﻿/*
* Slickflow 工作流引擎遵循LGPL协议，也可联系作者商业授权并获取技术支持；
* 除此之外的使用则视为不正当使用，请您务必避免由此带来的商业版权纠纷。
* 
The Slickflow project.
Copyright (C) 2014  .NET Workflow Engine Library

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, you can access the official
web page about lgpl: https://www.gnu.org/licenses/lgpl.html
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Dynamic;
using System.Reflection;
using System.Reflection.Emit;
using System.Text;
using IronPython.Hosting;
using Dapper;
using Slickflow.Data;
using Slickflow.Module.Localize;
using Slickflow.Engine.Common;
using Slickflow.Engine.Utility;
using Slickflow.Engine.Xpdl.Common;
using Slickflow.Engine.Xpdl.Entity;
using Slickflow.Engine.Delegate;

namespace Slickflow.Engine.Core.Pattern
{
    /// <summary>
    /// Action 执行器类
    /// </summary>
    internal class ActionExecutor
    {
        /// <summary>
        /// Action 的执行方法
        /// </summary>
        /// <param name="actionList">操作列表</param>
        /// <param name="delegateService">参数列表</param>
        internal static void ExecteActionList(IList<ActionEntity> actionList, 
            IDelegateService delegateService)
        {
            if (actionList != null && actionList.Count > 0)
            {
                foreach (var action in actionList)
                {
                    if (action.FireType != FireTypeEnum.None
                        && (action.ActionMethod != ActionMethodEnum.None))
                    {
                        Execute(action, delegateService);
                    }
                }
            }
        }

        /// <summary>
        /// 触发前执行外部操作的方法
        /// </summary>
        /// <param name="actionList">操作列表</param>
        /// <param name="delegateService">委托服务</param>
        internal static void ExecteActionListBefore(IList<ActionEntity> actionList,
            IDelegateService delegateService)
        {
            if (actionList != null && actionList.Count > 0)
            {
                var list = actionList.Where(a => a.FireType == FireTypeEnum.Before).ToList();
                if (list != null && list.Count > 0)
                {
                    ExecteActionList(list, delegateService);
                }
            }
        }

        /// <summary>
        /// 触发后执行外部操作的方法
        /// </summary>
        /// <param name="actionList">操作列表</param>
        /// <param name="delegateService">委托服务</param>
        internal static void ExecteActionListAfter(IList<ActionEntity> actionList,
            IDelegateService delegateService)
        {
            if (actionList != null && actionList.Count > 0)
            {
                var list = actionList.Where(a => a.FireType == FireTypeEnum.After).ToList();
                if (list != null && list.Count > 0)
                {
                    ExecteActionList(list, delegateService);
                }
            }
        }

        /// <summary>
        /// 执行外部服务实现类
        /// </summary>
        /// <param name="action">操作</param>
        /// <param name="delegateService">委托服务类</param>
        private static void Execute(ActionEntity action, IDelegateService delegateService)
        {
            if (action.ActionType == ActionTypeEnum.Event)
            {
                if (action.ActionMethod == ActionMethodEnum.LocalService)
                {
                    ExecuteLocalService(action, delegateService);
                }
                else if (action.ActionMethod == ActionMethodEnum.CSharpLibrary)
                {
                    ExecuteCSharpLibraryMethod(action, delegateService);
                }
                else if (action.ActionMethod == ActionMethodEnum.WebApi)
                {
                    ExecuteWebApiMethod(action, delegateService);
                }
                else if (action.ActionMethod == ActionMethodEnum.SQL)
                {
                    ExecuteSQLMethod(action, delegateService);
                }
                else if (action.ActionMethod == ActionMethodEnum.StoreProcedure)
                {
                    ExecuteStoreProcedureMethod(action, delegateService);
                }
                else if (action.ActionMethod == ActionMethodEnum.Python)
                {
                    ExecutePythonMethod(action, delegateService);
                }
                else
                {
                    throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.Execute.exception", action.ActionMethod.ToString()));
                }
            }
        }

        /// <summary>
        /// 执行外部方法
        /// </summary>
        /// <param name="action">Action实体</param>
        /// <param name="delegateService">委托服务</param>
        private static void ExecuteLocalService(ActionEntity action, IDelegateService delegateService)
        {
            try
            {
                //先获取具体实现类
                var instance = ReflectionHelper.GetSpecialInstance<IExternalService>(action.Expression);
                //再调用基类可执行方法
                var exterableInstance = instance as IExternable;
                exterableInstance.Executable(delegateService);
            }
            catch (System.Exception ex)
            {
                throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.ExecuteLocalService.exception", ex.Message));
            }
        }

        /// <summary>
        /// 执行外部方法
        /// </summary>
        /// <param name="action">Action实体</param>
        /// <param name="delegateService">委托服务</param>
        private static void ExecuteWebApiMethod(ActionEntity action, IDelegateService delegateService)
        {
            try
            {
                object result = null;
                if (action.SubMethod == SubMethodEnum.HttpGet)
                {
                    var jsonGetValue = delegateService.GetVariableThroughly(action.Arguments);
                    var url = string.Format("{0}/{1}", action.Expression, jsonGetValue);
                    var httpGetClient = HttpClientHelper.CreateHelper(url);
                    result = httpGetClient.Get();
                }
                else if (action.SubMethod == SubMethodEnum.HttpPost)
                {
                    string url = action.Expression;
                    var httpClientHelper = HttpClientHelper.CreateHelper(url);
                    var jsonValue = CompositeJsonValue(action.Arguments, delegateService);
                    var httpPostClient = HttpClientHelper.CreateHelper(url);
                    result = httpClientHelper.Post(jsonValue);
                }
                else if (action.SubMethod == SubMethodEnum.HttpPut)
                {
                    string url = action.Expression;
                    var httpClientHelper = HttpClientHelper.CreateHelper(url);
                    var jsonValue = CompositeJsonValue(action.Arguments, delegateService);
                    var httpPostClient = HttpClientHelper.CreateHelper(url);
                    result = httpClientHelper.Put(jsonValue);
                }
                else if (action.SubMethod == SubMethodEnum.HttpDelete)
                {
                    var jsonGetValue = delegateService.GetVariableThroughly(action.Arguments);
                    var url = string.Format("{0}/{1}", action.Expression, jsonGetValue);
                    var httpGetClient = HttpClientHelper.CreateHelper(url);
                    result = httpGetClient.Delete();
                }
            }
            catch (System.Exception ex)
            {
                throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.ExecuteWebApi.exception", ex.Message));
            }
        }

        /// <summary>
        /// 执行外部方法
        /// </summary>
        /// <param name="action">Action实体</param>
        /// <param name="delegateService">委托服务</param>
        private static void ExecuteSQLMethod(ActionEntity action, IDelegateService delegateService)
        {
            try
            {
                var parameters = CompositeSqlParametersValue(action.Arguments, delegateService);
                if (action.CodeInfo != null 
                    && !string.IsNullOrEmpty(action.CodeInfo.CodeText))
                {
                    //var sqlScript = action.Expression;
                    var sqlScript = action.CodeInfo.CodeText;        //modified by Besley in 12/26/2019, body is nodetext rather than attribute
                    var session = delegateService.GetSession();
                    var repository = new Repository();
                    repository.Execute(session.Connection, sqlScript, parameters, session.Transaction);
                }
                else
                {
                    throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.ExecuteSQLMethod.warn"));
                }
            }
            catch (System.Exception ex)
            {
                throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.ExecuteSQLMethod.exception", ex.Message));
            }
        }

        /// <summary>
        /// 执行外部方法
        /// </summary>
        /// <param name="action">Action实体</param>
        /// <param name="delegateService">委托服务</param>
        private static void ExecuteStoreProcedureMethod(ActionEntity action, IDelegateService delegateService)
        {
            try
            {
                var parameters = CompositeSqlParametersValue(action.Arguments, delegateService);
                var procedureName = action.Expression;
                var session = delegateService.GetSession();
                var repository = new Repository();
                repository.ExecuteProc(session.Connection, procedureName, parameters, session.Transaction);
            }
            catch (System.Exception ex)
            {
                throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.ExecuteStoreProcedureMethod.exception", ex.Message));
            }
        }

        /// <summary>
        /// 执行外部方法
        /// SetVariable:
        /// https://stackoverflow.com/questions/26426955/setting-and-getting-variables-in-net-hosted-ironpython-script/45734097
        /// </summary>
        /// <param name="action">Action实体</param>
        /// <param name="delegateService">委托服务</param>
        private static void ExecutePythonMethod(ActionEntity action, IDelegateService delegateService)
        {
            try
            {
                if (action.CodeInfo != null
                    && !string.IsNullOrEmpty(action.CodeInfo.CodeText))
                {
                    // var pythonScript = action.Expression;
                    var pythonScript = action.CodeInfo.CodeText;         //modified by Besley in 12/26/2019, body is nodetext rather than attribute
                    var engine = Python.CreateEngine();
                    var scope = engine.CreateScope();
                    var dictionary = CompositeKeyValue(action.Arguments, delegateService);
                    foreach (var item in dictionary)
                    {
                        scope.SetVariable(item.Key, item.Value);
                    }
                    var source = engine.CreateScriptSourceFromString(pythonScript);
                    source.Execute(scope);
                }
                else
                {
                    throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.ExecutePythonMethod.warn"));
                }
            }
            catch (System.Exception ex)
            {
                throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.ExecutePythonMethod.exception", ex.Message));
            }
        }

        /// <summary>
        /// 执行插件方法
        /// </summary>
        /// <param name="action">Action实体</param>
        /// <param name="delegateService">委托服务</param>
        private static void ExecuteCSharpLibraryMethod(ActionEntity action, IDelegateService delegateService)
        {
            try
            {
                //取出当前应用程序执行路径
                var methodInfo = action.MethodInfo;
                var assemblyFullName = methodInfo.AssemblyFullName;
                var methodName = methodInfo.MethodName;
                var executingPath = ConfigHelper.GetExecutingDirectory();
                var pluginAssemblyName = string.Format("{0}\\{1}\\{2}.dll", executingPath, "plugin", assemblyFullName);
                var pluginAssemblyTypes = Assembly.LoadFile(pluginAssemblyName).GetTypes();
                Type outerClass = pluginAssemblyTypes
                                        .Single(t => !t.IsInterface && t.FullName == methodInfo.TypeFullName);
                //object instance = Activator.CreateInstance(outerClass, parameters.ConstructorParameters);
                object instance = Activator.CreateInstance(outerClass);
                System.Reflection.MethodInfo mi = outerClass.GetMethod(methodName);

                object[] methodParams = null;
                if (!string.IsNullOrEmpty(action.Arguments.Trim()))
                {
                    methodParams = CompositeParameterValues(action.Arguments, delegateService);
                }
                var result = mi.Invoke(instance, methodParams);
            }
            catch(System.Exception ex)
            {
                throw new WorkflowException(LocalizeHelper.GetEngineMessage("actionexecutor.ExecuteCSharpLibraryMethod.exception", ex.Message));
            }
        }

        /// <summary>
        /// 构造最终对象的Json字符串
        /// </summary>
        /// <param name="arguments">参数列表</param>
        /// <param name="delegateService">委托服务</param>
        /// <returns>Json字符串</returns>
        private static string CompositeJsonValue(string arguments, IDelegateService delegateService)
        {
            var jsonValue = string.Empty;
            var arguValue = string.Empty;
            var arguList = arguments.Split(',');

            var strBuilder = new StringBuilder(256);
            foreach (var name in arguList)
            {
                if (strBuilder.ToString() != string.Empty) strBuilder.Append(",");

                arguValue = delegateService.GetVariableThroughly(name);
                arguValue = FormatJsonStringIfSimple(arguValue);
                strBuilder.Append(string.Format("{0}:{1}", name, arguValue));
            }

            if (strBuilder.ToString() != string.Empty)
            {
                jsonValue = string.Format("{{{0}}}", strBuilder.ToString());
            }
            return jsonValue;
        }

        /// <summary>
        /// 如果是简单字符串, 加双引号
        /// jack => "jack"
        /// </summary>
        /// <param name="jsonValue">字符串</param>
        /// <returns>变换格式后的字符串</returns>
        private static string FormatJsonStringIfSimple(string jsonValue)
        {
            jsonValue = jsonValue.TrimStart().TrimEnd();
            if ((jsonValue.StartsWith('{') && jsonValue.EndsWith('}'))
                || (jsonValue.StartsWith('"') && jsonValue.EndsWith('"')))
            {
                return jsonValue;
            }
            else
            {
                return string.Format("\"{0}\"", jsonValue);
            }
        }

        /// <summary>
        /// 构造最终对象的Json字符串
        /// </summary>
        /// <param name="arguments">参数列表</param>
        /// <param name="delegateService">委托服务</param>
        /// <returns>动态参数列表</returns>
        private static DynamicParameters CompositeSqlParametersValue(string arguments, IDelegateService delegateService)
        {
            DynamicParameters parameters = new DynamicParameters();

            var arguValue = string.Empty;
            var arguList = arguments.Split(',');
            foreach (var name in arguList)
            {
                arguValue = delegateService.GetVariableThroughly(name);
                parameters.Add(string.Format("@{0}",name), arguValue);
            }
            return parameters;
        }

        /// <summary>
        /// 构造最终对象的Json字符串
        /// </summary>
        /// <param name="arguments">参数列表</param>
        /// <param name="delegateService">委托服务</param>
        /// <returns>字典列表</returns>
        private static IDictionary<string, string> CompositeKeyValue(string arguments, IDelegateService delegateService)
        {
            var dictionary = new Dictionary<string, string>();
            var arguValue = string.Empty;
            var arguList = arguments.Split(',');
            foreach (var name in arguList)
            {
                arguValue = delegateService.GetVariableThroughly(name);
                dictionary.Add(name, arguValue);
            }
            return dictionary;
        }

        /// <summary>
        /// 构造可变数值列表
        /// </summary>
        /// <param name="arguments">参数列表</param>
        /// <param name="delegateService">委托服务</param>
        /// <returns>参数列表</returns>
        private static object[] CompositeParameterValues(string arguments, IDelegateService delegateService)
        {
            var arguList = arguments.Split(',');
            object[] valueArray = new object[arguList.Length];
            for (var i = 0; i < arguList.Length; i++)
            {
                valueArray[i] = delegateService.GetVariableThroughly(arguList[i]);
            }
            return valueArray;
        }
    }
}
