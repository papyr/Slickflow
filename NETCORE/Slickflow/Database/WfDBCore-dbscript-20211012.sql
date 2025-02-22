USE [WfDBCommunity]
GO
/****** Object:  StoredProcedure [dbo].[pr_com_QuerySQLPaged]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure

create PROCEDURE  [dbo].[pr_com_QuerySQLPaged]      
     @Query nvarchar(MAX), --SQL语句    
     @PageSize int, --每页大小   
     @CurrentPage  int ,  --当前页码   
     @Field nvarchar(40)='', --排序字段   
     @Order nvarchar(10) = 'asc ' --排序顺序   
AS    
    declare @PageCount int,
	        @TempSize int,    
			@TempNum int,  
			@strSQL varchar(max),
			@strField varchar(40),   
			@strFielddesc varchar(40),
			@Tempindex int 

    --0,1都做第一页处理
	if (@currentPage = 0)
		set @currentPage = 1

    set @TempNum = @CurrentPage * @PageSize    
	set @strField = ''
	set @strFielddesc = ''

	--计算总页数
	declare @strCountSQL nvarchar(MAX)
	set @strCountSQL = 'SELECT @total=COUNT(1) FROM (' + @Query + ')T'

	--总记录数
	DECLARE @rowsCount int
	DECLARE @params nvarchar(500)
	SET @params = '@total int OUTPUT'
	EXEC sp_executesql @strCountSQL, @params, @total=@rowsCount OUTPUT

	--根据总记录数，计算页数
	SET @PageCount = ceiling(convert(float, @rowsCount) / convert(float, @PageSize))

	--超过最后一页，显示尾页
    if(@CurrentPage>=@PageCount)    
        set @TempSize=@rowsCount-(@PageCount-1)*@PageSize    
    else  
        set @TempSize=@PageSize  

	SET @Tempindex=Charindex('projcode',@Query,0)
    if( @Tempindex>0 and @Tempindex<Charindex('from',@Query,0))
	begin
		if(@Field<>'' and @Field<>'projcode')
		begin
			set @strField = ',projcode ';
			set	@strFielddesc =',projcode desc ';
		end 
	end 

	--分页SQL
    if(@Order='desc')    
    begin    
      set @strSQL = '
            select *   
            from (   
                    select top '+CONVERT(varchar(10),@TempSize)+' *   
                    from (  
                            select top '+CONVERT(varchar(10),@TempNum)+' *   
                            from ('+@Query+') as t0   
                            order by '+@Field+' desc '+@strField+'  
                    ) as t1   
                    order by '+@Field+@strFielddesc+' 
            ) as t2   
            order by '+@Field+' desc' +@strField   
    end    
    else    
    begin    
      set @strSQL = '
            select *   
            from (  
                    select top '+CONVERT(varchar(10),@TempSize)+' *   
                    from (  
                            select top '+ CONVERT(varchar(10), @TempNum ) + ' *   
                            from ('+@Query+') as t0  
                            order by '+@Field+' asc '+@strField +'
                    ) as t1   
                    order by '+@Field+' desc  '+@strFielddesc+' 
            ) as t2   
            order by '+@Field +@strField  
    end  
    exec(@strSQL)
GO
/****** Object:  Table [dbo].[ManProductOrder]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ManProductOrder](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderCode] [varchar](30) NULL,
	[Status] [smallint] NULL,
	[ProductName] [nvarchar](100) NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TotalPrice] [decimal](18, 2) NULL,
	[CreatedTime] [datetime] NULL,
	[CustomerName] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Mobile] [varchar](30) NULL,
	[Remark] [nvarchar](1000) NULL,
	[LastUpdatedTime] [datetime] NULL,
 CONSTRAINT [PK_MADPRODUCTORDER] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ManProductOrder] ON
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (675, N'TB324384', 8, N'遥控灯D型', 5, CAST(1000.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(0x0000A72900F8491F AS DateTime), N'BBC', N'英国伦敦', N'739538', N'C店', CAST(0x0000A72901008DCD AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (676, N'TB377329', 3, N'遥控灯D型', 7, CAST(1000.00 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), CAST(0x0000A79000C4C367 AS DateTime), N'阿里巴巴', N'杭州西湖区', N'802382', N'B店', CAST(0x0000A79000CD1AA9 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (677, N'TB730548', 3, N'智能玩具C型', 6, CAST(1000.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), CAST(0x0000A79100A22D8A AS DateTime), N'汇丰银行', N'上海人民广场', N'338600', N'F店', CAST(0x0000A90201173470 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (678, N'TB574787', 3, N'智能玩具C型', 7, CAST(1000.00 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), CAST(0x0000A7B8009E3C10 AS DateTime), N'汇丰银行', N'上海人民广场', N'553578', N'C店', CAST(0x0000A7B8009E525E AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (679, N'TB100834', 4, N'童话玩具A型', 6, CAST(1000.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), CAST(0x0000A7D8013AFD08 AS DateTime), N'HACK 新闻', N'美国纽约', N'974724', N'A店', CAST(0x0000A7D8013B21C8 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (680, N'TB752624', 8, N'海盗船F型', 4, CAST(1000.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), CAST(0x0000A83F00B6AFBD AS DateTime), N'花旗银行', N'上海浦东新区', N'100628', N'F店', CAST(0x0000A83F00B7513E AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (681, N'TB517477', 3, N'童话玩具A型', 4, CAST(1000.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), CAST(0x0000A83F00E5C20C AS DateTime), N'中石油', N'北京燕山', N'120409', N'C店', CAST(0x0000A842010B62E7 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (682, N'TB601588', 4, N'遥控灯D型', 4, CAST(1000.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), CAST(0x0000A842010B8971 AS DateTime), N'花旗银行', N'上海浦东新区', N'428885', N'A店', CAST(0x0000A842010BA376 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (683, N'TB393078', 1, N'LED节能灯E型', 1, CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(0x0000A97E00B17993 AS DateTime), N'阿里巴巴', N'杭州西湖区', N'500282', N'B店', NULL)
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (684, N'TB937073', 3, N'智能玩具C型', 1, CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(0x0000AA0801600730 AS DateTime), N'中石油', N'北京燕山', N'376673', N'F店', CAST(0x0000AA0801604495 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (685, N'TB359987', 3, N'海盗船F型', 9, CAST(1000.00 AS Decimal(18, 2)), CAST(9000.00 AS Decimal(18, 2)), CAST(0x0000AAF600EF411F AS DateTime), N'中国邮政', N'北京复兴门', N'568964', N'F店', CAST(0x0000AAF600EF4E8F AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (686, N'TB588656', 8, N'智能玩具C型', 3, CAST(1000.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), CAST(0x0000ABBC00ACBC53 AS DateTime), N'花旗银行', N'上海浦东新区', N'666540', N'B店', CAST(0x0000ABBC00B3A68E AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (687, N'TB720748', 8, N'遥控飞机B型', 4, CAST(1000.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), CAST(0x0000AC2300F206A3 AS DateTime), N'花旗银行', N'上海浦东新区', N'140223', N'C店', CAST(0x0000AC2300FC0757 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (688, N'TB332639', 3, N'童话玩具A型', 1, CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), CAST(0x0000AC7E00CF9C4A AS DateTime), N'阿里巴巴', N'杭州西湖区', N'175105', N'B店', CAST(0x0000ACB000A03E28 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (689, N'TB741954', 8, N'童话玩具A型', 4, CAST(1000.00 AS Decimal(18, 2)), CAST(4000.00 AS Decimal(18, 2)), CAST(0x0000ACB000A1DABF AS DateTime), N'中石油', N'北京燕山', N'164151', N'B店', CAST(0x0000ACB000A24580 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (690, N'TB332806', 3, N'童话玩具A型', 2, CAST(1000.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), CAST(0x0000AD8F01004388 AS DateTime), N'青田麦家', N'福建岭南', N'909976', N'C店', CAST(0x0000AD8F0100596E AS DateTime))
SET IDENTITY_INSERT [dbo].[ManProductOrder] OFF
/****** Object:  Table [dbo].[HrsLeaveOpinion]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HrsLeaveOpinion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ActivityID] [varchar](50) NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[Remark] [nvarchar](1000) NULL,
	[ChangedTime] [datetime] NOT NULL,
	[ChangedUserID] [int] NOT NULL,
	[ChangedUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_HRSLEAVEOPINION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[HrsLeaveOpinion] ON
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (1, N'34', N'00000000-0000-0000-0000-000000000000', N'流程发起', N'申请人:6-路天明', CAST(0x0000A7BC013216A4 AS DateTime), 6, N'路天明')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (2, N'34', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', N'张恒丰(ID:5) agree', CAST(0x0000A7BC01326448 AS DateTime), 5, N'张恒丰')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (3, N'35', N'00000000-0000-0000-0000-000000000000', N'流程发起', N'申请人:6-路天明', CAST(0x0000A7D8013B4E1C AS DateTime), 6, N'路天明')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (4, N'35', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', N'张恒丰(ID:5) tongyi', CAST(0x0000A7D8013B7631 AS DateTime), 5, N'张恒丰')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (5, N'36', N'00000000-0000-0000-0000-000000000000', N'流程发起', N'申请人:6-路天明', CAST(0x0000A7EE00B0927D AS DateTime), 6, N'路天明')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (6, N'37', N'00000000-0000-0000-0000-000000000000', N'流程发起', N'申请人:6-路天明', CAST(0x0000A83F00E74309 AS DateTime), 6, N'路天明')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (7, N'37', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', N'张恒丰(ID:5) 同意', CAST(0x0000A83F00E772A8 AS DateTime), 5, N'张恒丰')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (8, N'37', N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', N'人事经理审批', N'李颖(ID:4) ', CAST(0x0000A83F00E7C07C AS DateTime), 4, N'李颖')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (9, N'38', N'00000000-0000-0000-0000-000000000000', N'流程发起', N'申请人:6-路天明', CAST(0x0000A842010CEE96 AS DateTime), 6, N'路天明')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (10, N'39', N'00000000-0000-0000-0000-000000000000', N'流程发起', N'申请人:6-LuTianMing', CAST(0x0000AC2300FEBD4A AS DateTime), 6, N'LuTianMing')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (11, N'39', N'c437c27a-8351-4805-fd4f-4e270084320a', N'部门经理审批', N'ZhangFeng(ID:5) 同意', CAST(0x0000AC2300FF6C20 AS DateTime), 5, N'ZhangFeng')
INSERT [dbo].[HrsLeaveOpinion] ([ID], [AppInstanceID], [ActivityID], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (12, N'39', N'da9f744b-3f97-40c9-c4f8-67d5a60a2485', N'人事经理审批', N'LiYin(ID:4) ', CAST(0x0000AC2300FF8A21 AS DateTime), 4, N'LiYin')
SET IDENTITY_INSERT [dbo].[HrsLeaveOpinion] OFF
/****** Object:  Table [dbo].[HrsLeave]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HrsLeave](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LeaveType] [nvarchar](50) NOT NULL,
	[Days] [decimal](18, 1) NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[CurrentActivityText] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[CreatedUserID] [nvarchar](50) NOT NULL,
	[CreatedUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [date] NOT NULL,
	[Remark] [nvarchar](1000) NULL,
	[Opinions] [nvarchar](2000) NULL,
 CONSTRAINT [PK_HRLEAVE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'Days'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'FromDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'ToDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CurrentActivityText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedUserID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedUserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedDateTime'
GO
SET IDENTITY_INSERT [dbo].[HrsLeave] ON
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDateTime], [Remark], [Opinions]) VALUES (80, N'事假', CAST(4.0 AS Decimal(18, 1)), CAST(0x5B420B00 AS Date), CAST(0x5F420B00 AS Date), NULL, 0, N'6', N'Lucy', CAST(0x64420B00 AS Date), N'dsf', N'safewfewasf')
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDateTime], [Remark], [Opinions]) VALUES (81, N'事假', CAST(4.0 AS Decimal(18, 1)), CAST(0x5A420B00 AS Date), CAST(0x5E420B00 AS Date), NULL, 0, N'6', N'Lucy', CAST(0x64420B00 AS Date), N'wfe', N'eqwrewqrfsdaegfeasfasfds')
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDateTime], [Remark], [Opinions]) VALUES (82, N'事假', CAST(6.0 AS Decimal(18, 1)), CAST(0x5A420B00 AS Date), CAST(0x60420B00 AS Date), NULL, 0, N'6', N'Lucy', CAST(0x64420B00 AS Date), N'asdf', N'wrdsadfsftrhgfr')
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDateTime], [Remark], [Opinions]) VALUES (83, N'事假', CAST(3.0 AS Decimal(18, 1)), CAST(0x5B420B00 AS Date), CAST(0x5E420B00 AS Date), NULL, 0, N'6', N'Lucy', CAST(0x74420B00 AS Date), N'u', N'ydfyi')
SET IDENTITY_INSERT [dbo].[HrsLeave] OFF
/****** Object:  UserDefinedFunction [dbo].[fn_com_SplitString]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fn_com_SplitString] ( @stringToSplit nvarchar(4000) )
RETURNS
 @returnList TABLE ([ID] int)
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(',', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(',', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)
  

  INSERT INTO @returnList 
  SELECT CONVERT(INT,  @name)

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[pr_eav_EntityAttrValuePivotGet]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_eav_EntityAttrValuePivotGet]
	@queryType		int = 0,
	@entityDefID	int = 0,
    @entityInfoID	int = 0		--表单实例ID 
AS


BEGIN

	SET NOCOUNT ON
	
	--判断有没有传入QueryTypeID
	IF (@queryType = 0 and @entityDefID = 0 and @entityInfoID = 0)
	BEGIN
		DECLARE @error int, @message varchar(4000)
		SELECT @error = ERROR_NUMBER()
			, @message = ERROR_MESSAGE();
		RAISERROR ('无效的输入参数，查询失败: %d: %s', 16, 1, @error, @message)
	END

	DECLARE @sql nvarchar(1000)
	DECLARE @countSql nvarchar(1000)
	DECLARE @query nvarchar(4000)
	DECLARE @rowsCount	int

	--组建查询用到的SQL语句
	--1. 基本语句
	IF (@queryType = 1)
	BEGIN
		--按照表单查所有实例数据
		SET @sql = 'SELECT ID FROM EavEntityInfo WHERE EntityDefID=' + CONVERT(varchar, @entityDefID)
		SET @countSql = 'SELECT @total=COUNT(1) FROM EavEntityInfo WHERE EntityDefID=' + CONVERT(varchar, @entityDefID)
	END 
	ELSE IF (@queryType = 2)
	BEGIN
		--查表单的其中一条实例数据
		SET @sql = 'SELECT ID FROM EavEntityInfo WHERE ID=' + CONVERT(varchar, @entityInfoID)
		SET @countSql = 'SELECT @total=COUNT(1) FROM EavEntityInfo WHERE ID=' + CONVERT(varchar, @entityInfoID)
	END
    
    --3. 获取总记录数，如果总记录数为0，则返回
	DECLARE @params nvarchar(500)
	SET @params = '@total int OUTPUT'
	EXEC sp_executesql @countSql, @params, @total=@rowsCount OUTPUT

	IF (@rowsCount = 0)
	BEGIN
		--选取空记录返回，用于Dapper构造动态类型对象
		SELECT
			EEI.ID,
			EEI.EntityDefID,
			EED.EntityName,
			EEI.CreatedUserName,
			EEI.CreatedUserID,
			EEI.CreatedDatetime
		FROM EavEntityInfo EEI
		INNER JOIN EavEntityDef EED
			ON EED.ID = EEI.EntityDefID
		WHERE EEI.ID = -1000

		RETURN
	END
	
	--4. 获取实体ID表
	DECLARE @tblEntityInfo TABLE(ID INT)

	INSERT INTO @tblEntityInfo
	EXEC sp_executesql @sql;
		
	--5. 查询是否有动态扩展属性，如果没有，返回主表记录
	DECLARE @tblDynamicAttr	TABLE(
		EntityInfoID		int,
		TblName		nvarchar(50),
		AttrID		int,
		AttrCode	varchar(30),
		AttrName	nvarchar(50),
		AttrDataType	int,
		OrderID			int,
		Value		nvarchar(4000)
	)
	
	--将动态属性写入临时表
	INSERT INTO @tblDynamicAttr
	SELECT * FROM(
		SELECT
			EEAI.EntityInfoID
			,'EavEntityAttrInt' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAI.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrInt EEAI
			ON EEA.ID = EEAI.AttrID
			WHERE EEA.StorageType = 1
		UNION ALL
		SELECT
			EEAN.EntityInfoID
			,'EavEntityAttrDecimal' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAN.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrDecimal EEAN
			ON EEA.ID = EEAN.AttrID
			WHERE EEA.StorageType = 1
		UNION ALL
		SELECT
			EEAV.EntityInfoID
			,'EavEntityAttrVarchar' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAV.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrVarchar EEAV
			ON EEA.ID = EEAV.AttrID
			WHERE EEA.StorageType = 1
		UNION ALL
		SELECT
			EEAD.EntityInfoID
			,'EavEntityAttrDatetime' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAD.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrDatetime EEAD
			ON EEA.ID = EEAD.AttrID
			WHERE EEA.StorageType = 1
		UNION ALL
		SELECT
			EEAT.EntityInfoID
			,'EavEntityAttrText' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAT.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrText EEAT
			ON EEA.ID = EEAT.AttrID
			WHERE EEA.StorageType = 1
	) T
	WHERE T.EntityInfoID IN (SELECT ID FROM @tblEntityInfo) 
	ORDER BY 
		T.EntityInfoID, 
		T.OrderID

	DECLARE @dynamicRowsCount int
	SELECT @dynamicRowsCount = COUNT(1) FROM @tblDynamicAttr
	
	print 'dynamic rows count:' 
	print @dynamicRowsCount
	
	--如果没有动态扩展属性，则返回主表记录
	IF (@dynamicRowsCount = 0)
	BEGIN
		SELECT 
			EEI.ID, 
			EED.EntityName
		FROM EavEntityInfo EEI
		INNER JOIN EavEntityDef EED
			ON EED.ID = EEI.EntityDefID
		WHERE EEI.ID IN (
			SELECT ID FROM @tblEntityInfo) 

		RETURN
	END

	--6. 返回动态字段的列表
	--表单自定义字段表的临时表
	--用于先将表单字段填充到表里
	CREATE TABLE #myCustomEntityAttrValueTable
	(
		[ID] [int] NULL,
		[EntityDefID] [int] NULL,
		[EntityName] [nvarchar] (100) NULL,
		[EntityCode] [varchar](100) NULL,
		[EntityTitle] [nvarchar](100) NULL,
		[AttrName] [nvarchar] (100) NULL,
		[AttrCode] [varchar](100) NULL,
		[OrderID]	[int] NULL,
		[Value] [nvarchar](max) NULL
	)

	--插入行记录到临时表
	INSERT INTO #myCustomEntityAttrValueTable
	SELECT 
		EEI.ID, 
		EEI.EntityDefID,
		EED.EntityName,
		EED.EntityCode,
		EED.EntityTitle,
		T.AttrName,
		T.AttrCode,
		T.OrderID,
		T.Value
	FROM EavEntityInfo EEI
	INNER JOIN EavEntityDef EED
		ON EED.ID = EEI.EntityDefID
	INNER JOIN EavEntityAttribute EEA
		ON EEA.EntityDefID = EED.ID
	INNER JOIN @tblEntityInfo T1
		ON T1.ID = EEI.ID
	LEFT JOIN @tblDynamicAttr T
		ON EEI.ID = T.EntityInfoID
	ORDER BY 
		T.EntityInfoID,
		T.OrderID
	
	
	--行列PIVOT过程
	DECLARE @QuestionList nvarchar(max);
	SELECT @QuestionList = STUFF(
		(
			SELECT 
				', ' + quotename(AttrCode) 
			FROM #myCustomEntityAttrValueTable 
			GROUP BY 
				AttrCode, 
				OrderID
			ORDER BY 
				OrderID
			FOR XML PATH('')
		), 
		1, 
		2, 
		''
	);
	
	--行列PIVOT过程SQL语句
	DECLARE @qry nvarchar(max);
	SET @qry = 'SELECT ID, EntityDefID, EntityName, EntityCode, EntityTitle, ' 
		+ @QuestionList 
		+ ' FROM (
					SELECT ID, EntityDefID, EntityName, EntityCode, EntityTitle, AttrCode, Value 
					FROM #myCustomEntityAttrValueTable 
			) UP
		PIVOT (
			MAX(Value) 
			FOR AttrCode IN (' + @QuestionList + ')
		) pvt
		ORDER BY 
			ID DESC;';

	--执行输出
	print @qry
	EXEC sp_executesql @qry;


	--7. 销毁临时表
	DROP TABLE #myCustomEntityAttrValueTable 


END
GO
/****** Object:  Table [dbo].[BizAppFlow]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BizAppFlow](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[AppInstanceCode] [varchar](50) NULL,
	[Status] [varchar](10) NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[Remark] [nvarchar](1000) NULL,
	[ChangedTime] [datetime] NOT NULL,
	[ChangedUserID] [varchar](50) NOT NULL,
	[ChangedUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_SALWALLWAORDERFLOW] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[BizAppFlow] ON
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (113, N'流程发起', N'3', NULL, NULL, N'流程发起', N'mssqlserver申请人:6-普通员工-小明', CAST(0x0000A4F500DC22C7 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (114, N'生产订单', N'624', N'TB300427', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010C6DBA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (115, N'生产订单', N'625', N'TB906432', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010C92A0 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (116, N'生产订单', N'626', N'TB338322', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010CA251 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (117, N'生产订单', N'627', N'TB612344', NULL, N'派单', N'完成派单', CAST(0x0000A4F5014DA236 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (118, N'生产订单', N'628', N'TB683061', NULL, N'派单', N'完成派单', CAST(0x0000A4F5014DAB96 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (119, N'生产订单', N'628', N'TB683061', NULL, N'打样', N'完成打样', CAST(0x0000A4F5014DC627 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (120, N'生产订单', N'627', N'TB612344', NULL, N'打样', N'完成打样', CAST(0x0000A4F5014DCFC6 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (121, N'生产订单', N'627', N'TB612344', NULL, N'生产', N'完成生产', CAST(0x0000A4F700D56961 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (122, N'生产订单', N'631', N'TB490683', NULL, N'派单', N'完成派单', CAST(0x0000A4F900FBE434 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (123, N'生产订单', N'630', N'TB351094', NULL, N'派单', N'完成派单', CAST(0x0000A4FC016B0F5F AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (124, N'生产订单', N'632', N'TB366615', NULL, N'派单', N'完成派单', CAST(0x0000A4FF00F6BDB6 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (125, N'生产订单', N'634', N'TB969829', NULL, N'派单', N'完成派单', CAST(0x0000A4FF00F6C6CD AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (126, N'生产订单', N'633', N'TB751853', NULL, N'派单', N'完成派单', CAST(0x0000A4FF0181C823 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (127, N'生产订单', N'639', N'TB792242', NULL, N'派单', N'完成派单', CAST(0x0000A5000117A5C8 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (128, N'生产订单', N'639', N'TB792242', NULL, N'打样', N'完成打样', CAST(0x0000A501008BED22 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (129, N'生产订单', N'640', N'TB429545', NULL, N'派单', N'完成派单', CAST(0x0000A50A010D8B79 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (130, N'生产订单', N'641', N'TB817384', NULL, N'派单', N'完成派单', CAST(0x0000A50B00B381FA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (131, N'生产订单', N'644', N'TB348804', NULL, N'派单', N'完成派单', CAST(0x0000A50B00DCCBEB AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (132, N'生产订单', N'643', N'TB351670', NULL, N'派单', N'完成派单', CAST(0x0000A50B00DCD1CD AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (133, N'生产订单', N'646', N'TB992099', NULL, N'派单', N'完成派单', CAST(0x0000A50B00E44F16 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (134, N'生产订单', N'648', N'TB588606', NULL, N'派单', N'完成派单', CAST(0x0000A50B00EAF847 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (135, N'生产订单', N'642', N'TB434232', NULL, N'派单', N'完成派单', CAST(0x0000A50C0120B5EA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (136, N'生产订单', N'647', N'TB285386', NULL, N'派单', N'完成派单', CAST(0x0000A50F00A2DEAE AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (137, N'生产订单', N'652', N'TB991726', NULL, N'派单', N'完成派单', CAST(0x0000A51001628464 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (138, N'生产订单', N'652', N'TB991726', NULL, N'打样', N'完成打样', CAST(0x0000A5100162D19D AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (139, N'生产订单', N'652', N'TB991726', NULL, N'生产', N'完成生产', CAST(0x0000A510016319E3 AS DateTime), N'10', N'跟单员-李杰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (140, N'生产订单', N'651', N'TB728743', NULL, N'派单', N'完成派单', CAST(0x0000A513010AF607 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (141, N'生产订单', N'650', N'TB328175', NULL, N'派单', N'完成派单', CAST(0x0000A513010AFA75 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (142, N'流程发起', N'4', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52B012C1E90 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (143, N'流程发起', N'5', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52C0091FF62 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (144, N'流程发起', N'6', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52C010A2086 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (145, N'请假流程', N'6', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A52C01153273 AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (146, N'生产订单', N'659', N'TB710707', NULL, N'派单', N'完成派单', CAST(0x0000A578013DAC71 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (147, N'生产订单', N'658', N'TB575859', NULL, N'派单', N'完成派单', CAST(0x0000A57801501892 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (148, N'生产订单', N'659', N'TB710707', NULL, N'打样', N'完成打样', CAST(0x0000A57801503093 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (149, N'生产订单', N'657', N'TB358232', NULL, N'派单', N'完成派单', CAST(0x0000A5780167A1AD AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (150, N'生产订单', N'656', N'TB779780', NULL, N'派单', N'完成派单', CAST(0x0000A57A01211907 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (151, N'生产订单', N'655', N'TB322602', NULL, N'派单', N'完成派单', CAST(0x0000A57C014BF2A2 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (152, N'生产订单', N'654', N'TB271916', NULL, N'派单', N'完成派单', CAST(0x0000A57C014D273A AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (153, N'生产订单', N'654', N'TB271916', NULL, N'打样', N'完成打样', CAST(0x0000A57C014D8A62 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (154, N'生产订单', N'653', N'TB559248', NULL, N'派单', N'完成派单', CAST(0x0000A57D012BCA76 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (155, N'生产订单', N'649', N'TB771229', NULL, N'派单', N'完成派单', CAST(0x0000A57D014D0D3C AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (158, N'生产订单', N'645', N'TB642095', NULL, N'派单', N'完成派单', CAST(0x0000A57D016233C7 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (159, N'生产订单', N'660', N'TB967961', NULL, N'派单', N'完成派单', CAST(0x0000A57D0162ECB4 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (160, N'生产订单', N'661', N'TB751700', NULL, N'派单', N'完成派单', CAST(0x0000A57D01648298 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (161, N'生产订单', N'661', N'TB751700', NULL, N'打样', N'完成打样', CAST(0x0000A57D01649AEE AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (162, N'生产订单', N'661', N'TB751700', NULL, N'生产', N'完成生产', CAST(0x0000A57D0164B2E1 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (163, N'生产订单', N'661', N'TB751700', NULL, N'质检', N'完成质检', CAST(0x0000A57D0164C7F0 AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (164, N'生产订单', N'661', N'TB751700', NULL, N'称重', N'完成称重', CAST(0x0000A57D01657E79 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (165, N'生产订单', N'661', N'TB751700', NULL, N'发货', N'完成发货', CAST(0x0000A57D016593FC AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (166, N'生产订单', N'652', N'TB991726', NULL, N'派单', N'完成派单', CAST(0x0000A57E014A4DF8 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (167, N'生产订单', N'662', N'TB647767', NULL, N'派单', N'完成派单', CAST(0x0000A57E0169A99B AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (168, N'生产订单', N'638', N'TB561443', NULL, N'派单', N'完成派单', CAST(0x0000A57F013BE354 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (169, N'生产订单', N'663', N'TB809544', NULL, N'派单', N'完成派单', CAST(0x0000A57F013C7377 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (170, N'生产订单', N'664', N'TB914891', NULL, N'派单', N'完成派单', CAST(0x0000A57F013CE48D AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (171, N'生产订单', N'665', N'TB929075', NULL, N'派单', N'完成派单', CAST(0x0000A57F014515AA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (172, N'生产订单', N'666', N'TB225725', NULL, N'派单', N'完成派单', CAST(0x0000A57F0146F53B AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (173, N'生产订单', N'667', N'TB164370', NULL, N'派单', N'完成派单', CAST(0x0000A57F014779F2 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (174, N'生产订单', N'667', N'TB164370', NULL, N'打样', N'完成打样', CAST(0x0000A57F0147D7EC AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (175, N'生产订单', N'667', N'TB164370', NULL, N'生产', N'完成生产', CAST(0x0000A57F0147EF54 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (176, N'生产订单', N'667', N'TB164370', NULL, N'质检', N'完成质检', CAST(0x0000A57F0148008F AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (177, N'生产订单', N'667', N'TB164370', NULL, N'称重', N'完成称重', CAST(0x0000A57F01481487 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (178, N'生产订单', N'667', N'TB164370', NULL, N'发货', N'完成发货', CAST(0x0000A57F01483D30 AS DateTime), N'16', N'包装员-小威')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (179, N'流程发起', N'7', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5B700B21B49 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (180, N'请假流程', N'7', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A5B700B252AE AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (181, N'请假流程', N'7', NULL, NULL, N'总经理审批', N'总经理-陈(ID:1) 同意', CAST(0x0000A5B700B27226 AS DateTime), N'1', N'总经理-陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (182, N'请假流程', N'7', NULL, NULL, N'人事经理审批', N'人事经理-李小姐(ID:4) ', CAST(0x0000A5B700B28A14 AS DateTime), N'4', N'人事经理-李小姐')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (183, N'流程发起', N'8', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5B700B38A15 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (184, N'请假流程', N'8', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A5B700B3AAF1 AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (185, N'生产订单', N'669', N'TB747473', NULL, N'派单', N'完成派单', CAST(0x0000A5B700B3E831 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (186, N'生产订单', N'669', N'TB747473', NULL, N'打样', N'完成打样', CAST(0x0000A5B700B3FCE9 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (187, N'生产订单', N'670', N'TB630627', NULL, N'派单', N'完成派单', CAST(0x0000A5B700B44E62 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (188, N'生产订单', N'670', N'TB630627', NULL, N'打样', N'完成打样', CAST(0x0000A5B700B46695 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (189, N'生产订单', N'670', N'TB630627', NULL, N'生产', N'完成生产', CAST(0x0000A5B700B47ECE AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (190, N'生产订单', N'670', N'TB630627', NULL, N'质检', N'完成质检', CAST(0x0000A5B700B493A5 AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (191, N'生产订单', N'670', N'TB630627', NULL, N'称重', N'完成称重', CAST(0x0000A5B700B4A808 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (192, N'生产订单', N'670', N'TB630627', NULL, N'发货', N'完成发货', CAST(0x0000A5B700B4C4D8 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (193, N'生产订单', N'671', N'TB165916', NULL, N'派单', N'完成派单', CAST(0x0000A5C5009C0E1E AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (194, N'流程发起', N'9', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500A0D72F AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (195, N'流程发起', N'10', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500B43CBB AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (196, N'流程发起', N'11', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500FE9389 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (197, N'生产订单', N'673', N'TB508950', NULL, N'派单', N'完成派单', CAST(0x0000A61300EE9CA7 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (198, N'生产订单', N'673', N'TB508950', NULL, N'打样', N'完成打样', CAST(0x0000A61300EEB976 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (199, N'生产订单', N'673', N'TB508950', NULL, N'生产', N'完成生产', CAST(0x0000A61300EED70C AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (200, N'生产订单', N'674', N'TB760538', NULL, N'派单', N'完成派单', CAST(0x0000A6320100EBD7 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (201, N'生产订单', N'674', N'TB760538', NULL, N'生产', N'完成生产', CAST(0x0000A6320112805C AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (202, N'生产订单', N'672', N'TB247595', NULL, N'派单', N'完成派单', CAST(0x0000A67D015B8A25 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (203, N'生产订单', N'668', N'TB885696', NULL, N'派单', N'完成派单', CAST(0x0000A72900F7E12C AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (204, N'生产订单', N'675', N'TB324384', NULL, N'派单', N'完成派单', CAST(0x0000A72900F8541C AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (205, N'生产订单', N'675', N'TB324384', NULL, N'打样', N'完成打样', CAST(0x0000A72900FEA7FD AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (206, N'生产订单', N'675', N'TB324384', NULL, N'生产', N'完成生产', CAST(0x0000A729010052AD AS DateTime), N'9', N'张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (207, N'生产订单', N'675', N'TB324384', NULL, N'质检', N'完成质检', CAST(0x0000A72901006C05 AS DateTime), N'13', N'杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (208, N'生产订单', N'675', N'TB324384', NULL, N'称重', N'完成称重', CAST(0x0000A72901007EE5 AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (209, N'生产订单', N'675', N'TB324384', NULL, N'发货', N'完成发货', CAST(0x0000A72901008DCD AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (210, N'流程发起', N'12', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A7290103EC77 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (211, N'请假流程', N'12', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) 同意', CAST(0x0000A72901040C66 AS DateTime), N'5', N'张恒丰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (212, N'请假流程', N'12', NULL, NULL, N'人事经理审批', N'李颖(ID:4) ', CAST(0x0000A72901043923 AS DateTime), N'4', N'李颖')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (213, N'流程发起', N'13', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A73600E34BD1 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (214, N'请假流程', N'13', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) AGREE', CAST(0x0000A73600E3664D AS DateTime), N'5', N'张恒丰')
GO
print 'Processed 100 total records'
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (215, N'请假流程', N'13', NULL, NULL, N'人事经理审批', N'李颖(ID:4) ', CAST(0x0000A73600E378AA AS DateTime), N'4', N'李颖')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (216, N'生产订单', N'676', N'TB377329', NULL, N'派单', N'完成派单', CAST(0x0000A79000CD1AA5 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (217, N'流程发起', N'32', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A7B8009703E0 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (218, N'请假流程', N'32', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) 同意', CAST(0x0000A7B80097B401 AS DateTime), N'5', N'张恒丰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (219, N'流程发起', N'33', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A7B8009BF515 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (220, N'生产订单', N'678', N'TB574787', NULL, N'派单', N'完成派单', CAST(0x0000A7B8009E525B AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (221, N'生产订单', N'679', N'TB100834', NULL, N'派单', N'完成派单', CAST(0x0000A7D8013B0D59 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (222, N'生产订单', N'679', N'TB100834', NULL, N'打样', N'完成打样', CAST(0x0000A7D8013B21C8 AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (223, N'生产订单', N'680', N'TB752624', NULL, N'派单', N'完成派单', CAST(0x0000A83F00B6F0E8 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (224, N'生产订单', N'680', N'TB752624', NULL, N'打样', N'完成打样', CAST(0x0000A83F00B706F3 AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (225, N'生产订单', N'680', N'TB752624', NULL, N'生产', N'完成生产', CAST(0x0000A83F00B715C3 AS DateTime), N'9', N'张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (226, N'生产订单', N'680', N'TB752624', NULL, N'质检', N'完成质检', CAST(0x0000A83F00B72520 AS DateTime), N'13', N'杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (227, N'生产订单', N'680', N'TB752624', NULL, N'发货', N'完成发货', CAST(0x0000A83F00B73839 AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (228, N'生产订单', N'680', N'TB752624', NULL, N'发货', N'完成发货', CAST(0x0000A83F00B7513D AS DateTime), N'16', N'小威')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (229, N'生产订单', N'681', N'TB517477', NULL, N'派单', N'完成派单', CAST(0x0000A83F00E5D4E7 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (230, N'生产订单', N'681', N'TB265497', NULL, N'派单', N'完成派单', CAST(0x0000A842010B62E3 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (231, N'生产订单', N'682', N'TB601588', NULL, N'派单', N'完成派单', CAST(0x0000A842010B92E7 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (232, N'生产订单', N'682', N'TB601588', NULL, N'打样', N'完成打样', CAST(0x0000A842010BA375 AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (233, N'生产订单', N'677', N'TB730548', NULL, N'派单', N'完成派单', CAST(0x0000A9020117346D AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (234, N'生产订单', N'684', N'TB937073', NULL, N'派单', N'完成派单', CAST(0x0000AA0801604495 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (235, N'生产订单', N'685', N'TB359987', NULL, N'派单', N'完成派单', CAST(0x0000AAF600EF4E8C AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (236, N'生产订单', N'686', N'TB588656', NULL, N'派单', N'完成派单', CAST(0x0000ABBC00B3407D AS DateTime), N'7', N'Gates')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (237, N'生产订单', N'686', N'TB588656', NULL, N'打样', N'完成打样', CAST(0x0000ABBC00B35BCA AS DateTime), N'11', N'FeiYu')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (238, N'生产订单', N'686', N'TB588656', NULL, N'生产', N'完成生产', CAST(0x0000ABBC00B373CA AS DateTime), N'9', N'ZhangMing')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (239, N'生产订单', N'686', N'TB588656', NULL, N'质检', N'完成质检', CAST(0x0000ABBC00B38910 AS DateTime), N'13', N'Jimi')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (240, N'生产订单', N'686', N'TB588656', NULL, N'称重', N'完成称重', CAST(0x0000ABBC00B39DDC AS DateTime), N'15', N'DaHan')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (241, N'生产订单', N'686', N'TB588656', NULL, N'发货', N'完成发货', CAST(0x0000ABBC00B3A68D AS DateTime), N'15', N'DaHan')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (242, N'生产订单', N'687', N'TB720748', NULL, N'派单', N'完成派单', CAST(0x0000AC2300FA38B0 AS DateTime), N'7', N'Gates')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (243, N'生产订单', N'687', N'TB720748', NULL, N'打样', N'完成打样', CAST(0x0000AC2300FBAD6B AS DateTime), N'11', N'FeiYu')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (244, N'生产订单', N'687', N'TB720748', NULL, N'生产', N'完成生产', CAST(0x0000AC2300FBC556 AS DateTime), N'9', N'ZhangMing')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (245, N'生产订单', N'687', N'TB720748', NULL, N'质检', N'完成质检', CAST(0x0000AC2300FBE00F AS DateTime), N'13', N'Jimi')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (246, N'生产订单', N'687', N'TB720748', NULL, N'发货', N'完成发货', CAST(0x0000AC2300FBF5BF AS DateTime), N'15', N'DaHan')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (247, N'生产订单', N'687', N'TB720748', NULL, N'发货', N'完成发货', CAST(0x0000AC2300FC0757 AS DateTime), N'15', N'DaHan')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (248, N'生产订单', N'688', N'TB332639', NULL, N'派单', N'完成派单', CAST(0x0000ACB000A03E27 AS DateTime), N'7', N'Gates')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (249, N'生产订单', N'689', N'TB741954', NULL, N'派单', N'完成派单', CAST(0x0000ACB000A1EC13 AS DateTime), N'7', N'Gates')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (250, N'生产订单', N'689', N'TB741954', NULL, N'打样', N'完成打样', CAST(0x0000ACB000A2023D AS DateTime), N'11', N'FeiYu')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (251, N'生产订单', N'689', N'TB741954', NULL, N'生产', N'完成生产', CAST(0x0000ACB000A21455 AS DateTime), N'9', N'ZhangMing')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (252, N'生产订单', N'689', N'TB741954', NULL, N'质检', N'完成质检', CAST(0x0000ACB000A224F6 AS DateTime), N'13', N'Jimi')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (253, N'生产订单', N'689', N'TB741954', NULL, N'称重', N'完成称重', CAST(0x0000ACB000A236B8 AS DateTime), N'15', N'DaHan')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (254, N'生产订单', N'689', N'TB741954', NULL, N'发货', N'完成发货', CAST(0x0000ACB000A24580 AS DateTime), N'15', N'DaHan')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (255, N'生产订单', N'690', N'TB332806', NULL, N'派单', N'完成派单', CAST(0x0000AD8F01005966 AS DateTime), N'7', N'Peter')
SET IDENTITY_INSERT [dbo].[BizAppFlow] OFF
/****** Object:  Table [dbo].[WhJobSchedule]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WhJobSchedule](
	[ID] [int] NOT NULL,
	[ScheduleType] [tinyint] NOT NULL,
	[ScheduleGUID] [varchar](100) NULL,
	[ScheduleName] [varchar](100) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Status] [smallint] NOT NULL,
	[CronExpression] [varchar](100) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_WFJOBSCHEDULE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WhJobSchedule', @level2type=N'COLUMN',@level2name=N'Status'
GO
INSERT [dbo].[WhJobSchedule] ([ID], [ScheduleType], [ScheduleGUID], [ScheduleName], [Title], [Status], [CronExpression], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName]) VALUES (1, 2, N'531894F4-F602-4252-8A1F-DFDE3C0C2D8C', N'TriggerTimingStartupProcess', N'流程定时启动', 0, NULL, CAST(0x0000ADBC00C2F444 AS DateTime), N'ADMIN_1001', N'ADMINISTRATOR_JOB')
INSERT [dbo].[WhJobSchedule] ([ID], [ScheduleType], [ScheduleGUID], [ScheduleName], [Title], [Status], [CronExpression], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName]) VALUES (2, 1, N'778A2615-8B0F-4DCD-9E17-5BD4BEA7231D', N'TerminateOverdueProcessInstance', N'逾期流程终结', 0, N'*/5 * * * *', CAST(0x0000ADB90161DE64 AS DateTime), N'ADMIN_1001', N'ADMINISTRATOR_JOB')
INSERT [dbo].[WhJobSchedule] ([ID], [ScheduleType], [ScheduleGUID], [ScheduleName], [Title], [Status], [CronExpression], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName]) VALUES (3, 1, N'F76D848C-DEE0-40FA-8CF3-7A0CC51B3B5D', N'SendTaskEMail', N'发送任务邮件', 0, N'*/2 * * * *', CAST(0x0000ADB90160673D AS DateTime), N'ADMIN_1001', N'ADMINISTRATOR_JOB')
INSERT [dbo].[WhJobSchedule] ([ID], [ScheduleType], [ScheduleGUID], [ScheduleName], [Title], [Status], [CronExpression], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName]) VALUES (4, 1, N'3D86096D-3D11-4FA8-8606-5BB0CFFD9DCF', N'TerminateOverdueActivityInstance', N'逾期任务自动完成', 0, N'*/2 * * * *', CAST(0x0000ADB90161E26B AS DateTime), N'ADMIN_1001', N'ADMINISTRATOR_JOB')
/****** Object:  Table [dbo].[WhJobLog]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WhJobLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[JobType] [varchar](50) NOT NULL,
	[JobName] [varchar](200) NOT NULL,
	[JobKey] [varchar](50) NULL,
	[RefClass] [varchar](50) NOT NULL,
	[RefIDs] [varchar](4000) NOT NULL,
	[Status] [smallint] NOT NULL,
	[Message] [nvarchar](4000) NULL,
	[StackTrace] [nvarchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_WFJOBS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PROCESS-INSTANCE
   ACTIVITY-INSTANCE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WhJobLog', @level2type=N'COLUMN',@level2name=N'RefClass'
GO
SET IDENTITY_INSERT [dbo].[WhJobLog] ON
INSERT [dbo].[WhJobLog] ([ID], [JobType], [JobName], [JobKey], [RefClass], [RefIDs], [Status], [Message], [StackTrace], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName]) VALUES (1, N'Timer', N'TriggerTimingStartupProcess', N'', N'Process', N'8d903a57-569a-4fb8-a75b-8ecce4a4fb5a', -1, N'The given key ''none'' was not present in the dictionary.', N'   at System.Collections.Generic.Dictionary`2.get_Item(TKey key)
   at Slickflow.Module.Localize.LocalizeUtility.GetItem(ProjectTypeEnum project, String key) in D:\dell-tool\SlickflowCore-20211003-dell\Source\Slickflow.Module.Localize\LocalizeUtility.cs:line 91
   at Slickflow.Module.Localize.LocalizeUtility.GetMessage(ProjectTypeEnum project, String key, String message) in D:\dell-tool\SlickflowCore-20211003-dell\Source\Slickflow.Module.Localize\LocalizeUtility.cs:line 116
   at Slickflow.Module.Localize.LocalizeHelper.GetEngineMessage(String key, String message) in D:\dell-tool\SlickflowCore-20211003-dell\Source\Slickflow.Module.Localize\LocalizeHelper.cs:line 56
   at Slickflow.Engine.Service.WorkflowService.Start(IDbConnection conn, IDbTransaction trans) in D:\dell-tool\SlickflowCore-20211003-dell\Source\Slickflow.Engine\Service\WorkflowService.cs:line 677
   at Slickflow.Engine.Service.WorkflowService.Start() in D:\dell-tool\SlickflowCore-20211003-dell\Source\Slickflow.Engine\Service\WorkflowService.cs:line 610
   at Slickflow.Engine.Service.WorkflowService.StartProcess(WfAppRunner runner) in D:\dell-tool\SlickflowCore-20211003-dell\Source\Slickflow.Engine\Service\WorkflowService.cs:line 720
   at Slickflow.JobScheduler.Service.SchedulerService.TriggerTimingStartupProcess(String processGUID, String version) in D:\dell-tool\SlickflowCore-20211003-dell\Source\Slickflow.JobScheduler\Service\SchedulerService.cs:line 367', CAST(0x0000ADBB00A48841 AS DateTime), N'ADMIN_1001', N'ADMINISTRATOR_JOB')
INSERT [dbo].[WhJobLog] ([ID], [JobType], [JobName], [JobKey], [RefClass], [RefIDs], [Status], [Message], [StackTrace], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName]) VALUES (2, N'Timer', N'TriggerTimingStartupProcess', N'', N'Process', N'8d903a57-569a-4fb8-a75b-8ecce4a4fb5a', 1, N'SUCCESS', NULL, CAST(0x0000ADBC00C2A9ED AS DateTime), N'ADMIN_1001', N'ADMINISTRATOR_JOB')
INSERT [dbo].[WhJobLog] ([ID], [JobType], [JobName], [JobKey], [RefClass], [RefIDs], [Status], [Message], [StackTrace], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName]) VALUES (3, N'Timer', N'InvokeProcessInstanceJobAction', N'', N'ProcessInstance', N'51', 1, N'SUCCESS', NULL, CAST(0x0000ADBE01677E14 AS DateTime), N'ADMIN_1001', N'ADMINISTRATOR_JOB')
SET IDENTITY_INSERT [dbo].[WhJobLog] OFF
/****** Object:  Table [dbo].[WfTransitionInstance]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfTransitionInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TransitionGUID] [varchar](100) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[TransitionType] [tinyint] NOT NULL,
	[FlyingType] [tinyint] NOT NULL,
	[FromActivityInstanceID] [int] NOT NULL,
	[FromActivityGUID] [varchar](100) NOT NULL,
	[FromActivityType] [smallint] NOT NULL,
	[FromActivityName] [nvarchar](50) NOT NULL,
	[ToActivityInstanceID] [int] NOT NULL,
	[ToActivityGUID] [varchar](100) NOT NULL,
	[ToActivityType] [smallint] NOT NULL,
	[ToActivityName] [nvarchar](50) NOT NULL,
	[ConditionParseResult] [tinyint] NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfTransitionInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[pr_eav_EntityInfoDelete]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_eav_EntityInfoDelete]
   @entityInfoID			int

AS

BEGIN

	SET NOCOUNT ON

	BEGIN TRANSACTION
	BEGIN TRY
		--删除主表数据
		DELETE 
		FROM EavEntityInfo
		WHERE ID = @entityInfoID

		--删除其它5张表的扩展属性数据
		DELETE 
		FROM EavEntityAttrInt
		WHERE EntityInfoID = @entityInfoID
	
		DELETE
		FROM EavEntityAttrDecimal
		WHERE EntityInfoID = @entityInfoID

		DELETE
		FROM EavEntityAttrVarchar
		WHERE EntityInfoID = @entityInfoID

		DELETE
		FROM EavEntityAttrDatetime
		WHERE EntityInfoID = @entityInfoID
		
		DELETE
		FROM EavEntityAttrText
		WHERE EntityInfoID = @entityInfoID
		
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION

			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除实体及其扩展属性失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_eav_EntityDefDelete]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_eav_EntityDefDelete]
   @entityDefID			int

AS

BEGIN

	SET NOCOUNT ON

	BEGIN TRANSACTION
	BEGIN TRY
		
		--1. 删除其它5张表的扩展属性数据
		DELETE 
		FROM EavEntityAttrInt
		WHERE EntityDefID = @entityDefID
	
		DELETE
		FROM EavEntityAttrDecimal
		WHERE EntityDefID = @entityDefID

		DELETE
		FROM EavEntityAttrVarchar
		WHERE EntityDefID = @entityDefID

		DELETE
		FROM EavEntityAttrDatetime
		WHERE EntityDefID = @entityDefID
		
		DELETE
		FROM EavEntityAttrText
		WHERE EntityDefID = @entityDefID
		
		--2. 删除实体信息主表数据
		DELETE 
		FROM EavEntityInfo
		WHERE EntityDefID = @entityDefID
		
		--3. 删除属性事件数据
		DELETE 
		FROM EavEntityAttributeEvent
		WHERE EntityDefID = @entityDefID
		
		--4. 删除实体属性表数据
		DELETE
		FROM EavEntityAttribute
		WHERE EntityDefID = @entityDefID
		
		--5. 删除定义主表数据
		DELETE
		FROM EavEntityDef
		WHERE ID = @entityDefID
		
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION

			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除实体及其扩展属性失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_eav_EntityAttrValueQuery]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_eav_EntityAttrValueQuery]
   @entityInfoID			int

AS

BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SELECT * FROM(
		SELECT
			EEAI.EntityInfoID
			,EEA.EntityDefID
			,'EavEntityAttrInt' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.DataValueField
			,EEA.DataTextField
			,CONVERT(nvarchar(100), EEAI.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrInt EEAI
				ON EEA.ID = EEAI.AttrID
		UNION ALL
		SELECT
			EEAN.EntityInfoID
			,EEA.EntityDefID
			,'EavEntityAttrDecimal' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.DataValueField
			,EEA.DataTextField
			,CONVERT(nvarchar(100), EEAN.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrDecimal EEAN
				ON EEA.ID = EEAN.AttrID
		UNION ALL
		SELECT
			EEAV.EntityInfoID
			,EEA.EntityDefID
			,'EavEntityAttrVarchar' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.DataValueField
			,EEA.DataTextField
			,CONVERT(nvarchar(4000), EEAV.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrVarchar EEAV
				ON EEA.ID = EEAV.AttrID
		UNION ALL
		SELECT
			EEAD.EntityInfoID
			,EEA.EntityDefID
			,'EavEntityAttrDatetime' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.DataValueField
			,EEA.DataTextField
			--,CONVERT(nvarchar, EEAD.Value) as Value
			,CONVERT(varchar(25), EEAD.Value, 120) 
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrDatetime EEAD
				ON EEA.ID = EEAD.AttrID
		UNION ALL
		SELECT
			EEAT.EntityInfoID
			,EEA.EntityDefID
			,'EavEntityAttrText' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.DataValueField
			,EEA.DataTextField
			,CONVERT(nvarchar(max), EEAT.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrText EEAT
				ON EEA.ID = EEAT.AttrID
					) T
	WHERE T.EntityInfoID=@entityInfoID
		
	END TRY
	BEGIN CATCH
			ROLLBACK TRANSACTION

			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('An error occurred when reading entity info data: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_eav_EntityAttrValuePivotQuery]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_eav_EntityAttrValuePivotQuery]
    @entityDefID	int = 0,		--表单定义ID
	@createdBeginDateTime	datetime = null,	--创建开始日期
	@createdEndDateTime		datetime = null,	--创建结束日期
	@whereSql	nvarchar(2000)
AS


BEGIN

	SET NOCOUNT ON
	
	--删除临时表
	IF OBJECT_ID('tempdb..##myPivotTable030609021') IS NOT NULL
	BEGIN
	  DROP TABLE ##myPivotTable030609021;
	END


	DECLARE @countSql nvarchar(1000)
	DECLARE @query nvarchar(4000)
	
	--检查参数是否有效
	IF (@entityDefID = 0)
	BEGIN
		DECLARE @error int, @message varchar(4000)
		SELECT @error = ERROR_NUMBER()
			, @message = ERROR_MESSAGE();
		RAISERROR ('表单定义ID标识不能为空！查询失败: %d: %s', 16, 1, @error, @message)
	END
	
	print 'begin...'

	--组建查询用到的SQL语句
	--1. 基本语句
	
	--1.1 构建时间范围条件语句
	DECLARE @dateSql nvarchar(1000)
	IF (@createdBeginDateTime IS NOT NULL)
	BEGIN 
		SET @dateSql = ' AND CreatedDateTime >=' + CONVERT(nvarchar, @createdBeginDateTime);
	END
	
	IF (@createdEndDateTime IS NOT NULL)
	BEGIN
		SET @dateSql = ' AND CreatedDateTime <=' + CONVERT(nvarchar, @createdEndDateTime);
	END
	
	--print @dateSql
	--1.2 

	--按照表单查所有实例数据
	DECLARE @sql nvarchar(2000)
	DECLARE @rowsCount int
	SET @sql = 'SELECT ID FROM EavEntityInfo WHERE EntityDefID=' + CONVERT(varchar, @entityDefID)
	SET @countSql = 'SELECT @total=COUNT(1) FROM EavEntityInfo WHERE EntityDefID=' + CONVERT(varchar, @entityDefID)

    
    --3. 获取总记录数，如果总记录数为0，则返回
	DECLARE @params nvarchar(500)
	SET @params = '@total int OUTPUT'
	EXEC sp_executesql @countSql, @params, @total=@rowsCount OUTPUT


	IF (@rowsCount = 0)
	BEGIN
		--选取空记录返回，用于Dapper构造动态类型对象
		SELECT
			EEI.ID,
			EEI.EntityDefID,
			EED.EntityName,
			EEI.CreatedUserName,
			EEI.CreatedUserID,
			EEI.CreatedDatetime
		FROM EavEntityInfo EEI
		INNER JOIN EavEntityDef EED
			ON EED.ID = EEI.EntityDefID
		WHERE EEI.ID = -1000

		RETURN
	END
	
	--4. 获取实体ID表
	DECLARE @tblEntityInfo TABLE(ID INT)

	INSERT INTO @tblEntityInfo
	EXEC sp_executesql @sql;
		
	--5. 查询是否有动态扩展属性，如果没有，返回主表记录
	DECLARE @tblDynamicAttr	TABLE(
		EntityInfoID		int,
		TblName		nvarchar(50),
		AttrID		int,
		AttrCode	varchar(30),
		AttrName	nvarchar(50),
		AttrDataType	int,
		OrderID			int,
		Value		nvarchar(4000)
	)
	
	--将动态属性写入临时表
	INSERT INTO @tblDynamicAttr
	SELECT * FROM(
		SELECT
			EEAI.EntityInfoID
			,'EavEntityAttrInt' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAI.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrInt EEAI
			ON EEA.ID = EEAI.AttrID
			WHERE EEA.StorageType = 1
		UNION ALL
		SELECT
			EEAN.EntityInfoID
			,'EavEntityAttrDecimal' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAN.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrDecimal EEAN
			ON EEA.ID = EEAN.AttrID
			WHERE EEA.StorageType = 1
		UNION ALL
		SELECT
			EEAV.EntityInfoID
			,'EavEntityAttrVarchar' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAV.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrVarchar EEAV
			ON EEA.ID = EEAV.AttrID
			WHERE EEA.StorageType = 1
		UNION ALL
		SELECT
			EEAD.EntityInfoID
			,'EavEntityAttrDatetime' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAD.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrDatetime EEAD
			ON EEA.ID = EEAD.AttrID
			WHERE EEA.StorageType = 1
		UNION ALL
		SELECT
			EEAT.EntityInfoID
			,'EavEntityAttrText' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAT.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrText EEAT
			ON EEA.ID = EEAT.AttrID
			WHERE EEA.StorageType = 1
	) T
	WHERE T.EntityInfoID IN (SELECT ID FROM @tblEntityInfo) 
	ORDER BY 
		T.EntityInfoID, 
		T.OrderID

	DECLARE @dynamicRowsCount int
	SELECT @dynamicRowsCount = COUNT(1) FROM @tblDynamicAttr
	
	
	--如果没有动态扩展属性，则返回主表记录
	IF (@dynamicRowsCount = 0)
	BEGIN
		SELECT 
			EEI.ID, 
			EED.EntityName
		FROM EavEntityInfo EEI
		INNER JOIN EavEntityDef EED
			ON EED.ID = EEI.EntityDefID
		WHERE EEI.ID IN (
			SELECT ID FROM @tblEntityInfo) 

		RETURN
	END

	--6. 返回动态字段的列表
	--表单自定义字段表的临时表
	--用于先将表单字段填充到表里
	CREATE TABLE #myCustomEntityAttrValueTable
	(
		[ID] [int] NULL,
		[EntityDefID] [int] NULL,
		[EntityName] [nvarchar] (100) NULL,
		[EntityCode] [varchar](100) NULL,
		[AttrName] [nvarchar] (100) NULL,
		[AttrCode] [varchar](100) NULL,
		[OrderID]	[int] NULL,
		[Value] [nvarchar](max) NULL
	)

	--插入行记录到临时表
	INSERT INTO #myCustomEntityAttrValueTable
	SELECT 
		EEI.ID, 
		EEI.EntityDefID,
		EED.EntityName,
		EED.EntityCode,
		T.AttrName,
		T.AttrCode,
		T.OrderID,
		T.Value
	FROM EavEntityInfo EEI
	INNER JOIN EavEntityDef EED
		ON EED.ID = EEI.EntityDefID
	INNER JOIN EavEntityAttribute EEA
		ON EEA.EntityDefID = EED.ID
	INNER JOIN @tblEntityInfo T1
		ON T1.ID = EEI.ID
	LEFT JOIN @tblDynamicAttr T
		ON EEI.ID = T.EntityInfoID
	ORDER BY 
		T.EntityInfoID,
		T.OrderID
	
	--SELECT * FROM #myCustomEntityAttrValueTable
	
	--行列PIVOT过程
	DECLARE @QuestionList nvarchar(max);
	SELECT @QuestionList = STUFF(
		(
			SELECT 
				', ' + quotename(AttrCode) 
			FROM #myCustomEntityAttrValueTable 
			GROUP BY 
				AttrCode, 
				OrderID
			ORDER BY 
				OrderID
			FOR XML PATH('')
		), 
		1, 
		2, 
		''
	);
	
	--行列PIVOT过程SQL语句
	DECLARE @qry nvarchar(max);
	SET @qry = 'SELECT ID, EntityDefID, EntityName, EntityCode, ' 
		+ @QuestionList 
		+ ' INTO ##myPivotTable030609021 FROM (
					SELECT ID, EntityDefID, EntityName, EntityCode, AttrCode, Value 
					FROM #myCustomEntityAttrValueTable 
			) UP 
			PIVOT (
				MAX(Value) 
				FOR AttrCode IN (' + @QuestionList + ')
			) pvt '
	
	--执行输出
	print @qry
	
	EXEC sp_executesql @qry;
	
	--增加条件过滤
	DECLARE @outSql nvarchar(max);
	SET @outSql = 'SELECT * FROM ##myPivotTable030609021'
	IF (@whereSql != '')
	BEGIN
		SET @outSql = @outSql 
			+ ' WHERE '
			+ @whereSql
	END 
	
	print @outSql
	EXEC sp_executesql @outSql;

	--7. 销毁临时表
	DROP TABLE #myCustomEntityAttrValueTable 
	DROP TABLE ##myPivotTable030609021


END
GO
/****** Object:  Table [dbo].[WfProcessVariable]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfProcessVariable](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VariableType] [varchar](50) NOT NULL,
	[AppInstanceID] [varchar](100) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[ActivityGUID] [varchar](100) NULL,
	[ActivityName] [nvarchar](50) NULL,
	[Name] [varchar](50) NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
	[LastUpdatedDateTime] [datetime] NOT NULL,
	[RowVersionID] [timestamp] NOT NULL,
 CONSTRAINT [PK_WFPROCESSVARIABLE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WfProcessVariable', @level2type=N'COLUMN',@level2name=N'VariableType'
GO
SET IDENTITY_INSERT [dbo].[WfProcessVariable] ON
INSERT [dbo].[WfProcessVariable] ([ID], [VariableType], [AppInstanceID], [ProcessGUID], [ProcessInstanceID], [ActivityGUID], [ActivityName], [Name], [Value], [LastUpdatedDateTime]) VALUES (4, N'Process', N'123', N'161d72ab-385e-460a-9414-6449fb4b7689', 50, N'', N'', N'day1', N'10', CAST(0x0000ADBD01520717 AS DateTime))
INSERT [dbo].[WfProcessVariable] ([ID], [VariableType], [AppInstanceID], [ProcessGUID], [ProcessInstanceID], [ActivityGUID], [ActivityName], [Name], [Value], [LastUpdatedDateTime]) VALUES (5, N'Process', N'123', N'161d72ab-385e-460a-9414-6449fb4b7689', 50, N'', N'', N'day2', N'5', CAST(0x0000ADBD0152137D AS DateTime))
SET IDENTITY_INSERT [dbo].[WfProcessVariable] OFF
/****** Object:  Table [dbo].[WfProcessInstance]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfProcessInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ProcessName] [nvarchar](50) NOT NULL,
	[Version] [nvarchar](20) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceCode] [nvarchar](50) NULL,
	[ProcessState] [smallint] NOT NULL,
	[ParentProcessInstanceID] [int] NULL,
	[ParentProcessGUID] [varchar](100) NULL,
	[InvokedActivityInstanceID] [int] NULL,
	[InvokedActivityGUID] [varchar](100) NULL,
	[JobTimerType] [smallint] NULL,
	[JobTimerStatus] [smallint] NULL,
	[TriggerExpression] [nvarchar](200) NULL,
	[OverdueDateTime] [datetime] NULL,
	[JobTimerTreatedDateTime] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[EndedDateTime] [datetime] NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfProcessInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WfProcess]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfProcess](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessGUID] [varchar](100) NULL,
	[Version] [nvarchar](20) NOT NULL,
	[ProcessName] [nvarchar](50) NOT NULL,
	[ProcessCode] [varchar](50) NOT NULL,
	[IsUsing] [tinyint] NOT NULL,
	[AppType] [varchar](20) NULL,
	[PackageType] [tinyint] NULL,
	[PackageProcessID] [int] NULL,
	[PageUrl] [nvarchar](100) NULL,
	[XmlFileName] [nvarchar](50) NULL,
	[XmlFilePath] [nvarchar](50) NULL,
	[XmlContent] [nvarchar](max) NULL,
	[StartType] [tinyint] NOT NULL,
	[StartExpression] [varchar](100) NULL,
	[Description] [nvarchar](1000) NULL,
	[EndType] [tinyint] NOT NULL,
	[EndExpression] [varchar](100) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfProcess] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfProcess] ON
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (3, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'1', N'PriceProcess(SequenceTest)', N'PriceProcessCode', 1, NULL, NULL, NULL, NULL, NULL, N'price\price.xml', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="60c8a694-632a-4ded-9155-f666e461b078" name="业务员(Sales)" code="salesmate" outerId="9"/>
		<Participant type="Role" id="7f9be0fb-7ffa-4b57-8c88-26734fbe3cf6" name="打样员(Tech)" code="techmate" outerId="10"/>
	</Participants>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="072af8c3-482a-4b1c-890b-685ce2fcc75d" name="PriceProcess(SequenceTest)" code="PriceProcessCode" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="9b78486d-5b8f-4be4-948e-522356e84e79" name="Start" code="AJBNOX" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="140" top="117" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="b53eb9ab-3af6-41ad-d722-bed946d19792" name="End" code="9IQ4FV" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="820" top="117" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="3c438212-4863-4ff8-efc9-a9096c4a8230" name="Sales Submit" code="5Q1Q82" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="60c8a694-632a-4ded-9155-f666e461b078"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression="PT5M"/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[{"Fruit": "apple"}]]>
						</Section>
					</Sections>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="undefined">
						<Widget left="280" top="123" width="100" height="27"/>
					</Geography>
				</Activity>
				<Activity id="eb833577-abb5-4239-875a-5f2e2fcb6d57" name="Manager Signature" code="HNGPSC" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="7f9be0fb-7ffa-4b57-8c88-26734fbe3cf6"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[{ "Fruit": "orange", "Book": "story" }]]>
						</Section>
					</Sections>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="undefined">
						<Widget left="450" top="120" width="120" height="32"/>
					</Geography>
				</Activity>
				<Activity id="cab57060-f433-422a-a66f-4a5ecfafd54e" name="Sales Confirm" code="9S66UP" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="60c8a694-632a-4ded-9155-f666e461b078"/>
					</Performers>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="undefined">
						<Widget left="640" top="123" width="90" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="5432de95-cbcd-4349-9cf0-7e67904c52aa" from="3c438212-4863-4ff8-efc9-a9096c4a8230" to="eb833577-abb5-4239-875a-5f2e2fcb6d57">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="undefined"/>
				</Transition>
				<Transition id="ac609b39-b6eb-4506-c36f-670c5ed53f5c" from="eb833577-abb5-4239-875a-5f2e2fcb6d57" to="cab57060-f433-422a-a66f-4a5ecfafd54e">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="undefined"/>
				</Transition>
				<Transition id="2d5c0e7b-1303-48cb-c22b-3cd2b45701e3" from="cab57060-f433-422a-a66f-4a5ecfafd54e" to="b53eb9ab-3af6-41ad-d722-bed946d19792">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="undefined"/>
				</Transition>
				<Transition id="9cf01621-2dd5-474a-8889-cdbe53a0b72e" from="9b78486d-5b8f-4be4-948e-522356e84e79" to="3c438212-4863-4ff8-efc9-a9096c4a8230">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="382eebd0-9250-46ef-b235-a97b64ebaa57" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A3F900E418AE AS DateTime), CAST(0x0000ABE401372138 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (24, N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'1', N'请假流程(WebDemo)', N'AskLeave', 1, NULL, NULL, NULL, NULL, NULL, N'QINGJIA\HrsLeave1.xml', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="3c7aeaed-8b58-46a6-be39-7b850e6ed8e0" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="c9e054eb-7e4f-47c3-a2b9-61e0ff8748d4" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="6200799d-ffd2-4ae6-d28f-294a0cd3435a" name="总经理" code="generalmanager" outerId="8"/>
		<Participant type="Role" id="a0c8c361-87e1-4106-a7c9-c0b589123c9c" name="人事经理" code="hrmanager" outerId="3"/>
	</Participants>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="2acffb20-6bd1-4891-98c9-c76d022d1445" name="请假流程(WebDemo)" code="AskLeave" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="bb6c9787-0e1c-4de1-ddbc-593992724ca5" name="开始&#xA;(Start)&#xA;" code="73XSBM" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="180" top="213.5" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="5eb84b81-0f04-476d-cc82-b42a65464880" name="结束&#xA;(End)&#xA;" code="39WCUQ" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="920" top="215" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="3242c597-e889-4768-f6db-cafc3d675370" name="员工提交&#xA;(EmployeeSubmit)" code="TLK1G6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="3c7aeaed-8b58-46a6-be39-7b850e6ed8e0"/>
					</Performers>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined">
						<Widget left="270" top="207.5" width="110" height="50"/>
					</Geography>
				</Activity>
				<Activity id="c437c27a-8351-4805-fd4f-4e270084320a" name="部门经理审批&#xA;(DeptManager)" code="8Z7BOX" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c9e054eb-7e4f-47c3-a2b9-61e0ff8748d4"/>
					</Performers>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined">
						<Widget left="440" top="209" width="110" height="47"/>
					</Geography>
				</Activity>
				<Activity id="c05bc40f-579b-49cb-cd12-30c2cba4db1e" name="Gateway" code="0IUHWH" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="620" top="213.5" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="a6a8e554-d73e-4a77-8d16-08edf5905e1f" name="总经理审批&#xA;(CEO)" code="9EGFZL" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6200799d-ffd2-4ae6-d28f-294a0cd3435a"/>
					</Performers>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined">
						<Widget left="744" top="140" width="96" height="40"/>
					</Geography>
				</Activity>
				<Activity id="da9f744b-3f97-40c9-c4f8-67d5a60a2485" name="人事经理审批(HRManager)" code="LM3V7T" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="a0c8c361-87e1-4106-a7c9-c0b589123c9c"/>
					</Performers>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined">
						<Widget left="744" top="290" width="86" height="40"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="7af6085c-d40e-4687-ec75-748b7ef18e3d" from="bb6c9787-0e1c-4de1-ddbc-593992724ca5" to="3242c597-e889-4768-f6db-cafc3d675370">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined"/>
				</Transition>
				<Transition id="92f5a2a2-e89e-4b3e-8ff9-6a72d3a2d946" from="3242c597-e889-4768-f6db-cafc3d675370" to="c437c27a-8351-4805-fd4f-4e270084320a">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined"/>
				</Transition>
				<Transition id="8c1922c3-6d16-452e-a9a0-0b7ba0453347" from="c437c27a-8351-4805-fd4f-4e270084320a" to="c05bc40f-579b-49cb-cd12-30c2cba4db1e">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined"/>
				</Transition>
				<Transition id="a158f3af-61b2-4169-f131-d0876c20063b" from="c05bc40f-579b-49cb-cd12-30c2cba4db1e" to="a6a8e554-d73e-4a77-8d16-08edf5905e1f">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days>3]]>
						</ConditionText>
					</Condition>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined"/>
				</Transition>
				<Transition id="2333ad8b-f958-4ca3-9e72-678d809de2ca" from="da9f744b-3f97-40c9-c4f8-67d5a60a2485" to="5eb84b81-0f04-476d-cc82-b42a65464880">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined"/>
				</Transition>
				<Transition id="efc696f7-83c4-4741-a6f5-e00f9631dda4" from="a6a8e554-d73e-4a77-8d16-08edf5905e1f" to="da9f744b-3f97-40c9-c4f8-67d5a60a2485">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined"/>
				</Transition>
				<Transition id="89c490d0-7a4f-4465-fb4f-0e6914ad703c" from="c05bc40f-579b-49cb-cd12-30c2cba4db1e" to="da9f744b-3f97-40c9-c4f8-67d5a60a2485">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days<=3]]>
						</ConditionText>
					</Condition>
					<Geography parent="7693ee84-8336-49b3-ceaf-e04debc7e751" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000A4210179DC78 AS DateTime), CAST(0x0000AD040134908C AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (33, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'1', N'订单流程(MvcDemo)', N'OrderProcess', 1, NULL, NULL, NULL, NULL, NULL, N'price\order.jump.tmp.xml', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="6398503c-25da-4c49-9530-41d3573c860c" name="业务员" code="salesmate" outerId="9"/>
		<Participant type="Role" id="cfb8d004-b27e-40a1-9bc7-55323de0b59b" name="打样员" code="techmate" outerId="10"/>
		<Participant type="Role" id="3c80b85c-73a9-4f52-a21f-1df2a9f37cf7" name="跟单员" code="merchandiser" outerId="11"/>
		<Participant type="Role" id="eae5fb4f-62d8-4024-81db-4ad8b48e611e" name="质检员" code="qcmate" outerId="12"/>
		<Participant type="Role" id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b" name="包装员" code="expressmate" outerId="13"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="订单流程(MvcDemo)" id="5c5041fc-ab7f-46c0-85a5-6250c3aea375">
			<Description>null</Description>
			<Activities>
				<Activity id="e357fe9e-dc33-4075-bd34-6f7425bb7671" name="开始" code="undefined">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="30" top="92" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="aad747dd-2b75-449c-a8a6-391b8a426e83" name="派单" code="Dispatching">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6398503c-25da-4c49-9530-41d3573c860c"/>
					</Performers>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined">
						<Widget left="160" top="98" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="890d4971-3d5d-4800-bdf3-a355fd4a6317" name="Or分支节点" code="undefined">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="317" top="93" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="fc8c71c5-8786-450e-af27-9f6a9de8560f" name="打样" code="Sampling">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="cfb8d004-b27e-40a1-9bc7-55323de0b59b"/>
					</Performers>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined">
						<Widget left="303" top="269" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803" name="生产" code="Manufacturing">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="3c80b85c-73a9-4f52-a21f-1df2a9f37cf7"/>
						<Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b"/>
					</Performers>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined">
						<Widget left="413" top="269" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="39c71004-d822-4c15-9ff2-94ca1068d745" name="质检" code="QCChecking">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="eae5fb4f-62d8-4024-81db-4ad8b48e611e"/>
					</Performers>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined">
						<Widget left="547" top="268" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="422e5354-14f7-4a0a-ae69-c169fee96e50" name="称重" code="Weighting">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b"/>
					</Performers>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined">
						<Widget left="660" top="179" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d" name="打印发货单" code="Delivering">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b"/>
					</Performers>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined">
						<Widget left="650" top="60" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="b70e717a-08da-419f-b2eb-7a3d71f054de" name="结束" code="undefined">
					<Description></Description>
					<ActivityType type="EndNode"/>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="867" top="107" width="38" height="38"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e8851141-e3f5-46d7-a317-b7860e32592e" from="e357fe9e-dc33-4075-bd34-6f7425bb7671" to="aad747dd-2b75-449c-a8a6-391b8a426e83">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="e4d3c553-ba29-4965-dd3e-d098895a10e7" from="aad747dd-2b75-449c-a8a6-391b8a426e83" to="890d4971-3d5d-4800-bdf3-a355fd4a6317">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="dabaa65d-905b-42c4-f5f7-e599334c03c9" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="fc8c71c5-8786-450e-af27-9f6a9de8560f">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[CanUseStock == "false" && IsHavingWeight == "false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="8eb5ee28-4d72-4361-fc4a-44ea46cbd639" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[CanUseStock == "true" && IsHavingWeight == "true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="bea1aa54-2167-4438-a9bf-1a2cbc5f43c9" from="fc8c71c5-8786-450e-af27-9f6a9de8560f" to="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="7a1dac3c-4f8c-46b2-bcb9-2ea36df29e27" from="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803" to="39c71004-d822-4c15-9ff2-94ca1068d745">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="9da96321-6bad-4673-829a-0bda31c3e3e1" from="39c71004-d822-4c15-9ff2-94ca1068d745" to="422e5354-14f7-4a0a-ae69-c169fee96e50">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="67a3fe0e-06d3-4a01-e0c1-1a731166c905" from="422e5354-14f7-4a0a-ae69-c169fee96e50" to="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="75f0eb1d-1933-4a0a-a953-76a755744336" from="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d" to="b70e717a-08da-419f-b2eb-7a3d71f054de">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
				<Transition id="95098c43-7acc-48f9-fd5f-6b27b445137b" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="422e5354-14f7-4a0a-ae69-c169fee96e50">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[CanUseStock == "true" && IsHavingWeight == "false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="fc9a253a-5c39-43ee-8c86-7f485308fa44" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000A4D2011D084F AS DateTime), CAST(0x0000A7D80144C286 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (51, N'ec794d6d-4543-4938-b5f5-cdd97cf939d6', N'1', N'财务报销', N'FinanceBaoxiao', 1, N'baoxiao', NULL, NULL, NULL, N'baoxiao.xml', N'baoxiao\baoxiao.xml', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="6e3e7793-638f-4a48-d787-2a1016711602" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="8ad2131e-a98e-4523-acba-88e4404ce0a9" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="77858784-3ec7-4849-c9c2-15e5e6dead0d" name="财务经理" code="finacemanager" outerId="14"/>
		<Participant type="Role" id="0501e326-8541-4d13-8159-d510d57ce1f5" name="总经理" code="generalmanager" outerId="8"/>
		<Participant type="Role" id="23d1c029-ec6e-4212-c9a5-1b82472d4747" name="主管总监" code="director" outerId="4"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="财务报销" id="ec794d6d-4543-4938-b5f5-cdd97cf939d6">
			<Description>null</Description>
			<Activities>
				<Activity id="fe775212-6351-4c9b-ea02-f54a8b95d63b" name="开始" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="59" top="160" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="77124224-0de9-4407-9d61-4405c8131c48" name="结束" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="925" top="219" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="7230bb34-3c35-4f44-8f2e-0933cb85aa35" name="填写报销单据" code="appform">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6e3e7793-638f-4a48-d787-2a1016711602"/>
					</Performers>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined">
						<Widget left="198" top="159" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="889aa813-3eab-4515-89af-cbd133cf030b" name="财务审批" code="accountaduit">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="77858784-3ec7-4849-c9c2-15e5e6dead0d"/>
					</Performers>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined">
						<Widget left="354" top="153" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="548e2052-1eab-43b0-a55c-020582b0b1c8" name="Gateway" code="">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="532" top="167" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd" name="总经理审批" code="ceoaudit">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="0501e326-8541-4d13-8159-d510d57ce1f5"/>
					</Performers>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined">
						<Widget left="629" top="116" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="77129a09-6b2c-43aa-af77-ba5ced57a174" name="主管总监查阅" code="cooaudit">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="23d1c029-ec6e-4212-c9a5-1b82472d4747"/>
					</Performers>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined">
						<Widget left="618" top="246" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="db2df810-7edd-4242-bc64-bac796d78844" name="Gateway" code="">
					<Description>总经理审批路由</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin"/>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="816" top="190" width="38" height="38"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="1ef510bb-e317-4df1-9f32-0b17601bb275" from="fe775212-6351-4c9b-ea02-f54a8b95d63b" to="7230bb34-3c35-4f44-8f2e-0933cb85aa35">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined"/>
				</Transition>
				<Transition id="61b60f12-9193-4134-af1f-8d974d354dfa" from="7230bb34-3c35-4f44-8f2e-0933cb85aa35" to="889aa813-3eab-4515-89af-cbd133cf030b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined"/>
				</Transition>
				<Transition id="5c8d1beb-5aef-4cc3-9e08-6fa6e153925d" from="889aa813-3eab-4515-89af-cbd133cf030b" to="548e2052-1eab-43b0-a55c-020582b0b1c8">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined"/>
				</Transition>
				<Transition id="96d291c4-3d7e-43e6-f820-dd695daa1fcc" from="548e2052-1eab-43b0-a55c-020582b0b1c8" to="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined"/>
				</Transition>
				<Transition id="1a1560ce-1258-46f1-f56e-9d1fb2e6142c" from="548e2052-1eab-43b0-a55c-020582b0b1c8" to="77129a09-6b2c-43aa-af77-ba5ced57a174">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined"/>
				</Transition>
				<Transition id="c405e021-cacf-412e-ce37-82817953c7ec" from="77129a09-6b2c-43aa-af77-ba5ced57a174" to="db2df810-7edd-4242-bc64-bac796d78844">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined"/>
				</Transition>
				<Transition id="60d69b10-ba70-46a4-948c-09d5be318397" from="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd" to="db2df810-7edd-4242-bc64-bac796d78844">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined"/>
				</Transition>
				<Transition id="32c2860a-3b66-4b77-a8f8-0f9578440d6d" from="db2df810-7edd-4242-bc64-bac796d78844" to="77124224-0de9-4407-9d61-4405c8131c48">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="c1eaef55-0cec-4127-aa0b-21ec5f544848" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000A55A0132BC96 AS DateTime), CAST(0x0000A7E40155942A AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (71, N'9fb4bca4-5674-4181-a010-f0e730e166dd', N'1', N'报价会签(SignTogetherTest)', N'BarginProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="9fb4bca4-5674-4181-a010-f0e730e166dd" name="报价会签(SignTogetherTest)" code="BarginProcess" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="1f303f19-71aa-4879-c501-f4d0f448f0a2" name="开始" code="DM668N" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="165" top="116" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="7462aae9-da1c-43f0-d741-a4586879de77" name="结束" code="LFPJ10" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="770" top="116" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="791d9d3a-882d-4796-cffc-84d9fca76afd" name="业务员提交" code="132XO7" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="undefined">
						<Widget left="303" top="121" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="23017d0c-08ca-4a59-9649-c6912b819001" name="业务员确认" code="FUR5KX" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="undefined">
						<Widget left="621" top="121" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="36cf2479-e8ec-4936-8bcd-b38101e4664a" name="板房会签" code="2O8FYL" url="">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Sequence" compareType="Percentage" completeOrder="0.5"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/samll_multiple_instance_task.png">
						<Widget left="472" top="121" width="67" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="50f7acb2-99d0-4877-e116-5bf19433bb89" from="1f303f19-71aa-4879-c501-f4d0f448f0a2" to="791d9d3a-882d-4796-cffc-84d9fca76afd">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="undefined"/>
				</Transition>
				<Transition id="87651a0d-81e5-4d6f-9ef3-ed0be0011c8f" from="791d9d3a-882d-4796-cffc-84d9fca76afd" to="36cf2479-e8ec-4936-8bcd-b38101e4664a">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="undefined"/>
				</Transition>
				<Transition id="63031ecf-2116-47a3-a0d8-f920dc5bee11" from="36cf2479-e8ec-4936-8bcd-b38101e4664a" to="23017d0c-08ca-4a59-9649-c6912b819001">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="undefined"/>
				</Transition>
				<Transition id="3d06aebb-2fb3-4995-e0c7-99d488f8312d" from="23017d0c-08ca-4a59-9649-c6912b819001" to="7462aae9-da1c-43f0-d741-a4586879de77">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="e91cae08-8b68-46e7-8a2e-b6b85093fd45" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A5D80104157F AS DateTime), CAST(0x0000ACF400DBD006 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (73, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'1', N'办公用品(SplitJoinTest)', N'OfficeGoods', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="114e7e8d-574c-42c2-eb1c-3d7160516ba3" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="595410fc-2f24-4708-bacd-0eb38b17e7fc" name="人事经理" code="hrmanager" outerId="3"/>
		<Participant type="Role" id="c9694802-fcb1-4cad-ad9e-aae9894305a6" name="总经理" code="generalmanager" outerId="8"/>
		<Participant type="Role" id="db7031ac-c0b4-4691-d6e0-195e66be6fe1" name="财务经理" code="finacemanager" outerId="14"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="办公用品(SplitJoinTest)" id="3a8ce214-fd18-4fac-95c0-e7958bc1b2f8">
			<Description>null</Description>
			<Activities>
				<Activity id="e52d0836-9f98-4b70-d485-6b01b8cc277e" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="160" top="141" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="30929bbb-c76e-4604-c956-f26feb4aa22e" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null"/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="876" top="141" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="4db4a153-c8fc-45df-b067-9d188ae19a41" name="仓库签字" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="114e7e8d-574c-42c2-eb1c-3d7160516ba3"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined">
						<Widget left="280" top="146" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="eb492ba8-075a-46e4-b95f-ac071dd3a43d" name="Gateway" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="414" top="141" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49" name="行政部签字" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="595410fc-2f24-4708-bacd-0eb38b17e7fc"/>
					</Performers>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined">
						<Widget left="553" top="60" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149" name="总经理签字" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c9694802-fcb1-4cad-ad9e-aae9894305a6"/>
					</Performers>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined">
						<Widget left="555" top="220" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="9414c43c-0c8c-4c0b-b65d-16203288c7ca" name="财务签字" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="db7031ac-c0b4-4691-d6e0-195e66be6fe1"/>
					</Performers>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined">
						<Widget left="555" top="147" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="932f7fa0-2d4c-4257-c158-b8b181af2d0a" name="财务主管" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="db7031ac-c0b4-4691-d6e0-195e66be6fe1"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined">
						<Widget left="734" top="144" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="81fdf756-ecd5-43c0-e2b3-25770aab5dee" from="e52d0836-9f98-4b70-d485-6b01b8cc277e" to="4db4a153-c8fc-45df-b067-9d188ae19a41">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
				<Transition id="69c1ba54-acb0-4b4e-ff03-3f6cf572e98a" from="4db4a153-c8fc-45df-b067-9d188ae19a41" to="eb492ba8-075a-46e4-b95f-ac071dd3a43d">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
				<Transition id="8d776249-f3c6-4397-817f-44880b34a451" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49">
					<Description>正常</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[surplus = "normal"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
				<Transition id="e40270aa-834a-455d-ffd6-b3f72feeeadc" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149">
					<Description>超量</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[surplus = "overamount"]]>
						</ConditionText>
					</Condition>
					<Receiver/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
				<Transition id="952b3594-fe40-427f-a27a-f2650226aeca" from="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49" to="932f7fa0-2d4c-4257-c158-b8b181af2d0a">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
				<Transition id="fd39de26-d9e9-425e-c952-dd8c37d329d6" from="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149" to="932f7fa0-2d4c-4257-c158-b8b181af2d0a">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
				<Transition id="6af8936c-a467-470a-f389-d0a3dcc3739b" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="9414c43c-0c8c-4c0b-b65d-16203288c7ca">
					<Description>正常</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[surplus = "normal"]]>
						</ConditionText>
					</Condition>
					<Receiver/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
				<Transition id="ec4b9497-c187-40a0-af21-1bc3401eb2cf" from="9414c43c-0c8c-4c0b-b65d-16203288c7ca" to="932f7fa0-2d4c-4257-c158-b8b181af2d0a">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
				<Transition id="4b8a68d6-ef32-420a-93e7-33c7e4b80360" from="932f7fa0-2d4c-4257-c158-b8b181af2d0a" to="30929bbb-c76e-4604-c956-f26feb4aa22e">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="6a788335-b5c8-4c94-f48f-f605aec62c65" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A60100F7C975 AS DateTime), CAST(0x0000AAE800F44849 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (104, N'b2a18777-43f1-4d4d-b9d5-f92aa655a93f', N'1', N'Ask for leave', N'AskLeaveE001', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="c3057cbe-72fb-46d5-f8d1-bedbc41ee5c4" name="testrole" code="testcode" outerId="21"/>
		<Participant type="Role" id="565f2976-3dee-4796-9dbd-e7691705bfd6" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="075d956b-fbaa-41da-8b2a-be24e7df7b2c" name="人事经理" code="hrmanager" outerId="3"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="Ask for leave" id="b2a18777-43f1-4d4d-b9d5-f92aa655a93f">
			<Description>null</Description>
			<Activities>
				<Activity id="849b95d4-6461-402a-f9f1-f443ced9b31a" name="Start" code="3JOGIG" url="null">
					<Description/>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="180" top="133" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="73a34903-b489-4dd5-9b28-a074a32f844b" name="End" code="KAWWO9" url="null">
					<Description/>
					<ActivityType type="EndNode" trigger="null"/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="818" top="142" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="b8d61c50-edfa-4edc-e890-7f0e84afa521" name="Submit Request" code="MNL42P" url="null">
					<Description/>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c3057cbe-72fb-46d5-f8d1-bedbc41ee5c4"/>
					</Performers>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined">
						<Widget left="312" top="138" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="0b41c280-b2dd-47eb-a074-73d56cb83e5b" name="" code="W8CRG5" url="null">
					<Description/>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="498" top="133" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="6bd98004-cd04-4f3a-bf21-ca232dcd0533" name="Dept Manager Approve" code="LY79GB" url="null">
					<Description/>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="565f2976-3dee-4796-9dbd-e7691705bfd6"/>
					</Performers>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined">
						<Widget left="632" top="50" width="67" height="50"/>
					</Geography>
				</Activity>
				<Activity id="6dbedb92-b128-4ae7-a9c8-3d8826d4c481" name="HR Manager Approve" code="SYA0LV" url="null">
					<Description/>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="075d956b-fbaa-41da-8b2a-be24e7df7b2c"/>
					</Performers>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined">
						<Widget left="633" top="203" width="67" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="7529e098-6a9f-4755-8d2a-12e69dc46068" from="849b95d4-6461-402a-f9f1-f443ced9b31a" to="b8d61c50-edfa-4edc-e890-7f0e84afa521">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined"/>
				</Transition>
				<Transition id="8050dd82-3a34-42c7-a994-15a3fe9b4a2d" from="b8d61c50-edfa-4edc-e890-7f0e84afa521" to="0b41c280-b2dd-47eb-a074-73d56cb83e5b">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined"/>
				</Transition>
				<Transition id="09abe631-68b9-4cfb-f3e9-d43692817c14" from="0b41c280-b2dd-47eb-a074-73d56cb83e5b" to="6bd98004-cd04-4f3a-bf21-ca232dcd0533">
					<Description>days &amp;lt;= 3</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days <= 3]]>
						</ConditionText>
					</Condition>
					<Receiver type="Superior"/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined"/>
				</Transition>
				<Transition id="33be7303-e246-48a1-ba83-ac038f1a06f5" from="0b41c280-b2dd-47eb-a074-73d56cb83e5b" to="6dbedb92-b128-4ae7-a9c8-3d8826d4c481">
					<Description>days &amp;gt; 3</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days > 3]]>
						</ConditionText>
					</Condition>
					<Receiver/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined"/>
				</Transition>
				<Transition id="c7dc0035-5230-4b38-e625-506ea9cfb117" from="6bd98004-cd04-4f3a-bf21-ca232dcd0533" to="73a34903-b489-4dd5-9b28-a074a32f844b">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined"/>
				</Transition>
				<Transition id="7dcd8bc6-99d9-4081-fdc6-f94c36f01907" from="6dbedb92-b128-4ae7-a9c8-3d8826d4c481" to="73a34903-b489-4dd5-9b28-a074a32f844b">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="48c413ca-344b-4c2e-84ea-f5ae24427f75" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A6EC00F3F9FB AS DateTime), CAST(0x0000AB2A00C966CB AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (109, N'1bc22da3-47e3-4a0a-be81-6d7297ad3aca', N'1', N'报价加签(SignForwardTest)', N'BarginMIProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="28e71769-f197-4fe0-fd9f-63474956dc60" name="业务员(Sales)" code="salesmate" outerId="9"/>
		<Participant type="Role" id="24b1a282-d4d4-4461-febb-2f28eb31f48f" name="打样员(Tech)" code="techmate" outerId="10"/>
	</Participants>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="1bc22da3-47e3-4a0a-be81-6d7297ad3aca" name="报价加签(SignForwardTest)" code="BarginMIProcess" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="1f303f19-71aa-4879-c501-f4d0f448f0a2" name="开始" code="MYXTED" url="null">
					<Description/>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="165" top="120" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="7462aae9-da1c-43f0-d741-a4586879de77" name="结束" code="3LZI6O" url="null">
					<Description/>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="768" top="124" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="791d9d3a-882d-4796-cffc-84d9fca76afd" name="业务员提交" code="UGRMYL" url="null">
					<Description/>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="28e71769-f197-4fe0-fd9f-63474956dc60"/>
					</Performers>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="undefined">
						<Widget left="303" top="121" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="23017d0c-08ca-4a59-9649-c6912b819001" name="业务员确认" code="TG32GR" url="null">
					<Description/>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="28e71769-f197-4fe0-fd9f-63474956dc60"/>
					</Performers>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="undefined">
						<Widget left="621" top="123" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="36cf2479-e8ec-4936-8bcd-b38101e4664a" name="板房加签" code="NM59LM" url="null">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignForward" mergeType="Parallel" compareType="Percentage" completeOrder="0.6"/>
					<Performers>
						<Performer id="24b1a282-d4d4-4461-febb-2f28eb31f48f"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/samll_multiple_instance_task.png">
						<Widget left="472" top="119" width="67" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="50f7acb2-99d0-4877-e116-5bf19433bb89" from="1f303f19-71aa-4879-c501-f4d0f448f0a2" to="791d9d3a-882d-4796-cffc-84d9fca76afd">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="undefined"/>
				</Transition>
				<Transition id="87651a0d-81e5-4d6f-9ef3-ed0be0011c8f" from="791d9d3a-882d-4796-cffc-84d9fca76afd" to="36cf2479-e8ec-4936-8bcd-b38101e4664a">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="undefined"/>
				</Transition>
				<Transition id="63031ecf-2116-47a3-a0d8-f920dc5bee11" from="36cf2479-e8ec-4936-8bcd-b38101e4664a" to="23017d0c-08ca-4a59-9649-c6912b819001">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="undefined"/>
				</Transition>
				<Transition id="3d06aebb-2fb3-4995-e0c7-99d488f8312d" from="23017d0c-08ca-4a59-9649-c6912b819001" to="7462aae9-da1c-43f0-d741-a4586879de77">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="016c6098-bd29-4b7e-a4f5-cd721210a005" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000A73500B6998A AS DateTime), CAST(0x0000ACF400DE716C AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (120, N'b4fe856b-9cf6-4a8e-af4e-b897ad00fc63', N'1', N'维养计划审批', N'MatainPlan', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="559afb98-a1d0-4d6c-af32-5fedd132db6b" name="科长级（村级负责岗）" code="300" outerId="300"/>
		<Participant type="Role" id="7080f30f-ebfb-47ed-e5a2-0fd27cffbf70" name="分管领导（乡镇级）" code="200" outerId="200"/>
		<Participant type="Role" id="1110a011-147a-43f5-a5fa-b1e2a6b67a86" name="局长级（县级负责岗）" code="100" outerId="100"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="维养计划审批" id="b4fe856b-9cf6-4a8e-af4e-b897ad00fc63">
			<Description>null</Description>
			<Activities>
				<Activity id="eb87bf37-8280-4d99-ee9e-617399fcc813" name="开始" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="76" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="d70a473f-1a46-464d-94f7-691cb22661c0" name="部门（村）提交审批" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="559afb98-a1d0-4d6c-af32-5fedd132db6b"/>
					</Performers>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined">
						<Widget left="182" top="76" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="7c3ee03e-91ca-4e84-ebc3-f705b7db7724" name="分管领导（乡）初审" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="7080f30f-ebfb-47ed-e5a2-0fd27cffbf70"/>
					</Performers>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined">
						<Widget left="344" top="76" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="995d69bc-2793-4ebb-a417-2fa508803452" name="" code="">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="532" top="227" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb" name="单位负责人（县）审批" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="1110a011-147a-43f5-a5fa-b1e2a6b67a86"/>
					</Performers>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined">
						<Widget left="683" top="228" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="a36ae24f-d74b-4d5b-cb5c-87566213ec5e" name="" code="">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="787" top="20" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="05845a9d-536f-4be2-db7c-d82282f13b45" name="结束" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="964" top="20" width="38" height="38"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="9ad0a94c-302f-496d-ceca-fa1638b84e12" from="eb87bf37-8280-4d99-ee9e-617399fcc813" to="d70a473f-1a46-464d-94f7-691cb22661c0">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined"/>
				</Transition>
				<Transition id="947680d4-fffc-419c-9175-583920ed92d2" from="d70a473f-1a46-464d-94f7-691cb22661c0" to="7c3ee03e-91ca-4e84-ebc3-f705b7db7724">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined"/>
				</Transition>
				<Transition id="e8be4c2d-d104-41ae-eb6a-7952d005995b" from="7c3ee03e-91ca-4e84-ebc3-f705b7db7724" to="995d69bc-2793-4ebb-a417-2fa508803452">
					<Description>undefined</Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined"/>
				</Transition>
				<Transition id="2fc94cd1-2e10-457f-f670-639a551b6aff" from="995d69bc-2793-4ebb-a417-2fa508803452" to="7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb">
					<Description>审批通过</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[xtype=="通过"  ||   xtype=="同意"]]>
						</ConditionText>
					</Condition>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined"/>
				</Transition>
				<Transition id="fd9ebf90-ad90-419b-f0b8-b15615114269" from="7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb" to="a36ae24f-d74b-4d5b-cb5c-87566213ec5e">
					<Description>undefined</Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined"/>
				</Transition>
				<Transition id="6b5194f2-57ee-4f11-87de-e8d29be3009e" from="a36ae24f-d74b-4d5b-cb5c-87566213ec5e" to="05845a9d-536f-4be2-db7c-d82282f13b45">
					<Description>审批通过</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[xtype=="通过"  ||  xtype=="同意"]]>
						</ConditionText>
					</Condition>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined"/>
				</Transition>
				<Transition id="cfa49cfe-067c-49a4-90ca-bc8bcec1fc9c" from="995d69bc-2793-4ebb-a417-2fa508803452" to="7c3ee03e-91ca-4e84-ebc3-f705b7db7724">
					<Description>审批不通过</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[xtype=="不通过"  || xtype=="不同意"  ||  xtype=="退回"]]>
						</ConditionText>
					</Condition>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined"/>
				</Transition>
				<Transition id="aa210284-a1f7-4e96-a623-2289aeca6d83" from="a36ae24f-d74b-4d5b-cb5c-87566213ec5e" to="7fedf1d4-a299-4985-b7e6-1d5c1ac0f7eb">
					<Description>审批不通过</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[xtype=="不通过"  ||  xtype=="不同意"  || xtype=="退回"]]>
						</ConditionText>
					</Condition>
					<Geography parent="471454b3-1d00-4298-bfc7-a495f90a93f7" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000A74D01168A9C AS DateTime), CAST(0x0000A7D80144A438 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (188, N'a0f15aad-81d3-467b-8a85-ab865ec4b3ab', N'1', N'并行分支多实例(AndSplitMI)', N'MITestProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="并行分支多实例(AndSplitMI)" id="a0f15aad-81d3-467b-8a85-ab865ec4b3ab">
			<Description>null</Description>
			<Activities>
				<Activity id="2cd8ff3f-fd36-4508-cee5-44dd985618ab" name="组长审批" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8459a01b-6326-4159-dc65-f337add34fcc" style="undefined">
						<Widget left="150" top="53" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d467834b-996c-42d7-fe27-1fff16d92460" name="员工填表" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8459a01b-6326-4159-dc65-f337add34fcc" style="undefined">
						<Widget left="10" top="53" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="487b0409-1056-4353-adf6-c3b6b7dc98c7" name="gateway-split" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="360" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6ac4e84d-23e4-4e31-9a7d-345b57dc9343" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="90" top="170" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="54fec63c-cab8-4774-fa81-bf7f9e127150" name="提交" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="undefined">
						<Widget left="210" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="eb4f0acf-99d5-4674-e386-822af5925a37" name="gateway-join" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="760" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fd77bbd7-daa9-46cf-9f35-34331482157b" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null"/>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1020" top="174" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="e3bfbd48-df18-4e8c-a02f-9ccdfb1c8e4d" name="归档" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="undefined">
						<Widget left="881" top="180" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="0c9869aa-c539-46ce-f317-c89227671b67" from="6ac4e84d-23e4-4e31-9a7d-345b57dc9343" to="54fec63c-cab8-4774-fa81-bf7f9e127150">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="undefined"/>
				</Transition>
				<Transition id="4713c54f-e34f-4a30-f1e5-326780550031" from="54fec63c-cab8-4774-fa81-bf7f9e127150" to="487b0409-1056-4353-adf6-c3b6b7dc98c7">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="undefined"/>
				</Transition>
				<Transition id="dab905a6-8677-4108-9fbf-41c7ad3c08c7" from="487b0409-1056-4353-adf6-c3b6b7dc98c7" to="d467834b-996c-42d7-fe27-1fff16d92460">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="undefined"/>
				</Transition>
				<Transition id="af210be6-a372-4528-a3ea-42c8d0e177a8" from="2cd8ff3f-fd36-4508-cee5-44dd985618ab" to="eb4f0acf-99d5-4674-e386-822af5925a37">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="undefined"/>
				</Transition>
				<Transition id="54a013d0-67ff-491e-9a0e-d2875bc03084" from="eb4f0acf-99d5-4674-e386-822af5925a37" to="e3bfbd48-df18-4e8c-a02f-9ccdfb1c8e4d">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="undefined"/>
				</Transition>
				<Transition id="d90af13f-8dba-4685-ab95-1b7ca86ab40d" from="e3bfbd48-df18-4e8c-a02f-9ccdfb1c8e4d" to="fd77bbd7-daa9-46cf-9f35-34331482157b">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="undefined"/>
				</Transition>
				<Transition id="44e097e2-264c-4713-d631-19d2286405f1" from="d467834b-996c-42d7-fe27-1fff16d92460" to="2cd8ff3f-fd36-4508-cee5-44dd985618ab">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8459a01b-6326-4159-dc65-f337add34fcc" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups>
			<Group id="8459a01b-6326-4159-dc65-f337add34fcc" name="并行评审">
				<Geography parent="cdcff8db-d9ae-4509-96c8-b61efd01e521" style="verticalAlign=top;">
					<Widget left="490" top="130" width="232" height="100"/>
				</Geography>
			</Group>
		</Groups>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A80000C827E9 AS DateTime), CAST(0x0000A9E500D0CAAD AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (189, N'9f01fb9e-c72a-4def-8e45-d9a9bd4f0e26', N'1', N'ParallelSplitTest', N'ParallelSplitTest', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="b02a99df-e3e4-47f2-9ff4-6ca490ca278c" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="c99df58a-542a-40a3-d7f8-a3a4c2080d43" name="人事经理" code="hrmanager" outerId="3"/>
		<Participant type="Role" id="1506c72b-0013-4d99-8d7a-d2ee48a10289" name="部门经理" code="depmanager" outerId="2"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="ParallelSplitTest" id="9f01fb9e-c72a-4def-8e45-d9a9bd4f0e26">
			<Description>null</Description>
			<Activities>
				<Activity id="988a4e5a-6fc7-468f-e514-00966e42b576" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="110" top="190" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0e22cafc-abb3-4825-9ac4-ad6e05efb00d" name="提交" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="b02a99df-e3e4-47f2-9ff4-6ca490ca278c"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined">
						<Widget left="220" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="21d412a0-dbfc-4a0b-d258-c58fd27b5f43" name="gateway-split" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="350" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="76cf75f3-8d6d-4486-9f79-ed1c09219b57" name="HR审批" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c99df58a-542a-40a3-d7f8-a3a4c2080d43"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined">
						<Widget left="490" top="130" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ba847a8e-3115-4fc4-fdad-dc45f8f5c765" name="gateway-join" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="630" top="200" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c36beec2-b91d-49fa-8bd3-b0342f51cc52" name="归档" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c99df58a-542a-40a3-d7f8-a3a4c2080d43"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined">
						<Widget left="760" top="200" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a9597f0c-c64e-4bb1-d917-1ffe5469b781" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode"/>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="900" top="197" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="8b948ae5-04ff-48ab-c376-32d4529c0c03" name="部门经理审批" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="1506c72b-0013-4d99-8d7a-d2ee48a10289"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined">
						<Widget left="490" top="254" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="4d1714e8-0a26-4f8d-d234-c75a1cc7ce6b" from="988a4e5a-6fc7-468f-e514-00966e42b576" to="0e22cafc-abb3-4825-9ac4-ad6e05efb00d">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined"/>
				</Transition>
				<Transition id="d3e0b05c-61ee-4c98-f80c-54758366891f" from="0e22cafc-abb3-4825-9ac4-ad6e05efb00d" to="21d412a0-dbfc-4a0b-d258-c58fd27b5f43">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined"/>
				</Transition>
				<Transition id="d7030bf1-fa20-48e0-bb85-c52f61a7050f" from="21d412a0-dbfc-4a0b-d258-c58fd27b5f43" to="76cf75f3-8d6d-4486-9f79-ed1c09219b57">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined"/>
				</Transition>
				<Transition id="6f103e90-d49c-46eb-888e-377a5aa6141e" from="76cf75f3-8d6d-4486-9f79-ed1c09219b57" to="ba847a8e-3115-4fc4-fdad-dc45f8f5c765">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined"/>
				</Transition>
				<Transition id="26326356-9884-4fdf-ae12-7d968c3998d3" from="ba847a8e-3115-4fc4-fdad-dc45f8f5c765" to="c36beec2-b91d-49fa-8bd3-b0342f51cc52">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined"/>
				</Transition>
				<Transition id="05460cbf-4109-4935-c98c-3088f3ec208b" from="c36beec2-b91d-49fa-8bd3-b0342f51cc52" to="a9597f0c-c64e-4bb1-d917-1ffe5469b781">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined"/>
				</Transition>
				<Transition id="319c25d8-59f6-4920-faa8-977b2f2ce225" from="21d412a0-dbfc-4a0b-d258-c58fd27b5f43" to="8b948ae5-04ff-48ab-c376-32d4529c0c03">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined"/>
				</Transition>
				<Transition id="ba7503ec-0d9b-4c1a-9f46-7398aa8afade" from="8b948ae5-04ff-48ab-c376-32d4529c0c03" to="ba847a8e-3115-4fc4-fdad-dc45f8f5c765">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="9e441376-d432-47e4-dfbe-28a8bbcd79e0" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, NULL, CAST(0x0000A8020151BADD AS DateTime), CAST(0x0000A8030093C525 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (190, N'68696ea3-00ab-4b40-8fcf-9859dbbde378', N'1', N'入库流程(AndSplitAndJoin)', N'StockInProcess', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="41b3619c-fe14-4eb4-bd70-7e37c94571ae" name="仓库" code="Role_QT" outerId="25"/>
		<Participant type="Role" id="c400a31a-9973-44a4-b0bb-6fe88e6b092a" name="综合部" code="Role_Finance_Manager" outerId="36"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="入库流程(AndSplitAndJoin)" id="68696ea3-00ab-4b40-8fcf-9859dbbde378">
			<Description>null</Description>
			<Activities>
				<Activity id="e3c8830d-290b-4c1f-bc6d-0e0e78eb0bbf" name="开始" code="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="40" top="228" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c8a6ab46-06ab-485c-a5bc-d6f18db5c2bc" name="仓库签字" code="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="41b3619c-fe14-4eb4-bd70-7e37c94571ae"/>
					</Performers>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined">
						<Widget left="170" top="228" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a44d219c-c60e-468c-b5ab-3f5159ac24a4" name="And分支节点" code="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="320" top="228" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e60084e4-517a-4892-a290-517159f1b7f4" name="综合部签字" code="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c400a31a-9973-44a4-b0bb-6fe88e6b092a"/>
					</Performers>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined">
						<Widget left="514" top="180" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ce3343b6-930d-4962-a2b9-2c4c4b2dab06" name="财务部签字" code="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c400a31a-9973-44a4-b0bb-6fe88e6b092a"/>
					</Performers>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined">
						<Widget left="514" top="272" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="10c7be47-c556-45ad-9db3-696160a3888a" name="And合并节点" code="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="680" top="224" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0fdff3c0-be97-43d6-b4ff-90d52efb5d6f" name="总经理签字" code="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c400a31a-9973-44a4-b0bb-6fe88e6b092a"/>
					</Performers>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined">
						<Widget left="800" top="224" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="76f7ef75-b538-40c8-b529-0849ca777b94" name="结束" code="null">
					<Description></Description>
					<ActivityType type="EndNode"/>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="800" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="a13fbc66-7e62-4dea-a4e6-ea094a231ef6" from="e3c8830d-290b-4c1f-bc6d-0e0e78eb0bbf" to="c8a6ab46-06ab-485c-a5bc-d6f18db5c2bc">
					<Description></Description>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined"/>
				</Transition>
				<Transition id="8dfbbbb7-674f-420a-99cb-5eefb53efbf2" from="c8a6ab46-06ab-485c-a5bc-d6f18db5c2bc" to="a44d219c-c60e-468c-b5ab-3f5159ac24a4">
					<Description></Description>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined"/>
				</Transition>
				<Transition id="7b4e4be7-a74d-4a8b-b2ce-bb367b0186be" from="a44d219c-c60e-468c-b5ab-3f5159ac24a4" to="ce3343b6-930d-4962-a2b9-2c4c4b2dab06">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[surplus != "正常"]]>
						</ConditionText>
					</Condition>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined"/>
				</Transition>
				<Transition id="df3ba298-3f28-4b30-983e-5a5c10bf19a6" from="a44d219c-c60e-468c-b5ab-3f5159ac24a4" to="e60084e4-517a-4892-a290-517159f1b7f4">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[surplus == "超量"]]>
						</ConditionText>
					</Condition>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined"/>
				</Transition>
				<Transition id="280a25b7-3175-40ef-af80-0e6c7f13e019" from="ce3343b6-930d-4962-a2b9-2c4c4b2dab06" to="10c7be47-c556-45ad-9db3-696160a3888a">
					<Description></Description>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined"/>
				</Transition>
				<Transition id="c6170a27-8b54-41e9-84e5-d89e5820b30f" from="e60084e4-517a-4892-a290-517159f1b7f4" to="10c7be47-c556-45ad-9db3-696160a3888a">
					<Description></Description>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined"/>
				</Transition>
				<Transition id="9ba78022-6dbf-4245-97de-04a42013f3e9" from="10c7be47-c556-45ad-9db3-696160a3888a" to="0fdff3c0-be97-43d6-b4ff-90d52efb5d6f">
					<Description></Description>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined"/>
				</Transition>
				<Transition id="f395dcc2-c4ae-42c2-a6fb-e0cd21ff8e7c" from="0fdff3c0-be97-43d6-b4ff-90d52efb5d6f" to="76f7ef75-b538-40c8-b529-0849ca777b94">
					<Description></Description>
					<Geography parent="a6fb4a95-6079-4092-8b2c-cad762a3df79" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, NULL, CAST(0x0000A80400AD0481 AS DateTime), CAST(0x0000A80800B21122 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (198, N'805a2af4-5196-4461-8b94-ec57714dfd9d', N'1', N'子流程Main(SubProcessMain)', N'SubprocessMain', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="dbb4dcfd-a288-4bc6-a2ba-0288dcd51ea3" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="f137400d-0659-4a92-e433-9868d0411279" name="testrole" code="testrole" outerId="21"/>
		<Participant type="Role" id="89e87b2b-6c39-43f3-c647-2a968f1899c1" name="人事经理" code="hrmanager" outerId="3"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="子流程Main(SubProcessMain)" id="805a2af4-5196-4461-8b94-ec57714dfd9d">
			<Description>null</Description>
			<Activities>
				<Activity id="39778075-73b1-43ed-d49f-da9c2e26d58c" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="100" top="195" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f8de1810-2db4-4f9d-fea1-2b6d33d02c24" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null"/>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="712" top="192" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="1122ea0a-6c06-42f7-9b2f-72c1ddea38a5" name="申请" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="dbb4dcfd-a288-4bc6-a2ba-0288dcd51ea3"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="undefined">
						<Widget left="230" top="195" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1689ba04-cebc-4ae3-d7af-2075b81f99c4" name="财务内部审批子流程" code="" url="null">
					<Description></Description>
					<ActivityType type="SubProcessNode" subId="f0782fc8-43f1-4520-bed9-f37fcbdede99"/>
					<Performers>
						<Performer id="f137400d-0659-4a92-e433-9868d0411279"/>
					</Performers>
					<Actions>
						<Action type="null"/>
					</Actions>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="rounded">
						<Widget left="400" top="195" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a89e17ef-e213-4d2d-d4d1-20dcec40d6c2" name="归档" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="89e87b2b-6c39-43f3-c647-2a968f1899c1"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="undefined">
						<Widget left="560" top="195" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="dc8f24ea-c33c-4bce-c8eb-d2f66edfa64d" from="39778075-73b1-43ed-d49f-da9c2e26d58c" to="1122ea0a-6c06-42f7-9b2f-72c1ddea38a5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="undefined"/>
				</Transition>
				<Transition id="cee2428c-7fd1-4864-db3d-585df2bb39a4" from="1122ea0a-6c06-42f7-9b2f-72c1ddea38a5" to="1689ba04-cebc-4ae3-d7af-2075b81f99c4">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="undefined"/>
				</Transition>
				<Transition id="32e5ddd3-cf50-4843-d49c-e46a68737361" from="1689ba04-cebc-4ae3-d7af-2075b81f99c4" to="a89e17ef-e213-4d2d-d4d1-20dcec40d6c2">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="undefined"/>
				</Transition>
				<Transition id="9c371cfd-d68d-44bb-8258-6b6cb729fe42" from="a89e17ef-e213-4d2d-d4d1-20dcec40d6c2" to="f8de1810-2db4-4f9d-fea1-2b6d33d02c24">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="dd12eb8a-4bbe-45b3-9263-69d3c574724b" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000A83F00FABAF1 AS DateTime), CAST(0x0000AA840143BF50 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (199, N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'1', N'子流程Inter(SubProcess)', N'InterSubProcess', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="a23858bf-9761-4090-d52a-acaa7042fddb" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="4bd70ef2-55b3-4e1e-d830-c20fb375764a" name="部门总监" code="lll" outerId="2"/>
		<Participant type="Role" id="5ad32fc2-3eb8-41a2-c8d0-d7fc492ea5aa" name="打样员(Tech)" code="techmate" outerId="10"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="子流程Inter(SbuProcess)" id="f0782fc8-43f1-4520-bed9-f37fcbdede99">
			<Description>null</Description>
			<Activities>
				<Activity id="5df97972-5296-4192-b1a8-4d16c946590f" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="170" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3d5cc2f8-2528-419b-a1ee-00d45ff2101a" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null"/>
					<Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="660" top="230" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1" name="提交申请" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="5ad32fc2-3eb8-41a2-c8d0-d7fc492ea5aa"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined">
						<Widget left="310" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="498222f9-5b4c-46d3-b6df-878db77d4f77" name="审批" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="4bd70ef2-55b3-4e1e-d830-c20fb375764a"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined">
						<Widget left="480" top="214" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="7729a977-a90c-4609-f2f3-0671dfcb4e7d" from="5df97972-5296-4192-b1a8-4d16c946590f" to="dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined"/>
				</Transition>
				<Transition id="1196dad5-2635-48e7-e972-58ab81661c21" from="dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1" to="498222f9-5b4c-46d3-b6df-878db77d4f77">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined"/>
				</Transition>
				<Transition id="ac9f6a7b-fd1d-4653-918d-d4a3659113fb" from="498222f9-5b4c-46d3-b6df-878db77d4f77" to="3d5cc2f8-2528-419b-a1ee-00d45ff2101a">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000A83F00F9EBF2 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (201, N'57de0623-d1a9-491d-915c-ea2c37d7a261', N'1', N'消息流程', N'MessageProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="57de0623-d1a9-491d-915c-ea2c37d7a261" name="消息流程" code="MessageProcess" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="72fffe33-876e-4940-ef74-26de6538c663" name="消息结束" code="MJT2L0" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="Message" expression="null"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/message_end.png">
						<Widget left="750" top="210" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ac0e96f5-9b2b-4bab-966f-36ac153c404d" name="提交" code="MBZO54" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="undefined">
						<Widget left="300" top="210" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e994eb64-1205-44de-9966-5a68b215774d" name="中间事件" code="T97RLP" url="null">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None" expression="null"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="446" top="210" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="68b3721b-a6f3-4b8e-8030-b912c47e13d8" name="审核" code="KNNJKT" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="undefined">
						<Widget left="570" top="210" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="569fc8de-c9e2-402f-f2fb-0d397683215b" name="MessageStart" code="Z3EWNE" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="Message" expression="message-process-start-001"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_start.png">
						<Widget left="170" top="210" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="208b98f4-360e-429f-ac5d-233119e2b8f3" from="ac0e96f5-9b2b-4bab-966f-36ac153c404d" to="e994eb64-1205-44de-9966-5a68b215774d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="undefined"/>
				</Transition>
				<Transition id="6a0f2c12-9618-41f9-901c-ce35ffd691a3" from="e994eb64-1205-44de-9966-5a68b215774d" to="68b3721b-a6f3-4b8e-8030-b912c47e13d8">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="undefined"/>
				</Transition>
				<Transition id="1515562e-52ba-4685-fc53-219c07d8a692" from="68b3721b-a6f3-4b8e-8030-b912c47e13d8" to="72fffe33-876e-4940-ef74-26de6538c663">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="undefined"/>
				</Transition>
				<Transition id="88e96cc0-c4b6-488a-d06d-19a52fb2145e" from="569fc8de-c9e2-402f-f2fb-0d397683215b" to="ac0e96f5-9b2b-4bab-966f-36ac153c404d">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="59267e91-2ef1-4354-fe5d-8bf339e404b9" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                      ', 2, N'message-process-start-001', N'', 2, N'null', CAST(0x0000A8DB00F20F91 AS DateTime), CAST(0x0000ABAF00AA4453 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (203, N'40887a03-0c04-45ed-b086-8ab724446e6c', N'1', N'管线现场验收流程', N'LinesCheckInProcess', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="管线现场验收流程" id="40887a03-0c04-45ed-b086-8ab724446e6c">
			<Description>null</Description>
			<Activities>
				<Activity id="4bc7d93a-163e-4f78-a8fd-2a0548b26eb4" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="40" top="206" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d3db5f9c-5a55-43d7-9a74-07c3dbbcf20a" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="550" top="422" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b761cc30-9707-4aa4-c858-f00c6e8bb8f8" name="施工单位录入" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Widget left="150" top="197" width="120" height="50"/>
					</Geography>
				</Activity>
				<Activity id="b80d07e4-e17b-4933-e1a5-60ccdbfef09b" name="监理单位审核" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Widget left="350" top="198" width="130" height="48"/>
					</Geography>
				</Activity>
				<Activity id="ab7ba705-ab79-4097-b8e5-9ea6f3db0318" name="指定验收人" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Widget left="690" top="198" width="120" height="50"/>
					</Geography>
				</Activity>
				<Activity id="69f1e4a5-c153-4946-8afd-c5f96b37b0f8" name="验收人员验收" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Widget left="881" top="197" width="110" height="50"/>
					</Geography>
				</Activity>
				<Activity id="7f908685-59f5-46ac-c89f-b9b9ebb43ff7" name="验收是否通过" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection=""/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1066" top="206" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d0ddba43-06b3-4642-d5d8-4d4bccf12a0f" name="验收人员录入" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Widget left="1057" top="336" width="90" height="50"/>
					</Geography>
				</Activity>
				<Activity id="6f1aa6e9-cc47-48d9-d1c7-cf2f7c5472da" name="验收数据比对" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Widget left="1057" top="413" width="90" height="50"/>
					</Geography>
				</Activity>
				<Activity id="4e8544e6-14a3-4bb0-d0e3-467af0f0ecf1" name="比对是否通过" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection=""/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="919" top="422" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="99682336-d927-4fef-8a12-6d7a25fa4342" name="资料入库" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Widget left="720" top="413" width="102" height="50"/>
					</Geography>
				</Activity>
				<Activity id="f80de27e-35a2-441e-dd67-1ba34a4c56f3" name="审核是否同意" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection=""/>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="566" top="206" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="a29b592b-9225-459c-9aad-a11b9ddbb008" from="4bc7d93a-163e-4f78-a8fd-2a0548b26eb4" to="b761cc30-9707-4aa4-c858-f00c6e8bb8f8">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="34d62e7d-c57a-4d48-81ca-1bf53f4439bf" from="b761cc30-9707-4aa4-c858-f00c6e8bb8f8" to="b80d07e4-e17b-4933-e1a5-60ccdbfef09b">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="d6cac8f9-d241-4d00-ed78-7a2469370a47" from="b80d07e4-e17b-4933-e1a5-60ccdbfef09b" to="f80de27e-35a2-441e-dd67-1ba34a4c56f3">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="4890e1ee-fa32-4e03-d027-d76684f42eca" from="f80de27e-35a2-441e-dd67-1ba34a4c56f3" to="ab7ba705-ab79-4097-b8e5-9ea6f3db0318">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="1839f64e-1e6c-4601-e1bc-13444cc639f9" from="ab7ba705-ab79-4097-b8e5-9ea6f3db0318" to="69f1e4a5-c153-4946-8afd-c5f96b37b0f8">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="82a29efc-b3c3-47df-dccf-74fb8b62dc1f" from="69f1e4a5-c153-4946-8afd-c5f96b37b0f8" to="7f908685-59f5-46ac-c89f-b9b9ebb43ff7">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="3d135530-cb16-4b8d-dad2-dd66a5ae8628" from="7f908685-59f5-46ac-c89f-b9b9ebb43ff7" to="d0ddba43-06b3-4642-d5d8-4d4bccf12a0f">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="412c4c63-1db9-4663-fa91-bcd7c8b98eb1" from="d0ddba43-06b3-4642-d5d8-4d4bccf12a0f" to="6f1aa6e9-cc47-48d9-d1c7-cf2f7c5472da">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="58e81131-ed08-447d-cc80-86f5bea219f5" from="6f1aa6e9-cc47-48d9-d1c7-cf2f7c5472da" to="4e8544e6-14a3-4bb0-d0e3-467af0f0ecf1">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="03b953d3-4d95-44e7-c028-cf81f177b5de" from="4e8544e6-14a3-4bb0-d0e3-467af0f0ecf1" to="d0ddba43-06b3-4642-d5d8-4d4bccf12a0f">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="541977ce-843a-4f02-ab58-206e038a1e07" from="99682336-d927-4fef-8a12-6d7a25fa4342" to="d3db5f9c-5a55-43d7-9a74-07c3dbbcf20a">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="2ba00b28-1591-4168-b9d8-27376499f2f5" from="4e8544e6-14a3-4bb0-d0e3-467af0f0ecf1" to="99682336-d927-4fef-8a12-6d7a25fa4342">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined"/>
				</Transition>
				<Transition id="01a3d747-1c30-452a-cc90-fd1e440d00a6" from="f80de27e-35a2-441e-dd67-1ba34a4c56f3" to="b761cc30-9707-4aa4-c858-f00c6e8bb8f8">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Points>
							<Point x="430" y="120"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="3d8e52ef-79e9-4700-c13d-dd02cc6c133e" from="7f908685-59f5-46ac-c89f-b9b9ebb43ff7" to="b761cc30-9707-4aa4-c858-f00c6e8bb8f8">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="4eded741-590e-4748-b2da-2ac464c391c1" style="undefined">
						<Points>
							<Point x="660" y="310"/>
						</Points>
					</Geography>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, NULL, CAST(0x0000A8F000ECBAAA AS DateTime), CAST(0x0000A8F10188925D AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (205, N'5c3e266b-de4d-4e07-b12a-6dbbab157dc8', N'1', N'泳道图', N'SwimLanProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="泳道图" id="5c3e266b-de4d-4e07-b12a-6dbbab157dc8">
			<Description></Description>
			<Activities>
				<Activity id="eba58fd1-95b6-42c6-c3d3-576f5f4e0ea4" name="接订单" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a967ca67-4b92-44f0-b021-78e03bee8337" style="undefined">
						<Widget left="120" top="10" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="343dd3a9-2180-4bc8-f673-320c0fd6cc2f" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="a967ca67-4b92-44f0-b021-78e03bee8337" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="10" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="eba58fd1-95b6-42c6-c3d3-576f5f4e0ea4" name="接订单" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a967ca67-4b92-44f0-b021-78e03bee8337" style="undefined">
						<Widget left="120" top="10" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="343dd3a9-2180-4bc8-f673-320c0fd6cc2f" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="a967ca67-4b92-44f0-b021-78e03bee8337" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="10" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1ffdef56-5570-49be-c874-f45485a2da70" name="加工产品" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8575e0e6-dace-43a9-eb3d-355e521f1380" style="undefined">
						<Widget left="220" top="9" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1ffdef56-5570-49be-c874-f45485a2da70" name="加工产品" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8575e0e6-dace-43a9-eb3d-355e521f1380" style="undefined">
						<Widget left="220" top="9" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="44708a3d-e787-43e9-9dae-d426b48eca76" name="发货" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="15e428dd-5d81-4f9c-9d4d-77be036d6936" style="undefined">
						<Widget left="340" top="14" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0d19cc94-0c03-4c90-afb1-7d877d66ca59" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="15e428dd-5d81-4f9c-9d4d-77be036d6936" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="440" top="14" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="44708a3d-e787-43e9-9dae-d426b48eca76" name="发货" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="15e428dd-5d81-4f9c-9d4d-77be036d6936" style="undefined">
						<Widget left="340" top="14" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0d19cc94-0c03-4c90-afb1-7d877d66ca59" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="15e428dd-5d81-4f9c-9d4d-77be036d6936" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="440" top="14" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="bc664e63-3bfd-4700-af45-017c1dfa5f60" from="eba58fd1-95b6-42c6-c3d3-576f5f4e0ea4" to="1ffdef56-5570-49be-c874-f45485a2da70">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="72f56f27-17b2-4f9f-c102-14d4e690dd50" style="null"/>
				</Transition>
				<Transition id="5de805c9-6ef5-46f1-fdbc-aa46817150b0" from="1ffdef56-5570-49be-c874-f45485a2da70" to="44708a3d-e787-43e9-9dae-d426b48eca76">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="72f56f27-17b2-4f9f-c102-14d4e690dd50" style="null"/>
				</Transition>
				<Transition id="d8daac62-67a7-4a3b-c721-c33026f48160" from="343dd3a9-2180-4bc8-f673-320c0fd6cc2f" to="eba58fd1-95b6-42c6-c3d3-576f5f4e0ea4">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="a967ca67-4b92-44f0-b021-78e03bee8337" style="null"/>
				</Transition>
				<Transition id="19ea819d-f250-435e-f200-897275915f80" from="44708a3d-e787-43e9-9dae-d426b48eca76" to="0d19cc94-0c03-4c90-afb1-7d877d66ca59">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="15e428dd-5d81-4f9c-9d4d-77be036d6936" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes>
			<Swimlane id="a967ca67-4b92-44f0-b021-78e03bee8337" name="销售部">
				<Geography parent="72f56f27-17b2-4f9f-c102-14d4e690dd50" style="swimlane;fillColor=#808913;startSize=28;">
					<Widget left="180" top="140" width="490" height="60"/>
				</Geography>
			</Swimlane>
			<Swimlane id="8575e0e6-dace-43a9-eb3d-355e521f1380" name="工程部">
				<Geography parent="72f56f27-17b2-4f9f-c102-14d4e690dd50" style="swimlane;fillColor=#CF0056;startSize=28;">
					<Widget left="180" top="240" width="490" height="60"/>
				</Geography>
			</Swimlane>
			<Swimlane id="15e428dd-5d81-4f9c-9d4d-77be036d6936" name="物流部">
				<Geography parent="72f56f27-17b2-4f9f-c102-14d4e690dd50" style="swimlane;fillColor=#4679B6;startSize=28;">
					<Widget left="180" top="330" width="490" height="70"/>
				</Geography>
			</Swimlane>
		</Swimlanes>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, NULL, CAST(0x0000A905008C0C4F AS DateTime), CAST(0x0000A905008D3979 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (209, N'16b14c1d-ff58-4401-ab97-22f7f11eb834', N'1', N'预算编制流程', N'BudgetPlanProcess', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="55f292ef-8a93-4486-eb9f-b555233c0caf" name="办公室财务" code="bgscw" outerId="23"/>
		<Participant type="Role" id="5ffc9c14-6893-4212-c809-a194cb80865d" name="质量管理科-预算专管员" code="ZlglkYszgy" outerId="28"/>
		<Participant type="Role" id="32eb5594-2085-4f45-9d87-98e75cf4787d" name="技术信息科-预算专管员" code="JsxxkYszgy" outerId="33"/>
		<Participant type="Role" id="d92ad957-9331-480d-d646-9f52df54c0d1" name="办公室(党委办公室)-预算专管员" code="DwbgsYszgy" outerId="72"/>
		<Participant type="Role" id="70df87e7-c5dd-4d74-9edc-c6ed929131cd" name="质量管理科-科长" code="ZlglkKz" outerId="27"/>
		<Participant type="Role" id="e00cf100-8d91-4bbb-b14f-2caf0a394302" name="质量管理科-分管领导" code="ZlglkFgld" outerId="26"/>
		<Participant type="Role" id="6cdd3787-6ba6-43fe-8bf3-93f8ffb57c59" name="技术信息科-科长" code="JsxxkKz" outerId="32"/>
		<Participant type="Role" id="e4e5cd2d-07d4-45fd-9097-2b8d9a770443" name="技术信息科-分管领导" code="JsxxkFgld" outerId="31"/>
		<Participant type="Role" id="89841534-fe04-4857-c472-53a92873ca58" name="办公室(党委办公室)-科长" code="DwbgsKz" outerId="71"/>
		<Participant type="Role" id="91493884-54f8-4de0-d02d-25d5cdc86e26" name="财务主管" code="cwzg" outerId="16"/>
		<Participant type="Role" id="ab4e542a-c813-4a5a-9242-8bb510318007" name="站长" code="ZhanZhang" outerId="25"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="预算编制流程" id="16b14c1d-ff58-4401-ab97-22f7f11eb834">
			<Description>null</Description>
			<Activities>
				<Activity id="1d71d085-6e35-418a-f9fb-3f6c5fdfe47d" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="-10" top="286" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6173ec0f-f94f-4458-fd91-d99f40c68bf3" name="办公室财务" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="7d45ca14-0ae5-48bc-caea-de49cb1a242d"/>
						<Performer id="55f292ef-8a93-4486-eb9f-b555233c0caf"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="48" top="286" width="82" height="32"/>
					</Geography>
				</Activity>
				<Activity id="53fc6152-fd4d-48a1-8998-2238d94f39f2" name="" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/>
					<Actions>
						<Action type="" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="168" top="286" width="40" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b9f2f47a-df5b-40c8-bdf0-458d8d3f4cf7" name="质量管理科经办人" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="a34ba481-6eea-4b2f-d96f-4adf552fb6ec"/>
						<Performer id="5ffc9c14-6893-4212-c809-a194cb80865d"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="258" top="188" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8e547292-dd52-41d8-bae9-90893982ae16" name="技术信息科经办人" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="5c6abfe1-0309-4939-f473-4970971aa0a1"/>
						<Performer id="32eb5594-2085-4f45-9d87-98e75cf4787d"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="258" top="270" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0b578579-1419-419a-d7fc-2aed5e1b3976" name="办公室（党委办公室）经办人" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="e2f92580-c5bd-47c6-ea2a-3ac228192297"/>
						<Performer id="d92ad957-9331-480d-d646-9f52df54c0d1"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="262" top="366" width="160" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1eeeebd5-f256-4ff5-e94f-325bb5117236" name="质量管理科科长" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="7b809a71-c0c2-4680-d5b0-b773b7bef4a5"/>
						<Performer id="70df87e7-c5dd-4d74-9edc-c6ed929131cd"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="378" top="188" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0ac62d64-09a9-4e6e-a0a1-4215368d16e3" name="质量管理科分管领导" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="e8dc4dea-8b09-4940-b55f-ec9aa5e27b6e"/>
						<Performer id="e00cf100-8d91-4bbb-b14f-2caf0a394302"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="498" top="188" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7f28be4a-db4a-4693-d4bc-5bda5c848089" name="技术信息科科长" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="9b93d1a8-2400-4e9f-e978-179c77a30971"/>
						<Performer id="6cdd3787-6ba6-43fe-8bf3-93f8ffb57c59"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="378" top="270" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a4204248-14b4-40fc-c040-c1d2d8909e47" name="技术信息科分管领导" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="d94a490e-dc44-4999-9895-d11fc69566d8"/>
						<Performer id="e4e5cd2d-07d4-45fd-9097-2b8d9a770443"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="498" top="270" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8fa76b08-b414-489b-d205-374d69641eaa" name="办公室（党委办公室）主任" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="1b912cc1-348a-49a4-8f7f-c7bddf9a16c4"/>
						<Performer id="89841534-fe04-4857-c472-53a92873ca58"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="442" top="366" width="132" height="32"/>
					</Geography>
				</Activity>
				<Activity id="16e73104-8d4a-44a7-a84f-74bccbcae841" name="" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin"/>
					<Actions>
						<Action type="" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="638" top="286" width="40" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0bb4697c-a43e-4a9b-c007-8e8d41f97fdb" name="财务主管" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bc9d1fbd-6bc2-4d8e-8934-7362bd2f59ec"/>
						<Performer id="91493884-54f8-4de0-d02d-25d5cdc86e26"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="718" top="286" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1b91de4b-a80d-468d-f5d0-d6fe5d30a747" name="站长" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="f1a1fdc7-9fa3-4763-ba7e-95a99ec9cfd8"/>
						<Performer id="ab4e542a-c813-4a5a-9242-8bb510318007"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined">
						<Widget left="828" top="286" width="50" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bcbe6f95-8f8c-46b4-e999-7b8966e3d9cd" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="918" top="286" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="93cbcefa-57c7-4856-fadf-5f520fe3e117" from="1d71d085-6e35-418a-f9fb-3f6c5fdfe47d" to="6173ec0f-f94f-4458-fd91-d99f40c68bf3">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="e63b44e1-a9c9-49b6-d13b-d75f9cd28147" from="6173ec0f-f94f-4458-fd91-d99f40c68bf3" to="53fc6152-fd4d-48a1-8998-2238d94f39f2">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="db8fd716-e9d2-45e6-9a4d-7a2b969be528" from="53fc6152-fd4d-48a1-8998-2238d94f39f2" to="b9f2f47a-df5b-40c8-bdf0-458d8d3f4cf7">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="7aa132d7-f3d9-4f2b-abe5-cc54bc1655fd" from="53fc6152-fd4d-48a1-8998-2238d94f39f2" to="8e547292-dd52-41d8-bae9-90893982ae16">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="7140a103-1118-479b-d9a4-5bfc492795f1" from="53fc6152-fd4d-48a1-8998-2238d94f39f2" to="0b578579-1419-419a-d7fc-2aed5e1b3976">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="664bdb8a-f77b-4af3-d139-a005b689106c" from="b9f2f47a-df5b-40c8-bdf0-458d8d3f4cf7" to="1eeeebd5-f256-4ff5-e94f-325bb5117236">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="ce0dc846-0359-46c3-bb40-5f45e32c6b93" from="1eeeebd5-f256-4ff5-e94f-325bb5117236" to="0ac62d64-09a9-4e6e-a0a1-4215368d16e3">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="b56cbfba-3f72-40f7-cfa0-bcd9139bdfad" from="8e547292-dd52-41d8-bae9-90893982ae16" to="7f28be4a-db4a-4693-d4bc-5bda5c848089">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="aa918811-ee29-4a75-b8cc-a51216558786" from="7f28be4a-db4a-4693-d4bc-5bda5c848089" to="a4204248-14b4-40fc-c040-c1d2d8909e47">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="fe49e558-9c82-4897-8453-8a904724764a" from="0ac62d64-09a9-4e6e-a0a1-4215368d16e3" to="16e73104-8d4a-44a7-a84f-74bccbcae841">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="846ad5bf-66d4-42da-f7e0-16a7cbbd6655" from="a4204248-14b4-40fc-c040-c1d2d8909e47" to="16e73104-8d4a-44a7-a84f-74bccbcae841">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="b19d8851-879f-4b6c-ccff-85e19fe7cd55" from="8fa76b08-b414-489b-d205-374d69641eaa" to="16e73104-8d4a-44a7-a84f-74bccbcae841">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="5d0c1315-04fa-4fe5-c2c7-777cedf6ac50" from="16e73104-8d4a-44a7-a84f-74bccbcae841" to="0bb4697c-a43e-4a9b-c007-8e8d41f97fdb">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="438844dc-8759-472b-af15-e62fed6f819d" from="0bb4697c-a43e-4a9b-c007-8e8d41f97fdb" to="1b91de4b-a80d-468d-f5d0-d6fe5d30a747">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="671a9f44-62e0-48a0-cd6f-dc4a013afa89" from="1b91de4b-a80d-468d-f5d0-d6fe5d30a747" to="bcbe6f95-8f8c-46b4-e999-7b8966e3d9cd">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
				<Transition id="d635cd44-0999-4f1b-9c14-449488dd5872" from="0b578579-1419-419a-d7fc-2aed5e1b3976" to="8fa76b08-b414-489b-d205-374d69641eaa">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c88056b4-fd2c-424f-f0ca-cdfffc73086e" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000A97701152302 AS DateTime), CAST(0x0000A98101493532 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (210, N'ca9ac4a1-a8a8-4951-9dd5-0279e9819549', N'1', N'thtest', N'thtestProcess', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="thtest" id="ca9ac4a1-a8a8-4951-9dd5-0279e9819549">
			<Description>null</Description>
			<Activities>
				<Activity id="c1fc4f24-6d9d-47c8-ad5d-3af6639706e2" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="480" top="-14" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="dbf57c47-08b7-4267-fa6d-c9afa706a54a" name="分配" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Widget left="460" top="46" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="933ebe57-97c1-4efa-a39b-b8b916184ca9" name="OR" code="">
					<Description>或分支</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="460" top="116" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3f2687d1-ba3b-4eaa-d784-48a721e4a701" name="组长" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Widget left="460" top="192" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f7554678-6ac0-4191-94a8-e972a73b44f9" name="AND" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="460" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5ab4b1fc-a06f-4915-af19-a91e037b1347" name="检验员A录入" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Widget left="294" top="306" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="737a7fd9-a906-448f-ad7c-c25589d84843" name="检验员B录入" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Widget left="640" top="300" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6fa396e7-3ad1-4e3a-c26f-3e35b0bbf8dc" name="AND合并" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="469" top="462" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="add7255e-1477-4cfd-97e3-991b9afe4974" name="小组审核" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Widget left="469" top="530" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="df69f554-c388-42cf-93d2-c1d9842bdd60" name="报告合成" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Widget left="469" top="692" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="dc27d4f9-e3b4-4975-8f78-6c668e552c17" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="486" top="746" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="77656a77-5829-4b43-b607-0cf37ddd7189" name="OR" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="780" top="300" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ea4981a0-4cd3-47a9-b94b-97e88a94c964" name="OR" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="469" top="596" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="36520892-0f3b-497a-eb7e-646cb7ef1129" from="c1fc4f24-6d9d-47c8-ad5d-3af6639706e2" to="dbf57c47-08b7-4267-fa6d-c9afa706a54a">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="58b73582-419d-4d1c-e36d-33371a2ff13c" from="dbf57c47-08b7-4267-fa6d-c9afa706a54a" to="933ebe57-97c1-4efa-a39b-b8b916184ca9">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="3653731e-77d0-4546-a630-981a08007785" from="933ebe57-97c1-4efa-a39b-b8b916184ca9" to="3f2687d1-ba3b-4eaa-d784-48a721e4a701">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Distribution == "true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="1a3a2261-5830-44b6-97bd-ee4ae8b81621" from="933ebe57-97c1-4efa-a39b-b8b916184ca9" to="df69f554-c388-42cf-93d2-c1d9842bdd60">
					<Description>直接合成报告</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Distribution == "false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Points>
							<Point x="210" y="420"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="07aba86a-3058-48da-fd12-651577c9f804" from="3f2687d1-ba3b-4eaa-d784-48a721e4a701" to="f7554678-6ac0-4191-94a8-e972a73b44f9">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="79ed5264-4f33-40b1-b20f-a157618e6a03" from="f7554678-6ac0-4191-94a8-e972a73b44f9" to="5ab4b1fc-a06f-4915-af19-a91e037b1347">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="3e5acc25-5626-4907-d05b-3b6f7104393b" from="f7554678-6ac0-4191-94a8-e972a73b44f9" to="737a7fd9-a906-448f-ad7c-c25589d84843">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="6444a576-f9fc-4eec-e5ca-6def167d8c43" from="5ab4b1fc-a06f-4915-af19-a91e037b1347" to="6fa396e7-3ad1-4e3a-c26f-3e35b0bbf8dc">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="ec10fb65-49c7-4d0c-b3fd-551ecc3e31fa" from="77656a77-5829-4b43-b607-0cf37ddd7189" to="6fa396e7-3ad1-4e3a-c26f-3e35b0bbf8dc">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[GoToChcek == "true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Points>
							<Point x="816" y="440"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="a67a3e8f-ca56-42e4-e608-a7cd87a3339f" from="6fa396e7-3ad1-4e3a-c26f-3e35b0bbf8dc" to="add7255e-1477-4cfd-97e3-991b9afe4974">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="e326be73-386e-4c57-a4e3-d57d928b35e2" from="ea4981a0-4cd3-47a9-b94b-97e88a94c964" to="df69f554-c388-42cf-93d2-c1d9842bdd60">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[GoToReportMake == "true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="d7fc6032-ed05-4065-d077-25dc2b678ee0" from="df69f554-c388-42cf-93d2-c1d9842bdd60" to="dc27d4f9-e3b4-4975-8f78-6c668e552c17">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="94f4c969-2a64-4bf0-a14b-8cfb54fe5cde" from="737a7fd9-a906-448f-ad7c-c25589d84843" to="77656a77-5829-4b43-b607-0cf37ddd7189">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Points/>
					</Geography>
				</Transition>
				<Transition id="5ff77c9a-2052-406f-aaab-7f5ac8fad29b" from="77656a77-5829-4b43-b607-0cf37ddd7189" to="3f2687d1-ba3b-4eaa-d784-48a721e4a701">
					<Description>退回组长</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[GoToChcek == "false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined">
						<Points>
							<Point x="816" y="290"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="79084c92-e2a8-4d4a-eca7-e5cd3aee1ec4" from="add7255e-1477-4cfd-97e3-991b9afe4974" to="ea4981a0-4cd3-47a9-b94b-97e88a94c964">
					<Description></Description>
					<Receiver/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
				<Transition id="135394e6-f294-4a96-ef9b-bf1c15c625a8" from="ea4981a0-4cd3-47a9-b94b-97e88a94c964" to="737a7fd9-a906-448f-ad7c-c25589d84843">
					<Description>退回检验员B</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[GoToReportMake == "false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="812133cc-5333-47b5-e2a1-ff2bb38703ef" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000A97A00F98698 AS DateTime), CAST(0x0000A97A00FA9A1A AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (211, N'c9b22142-e376-4725-a920-0db3d41c89ef', N'1', N'汇聚后再退回测试流程', N'JoinSendBackProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="汇聚后再退回测试流程" id="c9b22142-e376-4725-a920-0db3d41c89ef">
			<Description>null</Description>
			<Activities>
				<Activity id="883289f5-c333-4eb5-a2d1-82a92dbfb4e9" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="98" top="220" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fb4feac1-3f07-4550-8924-3b69cc1f931c" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="860" top="220" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e83d069e-931a-40a1-b3fe-964cb76a0574" name="Task01" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined">
						<Widget left="200" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8521b916-712f-407c-86c6-f36c23638316" name="gateway-split" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="330" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a3830a62-80f4-4c85-8b81-f7a194b677ee" name="gateway-join" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="600" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a4d2c206-9a8e-4735-d1d3-287bfb0bd46c" name="Task02" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined">
						<Widget left="450" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="81df662b-15b8-45ae-be95-b2b3235678d5" name="Task03" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined">
						<Widget left="450" top="300" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="00f2d27d-7d8b-4f01-d135-8135b194b7a9" name="Task05" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="ExternalMethod" name="" assembly="" interface="" method=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined">
						<Widget left="722" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="2ab07376-f7fd-4066-c3d8-a89850984e0d" from="883289f5-c333-4eb5-a2d1-82a92dbfb4e9" to="e83d069e-931a-40a1-b3fe-964cb76a0574">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined"/>
				</Transition>
				<Transition id="cffb4de6-2684-47d6-83bb-40ef37291202" from="e83d069e-931a-40a1-b3fe-964cb76a0574" to="8521b916-712f-407c-86c6-f36c23638316">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined"/>
				</Transition>
				<Transition id="6d0ec079-64ea-4a5e-e709-ae144601da5a" from="8521b916-712f-407c-86c6-f36c23638316" to="a4d2c206-9a8e-4735-d1d3-287bfb0bd46c">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined"/>
				</Transition>
				<Transition id="b8482289-0425-4fa5-dc7b-2ddeb2a3bd1b" from="8521b916-712f-407c-86c6-f36c23638316" to="81df662b-15b8-45ae-be95-b2b3235678d5">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined"/>
				</Transition>
				<Transition id="38838d48-1882-453d-e304-284b13ff829f" from="a4d2c206-9a8e-4735-d1d3-287bfb0bd46c" to="a3830a62-80f4-4c85-8b81-f7a194b677ee">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined"/>
				</Transition>
				<Transition id="95535804-edb9-4b9f-8eb3-2f60cfa08ff0" from="81df662b-15b8-45ae-be95-b2b3235678d5" to="a3830a62-80f4-4c85-8b81-f7a194b677ee">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined"/>
				</Transition>
				<Transition id="2f475df7-3eb8-401f-f389-b45994ec4c2b" from="a3830a62-80f4-4c85-8b81-f7a194b677ee" to="00f2d27d-7d8b-4f01-d135-8135b194b7a9">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined"/>
				</Transition>
				<Transition id="6d238ff1-ab26-4985-d652-4a875aa31d7d" from="00f2d27d-7d8b-4f01-d135-8135b194b7a9" to="fb4feac1-3f07-4550-8924-3b69cc1f931c">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="1733ea97-0a59-4057-c022-5c2e5fe0c0f8" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A97B00A4AB3C AS DateTime), CAST(0x0000A97C0149B35D AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (212, N'f133588b-7c79-4be9-8114-603870e247ca', N'1', N'测试流程', N'TestProcess002', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="测试流程" id="f133588b-7c79-4be9-8114-603870e247ca">
			<Description>null</Description>
			<Activities>
				<Activity id="62cfc189-a11e-4185-a515-4d20825ad6a2" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="381a54d7-64ce-4cc1-ac46-f79f4ef9c218" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="240" top="280" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="80f09618-1e01-4754-beaf-d98d02210423" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="381a54d7-64ce-4cc1-ac46-f79f4ef9c218" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="680" top="300" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8d24b5b7-1910-45fe-f294-6e4c068751cc" name="Task" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="Before" expression="Slickflow.Module.ExternalService.OrderSubmitService"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="381a54d7-64ce-4cc1-ac46-f79f4ef9c218" style="undefined">
						<Widget left="350" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c6cb4088-3823-44ae-8663-9cfc931992d7" name="Task" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="381a54d7-64ce-4cc1-ac46-f79f4ef9c218" style="undefined">
						<Widget left="520" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="1b52a2d6-32ac-4429-869e-0cb62be11544" from="62cfc189-a11e-4185-a515-4d20825ad6a2" to="8d24b5b7-1910-45fe-f294-6e4c068751cc">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="381a54d7-64ce-4cc1-ac46-f79f4ef9c218" style="undefined"/>
				</Transition>
				<Transition id="bb62ad60-4357-4d44-e65c-91ac0a9d2f4b" from="8d24b5b7-1910-45fe-f294-6e4c068751cc" to="c6cb4088-3823-44ae-8663-9cfc931992d7">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="381a54d7-64ce-4cc1-ac46-f79f4ef9c218" style="undefined"/>
				</Transition>
				<Transition id="4fedef57-89e1-4704-aa33-307fcb7db910" from="c6cb4088-3823-44ae-8663-9cfc931992d7" to="80f09618-1e01-4754-beaf-d98d02210423">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="381a54d7-64ce-4cc1-ac46-f79f4ef9c218" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A97C007225D6 AS DateTime), CAST(0x0000A9FF00ED9C11 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (213, N'51b5703f-faf2-4a5c-bce2-f85352321b25', N'1', N'并行分支的合并和退回', N'ParallelSendBackProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="并行分支的合并和退回" id="51b5703f-faf2-4a5c-bce2-f85352321b25">
			<Description>null</Description>
			<Activities>
				<Activity id="e93209a7-048b-4df3-b83b-2bf04251bca5" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="336" top="40" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="651b3d4e-380e-4eb1-906c-2680b093fbe5" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="336" top="663" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="07528e28-ab09-4b4f-dc7c-29c55e96895c" name="业务分配" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Widget left="316" top="110" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="be9a8641-5edf-48d7-f210-6ae3f9b6b284" name="OR" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="316" top="182" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4922390e-db6a-4b66-9a24-435a848c913b" name="AND" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="316" top="320" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fd4ef12e-45e3-4bc4-cb3c-49be877ce92d" name="检验员B录入" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Widget left="260" top="390" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="560d8895-e7d7-416d-9526-97b45f7b1c03" name="检验员A录入" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Widget left="380" top="390" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e6eff740-82d2-4948-aad2-c77372c165f9" name="AND" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin"/>
					<Actions>
						<Action type="null" name="null" assembly="null" interface="null" method="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="316" top="450" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3cd7c4c9-3221-4004-e484-7434152b9b23" name="报告合成" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Widget left="316" top="599" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="38b3d840-ec40-4aee-98e7-5cf4add698d0" name="组长" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Widget left="316" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6e2ff798-7b0b-4775-82e9-cc201b991519" name="小组审核" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Widget left="316" top="529" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="703b1093-282f-47c9-be32-fb554e6074ff" from="e93209a7-048b-4df3-b83b-2bf04251bca5" to="07528e28-ab09-4b4f-dc7c-29c55e96895c">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined"/>
				</Transition>
				<Transition id="80edb50a-053e-47e3-f360-3ab099b4b3cd" from="38b3d840-ec40-4aee-98e7-5cf4add698d0" to="4922390e-db6a-4b66-9a24-435a848c913b">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined"/>
				</Transition>
				<Transition id="8271a6a8-868d-492f-b2ee-df77a32d1e23" from="fd4ef12e-45e3-4bc4-cb3c-49be877ce92d" to="e6eff740-82d2-4948-aad2-c77372c165f9">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Points>
							<Point x="296" y="474"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="15b190dd-8194-4ca6-aa5a-f615f4053e7c" from="560d8895-e7d7-416d-9526-97b45f7b1c03" to="e6eff740-82d2-4948-aad2-c77372c165f9">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Points>
							<Point x="416" y="474"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="d2fafca3-bcfb-48b8-9f7b-dc4d070e6bcd" from="3cd7c4c9-3221-4004-e484-7434152b9b23" to="651b3d4e-380e-4eb1-906c-2680b093fbe5">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined"/>
				</Transition>
				<Transition id="e59312db-4b0c-41c4-f258-5000085b04bd" from="07528e28-ab09-4b4f-dc7c-29c55e96895c" to="be9a8641-5edf-48d7-f210-6ae3f9b6b284">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined"/>
				</Transition>
				<Transition id="74cc0866-fc54-4c9c-ff7c-345738703c89" from="be9a8641-5edf-48d7-f210-6ae3f9b6b284" to="3cd7c4c9-3221-4004-e484-7434152b9b23">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[isnew == 0]]>
						</ConditionText>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Points>
							<Point x="200" y="450"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="e6672b08-a3f3-4a69-c7ad-29a757f4ae63" from="be9a8641-5edf-48d7-f210-6ae3f9b6b284" to="38b3d840-ec40-4aee-98e7-5cf4add698d0">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[isnew == 1]]>
						</ConditionText>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Points/>
					</Geography>
				</Transition>
				<Transition id="c3764b81-71ec-4ba7-a4ac-801c96f78874" from="e6eff740-82d2-4948-aad2-c77372c165f9" to="6e2ff798-7b0b-4775-82e9-cc201b991519">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined"/>
				</Transition>
				<Transition id="a2247048-9056-4711-8f46-3020addbbbcc" from="6e2ff798-7b0b-4775-82e9-cc201b991519" to="3cd7c4c9-3221-4004-e484-7434152b9b23">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined"/>
				</Transition>
				<Transition id="cd1795f2-5832-4bf1-864e-ce88d748a0e2" from="4922390e-db6a-4b66-9a24-435a848c913b" to="fd4ef12e-45e3-4bc4-cb3c-49be877ce92d">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Points>
							<Point x="296" y="383"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="42eb93ff-8231-4087-c0cf-ab2804c43c3c" from="4922390e-db6a-4b66-9a24-435a848c913b" to="560d8895-e7d7-416d-9526-97b45f7b1c03">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="c028ad33-cef9-4fcf-8c25-e908d73f8503" style="undefined">
						<Points>
							<Point x="416" y="383"/>
						</Points>
					</Geography>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A97E00A6FF68 AS DateTime), CAST(0x0000A98300960078 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (214, N'ecb45a60-18f1-47de-8216-c2ab1b63f360', N'1', N'测试编制-10-22', N'TestPlant1022', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="9fdf1c09-8bb2-42e6-d2cf-5066660146f4" name="办公室财务" code="bgscw" outerId="23"/>
		<Participant type="Role" id="48efafce-2afe-49ec-a048-c285c7d32d8f" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="32ce5af1-60f7-420b-8e09-f155ba836af9" name="质量管理科-预算专管员" code="ZlglkYszgy" outerId="28"/>
		<Participant type="Role" id="61419732-9ae8-4244-cd3a-26dcc0872606" name="技术信息科-预算专管员" code="JsxxkYszgy" outerId="33"/>
		<Participant type="Role" id="ceec37f1-7d39-4b3f-fa40-12fa3c9a9c49" name="安全管理科-预算专管员" code="AqglkYszgy" outerId="38"/>
		<Participant type="Role" id="9fb8d61f-725d-4aa7-9048-c35c8ffdfa93" name="质量管理科-科长" code="ZlglkKz" outerId="27"/>
		<Participant type="Role" id="fca26b2b-db04-473f-e653-37d32fd8dd7e" name="质量管理科-分管领导" code="ZlglkFgld" outerId="26"/>
		<Participant type="Role" id="81ef745a-4019-4819-8f1b-a014550810a3" name="技术信息科-科长" code="JsxxkKz" outerId="32"/>
		<Participant type="Role" id="58875dec-13ea-4ab3-9114-3bb0659141ad" name="技术信息科-分管领导" code="JsxxkFgld" outerId="31"/>
		<Participant type="Role" id="d3aa1dad-4726-4059-c582-40b42f321143" name="安全管理科-科长" code="AqglkKz" outerId="37"/>
		<Participant type="Role" id="d9e41479-6e0f-4b04-e706-6482536d1032" name="安全管理科-分管领导" code="AqglkFgld" outerId="36"/>
		<Participant type="Role" id="58eb724d-a6af-4f7b-f32e-61c4243ea13f" name="财务主管" code="cwzg" outerId="16"/>
		<Participant type="Role" id="9c961200-ae4d-4ee0-ab8a-aab8f63d49b8" name="站长" code="ZhanZhang" outerId="25"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="测试编制-10-22" id="ecb45a60-18f1-47de-8216-c2ab1b63f360">
			<Description>null</Description>
			<Activities>
				<Activity id="5451375b-2e23-4d04-c381-5aeee434f9c3" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="22" top="290" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5ab08ca4-79e5-468e-f122-9b77df96f701" name="办公室财务" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="9fdf1c09-8bb2-42e6-d2cf-5066660146f4"/>
						<Performer id="48efafce-2afe-49ec-a048-c285c7d32d8f"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="null" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="80" top="290" width="82" height="32"/>
					</Geography>
				</Activity>
				<Activity id="aab02808-7885-4c7d-d4b1-58bb79dda77e" name="" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Actions>
						<Action type="" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="200" top="290" width="40" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3776cc10-6f42-4def-9789-0ddb34b6f745" name="质量管理科经办人1" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="a34ba481-6eea-4b2f-d96f-4adf552fb6ec"/>
						<Performer id="5ffc9c14-6893-4212-c809-a194cb80865d"/>
						<Performer id="d5088635-3c41-4301-e826-fa86f0317971"/>
						<Performer id="32ce5af1-60f7-420b-8e09-f155ba836af9"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="290" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="43502bf9-b6d0-4c89-820e-56bd371a1ac1" name="技术信息科经办人" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="5c6abfe1-0309-4939-f473-4970971aa0a1"/>
						<Performer id="32eb5594-2085-4f45-9d87-98e75cf4787d"/>
						<Performer id="8c6ad0a1-49ed-4bf9-d86e-301dc078dfa0"/>
						<Performer id="61419732-9ae8-4244-cd3a-26dcc0872606"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="290" top="258" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b9f2c1cd-8c75-430d-c407-4bbff519bab4" name="安全管理科经办人" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="9e9ff496-3352-407f-8ec9-f064f8b07377"/>
						<Performer id="0b79fc88-377e-4165-d804-0157f6f89f15"/>
						<Performer id="74c79f30-dd50-4d2f-94b7-786aad385722"/>
						<Performer id="ceec37f1-7d39-4b3f-fa40-12fa3c9a9c49"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="290" top="340" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f8d4e2fc-e0df-48a5-9f69-72a6686d10ca" name="质量管理科科长" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="7b809a71-c0c2-4680-d5b0-b773b7bef4a5"/>
						<Performer id="70df87e7-c5dd-4d74-9edc-c6ed929131cd"/>
						<Performer id="509df314-4701-4ac2-fe2f-8446e28828c8"/>
						<Performer id="9fb8d61f-725d-4aa7-9048-c35c8ffdfa93"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="420" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="045f2bb2-6b05-42eb-c776-621b7bb6c618" name="质量管理科分管领导" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="e8dc4dea-8b09-4940-b55f-ec9aa5e27b6e"/>
						<Performer id="e00cf100-8d91-4bbb-b14f-2caf0a394302"/>
						<Performer id="a2bb7a18-e643-409b-9e7a-48f4cd1a330b"/>
						<Performer id="fca26b2b-db04-473f-e653-37d32fd8dd7e"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="530" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b5626989-b129-4204-ffb7-dc6decfec36f" name="技术信息科科长" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="9b93d1a8-2400-4e9f-e978-179c77a30971"/>
						<Performer id="6cdd3787-6ba6-43fe-8bf3-93f8ffb57c59"/>
						<Performer id="cf5ea50e-6482-4b8d-98fd-e75cc56e6722"/>
						<Performer id="81ef745a-4019-4819-8f1b-a014550810a3"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="420" top="258" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="34809ad2-7fb7-4892-d4e3-8308ade1459a" name="技术信息科分管领导" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="d94a490e-dc44-4999-9895-d11fc69566d8"/>
						<Performer id="e4e5cd2d-07d4-45fd-9097-2b8d9a770443"/>
						<Performer id="ef0eb440-fbc8-4fea-bd8a-ed2bcb80b906"/>
						<Performer id="58875dec-13ea-4ab3-9114-3bb0659141ad"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="530" top="258" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d9a94920-d0ad-47b3-ab9b-579a1d91e7c1" name="安全管理科科长" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="51b02da9-7a05-4d97-c5c7-0a6b7c771812"/>
						<Performer id="59e60999-02e8-4835-e95c-ff037c7a8bd7"/>
						<Performer id="80cec2f2-c679-4fcd-e88f-b816a3f3bc31"/>
						<Performer id="d3aa1dad-4726-4059-c582-40b42f321143"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="420" top="340" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9779ac8b-2ed3-48d1-cdaf-a0f7de47b3fb" name="安全管理科分管领导" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="667951ef-bac7-4b09-fae5-0711234411a1"/>
						<Performer id="3d58cfda-ba61-433b-82a8-b63867ffc23b"/>
						<Performer id="6999a2d3-3215-42a5-e4c0-b3b0e614f37d"/>
						<Performer id="d9e41479-6e0f-4b04-e706-6482536d1032"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="530" top="340" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2783e849-c8c3-469d-b27d-9c56e2adb82b" name="" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin"/>
					<Actions>
						<Action type="" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="670" top="290" width="40" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7257a86f-cf49-4f81-a2f4-6403c39148cd" name="财务主管" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bc9d1fbd-6bc2-4d8e-8934-7362bd2f59ec"/>
						<Performer id="91493884-54f8-4de0-d02d-25d5cdc86e26"/>
						<Performer id="267e9de3-a6ea-49b8-93df-a583f8c366ca"/>
						<Performer id="58eb724d-a6af-4f7b-f32e-61c4243ea13f"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="750" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="de6a055b-e2e8-42ad-d004-594acbac5f3f" name="站长" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="f1a1fdc7-9fa3-4763-ba7e-95a99ec9cfd8"/>
						<Performer id="ab4e542a-c813-4a5a-9242-8bb510318007"/>
						<Performer id="08a86c7e-19db-4608-d20e-7e3ed2a01ee3"/>
						<Performer id="9c961200-ae4d-4ee0-ab8a-aab8f63d49b8"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined">
						<Widget left="860" top="290" width="50" height="32"/>
					</Geography>
				</Activity>
				<Activity id="638e300c-d803-4219-8da3-787d3081998a" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="950" top="290" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="9248d536-ce45-4c23-c1ed-86d2f1b18bcf" from="5451375b-2e23-4d04-c381-5aeee434f9c3" to="5ab08ca4-79e5-468e-f122-9b77df96f701">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="606db5e0-f0ef-4ffd-f7cd-1a0ea42fd7f0" from="5ab08ca4-79e5-468e-f122-9b77df96f701" to="aab02808-7885-4c7d-d4b1-58bb79dda77e">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="36de0ecd-2330-4724-c448-a85cdaf15fa2" from="aab02808-7885-4c7d-d4b1-58bb79dda77e" to="3776cc10-6f42-4def-9789-0ddb34b6f745">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[flag=1]]>
						</ConditionText>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="bef9d224-3fb5-4387-99fd-7d99d3fcdbfe" from="aab02808-7885-4c7d-d4b1-58bb79dda77e" to="43502bf9-b6d0-4c89-820e-56bd371a1ac1">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[flag=1]]>
						</ConditionText>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="11feb4d0-48fd-4edd-ac0e-24c69f7b1095" from="aab02808-7885-4c7d-d4b1-58bb79dda77e" to="b9f2c1cd-8c75-430d-c407-4bbff519bab4">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[flag=1]]>
						</ConditionText>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="cb6176af-57f9-44d6-c02d-985c166443dc" from="3776cc10-6f42-4def-9789-0ddb34b6f745" to="f8d4e2fc-e0df-48a5-9f69-72a6686d10ca">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="b3cae629-69ef-407a-f81f-44cf38415e6b" from="f8d4e2fc-e0df-48a5-9f69-72a6686d10ca" to="045f2bb2-6b05-42eb-c776-621b7bb6c618">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="7c46e8a9-bffd-4566-d2e5-1e1749fceb78" from="43502bf9-b6d0-4c89-820e-56bd371a1ac1" to="b5626989-b129-4204-ffb7-dc6decfec36f">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="36230a3f-f49c-4f38-fa69-6023a06deac4" from="b5626989-b129-4204-ffb7-dc6decfec36f" to="34809ad2-7fb7-4892-d4e3-8308ade1459a">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="c29de506-69fc-4669-d1b6-e22999d076ce" from="b9f2c1cd-8c75-430d-c407-4bbff519bab4" to="d9a94920-d0ad-47b3-ab9b-579a1d91e7c1">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="fd390f25-ac3c-4419-bab1-9ec7d015637d" from="d9a94920-d0ad-47b3-ab9b-579a1d91e7c1" to="9779ac8b-2ed3-48d1-cdaf-a0f7de47b3fb">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="cc63c32b-dd9a-4df6-a114-863012183c19" from="045f2bb2-6b05-42eb-c776-621b7bb6c618" to="2783e849-c8c3-469d-b27d-9c56e2adb82b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[flag=1]]>
						</ConditionText>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="f6f50110-d2aa-4b84-fbaf-a964b13afc47" from="34809ad2-7fb7-4892-d4e3-8308ade1459a" to="2783e849-c8c3-469d-b27d-9c56e2adb82b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[flag=1]]>
						</ConditionText>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="9115d798-748f-4a5c-ad12-f9068f115776" from="9779ac8b-2ed3-48d1-cdaf-a0f7de47b3fb" to="2783e849-c8c3-469d-b27d-9c56e2adb82b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[flag=1]]>
						</ConditionText>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="3415c0c9-f28f-4224-b16d-f18eb4a63caa" from="2783e849-c8c3-469d-b27d-9c56e2adb82b" to="7257a86f-cf49-4f81-a2f4-6403c39148cd">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="326f5374-fb48-4ba1-d421-bb924737b84d" from="7257a86f-cf49-4f81-a2f4-6403c39148cd" to="de6a055b-e2e8-42ad-d004-594acbac5f3f">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
				<Transition id="1fecf30c-fab4-4f06-94dd-a2b3d07bc449" from="de6a055b-e2e8-42ad-d004-594acbac5f3f" to="638e300c-d803-4219-8da3-787d3081998a">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="5249c323-3d65-425d-c09a-0203cc18106b" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000A98100F723FA AS DateTime), CAST(0x0000A9D5013D79FE AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (216, N'3d93f845-ae65-4399-b307-f074b9206eb1', N'1', N'intermediate event process', N'IntermediateEventProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="3d93f845-ae65-4399-b307-f074b9206eb1" name="intermediate event process" code="IntermediateEventProcess" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="e72e570f-7017-4943-d759-00d3dce4898b" name="开始" code="OO1VGR" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="null" method="null" arguments="null" expression="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="119" top="220" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4f9577ad-76d5-429a-8b25-ed679a33c202" name="Task001" code="DZA8FZ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="Before" method="null" arguments="null" expression="aaa"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="undefined">
						<Widget left="239" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a9780549-1072-42f6-aab8-da0008520938" name="" code="CLOUN6" url="null">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="Before" method="SQL" arguments="" expression="">
							<CodeInfo>
								<![CDATA[select * from sysuser;]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="399" top="220" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="278f0546-0511-43bd-da40-52a44b1dcab0" name="Task002" code="FK3CYU" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="undefined">
						<Widget left="519" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f03dd38b-9b2d-46e8-e354-4b3431aafd44" name="结束" code="JDKQRL" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="null" method="null" arguments="null" expression="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="693" top="220" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e4425bf5-2e4c-4917-9d0e-7a5fb86c4d6c" from="e72e570f-7017-4943-d759-00d3dce4898b" to="4f9577ad-76d5-429a-8b25-ed679a33c202">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="undefined"/>
				</Transition>
				<Transition id="62703231-ac90-4184-cef0-b9d0e289bd45" from="4f9577ad-76d5-429a-8b25-ed679a33c202" to="a9780549-1072-42f6-aab8-da0008520938">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="undefined"/>
				</Transition>
				<Transition id="2e85ecb7-5702-4710-818e-2f621e086c55" from="a9780549-1072-42f6-aab8-da0008520938" to="278f0546-0511-43bd-da40-52a44b1dcab0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="undefined"/>
				</Transition>
				<Transition id="d68c314c-ba96-469a-e535-b3da74f1bc42" from="278f0546-0511-43bd-da40-52a44b1dcab0" to="f03dd38b-9b2d-46e8-e354-4b3431aafd44">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="61fc0d48-171a-42bb-d328-331a03046355" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A9AC00A1F61D AS DateTime), CAST(0x0000AC5200ABDE33 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (219, N'4be58a96-926c-4aff-a383-fe71185572e5', N'1', N'事件测试交互流程', N'EventExternalOrder', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="3e977ffc-d586-4fdd-a639-0f2154a5865a" name="员工" code="BA364B4D-2D0A-4D41-B3E1-BC395894CE19" outerId="5"/>
		<Participant type="Role" id="530d1535-6050-4fbc-9119-f34351812878" name="中层" code="1184DC5A-AE75-42FE-9800-416A0EAABB5A" outerId="7"/>
		<Participant type="Role" id="195ff37b-f511-4bbd-b074-3ea163690f28" name="高层" code="F514C2C6-F663-4015-954A-0960C6772444" outerId="8"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="事件测试交互流程" id="4be58a96-926c-4aff-a383-fe71185572e5">
			<Description>null</Description>
			<Activities>
				<Activity id="7b638c12-31e6-43a1-b47a-189070760967" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Actions>
						<Action type="Event"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="ec6c46c6-6cef-434f-9ba8-21d461dc46d2" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="200" top="240" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="de50335a-034c-4c58-db72-ddd00c1aebfe" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Actions>
						<Action type="Event" fire="After" method="LocalMethod" expression="Slickflow.Module.External.OrderCompletedService"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="ec6c46c6-6cef-434f-9ba8-21d461dc46d2" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="670" top="240" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="76c8b8cf-346b-467e-c04c-a3659b6fbdd3" name="订单提交" code="OrderSubmit" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="3e977ffc-d586-4fdd-a639-0f2154a5865a"/>
						<Performer id="530d1535-6050-4fbc-9119-f34351812878"/>
						<Performer id="195ff37b-f511-4bbd-b074-3ea163690f28"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="Before" method="LocalMethod" expression="Slickflow.Module.External.OrderSubmitService"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[{"A":"a", "B":"b"}]]>
						</Section>
					</Sections>
					<Geography parent="ec6c46c6-6cef-434f-9ba8-21d461dc46d2" style="undefined">
						<Widget left="400" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="7e685458-83ff-4b30-8fba-dc01328a5677" from="7b638c12-31e6-43a1-b47a-189070760967" to="76c8b8cf-346b-467e-c04c-a3659b6fbdd3">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="ec6c46c6-6cef-434f-9ba8-21d461dc46d2" style="undefined"/>
				</Transition>
				<Transition id="d4a3e161-80c8-4771-9710-8d622e324a19" from="76c8b8cf-346b-467e-c04c-a3659b6fbdd3" to="de50335a-034c-4c58-db72-ddd00c1aebfe">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="ec6c46c6-6cef-434f-9ba8-21d461dc46d2" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A9B10112298E AS DateTime), CAST(0x0000AA7200AE58A9 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (220, N'5d6a7d6f-daa2-482d-8303-87b3b9f59a6a', N'1', N'事件测试流程-7', N'code-7', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="87b19513-b30f-48f1-a25f-7087a5d492ea" name="testrole" code="testcode" outerId="21"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="事件测试流程-7" id="5d6a7d6f-daa2-482d-8303-87b3b9f59a6a">
			<Description>null</Description>
			<Activities>
				<Activity id="b186a142-1465-467c-8cea-87609144383e" name="订单提交" code="OrderSubmit" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="87b19513-b30f-48f1-a25f-7087a5d492ea"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" method="null" arguments="null" expression="somethingelse"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression="P2M"/>
					</Boundaries>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="undefined">
						<Widget left="260" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="08e97610-e871-44d8-92e3-8bae0abd5e60" name="通知商务" code="" url="null">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None"/>
					<Actions>
						<Action type="Event" fire="Before" method="LocalMethod" arguments="null" expression="Slickflow.Module.External.OrderSubmitService"/>
						<Action type="Event" fire="After" method="None" arguments="" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="406" top="150" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b3f5be65-5e45-40eb-e603-7ccca179dfa3" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="650" top="150" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c7486da0-61f7-45b9-f82a-4a19fb8f9ee7" name="合同审批" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="undefined">
						<Widget left="506" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="76b12891-ffbd-4d2e-84a6-3f81f0321818" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="140" top="150" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="eb25320e-8388-4f91-bdc3-8ac48aea839f" from="76b12891-ffbd-4d2e-84a6-3f81f0321818" to="b186a142-1465-467c-8cea-87609144383e">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="undefined"/>
				</Transition>
				<Transition id="865c6513-3aa0-4edd-c6c7-2a1b70eeb0a4" from="b186a142-1465-467c-8cea-87609144383e" to="08e97610-e871-44d8-92e3-8bae0abd5e60">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="undefined">
						<Points>
							<Point x="361" y="166"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="16ec4a02-fe7a-4ff9-a237-e2624a58410c" from="08e97610-e871-44d8-92e3-8bae0abd5e60" to="c7486da0-61f7-45b9-f82a-4a19fb8f9ee7">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="undefined"/>
				</Transition>
				<Transition id="ca2e7ed4-6350-4ab8-9e1d-3c995d864d5a" from="c7486da0-61f7-45b9-f82a-4a19fb8f9ee7" to="b3f5be65-5e45-40eb-e603-7ccca179dfa3">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="aa8c0a51-4f4c-4643-b44c-9220225dadca" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A9B200A3DD64 AS DateTime), CAST(0x0000AAEC0149BBFC AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (249, N'2d403426-b98a-4498-9fd5-6c4f253d2f98', N'1', N'动态并发多实例测试流程', N'AnsPlitMIProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="bb2df26b-f4be-47b9-b5f3-b1feeafea1dc" name="测试人员" code="tester" outerId="36"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="动态并发多实例测试流程" id="2d403426-b98a-4498-9fd5-6c4f253d2f98">
			<Description>null</Description>
			<Activities>
				<Activity id="427ae5e0-4443-4585-fda4-0be43308546f" name="小组分配项目" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="null" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="bc1b5702-672e-475f-db81-09581d8f47f5" style="undefined">
						<Widget left="34" top="10" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8f95b7d1-172a-44a8-af41-bf272cac942a" name="小组汇总审核" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="bc1b5702-672e-475f-db81-09581d8f47f5" style="undefined">
						<Widget left="34" top="120" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="01154e89-5cad-4457-8b40-bfe5c8a8e52a" name="检验员录入" code="" url="null">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Parallel" compareType="Percentage" completeOrder="100"/>
					<Actions>
						<Action type="Event" fire="null" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="bc1b5702-672e-475f-db81-09581d8f47f5" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="34" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1cf2ff41-3f6b-4aa4-cb8a-ecae4b372093" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="460" top="40" width="32" height="30"/>
					</Geography>
				</Activity>
				<Activity id="40c91da4-8362-4c3a-89e8-b457bba8e958" name="业务登记" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bb2df26b-f4be-47b9-b5f3-b1feeafea1dc"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined">
						<Widget left="440" top="114" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f0744821-da6b-4f61-9940-25eb26b86ca6" name="业务分配" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bb2df26b-f4be-47b9-b5f3-b1feeafea1dc"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined">
						<Widget left="440" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f834f537-bfbd-4dc0-d4ce-7640bf218ad4" name="OR" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="440" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1a97dab6-fc08-4df5-8225-97bb98ea97db" name="AND多实例-分支" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="440" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9f11a387-972d-4542-d059-b60d591d03f1" name="AND多实例-合并" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="440" top="520" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="35f61535-d46b-4c83-bd04-0a775b0bd690" name="报告合成" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bb2df26b-f4be-47b9-b5f3-b1feeafea1dc"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined">
						<Widget left="440" top="570" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d60eba69-140a-43d7-d4fe-1915b1e11b3b" name="报告审核" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bb2df26b-f4be-47b9-b5f3-b1feeafea1dc"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined">
						<Widget left="440" top="620" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b1f9ea9e-2073-4310-b849-d49ce676aaf7" name="报告批准" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bb2df26b-f4be-47b9-b5f3-b1feeafea1dc"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined">
						<Widget left="440" top="670" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="19543855-e569-4e51-cf0c-50eb9f4249d1" name="报告打印" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bb2df26b-f4be-47b9-b5f3-b1feeafea1dc"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined">
						<Widget left="440" top="720" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6613fcb8-0992-4eb0-b187-8f8a82324021" name="报告归档" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="bb2df26b-f4be-47b9-b5f3-b1feeafea1dc"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined">
						<Widget left="440" top="770" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9e223469-3b49-4dc7-8372-ff35ed6fcc1c" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="460" top="822" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="eebe4406-7691-484e-8c9b-4425a605dd72" from="1cf2ff41-3f6b-4aa4-cb8a-ecae4b372093" to="40c91da4-8362-4c3a-89e8-b457bba8e958">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="a43d4a25-ac64-4c93-b702-e058689529a4" from="40c91da4-8362-4c3a-89e8-b457bba8e958" to="f0744821-da6b-4f61-9940-25eb26b86ca6">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="156d99be-9646-4e9b-c89b-47910d418c07" from="f0744821-da6b-4f61-9940-25eb26b86ca6" to="f834f537-bfbd-4dc0-d4ce-7640bf218ad4">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="10112293-f0da-4527-d3e2-ac29cdfb10a9" from="1a97dab6-fc08-4df5-8225-97bb98ea97db" to="427ae5e0-4443-4585-fda4-0be43308546f">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="d2909348-dfc3-4427-c878-e292b654fec1" from="f834f537-bfbd-4dc0-d4ce-7640bf218ad4" to="35f61535-d46b-4c83-bd04-0a775b0bd690">
					<Description>直接合成报告</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[reportmake== "true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined">
						<Points>
							<Point x="300" y="420"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="95cc4356-8064-41c5-b0a7-369bdaeb603d" from="8f95b7d1-172a-44a8-af41-bf272cac942a" to="9f11a387-972d-4542-d059-b60d591d03f1">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="33dab522-ae9f-4bc0-d211-6e4b24d7dadc" from="9f11a387-972d-4542-d059-b60d591d03f1" to="35f61535-d46b-4c83-bd04-0a775b0bd690">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="c4070a14-7eef-40bd-c3d3-e63ebc770483" from="35f61535-d46b-4c83-bd04-0a775b0bd690" to="d60eba69-140a-43d7-d4fe-1915b1e11b3b">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="dfc8be85-5a8f-4cec-b3f8-a0b41e364374" from="d60eba69-140a-43d7-d4fe-1915b1e11b3b" to="b1f9ea9e-2073-4310-b849-d49ce676aaf7">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="68e745d2-00a0-4b17-83cd-41d2dd34bf2d" from="b1f9ea9e-2073-4310-b849-d49ce676aaf7" to="19543855-e569-4e51-cf0c-50eb9f4249d1">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="e45e8126-de63-46a4-b4cc-8df6e69daa7c" from="19543855-e569-4e51-cf0c-50eb9f4249d1" to="6613fcb8-0992-4eb0-b187-8f8a82324021">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="ba696d4d-1c38-4ee6-ef7a-cb1134f9a767" from="6613fcb8-0992-4eb0-b187-8f8a82324021" to="9e223469-3b49-4dc7-8372-ff35ed6fcc1c">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="2f3d2957-a5ae-41e0-b0d5-67bcdf00b039" from="f834f537-bfbd-4dc0-d4ce-7640bf218ad4" to="1a97dab6-fc08-4df5-8225-97bb98ea97db">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[reportmake== "false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="undefined"/>
				</Transition>
				<Transition id="441f8f7a-507f-4da7-a358-0bb334594e76" from="427ae5e0-4443-4585-fda4-0be43308546f" to="01154e89-5cad-4457-8b40-bfe5c8a8e52a">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="bc1b5702-672e-475f-db81-09581d8f47f5" style="undefined"/>
				</Transition>
				<Transition id="41e9154e-0ec1-45ef-8765-b1f02e7fcfb6" from="01154e89-5cad-4457-8b40-bfe5c8a8e52a" to="8f95b7d1-172a-44a8-af41-bf272cac942a">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="bc1b5702-672e-475f-db81-09581d8f47f5" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups>
			<Group id="bc1b5702-672e-475f-db81-09581d8f47f5" name="">
				<Geography parent="ee8a3d37-9192-485d-a3ce-43188e47df00" style="group">
					<Widget left="400" top="347" width="140" height="163"/>
				</Geography>
			</Group>
		</Groups>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A9CB00A0322C AS DateTime), CAST(0x0000A9E500F265E0 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (250, N'1206e68e-8be7-4fee-b562-5bb5c1c6db5c', N'1', N'嵌套分支测试', N'NestedBranchTest', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="嵌套分支测试" id="1206e68e-8be7-4fee-b562-5bb5c1c6db5c">
			<Description></Description>
			<Activities>
				<Activity id="4e254817-15c9-4105-9d05-a2aedf2b6440" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="60" top="234" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="be687114-fcc6-4c7c-f21d-4c08f9e72398" name="申请" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="undefined">
						<Widget left="170" top="234" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fa312b66-8bd2-4862-9970-707605e790c7" name="部门汇总评审分支" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="320" top="234" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ff581cb1-5036-46d0-a756-754195bc600a" name="行政评审分支" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="460" top="218" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ef5e8fbd-2c42-4ccc-f69e-1292b2e100be" name="技术部" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="undefined">
						<Widget left="574" top="50" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="74fb6759-1bf8-4a79-8779-d57d3d3f9944" name="财务部" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="undefined">
						<Widget left="620" top="154" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ce639580-2e05-4d45-b449-1ebd0c9be7ad" name="人事部" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="undefined">
						<Widget left="610" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d5a26f4c-9742-46fb-feee-0c4ac927f361" name="部门评审汇总" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="750" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="283ed75f-99a2-4de0-9550-7e2855648b93" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="900" top="242" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="d2218935-0406-425c-bf50-6305cc1b401a" from="4e254817-15c9-4105-9d05-a2aedf2b6440" to="be687114-fcc6-4c7c-f21d-4c08f9e72398">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null"/>
				</Transition>
				<Transition id="c1be3340-ef12-4beb-cc63-2270deca4bc6" from="be687114-fcc6-4c7c-f21d-4c08f9e72398" to="fa312b66-8bd2-4862-9970-707605e790c7">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null"/>
				</Transition>
				<Transition id="2f2b7eee-3c2d-494f-acf8-cc2981bee172" from="fa312b66-8bd2-4862-9970-707605e790c7" to="ff581cb1-5036-46d0-a756-754195bc600a">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null"/>
				</Transition>
				<Transition id="0c22fbc1-07ec-42c3-f11c-ab68320fd329" from="ff581cb1-5036-46d0-a756-754195bc600a" to="74fb6759-1bf8-4a79-8779-d57d3d3f9944">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null"/>
				</Transition>
				<Transition id="a7768fe3-4d2f-4569-b9fb-17160e070377" from="ff581cb1-5036-46d0-a756-754195bc600a" to="ce639580-2e05-4d45-b449-1ebd0c9be7ad">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null"/>
				</Transition>
				<Transition id="b4c69a25-6925-4163-9cc6-3a36be334a71" from="fa312b66-8bd2-4862-9970-707605e790c7" to="ef5e8fbd-2c42-4ccc-f69e-1292b2e100be">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null">
						<Points>
							<Point x="356" y="170"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="a0e0f560-d9db-4d12-8d4f-9340f1f08f1c" from="ef5e8fbd-2c42-4ccc-f69e-1292b2e100be" to="d5a26f4c-9742-46fb-feee-0c4ac927f361">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null">
						<Points>
							<Point x="786" y="190"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="062b34ad-c0b8-4449-d32a-cc9cb0e8d51c" from="74fb6759-1bf8-4a79-8779-d57d3d3f9944" to="d5a26f4c-9742-46fb-feee-0c4ac927f361">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null"/>
				</Transition>
				<Transition id="cdc5f690-7b75-4eb4-bed0-cbccd3e199ea" from="ce639580-2e05-4d45-b449-1ebd0c9be7ad" to="d5a26f4c-9742-46fb-feee-0c4ac927f361">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null"/>
				</Transition>
				<Transition id="ad7a696e-8614-46fc-82ee-66e96b2f9024" from="d5a26f4c-9742-46fb-feee-0c4ac927f361" to="283ed75f-99a2-4de0-9550-7e2855648b93">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="7193f094-7d6f-4d78-f054-7cc32d17f61b" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000A9CE009307C1 AS DateTime), CAST(0x0000A9CE00B1E7FA AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (253, N'a474e0ee-3fe0-40f2-99a1-9400d2934580', N'1', N'合同流程', N'Contractprocess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<Package>
	<Participants>
		<Participant type="Role" name="科室员工" id="0fd65ccf-c356-48b6-ca73-cc986b48a25e" code="ksyg" outerId="24" />
		<Participant type="Role" name="科长" id="b79cf592-a3a9-441b-ae5a-1ddf943bebd4" code="kz" outerId="5" />
		<Participant type="Role" name="副科长" id="7c1009f9-1229-4777-feae-a03644bbfd66" code="Fkz" outerId="76" />
		<Participant type="Role" name="财务主管" id="9d3abc43-e322-417c-f75c-c01a8c5e31d7" code="cwzg" outerId="16" />
		<Participant type="Role" name="办公室负责人" id="31347e88-ac14-4b4f-bc39-fe96a07a8f26" code="bgsfzr" outerId="13" />
		<Participant type="Role" name="分管站长" id="9c0c7228-f9a5-4ec5-9d0c-2866af5aebbb" code="fgzz" outerId="14" />
		<Participant type="Role" name="站长" id="43451c4a-2396-4158-a71b-c92245955b57" code="ZhanZhang" outerId="25" />
	</Participants>
	<WorkflowProcesses>
		<Process name="合同流程" id="a474e0ee-3fe0-40f2-99a1-9400d2934580">
			<Description>null</Description>
			<Activities>
				<Activity name="开始" id="cdb23070-d918-4dcd-e489-7f5f7dbbeb72" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" />
					<Geography style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="32" height="32" top="269" left="68" />
					</Geography>
				</Activity>
				<Activity name="合同经办人" id="2bcf73ea-1594-4ace-8f98-2340f62d07af" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode" />
					<Performers>
						<Performer id="0fd65ccf-c356-48b6-ca73-cc986b48a25e" />
					</Performers>
					<Actions>
						<Action type="Event" expression="" fire="" />
					</Actions>
					<Boundaries>
						<Boundary expression="" event="Timer" />
					</Boundaries>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="72" height="32" top="269" left="148" />
					</Geography>
				</Activity>
				<Activity name="科长" id="6ac6fba5-75d3-4134-8368-113ca30f7a71" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode" />
					<Performers>
						<Performer id="0b0a489e-1508-49d4-c264-2777510d6afe" />
						<Performer id="3efb8e7b-2df6-4c44-ce97-12c3b1f5b3f6" />
						<Performer id="f2a44512-9b12-49c7-cd8a-c3a0d1d88196" />
						<Performer id="282fcc95-3126-49c4-8247-36c0287bb067" />
						<Performer id="c8fb2e92-347f-4216-9c72-5819876dc9a4" />
						<Performer id="47c0b5e5-2f43-4653-92de-65caf4189887" />
						<Performer id="c449f05a-fd75-45ef-f219-ebf2fa2afc74" />
						<Performer id="9dd4cda5-cd84-4986-a876-092200873244" />
						<Performer id="24623ae6-d3d9-4846-de39-0593b50ad2b8" />
						<Performer id="34803df0-06d7-46d5-f279-77ace9e843d7" />
						<Performer id="d8a44e34-14fb-4bb9-8706-c31c61ca7d5e" />
						<Performer id="66ca38a6-1b76-441e-9d76-c6b779c77ea5" />
						<Performer id="62c28eb9-cf34-47ff-85e3-17f6ae18398e" />
						<Performer id="7fb16846-f549-4201-9381-55d4b5997c34" />
						<Performer id="a01b0b82-4e8c-4b63-ecbf-8bdee8dc1f06" />
						<Performer id="b79cf592-a3a9-441b-ae5a-1ddf943bebd4" />
						<Performer id="7c1009f9-1229-4777-feae-a03644bbfd66" />
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null" />
					</Actions>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="72" height="32" top="269" left="268" />
					</Geography>
				</Activity>
				<Activity name="财务主管" id="5d081ba0-62e6-404b-9c32-709886f88498" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode" />
					<Performers>
						<Performer id="9adbc47f-de3f-490b-e0bc-82f4ff9a3b99" />
						<Performer id="7aaa9f45-cc9d-4f8d-de20-2312dcdbb987" />
						<Performer id="662c53fb-0cf7-416c-ec42-8ed91788866a" />
						<Performer id="98e7f3ca-619b-4e68-9efc-d234f907b1f4" />
						<Performer id="7def3e49-049e-4a1f-eb2d-6c0f82dd7926" />
						<Performer id="9d3abc43-e322-417c-f75c-c01a8c5e31d7" />
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null" />
					</Actions>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="72" height="32" top="269" left="388" />
					</Geography>
				</Activity>
				<Activity name="办公室负责人" id="161af09d-88fa-4dec-d3cc-00c337c3a932" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode" />
					<Performers>
						<Performer id="34803df0-06d7-46d5-f279-77ace9e843d7" />
						<Performer id="9209fac8-8c52-48aa-c1ab-0777791fd970" />
						<Performer id="bbb0b0ea-1a8d-48b6-bffc-4680bbaa8eb8" />
						<Performer id="bf333031-887a-4bce-898d-be401d63d572" />
						<Performer id="6d88c1b3-ab23-4a55-8334-c547c1f1212f" />
						<Performer id="31347e88-ac14-4b4f-bc39-fe96a07a8f26" />
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null" />
					</Actions>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="82" height="32" top="269" left="498" />
					</Geography>
				</Activity>
				<Activity name="" id="a017f053-0331-4725-d639-f763d76b54a7" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewayDirection="OrSplit" gatewaySplitJoinType="Split" />
					<Actions>
						<Action type="" fire="null" />
					</Actions>
					<Geography style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="40" height="32" top="269" left="608" />
					</Geography>
				</Activity>
				<Activity name="分管站长" id="5ccfd4c7-0083-4657-d35b-67fcd1781af1" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode" />
					<Performers>
						<Performer id="649d5bdc-4cb6-4403-8e3a-b93505e3d268" />
						<Performer id="e7a8c2dd-03c6-4642-f568-754f40f8009a" />
						<Performer id="e2fc481e-8d69-4dfb-b8ae-192bdafaf246" />
						<Performer id="621f237d-51ba-4f36-a360-87a0a5ff5230" />
						<Performer id="107097e2-aa3a-4372-eaaa-3ad9c72ddbb2" />
						<Performer id="8aa06400-290b-4c7c-9134-bed8a5d7653a" />
						<Performer id="de88b2b1-3232-4510-b734-aa19bf329b6f" />
						<Performer id="b130e1b5-1def-478c-b130-bdb46a9a1911" />
						<Performer id="0887c8a5-4336-4bb0-c200-97ef2bb1f5fd" />
						<Performer id="4eb7c524-6d5f-49fd-e617-0266261ff8a4" />
						<Performer id="fe5eaa89-8cc5-4609-f047-1cf09214a198" />
						<Performer id="d3554d6d-73b6-47e0-cdda-59e00e97c5eb" />
						<Performer id="7e918695-48c1-40c0-8f7a-54840a6122bb" />
						<Performer id="eedf9bb2-bbf4-4beb-f790-a6c2048984e3" />
						<Performer id="247b1e76-f90d-4257-83ca-dbc42596b4f5" />
						<Performer id="34762d85-9ec0-42dd-ab9c-e656fbc5d290" />
						<Performer id="902aa9ee-c8a4-4709-f711-d0e1c4f86eb2" />
						<Performer id="273b09ca-fef0-4ea0-bb89-5dd06decd975" />
						<Performer id="a7aec831-c923-4b4a-fbef-e72b182fe2ce" />
						<Performer id="8798c500-531f-4ebd-bd9e-8d6e7b4d3d44" />
						<Performer id="14850863-54eb-4672-c399-3b435243cda6" />
						<Performer id="9c0c7228-f9a5-4ec5-9d0c-2866af5aebbb" />
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null" />
					</Actions>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="72" height="32" top="199" left="738" />
					</Geography>
				</Activity>
				<Activity name="站长" id="5fd89df6-a1af-4866-f90c-11f29e84165f" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode" />
					<Performers>
						<Performer id="328d11d9-a7d1-4fa9-a91f-96f68ff1df83" />
						<Performer id="b956b194-f9d9-419d-b148-f7e7f4cfad1d" />
						<Performer id="a0e0a67a-68af-4e44-d0d5-c8d3880f668e" />
						<Performer id="f42284e6-9b04-43be-a50e-c7216ede6183" />
						<Performer id="6fd2291b-527c-49e5-dcb0-3cad3e41ad69" />
						<Performer id="43451c4a-2396-4158-a71b-c92245955b57" />
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null" />
					</Actions>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="72" height="32" top="269" left="864" />
					</Geography>
				</Activity>
				<Activity name="结束" id="5dd66b5e-6088-4c01-f553-b2516f1e4e1f" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" />
					<Geography style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e">
						<Widget width="32" height="32" top="269" left="978" />
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition to="2bcf73ea-1594-4ace-8f98-2340f62d07af" from="cdb23070-d918-4dcd-e489-7f5f7dbbeb72" id="7ad485bc-1329-480f-e415-ea075e4d5cb2">
					<Description></Description>
					<Receiver type="Default" />
					<Condition type="null">
						<ConditionText />
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
				<Transition to="6ac6fba5-75d3-4134-8368-113ca30f7a71" from="2bcf73ea-1594-4ace-8f98-2340f62d07af" id="9f97ed9f-c016-4e73-a1f0-bc973d09313b">
					<Description></Description>
					<Receiver />
					<Condition type="Expression">
						<ConditionText />
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
				<Transition to="5d081ba0-62e6-404b-9c32-709886f88498" from="6ac6fba5-75d3-4134-8368-113ca30f7a71" id="7b79a1a7-f4dd-43e7-d81c-60f95e427312">
					<Description></Description>
					<Receiver type="Default" />
					<Condition type="null">
						<ConditionText />
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
				<Transition to="161af09d-88fa-4dec-d3cc-00c337c3a932" from="5d081ba0-62e6-404b-9c32-709886f88498" id="a9d0a5dc-2bb9-4e05-cce1-732dad950a11">
					<Description></Description>
					<Receiver type="Default" />
					<Condition type="null">
						<ConditionText />
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
				<Transition to="a017f053-0331-4725-d639-f763d76b54a7" from="161af09d-88fa-4dec-d3cc-00c337c3a932" id="6ec1ba17-7ef4-450f-ee1d-7c1f36b74c68">
					<Description></Description>
					<Receiver type="Default" />
					<Condition type="null">
						<ConditionText />
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
				<Transition to="5ccfd4c7-0083-4657-d35b-67fcd1781af1" from="a017f053-0331-4725-d639-f763d76b54a7" id="688dd33a-8c88-4d74-e207-43b5c5cf9e83">
					<Description></Description>
					<Receiver />
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[flag=1]]>
						</ConditionText>
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
				<Transition to="5fd89df6-a1af-4866-f90c-11f29e84165f" from="a017f053-0331-4725-d639-f763d76b54a7" id="292f63b8-2585-4bd3-cfab-63805cd1b8a7">
					<Description></Description>
					<Receiver />
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[flag=0]]>
						</ConditionText>
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
				<Transition to="5fd89df6-a1af-4866-f90c-11f29e84165f" from="5ccfd4c7-0083-4657-d35b-67fcd1781af1" id="e1f1d741-9212-4c12-8f9c-1228021baa16">
					<Description></Description>
					<Receiver type="Default" />
					<Condition type="null">
						<ConditionText />
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
				<Transition to="5dd66b5e-6088-4c01-f553-b2516f1e4e1f" from="5fd89df6-a1af-4866-f90c-11f29e84165f" id="457b861d-4f80-49ec-b088-9586dd0af7b2">
					<Description></Description>
					<Receiver type="Default" />
					<Condition type="null">
						<ConditionText />
					</Condition>
					<Geography style="undefined" parent="c2db9291-c1f8-49f9-85bf-3e097a19106e" />
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes />
		<Groups />
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000A9DC01687AD6 AS DateTime), CAST(0x0000A9FF00AAE18E AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (282, N'b36baa00-e07e-4f91-a5a4-645b015ca7fc', N'1', N'办理内部工作联系单', N'WorkFormProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="d5f943e1-2697-4562-b7d8-71000f62c8e2" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="f4715de8-54bf-4233-d9f3-a7bec1fe5ae6" name="副总经理" code="deputygeneralmanager" outerId="7"/>
		<Participant type="Role" id="89d9ed30-4376-406f-9858-9cf2c828872d" name="总经理" code="generalmanager" outerId="8"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="办理内部工作联系单" id="b36baa00-e07e-4f91-a5a4-645b015ca7fc">
			<Description>null</Description>
			<Activities>
				<Activity id="f44aa7c0-fe24-427c-a9ee-b5f914845f44" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Actions>
						<Action type="Event" fire="After" expression="Slickflow.Module.External.OrderSubmitService"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png;strokeColor=green;fillColor=green;fontSize=12;">
						<Widget left="50" top="110" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7a4a6113-62d5-4c4c-e93d-e08df14435d3" name="编制" code="bianzhi" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="fontSize=12;">
						<Widget left="130" top="110" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="80fde130-b371-4b63-92b1-cd990e853399" name="审批" code="shenpi" url="null">
					<Description>审批</Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignForward" mergeType="Sequence" compareType="Percentage" completeOrder="100"/>
					<Performers>
						<Performer id="d5f943e1-2697-4562-b7d8-71000f62c8e2"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png;fontSize=12;">
						<Widget left="370" top="50" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7a54baa5-8dbf-48db-8851-cfd5b2f23a39" name="gateway-split" code="" url="null">
					<Description>是否审批</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="260" top="110" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f9f48181-9a07-4c8c-dd03-4ef9a3777306" name="批准" code="pizhun" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="f4715de8-54bf-4233-d9f3-a7bec1fe5ae6"/>
						<Performer id="89d9ed30-4376-406f-9858-9cf2c828872d"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="fontSize=12;">
						<Widget left="510" top="110" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ee6e8c8d-061c-4a3c-ef58-ca133d038be8" name="办理" code="banli" url="null">
					<Description>接受部门办理</Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Parallel" compareType="Percentage" completeOrder="100"/>
					<Performers>
						<Performer id="d5f943e1-2697-4562-b7d8-71000f62c8e2"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod" fire="null"/>
					</Actions>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png;fontSize=12;">
						<Widget left="630" top="110" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1382a71f-e9f3-420f-d76c-1722a8af1bb1" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Actions>
						<Action type="Event" fire="After" expression="Slickflow.Module.External.OrderCompletedService"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png;fontSize=12;">
						<Widget left="748" top="110" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="eb058264-3843-4d8f-ee82-36e4a70edfc2" from="f44aa7c0-fe24-427c-a9ee-b5f914845f44" to="7a4a6113-62d5-4c4c-e93d-e08df14435d3">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="undefined"/>
				</Transition>
				<Transition id="9ede3a90-b755-4f60-db6c-9b2f2349b444" from="7a4a6113-62d5-4c4c-e93d-e08df14435d3" to="7a54baa5-8dbf-48db-8851-cfd5b2f23a39">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="undefined"/>
				</Transition>
				<Transition id="7ccce4c0-9321-4390-b36d-93604462cde3" from="7a54baa5-8dbf-48db-8851-cfd5b2f23a39" to="80fde130-b371-4b63-92b1-cd990e853399">
					<Description>审批</Description>
					<Receiver type="Compeer"/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Checker!=""]]>
						</ConditionText>
					</Condition>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="undefined"/>
				</Transition>
				<Transition id="6db8c1d3-f48a-49da-fd86-9340dd986165" from="80fde130-b371-4b63-92b1-cd990e853399" to="f9f48181-9a07-4c8c-dd03-4ef9a3777306">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="undefined"/>
				</Transition>
				<Transition id="fd063237-3205-40ca-eb33-18e2584950b0" from="7a54baa5-8dbf-48db-8851-cfd5b2f23a39" to="f9f48181-9a07-4c8c-dd03-4ef9a3777306">
					<Description>不审批</Description>
					<Receiver type="Superior"/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Checker==""]]>
						</ConditionText>
					</Condition>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="strokeColor=blue;fillColor=blue;"/>
				</Transition>
				<Transition id="f93de2c2-83a3-4a85-d5c1-959ddc78a6d6" from="f9f48181-9a07-4c8c-dd03-4ef9a3777306" to="ee6e8c8d-061c-4a3c-ef58-ca133d038be8">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="undefined"/>
				</Transition>
				<Transition id="fe7a85c9-c2f3-4a66-c083-91d23294c799" from="ee6e8c8d-061c-4a3c-ef58-ca133d038be8" to="1382a71f-e9f3-420f-d76c-1722a8af1bb1">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="398b6e02-2574-4e87-bc67-b477ae49be52" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000AA0600B15B93 AS DateTime), CAST(0x0000AA0B0140E3B5 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (284, N'1126bef6-b250-4bd1-9539-c3ebda8312ae', N'1', N'分支合并流程测试(AndSplitAndJoin)', N'SplitJoinTEst', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="212de713-1d5d-4718-fd60-d469be951f98" name="testrole" code="testrole" outerId="21"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="分支合并流程测试(AndSplitAndJoin)" id="1126bef6-b250-4bd1-9539-c3ebda8312ae">
			<Description>null</Description>
			<Activities>
				<Activity id="bd59c9ea-30f7-4158-95e4-c6a5624bad46" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="210" top="220" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="dd308e9f-7746-4036-a4e6-8308828a3839" name="001" code="test-001" url="">
					<Description>desc</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="212de713-1d5d-4718-fd60-d469be951f98"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[name\jack]]>
						</Section>
					</Sections>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="undefined">
						<Widget left="320" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d2f19cb7-6bb4-454d-f383-021d8448ff1a" name="gateway-split" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="470" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="608fce0f-6083-4303-dc7b-d17b7f01f68d" name="002" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="undefined">
						<Widget left="620" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c698384d-b51e-420c-d398-25b7ddea9db7" name="003" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="undefined">
						<Widget left="620" top="254" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7a739b9e-87d9-4cfd-db92-4cadf907d975" name="gateway-join" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin" gatewayJoinPass="null"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="770" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b21334d0-365c-493b-fe31-3c529ccca939" name="004" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="undefined">
						<Widget left="900" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f6b443d3-1f4d-49af-cd89-c136859a1330" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Actions>
						<Action type="Event" fire="Before" method="LocalMethod" expression="hello"/>
					</Actions>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1050" top="220" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="cfc107d2-95a1-4feb-804f-8e3d19442024" from="bd59c9ea-30f7-4158-95e4-c6a5624bad46" to="dd308e9f-7746-4036-a4e6-8308828a3839">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="null"/>
				</Transition>
				<Transition id="df3eb63c-a9c4-4802-dd2a-14e8c8c90ca1" from="dd308e9f-7746-4036-a4e6-8308828a3839" to="d2f19cb7-6bb4-454d-f383-021d8448ff1a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="null"/>
				</Transition>
				<Transition id="05828cb5-c133-4cfa-cf72-ae5d776fd0a7" from="d2f19cb7-6bb4-454d-f383-021d8448ff1a" to="608fce0f-6083-4303-dc7b-d17b7f01f68d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="null"/>
				</Transition>
				<Transition id="fc4faddd-a7e5-4fef-a1f2-f78ab806b2b1" from="d2f19cb7-6bb4-454d-f383-021d8448ff1a" to="c698384d-b51e-420c-d398-25b7ddea9db7">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="null"/>
				</Transition>
				<Transition id="55926a33-f645-4f60-f371-8fe73985c0f2" from="608fce0f-6083-4303-dc7b-d17b7f01f68d" to="7a739b9e-87d9-4cfd-db92-4cadf907d975">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="null"/>
				</Transition>
				<Transition id="3790672e-7193-40ec-8ffc-721f4bb23568" from="c698384d-b51e-420c-d398-25b7ddea9db7" to="7a739b9e-87d9-4cfd-db92-4cadf907d975">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="null"/>
				</Transition>
				<Transition id="cbf71a18-a69b-418d-e2f5-7f0d968a8d63" from="7a739b9e-87d9-4cfd-db92-4cadf907d975" to="b21334d0-365c-493b-fe31-3c529ccca939">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="null"/>
				</Transition>
				<Transition id="07a38927-b167-4f89-fd7e-ff4950271304" from="b21334d0-365c-493b-fe31-3c529ccca939" to="f6b443d3-1f4d-49af-cd89-c136859a1330">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="3ea649ff-c371-4271-e1ca-a75d348dfe6f" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000AA1800ED1CAF AS DateTime), CAST(0x0000AA64009CCA71 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (285, N'be3ab44e-22e2-4d08-a1e2-2aa3632f7918', N'1', N'并行会签测试(SignTogether-P)', N'SignTogether-P', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="并行会签测试(SignTogether-P)" id="be3ab44e-22e2-4d08-a1e2-2aa3632f7918">
			<Description>null</Description>
			<Activities>
				<Activity id="7e119a71-cbe5-4a10-d363-fa47ee3e4bb6" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="270" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4fe500b4-68db-4c7c-bff3-8904d63ea0a5" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="840" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2794216e-6402-4383-d1e5-7f292e3ef505" name="Submit" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="undefined">
						<Widget left="380" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="48a71126-e77f-4568-8892-3bcc58051350" name="Confirm" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="undefined">
						<Widget left="680" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fe881d0b-30ca-4e70-cbb1-25ad103c3600" name="Sign Together" code="" url="null">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Parallel" compareType="Percentage" completeOrder="0.5"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="530" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="c3c10397-b823-4418-d482-548d8c0924c1" from="7e119a71-cbe5-4a10-d363-fa47ee3e4bb6" to="2794216e-6402-4383-d1e5-7f292e3ef505">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="null"/>
				</Transition>
				<Transition id="b0fe1a8d-7b3e-4888-9599-9897c49aa783" from="2794216e-6402-4383-d1e5-7f292e3ef505" to="fe881d0b-30ca-4e70-cbb1-25ad103c3600">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="null"/>
				</Transition>
				<Transition id="c6090a21-4b58-4e95-d4f3-829f4a84d721" from="fe881d0b-30ca-4e70-cbb1-25ad103c3600" to="48a71126-e77f-4568-8892-3bcc58051350">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="null"/>
				</Transition>
				<Transition id="48a708c6-780d-4363-e16f-3e42f3d79852" from="48a71126-e77f-4568-8892-3bcc58051350" to="4fe500b4-68db-4c7c-bff3-8904d63ea0a5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="1755af83-91f5-4634-b0f1-ab2a75f6f7bf" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000AA1D00888D1A AS DateTime), CAST(0x0000AA63010287C0 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (286, N'ba48a387-cee0-49b8-8f07-92bfd6073a7d', N'1', N'分支合并流程测试(OrSplitOrJoin)', N'ProcessOrSplitOrJoin', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="分支合并流程测试(OrSplitOrJoin)" id="ba48a387-cee0-49b8-8f07-92bfd6073a7d">
			<Description>null</Description>
			<Activities>
				<Activity id="c50a02a8-1926-4768-c241-03299e4072c8" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="250" top="280" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="30cf9abf-5ae2-4221-8b13-d98685274fea" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1080" top="280" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="78c8d13b-70de-45f3-fc62-0e57d71eb09f" name="gateway-split" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="500" top="280" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7968a6c2-8897-4d1b-b1f7-1f93fb4301e9" name="001" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="undefined">
						<Widget left="350" top="280" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a727bc3a-9bcd-4cbc-b348-5ea0d16969b5" name="002" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="undefined">
						<Widget left="650" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="38da1498-c0cf-46d7-a351-f14a89e96be5" name="003" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="undefined">
						<Widget left="650" top="296" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2827af86-be47-43f5-c2a9-65c71fdc7f61" name="004" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="undefined">
						<Widget left="940" top="280" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="489fd92b-e696-4c7d-8046-873bc54a5d21" name="gateway-join" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="816" top="280" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="69d3682c-cf06-438b-cb5e-aef2856aa00e" name="Task" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="undefined">
						<Widget left="650" top="408" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="3363672a-2004-4c76-d434-16dbe6cde7cb" from="c50a02a8-1926-4768-c241-03299e4072c8" to="7968a6c2-8897-4d1b-b1f7-1f93fb4301e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="b1b6bd22-9107-4e4d-9315-8a3e62c99a25" from="7968a6c2-8897-4d1b-b1f7-1f93fb4301e9" to="78c8d13b-70de-45f3-fc62-0e57d71eb09f">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="5935cdd3-ec56-44b6-a8cf-40b1d20c12c1" from="78c8d13b-70de-45f3-fc62-0e57d71eb09f" to="a727bc3a-9bcd-4cbc-b348-5ea0d16969b5">
					<Description>islarge==1</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[islarge==1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="95a9c667-8e9d-4721-f387-7426e5d75950" from="78c8d13b-70de-45f3-fc62-0e57d71eb09f" to="38da1498-c0cf-46d7-a351-f14a89e96be5">
					<Description>islarge=0</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[islarge==0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="67fd11f4-f875-4c1c-fe06-0bd118168d1d" from="a727bc3a-9bcd-4cbc-b348-5ea0d16969b5" to="489fd92b-e696-4c7d-8046-873bc54a5d21">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="e1c23f42-4f83-413e-b4fe-ab56d8420e56" from="38da1498-c0cf-46d7-a351-f14a89e96be5" to="489fd92b-e696-4c7d-8046-873bc54a5d21">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="b346beb6-c365-4ce9-80b8-d83f0a57b962" from="489fd92b-e696-4c7d-8046-873bc54a5d21" to="2827af86-be47-43f5-c2a9-65c71fdc7f61">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="d899c551-6fd5-46be-a631-f9ce6837811b" from="2827af86-be47-43f5-c2a9-65c71fdc7f61" to="30cf9abf-5ae2-4221-8b13-d98685274fea">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="94399203-8b77-42e4-ff50-1105ccbb6ed4" from="78c8d13b-70de-45f3-fc62-0e57d71eb09f" to="69d3682c-cf06-438b-cb5e-aef2856aa00e">
					<Description>islarge=0</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[islarge==0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
				<Transition id="13f37f20-ef76-4c8e-8640-bc29f3cac552" from="69d3682c-cf06-438b-cb5e-aef2856aa00e" to="489fd92b-e696-4c7d-8046-873bc54a5d21">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="8b270375-7518-407b-ff71-0d1568065b25" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000AA290086A5EF AS DateTime), CAST(0x0000AA4000F02A94 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (289, N'a00cc149-b4d5-4c33-af3e-7633ace0afef', N'1', N'轻化所检测动态流程', N'InstituteReviewProcess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="71788d76-f0e7-411a-9cc9-53bd788beed9" name="室主任" code="deptleader" outerId="25"/>
		<Participant type="Role" id="9a3d84c9-7627-43a3-cf8e-403a2b820d76" name="化学检测室" code="qhchemerity" outerId="119"/>
		<Participant type="Role" id="cb4d528c-e586-4867-ec10-e80a2e578dc7" name="玻璃检测室" code="glass" outerId="122"/>
		<Participant type="Role" id="0fda3e55-6b67-4e2c-fd2e-faaf53b18f17" name="维生素组" code="vitamin" outerId="300"/>
		<Participant type="Role" id="35209c98-9c95-45c4-9c1a-2e433d93cafc" name="理化一室1组" code="chemistryone1" outerId="294"/>
		<Participant type="Role" id="2377977b-324c-46ea-adee-099cfd402b5f" name="元素组" code="element" outerId="291"/>
		<Participant type="Role" id="47ac06d7-6814-4ae3-92b5-8fb6de52b4bf" name="其它微生物组" code="microbeother" outerId="303"/>
		<Participant type="Role" id="e1acdf54-a722-4539-ace6-b427f9b24cce" name="微生物非食品组" code="microbenonfood" outerId="302"/>
		<Participant type="Role" id="d4c9976a-39fa-4f5b-9716-dd3b71c9a4cc" name="微生物食品指示菌组" code="microbeindication" outerId="304"/>
		<Participant type="Role" id="69e6814c-e8e1-4b9c-9c06-c794a8d8bc77" name="微生物食品致病菌组" code="microbedisease" outerId="305"/>
		<Participant type="Role" id="f15d5b1c-2cc0-4213-cfb4-61006633680a" name="标签感官组" code="labelsense" outerId="297"/>
		<Participant type="Role" id="843f2247-d06c-4056-8818-970291627127" name="气相组" code="gas" outerId="292"/>
		<Participant type="Role" id="5894203b-66dd-481b-fb9b-caa3489eef5b" name="液相组" code="liquid" outerId="293"/>
		<Participant type="Role" id="0b9844b7-3665-4fd4-f89a-4a7db108dcc4" name="理化一室2组" code="chemistryone2" outerId="295"/>
		<Participant type="Role" id="a49397bf-10e9-4aee-f6a0-b2d297516236" name="理化一室3组" code="chemistryone3" outerId="296"/>
		<Participant type="Role" id="2eb66a86-4032-4cca-f69b-40fe62fb29fc" name="理化二室日化组" code="chemistrytwodaily" outerId="299"/>
		<Participant type="Role" id="48a7f342-81b3-4f4e-84f1-f955c24c1a4d" name="理化二室食品组" code="chemistrytwofood" outerId="298"/>
		<Participant type="Role" id="b0299582-d7b4-470a-9cf4-b37739455e72" name="组员" code="member" outerId="27"/>
		<Participant type="Role" id="9b27b9c2-ad44-47c7-90ba-73f2e0c280fe" name="业务登记人员" code="bizregistrar" outerId="23"/>
		<Participant type="Role" id="6c82341a-9865-4f1f-b9e9-d10085352eae" name="测试人员" code="tester" outerId="36"/>
		<Participant type="Role" id="de14baf0-872a-44d7-b48b-2d3f5f57d039" name="业务分配人员" code="bizdistribution" outerId="24"/>
		<Participant type="Role" id="5cffa58b-a14a-47b9-a10c-d27a9d05c537" name="报告审核人员" code="reportchecker" outerId="30"/>
		<Participant type="Role" id="c16b6528-f6b4-437b-d0be-29cc71890a0e" name="报告打印人员" code="reportprinter" outerId="33"/>
		<Participant type="Role" id="e0a68c3e-2edf-4357-cace-678a8ebb599a" name="报告批准人员" code="reportapprover" outerId="31"/>
		<Participant type="Role" id="88b61f2c-09d7-46f4-8646-54047fa15a72" name="报告归档人员" code="reportarchiver" outerId="35"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="轻化所检测动态流程" id="cd5c33f6-d2a3-4cb7-9297-1b032706129e">
			<Description>null</Description>
			<Activities>
				<Activity id="0cf6bf99-ebc6-4bb8-93d8-ee7d1bbbce69" name="本所科室分配项目" code="" url="/QhBusinessItemToPerson/index" myProperties="&quot;MultiSelect&quot;:&quot;true&quot;,&quot;BatchURL&quot;:&quot;/QhBusinessItemToPerson/ItemToPersonBatchDistribute&quot;,&quot;DefaultConditions&quot;:&quot;&quot;">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="71788d76-f0e7-411a-9cc9-53bd788beed9"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="21ffa374-8b34-4d15-fc26-90e12a6c8a3e" style="undefined">
						<Widget left="10" top="10" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="43d1bfb2-86c7-4964-c2db-e0a04fa775bf" name="检验员录入" code="" url="/QhInspector/index" myProperties="&quot;MultiSelect&quot;:&quot;true&quot;,&quot;BatchURL&quot;:&quot;/Inspector/InspectorBatchInput&quot;,&quot;DefaultConditions&quot;:&quot;&quot;">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Parallel" compareType="Percentage" completeOrder="100"/>
					<Performers>
						<Performer id="9a3d84c9-7627-43a3-cf8e-403a2b820d76"/>
						<Performer id="cb4d528c-e586-4867-ec10-e80a2e578dc7"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="21ffa374-8b34-4d15-fc26-90e12a6c8a3e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="10" top="70" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="15b9b7a8-ae9e-4dcb-eb6a-ac56abe6b929" name="外所科室分配项目" code="" url="/QhBusinessItemToPerson/index" myProperties="&quot;MultiSelect&quot;:&quot;true&quot;,&quot;BatchURL&quot;:&quot;/QhBusinessItemToPerson/ItemToPersonBatchDistribute&quot;,&quot;DefaultConditions&quot;:&quot;&quot;">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="0fda3e55-6b67-4e2c-fd2e-faaf53b18f17"/>
						<Performer id="35209c98-9c95-45c4-9c1a-2e433d93cafc"/>
						<Performer id="2377977b-324c-46ea-adee-099cfd402b5f"/>
						<Performer id="47ac06d7-6814-4ae3-92b5-8fb6de52b4bf"/>
						<Performer id="e1acdf54-a722-4539-ace6-b427f9b24cce"/>
						<Performer id="d4c9976a-39fa-4f5b-9716-dd3b71c9a4cc"/>
						<Performer id="69e6814c-e8e1-4b9c-9c06-c794a8d8bc77"/>
						<Performer id="f15d5b1c-2cc0-4213-cfb4-61006633680a"/>
						<Performer id="843f2247-d06c-4056-8818-970291627127"/>
						<Performer id="5894203b-66dd-481b-fb9b-caa3489eef5b"/>
						<Performer id="0b9844b7-3665-4fd4-f89a-4a7db108dcc4"/>
						<Performer id="a49397bf-10e9-4aee-f6a0-b2d297516236"/>
						<Performer id="2eb66a86-4032-4cca-f69b-40fe62fb29fc"/>
						<Performer id="48a7f342-81b3-4f4e-84f1-f955c24c1a4d"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="98b35609-7d1d-408b-f550-5ddf849252b7" style="undefined">
						<Widget left="10" top="10" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b9d3dc30-6128-4081-cc74-b27c1110ba08" name="外所检验员录入" code="" url="/QhInspector/index" myProperties="&quot;MultiSelect&quot;:&quot;true&quot;,&quot;BatchURL&quot;:&quot;/Inspector/InspectorBatchInput&quot;,&quot;DefaultConditions&quot;:&quot;&quot;">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="null" mergeType="null" compareType="null" completeOrder=""/>
					<Performers>
						<Performer id="b0299582-d7b4-470a-9cf4-b37739455e72"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="98b35609-7d1d-408b-f550-5ddf849252b7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="10" top="70" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9ccc208c-01a6-47f0-bde3-42dbfc98edd5" name="外所科室汇总审核" code="" url="" myProperties="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="98b35609-7d1d-408b-f550-5ddf849252b7" style="undefined">
						<Widget left="10" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bbaa314a-d78c-476b-8a0e-58c4c153e422" name="开始" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="460" top="10" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3f2ad2f8-7e5e-411c-bd0c-4d4cc0390f3b" name="业务登记" code="" url="/QhBusiness/index" myProperties="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="9b27b9c2-ad44-47c7-90ba-73f2e0c280fe"/>
						<Performer id="6c82341a-9865-4f1f-b9e9-d10085352eae"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Widget left="440" top="70" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f72a5d5a-7155-41da-b63e-c2c0f20bd11c" name="业务科分配任务" code="" url="/QHtaskdistribute/index" myProperties="&quot;MultiSelect&quot;:&quot;false&quot;,&quot;BatchURL&quot;:&quot;/QhTaskDistribute/TaskBatchDistribute&quot;">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6c82341a-9865-4f1f-b9e9-d10085352eae"/>
						<Performer id="de14baf0-872a-44d7-b48b-2d3f5f57d039"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Widget left="440" top="130" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="88bb6545-b196-4631-8aaa-95feaf257e76" name="OR" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="440" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="14c6e578-fc0d-46b2-abf1-91d1cd662ef0" name="AND分支(多实例)" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI"/>
					<Actions>
						<Action type="null" fire="null"/>
					</Actions>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="440" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a2c294b9-00f1-46a9-e394-3d5124e42b86" name="AND合并(多实例)" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI"/>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="440" top="480" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="48a54022-a095-4f97-9f2f-17f212e00192" name="AND分支多实例" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI"/>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="714" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ce6ec6bc-b5fc-48b4-b413-86b305f12679" name="AND合并多实例" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI"/>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="714" top="560" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ba87f7a6-d925-4c5a-e4b3-a083ebfe3b6e" name="OR合并" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin"/>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="570" top="680" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6b8366c6-8a22-4142-f071-72c7c197870f" name="报告编制(主检)" code="" url="" myProperties="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6c82341a-9865-4f1f-b9e9-d10085352eae"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Widget left="556" top="760" width="100" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1a460294-7827-477b-c2f2-7b92d2d0fac1" name="结束" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="590" top="1070" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2c13e424-71cd-48b8-c592-81b01d9046cf" name="报告审核" code="" url="" myProperties="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="5cffa58b-a14a-47b9-a10c-d27a9d05c537"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Widget left="570" top="820" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="acd8469b-9fca-421e-d3a2-2365c728bd86" name="报告打印" code="" url="" myProperties="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c16b6528-f6b4-437b-d0be-29cc71890a0e"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Widget left="570" top="940" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3e614c86-49a2-4314-e3ca-b7c960e845fe" name="报告批准" code="" url="" myProperties="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="e0a68c3e-2edf-4357-cace-678a8ebb599a"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Widget left="570" top="880" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4ef4aa1f-92d0-47ed-9b82-f204156ff7b8" name="报告归档" code="" url="" myProperties="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="88b61f2c-09d7-46f4-8646-54047fa15a72"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Widget left="570" top="1000" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c6014c71-50a0-4fa1-b16c-cd0cabe917d0" name="报告编制" code="" url="" myProperties="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="None" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Widget left="440" top="680" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="62fff595-bdd1-45d2-95f7-114d45189c84" name="OR" code="" url="null" myProperties="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Boundaries>
						<Boundary event="null" expression="null"/>
					</Boundaries>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="440" top="560" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="d0a7aa37-e7e6-46bf-bc69-42e88a75bf99" from="bbaa314a-d78c-476b-8a0e-58c4c153e422" to="3f2ad2f8-7e5e-411c-bd0c-4d4cc0390f3b">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="8d684732-1057-43d4-d98d-3d6112e2a9a7" from="3f2ad2f8-7e5e-411c-bd0c-4d4cc0390f3b" to="f72a5d5a-7155-41da-b63e-c2c0f20bd11c">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="826b70f4-10fd-4dd2-a55a-d1f45dd685ea" from="f72a5d5a-7155-41da-b63e-c2c0f20bd11c" to="88bb6545-b196-4631-8aaa-95feaf257e76">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="f4284a72-9277-4d1e-bd7d-8209ba5b1d1f" from="88bb6545-b196-4631-8aaa-95feaf257e76" to="14c6e578-fc0d-46b2-abf1-91d1cd662ef0">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[reportmake=="false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="360ca060-e2d9-44fd-c964-996faf255568" from="14c6e578-fc0d-46b2-abf1-91d1cd662ef0" to="0cf6bf99-ebc6-4bb8-93d8-ee7d1bbbce69">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="ad04f19f-0aa1-4e32-b56e-2853d6d381e5" from="88bb6545-b196-4631-8aaa-95feaf257e76" to="48a54022-a095-4f97-9f2f-17f212e00192">
					<Description>分包至外所</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[gotoother=="true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined;fontColor=red;">
						<Points>
							<Point x="750" y="240"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="c910b9ff-61bb-48a9-bada-979a967ce19b" from="48a54022-a095-4f97-9f2f-17f212e00192" to="15b9b7a8-ae9e-4dcb-eb6a-ac56abe6b929">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="bcab401e-18f4-4a10-ec82-64198a56c75b" from="9ccc208c-01a6-47f0-bde3-42dbfc98edd5" to="ce6ec6bc-b5fc-48b4-b413-86b305f12679">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="32449303-be76-4b8e-c7c4-9fc378c454b3" from="ce6ec6bc-b5fc-48b4-b413-86b305f12679" to="ba87f7a6-d925-4c5a-e4b3-a083ebfe3b6e">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined">
						<Points>
							<Point x="750" y="640"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="fc1870af-d15e-4a4b-cd9f-f18c087fd127" from="ba87f7a6-d925-4c5a-e4b3-a083ebfe3b6e" to="6b8366c6-8a22-4142-f071-72c7c197870f">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="e22e80fd-4c92-4e4b-822e-c1b428e79ddd" from="6b8366c6-8a22-4142-f071-72c7c197870f" to="2c13e424-71cd-48b8-c592-81b01d9046cf">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="d6dec07f-9d60-4b5f-8b28-c7299843c384" from="2c13e424-71cd-48b8-c592-81b01d9046cf" to="3e614c86-49a2-4314-e3ca-b7c960e845fe">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="d47f002f-e02d-41a3-e23e-e1bc1038457d" from="3e614c86-49a2-4314-e3ca-b7c960e845fe" to="acd8469b-9fca-421e-d3a2-2365c728bd86">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="46360889-84fa-46df-f21d-fa512bede012" from="acd8469b-9fca-421e-d3a2-2365c728bd86" to="4ef4aa1f-92d0-47ed-9b82-f204156ff7b8">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="ee5c7b10-57b6-40a1-9ce4-59d1d85e48aa" from="4ef4aa1f-92d0-47ed-9b82-f204156ff7b8" to="1a460294-7827-477b-c2f2-7b92d2d0fac1">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="dce29321-4b76-4dab-85d0-3ea56e1b8162" from="88bb6545-b196-4631-8aaa-95feaf257e76" to="6b8366c6-8a22-4142-f071-72c7c197870f">
					<Description>直接报告编制</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[reportmake=="true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined;strokeColor=blue;fillColor=blue;fontColor=green;">
						<Points>
							<Point x="220" y="470"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="2b5cc7f4-9c5a-40d5-8389-b9665ab5c25b" from="43d1bfb2-86c7-4964-c2db-e0a04fa775bf" to="a2c294b9-00f1-46a9-e394-3d5124e42b86">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="f8784f36-6ade-4290-8af4-976e08752ccc" from="62fff595-bdd1-45d2-95f7-114d45189c84" to="c6014c71-50a0-4fa1-b16c-cd0cabe917d0">
					<Description>代理报告编制</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[gotomain=="false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined;fontColor=red;"/>
				</Transition>
				<Transition id="b44df3b5-82d8-4e3d-e674-15bd6a092546" from="a2c294b9-00f1-46a9-e394-3d5124e42b86" to="62fff595-bdd1-45d2-95f7-114d45189c84">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="054bd556-f42f-4f94-d3e1-2f0b0cb2e8b9" from="62fff595-bdd1-45d2-95f7-114d45189c84" to="ba87f7a6-d925-4c5a-e4b3-a083ebfe3b6e">
					<Description>直接到主检编制</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[gotomain=="true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined;fontColor=green;">
						<Points>
							<Point x="606" y="600"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="ca726b7c-e965-4402-ec4a-ae24fce74f3b" from="c6014c71-50a0-4fa1-b16c-cd0cabe917d0" to="ba87f7a6-d925-4c5a-e4b3-a083ebfe3b6e">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="undefined"/>
				</Transition>
				<Transition id="a0b0a6cd-ccfc-49c1-bbc9-fa65817442ee" from="0cf6bf99-ebc6-4bb8-93d8-ee7d1bbbce69" to="43d1bfb2-86c7-4964-c2db-e0a04fa775bf">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="21ffa374-8b34-4d15-fc26-90e12a6c8a3e" style="undefined"/>
				</Transition>
				<Transition id="080bf28d-c0e2-4113-f53a-b6a78ef3c9c0" from="15b9b7a8-ae9e-4dcb-eb6a-ac56abe6b929" to="b9d3dc30-6128-4081-cc74-b27c1110ba08">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="98b35609-7d1d-408b-f550-5ddf849252b7" style="undefined"/>
				</Transition>
				<Transition id="07f5441e-3f3e-4195-c2ed-4d57210f4409" from="b9d3dc30-6128-4081-cc74-b27c1110ba08" to="9ccc208c-01a6-47f0-bde3-42dbfc98edd5">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="98b35609-7d1d-408b-f550-5ddf849252b7" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups>
			<Group id="21ffa374-8b34-4d15-fc26-90e12a6c8a3e" name="">
				<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="group">
					<Widget left="430" top="330" width="92" height="112"/>
				</Geography>
			</Group>
			<Group id="98b35609-7d1d-408b-f550-5ddf849252b7" name="">
				<Geography parent="84811b73-e8d5-45ff-b37a-38531bcc45c8" style="group">
					<Widget left="704" top="330" width="92" height="192"/>
				</Geography>
			</Group>
		</Groups>
	</Layout>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AA2B00A35EFE AS DateTime), CAST(0x0000AA2B00A35F28 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (290, N'dd0865d2-2686-4904-9777-de1ddde1f491', N'1', N'分支嵌套测试流程(OrSplitNested)', N'OrSplitNested', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="分支嵌套测试流程(OrSplitNested)" id="dd0865d2-2686-4904-9777-de1ddde1f491">
			<Description>null</Description>
			<Activities>
				<Activity id="d329523b-03df-4a02-95f9-11928bcc323a" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="230" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9779be95-5f3e-48f4-f7a9-0afd4e85e60f" name="A" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="undefined">
						<Widget left="330" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c5980363-2253-4189-face-dfe2b573009f" name="or-split" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="500" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="097463f4-9cb6-488b-84bf-a084ee21bc78" name="or-split" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="640" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="808bee0e-7ecc-4a3f-d210-961406dae702" name="B" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="undefined">
						<Widget left="760" top="130" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="646e0c39-1e59-4f07-b303-b3f0d6b58682" name="C" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="undefined">
						<Widget left="770" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6cab87ce-eebd-469b-e4d9-edfa478532c1" name="D" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="undefined">
						<Widget left="720" top="340" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="84ecd404-5bab-4927-9edd-f24e4d083aec" name="or-join" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="910" top="180" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fb3b1ea0-1279-40a6-9d6c-574e6925bed4" name="or-join" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="1050" top="270" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2a36ddbe-1289-4810-bd3d-6d978823ff27" name="E" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="undefined">
						<Widget left="1210" top="280" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0d01b084-23c8-4b19-a5a9-480189f44076" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1220" top="410" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="952472e6-92a2-41f3-a008-224d01b7f8be" name="H" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="undefined">
						<Widget left="720" top="450" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="30d4201c-85a3-43e4-a177-8d8286ef9ab3" name="K" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="undefined">
						<Widget left="720" top="540" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="ecf81efe-7330-4397-ce1c-097a43f3269b" from="d329523b-03df-4a02-95f9-11928bcc323a" to="9779be95-5f3e-48f4-f7a9-0afd4e85e60f">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="1ffb4528-aad4-4651-f5c9-62fb4f64c386" from="9779be95-5f3e-48f4-f7a9-0afd4e85e60f" to="c5980363-2253-4189-face-dfe2b573009f">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="dacedf78-8f9f-4ddf-cc28-74f220622fb0" from="c5980363-2253-4189-face-dfe2b573009f" to="097463f4-9cb6-488b-84bf-a084ee21bc78">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[feeling=="smile"]]>
						</ConditionText>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="12f01b99-06cb-4618-d2cd-6e452297b87c" from="097463f4-9cb6-488b-84bf-a084ee21bc78" to="808bee0e-7ecc-4a3f-d210-961406dae702">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[money==1000]]>
						</ConditionText>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="6640b6be-6907-4e59-ac85-7225d56ad096" from="097463f4-9cb6-488b-84bf-a084ee21bc78" to="646e0c39-1e59-4f07-b303-b3f0d6b58682">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[money==50000]]>
						</ConditionText>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="2b8769a8-7954-4ae2-dd5f-1f6ecad16596" from="c5980363-2253-4189-face-dfe2b573009f" to="6cab87ce-eebd-469b-e4d9-edfa478532c1">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[feeling=="sad"]]>
						</ConditionText>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="d47ad6dd-be73-4032-ad18-eea7998ce48a" from="808bee0e-7ecc-4a3f-d210-961406dae702" to="84ecd404-5bab-4927-9edd-f24e4d083aec">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="24cd8ee7-f7ea-4397-96c3-d77a02a39d56" from="646e0c39-1e59-4f07-b303-b3f0d6b58682" to="84ecd404-5bab-4927-9edd-f24e4d083aec">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="ffb4135a-5243-4c8a-960a-7951c147df7c" from="6cab87ce-eebd-469b-e4d9-edfa478532c1" to="fb3b1ea0-1279-40a6-9d6c-574e6925bed4">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="caca6da6-43ef-4dc7-ad3b-fb4a1058dbc4" from="84ecd404-5bab-4927-9edd-f24e4d083aec" to="fb3b1ea0-1279-40a6-9d6c-574e6925bed4">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="4f5187f7-eef3-4c32-f1c7-7f2581f3062b" from="fb3b1ea0-1279-40a6-9d6c-574e6925bed4" to="2a36ddbe-1289-4810-bd3d-6d978823ff27">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="22f29534-208b-4e6a-e224-d2355bc1375b" from="2a36ddbe-1289-4810-bd3d-6d978823ff27" to="0d01b084-23c8-4b19-a5a9-480189f44076">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="3f459a1c-071f-441f-b976-000bdd3de9c5" from="c5980363-2253-4189-face-dfe2b573009f" to="952472e6-92a2-41f3-a008-224d01b7f8be">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[feeling=="smile"]]>
						</ConditionText>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="5257797f-8f39-4b18-90c1-63488934f327" from="952472e6-92a2-41f3-a008-224d01b7f8be" to="fb3b1ea0-1279-40a6-9d6c-574e6925bed4">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="d216b02b-242f-49f1-fdfd-9166428c1961" from="c5980363-2253-4189-face-dfe2b573009f" to="30d4201c-85a3-43e4-a177-8d8286ef9ab3">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[feeling=="smile"]]>
						</ConditionText>
					</Condition>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
				<Transition id="c0ac5b90-4b75-465c-ed01-5ca5385bddd2" from="30d4201c-85a3-43e4-a177-8d8286ef9ab3" to="fb3b1ea0-1279-40a6-9d6c-574e6925bed4">
					<Description></Description>
					<Receiver type="Default"/>
					<Condition/>
					<Geography parent="8fa5f909-0a20-4ccf-9791-63c846c41d58" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000AA2B00B1F73B AS DateTime), CAST(0x0000AA2C008B6326 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (291, N'aab213aa-b7a9-4af7-a3e4-9681b7059448', N'1', N'互斥分支合并测试(PriorityTest)', N'XORSplit', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="互斥分支合并测试" id="aab213aa-b7a9-4af7-a3e4-9681b7059448">
			<Description>null</Description>
			<Activities>
				<Activity id="6e2af975-9695-402f-8654-6366b4ff7fef" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="200" top="290" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ec4998f4-51ab-42ae-e0c9-2aa3a1de7cb7" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1130" top="292" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="83c5eab0-6f2b-42de-b9a5-cc047d3c8117" name="001" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="undefined">
						<Widget left="330" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3153cd47-e06a-4855-fe52-cc62ec045fe6" name="OrSplit" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="XOrSplit" gatewayJoinPass="null"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="490" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="eb499497-9978-4818-a390-4d7ad99df7fe" name="OrJoin" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="XOrJoin" gatewayJoinPass="null"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="760" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="70e6c40d-603f-41f2-ac0e-de861ba8d8e0" name="005" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="undefined">
						<Widget left="940" top="276" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="28880673-d4cb-4094-8bcd-8c2563915c4a" name="002" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="undefined">
						<Widget left="620" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f68be881-0ede-40b0-a4b5-7cc933401986" name="003" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="undefined">
						<Widget left="620" top="336" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6b25baaa-babc-4edd-9854-1e26f14b4080" name="004" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="undefined">
						<Widget left="620" top="438" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="9a2ba14c-e770-42a9-f5c3-129cf9b113c5" from="6e2af975-9695-402f-8654-6366b4ff7fef" to="83c5eab0-6f2b-42de-b9a5-cc047d3c8117">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="1c8b1f5a-ed60-4345-f90f-62a0f18a14f3" from="83c5eab0-6f2b-42de-b9a5-cc047d3c8117" to="3153cd47-e06a-4855-fe52-cc62ec045fe6">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="c6997864-54b3-472f-870c-c3259c1a4cc6" from="3153cd47-e06a-4855-fe52-cc62ec045fe6" to="28880673-d4cb-4094-8bcd-8c2563915c4a">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[reportmake=="false"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours priority="1" forced="null"/>
					<Receiver/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="bf8f30b2-e6fb-4368-f2e1-98d1fe5e1ca0" from="3153cd47-e06a-4855-fe52-cc62ec045fe6" to="f68be881-0ede-40b0-a4b5-7cc933401986">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[reportmake=="true"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours priority="0" forced="null"/>
					<Receiver/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="c307a747-d19b-4bad-d37a-0d99a711c0eb" from="28880673-d4cb-4094-8bcd-8c2563915c4a" to="eb499497-9978-4818-a390-4d7ad99df7fe">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="83b2d6c5-917e-4de0-dd8f-d6b89b3f9ef0" from="f68be881-0ede-40b0-a4b5-7cc933401986" to="eb499497-9978-4818-a390-4d7ad99df7fe">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="8001b128-eb97-45ba-9399-a2d71875f549" from="eb499497-9978-4818-a390-4d7ad99df7fe" to="70e6c40d-603f-41f2-ac0e-de861ba8d8e0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="286a64d4-4cad-4d5c-9f41-d9e7cf31ef66" from="70e6c40d-603f-41f2-ac0e-de861ba8d8e0" to="ec4998f4-51ab-42ae-e0c9-2aa3a1de7cb7">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="f276c09d-e0dc-45ee-af4d-fb56136a8b43" from="6b25baaa-babc-4edd-9854-1e26f14b4080" to="eb499497-9978-4818-a390-4d7ad99df7fe">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
				<Transition id="b6eb1ec8-ad73-4c7a-f061-8eb2aafdc493" from="3153cd47-e06a-4855-fe52-cc62ec045fe6" to="6b25baaa-babc-4edd-9854-1e26f14b4080">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[money==1000]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours priority="-1" forced="null"/>
					<Receiver/>
					<Geography parent="202285ad-90db-4166-dd2e-055f37374430" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000AA3A0089514A AS DateTime), CAST(0x0000AA3E00BB304E AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (292, N'cc94fe07-5314-445a-b2e4-131bbce28764', N'1', N'增强或合并测试(EOrJoinTest)', N'EOrJoinTest', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="cc94fe07-5314-445a-b2e4-131bbce28764" name="增强或合并测试(EOrJoinTest)" code="EOrJoinTest" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="6cae17e8-cdfd-465d-ea95-466a242cc8c1" name="开始" code="AE235X" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="190" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0cbf4155-199d-46d7-a8af-798c25d20d7f" name="结束" code="VNUV9H" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1120" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="acbe0ede-f450-42ef-c275-17e794da70af" name="001" code="NWZUNC" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="undefined">
						<Widget left="330" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b18023f2-ffe8-45b7-8a69-3b8be8e6f8cc" name="OrSplit" code="4V7AVX" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="470" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5b47bdb9-d537-4b1c-c318-5710c7b70724" name="002" code="95ICFH" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="undefined">
						<Widget left="660" top="140" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2bf0406b-56fa-4594-c964-064df2d1e45a" name="003" code="ITMYC6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="undefined">
						<Widget left="660" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3a11b1a6-3cd9-4cd2-f873-de96d3a9eea8" name="004" code="N7V3QI" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="undefined">
						<Widget left="660" top="370" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8588fd00-3f8e-49d9-da0b-efc05f33bbec" name="005" code="UR36ME" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="undefined">
						<Widget left="980" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d545624e-6281-4577-e1b6-01473f2e41b4" name="EOrJoinTokenCount:2&#xA;" code="PKK4R1" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="EOrJoin" gatewayJoinPass="TokenCountPass"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="850" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="34a0d45b-7510-45d0-d016-a330974c69b0" from="6cae17e8-cdfd-465d-ea95-466a242cc8c1" to="acbe0ede-f450-42ef-c275-17e794da70af">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="3643b229-b8c1-43dc-df30-92e4294badf1" from="acbe0ede-f450-42ef-c275-17e794da70af" to="b18023f2-ffe8-45b7-8a69-3b8be8e6f8cc">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="dbdbfc72-7cb7-4f6b-cac4-44e222b4f5de" from="b18023f2-ffe8-45b7-8a69-3b8be8e6f8cc" to="5b47bdb9-d537-4b1c-c318-5710c7b70724">
					<Description>reportmake==false</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[reportmake=="false"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="b945fa43-7a38-4183-bf91-b0323540bbfe" from="b18023f2-ffe8-45b7-8a69-3b8be8e6f8cc" to="2bf0406b-56fa-4594-c964-064df2d1e45a">
					<Description>age==18</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[age==18]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="0e33bfcd-baec-43b4-e597-7e0ba9bb31ec" from="b18023f2-ffe8-45b7-8a69-3b8be8e6f8cc" to="3a11b1a6-3cd9-4cd2-f873-de96d3a9eea8">
					<Description>money==1000</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[money==1000]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="5709ab9e-b889-492b-8158-d445808b2b29" from="8588fd00-3f8e-49d9-da0b-efc05f33bbec" to="0cbf4155-199d-46d7-a8af-798c25d20d7f">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="0ef5034d-e840-429d-b240-3a7a1055681a" from="5b47bdb9-d537-4b1c-c318-5710c7b70724" to="d545624e-6281-4577-e1b6-01473f2e41b4">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="7d6a28c9-0288-46b2-b0e0-5a92ee7afd51" from="2bf0406b-56fa-4594-c964-064df2d1e45a" to="d545624e-6281-4577-e1b6-01473f2e41b4">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="true"/>
					<Receiver/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="fdb32f0a-0bea-4943-888f-548e04fa8019" from="3a11b1a6-3cd9-4cd2-f873-de96d3a9eea8" to="d545624e-6281-4577-e1b6-01473f2e41b4">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="true"/>
					<Receiver/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
				<Transition id="7b26413f-1d84-4367-8adb-8ea81972b1db" from="d545624e-6281-4577-e1b6-01473f2e41b4" to="8588fd00-3f8e-49d9-da0b-efc05f33bbec">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="375f7d34-b6c6-4116-b8c6-3d6009189a84" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000AA3E00DA93F8 AS DateTime), CAST(0x0000ABF400E0F2E9 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (293, N'64d57eea-4b08-48ad-96bd-0f42b27baa0a', N'1', N'合并连接分支节点', N'SplitComesAfterJoin', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="合并连接分支节点" id="64d57eea-4b08-48ad-96bd-0f42b27baa0a">
			<Description>null</Description>
			<Activities>
				<Activity id="613ea8a5-9c4f-4645-c160-b988a8ac4c52" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="160" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1070" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e378ece7-2244-4b1a-9652-3b5b76129480" name="001" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="undefined">
						<Widget left="260" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" name="OrSplit" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="410" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853" name="OrJoin" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="710" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0904f559-b920-46aa-ae57-97aa780d02a1" name="002" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="undefined">
						<Widget left="560" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7b05fc1c-5b54-41de-a267-7026c47fbdb1" name="003" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="undefined">
						<Widget left="548" top="330" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2d84ae66-a801-4adf-8212-ded838279e88" name="AndSplit" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="810" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="703f422e-0e54-4b4d-f981-1d1bc34e6fde" name="004" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="undefined">
						<Widget left="920" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="42200780-72d0-4058-e1aa-886e157e21f6" name="005" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="undefined">
						<Widget left="930" top="320" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e9951f11-008b-4cc8-a0fe-078a67c8e21a" from="613ea8a5-9c4f-4645-c160-b988a8ac4c52" to="e378ece7-2244-4b1a-9652-3b5b76129480">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="1d70de3a-a7f1-432c-fbff-73a305c1ca6e" from="e378ece7-2244-4b1a-9652-3b5b76129480" to="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="cb29cf64-7564-4a19-af16-596aea112b24" from="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" to="0904f559-b920-46aa-ae57-97aa780d02a1">
					<Description>age==18</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[age==18]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="937fc350-72c3-471d-ed9b-eb4c45e74c20" from="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" to="7b05fc1c-5b54-41de-a267-7026c47fbdb1">
					<Description>gender==male</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[gender=="male"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="f44cd924-5711-4fc9-9ad3-5dbed753fef2" from="0904f559-b920-46aa-ae57-97aa780d02a1" to="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="7fbedc5f-0ee5-4d16-fe4a-5680b9737ef7" from="7b05fc1c-5b54-41de-a267-7026c47fbdb1" to="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="56639ee4-b267-49c0-fdb8-a5a11f2dd516" from="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853" to="2d84ae66-a801-4adf-8212-ded838279e88">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="c31d4b76-51f5-40ce-f3b6-c8a47160e915" from="2d84ae66-a801-4adf-8212-ded838279e88" to="703f422e-0e54-4b4d-f981-1d1bc34e6fde">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="b5ff04db-2c44-44f3-c1a8-31b928758121" from="703f422e-0e54-4b4d-f981-1d1bc34e6fde" to="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="11377463-2ef4-4513-d7bd-201367092532" from="2d84ae66-a801-4adf-8212-ded838279e88" to="42200780-72d0-4058-e1aa-886e157e21f6">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
				<Transition id="9c39376a-b0b5-47e0-9d8e-da8279cd30ea" from="42200780-72d0-4058-e1aa-886e157e21f6" to="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2e5cb146-2e59-45d7-9bc4-c6c2be93fa75" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000AA44008259D6 AS DateTime), CAST(0x0000AA450135EFCD AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (296, N'27040a76-6d98-489a-a99b-e64ec614208e', N'1', N'合并连接分支节点3', N'SplitComesAfter3', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="合并连接分支节点3" id="27040a76-6d98-489a-a99b-e64ec614208e">
			<Description>null</Description>
			<Activities>
				<Activity id="fcc9f828-4c28-4f8d-a035-28f3651e0d86" name="006" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="10d26377-1c52-43c4-9d67-6581d91547e6" style="undefined">
						<Widget left="20" top="39" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c5cec488-dfba-4810-a6b9-314322b20f06" name="007" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="10d26377-1c52-43c4-9d67-6581d91547e6" style="undefined">
						<Widget left="156" top="34" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="613ea8a5-9c4f-4645-c160-b988a8ac4c52" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="160" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1180" top="260" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e378ece7-2244-4b1a-9652-3b5b76129480" name="001" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="undefined">
						<Widget left="260" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" name="AndSplitMI" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI" gatewayJoinPass="null"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="410" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853" name="AndJoinMI" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI" gatewayJoinPass="null"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="820" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2d84ae66-a801-4adf-8212-ded838279e88" name="AndSplit" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="920" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="703f422e-0e54-4b4d-f981-1d1bc34e6fde" name="004" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="undefined">
						<Widget left="1030" top="200" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="42200780-72d0-4058-e1aa-886e157e21f6" name="005" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="undefined">
						<Widget left="1040" top="330" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e9951f11-008b-4cc8-a0fe-078a67c8e21a" from="613ea8a5-9c4f-4645-c160-b988a8ac4c52" to="e378ece7-2244-4b1a-9652-3b5b76129480">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="1d70de3a-a7f1-432c-fbff-73a305c1ca6e" from="e378ece7-2244-4b1a-9652-3b5b76129480" to="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="56639ee4-b267-49c0-fdb8-a5a11f2dd516" from="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853" to="2d84ae66-a801-4adf-8212-ded838279e88">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="c31d4b76-51f5-40ce-f3b6-c8a47160e915" from="2d84ae66-a801-4adf-8212-ded838279e88" to="703f422e-0e54-4b4d-f981-1d1bc34e6fde">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="b5ff04db-2c44-44f3-c1a8-31b928758121" from="703f422e-0e54-4b4d-f981-1d1bc34e6fde" to="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="11377463-2ef4-4513-d7bd-201367092532" from="2d84ae66-a801-4adf-8212-ded838279e88" to="42200780-72d0-4058-e1aa-886e157e21f6">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="9c39376a-b0b5-47e0-9d8e-da8279cd30ea" from="42200780-72d0-4058-e1aa-886e157e21f6" to="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="60e9de1d-e751-4879-e72b-0fcaf62bd6d2" from="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" to="fcc9f828-4c28-4f8d-a035-28f3651e0d86">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="90066d60-37c9-4d08-fd21-a36570734359" from="c5cec488-dfba-4810-a6b9-314322b20f06" to="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="null"/>
				</Transition>
				<Transition id="7a2a5d01-db23-4242-8f65-e73850adb2bc" from="fcc9f828-4c28-4f8d-a035-28f3651e0d86" to="c5cec488-dfba-4810-a6b9-314322b20f06">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="10d26377-1c52-43c4-9d67-6581d91547e6" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups>
			<Group id="10d26377-1c52-43c4-9d67-6581d91547e6" name="">
				<Geography parent="a3b6e319-9eaf-4af0-9f98-a51872b621d8" style="group">
					<Widget left="520" top="216" width="238" height="110"/>
				</Geography>
			</Group>
		</Groups>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000AA46014BD16D AS DateTime), CAST(0x0000AA46014F943D AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (297, N'643b1dc1-e2cf-4580-893a-70f79d47de62', N'1', N'合并连接分支节点4', N'SplitComesAfter4', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="合并连接分支节点4" id="643b1dc1-e2cf-4580-893a-70f79d47de62">
			<Description>null</Description>
			<Activities>
				<Activity id="613ea8a5-9c4f-4645-c160-b988a8ac4c52" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="160" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1070" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e378ece7-2244-4b1a-9652-3b5b76129480" name="001" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="undefined">
						<Widget left="260" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" name="AndSplitMI" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI" gatewayJoinPass="null"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="410" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853" name="AndJoinMI" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI" gatewayJoinPass="null"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="710" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="703f422e-0e54-4b4d-f981-1d1bc34e6fde" name="004" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="undefined">
						<Widget left="920" top="234" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bea2f472-5d70-4830-b934-d8b83a96a5fc" name="005" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="undefined">
						<Widget left="560" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e9951f11-008b-4cc8-a0fe-078a67c8e21a" from="613ea8a5-9c4f-4645-c160-b988a8ac4c52" to="e378ece7-2244-4b1a-9652-3b5b76129480">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="null"/>
				</Transition>
				<Transition id="1d70de3a-a7f1-432c-fbff-73a305c1ca6e" from="e378ece7-2244-4b1a-9652-3b5b76129480" to="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="null"/>
				</Transition>
				<Transition id="b5ff04db-2c44-44f3-c1a8-31b928758121" from="703f422e-0e54-4b4d-f981-1d1bc34e6fde" to="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="null"/>
				</Transition>
				<Transition id="01ec6a05-ee5a-40ce-a2d7-863db1a806ae" from="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" to="bea2f472-5d70-4830-b934-d8b83a96a5fc">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="null"/>
				</Transition>
				<Transition id="3fac4c39-3ca5-41db-9659-01e7e3d60b33" from="bea2f472-5d70-4830-b934-d8b83a96a5fc" to="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="null"/>
				</Transition>
				<Transition id="3117b34a-923d-494b-c416-4d2ff7d95a06" from="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853" to="703f422e-0e54-4b4d-f981-1d1bc34e6fde">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8230e360-7a7a-41df-d93c-ca4716a4caa1" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000AA4601502C97 AS DateTime), CAST(0x0000AA460150D8CE AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (300, N'e7312e16-1da5-4351-8919-84f52eac92db', N'1', N'合并连接分支节点2', N'SplitComesAfter2', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="合并连接分支节点2" id="e7312e16-1da5-4351-8919-84f52eac92db">
			<Description>null</Description>
			<Activities>
				<Activity id="613ea8a5-9c4f-4645-c160-b988a8ac4c52" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="160" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1070" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e378ece7-2244-4b1a-9652-3b5b76129480" name="001" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="undefined">
						<Widget left="260" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" name="AndSplit" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="410" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853" name="AndJoin" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="710" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0904f559-b920-46aa-ae57-97aa780d02a1" name="002" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="undefined">
						<Widget left="550" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7b05fc1c-5b54-41de-a267-7026c47fbdb1" name="003" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="undefined">
						<Widget left="548" top="330" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2d84ae66-a801-4adf-8212-ded838279e88" name="AndSplit" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="810" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="703f422e-0e54-4b4d-f981-1d1bc34e6fde" name="004" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="undefined">
						<Widget left="920" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="42200780-72d0-4058-e1aa-886e157e21f6" name="005" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="undefined">
						<Widget left="930" top="320" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e9951f11-008b-4cc8-a0fe-078a67c8e21a" from="613ea8a5-9c4f-4645-c160-b988a8ac4c52" to="e378ece7-2244-4b1a-9652-3b5b76129480">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="1d70de3a-a7f1-432c-fbff-73a305c1ca6e" from="e378ece7-2244-4b1a-9652-3b5b76129480" to="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="cb29cf64-7564-4a19-af16-596aea112b24" from="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" to="0904f559-b920-46aa-ae57-97aa780d02a1">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="937fc350-72c3-471d-ed9b-eb4c45e74c20" from="37a798fd-02a0-4c70-dfbc-3fc9d92ce0c0" to="7b05fc1c-5b54-41de-a267-7026c47fbdb1">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="f44cd924-5711-4fc9-9ad3-5dbed753fef2" from="0904f559-b920-46aa-ae57-97aa780d02a1" to="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="7fbedc5f-0ee5-4d16-fe4a-5680b9737ef7" from="7b05fc1c-5b54-41de-a267-7026c47fbdb1" to="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="56639ee4-b267-49c0-fdb8-a5a11f2dd516" from="ba39c0b0-8c0c-4adc-9d5f-fd9a7f0da853" to="2d84ae66-a801-4adf-8212-ded838279e88">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="c31d4b76-51f5-40ce-f3b6-c8a47160e915" from="2d84ae66-a801-4adf-8212-ded838279e88" to="703f422e-0e54-4b4d-f981-1d1bc34e6fde">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="b5ff04db-2c44-44f3-c1a8-31b928758121" from="703f422e-0e54-4b4d-f981-1d1bc34e6fde" to="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="11377463-2ef4-4513-d7bd-201367092532" from="2d84ae66-a801-4adf-8212-ded838279e88" to="42200780-72d0-4058-e1aa-886e157e21f6">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours forced="false"/>
					<Receiver/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
				<Transition id="9c39376a-b0b5-47e0-9d8e-da8279cd30ea" from="42200780-72d0-4058-e1aa-886e157e21f6" to="4897e8ca-e9ce-46dd-c9b0-659e736bfc5a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="87eedfce-d2c9-44ae-f38d-2dcfd493a99a" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000AA48011A0780 AS DateTime), CAST(0x0000AA5100AD5569 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (325, N'dca797e0-6eb0-42d2-964f-96e69af5634c', N'1', N'并行多实例简单测试(Simple)', N'AndSplitMISimpleTest', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="2ebabe93-000e-4f2b-ad63-fb463d76cba7" name="预算专管员" code="Yszgy" outerId="75"/>
		<Participant type="Role" id="94550617-2b64-4f1a-996a-580970518fd0" name="科长" code="kz" outerId="5"/>
		<Participant type="Role" id="a4948101-4704-4db5-9919-54ca40e7f50b" name="分管站长" code="fgzz" outerId="14"/>
		<Participant type="Role" id="6f6a96d8-eb8a-442c-ad17-266f4868b616" name="办公室财务" code="bgscw" outerId="23"/>
		<Participant type="Role" id="da775e82-009f-4071-f0d2-0573da6f100e" name="财务主管" code="cwzg" outerId="16"/>
		<Participant type="Role" id="4e5481fa-0554-4c3a-dccc-99d3aadd26a0" name="站长" code="ZhanZhang" outerId="25"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="并行多实例简单测试(Simple)" id="dca797e0-6eb0-42d2-964f-96e69af5634c">
			<Description>null</Description>
			<Activities>
				<Activity id="94811449-fe02-412e-80f3-a4b15adb0647" name="Budget Request" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="2ebabe93-000e-4f2b-ad63-fb463d76cba7"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Geography parent="d4a83711-afce-4765-b623-d4c3f063366f" style="undefined">
						<Widget left="10" top="10" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8c5e0f95-6b17-4930-b278-d8b7dfade175" name="Manager" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="94550617-2b64-4f1a-996a-580970518fd0"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Geography parent="d4a83711-afce-4765-b623-d4c3f063366f" style="undefined">
						<Widget left="120" top="10" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="52a98f66-aa72-4f12-ac83-a906688a64ca" name="Operator" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="a4948101-4704-4db5-9919-54ca40e7f50b"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Geography parent="d4a83711-afce-4765-b623-d4c3f063366f" style="undefined">
						<Widget left="230" top="10" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="feb5b292-113b-4c2c-9b5d-03e0a85629ac" name="Start" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="170" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c320c954-220d-4003-b822-59e4a9d86cbe" name="Office" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6f6a96d8-eb8a-442c-ad17-266f4868b616"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined">
						<Widget left="250" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6e94ab43-232a-4c17-e1e3-b4d01e756695" name="gateway-split" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI" gatewayJoinPass="null"/>
					<Actions>
						<Action type="null"/>
					</Actions>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="360" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3db913d0-040c-4f73-e589-da5198adbde4" name="gateway-join" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI" gatewayJoinPass="null"/>
					<Actions>
						<Action type="null"/>
					</Actions>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="790" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4fa8386d-27eb-497c-bdfd-62bd68b6ebbd" name="CFO" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="da775e82-009f-4071-f0d2-0573da6f100e"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined">
						<Widget left="900" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ee7cb980-c444-448b-9db7-f3255fc4be78" name="CEO" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="4e5481fa-0554-4c3a-dccc-99d3aadd26a0"/>
					</Performers>
					<Actions>
						<Action type="ExternalMethod"/>
					</Actions>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined">
						<Widget left="1010" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2f798038-b23a-4355-ca6c-e85fc2490843" name="End" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1140" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="2a89ecce-2fa2-42a9-b95a-95a9116a1da8" from="feb5b292-113b-4c2c-9b5d-03e0a85629ac" to="c320c954-220d-4003-b822-59e4a9d86cbe">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined"/>
				</Transition>
				<Transition id="66be1ef7-7119-4372-de1d-4b083ba07f3a" from="c320c954-220d-4003-b822-59e4a9d86cbe" to="6e94ab43-232a-4c17-e1e3-b4d01e756695">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined"/>
				</Transition>
				<Transition id="32c60af9-74c6-4f78-ae56-744a9e40cd76" from="3db913d0-040c-4f73-e589-da5198adbde4" to="4fa8386d-27eb-497c-bdfd-62bd68b6ebbd">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined"/>
				</Transition>
				<Transition id="262dc99d-e29c-43a2-f965-bccbe1ff4088" from="4fa8386d-27eb-497c-bdfd-62bd68b6ebbd" to="ee7cb980-c444-448b-9db7-f3255fc4be78">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined"/>
				</Transition>
				<Transition id="84643a38-c72e-4413-9693-eab60e41bede" from="ee7cb980-c444-448b-9db7-f3255fc4be78" to="2f798038-b23a-4355-ca6c-e85fc2490843">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined"/>
				</Transition>
				<Transition id="92658808-3366-4dfd-b897-10af446cdf78" from="6e94ab43-232a-4c17-e1e3-b4d01e756695" to="94811449-fe02-412e-80f3-a4b15adb0647">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined"/>
				</Transition>
				<Transition id="e0329133-1e95-4445-a156-bd775334c138" from="52a98f66-aa72-4f12-ac83-a906688a64ca" to="3db913d0-040c-4f73-e589-da5198adbde4">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver type="Default"/>
					<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="undefined"/>
				</Transition>
				<Transition id="d25518bb-3074-420d-a14d-034c91e7c1ce" from="94811449-fe02-412e-80f3-a4b15adb0647" to="8c5e0f95-6b17-4930-b278-d8b7dfade175">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver type="Superior"/>
					<Geography parent="d4a83711-afce-4765-b623-d4c3f063366f" style="undefined"/>
				</Transition>
				<Transition id="25ab507c-330a-466a-cb65-3465596bdfda" from="8c5e0f95-6b17-4930-b278-d8b7dfade175" to="52a98f66-aa72-4f12-ac83-a906688a64ca">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver type="Superior"/>
					<Geography parent="d4a83711-afce-4765-b623-d4c3f063366f" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups>
			<Group id="d4a83711-afce-4765-b623-d4c3f063366f" name="">
				<Geography parent="55c62492-2ac8-46a3-a21f-933d604f4982" style="group">
					<Widget left="450" top="220" width="312" height="52"/>
				</Geography>
			</Group>
		</Groups>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000AA630104171E AS DateTime), CAST(0x0000AA6301045634 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (366, N'e05ebfe6-d424-41fd-955a-3bc7f90ad9fa', N'1', N'资产采购订单审批', N'PurchaseOrderApprove', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="0998b93c-5267-4d93-960e-48b5a7f4179d" name="testrole" code="testrole" outerId="21"/>
		<Participant type="Role" id="74b8a615-5c26-46d6-81d4-e20aed26793c" name="包装员(Express)" code="expressmate" outerId="13"/>
		<Participant type="Role" id="dcc85b29-aa95-4627-a19a-fdc3173628f7" name="部门经理" code="depmanager" outerId="2"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="资产采购订单审批" id="e05ebfe6-d424-41fd-955a-3bc7f90ad9fa">
			<Description>null</Description>
			<Activities>
				<Activity id="bf6089b3-1717-4cdd-b25c-544e198c6214" name="采购经理审批" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="undefined">
						<Widget left="510" top="14" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="02665d0a-bcc7-475a-a161-0006dfcc0abd" name="" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin" gatewayJoinPass="null"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="700" top="70" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1c8d8913-4e06-4926-f206-fd55c26b8d33" name="采购主管审批" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="0998b93c-5267-4d93-960e-48b5a7f4179d"/>
						<Performer id="74b8a615-5c26-46d6-81d4-e20aed26793c"/>
						<Performer id="dcc85b29-aa95-4627-a19a-fdc3173628f7"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="undefined">
						<Widget left="200" top="54" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1fc1ed1e-8022-4426-f11c-39b35e544149" name="订单金额？" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="" gatewayJoinPass="null"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="350" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="89df0c62-9ae8-4406-8297-99694095692d" name="订单金额？" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="" gatewayJoinPass="null"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="350" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bf6089b3-1717-4cdd-b25c-544e198c6214" name="采购经理审批" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="undefined">
						<Widget left="510" top="14" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="02665d0a-bcc7-475a-a161-0006dfcc0abd" name="" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin" gatewayJoinPass="null"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="700" top="70" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1c8d8913-4e06-4926-f206-fd55c26b8d33" name="采购主管审批" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="0998b93c-5267-4d93-960e-48b5a7f4179d"/>
						<Performer id="74b8a615-5c26-46d6-81d4-e20aed26793c"/>
						<Performer id="dcc85b29-aa95-4627-a19a-fdc3173628f7"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="undefined">
						<Widget left="200" top="54" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1fc1ed1e-8022-4426-f11c-39b35e544149" name="订单金额？" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="" gatewayJoinPass="null"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="350" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="89df0c62-9ae8-4406-8297-99694095692d" name="订单金额？" code="" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="" gatewayJoinPass="null"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="350" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ce96cebd-eb21-43e2-9297-51cfdd8a4a3e" name="财务会签" code="" url="null">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="" mergeType="" compareType="" completeOrder=""/>
					<Geography parent="82c82def-a027-4603-aab8-7bcf96a7033b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="510" top="90" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ce96cebd-eb21-43e2-9297-51cfdd8a4a3e" name="财务会签" code="" url="null">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="" mergeType="" compareType="" completeOrder=""/>
					<Geography parent="82c82def-a027-4603-aab8-7bcf96a7033b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="510" top="90" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7e468aa4-0750-421b-e7db-c097d4ff488a" name="老板审批" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="undefined">
						<Widget left="840" top="33" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2fea4b6d-0301-4524-d44a-6e1519da22f8" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bcb25ec2-0bb2-446c-b099-f8704f957229" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="46d785a7-2225-4086-e970-3b0dbad7a3c7" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="629d54c0-b01b-4e2a-fffc-e8e6b99bc1d1" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d704e324-3ff8-49a8-852b-4f708ffa04d1" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="99f6c451-5c90-4c52-cac4-3fafdb48d408" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6ce668b4-0ecf-4b10-cf3e-dadd9876cddf" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f726744b-addd-428e-9230-0e308438c43f" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3c1636c6-7a0e-4086-a905-c9adedc0dee4" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8bf6f55b-03a4-450d-f722-42d7a81f4de2" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d90649ae-c593-4d55-ea8b-f0c5f98d3a9d" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5f98e13c-b824-45d7-9d8d-9f6ce4a870a0" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c2840e4e-ee2b-4fca-edd8-17a2b049ff97" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="20e7550e-9f05-49e8-e777-8f11446fdf50" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f52e6934-0186-496f-f267-dbdc7845aaf0" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6db66582-ef55-46a4-cb43-31f868fcb498" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="607d5e1f-950b-49d7-d2e3-8d79e10800fb" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ec67f099-0a10-4125-9a83-2e6e57e21cc9" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0d0b4461-8270-41e1-ab2e-dc400a81c59d" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f6b63ead-baef-4703-c2c8-63eecb8322f5" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="48211b66-b7cd-4a8f-f877-9ce4b522d84b" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d9fcaf7d-5a07-4bc3-8706-7a3265301f80" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="53e6cdd5-0e20-4553-ee28-d8f80a12d3ce" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a8fc80c1-820e-4cde-a02a-2aedb3fef0f4" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7e468aa4-0750-421b-e7db-c097d4ff488a" name="老板审批" code="" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="undefined">
						<Widget left="840" top="33" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2fea4b6d-0301-4524-d44a-6e1519da22f8" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bcb25ec2-0bb2-446c-b099-f8704f957229" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="46d785a7-2225-4086-e970-3b0dbad7a3c7" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="629d54c0-b01b-4e2a-fffc-e8e6b99bc1d1" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d704e324-3ff8-49a8-852b-4f708ffa04d1" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="99f6c451-5c90-4c52-cac4-3fafdb48d408" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6ce668b4-0ecf-4b10-cf3e-dadd9876cddf" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f726744b-addd-428e-9230-0e308438c43f" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3c1636c6-7a0e-4086-a905-c9adedc0dee4" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8bf6f55b-03a4-450d-f722-42d7a81f4de2" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d90649ae-c593-4d55-ea8b-f0c5f98d3a9d" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5f98e13c-b824-45d7-9d8d-9f6ce4a870a0" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c2840e4e-ee2b-4fca-edd8-17a2b049ff97" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="20e7550e-9f05-49e8-e777-8f11446fdf50" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f52e6934-0186-496f-f267-dbdc7845aaf0" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6db66582-ef55-46a4-cb43-31f868fcb498" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="607d5e1f-950b-49d7-d2e3-8d79e10800fb" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ec67f099-0a10-4125-9a83-2e6e57e21cc9" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0d0b4461-8270-41e1-ab2e-dc400a81c59d" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f6b63ead-baef-4703-c2c8-63eecb8322f5" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="48211b66-b7cd-4a8f-f877-9ce4b522d84b" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d9fcaf7d-5a07-4bc3-8706-7a3265301f80" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="53e6cdd5-0e20-4553-ee28-d8f80a12d3ce" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a8fc80c1-820e-4cde-a02a-2aedb3fef0f4" name="结束" code="" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="65" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d1dfe3f9-6fac-479d-9f24-4acd5cf8fdd5" name="开始" code="" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None"/>
					<Geography parent="0678f34d-f49b-477e-84e0-4e45d2dc9d66" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="240" top="190" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="5bc4b36a-bb86-4e04-8d35-24c759d320dc" from="d1dfe3f9-6fac-479d-9f24-4acd5cf8fdd5" to="1c8d8913-4e06-4926-f206-fd55c26b8d33">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="0678f34d-f49b-477e-84e0-4e45d2dc9d66" style="null"/>
				</Transition>
				<Transition id="50202d33-b54c-4509-ea7d-12f2c2029865" from="ce96cebd-eb21-43e2-9297-51cfdd8a4a3e" to="02665d0a-bcc7-475a-a161-0006dfcc0abd">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="0678f34d-f49b-477e-84e0-4e45d2dc9d66" style="null"/>
				</Transition>
				<Transition id="96de3cbb-d610-492e-93b4-e0d77d5b15a9" from="02665d0a-bcc7-475a-a161-0006dfcc0abd" to="7e468aa4-0750-421b-e7db-c097d4ff488a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="0678f34d-f49b-477e-84e0-4e45d2dc9d66" style="null"/>
				</Transition>
				<Transition id="4a673a0a-9db2-41ef-85a2-b5b21ee22b4e" from="1fc1ed1e-8022-4426-f11c-39b35e544149" to="ce96cebd-eb21-43e2-9297-51cfdd8a4a3e">
					<Description>订单金额 ≥ 30000</Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="0678f34d-f49b-477e-84e0-4e45d2dc9d66" style="null"/>
				</Transition>
				<Transition id="174ab017-d5de-4bcf-b6f8-c9c3f2565e80" from="bf6089b3-1717-4cdd-b25c-544e198c6214" to="02665d0a-bcc7-475a-a161-0006dfcc0abd">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="null"/>
				</Transition>
				<Transition id="f3373e99-820b-464a-e57a-4107483ee4d2" from="1c8d8913-4e06-4926-f206-fd55c26b8d33" to="1fc1ed1e-8022-4426-f11c-39b35e544149">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="null"/>
				</Transition>
				<Transition id="c395dcd3-ef90-4a2b-e1a1-e062caa5c486" from="1fc1ed1e-8022-4426-f11c-39b35e544149" to="bf6089b3-1717-4cdd-b25c-544e198c6214">
					<Description>订单金额 &amp;lt; 30000</Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" style="null"/>
				</Transition>
				<Transition id="acf6d758-23f6-410f-ec42-c32df155bddb" from="7e468aa4-0750-421b-e7db-c097d4ff488a" to="2fea4b6d-0301-4524-d44a-6e1519da22f8">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes>
			<Swimlane id="3c3065ee-0f4d-4a36-aa78-84f23fe8f0d7" name="采购部&#xA;">
				<Geography parent="0678f34d-f49b-477e-84e0-4e45d2dc9d66" style="swimlane;fillColor=#83027F;startSize=28;">
					<Widget left="170" top="136" width="980" height="140"/>
				</Geography>
			</Swimlane>
			<Swimlane id="82c82def-a027-4603-aab8-7bcf96a7033b" name="财务部&#xA;">
				<Geography parent="0678f34d-f49b-477e-84e0-4e45d2dc9d66" style="swimlane;fillColor=#66B922;startSize=28;">
					<Widget left="170" top="276" width="980" height="154"/>
				</Geography>
			</Swimlane>
			<Swimlane id="c344f9bf-a84e-47d2-dec2-5b9ad4ea4452" name="老板&#xA;">
				<Geography parent="0678f34d-f49b-477e-84e0-4e45d2dc9d66" style="swimlane;fillColor=#808913;startSize=28;">
					<Widget left="170" top="430" width="980" height="130"/>
				</Geography>
			</Swimlane>
		</Swimlanes>
		<Groups/>
	</Layout>
</Package>', 0, N'', NULL, 0, N'', CAST(0x0000AA6500B08BEA AS DateTime), CAST(0x0000AA8900FBD472 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (369, N'c1b01894-05fb-46cf-bd89-9197e0a26a8e', N'1', N'并行容器主流程(AndSplitMI-Main)', N'ParallelContainerProcess', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="55516adf-c136-4281-e189-eff4986ede96" name="testrole" code="testrole" outerId="21"/>
		<Participant type="Role" id="12516f93-e25a-49a8-8bc9-28fe311bc8f6" name="普通员工" code="employees" outerId="1"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="并行容器主流程(AndSplitMI-Main)" id="c1b01894-05fb-46cf-bd89-9197e0a26a8e">
			<Description>null</Description>
			<Activities>
				<Activity id="04332326-9726-4d8f-a440-0eae809c1a4f" name="start" code="" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="74044fb5-5c57-4f98-917d-d49e1bf11528" name="Task-001" code="" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="">
						<Widget left="210" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6392c3be-6584-441f-84c7-7d22c5ec5e93" name="and-split" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI" gatewayJoinPass="null"/>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="370" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ba5a472c-bae8-4265-bf92-edb5203bf8e9" name="and-join" code="" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI" gatewayJoinPass="null"/>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="700" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="631e08d5-5f40-44aa-95a6-b8627d8c32d0" name="task-100" code="" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="55516adf-c136-4281-e189-eff4986ede96"/>
						<Performer id="12516f93-e25a-49a8-8bc9-28fe311bc8f6"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="">
						<Widget left="860" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="173177ae-8ce5-4346-9948-e0c625478835" name="end" code="" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null"/>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1020" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b05af18f-fc91-4849-8fcb-54a60f5230f6" name="Subprocess" code="" url="">
					<Description></Description>
					<ActivityType type="SubProcessNode" subId="072af8c3-482a-4b1c-890b-685ce2fcc75d"/>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/subprocess.png">
						<Widget left="530" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="d46499a8-1390-4357-aa6d-60211b3b91d7" from="04332326-9726-4d8f-a440-0eae809c1a4f" to="74044fb5-5c57-4f98-917d-d49e1bf11528">
					<Description></Description>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="null"/>
				</Transition>
				<Transition id="04a52347-20b9-4d42-b3ba-c78b55b86841" from="74044fb5-5c57-4f98-917d-d49e1bf11528" to="6392c3be-6584-441f-84c7-7d22c5ec5e93">
					<Description></Description>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="null"/>
				</Transition>
				<Transition id="4ea1bcf1-3856-4603-9276-fb470d7739c0" from="ba5a472c-bae8-4265-bf92-edb5203bf8e9" to="631e08d5-5f40-44aa-95a6-b8627d8c32d0">
					<Description></Description>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="null"/>
				</Transition>
				<Transition id="6178a811-fcc0-4fef-82d4-1a4e8fd9b52e" from="631e08d5-5f40-44aa-95a6-b8627d8c32d0" to="173177ae-8ce5-4346-9948-e0c625478835">
					<Description></Description>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="null"/>
				</Transition>
				<Transition id="5729d0be-9388-4ca3-d8ea-4764890448dc" from="6392c3be-6584-441f-84c7-7d22c5ec5e93" to="b05af18f-fc91-4849-8fcb-54a60f5230f6">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="null"/>
				</Transition>
				<Transition id="aa28ae56-2421-4012-fd6c-171004ec422f" from="b05af18f-fc91-4849-8fcb-54a60f5230f6" to="ba5a472c-bae8-4265-bf92-edb5203bf8e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="066553fd-732f-4acf-9753-5fcf34011df1" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
		<Groups/>
	</Layout>
</Package>', 0, N'', N'', 0, N'', CAST(0x0000AA7E00945D6B AS DateTime), CAST(0x0000AA84013F9AFB AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (372, N'a18d49d0-9eca-4939-a62e-176af0d5cc6a', N'1', N'WebApi测试', N'WebApiTest', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="a18d49d0-9eca-4939-a62e-176af0d5cc6a" name="WebApi测试" code="WebApiTest" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="f2b95ac8-0a4b-4c27-8a77-88de44b14af7" name="开始" code="1OQ0BZ" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null"/>
					<Geography parent="c399a169-3a06-4b98-9a14-82b4c688c16b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="170" top="180" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a1b54659-27ce-4589-b83f-e4e8c5cdef3e" name="结束" code="U8LEZZ" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null"/>
					<Geography parent="c399a169-3a06-4b98-9a14-82b4c688c16b" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="760" top="200" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="31107433-6f5d-4763-e27d-596191fb3dad" name="Task-02" code="QHGCQZ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="c399a169-3a06-4b98-9a14-82b4c688c16b" style="undefined">
						<Widget left="570" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6e42b0f8-9d35-4c9b-babf-41310b418808" name="Task" code="R14JII" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="Before" method="SQL" arguments="" expression="">
							<CodeInfo>
								<![CDATA[select * from wfprocess;]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="c399a169-3a06-4b98-9a14-82b4c688c16b" style="undefined">
						<Widget left="340" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="286d737f-ced5-47fb-a63c-b35b252635f2" from="31107433-6f5d-4763-e27d-596191fb3dad" to="a1b54659-27ce-4589-b83f-e4e8c5cdef3e">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="c399a169-3a06-4b98-9a14-82b4c688c16b" style="null"/>
				</Transition>
				<Transition id="4fb5b415-186f-4312-a024-036a1718d6c5" from="f2b95ac8-0a4b-4c27-8a77-88de44b14af7" to="6e42b0f8-9d35-4c9b-babf-41310b418808">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="c399a169-3a06-4b98-9a14-82b4c688c16b" style="null"/>
				</Transition>
				<Transition id="d160a541-5282-4a33-fdf2-bb844b543d23" from="6e42b0f8-9d35-4c9b-babf-41310b418808" to="31107433-6f5d-4763-e27d-596191fb3dad">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="c399a169-3a06-4b98-9a14-82b4c688c16b" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                      ', 0, NULL, N'', 0, NULL, CAST(0x0000AAB5010EBB23 AS DateTime), CAST(0x0000AB96011000EA AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (397, N'5dde28a7-ac35-4646-ae77-fb650de0292c', N'1', N'LeaveRequest', N'LeaveRequestCode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="414a2b05-24af-4a57-be42-21861b14765f" name="LeaveRequest" code="LeaveRequestCode" version="1"><Description></Description><Activities><Activity id="26848c79-06fd-40dd-8015-f3a6c15f12c3" name="Start" code="" url=""><Description /><ActivityType type="StartNode" /><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="b71e8091-cc6a-44d5-b74c-238dfc731c7c" name="Fill Leave Days" code="" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="01dade72-f641-4c68-8ed6-d0c75c0e7ec1" name="OrSplit" code="" url=""><Description /><ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" /><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png"><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="756dfbbc-9922-46ea-9436-940429afacf9" name="CEO Evaluate" code="" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" style=""><Widget left="530" top="160" width="72" height="32" /></Geography></Activity><Activity id="75354eec-b949-433f-99d4-f9cfef55918f" name="Manager Evaluate" code="" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" style=""><Widget left="530" top="60" width="72" height="32" /></Geography></Activity><Activity id="35e1d900-7c72-4cc1-bcba-9c07968e0cfe" name="OrJoin" code="" url=""><Description /><ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" /><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png"><Widget left="690" top="160" width="72" height="32" /></Geography></Activity><Activity id="a10ce923-c3ee-49bb-9e15-9c187e4f2ec7" name="HR Notify" code="" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" style=""><Widget left="850" top="160" width="72" height="32" /></Geography></Activity><Activity id="6080522f-c54e-4a58-9844-1f7c7607f28e" name="End" code="" url=""><Description /><ActivityType type="EndNode" /><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="1010" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="990f8c62-d49a-473c-b928-840bd716b4a1" from="26848c79-06fd-40dd-8015-f3a6c15f12c3" to="b71e8091-cc6a-44d5-b74c-238dfc731c7c"><Description></Description><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" /></Transition><Transition id="d0addc66-6ee9-46d1-8c12-1a03f5632b54" from="b71e8091-cc6a-44d5-b74c-238dfc731c7c" to="01dade72-f641-4c68-8ed6-d0c75c0e7ec1"><Description></Description><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" /></Transition><Transition id="1c864dda-1656-4038-b750-5c6e14c4dbd5" from="01dade72-f641-4c68-8ed6-d0c75c0e7ec1" to="756dfbbc-9922-46ea-9436-940429afacf9"><Description>days&gt;=3</Description><Condition type="Expression"><ConditionText>days&gt;=3</ConditionText></Condition><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" /></Transition><Transition id="ca0d8b43-788b-4695-822e-e8d4650c5d18" from="01dade72-f641-4c68-8ed6-d0c75c0e7ec1" to="75354eec-b949-433f-99d4-f9cfef55918f"><Description>days&lt;3</Description><Condition type="Expression"><ConditionText>days&lt;3</ConditionText></Condition><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" /></Transition><Transition id="02527a04-c68a-4304-8198-7f527d156687" from="75354eec-b949-433f-99d4-f9cfef55918f" to="35e1d900-7c72-4cc1-bcba-9c07968e0cfe"><Description></Description><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" /></Transition><Transition id="6cafb191-d4df-4fa6-9e85-b8d60e8203b5" from="756dfbbc-9922-46ea-9436-940429afacf9" to="35e1d900-7c72-4cc1-bcba-9c07968e0cfe"><Description></Description><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" /></Transition><Transition id="fddb56b4-2b4a-4fe6-8d34-73d387275ac8" from="35e1d900-7c72-4cc1-bcba-9c07968e0cfe" to="a10ce923-c3ee-49bb-9e15-9c187e4f2ec7"><Description></Description><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" /></Transition><Transition id="94aa4115-ef57-4140-8db9-cbcb8d3ab18a" from="a10ce923-c3ee-49bb-9e15-9c187e4f2ec7" to="6080522f-c54e-4a58-9844-1f7c7607f28e"><Description></Description><Geography parent="dfb9f947-ce12-4643-9a61-a0ab13164ef4" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AACD00EC9A85 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (752, N'd7f72d8e-f6f0-45b8-d470-15b51542af21', N'1', N'多泳道订单流程', N'morderprocess', 1, NULL, 1, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Swimlanes>
			<Swimlane title="订单" type="MainProcess" id="5bac0e25-e824-4713-eb42-ed5864c29680">
				<Process package="MainProcess" id="d7f72d8e-f6f0-45b8-d470-15b51542af21" name="多泳道订单流程" code="morderprocess" description=""/>
				<Geography parent="38994476-9180-45b2-8aae-8d44eb8e794d" style="swimlane;fillColor=#83027F;startSize=28;">
					<Widget left="180" top="170" width="770" height="150"/>
				</Geography>
			</Swimlane>
			<Swimlane title="生产计划" type="PoolProcess" id="728e2c93-1c36-496c-b0ba-a1462a05b70d">
				<Process package="PoolProcess" id="b79dafbd-232c-4d39-9be9-67d4fa407865" name="生产计划流程" code="sorderprocess" description=""/>
				<Geography parent="38994476-9180-45b2-8aae-8d44eb8e794d" style="swimlane;fillColor=#66B922;startSize=28;">
					<Widget left="380" top="420" width="460" height="140"/>
				</Geography>
			</Swimlane>
		</Swimlanes>
		<Groups/>
		<Messages>
			<Message id="795c0d3f-8aa2-4b0c-e6b2-eef5ed42f150" from="6215a832-8f2a-49be-99a8-ccfd46323ca0" to="12c7538c-8dbc-4d90-ed6f-f4417f57e92a">
				<Description></Description>
				<Geography parent="38994476-9180-45b2-8aae-8d44eb8e794d" style="message"/>
			</Message>
			<Message id="a34f4cad-4ee5-4ccd-b84e-58cf5f546153" from="d39039c4-9989-43cc-fa68-8bedfaf4ba70" to="3580e43d-ead4-442c-cd87-c0663cc2a63d">
				<Description></Description>
				<Geography parent="38994476-9180-45b2-8aae-8d44eb8e794d" style="message"/>
			</Message>
		</Messages>
	</Layout>
	<WorkflowProcesses>
		<Process id="d7f72d8e-f6f0-45b8-d470-15b51542af21" name="多泳道订单流程" code="morderprocess" version="1" package="MainProcess">
			<Description></Description>
			<Activities>
				<Activity id="e684d061-446d-47fa-98be-9369d80f48aa" name="Start" code="U7MOMN" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="60" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9ecfb4eb-3974-4c09-9005-c9b9c820afea" name="同步订单" code="YHPNAQ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined">
						<Widget left="160" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="75b0a116-0a22-4bd7-d058-4de04b8c7308" name="订单分配" code="DQ64AO" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined">
						<Widget left="360" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="026058fb-be7f-42a6-a3db-2f83bfc13598" name="End" code="ZPUL2D" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="710" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="86c11cbd-678d-49f5-8a3e-6189758d20ab" name="客户反馈" code="GEUOI9" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined">
						<Widget left="600" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6215a832-8f2a-49be-99a8-ccfd46323ca0" name="InterMessageThrow" code="C4YW6C" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="Message" expression="NewOrderThrowingMessage-975YTF" messageDirection="Throw"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_throw_intermediate.png">
						<Widget left="270" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3580e43d-ead4-442c-cd87-c0663cc2a63d" name="InterMessageCatch" code="LU4226" url="null">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="Message" expression="EndOrderThrowingMessage-3678F" messageDirection="Catch"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_catch_intermediate.png">
						<Widget left="500" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="216a69fd-2d8f-4d24-b283-185d5118f1e8" from="e684d061-446d-47fa-98be-9369d80f48aa" to="9ecfb4eb-3974-4c09-9005-c9b9c820afea">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="ba40bfcb-9ea1-4bcc-963c-0875211f630a" from="86c11cbd-678d-49f5-8a3e-6189758d20ab" to="026058fb-be7f-42a6-a3db-2f83bfc13598">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="fcb14cca-7f95-44b7-8e68-f3315a2a10d7" from="9ecfb4eb-3974-4c09-9005-c9b9c820afea" to="6215a832-8f2a-49be-99a8-ccfd46323ca0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="f79e0393-45fe-4ed8-b2dc-1c1fa63bd01c" from="6215a832-8f2a-49be-99a8-ccfd46323ca0" to="75b0a116-0a22-4bd7-d058-4de04b8c7308">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="d6ea8a1f-d5d8-4823-b83b-e77917184734" from="75b0a116-0a22-4bd7-d058-4de04b8c7308" to="3580e43d-ead4-442c-cd87-c0663cc2a63d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="2ec77454-d600-48a6-f04c-8efc6712734b" from="3580e43d-ead4-442c-cd87-c0663cc2a63d" to="86c11cbd-678d-49f5-8a3e-6189758d20ab">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
		<Process id="b79dafbd-232c-4d39-9be9-67d4fa407865" name="生产计划流程" code="sorderprocess" version="1" package="PoolProcess">
			<Description></Description>
			<Activities>
				<Activity id="b67aa403-568b-4857-b3c4-9f24117617d5" name="生产排程" code="Q21IYE" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined">
						<Widget left="140" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bcb2ee5a-15f4-40e5-f73c-942af7999a56" name="排程审核" code="Z9ROBA" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined">
						<Widget left="240" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="12c7538c-8dbc-4d90-ed6f-f4417f57e92a" name="StartMessageCatch" code="TN1D43" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="Message" expression="NewOrderThrowingMessage-975YTF" messageDirection="Catch"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_start.png">
						<Widget left="70" top="64" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d39039c4-9989-43cc-fa68-8bedfaf4ba70" name="EndMessageThrow" code="XP911Z" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="Message" expression="EndOrderThrowingMessage-3678F" messageDirection="Throw"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_end_throw.png">
						<Widget left="370" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="944fe2f0-04bb-454e-d8a9-80e3c237c3e9" from="b67aa403-568b-4857-b3c4-9f24117617d5" to="bcb2ee5a-15f4-40e5-f73c-942af7999a56">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined"/>
				</Transition>
				<Transition id="c2bf99a5-01c3-448a-816d-76f9d35d26a7" from="12c7538c-8dbc-4d90-ed6f-f4417f57e92a" to="b67aa403-568b-4857-b3c4-9f24117617d5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined"/>
				</Transition>
				<Transition id="b8c76b06-4a38-48c3-d8d0-47ef41c7b213" from="bcb2ee5a-15f4-40e5-f73c-942af7999a56" to="d39039c4-9989-43cc-fa68-8bedfaf4ba70">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000AB9600E89B63 AS DateTime), CAST(0x0000ABCB014A31CD AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (753, N'b79dafbd-232c-4d39-9be9-67d4fa407865', N'1', N'生产计划流程', N'sorderprocess', 1, NULL, 2, 752, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Swimlanes>
			<Swimlane title="订单" type="MainProcess" id="5bac0e25-e824-4713-eb42-ed5864c29680">
				<Process package="MainProcess" id="d7f72d8e-f6f0-45b8-d470-15b51542af21" name="多泳道订单流程" code="morderprocess" description=""/>
				<Geography parent="38994476-9180-45b2-8aae-8d44eb8e794d" style="swimlane;fillColor=#83027F;startSize=28;">
					<Widget left="180" top="170" width="770" height="150"/>
				</Geography>
			</Swimlane>
			<Swimlane title="生产计划" type="PoolProcess" id="728e2c93-1c36-496c-b0ba-a1462a05b70d">
				<Process package="PoolProcess" id="b79dafbd-232c-4d39-9be9-67d4fa407865" name="生产计划流程" code="sorderprocess" description=""/>
				<Geography parent="38994476-9180-45b2-8aae-8d44eb8e794d" style="swimlane;fillColor=#66B922;startSize=28;">
					<Widget left="380" top="420" width="460" height="140"/>
				</Geography>
			</Swimlane>
		</Swimlanes>
		<Groups/>
		<Messages>
			<Message id="795c0d3f-8aa2-4b0c-e6b2-eef5ed42f150" from="6215a832-8f2a-49be-99a8-ccfd46323ca0" to="12c7538c-8dbc-4d90-ed6f-f4417f57e92a">
				<Description></Description>
				<Geography parent="38994476-9180-45b2-8aae-8d44eb8e794d" style="message"/>
			</Message>
			<Message id="a34f4cad-4ee5-4ccd-b84e-58cf5f546153" from="d39039c4-9989-43cc-fa68-8bedfaf4ba70" to="3580e43d-ead4-442c-cd87-c0663cc2a63d">
				<Description></Description>
				<Geography parent="38994476-9180-45b2-8aae-8d44eb8e794d" style="message"/>
			</Message>
		</Messages>
	</Layout>
	<WorkflowProcesses>
		<Process id="d7f72d8e-f6f0-45b8-d470-15b51542af21" name="多泳道订单流程" code="morderprocess" version="1" package="MainProcess">
			<Description></Description>
			<Activities>
				<Activity id="e684d061-446d-47fa-98be-9369d80f48aa" name="Start" code="U7MOMN" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="60" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9ecfb4eb-3974-4c09-9005-c9b9c820afea" name="同步订单" code="YHPNAQ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined">
						<Widget left="160" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="75b0a116-0a22-4bd7-d058-4de04b8c7308" name="订单分配" code="DQ64AO" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined">
						<Widget left="360" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="026058fb-be7f-42a6-a3db-2f83bfc13598" name="End" code="ZPUL2D" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="710" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="86c11cbd-678d-49f5-8a3e-6189758d20ab" name="客户反馈" code="GEUOI9" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined">
						<Widget left="600" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6215a832-8f2a-49be-99a8-ccfd46323ca0" name="InterMessageThrow" code="C4YW6C" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="Message" expression="NewOrderThrowingMessage-975YTF" messageDirection="Throw"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_throw_intermediate.png">
						<Widget left="270" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3580e43d-ead4-442c-cd87-c0663cc2a63d" name="InterMessageCatch" code="LU4226" url="null">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="Message" expression="EndOrderThrowingMessage-3678F" messageDirection="Catch"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_catch_intermediate.png">
						<Widget left="500" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="216a69fd-2d8f-4d24-b283-185d5118f1e8" from="e684d061-446d-47fa-98be-9369d80f48aa" to="9ecfb4eb-3974-4c09-9005-c9b9c820afea">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="ba40bfcb-9ea1-4bcc-963c-0875211f630a" from="86c11cbd-678d-49f5-8a3e-6189758d20ab" to="026058fb-be7f-42a6-a3db-2f83bfc13598">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="fcb14cca-7f95-44b7-8e68-f3315a2a10d7" from="9ecfb4eb-3974-4c09-9005-c9b9c820afea" to="6215a832-8f2a-49be-99a8-ccfd46323ca0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="f79e0393-45fe-4ed8-b2dc-1c1fa63bd01c" from="6215a832-8f2a-49be-99a8-ccfd46323ca0" to="75b0a116-0a22-4bd7-d058-4de04b8c7308">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="d6ea8a1f-d5d8-4823-b83b-e77917184734" from="75b0a116-0a22-4bd7-d058-4de04b8c7308" to="3580e43d-ead4-442c-cd87-c0663cc2a63d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
				<Transition id="2ec77454-d600-48a6-f04c-8efc6712734b" from="3580e43d-ead4-442c-cd87-c0663cc2a63d" to="86c11cbd-678d-49f5-8a3e-6189758d20ab">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5bac0e25-e824-4713-eb42-ed5864c29680" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
		<Process id="b79dafbd-232c-4d39-9be9-67d4fa407865" name="生产计划流程" code="sorderprocess" version="1" package="PoolProcess">
			<Description></Description>
			<Activities>
				<Activity id="b67aa403-568b-4857-b3c4-9f24117617d5" name="生产排程" code="Q21IYE" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined">
						<Widget left="140" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bcb2ee5a-15f4-40e5-f73c-942af7999a56" name="排程审核" code="Z9ROBA" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined">
						<Widget left="240" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="12c7538c-8dbc-4d90-ed6f-f4417f57e92a" name="StartMessageCatch" code="TN1D43" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="Message" expression="NewOrderThrowingMessage-975YTF" messageDirection="Catch"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_start.png">
						<Widget left="70" top="64" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d39039c4-9989-43cc-fa68-8bedfaf4ba70" name="EndMessageThrow" code="XP911Z" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="Message" expression="EndOrderThrowingMessage-3678F" messageDirection="Throw"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_end_throw.png">
						<Widget left="370" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="944fe2f0-04bb-454e-d8a9-80e3c237c3e9" from="b67aa403-568b-4857-b3c4-9f24117617d5" to="bcb2ee5a-15f4-40e5-f73c-942af7999a56">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined"/>
				</Transition>
				<Transition id="c2bf99a5-01c3-448a-816d-76f9d35d26a7" from="12c7538c-8dbc-4d90-ed6f-f4417f57e92a" to="b67aa403-568b-4857-b3c4-9f24117617d5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined"/>
				</Transition>
				<Transition id="b8c76b06-4a38-48c3-d8d0-47ef41c7b213" from="bcb2ee5a-15f4-40e5-f73c-942af7999a56" to="d39039c4-9989-43cc-fa68-8bedfaf4ba70">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="728e2c93-1c36-496c-b0ba-a1462a05b70d" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 2, N'NewOrderThrowingMessage-975YTF', N'', 2, N'EndOrderThrowingMessage-3678F', CAST(0x0000AB9600EA3D7F AS DateTime), CAST(0x0000ABCB014A31E6 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (754, N'3ed13f4d-2cf1-4f26-920e-051182fd5aa6', N'1', N'messagetest', N'messagetestcode', 0, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Swimlanes>
			<Swimlane title="Swimlane" type="" id="c114fa94-e852-4526-c223-8a4d21d05098">
				<Geography parent="bf512379-46b8-4177-a4cc-5ab0dced066d" style="swimlane;fillColor=#83027F">
					<Widget left="240" top="150" width="300" height="160"/>
				</Geography>
			</Swimlane>
			<Swimlane title="Swimlane" type="" id="1d2faae9-83f2-4785-d503-64bf8873335b">
				<Geography parent="bf512379-46b8-4177-a4cc-5ab0dced066d" style="swimlane;fillColor=#66B922">
					<Widget left="330" top="390" width="300" height="160"/>
				</Geography>
			</Swimlane>
		</Swimlanes>
		<Groups/>
		<Messages>
			<Message id="ea2d4eee-2126-4fab-c149-2fdbe8181930" from="bcf5755d-e535-4aa8-d1d4-656e709c0e6e" to="5c216c18-d81a-4697-b493-698300eca9f9">
				<Description></Description>
				<Geography parent="bf512379-46b8-4177-a4cc-5ab0dced066d" style="message"/>
			</Message>
		</Messages>
	</Layout>
	<WorkflowProcesses>
		<Process id="3ed13f4d-2cf1-4f26-920e-051182fd5aa6" name="messagetest" code="messagetestcode" package="undefined">
			<Description></Description>
			<Activities>
				<Activity id="bcf5755d-e535-4aa8-d1d4-656e709c0e6e" name="Task" code="Y1BXAO" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="c114fa94-e852-4526-c223-8a4d21d05098" style="undefined">
						<Widget left="90" top="64" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5c216c18-d81a-4697-b493-698300eca9f9" name="Task" code="PQZLC5" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="1d2faae9-83f2-4785-d503-64bf8873335b" style="undefined">
						<Widget left="140" top="80" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions/>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ', 0, NULL, NULL, 0, NULL, CAST(0x0000AB96010E2A2C AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (763, N'ce4ee560-2d9d-48a7-8276-64be16c8b8ac', N'1', N'qwe', N'weqr', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="ce4ee560-2d9d-48a7-8276-64be16c8b8ac" name="qwe" code="weqr" package="null">
			<Description></Description>
			<Activities>
				<Activity id="8f744488-35e1-4797-ecbb-5daf7ae9ad14" name="Start" code="75G95T" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null"/>
					<Geography parent="a8a1a0b2-915d-41e7-c12d-9ab5e9b7d7c4" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="220" top="220" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f465d7da-5b18-454f-8113-547cc21552fd" name="Task" code="LAYPGM" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a8a1a0b2-915d-41e7-c12d-9ab5e9b7d7c4" style="undefined">
						<Widget left="400" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="47c0cb90-7304-40e3-9955-cfcb51f3d102" from="8f744488-35e1-4797-ecbb-5daf7ae9ad14" to="f465d7da-5b18-454f-8113-547cc21552fd">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8a1a0b2-915d-41e7-c12d-9ab5e9b7d7c4" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ', 0, NULL, N'', 0, NULL, CAST(0x0000ABBB0141D6F4 AS DateTime), CAST(0x0000ABBB014B72A9 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (764, N'0016b82c-9e55-45d4-8f8a-935955a24590', N'1', N'messagestart-process', N'messagestart', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="0016b82c-9e55-45d4-8f8a-935955a24590" name="messagestart-process" code="messagestart" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="3a74d171-49ba-423c-8bf4-5b45b41a9060" name="Task" code="NG2UKY" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="5d979d7f-0fbf-4f51-ffd1-eb2598b955f6" style="undefined">
						<Widget left="420" top="270" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b2d24d51-8dd5-4aba-d950-5267239f13b3" name="StartMessageCatch" code="18OZ7Y" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="Message" expression="null" messageDirection="catch"/>
					<Geography parent="5d979d7f-0fbf-4f51-ffd1-eb2598b955f6" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_start.png">
						<Widget left="200" top="270" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fba39879-0bf5-4f54-d3d7-c8595ed34964" name="EndMessageCatch" code="BZ79BB" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="Message" expression="null" messageDirection="catch"/>
					<Geography parent="5d979d7f-0fbf-4f51-ffd1-eb2598b955f6" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/message_end.png">
						<Widget left="690" top="270" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="530924e0-3f81-4c22-8924-c9fec10c1a4e" from="b2d24d51-8dd5-4aba-d950-5267239f13b3" to="3a74d171-49ba-423c-8bf4-5b45b41a9060">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5d979d7f-0fbf-4f51-ffd1-eb2598b955f6" style="undefined"/>
				</Transition>
				<Transition id="69f918e8-7ed2-408f-f966-481a892c47f0" from="3a74d171-49ba-423c-8bf4-5b45b41a9060" to="fba39879-0bf5-4f54-d3d7-c8595ed34964">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="5d979d7f-0fbf-4f51-ffd1-eb2598b955f6" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ', 2, N'null', N'', 2, N'null', CAST(0x0000ABC4014A28BD AS DateTime), CAST(0x0000ABC4014D2B17 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (765, N'390f3284-b0bc-452c-aeeb-99edc61b4963', N'1', N'servicetasktest', N'servicetasktestprocess', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8"?><Package><WorkflowProcesses><Process id="390f3284-b0bc-452c-aeeb-99edc61b4963" name="servicetasktest" code="servicetasktestprocess" version="1"><Description></Description></Process></WorkflowProcesses></Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ABF101505605 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (781, N'3afcfc55-6476-486c-9533-65b4deb07061', N'1', N'aaa', N'aaacode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="3afcfc55-6476-486c-9533-65b4deb07061" name="aaa" code="aaacode" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="a688817d-a7fc-4c96-a317-16878f764ecc" name="Start" code="2VFS5T" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="1eb4270f-30c4-4b07-c9f1-12236b714ceb" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="230" top="200" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ded81bd4-8714-4159-bcd3-42ad03611ca2" name="Task" code="WWFW71" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="Before" method="SQL" arguments="" expression="">
							<CodeInfo>
								<![CDATA[select * from sysuser;]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="1eb4270f-30c4-4b07-c9f1-12236b714ceb" style="undefined">
						<Widget left="380" top="210" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions/>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ', 0, NULL, N'', 0, NULL, CAST(0x0000ABFA00E1BDEE AS DateTime), CAST(0x0000AC4400A22392 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (782, N'a306de72-1c00-4498-bbf0-042d5ea55de6', N'1', N'tttfull', N'tttcode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="a306de72-1c00-4498-bbf0-042d5ea55de6" name="tttfull" code="tttcode" package="undefined">
			<Description></Description>
			<Transitions/>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ', 0, NULL, N'', 0, NULL, CAST(0x0000ABFA00E3620E AS DateTime), CAST(0x0000ABFA00E36220 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (785, N'785ba800-34cc-4524-a9f5-1abe0417da6c', N'1', N'fffprocess', N'fffprocesscode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="785ba800-34cc-4524-a9f5-1abe0417da6c" name="fffprocess" code="fffprocesscode" package="null">
			<Description></Description>
			<Activities>
				<Activity id="5a936245-60b1-4b91-dc6b-f79743af7b9a" name="Start" code="LTUKXX" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="6189a643-3c6c-478a-da73-a040e5e55bf7" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="290" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b9b3e4c4-b262-46ba-9da1-6f70154e1aa8" name="Task" code="EAVB1Z" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="6189a643-3c6c-478a-da73-a040e5e55bf7" style="undefined">
						<Widget left="410" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0d7ecc9f-2c61-4ac9-b8cb-523abc4ba0f4" name="End" code="UK169Z" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="6189a643-3c6c-478a-da73-a040e5e55bf7" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="610" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3fc0afad-0b03-49c8-d36b-dd30f13a6829" name="Task4" code="E8Q5HF" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="6189a643-3c6c-478a-da73-a040e5e55bf7" style="undefined">
						<Widget left="520" top="310" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c5a37a4b-ba44-47f9-c221-f261cdb1b1f7" name="Task3" code="YWQEAA" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="6189a643-3c6c-478a-da73-a040e5e55bf7" style="undefined">
						<Widget left="360" top="380" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="72b6ff6e-aa2f-44c9-bddd-f32ceb67b1c4" name="Task5" code="1R8OI3" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="6189a643-3c6c-478a-da73-a040e5e55bf7" style="undefined">
						<Widget left="510" top="380" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions/>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ', 0, NULL, N'', 0, NULL, CAST(0x0000AC0A009832C1 AS DateTime), CAST(0x0000AC0A009DE466 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (786, N'799252f9-6262-4da0-ab4e-ec7a580d937f', N'1', N'BookSellerProcess9683', N'BookSellerProcessCode9683', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="799252f9-6262-4da0-ab4e-ec7a580d937f" name="BookSellerProcess9683" code="BookSellerProcessCode9683" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="6aed7362-43b9-4ba3-8ba5-7a8d356953df" name="Start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="0846c55e-366a-463d-f928-40bc2152b896" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d7608a64-0859-4945-a425-5ad44c19caaa" name="Package Books" code="003" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="0846c55e-366a-463d-f928-40bc2152b896" style="">
						<Widget left="210" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d6534fc3-4d80-42e2-a6ee-c5a963b82289" name="Deliver Books" code="005" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="0846c55e-366a-463d-f928-40bc2152b896" style="">
						<Widget left="370" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7c8f2a15-0675-49d1-98d1-5debf31b4945" name="End" code="End" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="0846c55e-366a-463d-f928-40bc2152b896" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="580" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="5ed6dd25-a613-43df-97b5-7467c0cb3eae" from="6aed7362-43b9-4ba3-8ba5-7a8d356953df" to="d7608a64-0859-4945-a425-5ad44c19caaa">
					<Description></Description>
					<Geography parent="0846c55e-366a-463d-f928-40bc2152b896" style="null"/>
				</Transition>
				<Transition id="10035162-8f58-455e-8fb8-e7fa82d17431" from="d7608a64-0859-4945-a425-5ad44c19caaa" to="d6534fc3-4d80-42e2-a6ee-c5a963b82289">
					<Description></Description>
					<Geography parent="0846c55e-366a-463d-f928-40bc2152b896" style="null"/>
				</Transition>
				<Transition id="cbd73a6e-98bc-44e0-b7fb-71f5a86d5814" from="d6534fc3-4d80-42e2-a6ee-c5a963b82289" to="7c8f2a15-0675-49d1-98d1-5debf31b4945">
					<Description></Description>
					<Geography parent="0846c55e-366a-463d-f928-40bc2152b896" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ', 0, NULL, NULL, 0, NULL, CAST(0x0000AC200187F04E AS DateTime), CAST(0x0000AC2100C44FA3 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (787, N'686d06ca-52fa-4645-905c-d4bef994a129', N'1', N'xortest', N'xortestcode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="686d06ca-52fa-4645-905c-d4bef994a129" name="xortest" code="xortestcode" package="null">
			<Description></Description>
			<Activities>
				<Activity id="9c19bdd0-3abb-47fe-e569-698c4837913b" name="Start" code="43HVD3" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="210" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e11d6ea8-caac-4f71-8e3f-c231b39866c0" name="End" code="6H5SEZ" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="780" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8d83e93d-9abe-4ca4-f76c-c976f460c56a" name="task-001" code="KQPJ68" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined">
						<Widget left="300" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="594542cf-a145-4dee-98d4-24861dd011c0" name="gateway-split" code="2G5RVR" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="XOrSplit" gatewayJoinPass="null"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="470" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="94985e44-23f5-459a-ad07-5e65875cb28d" name="task-002" code="L640PM" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined">
						<Widget left="630" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="41658eab-7561-4c54-9394-950890860df9" name="task-003" code="C992TV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined">
						<Widget left="630" top="300" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="ea0e5edc-30d8-46c1-b6e7-be5ed25e35ee" from="9c19bdd0-3abb-47fe-e569-698c4837913b" to="8d83e93d-9abe-4ca4-f76c-c976f460c56a">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined"/>
				</Transition>
				<Transition id="28ba700c-92eb-449b-a1b5-d9be10762baf" from="8d83e93d-9abe-4ca4-f76c-c976f460c56a" to="594542cf-a145-4dee-98d4-24861dd011c0">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined"/>
				</Transition>
				<Transition id="e2b6501e-d8c8-4646-9be3-bf8500a4f812" from="594542cf-a145-4dee-98d4-24861dd011c0" to="94985e44-23f5-459a-ad07-5e65875cb28d">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[a=1 && b=2]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours priority="-1"/>
					<Receiver/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined"/>
				</Transition>
				<Transition id="50bf6eb3-a798-4ef3-d100-171f85fd19eb" from="594542cf-a145-4dee-98d4-24861dd011c0" to="41658eab-7561-4c54-9394-950890860df9">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined"/>
				</Transition>
				<Transition id="938b94d5-6787-4076-8dae-46273116efc6" from="94985e44-23f5-459a-ad07-5e65875cb28d" to="e11d6ea8-caac-4f71-8e3f-c231b39866c0">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined"/>
				</Transition>
				<Transition id="fe4a2203-56bc-4a96-d6f4-4d5fe76386d6" from="41658eab-7561-4c54-9394-950890860df9" to="e11d6ea8-caac-4f71-8e3f-c231b39866c0">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="8561d95e-9c24-4b9b-9414-68bc46f9976a" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000AC2F01203E71 AS DateTime), CAST(0x0000AC2F0120D9A9 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (791, N'88401241-0a98-4639-b3fa-f7612eb0fd55', N'1', N'LessonsLearned090402', N'LessonsLearned1', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="88401241-0a98-4639-b3fa-f7612eb0fd55" name="LessonsLearned090402" code="LessonsLearned1" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="bec60a19-153c-4669-ac94-5e70b1fa09d0" name="Start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="10" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c0583d2e-6b73-4e06-be60-2c06cc32db43" name="ED LL start to distribution" code="distribution" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="">
						<Widget left="90" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="89654108-5b54-449e-bd11-2ea9ef8ab6f3" name="Distribution to ED" code="Distribution_ED" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="300" top="310" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="59f65da4-a956-4923-b541-0b6a62cd7a76" name="Distribution in IPN" code="Distribution_in_IPN" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="290" top="460" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="96242ed9-7760-49e1-9c27-b1b3a096a83c" name="Distribution inside plant" code="Distribution_inside_plant" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="290" top="630" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fdd42777-fba7-491e-d8e4-c6f80d6e50c0" name="Sent to ED LLC" code="Sent_to_ED_LLC" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="510" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0bc230bb-77e9-4e5c-efc0-c93ddd521b71" name="Manager agree to send out as select filter?" code="LYPVGB" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="620" top="500" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="582b7763-134d-4949-de5d-0e78de3f8515" name="Feedback mandatory?" code="KHMJPV" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="610" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="495912ff-a339-43f4-fc01-222b6d1feadc" name="Send email as notification" code="Send_email_as_notification" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="610" top="50" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b4efd06c-7f4f-4d24-d066-1ccff8142e07" name="section manager Group" code="5PH9OI" url="">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Parallel" compareType="null" completeOrder=""/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="840" top="110" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9f9b6522-1eff-49a4-919d-d8caefad1f41" name="Assign feedback task to one person in this section" code="Assign_feedback task_person" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1020" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4247bd94-a0a7-4d84-9d1a-13f2f324112d" name="No actions planned (all)" code="COI138" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="XOrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1170" top="278" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3ba1e28b-b100-4abe-e5ab-6811f7a1e218" name="Section manager approve?" code="LKN2VV" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1260" top="166" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2e6005c5-b82e-4663-cd32-917c01c661db" name="HoD approve?" code="JJY6EW" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1260" top="410" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a7f9ea2c-fb1c-48a9-89a9-8ea000bf9666" name="Approve" code="5X89YA" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1440" top="360" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b9c52097-e1d7-4e84-e348-8c7d0ed10b7a" name="responsible tracking" code="EVD1G6" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1560" top="360" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="29994288-7546-4d99-b96b-9c4771b1bcf8" name="Responsible tracking" code="6MBBDA" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1560" top="198" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="333bf0bd-e48c-4818-c23a-5af804de156a" name="Approve" code="1Z489L" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1440" top="198" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="407aedaa-b5be-4305-a72e-9dd08c05bf3f" name="Section manager approved?(confirm effectiveness)" code="FWBK55" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1710" top="192" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fbb046ef-0179-4f59-d3ab-589d5578a0a5" name="Approve" code="ELRQSH" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1850" top="192" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d73bad13-1c33-48e5-fe94-fe99fddde641" name="Change responsible and due date" code="EITROF" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1710" top="270" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a91c2829-a18b-4325-baf9-5a15cd0cfba7" name="LL end" code="QOI513" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="2300" top="290" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4d7e7053-795d-4509-c2d5-7463c79162f5" name="Manager agree to send out as select filter?" code="IWKJAW" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="510" top="500" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d8566f4b-aa23-430c-a3cf-9ed67b6d5d38" name="is ED LLC?" code="VY9BOX" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="180" top="82" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5b68f67c-9145-492b-8bd6-2267cc487a0f" name="HoD approved?(confirm effectiveness)" code="FWBK55" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1710" top="360" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="191624c2-99b5-428b-ac30-03107afdca25" name="Change responsible and due date" code="EITROF" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1710" top="442" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d1ab84f8-215e-47d3-8d1c-f6a712f6bace" name="Approve" code="GULHV8" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1850" top="360" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fb9eaeab-39cd-4bff-9747-36bc5736f010" name="Close" code="GZ2R9Z" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="XOrJoin" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="2140" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7c9734b6-a37b-46ff-b258-88a2f718ca53" name="Closer" code="DKUHT2" url="">
					<Description>ED Level closed by ED-LLC; IPN leve closed by Lead plant QMM; Plant Level closed by Plant QMM.</Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1990" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c1f2cda4-3f46-4a23-fe53-3b6c25d59dac" name="if leadership RC filter activated" code="H6BBR5" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="720" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6e33e88c-109d-4658-9aa1-4b3e7dde3fe5" name="HoD Group" code="Z43E63" url="">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="null" mergeType="null" compareType="null" completeOrder=""/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="840" top="532" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fa646257-32c9-4aa9-e07d-576266afedad" name="Assign feedback task to one person in this section" code="Assign_feedback task_person" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="970" top="654" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="35bb2aa5-35df-4b40-b312-f8fae8e2b24c" name="No actions planned (all)" code="COI138" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="XOrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1120" top="642" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4d075523-abd4-4adb-e0bb-e3a9bf77606a" name="Section manager approve?" code="LKN2VV" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1220" top="564" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="549f05b6-2463-4798-857e-ea096692de15" name="HoD approve?" code="JJY6EW" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1200" top="850" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1ebd2fc6-d22e-42a2-b32b-9e3021d8b688" name="Approve" code="5X89YA" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1390" top="760" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ca9b8c55-b06f-418a-c5d2-0436e52bca20" name="responsible tracking" code="EVD1G6" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1510" top="756" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a5ab675c-9def-48c4-fc53-4822523ed2e8" name="Responsible tracking" code="6MBBDA" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1512" top="598" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4a753ae3-710f-44e2-e165-150638f1cc18" name="Approve" code="1Z489L" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1390" top="598" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3514db60-66fd-45e6-acb8-00b2c8efff9b" name="Section manager approved?(confirm effectiveness)" code="FWBK55" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1660" top="588" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e598400f-e301-4589-d247-9b493d864c47" name="Approve" code="ELRQSH" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1800" top="580" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="66937cc3-f270-4656-ee65-4cdd92b1faf8" name="Change responsible and due date" code="EITROF" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1660" top="654" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f9deb889-cf41-4a7a-933f-13ad88b4cc0a" name="HoD approved?(confirm effectiveness)" code="FWBK55" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1660" top="756" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="dc23f9eb-0c6e-47fa-d419-ecee26ee7ac0" name="Change responsible and due date" code="EITROF" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined">
						<Widget left="1660" top="860" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d1bcc996-b887-4890-a74b-848da5545f95" name="Approve" code="GULHV8" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1810" top="756" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="6855bf69-8d78-40ed-a696-de43040716db" from="bec60a19-153c-4669-ac94-5e70b1fa09d0" to="c0583d2e-6b73-4e06-be60-2c06cc32db43">
					<Description></Description>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="null"/>
				</Transition>
				<Transition id="7d6bef3a-6ef8-4936-d709-09360f5ecb3a" from="c0583d2e-6b73-4e06-be60-2c06cc32db43" to="d8566f4b-aa23-430c-a3cf-9ed67b6d5d38">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="132d2b0b-0c07-4c54-9957-7ad795c477cf" from="89654108-5b54-449e-bd11-2ea9ef8ab6f3" to="fdd42777-fba7-491e-d8e4-c6f80d6e50c0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="a1c92494-ba7e-4e20-fa6b-f3f4bbbc53f0" from="d8566f4b-aa23-430c-a3cf-9ed67b6d5d38" to="89654108-5b54-449e-bd11-2ea9ef8ab6f3">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsED=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="2ef6cdbc-dfd5-481e-b979-2f2a81cafdb4" from="d8566f4b-aa23-430c-a3cf-9ed67b6d5d38" to="59f65da4-a956-4923-b541-0b6a62cd7a76">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsED=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="7e51d798-14b5-405b-925a-07c5563026fc" from="d8566f4b-aa23-430c-a3cf-9ed67b6d5d38" to="96242ed9-7760-49e1-9c27-b1b3a096a83c">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsED=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="a50b71a1-6c4e-4e5c-96c6-61297df8f286" from="d8566f4b-aa23-430c-a3cf-9ed67b6d5d38" to="fdd42777-fba7-491e-d8e4-c6f80d6e50c0">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsED=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="d64f8d44-293e-463c-f977-a5f4bd72eb02" from="582b7763-134d-4949-de5d-0e78de3f8515" to="495912ff-a339-43f4-fc01-222b6d1feadc">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsFeedbackMandatory=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="8f656d8d-d0e0-4508-b737-cab66e8b6a9c" from="582b7763-134d-4949-de5d-0e78de3f8515" to="c1f2cda4-3f46-4a23-fe53-3b6c25d59dac">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsFeedbackMandatory=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="e4376261-556c-48a3-d1bf-5e4a54a2a0da" from="0bc230bb-77e9-4e5c-efc0-c93ddd521b71" to="c1f2cda4-3f46-4a23-fe53-3b6c25d59dac">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsSendManagerAgree = 1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="6c7d63e2-cd21-4421-f202-863655659944" from="b4efd06c-7f4f-4d24-d066-1ccff8142e07" to="9f9b6522-1eff-49a4-919d-d8caefad1f41">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="f2dd8ae2-c848-48fa-e5e4-651490f86e33" from="9f9b6522-1eff-49a4-919d-d8caefad1f41" to="4247bd94-a0a7-4d84-9d1a-13f2f324112d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="e89fc202-d757-4334-d509-1400379134de" from="4247bd94-a0a7-4d84-9d1a-13f2f324112d" to="3ba1e28b-b100-4abe-e5ab-6811f7a1e218">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="5eb968b3-fc96-496a-81c4-f2762f3790f1" from="4247bd94-a0a7-4d84-9d1a-13f2f324112d" to="2e6005c5-b82e-4663-cd32-917c01c661db">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsAllNoActionPlanned=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours priority="-1"/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="a1ef84f1-c54d-4793-967c-05a09ece0e3d" from="2e6005c5-b82e-4663-cd32-917c01c661db" to="a7f9ea2c-fb1c-48a9-89a9-8ea000bf9666">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="d8cc5aaf-57a1-4d50-f0e0-e56b68622c2a" from="a7f9ea2c-fb1c-48a9-89a9-8ea000bf9666" to="9f9b6522-1eff-49a4-919d-d8caefad1f41">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove = 0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="fb83cf96-c6a4-4594-e62f-ccb6e6ee4e4d" from="a7f9ea2c-fb1c-48a9-89a9-8ea000bf9666" to="b9c52097-e1d7-4e84-e348-8c7d0ed10b7a">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove = 1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="5b3bcb71-945a-4364-edfd-ac01ef22f218" from="3ba1e28b-b100-4abe-e5ab-6811f7a1e218" to="333bf0bd-e48c-4818-c23a-5af804de156a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="f84df898-5a94-4b33-8a04-8c8a71c85bd4" from="333bf0bd-e48c-4818-c23a-5af804de156a" to="29994288-7546-4d99-b96b-9c4771b1bcf8">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove = 1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="c7c5e94a-3cab-4790-f42b-eab4c65fd799" from="333bf0bd-e48c-4818-c23a-5af804de156a" to="9f9b6522-1eff-49a4-919d-d8caefad1f41">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove = 0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="7ba157be-d33a-4cda-bc8f-ede63d8f8476" from="29994288-7546-4d99-b96b-9c4771b1bcf8" to="407aedaa-b5be-4305-a72e-9dd08c05bf3f">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="ff354983-79aa-4bd8-952a-8c09c305aa90" from="407aedaa-b5be-4305-a72e-9dd08c05bf3f" to="fbb046ef-0179-4f59-d3ab-589d5578a0a5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="99023b8a-a1a0-4eec-93fd-b9316792afff" from="d73bad13-1c33-48e5-fe94-fe99fddde641" to="29994288-7546-4d99-b96b-9c4771b1bcf8">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="ab00904d-e5d9-48bd-8345-2c7fade43da6" from="fbb046ef-0179-4f59-d3ab-589d5578a0a5" to="d73bad13-1c33-48e5-fe94-fe99fddde641">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="49eca4fb-16b3-4cd2-fa44-2a4ec7939bab" from="4d7e7053-795d-4509-c2d5-7463c79162f5" to="0bc230bb-77e9-4e5c-efc0-c93ddd521b71">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="368c7fba-f1b8-4f3f-92ff-2e5d506d7777" from="fdd42777-fba7-491e-d8e4-c6f80d6e50c0" to="582b7763-134d-4949-de5d-0e78de3f8515">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="21926852-9b67-4283-bc65-b8c16f512977" from="59f65da4-a956-4923-b541-0b6a62cd7a76" to="4d7e7053-795d-4509-c2d5-7463c79162f5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="6c98125b-b5a6-483f-c339-351e01d04ffb" from="96242ed9-7760-49e1-9c27-b1b3a096a83c" to="4d7e7053-795d-4509-c2d5-7463c79162f5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="33f33246-94be-479c-dad4-743b98f06784" from="4d7e7053-795d-4509-c2d5-7463c79162f5" to="c0583d2e-6b73-4e06-be60-2c06cc32db43">
					<Description>驳回</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsSendManagerAgree = 0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="f178c822-c7c0-4733-c932-c42ab68760af" from="b9c52097-e1d7-4e84-e348-8c7d0ed10b7a" to="5b68f67c-9145-492b-8bd6-2267cc487a0f">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="faf50bf3-50db-413a-9c19-92db20f83587" from="5b68f67c-9145-492b-8bd6-2267cc487a0f" to="d1ab84f8-215e-47d3-8d1c-f6a712f6bace">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="8e8818b4-7b3e-4bd6-a53d-7aed82afc913" from="d1ab84f8-215e-47d3-8d1c-f6a712f6bace" to="191624c2-99b5-428b-ac30-03107afdca25">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="aac8349a-69c1-411e-f209-0e85011b9bf8" from="191624c2-99b5-428b-ac30-03107afdca25" to="b9c52097-e1d7-4e84-e348-8c7d0ed10b7a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="9d3f3643-04a7-445d-ef46-4c69a4fbe4aa" from="fbb046ef-0179-4f59-d3ab-589d5578a0a5" to="7c9734b6-a37b-46ff-b258-88a2f718ca53">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="28595ce2-be8c-43e4-e91b-20333b902217" from="d1ab84f8-215e-47d3-8d1c-f6a712f6bace" to="7c9734b6-a37b-46ff-b258-88a2f718ca53">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="bf7d7dc7-27ed-43b7-ca1b-9611029a2448" from="7c9734b6-a37b-46ff-b258-88a2f718ca53" to="fb9eaeab-39cd-4bff-9747-36bc5736f010">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="58bc03d1-4dc2-455b-887f-fd3cb4376c9d" from="fb9eaeab-39cd-4bff-9747-36bc5736f010" to="a91c2829-a18b-4325-baf9-5a15cd0cfba7">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsClose=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="44e5cfe0-d2a8-43ea-fe5c-733401a72432" from="7c9734b6-a37b-46ff-b258-88a2f718ca53" to="b4efd06c-7f4f-4d24-d066-1ccff8142e07">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsClose=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="742beeca-0191-4269-e041-d72d26d32f8c" from="fb9eaeab-39cd-4bff-9747-36bc5736f010" to="7c9734b6-a37b-46ff-b258-88a2f718ca53">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsClose=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="a80f6874-0980-49ee-ac5b-d964871fd6a1" from="c1f2cda4-3f46-4a23-fe53-3b6c25d59dac" to="b4efd06c-7f4f-4d24-d066-1ccff8142e07">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="cb905c5d-66ca-4cd3-8a37-1c97353b351c" from="fa646257-32c9-4aa9-e07d-576266afedad" to="35bb2aa5-35df-4b40-b312-f8fae8e2b24c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="1f69b6a6-8278-4251-ef95-e0447b804231" from="35bb2aa5-35df-4b40-b312-f8fae8e2b24c" to="4d075523-abd4-4adb-e0bb-e3a9bf77606a">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="93973a7c-6334-4056-a407-7d8c06fbc05a" from="35bb2aa5-35df-4b40-b312-f8fae8e2b24c" to="549f05b6-2463-4798-857e-ea096692de15">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsAllNoActionPlanned=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours priority="-1"/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="9ce1e46d-3371-4466-9fbc-189199175940" from="549f05b6-2463-4798-857e-ea096692de15" to="1ebd2fc6-d22e-42a2-b32b-9e3021d8b688">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="d8522774-6411-40c3-8496-e9d4744d2b3c" from="1ebd2fc6-d22e-42a2-b32b-9e3021d8b688" to="fa646257-32c9-4aa9-e07d-576266afedad">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove = 0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="5527950a-c214-4ab9-e3eb-683852905503" from="1ebd2fc6-d22e-42a2-b32b-9e3021d8b688" to="ca9b8c55-b06f-418a-c5d2-0436e52bca20">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove = 1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="3a35a53b-3f4b-474c-c50a-56d7389c5452" from="4d075523-abd4-4adb-e0bb-e3a9bf77606a" to="4a753ae3-710f-44e2-e165-150638f1cc18">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="81425c18-773e-44d8-86fc-0961766040d5" from="4a753ae3-710f-44e2-e165-150638f1cc18" to="a5ab675c-9def-48c4-fc53-4822523ed2e8">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove = 1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="b3e4096e-b7a8-4605-a806-e15b9a547bb4" from="4a753ae3-710f-44e2-e165-150638f1cc18" to="fa646257-32c9-4aa9-e07d-576266afedad">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove = 0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="1e4bce12-211f-40dc-fdec-bbef96fa3f91" from="a5ab675c-9def-48c4-fc53-4822523ed2e8" to="3514db60-66fd-45e6-acb8-00b2c8efff9b">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="22b4a033-592f-4a74-ebb2-48f14abd158a" from="3514db60-66fd-45e6-acb8-00b2c8efff9b" to="e598400f-e301-4589-d247-9b493d864c47">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="a9b076ad-28f7-426d-ed08-5973ce1251db" from="66937cc3-f270-4656-ee65-4cdd92b1faf8" to="a5ab675c-9def-48c4-fc53-4822523ed2e8">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="a88ee28b-75ba-4849-9edb-85cfacbeac42" from="e598400f-e301-4589-d247-9b493d864c47" to="66937cc3-f270-4656-ee65-4cdd92b1faf8">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="6316559c-7449-4511-d060-3aa1baa4cdf7" from="ca9b8c55-b06f-418a-c5d2-0436e52bca20" to="f9deb889-cf41-4a7a-933f-13ad88b4cc0a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="3b914ab1-cdda-464a-91a6-8504f60cc032" from="f9deb889-cf41-4a7a-933f-13ad88b4cc0a" to="d1bcc996-b887-4890-a74b-848da5545f95">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="1be5d22c-3352-4c1f-db91-225fee81af09" from="d1bcc996-b887-4890-a74b-848da5545f95" to="dc23f9eb-0c6e-47fa-d419-ecee26ee7ac0">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="93b3f951-b8ae-4228-d75a-4e93a4281250" from="dc23f9eb-0c6e-47fa-d419-ecee26ee7ac0" to="ca9b8c55-b06f-418a-c5d2-0436e52bca20">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="c7e7bfb8-f53d-48fc-bf8a-43fdf6841255" from="c1f2cda4-3f46-4a23-fe53-3b6c25d59dac" to="6e33e88c-109d-4658-9aa1-4b3e7dde3fe5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="54bf7e36-53b9-4c92-8ec8-9b276ee5e54d" from="6e33e88c-109d-4658-9aa1-4b3e7dde3fe5" to="fa646257-32c9-4aa9-e07d-576266afedad">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="cbae4e2b-e645-46a1-f223-44d3e86467f0" from="e598400f-e301-4589-d247-9b493d864c47" to="7c9734b6-a37b-46ff-b258-88a2f718ca53">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="be8eeb3d-34a7-408b-ce1a-c55d222a29d9" from="d1bcc996-b887-4890-a74b-848da5545f95" to="7c9734b6-a37b-46ff-b258-88a2f718ca53">
					<Description>Y</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsApprove=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
				<Transition id="2dce804a-5dc8-424f-810f-1ac9d2251b09" from="fb9eaeab-39cd-4bff-9747-36bc5736f010" to="6e33e88c-109d-4658-9aa1-4b3e7dde3fe5">
					<Description>N</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[IsClose=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="294572d9-89d1-4a40-da61-2886d7f19e1d" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AC3200B57C8E AS DateTime), CAST(0x0000AC3200B57C8F AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (793, N'a4a6c04d-ad7a-4e14-bda8-b884f812913a', N'1', N'orjoinosplitgo', N'orjoinorsplitgocode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="a4a6c04d-ad7a-4e14-bda8-b884f812913a" name="orjoinosplitgo" code="orjoinorsplitgocode" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="4d5303b4-2cd9-4586-c24b-90e7c36f56f7" name="Start" code="MT483L" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="240" top="260" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="11eda020-520a-4cb9-fee5-4b0fef0c4ebd" name="End" code="S2L4XK" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1110" top="260" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5ce4013e-98d8-4f67-c908-14c80e76b68d" name="Task01" code="G8EJRM" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined">
						<Widget left="330" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f5bf84dd-0561-46a1-c511-be839569c8c9" name="gateway-split" code="PXWV3X" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="460" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ce7f4683-f2fa-4c8d-f52c-886223151a3e" name="Task02" code="MYSI2F" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined">
						<Widget left="600" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="525f1d7a-f770-4bf2-c3af-3c35bcdf9a24" name="Tasi03" code="S9D5D9" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined">
						<Widget left="610" top="360" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="233c0edd-5989-4f12-9e37-4ed5c8bbd63c" name="gateway-join" code="QXGRNC" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="710" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2b7a5bb7-f32f-402c-92b8-8315c1863c4b" name="gateway-split" code="8OFU3L" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="850" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2cc618ca-3c2c-4cb7-d521-49ba87eb0c9b" name="Task04" code="MA99CU" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined">
						<Widget left="980" top="200" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8f637665-2899-47fb-efdc-bcbf522bb5c4" name="Task05" code="4A9SUJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined">
						<Widget left="980" top="320" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e5a4e351-76b0-4b41-98b7-9c7a80a3c019" from="4d5303b4-2cd9-4586-c24b-90e7c36f56f7" to="5ce4013e-98d8-4f67-c908-14c80e76b68d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="0b70534c-c335-4dc3-ef2d-51464bdd1cfb" from="5ce4013e-98d8-4f67-c908-14c80e76b68d" to="f5bf84dd-0561-46a1-c511-be839569c8c9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="12c05cda-c5a9-47a3-94ee-d94481c3cb55" from="f5bf84dd-0561-46a1-c511-be839569c8c9" to="ce7f4683-f2fa-4c8d-f52c-886223151a3e">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[a="1"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="9b3177c8-7111-4aef-ad1f-0927880a6e44" from="525f1d7a-f770-4bf2-c3af-3c35bcdf9a24" to="233c0edd-5989-4f12-9e37-4ed5c8bbd63c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="bbbd3dd3-cad8-482d-ef5d-f3044398d02c" from="f5bf84dd-0561-46a1-c511-be839569c8c9" to="525f1d7a-f770-4bf2-c3af-3c35bcdf9a24">
					<Description>a=&amp;quot;2&amp;quot;</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[a=2]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="9004ae98-ff35-4070-dd19-1121b52b7c65" from="ce7f4683-f2fa-4c8d-f52c-886223151a3e" to="233c0edd-5989-4f12-9e37-4ed5c8bbd63c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="c9770f0b-0a1a-4eb8-8ae0-a0b4003c58b8" from="233c0edd-5989-4f12-9e37-4ed5c8bbd63c" to="2b7a5bb7-f32f-402c-92b8-8315c1863c4b">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="c5398f96-4d6f-4d17-e734-486e06a5a8de" from="2b7a5bb7-f32f-402c-92b8-8315c1863c4b" to="2cc618ca-3c2c-4cb7-d521-49ba87eb0c9b">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[b=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="b7b2e96a-4292-44e3-c9de-b92af88038b0" from="2b7a5bb7-f32f-402c-92b8-8315c1863c4b" to="8f637665-2899-47fb-efdc-bcbf522bb5c4">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[b=2]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="dfc3863b-178e-4346-c99c-6d7832873e3c" from="2cc618ca-3c2c-4cb7-d521-49ba87eb0c9b" to="11eda020-520a-4cb9-fee5-4b0fef0c4ebd">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
				<Transition id="7a496c16-c418-4de1-8603-c50db79fc06a" from="8f637665-2899-47fb-efdc-bcbf522bb5c4" to="11eda020-520a-4cb9-fee5-4b0fef0c4ebd">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="deec6056-0d44-443d-ac2d-a352a0bafc01" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000AC34012FE5D3 AS DateTime), CAST(0x0000AC36011FF8D1 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (795, N'c8533c32-446d-44da-af28-b3e519471faa', N'1', N'servicenode', N'servicenodetest', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="c8533c32-446d-44da-af28-b3e519471faa" name="servicenode" code="servicenodetest" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="deec2e32-a874-465d-efd5-d0c044824637" name="Service" code="RXKLQ9" url="">
					<Description></Description>
					<ActivityType type="ServiceNode"/>
					<Services>
						<Service method="SQL" arguments="" expression="">
							<CodeInfo>
								<![CDATA[update sysuser set email=''jack@163.com'' where username=''Test'';]]>
							</CodeInfo>
						</Service>
					</Services>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/service_task.png">
						<Widget left="500" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0bc923e3-07df-4cc7-c835-44eb01670841" name="Start" code="JZSDK4" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="220" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="72f45b58-1d78-49fa-8da9-2a59baace9a3" name="End" code="UXB18L" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="840" top="230" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="35540f9c-b374-4e26-a451-fdb7f0e65dd5" name="Task-01" code="20WTC8" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="undefined">
						<Widget left="340" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="476ac9a9-0ba7-454b-da05-ad7eb9f2a1dc" name="Task-02" code="JGF7K7" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="undefined">
						<Widget left="670" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="efbd5ce4-0e83-4375-a2cc-2c8f5040038b" from="0bc923e3-07df-4cc7-c835-44eb01670841" to="35540f9c-b374-4e26-a451-fdb7f0e65dd5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="undefined"/>
				</Transition>
				<Transition id="5c5bd5d4-4647-4817-c494-9a6180a76795" from="35540f9c-b374-4e26-a451-fdb7f0e65dd5" to="deec2e32-a874-465d-efd5-d0c044824637">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="undefined"/>
				</Transition>
				<Transition id="6ff30968-a5f8-419c-f85e-4865ce6349cd" from="deec2e32-a874-465d-efd5-d0c044824637" to="476ac9a9-0ba7-454b-da05-ad7eb9f2a1dc">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="undefined"/>
				</Transition>
				<Transition id="1aec0409-9530-4248-e09b-4f8f2419d5ad" from="476ac9a9-0ba7-454b-da05-ad7eb9f2a1dc" to="72f45b58-1d78-49fa-8da9-2a59baace9a3">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="b1d56c78-8524-492d-9533-fd189a50ac05" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000AC4600EED9FA AS DateTime), CAST(0x0000AC5A0146473F AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (796, N'1dfdd8e6-b857-49b1-a09c-be5433a16a1a', N'1', N'Cargue de documentos', N'carguedocumentos', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="1dfdd8e6-b857-49b1-a09c-be5433a16a1a" name="Cargue de documentos" code="carguedocumentos" package="null">
			<Description></Description>
			<Activities>
				<Activity id="513d0d25-7ee0-42b0-ee27-284a947f6676" name="Start" code="TUXE38" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="130" top="50" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ad8b04f9-8799-474a-dc50-ce82e88eb9f7" name="Request" code="XEKRWD" url="">
					<Description>Creación de petición y cargue de documentos</Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined">
						<Widget left="250" top="70" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="33d0cac2-72cd-466e-d75d-757fc07ea931" name="Accept response" code="OLEH63" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined">
						<Widget left="590" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1b5472d5-d1b2-4394-dddd-80020ed70b99" name="End" code="BH32MN" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="800" top="92" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0253d8a4-976b-41c9-faca-cc0097dfba17" name="Response request" code="7M8Q5Z" url="">
					<Description>Responder petición al ciudadano</Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined">
						<Widget left="450" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="28430020-101d-45ff-b8fd-45817cb343e2" name="Review Request" code="WVI9XT" url="">
					<Description>Revisión de documentos </Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined">
						<Widget left="250" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="982f5f08-0f50-48fe-df33-cbbfc78cdb50" from="513d0d25-7ee0-42b0-ee27-284a947f6676" to="ad8b04f9-8799-474a-dc50-ce82e88eb9f7">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined"/>
				</Transition>
				<Transition id="1bc47e06-98d2-49da-f950-4619f479892c" from="33d0cac2-72cd-466e-d75d-757fc07ea931" to="1b5472d5-d1b2-4394-dddd-80020ed70b99">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined"/>
				</Transition>
				<Transition id="cc74eaaa-ec6c-4eb8-ac68-dc6897b28243" from="28430020-101d-45ff-b8fd-45817cb343e2" to="0253d8a4-976b-41c9-faca-cc0097dfba17">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined"/>
				</Transition>
				<Transition id="b9e398ab-b575-4e5f-abe3-439bedf39aa3" from="ad8b04f9-8799-474a-dc50-ce82e88eb9f7" to="28430020-101d-45ff-b8fd-45817cb343e2">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined"/>
				</Transition>
				<Transition id="eafa02cd-79eb-4fef-8693-9c01900fd74f" from="0253d8a4-976b-41c9-faca-cc0097dfba17" to="33d0cac2-72cd-466e-d75d-757fc07ea931">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cabd5500-3966-40ec-e0d4-b2779cf6fb4d" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AC5A01396192 AS DateTime), CAST(0x0000AC5A01396207 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (797, N'615168ee-5a36-4dd2-8ec4-f40a45b2d6ef', N'1', N'travel ', N'travel', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="615168ee-5a36-4dd2-8ec4-f40a45b2d6ef" name="travel " code="travel" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="30601b81-348b-4e09-f69a-450177ab92b4" name="Start" code="E5VZAD" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="80" top="180" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8e352f7b-7910-4863-ab55-fb9aa0388fd4" name="Request travel" code="7PS3M2" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined">
						<Widget left="180" top="180" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2af09d50-28d1-45cc-c850-e6795d2610ff" name="Check order form" code="D28M8O" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined">
						<Widget left="290" top="180" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f90d8314-d282-484e-9ff4-729000439ded" name="gateway-split" code="E3CYZ0" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="410" top="180" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9c1c9ec6-6531-42c9-ccde-d05b106f7bc9" name="Reserve flights" code="TJ6UTY" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined">
						<Widget left="540" top="110" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1d8feb09-927f-4d48-9ac4-1dff69d91c91" name="Reserve hotels" code="1Z4PIJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined">
						<Widget left="530" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="cfde2d70-bc50-4990-dc29-09a2a22b545d" name="Notify client" code="7UEP2J" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined">
						<Widget left="780" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="aa7aec62-9c10-407b-dd99-3a362f69e33f" name="End" code="SNH8F1" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="910" top="170" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7bbd9e30-61f3-4039-bbf9-ee91100df3e5" name="gateway-join" code="QAYL5W" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin" gatewayJoinPass="null"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="670" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="a50ef893-caa0-4588-9617-f194a6f18e88" from="8e352f7b-7910-4863-ab55-fb9aa0388fd4" to="2af09d50-28d1-45cc-c850-e6795d2610ff">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
				<Transition id="8821741e-1858-4d49-d967-55da4e548ceb" from="2af09d50-28d1-45cc-c850-e6795d2610ff" to="f90d8314-d282-484e-9ff4-729000439ded">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
				<Transition id="3e5ff5a7-3c5d-41b6-e13e-040a2d2cff6b" from="f90d8314-d282-484e-9ff4-729000439ded" to="9c1c9ec6-6531-42c9-ccde-d05b106f7bc9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
				<Transition id="d86c11c1-2dc3-4601-8d0f-985fa1495a17" from="f90d8314-d282-484e-9ff4-729000439ded" to="1d8feb09-927f-4d48-9ac4-1dff69d91c91">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
				<Transition id="6b7f9d5e-bf80-41d7-e063-23841dd77e46" from="cfde2d70-bc50-4990-dc29-09a2a22b545d" to="aa7aec62-9c10-407b-dd99-3a362f69e33f">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
				<Transition id="e3d8c8a7-bb5f-4189-ddb7-955f1d2a0227" from="9c1c9ec6-6531-42c9-ccde-d05b106f7bc9" to="7bbd9e30-61f3-4039-bbf9-ee91100df3e5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
				<Transition id="c0d9c680-94a7-47b0-88c7-f6b30bce450d" from="1d8feb09-927f-4d48-9ac4-1dff69d91c91" to="7bbd9e30-61f3-4039-bbf9-ee91100df3e5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
				<Transition id="0749f8e0-d8e4-4db9-8c69-bd11825bc595" from="7bbd9e30-61f3-4039-bbf9-ee91100df3e5" to="cfde2d70-bc50-4990-dc29-09a2a22b545d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
				<Transition id="c5f60258-94c1-4570-e8b0-faa7b2b13fcd" from="30601b81-348b-4e09-f69a-450177ab92b4" to="8e352f7b-7910-4863-ab55-fb9aa0388fd4">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a6572402-bfbe-4fd5-e67c-efd0f15ca585" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AC5A013973F6 AS DateTime), CAST(0x0000ACB600DA527A AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (798, N'4b096479-c600-4083-99ed-14512160e75b', N'1', N'orsplit-intermediate-process', N'orsplit-intermediate-process-code', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="4b096479-c600-4083-99ed-14512160e75b" name="orsplit-intermediate-process" code="orsplit-intermediate-process-code" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="efd49856-eda0-48ea-ed75-d8da2fa60e79" name="Start" code="3F0KTR" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="360" top="270" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="18ac5d21-5e7e-47b0-b738-72c1402ae3f5" name="End" code="TEASA1" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1130" top="260" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ff87f7d7-b5a5-4d25-90ea-699568fb7496" name="Task-01" code="KZZFAW" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined">
						<Widget left="470" top="270" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="797fa5a7-8977-4504-f480-0323c8e54278" name="gateway-split" code="0IK8AJ" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="650" top="270" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1cbf4be3-d99d-4694-eef1-351fea959627" name="Task-02" code="T4G6Q6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined">
						<Widget left="820" top="210" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6222fd99-f944-4c00-c66f-f6cdf1596a3b" name="InteEvent" code="KSL6R6" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="Before" method="SQL" arguments="" expression="">
							<CodeInfo>
								<![CDATA[ 								select * from sysuser; 							]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="840" top="320" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5e8f098f-9534-41dc-85e5-3d9cae9800a8" name="gateway-join" code="LPD8CF" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="960" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="c9664b80-0dbf-4853-d1ff-e4e91a7df218" from="efd49856-eda0-48ea-ed75-d8da2fa60e79" to="ff87f7d7-b5a5-4d25-90ea-699568fb7496">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined"/>
				</Transition>
				<Transition id="96c093ea-4ae3-439f-8cfb-d5a07b2615ff" from="ff87f7d7-b5a5-4d25-90ea-699568fb7496" to="797fa5a7-8977-4504-f480-0323c8e54278">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined"/>
				</Transition>
				<Transition id="c3376f49-3a78-48db-eccb-5c9985864ebf" from="797fa5a7-8977-4504-f480-0323c8e54278" to="1cbf4be3-d99d-4694-eef1-351fea959627">
					<Description>days &amp;gt; 3</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days > 3]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined"/>
				</Transition>
				<Transition id="1cb5783e-3267-4196-cfcf-b433ddc6ee64" from="797fa5a7-8977-4504-f480-0323c8e54278" to="6222fd99-f944-4c00-c66f-f6cdf1596a3b">
					<Description>days &amp;lt;= 3</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days <= 3]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined"/>
				</Transition>
				<Transition id="68a43146-8e14-43a1-cd3b-0f7f8f6a086d" from="1cbf4be3-d99d-4694-eef1-351fea959627" to="5e8f098f-9534-41dc-85e5-3d9cae9800a8">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined"/>
				</Transition>
				<Transition id="6b441356-d6c5-43d2-a1b7-41c472f559da" from="6222fd99-f944-4c00-c66f-f6cdf1596a3b" to="5e8f098f-9534-41dc-85e5-3d9cae9800a8">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined">
						<Points>
							<Point x="920" y="310"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="72896820-92ee-4a10-bda2-eb65f89ac169" from="5e8f098f-9534-41dc-85e5-3d9cae9800a8" to="18ac5d21-5e7e-47b0-b738-72c1402ae3f5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="2def86ab-cba2-42a4-f3e3-42de8850d976" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000AC5D00D0AA16 AS DateTime), CAST(0x0000AC5D0133139F AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (799, N'b6aac2c1-31e9-4bd4-ade7-d110bf1bac72', N'1', N'approval-gateway', N'approval-gateway-code', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="b6aac2c1-31e9-4bd4-ade7-d110bf1bac72" name="approval-gateway" code="approval-gateway-code" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="ebadcd99-df64-439b-83f4-578b366691d4" name="Start" code="EC3YZ2" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="210" top="290" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="674db2bc-c019-4998-9d1b-c2ea394b2b7c" name="End" code="HPAWFY" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="870" top="290" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b09fb177-6ef2-46ed-8f94-6a6f5f47c782" name="Task-01" code="RP7Y4H" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined">
						<Widget left="330" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c9f2bbfa-25f5-4861-8eee-b290f632d786" name="Approval-OrSplit" code="OJJM2Q" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="ApprovalOrSplit" gatewayJoinPass="null"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="480" top="290" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="96506751-cf62-411a-8ed5-025221436657" name="Task-02" code="D2D2JH" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined">
						<Widget left="660" top="210" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d9521401-5d1c-4a59-8039-966cda7072b7" name="Task-03" code="I91TDJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined">
						<Widget left="660" top="370" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e62c369a-91d3-49df-8806-3a3221425565" from="ebadcd99-df64-439b-83f4-578b366691d4" to="b09fb177-6ef2-46ed-8f94-6a6f5f47c782">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined"/>
				</Transition>
				<Transition id="43fa230a-7759-4386-ede4-ab04c7a10d5e" from="c9f2bbfa-25f5-4861-8eee-b290f632d786" to="96506751-cf62-411a-8ed5-025221436657">
					<Description>Agreed</Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours approval="1"/>
					<Receiver/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined"/>
				</Transition>
				<Transition id="2d8b2060-5cd0-411c-ce97-e697a695d549" from="c9f2bbfa-25f5-4861-8eee-b290f632d786" to="d9521401-5d1c-4a59-8039-966cda7072b7">
					<Description>Refused</Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours approval="-1"/>
					<Receiver/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined"/>
				</Transition>
				<Transition id="a3655051-d93e-4cff-916c-7d1a2ceb7c42" from="96506751-cf62-411a-8ed5-025221436657" to="674db2bc-c019-4998-9d1b-c2ea394b2b7c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined"/>
				</Transition>
				<Transition id="829dd5ab-e28d-4795-d1dc-a6890bfbafc4" from="d9521401-5d1c-4a59-8039-966cda7072b7" to="674db2bc-c019-4998-9d1b-c2ea394b2b7c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined"/>
				</Transition>
				<Transition id="43333100-d55b-45b6-918a-2cef023bd0be" from="b09fb177-6ef2-46ed-8f94-6a6f5f47c782" to="c9f2bbfa-25f5-4861-8eee-b290f632d786">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="cf58580d-8023-4ee8-967c-020dfd784feb" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000AC5F00B283CB AS DateTime), CAST(0x0000AC6200A6D5BC AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (800, N'9e50e5db-b33c-4f42-921c-26f1a1f4cc0e', N'1', N'AndSplitAndJoin', N'AndSplitAndJoin-Code', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="9e50e5db-b33c-4f42-921c-26f1a1f4cc0e" name="AndSplitAndJoin" code="AndSplitAndJoin-Code" package="null">
			<Description></Description>
			<Activities>
				<Activity id="d853e0c4-7263-45b1-997c-a0e221da88a6" name="start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="100" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="13ead0a4-7d3c-4fc1-b36a-36be747d1b54" name="Task-001" code="task001" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="">
						<Widget left="240" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3aa2069a-206d-42d0-ad23-6d0fb5b6fef4" name="AndSplit" code="split001" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="370" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c2d1ab7f-b196-4007-ab89-f1def8af5789" name="task-010" code="task010" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="">
						<Widget left="560" top="210" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a3e2f206-949a-484e-ab75-b57a3c23b3e0" name="task-020" code="task020" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="">
						<Widget left="560" top="110" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f713fc0a-540a-45cc-85fb-815398c597bb" name="AndJoin" code="join001" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin" gatewayJoinPass="null"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="780" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="53747902-3308-4b9f-af0f-3c76863daf41" name="task-100" code="task100" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="">
						<Widget left="900" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="79df7fa3-3feb-4592-8a7d-121d3d006ffb" name="end" code="End" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1060" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="8604b6ee-fc3f-44f2-b9ba-64e5756d738f" from="d853e0c4-7263-45b1-997c-a0e221da88a6" to="13ead0a4-7d3c-4fc1-b36a-36be747d1b54">
					<Description></Description>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="null"/>
				</Transition>
				<Transition id="42874a96-ae46-4b06-a86a-6db634e89673" from="13ead0a4-7d3c-4fc1-b36a-36be747d1b54" to="3aa2069a-206d-42d0-ad23-6d0fb5b6fef4">
					<Description></Description>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="null"/>
				</Transition>
				<Transition id="ab1c59b5-ebc7-494c-94c5-d6d6a31cfaba" from="3aa2069a-206d-42d0-ad23-6d0fb5b6fef4" to="c2d1ab7f-b196-4007-ab89-f1def8af5789">
					<Description></Description>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="null"/>
				</Transition>
				<Transition id="7492359c-5326-4f3a-8c78-0a5fa494c2cb" from="3aa2069a-206d-42d0-ad23-6d0fb5b6fef4" to="a3e2f206-949a-484e-ab75-b57a3c23b3e0">
					<Description></Description>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="null"/>
				</Transition>
				<Transition id="9bef9f37-6332-432f-92cd-4be7cc355283" from="f713fc0a-540a-45cc-85fb-815398c597bb" to="53747902-3308-4b9f-af0f-3c76863daf41">
					<Description></Description>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="null"/>
				</Transition>
				<Transition id="cc7b1772-df97-4c0a-a7c1-051ff51f6bdc" from="53747902-3308-4b9f-af0f-3c76863daf41" to="79df7fa3-3feb-4592-8a7d-121d3d006ffb">
					<Description></Description>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="null"/>
				</Transition>
				<Transition id="1fe6208e-b468-40b6-8e53-72566285ade3" from="a3e2f206-949a-484e-ab75-b57a3c23b3e0" to="f713fc0a-540a-45cc-85fb-815398c597bb">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="undefined"/>
				</Transition>
				<Transition id="950da065-59d7-4d68-a0c6-a4e53c9d1c1f" from="c2d1ab7f-b196-4007-ab89-f1def8af5789" to="f713fc0a-540a-45cc-85fb-815398c597bb">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="367744a9-6cff-49f6-ac04-1d4c5acd1d58" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000AC6100D36E06 AS DateTime), CAST(0x0000AC6100D3BE3F AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (801, N'7b8f611f-6d65-4789-b3a9-1bceb132cc1c', N'1', N'OrSplitOrJoin', N'OrSplitOrJoin-Code', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="7b8f611f-6d65-4789-b3a9-1bceb132cc1c" name="OrSplitOrJoin" code="OrSplitOrJoin-Code" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="0328572e-9bc3-4a42-b12b-d16d4ad2f353" name="start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="170" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2501d1b7-a26e-4f5e-961a-885db921019c" name="Task-001" code="task001" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="">
						<Widget left="260" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4eba6820-f0e4-4048-b9d9-cf7dc634dab6" name="ApprovalOrSplit" code="split001" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="370" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="b4950a06-eef7-4d4a-b3e0-80f6554fdc58" name="task-021" code="task010" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="">
						<Widget left="530" top="230" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="aa92347e-f25a-4852-998b-11ec67ac327b" name="task-020" code="task020" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="">
						<Widget left="530" top="68" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c8d3cb4e-5001-45c3-a0a7-5995d238a119" name="OrJoin" code="join001" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="700" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="81cc78cf-ebb9-4a8b-907c-b7f0c3dacdb0" name="task-300" code="task100" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="">
						<Widget left="820" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="551479c2-8493-4e8d-9ad9-42f50b689283" name="end" code="End" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="960" top="150" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="ac78878f-08a2-4959-a78e-2edb3df53d52" from="0328572e-9bc3-4a42-b12b-d16d4ad2f353" to="2501d1b7-a26e-4f5e-961a-885db921019c">
					<Description></Description>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="null"/>
				</Transition>
				<Transition id="ac7ce020-4904-4ee0-8cd0-cba4ab086916" from="2501d1b7-a26e-4f5e-961a-885db921019c" to="4eba6820-f0e4-4048-b9d9-cf7dc634dab6">
					<Description></Description>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="null"/>
				</Transition>
				<Transition id="8bec53ff-1eb8-43cd-be9d-7e726489b8df" from="4eba6820-f0e4-4048-b9d9-cf7dc634dab6" to="b4950a06-eef7-4d4a-b3e0-80f6554fdc58">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[b=3]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours defaultBranch="false"/>
					<Receiver/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="null"/>
				</Transition>
				<Transition id="30c9f8a4-aeca-422a-a67e-5d8b0de1505a" from="4eba6820-f0e4-4048-b9d9-cf7dc634dab6" to="aa92347e-f25a-4852-998b-11ec67ac327b">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[a=2]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours defaultBranch="false"/>
					<Receiver/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="null"/>
				</Transition>
				<Transition id="d1e17eff-2cf4-4759-bee6-e0dccb4ca650" from="c8d3cb4e-5001-45c3-a0a7-5995d238a119" to="81cc78cf-ebb9-4a8b-907c-b7f0c3dacdb0">
					<Description></Description>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="null"/>
				</Transition>
				<Transition id="29073ac1-f4e6-4778-929e-11bad24dbf5d" from="81cc78cf-ebb9-4a8b-907c-b7f0c3dacdb0" to="551479c2-8493-4e8d-9ad9-42f50b689283">
					<Description></Description>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="null"/>
				</Transition>
				<Transition id="cb0d422c-4866-44c6-f705-4bc358dfa7ec" from="aa92347e-f25a-4852-998b-11ec67ac327b" to="c8d3cb4e-5001-45c3-a0a7-5995d238a119">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="undefined"/>
				</Transition>
				<Transition id="2122e8ab-d1aa-4561-de21-27ab256c5c02" from="b4950a06-eef7-4d4a-b3e0-80f6554fdc58" to="c8d3cb4e-5001-45c3-a0a7-5995d238a119">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="b236865f-ee1b-41f4-bb3a-5277e334f2e0" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000AC6100D3E05B AS DateTime), CAST(0x0000AC7A00AD1ECF AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (830, N'e1aa812d-7657-4cc8-8f53-fb619a7bca47', N'1', N'testone', N'testonecode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="1f232ca1-1547-47fd-bacb-ef6cbe8205a2" name="testone" code="testonecode" version="1"><Description></Description><Activities><Activity id="232ba246-5c38-4b1d-b584-f7022081a3e8" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="870f93bd-de76-4e9d-9fc9-fc1a5a5ecfef" name="Task-001" code="task001" url="http://www.slickflow.com"><Description /><ActivityType type="TaskNode" /><Performers><Performer /></Performers><Actions><Action type="Event" fire="Before" method="LocalService" subMethod="None" arguments="" expression="Slickflow.Module.External.OrderSubmitService" /></Actions><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="73bb2001-f6fe-4510-bcd7-ead793b3f73a" name="Task-002" code="task002" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" style=""><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="20f36481-6821-42eb-8fcd-63c5bb803585" name="Task-003" code="task003" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" style=""><Widget left="530" top="160" width="72" height="32" /></Geography></Activity><Activity id="645b0e38-961c-422b-affa-02aac95c6e91" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="740" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="a533b0de-7cf8-442a-a8c7-bab2c85f672e" from="232ba246-5c38-4b1d-b584-f7022081a3e8" to="870f93bd-de76-4e9d-9fc9-fc1a5a5ecfef"><Description></Description><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" /></Transition><Transition id="b0d9d3e3-df5c-4be9-a006-46e2055060de" from="870f93bd-de76-4e9d-9fc9-fc1a5a5ecfef" to="73bb2001-f6fe-4510-bcd7-ead793b3f73a"><Description>t-001</Description><Condition type="Expression"><ConditionText>a&gt;2</ConditionText></Condition><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" /></Transition><Transition id="2060151d-e73c-4081-a06e-0d441943705b" from="73bb2001-f6fe-4510-bcd7-ead793b3f73a" to="20f36481-6821-42eb-8fcd-63c5bb803585"><Description></Description><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" /></Transition><Transition id="af8eb4f0-b67c-4198-9c74-4fb1e3223e83" from="20f36481-6821-42eb-8fcd-63c5bb803585" to="645b0e38-961c-422b-affa-02aac95c6e91"><Description></Description><Geography parent="cc7ca2b8-e1b5-497a-96b9-67dfe9453052" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACED01508010 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (831, N'415f075d-643b-4f08-8546-1bfbca8ac563', N'1', N'Disputed', N'Disputed', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Swimlanes>
			<Swimlane title="Swimlane" type="" id="d7c549e2-d9b1-4b88-b3bd-e004fbe548f0">
				<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="swimlane;fillColor=#83027F">
					<Widget left="60" top="22" width="840" height="188"/>
				</Geography>
			</Swimlane>
			<Swimlane title="Swimlane" type="" id="730ee1d6-e18f-4e16-b1c2-e97ebcf5d504">
				<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="swimlane;fillColor=#66B922">
					<Widget left="60" top="210" width="840" height="160"/>
				</Geography>
			</Swimlane>
			<Swimlane title="Swimlane" type="" id="e315c626-5604-4fbf-f021-7896418f5a81">
				<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="swimlane;fillColor=#808913">
					<Widget left="60" top="370" width="840" height="180"/>
				</Geography>
			</Swimlane>
		</Swimlanes>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="415f075d-643b-4f08-8546-1bfbca8ac563" name="Disputed" code="Disputed" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="00efe6c1-97c9-4895-ac52-d916a84082fc" name="End" code="MM6ITJ" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="e315c626-5604-4fbf-f021-7896418f5a81" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="690" top="78" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="cdd7a91f-56a8-451d-805f-b66f5626cb9e" name="Start" code="20MNGP" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="110" top="49" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bc6d0c49-0c05-45f7-a4cd-4c162363f41d" name="Receipt of Disputed" code="MLK2YR" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="00e51686-7b1a-4450-e659-1050469af57c"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="After" method="LocalService" arguments="" expression=""/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Widget left="180" top="40" width="80" height="50"/>
					</Geography>
				</Activity>
				<Activity id="f2bf16ca-b2cb-491a-eff9-213fb972de94" name="Document Upload" code="XTEH51" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="1b77ac0e-7d01-4d2f-96b1-64cccb10c683"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Widget left="310" top="44" width="90" height="41"/>
					</Geography>
				</Activity>
				<Activity id="d1799fdd-d488-43a9-ff68-cb0cec560508" name="Document Validation" code="K2DO2I" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="00e51686-7b1a-4450-e659-1050469af57c"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Widget left="310" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="20b05abf-7fca-4758-81c6-bfd2e83d163d" name="Validate documentation Assigned lawyer" code="C5LUQS" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="00e51686-7b1a-4450-e659-1050469af57c"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Widget left="180" top="240" width="90" height="60"/>
					</Geography>
				</Activity>
				<Activity id="0add4617-37a4-4f22-d451-52c23ca97164" name="Disputed" code="43K2IZ" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="180" top="320" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7377fbd9-4b60-469f-f43c-728fb480ae91" name="Validate Documentation" code="O7XUSQ" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="00e51686-7b1a-4450-e659-1050469af57c"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Widget left="184" top="420" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="20c83493-a019-4f81-8d29-732ee5c47a81" name="Check Disputed?" code="62RWPE" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="300" top="420" width="70" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d1ac4aa3-279a-4f1e-b4ba-959d667569e1" name="Notify assignment" code="Z0H4LT" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="00e51686-7b1a-4450-e659-1050469af57c"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="Before" method="WebApi" arguments="message,email" expression="https://epx-ecm-services.azurewebsites.net/api/SendEmail?subject=Notificacion&amp;message={message}&amp;to={email}" subMethod="HttpGet"/>
						<Action type="Event" fire="After" method="WebApi" arguments="" expression="" subMethod="HttpGet"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Widget left="450" top="410" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e7be7431-d083-4e6b-a2af-f4ccdd9431ff" name="validate notification" code="021ODF" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="00e51686-7b1a-4450-e659-1050469af57c"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Widget left="450" top="510" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="10ca30ce-9112-41d9-bcd4-c1a3ac6cf687" name="Conciliation" code="AQPPNE" url="">
					<Description></Description>
					<ActivityType type="SubProcessNode" subId="79fef6a1-eebd-4cac-97c2-dccc995e20a3" subType="null" subVar="null"/>
					<Performers>
						<Performer id="00e51686-7b1a-4450-e659-1050469af57c"/>
					</Performers>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/subprocess.png">
						<Widget left="610" top="452" width="72" height="28"/>
					</Geography>
				</Activity>
				<Activity id="328d8654-2a05-48b4-fc07-0a00e3f595ab" name="Action Plan" code="MLAZ41" url="">
					<Description></Description>
					<ActivityType type="SubProcessNode" subId="fb7ef800-2d0b-4a5f-a2f1-1f4cfb64aa61" subType="null" subVar="null"/>
					<Performers>
						<Performer id="00e51686-7b1a-4450-e659-1050469af57c"/>
					</Performers>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/subprocess.png">
						<Widget left="330" top="320" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9ffe9b9c-aa3f-466a-de86-8b4b13cb391b" name="End" code="CLBJCB" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="450" top="320" width="30" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="3d034e96-c4f3-4cce-c374-190d487bc994" from="cdd7a91f-56a8-451d-805f-b66f5626cb9e" to="bc6d0c49-0c05-45f7-a4cd-4c162363f41d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="6bdf300d-25d2-4532-b543-d1e611b961d2" from="bc6d0c49-0c05-45f7-a4cd-4c162363f41d" to="f2bf16ca-b2cb-491a-eff9-213fb972de94">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="c6515e9e-bd24-4441-ae8d-6fe373e4f15e" from="f2bf16ca-b2cb-491a-eff9-213fb972de94" to="d1799fdd-d488-43a9-ff68-cb0cec560508">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Points>
							<Point x="355" y="120"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="5bbe5b8a-cac8-4a63-dd91-ae77fdd06f7a" from="d1799fdd-d488-43a9-ff68-cb0cec560508" to="20b05abf-7fca-4758-81c6-bfd2e83d163d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Points>
							<Point x="216" y="230"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="06c6b4aa-27e6-410c-d80b-7eca03dce6b1" from="20b05abf-7fca-4758-81c6-bfd2e83d163d" to="0add4617-37a4-4f22-d451-52c23ca97164">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="f173b694-6fac-458b-a34e-50d11a5a220a" from="0add4617-37a4-4f22-d451-52c23ca97164" to="7377fbd9-4b60-469f-f43c-728fb480ae91">
					<Description>Yes</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Disputed=="Validate"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="3572575d-700a-4a70-a366-0cdd119d15a2" from="20c83493-a019-4f81-8d29-732ee5c47a81" to="e7be7431-d083-4e6b-a2af-f4ccdd9431ff">
					<Description>Yes</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Check=="Check"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="fc79a785-1c9e-4dbb-c56f-27d13504f759" from="20c83493-a019-4f81-8d29-732ee5c47a81" to="d1ac4aa3-279a-4f1e-b4ba-959d667569e1">
					<Description>No</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Check=="Dont Check"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined">
						<Points/>
					</Geography>
				</Transition>
				<Transition id="48e07ef0-e917-40e8-8bdc-447009159912" from="e7be7431-d083-4e6b-a2af-f4ccdd9431ff" to="10ca30ce-9112-41d9-bcd4-c1a3ac6cf687">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="0eb33ded-8100-4a64-eb8d-2ec7dfd03bf1" from="d1ac4aa3-279a-4f1e-b4ba-959d667569e1" to="10ca30ce-9112-41d9-bcd4-c1a3ac6cf687">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="c5ac9f97-fd11-45a0-c2ba-cb64d33be8eb" from="10ca30ce-9112-41d9-bcd4-c1a3ac6cf687" to="00efe6c1-97c9-4895-ac52-d916a84082fc">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="04801b57-a4a9-4d47-b11b-a8e636d556a7" from="7377fbd9-4b60-469f-f43c-728fb480ae91" to="20c83493-a019-4f81-8d29-732ee5c47a81">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="9c14cd1d-02ba-42cd-d2be-5f17ee62dea9" from="0add4617-37a4-4f22-d451-52c23ca97164" to="328d8654-2a05-48b4-fc07-0a00e3f595ab">
					<Description>No</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Disputed=="Plan"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
				<Transition id="d0ac03f1-a7d8-411a-f0db-a9329d0777a9" from="328d8654-2a05-48b4-fc07-0a00e3f595ab" to="9ffe9b9c-aa3f-466a-de86-8b4b13cb391b">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="62a94b0b-7a19-4853-c8ca-d1f63870d34a" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000ACEF00DDC3EE AS DateTime), CAST(0x0000ACEF00DEDF74 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (832, N'79fef6a1-eebd-4cac-97c2-dccc995e20a3', N'1', N'Conciliation', N'Conciliation', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="79fef6a1-eebd-4cac-97c2-dccc995e20a3" name="Conciliation" code="Conciliation" package="null">
			<Description></Description>
			<Activities>
				<Activity id="5d2be265-f2c9-490e-f857-388c4bf90e2f" name="Request Conciliation" code="07Q88B" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="ac4f1166-772d-4008-8e6a-019932b2e18e"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Widget left="140" top="60" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f886f0f6-e76d-43fc-a65d-77decf9fb8c1" name="Receive reconciliation" code="HVA74Q" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="ac4f1166-772d-4008-8e6a-019932b2e18e"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Widget left="140" top="130" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e0cbc416-9ff1-42b0-ee0b-5bd056af5688" name="Complies with Guidelines?" code="Z8WTY8" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="140" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="167ded83-351e-4a97-d017-b16f1429884f" name="Notifications of Inappropriateness" code="30YJAY" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="ac4f1166-772d-4008-8e6a-019932b2e18e"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="Before" method="WebApi" arguments="message,email" expression="https://epx-ecm-services.azurewebsites.net/api/SendEmail?subject=Notificacion&amp;message=Se notifica como improcendente la conciliacion solicitada&amp;to=vorea@linkx.mx" subMethod="HttpGet"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Widget left="710" top="140" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5ec2896d-f105-4ca3-d92a-73a675564961" name="Notifies the lawyer" code="JIK0Z3" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="ac4f1166-772d-4008-8e6a-019932b2e18e"/>
					</Performers>
					<Actions>
						<Action type="Event" fire="Before" method="WebApi" arguments="message,email" expression="https://epx-ecm-services.azurewebsites.net/api/SendEmail?subject=Notificacion&amp;message=Se envia notificacion para su gestion en la conciliacion&amp;to=vorea@linkx.mx" subMethod="HttpGet"/>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Widget left="140" top="300" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a3d2af15-a3fd-492a-e7ea-ece521daaf34" name="Validation Conciliation" code="DJ7EAQ" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="ac4f1166-772d-4008-8e6a-019932b2e18e"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Widget left="280" top="300" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="cd80c61f-a6a0-4367-ce1f-3eed3efda45e" name="Financial" code="H434QG" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="410" top="300" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="20192103-7a15-4cb6-f3b4-21ca88f6a20f" name="New Agreement" code="B2KI1J" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="ac4f1166-772d-4008-8e6a-019932b2e18e"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Widget left="560" top="350" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bd5805b8-61ef-48f5-8142-e5e18ca402a5" name="Generate Conciliation Document" code="KOXXQP" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="ac4f1166-772d-4008-8e6a-019932b2e18e"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Widget left="560" top="249" width="72" height="51"/>
					</Geography>
				</Activity>
				<Activity id="6e7f3397-b289-43df-f3aa-2ad774fea235" name="Accept Agreement" code="44FY3A" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="700" top="350" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="809a8d8f-3012-4769-fbe8-7234c76510f9" name="End" code="OSJWQR" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="940" top="350" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ef1ec999-3e69-445d-da50-ac23e9840b47" name="End" code="3JO6UK" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="850" top="140" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="27083756-47f3-47a5-89ff-592a63121dfc" name="Start" code="7O0YHD" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="70" top="60" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7c6264a4-d634-4ba4-ce44-d23b4aa4ae4b" name="Fin" code="ZCBYLP" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="660" top="258" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4e4c1838-a71d-4c18-bc3a-2012cbe46a4f" name="Authorize Agreement" code="5J0C44" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="ac4f1166-772d-4008-8e6a-019932b2e18e"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Widget left="830" top="350" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="57175df3-beee-4f09-94f3-ac196679b3f6" from="27083756-47f3-47a5-89ff-592a63121dfc" to="5d2be265-f2c9-490e-f857-388c4bf90e2f">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="4b5cca1a-cb48-4ee7-9340-f02f59da8d61" from="5d2be265-f2c9-490e-f857-388c4bf90e2f" to="f886f0f6-e76d-43fc-a65d-77decf9fb8c1">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="b32f1ee7-ee65-472e-f8bb-f28bdb1e12d6" from="f886f0f6-e76d-43fc-a65d-77decf9fb8c1" to="e0cbc416-9ff1-42b0-ee0b-5bd056af5688">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="1ea05d43-379d-4916-d093-bb6955958fa0" from="e0cbc416-9ff1-42b0-ee0b-5bd056af5688" to="167ded83-351e-4a97-d017-b16f1429884f">
					<Description>No</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[No=="Notifications of Inappropriateness"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="353de004-c93e-434d-fb11-02a313d89420" from="e0cbc416-9ff1-42b0-ee0b-5bd056af5688" to="5ec2896d-f105-4ca3-d92a-73a675564961">
					<Description>Yes</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Yes=="Notifies the lawyer"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined">
						<Points>
							<Point x="176" y="261"/>
						</Points>
					</Geography>
				</Transition>
				<Transition id="ced5c48d-5205-4617-e8c9-85b6d8ee0b77" from="5ec2896d-f105-4ca3-d92a-73a675564961" to="a3d2af15-a3fd-492a-e7ea-ece521daaf34">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="1bd70a3f-1827-4041-da4a-f8f89c92ef22" from="a3d2af15-a3fd-492a-e7ea-ece521daaf34" to="cd80c61f-a6a0-4367-ce1f-3eed3efda45e">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="cf6212c1-61c1-4756-c94a-56670c58ce7e" from="cd80c61f-a6a0-4367-ce1f-3eed3efda45e" to="bd5805b8-61ef-48f5-8142-e5e18ca402a5">
					<Description>Yes</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Yes=="Conciliation"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="495d028b-fe34-43a7-b8ef-1354016621b3" from="cd80c61f-a6a0-4367-ce1f-3eed3efda45e" to="20192103-7a15-4cb6-f3b4-21ca88f6a20f">
					<Description>No</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[No=="New"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="410e6a60-f205-4856-fb3d-e801229b9265" from="20192103-7a15-4cb6-f3b4-21ca88f6a20f" to="6e7f3397-b289-43df-f3aa-2ad774fea235">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="57520995-a17a-406a-d429-8956339d2f9d" from="6e7f3397-b289-43df-f3aa-2ad774fea235" to="4e4c1838-a71d-4c18-bc3a-2012cbe46a4f">
					<Description>Yes</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Acepta=="Si"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="e5549900-646b-4bc1-b360-f46fc7d82497" from="6e7f3397-b289-43df-f3aa-2ad774fea235" to="167ded83-351e-4a97-d017-b16f1429884f">
					<Description>No</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[Acepta=="No"]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours/>
					<Receiver/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="2091c493-2be8-4628-db1b-415cd77f377c" from="167ded83-351e-4a97-d017-b16f1429884f" to="ef1ec999-3e69-445d-da50-ac23e9840b47">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="cdefe629-77f5-454d-fa16-7992513e1d36" from="bd5805b8-61ef-48f5-8142-e5e18ca402a5" to="7c6264a4-d634-4ba4-ce44-d23b4aa4ae4b">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
				<Transition id="f2ff944c-581f-4163-feb8-3726c14698ad" from="4e4c1838-a71d-4c18-bc3a-2012cbe46a4f" to="809a8d8f-3012-4769-fbe8-7234c76510f9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="366fafa8-8085-48c3-9169-7d0348f6c889" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000ACEF00DDCC08 AS DateTime), CAST(0x0000ACEF00DDCC08 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (834, N'02600097-4084-4d38-988f-4749bec16a2a', N'1', N'interevent', N'intereventcode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="02600097-4084-4d38-988f-4749bec16a2a" name="interevent" code="intereventcode" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="999fa7fe-440d-48be-bac6-fa9e9c7a388b" name="Start" code="4UMXAM" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="310" top="200" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3da1304b-2704-40d4-c27c-c7813098b020" name="End" code="326715" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="900" top="200" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d6bd4dda-8523-4236-e936-20760b66c02f" name="Task-01" code="N9M10B" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="undefined">
						<Widget left="450" top="200" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="7f546815-e55c-4cca-bc77-465090ff2fe0" name="InteEvent" code="G3ZDFU" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="After" method="SQL" arguments="" expression="">
							<CodeInfo>
								<![CDATA[update tmptest set title=''a1234'' where id=1]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="620" top="200" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fd14d392-323d-4dde-c504-e65990667402" name="Task-02" code="P59S6Y" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="undefined">
						<Widget left="760" top="200" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="96dc4467-84b2-4d2d-bb83-296bd979120b" from="999fa7fe-440d-48be-bac6-fa9e9c7a388b" to="d6bd4dda-8523-4236-e936-20760b66c02f">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="undefined"/>
				</Transition>
				<Transition id="afba7827-4ac1-4d91-8406-8fe889064339" from="d6bd4dda-8523-4236-e936-20760b66c02f" to="7f546815-e55c-4cca-bc77-465090ff2fe0">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="undefined"/>
				</Transition>
				<Transition id="e010ab50-a7d5-45fc-b282-d927b587624c" from="7f546815-e55c-4cca-bc77-465090ff2fe0" to="fd14d392-323d-4dde-c504-e65990667402">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="undefined"/>
				</Transition>
				<Transition id="af0372d0-a4f8-4e09-aa7f-6be3d391d58d" from="fd14d392-323d-4dde-c504-e65990667402" to="3da1304b-2704-40d4-c27c-c7813098b020">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="32e0e0ad-0eb7-4a22-9d19-09c3f9e403ce" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACF1016468EE AS DateTime), CAST(0x0000ACF1016C8F5F AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (837, N'dc957035-9ce8-4c8a-804c-86243ffbc521', N'1', N'inteventgatewaytest', N'inteventgatewaytestcode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="dc957035-9ce8-4c8a-804c-86243ffbc521" name="inteventgatewaytest" code="inteventgatewaytestcode" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="18e3821c-8bd9-4450-85ec-f12815a2f962" name="Start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="02dbb57f-3a30-433c-b220-a1c16c674266" name="Task-001" code="task001" url="http://www.slickflow.com">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="">
						<Widget left="210" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4674e2ed-d1cc-4546-adc0-edc749b8afc5" name="Set Status" code="XQ00CH" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="After" method="SQL" arguments="" expression="">
							<CodeInfo>
								<![CDATA[ 								 								update tmptest set title=''a999'' where id=1 							 							]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="370" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="453281dd-3e75-4829-916c-13a8df6bc937" name="gateway-split" code="U553XM" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="470" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="15049fc1-ccd9-4475-d5f1-8d775e326497" name="Task002" code="MFSGCY" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined">
						<Widget left="610" top="110" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="975fbad3-1c2f-4beb-bf32-0ea60a05af10" name="Task003" code="WUYYH7" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined">
						<Widget left="620" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3a77aa81-b370-43c5-d66f-f74b575a8a83" name="gateway-join" code="MVHLJ6" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin" gatewayJoinPass="null"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="750" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0c127abd-dbcc-47c6-c2ac-398479e2a134" name="Task004" code="FC14KM" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined">
						<Widget left="870" top="170" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="82773de3-58f2-415a-88f5-d4debd84393d" name="End" code="FNX97E" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1020" top="170" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e492c59c-e714-4b7a-8a4b-1634f6f1fdb9" from="18e3821c-8bd9-4450-85ec-f12815a2f962" to="02dbb57f-3a30-433c-b220-a1c16c674266">
					<Description></Description>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="null"/>
				</Transition>
				<Transition id="e3a5a22e-8c61-4cbd-9b93-4001ef9b0efc" from="02dbb57f-3a30-433c-b220-a1c16c674266" to="4674e2ed-d1cc-4546-adc0-edc749b8afc5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined"/>
				</Transition>
				<Transition id="c5d50a58-3cd5-486c-cbc8-68a59dd3f89a" from="4674e2ed-d1cc-4546-adc0-edc749b8afc5" to="453281dd-3e75-4829-916c-13a8df6bc937">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined"/>
				</Transition>
				<Transition id="a3cfa5ad-5de3-4415-c550-9303e3772362" from="453281dd-3e75-4829-916c-13a8df6bc937" to="15049fc1-ccd9-4475-d5f1-8d775e326497">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined"/>
				</Transition>
				<Transition id="fbca2afa-687e-4385-eabd-ef1f38d33e93" from="453281dd-3e75-4829-916c-13a8df6bc937" to="975fbad3-1c2f-4beb-bf32-0ea60a05af10">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined"/>
				</Transition>
				<Transition id="dc0dbff2-2067-4491-cf04-1b40a7f3076d" from="15049fc1-ccd9-4475-d5f1-8d775e326497" to="3a77aa81-b370-43c5-d66f-f74b575a8a83">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined"/>
				</Transition>
				<Transition id="1db4f329-2273-475c-b017-98d6b471030a" from="975fbad3-1c2f-4beb-bf32-0ea60a05af10" to="3a77aa81-b370-43c5-d66f-f74b575a8a83">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined"/>
				</Transition>
				<Transition id="8878a2c9-f4d0-43bf-db1e-aee4479159a1" from="3a77aa81-b370-43c5-d66f-f74b575a8a83" to="0c127abd-dbcc-47c6-c2ac-398479e2a134">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined"/>
				</Transition>
				<Transition id="e09e2527-4b42-4fde-fdce-6d2e0ee0d978" from="0c127abd-dbcc-47c6-c2ac-398479e2a134" to="82773de3-58f2-415a-88f5-d4debd84393d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="a8ca58ab-c2fa-4b39-fb9f-6185728d2135" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACF401004EC2 AS DateTime), CAST(0x0000ACF7009F17FA AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (839, N'd4e264f5-d9df-4b97-b90e-5bf68ecd2619', N'1', N'组合测试', N'111', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="d061968f-54e2-4c98-dd21-fcd891e58b66" name="帅哥专属" code="1231cxzczczc" outerId="15123855280161792"/>
		<Participant type="Role" id="dc518061-cb66-46fe-97b1-33f0736e5fbd" name="站长" code="9090909" outerId="15014794145924096"/>
	</Participants>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="d4e264f5-d9df-4b97-b90e-5bf68ecd2619" name="组合测试" code="111" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="bd7996ca-e57c-4421-d019-0af5c501ce8e" name="Start" code="XYMNFG" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="330" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="23299bfb-9b74-44dd-a5e2-c7bdfd044bb3" name="End" code="YP39PG" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="1130" top="250" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4e0dabcc-bbe9-4503-f72a-365d7195be0d" name="Task1" code="任务1" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="d061968f-54e2-4c98-dd21-fcd891e58b66"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined">
						<Widget left="430" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5ec88e3a-26f6-4aa1-98aa-6947eb6e0495" name="gateway-split" code="YGKZS9" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplitMI" gatewayJoinPass="null"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="540" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="39abe6e2-cbd3-495d-f7b3-f1371b8e61fb" name="gateway-join" code="0A0Y02" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoinMI" gatewayJoinPass="null"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="900" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2b6ca240-f4a7-4e35-ea6d-54738e3a86c5" name="Task4" code="任务四" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="dc518061-cb66-46fe-97b1-33f0736e5fbd"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined">
						<Widget left="1000" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fb9d351e-5c95-4e6b-9d57-5b7130d0c616" name="Task2" code="任务二" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="d061968f-54e2-4c98-dd21-fcd891e58b66"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined">
						<Widget left="650" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f204c326-deec-4c95-e403-c0a381281e79" name="Task3" code="任务三" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="d061968f-54e2-4c98-dd21-fcd891e58b66"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined">
						<Widget left="770" top="250" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="c814bd55-5ab1-4e24-ee4f-910a78e318d5" from="bd7996ca-e57c-4421-d019-0af5c501ce8e" to="4e0dabcc-bbe9-4503-f72a-365d7195be0d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined"/>
				</Transition>
				<Transition id="82da873a-4890-46df-df0e-8349c08e655f" from="4e0dabcc-bbe9-4503-f72a-365d7195be0d" to="5ec88e3a-26f6-4aa1-98aa-6947eb6e0495">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined"/>
				</Transition>
				<Transition id="c927b54d-38ba-4ec1-c586-e94cb2d27c3b" from="5ec88e3a-26f6-4aa1-98aa-6947eb6e0495" to="fb9d351e-5c95-4e6b-9d57-5b7130d0c616">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined"/>
				</Transition>
				<Transition id="455bb68e-2a07-45ac-de20-7b496d1691bc" from="f204c326-deec-4c95-e403-c0a381281e79" to="39abe6e2-cbd3-495d-f7b3-f1371b8e61fb">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined"/>
				</Transition>
				<Transition id="ffe41e64-eb58-46d3-aaa6-55332172389a" from="39abe6e2-cbd3-495d-f7b3-f1371b8e61fb" to="2b6ca240-f4a7-4e35-ea6d-54738e3a86c5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined"/>
				</Transition>
				<Transition id="dd3ef6a0-58e0-436d-f4d5-c001686d06f9" from="2b6ca240-f4a7-4e35-ea6d-54738e3a86c5" to="23299bfb-9b74-44dd-a5e2-c7bdfd044bb3">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined"/>
				</Transition>
				<Transition id="5b4212db-8849-4878-a6c0-3f5570b3a27d" from="fb9d351e-5c95-4e6b-9d57-5b7130d0c616" to="f204c326-deec-4c95-e403-c0a381281e79">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="7d952e59-943d-4a9d-9046-229d6b451ec7" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000ACF501151AFB AS DateTime), CAST(0x0000ACF501151B07 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (847, N'f6ae6bca-e3a7-4b85-b943-5c23d57608fb', N'1', N'etste00123', N'etwacode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="84620892-4e9f-4e93-90f7-4aeee16b32e8" name="etste00123" code="etwacode" version="1"><Description></Description><Activities><Activity id="b7afd72a-1f0b-43b8-a661-9bc3022aa6c9" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="4f684a1d-46ab-4da3-a124-89788772e751" name="Task-001" code="task001" url="http://www.slickflow.com"><Description /><ActivityType type="TaskNode" /><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="2595363a-a94f-49cb-b0fa-be2e2cc083fb" name="Task-002" code="task002" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" style=""><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="e20055a3-5273-4b9d-8807-eeb66a29b2bc" name="Task-003" code="task003" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" style=""><Widget left="530" top="160" width="72" height="32" /></Geography></Activity><Activity id="50170e65-2ddc-4c66-a3d4-bd0952e81b3d" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="740" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="733d9114-b796-430c-b904-cdf45e9bb177" from="b7afd72a-1f0b-43b8-a661-9bc3022aa6c9" to="4f684a1d-46ab-4da3-a124-89788772e751"><Description></Description><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" /></Transition><Transition id="2950600c-5715-4597-9ce5-4a98c77fc36a" from="4f684a1d-46ab-4da3-a124-89788772e751" to="2595363a-a94f-49cb-b0fa-be2e2cc083fb"><Description>t-001</Description><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" /></Transition><Transition id="46001dd1-cdce-4a90-875c-a20b591ca0db" from="2595363a-a94f-49cb-b0fa-be2e2cc083fb" to="e20055a3-5273-4b9d-8807-eeb66a29b2bc"><Description></Description><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" /></Transition><Transition id="482c8850-a32a-40a7-bc73-6a685490d205" from="e20055a3-5273-4b9d-8807-eeb66a29b2bc" to="50170e65-2ddc-4c66-a3d4-bd0952e81b3d"><Description></Description><Geography parent="0b71adb7-816f-4bbd-9539-acb0f576b032" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACF600DD3591 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (848, N'678a8235-d0de-43b0-9019-405c1b208173', N'1', N'dddd', N'ddddcode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="27dab21a-d7e1-4bed-8d6e-a1287d4fb695" name="dddd" code="ddddcode" version="1"><Description></Description><Activities><Activity id="32fba2b0-4238-4298-95d8-203b4b0d4c02" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="f4f8ab37-5d9f-4118-b3c0-d445be26641a" name="Task-001" code="task001" url="http://www.slickflow.com"><Description /><ActivityType type="TaskNode" /><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="1afd0ac4-96b8-4389-a3e8-8a8b71f34759" name="Task-002" code="task002" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" style=""><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="e783ed0e-0420-4741-bb37-6057f588a5f4" name="Task-003" code="task003" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" style=""><Widget left="530" top="160" width="72" height="32" /></Geography></Activity><Activity id="d82b7b56-c8b1-4a00-894c-3fdbae2dab21" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="740" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="0cd46dbe-c753-4f7f-8d3e-d5469831fca5" from="32fba2b0-4238-4298-95d8-203b4b0d4c02" to="f4f8ab37-5d9f-4118-b3c0-d445be26641a"><Description></Description><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" /></Transition><Transition id="0e8761c9-0a78-4015-8b15-3396ccf47bd8" from="f4f8ab37-5d9f-4118-b3c0-d445be26641a" to="1afd0ac4-96b8-4389-a3e8-8a8b71f34759"><Description>t-001</Description><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" /></Transition><Transition id="eb343ca3-26b6-4f99-8db9-d19084ba0635" from="1afd0ac4-96b8-4389-a3e8-8a8b71f34759" to="e783ed0e-0420-4741-bb37-6057f588a5f4"><Description></Description><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" /></Transition><Transition id="add621b5-6cfb-4d03-8ad4-6ad0fd89563a" from="e783ed0e-0420-4741-bb37-6057f588a5f4" to="d82b7b56-c8b1-4a00-894c-3fdbae2dab21"><Description></Description><Geography parent="3eab8401-f3b6-4f31-83e5-53c8f6ed011b" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACF600DF1CA0 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (849, N'3dcabd47-29e3-4fbb-9c08-bc5c46a9cee9', N'1', N'userdf', N'usercode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="3dcabd47-29e3-4fbb-9c08-bc5c46a9cee9" name="userdf" code="usercode" version="1"><Description></Description><Activities><Activity id="6a795e87-422f-47a1-8c4a-6f16548661da" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="ecf6a834-0622-4117-a0e3-766814e66bc1" name="Task-001" code="task001" url="http://www.slickflow.com"><Description /><ActivityType type="TaskNode" /><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="b422c22b-d327-4924-aebe-2647d240e391" name="Task-002" code="task002" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" style=""><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="503690de-01ab-425c-8d60-8709639a2dc4" name="Task-003" code="task003" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" style=""><Widget left="530" top="160" width="72" height="32" /></Geography></Activity><Activity id="ddefda05-67af-4d6c-81f3-6f48382d4f36" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="740" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="5fa4a8df-908d-4bc3-9cc2-75d450dff99b" from="6a795e87-422f-47a1-8c4a-6f16548661da" to="ecf6a834-0622-4117-a0e3-766814e66bc1"><Description></Description><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" /></Transition><Transition id="7a6430b7-0dd9-4677-b66f-2ae3a1471647" from="ecf6a834-0622-4117-a0e3-766814e66bc1" to="b422c22b-d327-4924-aebe-2647d240e391"><Description>t-001</Description><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" /></Transition><Transition id="9b7c3cfb-8196-4ed7-81bc-03283eaa7225" from="b422c22b-d327-4924-aebe-2647d240e391" to="503690de-01ab-425c-8d60-8709639a2dc4"><Description></Description><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" /></Transition><Transition id="25d6a175-d819-4cbb-bbe5-54acdfafa279" from="503690de-01ab-425c-8d60-8709639a2dc4" to="ddefda05-67af-4d6c-81f3-6f48382d4f36"><Description></Description><Geography parent="8ec022ee-4fd2-417b-9d85-642da4f33cda" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACF600E99FA3 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (850, N'950778ce-7b34-4981-8b00-71663c808733', N'1', N'mmm', N'mmmcode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="950778ce-7b34-4981-8b00-71663c808733" name="mmm" code="mmmcode" version="1"><Description></Description><Activities><Activity id="75f68807-6851-45c6-bf79-dcaeacc6ebec" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="25555846-16d6-4bce-a2a8-403b4d8b1d8d" name="Task-001" code="task001" url="http://www.slickflow.com"><Description /><ActivityType type="TaskNode" /><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="73600830-8ed1-48ff-b7d0-a969d348a10d" name="Task-002" code="task002" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" style=""><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="94952aa7-076b-4a3e-9144-dc9dc17c85d3" name="Task-003" code="task003" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" style=""><Widget left="530" top="160" width="72" height="32" /></Geography></Activity><Activity id="0549905f-f868-471f-87bd-33cc2610445d" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="740" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="4a3f3a3a-1d80-455c-bbf8-65ecb7a37dc2" from="75f68807-6851-45c6-bf79-dcaeacc6ebec" to="25555846-16d6-4bce-a2a8-403b4d8b1d8d"><Description></Description><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" /></Transition><Transition id="9969b027-b04a-43e0-be52-d7d8928264cb" from="25555846-16d6-4bce-a2a8-403b4d8b1d8d" to="73600830-8ed1-48ff-b7d0-a969d348a10d"><Description>t-001</Description><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" /></Transition><Transition id="377b8df0-c733-4fb3-9e74-b402453f6363" from="73600830-8ed1-48ff-b7d0-a969d348a10d" to="94952aa7-076b-4a3e-9144-dc9dc17c85d3"><Description></Description><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" /></Transition><Transition id="5cd75c72-07c0-43ba-b7e2-c31a1b555815" from="94952aa7-076b-4a3e-9144-dc9dc17c85d3" to="0549905f-f868-471f-87bd-33cc2610445d"><Description></Description><Geography parent="134b31aa-9e94-4216-a65e-6ea311c2c554" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACF600EA1FF0 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (851, N'0e3ddb67-16b6-4d42-98e4-2c535b687489', N'1', N'BookSellerProcess3740', N'BookSellerProcessCode3740', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="0e3ddb67-16b6-4d42-98e4-2c535b687489" name="BookSellerProcess3740" code="BookSellerProcessCode3740" version="1"><Description></Description><Activities><Activity id="0d7c28da-6b79-4fd6-994b-bd89f8ee9469" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="0663d869-70a7-438d-b133-090f6b047ac3" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="f55bc7ef-05f7-448d-9642-1959a597eac5" name="Package Books" code="003" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="0663d869-70a7-438d-b133-090f6b047ac3" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="49366b82-b108-4415-843f-3c985c8fc64c" name="Deliver Books" code="005" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="0663d869-70a7-438d-b133-090f6b047ac3" style=""><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="e43a9ae0-563c-4bdb-92b8-7d80b68d332e" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="0663d869-70a7-438d-b133-090f6b047ac3" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="580" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="ecf8d3bc-eb21-4b99-89e6-774178ad2db4" from="0d7c28da-6b79-4fd6-994b-bd89f8ee9469" to="f55bc7ef-05f7-448d-9642-1959a597eac5"><Description></Description><Geography parent="0663d869-70a7-438d-b133-090f6b047ac3" /></Transition><Transition id="792e139f-4ce6-4b01-8d33-d21624bca9bd" from="f55bc7ef-05f7-448d-9642-1959a597eac5" to="49366b82-b108-4415-843f-3c985c8fc64c"><Description></Description><Geography parent="0663d869-70a7-438d-b133-090f6b047ac3" /></Transition><Transition id="a89648e9-8ef0-43fd-9474-ec33e39e7204" from="49366b82-b108-4415-843f-3c985c8fc64c" to="e43a9ae0-563c-4bdb-92b8-7d80b68d332e"><Description></Description><Geography parent="0663d869-70a7-438d-b133-090f6b047ac3" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000ACF600EE70DB AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (852, N'cb30406d-5879-4e0e-b657-11b01814b261', N'1', N'LargeOrderProcess1259', N'LargeOrderProcessCode1259', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="cb30406d-5879-4e0e-b657-11b01814b261" name="LargeOrderProcess1259" code="LargeOrderProcessCode1259" version="1"><Description></Description><Activities><Activity id="abd2ee94-5996-4184-bf2f-3119747dbc05" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="f02f3f85-d1ba-4f09-a29d-3550713453c1" name="Large Order Received" code="001" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="709c02ee-eb51-483a-a857-33bb549f5fd1" name="AndSplit" code="AS002" url=""><Description /><ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" /><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png"><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="18fd247b-3f13-42f2-8d18-daaadc78b630" name="Engineering Review" code="003" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" style=""><Widget left="530" top="210" width="72" height="32" /></Geography></Activity><Activity id="7a09d65d-b5ad-48f6-b66f-637c82cdcb23" name="Design Review" code="005" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" style=""><Widget left="530" top="110" width="72" height="32" /></Geography></Activity><Activity id="2e927fc8-ea86-418c-8a4b-4ca6b2ee0ecc" name="AndJoin" code="AJ002" url=""><Description /><ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="AndJoin" /><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/merge.png"><Widget left="690" top="160" width="72" height="32" /></Geography></Activity><Activity id="7b0782db-caa4-4f65-9a0f-c213fbf40a5c" name="Management Approve" code="007" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" style=""><Widget left="850" top="160" width="72" height="32" /></Geography></Activity><Activity id="ed9d78a1-6f86-463a-8cac-e8d0cce019f6" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="1060" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="b2c3f63f-2d15-4e2e-817b-3805bb655d98" from="abd2ee94-5996-4184-bf2f-3119747dbc05" to="f02f3f85-d1ba-4f09-a29d-3550713453c1"><Description></Description><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" /></Transition><Transition id="a4f47fac-23e7-4ded-99d3-5466c1bd5365" from="f02f3f85-d1ba-4f09-a29d-3550713453c1" to="709c02ee-eb51-483a-a857-33bb549f5fd1"><Description></Description><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" /></Transition><Transition id="a83f577a-da21-486b-b3fd-39758e146490" from="709c02ee-eb51-483a-a857-33bb549f5fd1" to="18fd247b-3f13-42f2-8d18-daaadc78b630"><Description></Description><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" /></Transition><Transition id="6c0dd05b-8380-4c7d-9303-0412245f8b0f" from="709c02ee-eb51-483a-a857-33bb549f5fd1" to="7a09d65d-b5ad-48f6-b66f-637c82cdcb23"><Description></Description><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" /></Transition><Transition id="601d84bc-b646-4feb-889f-602bc33edf04" from="7a09d65d-b5ad-48f6-b66f-637c82cdcb23" to="2e927fc8-ea86-418c-8a4b-4ca6b2ee0ecc"><Description></Description><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" /></Transition><Transition id="b8ede450-dd53-4af4-a32b-ae8da2fdffae" from="18fd247b-3f13-42f2-8d18-daaadc78b630" to="2e927fc8-ea86-418c-8a4b-4ca6b2ee0ecc"><Description></Description><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" /></Transition><Transition id="6c2bbfdc-2b1c-4376-9279-be37bb4bb799" from="2e927fc8-ea86-418c-8a4b-4ca6b2ee0ecc" to="7b0782db-caa4-4f65-9a0f-c213fbf40a5c"><Description></Description><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" /></Transition><Transition id="11a87f8d-cc6f-46c1-b551-790bf41e0a93" from="7b0782db-caa4-4f65-9a0f-c213fbf40a5c" to="ed9d78a1-6f86-463a-8cac-e8d0cce019f6"><Description></Description><Geography parent="7677e02c-f58a-434c-8322-567c138211e3" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000ACF600EF2727 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (853, N'0bae2914-1897-44db-8158-afe2e31b2513', N'1', N'BookSellerProcess3341', N'BookSellerProcessCode3341', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants /><WorkflowProcesses><Process id="0bae2914-1897-44db-8158-afe2e31b2513" name="BookSellerProcess3341" code="BookSellerProcessCode3341" version="1"><Description></Description><Activities><Activity id="c4f2c074-202a-498a-90d3-6f65b2680cd8" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="f8553775-42fb-4d0e-80b2-e36200668e25" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="1d4affc6-beb2-4ca4-8076-2f960b1bf57d" name="Package Books" code="003" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="f8553775-42fb-4d0e-80b2-e36200668e25" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="a9303c4b-e129-4d0f-b63f-23340426826a" name="Deliver Books" code="005" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="f8553775-42fb-4d0e-80b2-e36200668e25" style=""><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="3748c9ed-6145-4729-bca2-b6f2bf0f29f9" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="f8553775-42fb-4d0e-80b2-e36200668e25" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="580" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="0e16eefe-142a-4c64-bb69-023273d5f4e4" from="c4f2c074-202a-498a-90d3-6f65b2680cd8" to="1d4affc6-beb2-4ca4-8076-2f960b1bf57d"><Description></Description><Geography parent="f8553775-42fb-4d0e-80b2-e36200668e25" /></Transition><Transition id="55f6f666-1876-4008-b064-ead1ef5472ed" from="1d4affc6-beb2-4ca4-8076-2f960b1bf57d" to="a9303c4b-e129-4d0f-b63f-23340426826a"><Description></Description><Geography parent="f8553775-42fb-4d0e-80b2-e36200668e25" /></Transition><Transition id="12a661db-20fe-45b6-a8db-ebace1b1fb09" from="a9303c4b-e129-4d0f-b63f-23340426826a" to="3748c9ed-6145-4729-bca2-b6f2bf0f29f9"><Description></Description><Geography parent="f8553775-42fb-4d0e-80b2-e36200668e25" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000ACF600EF3DAB AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (854, N'a90ea51f-6710-4c9b-925f-4f6dda5122a2', N'1', N'mitest', N'mitestcode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="a90ea51f-6710-4c9b-925f-4f6dda5122a2" name="mitest" code="mitestcode" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="92d0fe8d-7035-4182-8142-47ca486a43d3" name="Start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="80" top="150" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ba955a13-9c09-4284-a27e-40201a72eefe" name="Task-001" code="task001" url="http://www.slickflow.com">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="">
						<Widget left="210" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ca6a64db-102e-4f09-b7b1-bb526af18d40" name="Sign Together" code="MI001" url="">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Sequence" compareType="Count" completeOrder="2"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="370" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bb1256c3-e72f-435f-bc24-31f7562d3520" name="Task-003" code="task003" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="">
						<Widget left="700" top="80" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="171af023-5e40-4404-92a6-d376b0837b56" name="End" code="End" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="900" top="150" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c39998e9-ef97-4f57-93eb-9bdc3900e90a" name="gateway-split" code="7H6TOM" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="ApprovalOrSplit" gatewayJoinPass="null"/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="510" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="adffeec4-6768-4c21-cf2d-32b635051872" name="Task-002" code="LBUBWU" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="undefined">
						<Widget left="700" top="220" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="fd9cb1c7-b194-4824-9e13-fb99867ff94d" from="92d0fe8d-7035-4182-8142-47ca486a43d3" to="ba955a13-9c09-4284-a27e-40201a72eefe">
					<Description></Description>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="null"/>
				</Transition>
				<Transition id="8dfaa5bd-a0e8-4218-863f-0a87a4b93f8c" from="ba955a13-9c09-4284-a27e-40201a72eefe" to="ca6a64db-102e-4f09-b7b1-bb526af18d40">
					<Description></Description>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="null"/>
				</Transition>
				<Transition id="cbf9aeb5-a248-4f0b-be52-3c50cae0d853" from="bb1256c3-e72f-435f-bc24-31f7562d3520" to="171af023-5e40-4404-92a6-d376b0837b56">
					<Description></Description>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="null"/>
				</Transition>
				<Transition id="3f9e85ca-3f80-4478-ca9e-e7372d275176" from="ca6a64db-102e-4f09-b7b1-bb526af18d40" to="c39998e9-ef97-4f57-93eb-9bdc3900e90a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="undefined"/>
				</Transition>
				<Transition id="0c60049b-8855-446e-cc63-0bae990f866f" from="c39998e9-ef97-4f57-93eb-9bdc3900e90a" to="bb1256c3-e72f-435f-bc24-31f7562d3520">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours approval="1"/>
					<Receiver/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="undefined"/>
				</Transition>
				<Transition id="ce6c70a5-b5c0-4ce3-c410-9c1a9827a36b" from="c39998e9-ef97-4f57-93eb-9bdc3900e90a" to="adffeec4-6768-4c21-cf2d-32b635051872">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<GroupBehaviours approval="-1"/>
					<Receiver/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="undefined"/>
				</Transition>
				<Transition id="6a710088-e78d-4284-8438-267f7e714e3d" from="adffeec4-6768-4c21-cf2d-32b635051872" to="171af023-5e40-4404-92a6-d376b0837b56">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="ec9b3ac5-5bba-413c-e95a-21cff2d4f2a9" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACF600F0382E AS DateTime), CAST(0x0000ACF700B0000B AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (855, N'57dcfeea-a13e-4c1e-8b60-a7b967a52d9d', N'1', N'misequece', N'misequencecode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="57dcfeea-a13e-4c1e-8b60-a7b967a52d9d" name="misequece" code="misequencecode" package="null">
			<Description></Description>
			<Activities>
				<Activity id="4336698e-0f4e-429c-9788-d00c7cb80e87" name="Start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="95efacfc-e507-46bc-a7f6-f51f08ccbd0e" name="Task-001" code="task001" url="http://www.slickflow.com">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="">
						<Widget left="210" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3b57d932-e7a9-481e-8689-8d5d16bc002d" name="Sign Together" code="MI001" url="">
					<Description></Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Parallel" compareType="Count" completeOrder="2"/>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/multiple_instance_task.png">
						<Widget left="370" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ee504e13-105f-44d1-9794-8846fc159376" name="Task-003" code="task003" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="">
						<Widget left="530" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="65450e92-7026-44ed-97ec-c27d3fc0e053" name="End" code="End" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="740" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e8a42154-29e5-4e2b-8aca-ed4ea40b668f" from="4336698e-0f4e-429c-9788-d00c7cb80e87" to="95efacfc-e507-46bc-a7f6-f51f08ccbd0e">
					<Description></Description>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="null"/>
				</Transition>
				<Transition id="9c06f8e9-b31d-43ab-96d1-716fa5298b30" from="95efacfc-e507-46bc-a7f6-f51f08ccbd0e" to="3b57d932-e7a9-481e-8689-8d5d16bc002d">
					<Description></Description>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="null"/>
				</Transition>
				<Transition id="021ecc92-c39c-4ab5-a2dc-d0ece47930da" from="3b57d932-e7a9-481e-8689-8d5d16bc002d" to="ee504e13-105f-44d1-9794-8846fc159376">
					<Description></Description>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="null"/>
				</Transition>
				<Transition id="eaf8d4d9-d7fa-4206-bc4e-5ddb26f7f0c4" from="ee504e13-105f-44d1-9794-8846fc159376" to="65450e92-7026-44ed-97ec-c27d3fc0e053">
					<Description></Description>
					<Geography parent="d68ca1e8-9258-4092-c84f-9ca21b3d678c" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                 ', 0, NULL, N'', 0, NULL, CAST(0x0000ACF600F8EBAA AS DateTime), CAST(0x0000ACF6010531EC AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (856, N'5079c9ff-40eb-47f2-b544-a8faf48945ce', N'1', N'startgateway', N'startgatewaycode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="5079c9ff-40eb-47f2-b544-a8faf48945ce" name="startgateway" code="startgatewaycode" package="null">
			<Description></Description>
			<Activities>
				<Activity id="a7b35eca-3206-43ba-a91a-78af5188525c" name="Start" code="YJ313T" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="250" top="190" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d2d4b64d-ef70-44a0-f3a1-a0f0ac9f3688" name="gateway-split" code="R4BIQT" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="380" top="190" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c95e0dac-8308-4e34-b9ad-85f1d7c6ca8e" name="Task-01" code="YLHHL0" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="undefined">
						<Widget left="530" top="140" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="58c446e1-33cb-48d6-8e57-6284220d0309" name="Task-02" code="A5QRB5" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="undefined">
						<Widget left="530" top="260" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="457056ad-f2fe-45c6-b104-05649aa80d08" name="End" code="VGAVSH" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="710" top="190" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="90efec69-7b8a-42d8-f21f-e85c32fc5755" from="a7b35eca-3206-43ba-a91a-78af5188525c" to="d2d4b64d-ef70-44a0-f3a1-a0f0ac9f3688">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="undefined"/>
				</Transition>
				<Transition id="2682ab3b-2b69-4fd0-893b-c04c102fb2ae" from="d2d4b64d-ef70-44a0-f3a1-a0f0ac9f3688" to="c95e0dac-8308-4e34-b9ad-85f1d7c6ca8e">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="undefined"/>
				</Transition>
				<Transition id="0e35c8eb-3a37-43b9-ab3c-2412fcb9eba5" from="d2d4b64d-ef70-44a0-f3a1-a0f0ac9f3688" to="58c446e1-33cb-48d6-8e57-6284220d0309">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="undefined"/>
				</Transition>
				<Transition id="b1ebaae7-4e1a-46d1-fd24-b34efd2e4fba" from="c95e0dac-8308-4e34-b9ad-85f1d7c6ca8e" to="457056ad-f2fe-45c6-b104-05649aa80d08">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="undefined"/>
				</Transition>
				<Transition id="a857c37e-cad0-4135-9f34-8b9651f86e97" from="58c446e1-33cb-48d6-8e57-6284220d0309" to="457056ad-f2fe-45c6-b104-05649aa80d08">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="137f930e-0c58-4747-9512-ff2b39428906" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, N'', 0, NULL, CAST(0x0000ACF6011304C3 AS DateTime), CAST(0x0000ACF6013916FD AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (857, N'75BF39C8-5F4B-441F-9A08-39E0B46A9903', N'1', N'AskForLeave(WebDemo)', N'AskLeave', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="3c7aeaed-8b58-46a6-be39-7b850e6ed8e0" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="c9e054eb-7e4f-47c3-a2b9-61e0ff8748d4" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="6200799d-ffd2-4ae6-d28f-294a0cd3435a" name="总经理" code="generalmanager" outerId="8"/>
		<Participant type="Role" id="a0c8c361-87e1-4106-a7c9-c0b589123c9c" name="人事经理" code="hrmanager" outerId="3"/>
	</Participants>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="75BF39C8-5F4B-441F-9A08-39E0B46A9903" name="AskForLeave(WebDemo)" code="AskLeave" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="bb6c9787-0e1c-4de1-ddbc-593992724ca5" name="Start" code="M8EL1N" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="100" top="181" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="5eb84b81-0f04-476d-cc82-b42a65464880" name="End" code="M2C4Z0" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="860" top="185" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="3242c597-e889-4768-f6db-cafc3d675370" name="Employee Submit" code="IX8RI7" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="3c7aeaed-8b58-46a6-be39-7b850e6ed8e0"/>
					</Performers>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined">
						<Widget left="210" top="181" width="110" height="37"/>
					</Geography>
				</Activity>
				<Activity id="c437c27a-8351-4805-fd4f-4e270084320a" name="Dept Manager Approval" code="M9VKPY" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c9e054eb-7e4f-47c3-a2b9-61e0ff8748d4"/>
					</Performers>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined">
						<Widget left="380" top="181" width="107" height="37"/>
					</Geography>
				</Activity>
				<Activity id="c05bc40f-579b-49cb-cd12-30c2cba4db1e" name="Gateway" code="XNXT3O" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit" gatewayJoinPass="null"/>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="550" top="180" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="a6a8e554-d73e-4a77-8d16-08edf5905e1f" name="CEO Approval" code="JG0T8O" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6200799d-ffd2-4ae6-d28f-294a0cd3435a"/>
					</Performers>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined">
						<Widget left="700" top="110" width="80" height="47"/>
					</Geography>
				</Activity>
				<Activity id="da9f744b-3f97-40c9-c4f8-67d5a60a2485" name="HR Manager Approval" code="S6DBXK" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="a0c8c361-87e1-4106-a7c9-c0b589123c9c"/>
					</Performers>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined">
						<Widget left="700" top="260" width="90" height="40"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="7af6085c-d40e-4687-ec75-748b7ef18e3d" from="bb6c9787-0e1c-4de1-ddbc-593992724ca5" to="3242c597-e889-4768-f6db-cafc3d675370">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined"/>
				</Transition>
				<Transition id="92f5a2a2-e89e-4b3e-8ff9-6a72d3a2d946" from="3242c597-e889-4768-f6db-cafc3d675370" to="c437c27a-8351-4805-fd4f-4e270084320a">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined"/>
				</Transition>
				<Transition id="8c1922c3-6d16-452e-a9a0-0b7ba0453347" from="c437c27a-8351-4805-fd4f-4e270084320a" to="c05bc40f-579b-49cb-cd12-30c2cba4db1e">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined"/>
				</Transition>
				<Transition id="a158f3af-61b2-4169-f131-d0876c20063b" from="c05bc40f-579b-49cb-cd12-30c2cba4db1e" to="a6a8e554-d73e-4a77-8d16-08edf5905e1f">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days>3]]>
						</ConditionText>
					</Condition>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined"/>
				</Transition>
				<Transition id="2333ad8b-f958-4ca3-9e72-678d809de2ca" from="da9f744b-3f97-40c9-c4f8-67d5a60a2485" to="5eb84b81-0f04-476d-cc82-b42a65464880">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined"/>
				</Transition>
				<Transition id="efc696f7-83c4-4741-a6f5-e00f9631dda4" from="a6a8e554-d73e-4a77-8d16-08edf5905e1f" to="da9f744b-3f97-40c9-c4f8-67d5a60a2485">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined"/>
				</Transition>
				<Transition id="89c490d0-7a4f-4465-fb4f-0e6914ad703c" from="c05bc40f-579b-49cb-cd12-30c2cba4db1e" to="da9f744b-3f97-40c9-c4f8-67d5a60a2485">
					<Description></Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days<=3]]>
						</ConditionText>
					</Condition>
					<Geography parent="80939e40-7aa5-45d4-b798-4d8d6150fd1f" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000ACFE010986A0 AS DateTime), CAST(0x0000ACFE010AD473 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (859, N'2b027b97-a0d2-4ebb-9435-f46f34a69f79', N'1', N'项目预验收', N'项目预验收', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="utf-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="2b027b97-a0d2-4ebb-9435-f46f34a69f79" name="项目预验收" code="项目预验收" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="9cc82c36-db0c-4d6f-a661-6720978532f9" name="开始" code="N1QGDL" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="250" top="252" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c463caab-7b69-49de-a633-5ad90879d18e" name="结束" code="FH08UG" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="130" top="726" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="53e38984-e16c-4955-9f31-bc1121b22773" name="承包商发起" code="ECSTD2" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="After" method="SQL" arguments="KeyId" expression="">
							<CodeInfo>
								<![CDATA[ 								 								 								 								 								UPDATE dbo.CahPreliminaryAcceptances SET Status = 2 WHERE Id = @KeyId 							 							 							 							 							]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="376" top="252" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e7d1e8c4-7180-425f-9c8d-00e6cfd76454" name="区域经理" code="NUSM8B" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Actions>
						<Action type="Event" fire="After" method="SQL" arguments="KeyId" expression="">
							<CodeInfo>
								<![CDATA[ 								 								 								 								 								UPDATE dbo.CahPreliminaryAcceptances SET Status = 6 WHERE Id = @KeyId 							 							 							 							 							]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="602" top="733" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e0221cbc-8bba-4e69-a328-e875b0799eb8" name="监理审批-动力" code="ZO5CH4" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="200" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d99f85fc-16b6-4e36-83c1-9f254b781dea" name="监理审批开始" code="4G5OY8" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="530" top="252" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4c70bfc0-dd04-4f97-bff3-64428075da47" name="监理审批-装修" code="L1QKMM" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="43be7f9c-45de-453b-f092-973d866724e9" name="监理审批结束" code="WNRDV3" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="900" top="252" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6220d4f5-4d09-4c44-b534-2ac9ece967c3" name="监理审批-电气" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fac15cdb-51c5-4468-b115-8af06e266763" name="管理公司审批-总图" code="554X82" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="40" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" name="管理公司审批开始" code="7E1CL3" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1106" top="252" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298" name="管理公司审批结束" code="2TPTXZ" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="1546" top="252" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="25180f2d-c6f2-4522-d293-8dd9446fc23e" name="管理公司审批-建筑" code="UWZ9JN" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="80" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4116b66d-0c7e-4dfe-9ccb-d3c97dc53d90" name="管理公司审批-结构" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="120" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c177ee09-d3a8-488b-e336-eb78c893ee3f" name="业主-总图" code="7JTI25" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="440" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4132a658-d4ac-4535-afb3-590447d4e125" name="业主开始审批" code="70YLBV" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="1240" top="733" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="67f74b68-5e55-4751-ebef-8478ecd45a08" name="业主结束审批" code="Z47OSU" url="null">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin" gatewayJoinPass="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="810" top="733" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e28b7ef3-9d35-4906-98ec-9a688f39209c" name="业主-建筑" code="UISPJV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="480" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="660b105b-435d-45ae-de9b-de9343e2c060" name="业主-结构" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="520" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e1e760dd-e30f-43e0-c2e1-5e8332df8b34" name="监理审批-暖通" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="280" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="effb01ac-4072-4beb-ef8d-cef7b7440b7d" name="监理审批-给排水" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="320" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0a8fd69d-402d-4cb3-a69e-8682915866bf" name="监理审批-IT" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="360" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2df16518-8472-4eaf-c881-992337102661" name="监理审批-消防" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="400" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="68bd5813-6304-483b-cb4c-e41e6b8b6860" name="监理审批-弱电" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="440" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2ef9fea0-0ebb-40b0-d251-226f60b3f3dc" name="监理审批-BAS" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="480" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a8966d9e-e72c-4fa1-d844-aaa1132dc710" name="监理审批-环保" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="520" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="117fb2ba-d07e-4efa-92da-3f089d29bc35" name="监理审批-绿化" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="560" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ad761ccf-9b25-46f5-8986-1a6243ef37bb" name="监理审批-保洁" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="600" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4fbb3e6b-f48f-497e-8b1a-26510964e2a1" name="监理审批-结构" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="120" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2322ef0b-a8be-4cbb-de7c-579b6b363fb5" name="监理审批-建筑" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="80" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="913d2152-57cb-4799-ca3e-f20db60b639c" name="监理审批-总图" code="5ACCP6" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="700" top="40" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9d294237-be63-45b9-f860-3116af9db555" name="管理公司审批-装修" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f841c748-6251-49fc-9068-c8c3ca9f0b2c" name="管理公司审批-给排水" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="320" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="34114343-5a1a-46f0-ae8d-bbc1cd421c49" name="管理公司审批-IT" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="360" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5ce59fe1-abe6-4fd7-f527-c8c282c43158" name="管理公司审批-消防" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="400" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3c44a09b-86a3-4eed-9aaa-145e3a87c102" name="管理公司审批-弱电" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="440" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4fe991a8-612f-43aa-f794-f8a31f6efdd9" name="管理公司审批-BAS" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="480" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="33c1d131-eb16-4a98-db60-b37f31658731" name="管理公司审批-环保" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="520" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a3278c36-c99c-4c68-a406-71f94ffb549e" name="管理公司审批-电气" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="98eaa29c-a79f-4d32-bff1-840c381ee2b5" name="管理公司审批-绿化" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="560" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="171933f8-4b19-42f0-a383-b85d71883231" name="管理公司审批-保洁" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="600" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e54a604c-5d21-4fee-f764-bd0a4a3f9bd4" name="管理公司审批-暖通" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="280" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="349ecf60-4635-4b44-c558-c5c29ab9fdcb" name="管理公司审批-动力" code="BSTYGJ" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1296" top="200" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e8ef736c-330e-4003-dca9-1765b99ae111" name="业主-装修" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="560" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8c49efa4-3a61-4168-e031-30603ba78b71" name="业主-动力" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="602" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="619f9cea-469f-4ef7-d679-f3388a1296d6" name="业主-电气" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="642" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c8eaff25-a1a2-405f-db33-b24ff3f473dc" name="业主-暖通" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="682" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="41855335-9090-4472-ed6c-0a42c1eb481e" name="业主-给排水" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="722" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3c475789-98d6-446e-8185-456cdb7a2941" name="业主-IT" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="760" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6d993e8e-9b24-4cf1-b238-ee1d56e5df96" name="业主-消防" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="802" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1fd75a05-b2cb-42ba-adf9-312a6745b654" name="业主-弱电" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="842" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f344fcfd-f5ce-4503-feac-f36fb4d77d56" name="业主-BAS" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="882" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="6418c23d-334f-4a87-f5ce-bd778ca9a03c" name="业主-环保" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="922" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="e4269676-2a28-4e96-f526-d2fa18db5657" name="业主-绿化" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="962" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="1a064b64-1437-4445-cd6c-20cf90aeadf1" name="业主-保洁" code="4L0HNV" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Widget left="1010" top="1002" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3a01ceba-194f-4686-8c5f-94fdfdef0b32" name="InteEvent" code="TB7H8R" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="After" method="SQL" arguments="KeyId" expression="">
							<CodeInfo>
								<![CDATA[ 								 								 								 								 								 								 								UPDATE dbo.CahPreliminaryAcceptances SET Status = 3 WHERE Id = @KeyId 							 							 							 							 							 							 							]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="1030" top="252" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="3127beb2-0d17-4ead-8c7f-44c27add5c6a" name="InteEvent" code="IETCPZ" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="After" method="SQL" arguments="KeyId" expression="">
							<CodeInfo>
								<![CDATA[ 								 								 								 								 								 								 								UPDATE dbo.CahPreliminaryAcceptances SET Status = 4 WHERE Id = @KeyId 							 							 							 							 							 							 							]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="1646" top="564" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="eec06a43-bda6-48d6-966e-a4cc138b99ba" name="InteEvent" code="P201VJ" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="None" expression="null" messageDirection="null"/>
					<Actions>
						<Action type="Event" fire="After" method="SQL" arguments="KeyId" expression="">
							<CodeInfo>
								<![CDATA[ 								 								 								 								 								 								 								UPDATE dbo.CahPreliminaryAcceptances SET Status = 5 WHERE Id = @KeyId 							 							 							 							 							 							 							]]>
							</CodeInfo>
						</Action>
					</Actions>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_intermediate.png">
						<Widget left="740" top="732" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="bfbc7a30-e6e0-4c70-814e-e00f25cc3410" name="是否合格" code="ATP8C4" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="XOrSplit" gatewayJoinPass="null"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="350" top="726" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="a73e9d0a-ece6-4699-b0f5-1faf3ac63077" from="9cc82c36-db0c-4d6f-a661-6720978532f9" to="53e38984-e16c-4955-9f31-bc1121b22773">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1c7aee89-973f-4e2a-a98b-3a3f9c459636" from="e0221cbc-8bba-4e69-a328-e875b0799eb8" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="5ed3e5c4-9991-4013-dc7d-769815fe0839" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="4c70bfc0-dd04-4f97-bff3-64428075da47">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="8fb77b64-2f3f-48fd-c7cf-dd23e669d720" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="e0221cbc-8bba-4e69-a328-e875b0799eb8">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="41808042-751b-4761-c1e6-cd76ee1ac3c1" from="4c70bfc0-dd04-4f97-bff3-64428075da47" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="ce96e79d-372b-4125-a7eb-524b3c4c9082" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="6220d4f5-4d09-4c44-b534-2ac9ece967c3">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="4399cc75-6a37-4ec0-829e-83e86ca8bcb0" from="6220d4f5-4d09-4c44-b534-2ac9ece967c3" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="70e9751b-0af5-445e-935b-447c4d55fd3c" from="fac15cdb-51c5-4468-b115-8af06e266763" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="95f299b0-d5cc-4fa0-89eb-918f6e65cb2d" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="fac15cdb-51c5-4468-b115-8af06e266763">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1e453f37-fe07-44ec-beae-808cf7c55d9b" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="25180f2d-c6f2-4522-d293-8dd9446fc23e">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="9384b405-9f52-4d62-8150-5e0acaf339e1" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="4116b66d-0c7e-4dfe-9ccb-d3c97dc53d90">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="ea8a754c-76c0-44a3-85f6-3c511e0c4052" from="25180f2d-c6f2-4522-d293-8dd9446fc23e" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="0fd49123-40fc-4452-fe06-156ab5e1b4e9" from="4116b66d-0c7e-4dfe-9ccb-d3c97dc53d90" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="9d9f85cb-9970-4498-b53d-e6298bcef475" from="4132a658-d4ac-4535-afb3-590447d4e125" to="c177ee09-d3a8-488b-e336-eb78c893ee3f">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="bb1661aa-3342-4c17-c0ed-6c3d4a5a4c65" from="c177ee09-d3a8-488b-e336-eb78c893ee3f" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1d0747ef-9dd4-4c22-b4f6-87fcd557b2d2" from="4132a658-d4ac-4535-afb3-590447d4e125" to="e28b7ef3-9d35-4906-98ec-9a688f39209c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="a8a05b3f-0853-40f0-83d5-34cab838c45b" from="4132a658-d4ac-4535-afb3-590447d4e125" to="660b105b-435d-45ae-de9b-de9343e2c060">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="b72c00bf-39de-4e5c-b856-7ad43140542f" from="e28b7ef3-9d35-4906-98ec-9a688f39209c" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="44295d1c-95e2-44e4-ca99-332c6c854fc6" from="660b105b-435d-45ae-de9b-de9343e2c060" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="fce7136c-8c83-4334-87bc-91fad3b38617" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="913d2152-57cb-4799-ca3e-f20db60b639c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="338b8ac9-8358-4b5f-e1a8-dea84d3325cb" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="2322ef0b-a8be-4cbb-de7c-579b6b363fb5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="0efa00a2-8bb1-429d-a41e-56bfc53dbfb3" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="4fbb3e6b-f48f-497e-8b1a-26510964e2a1">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="f57a8ab1-474f-4934-85c0-7a7d23cf9c20" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="e1e760dd-e30f-43e0-c2e1-5e8332df8b34">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="f95e6b5f-6a58-4656-96a9-83c766e5a7ce" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="effb01ac-4072-4beb-ef8d-cef7b7440b7d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="ed9b6fc8-c0ff-49f9-ebac-3633739dbe69" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="0a8fd69d-402d-4cb3-a69e-8682915866bf">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="16c121ee-3b7d-4afe-ab48-725e62b1bf09" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="2df16518-8472-4eaf-c881-992337102661">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="c1e5601e-de1c-4a0a-87aa-05d4aa4211b5" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="68bd5813-6304-483b-cb4c-e41e6b8b6860">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="3a4d18cd-1e05-4ed0-c147-5fd0151749a3" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="2ef9fea0-0ebb-40b0-d251-226f60b3f3dc">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="5e20715c-3f51-4c70-bd5f-8814b614d625" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="a8966d9e-e72c-4fa1-d844-aaa1132dc710">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="0cc09d44-e671-48fa-f1f5-84126ce6d171" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="ad761ccf-9b25-46f5-8986-1a6243ef37bb">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="067d7700-2eef-4efd-caf6-5c12c92dc855" from="d99f85fc-16b6-4e36-83c1-9f254b781dea" to="117fb2ba-d07e-4efa-92da-3f089d29bc35">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="69381f90-95fb-4085-e990-009a5836cc3e" from="913d2152-57cb-4799-ca3e-f20db60b639c" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1300e2e3-e9e3-43d2-d0ac-8a19289320a8" from="2322ef0b-a8be-4cbb-de7c-579b6b363fb5" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="aab2b205-4acb-492e-eff5-ad3d9a05e1c3" from="4fbb3e6b-f48f-497e-8b1a-26510964e2a1" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="9fd815e0-d454-444a-fe3e-2fb47fc72ff5" from="e1e760dd-e30f-43e0-c2e1-5e8332df8b34" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="a6222e7f-c321-469c-b614-9163463a8e97" from="effb01ac-4072-4beb-ef8d-cef7b7440b7d" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="4f6d792e-1fed-4154-fe8a-37b09c276e55" from="0a8fd69d-402d-4cb3-a69e-8682915866bf" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="ffcbbc0c-cec4-42a6-bcb7-226bcbf88fb6" from="2df16518-8472-4eaf-c881-992337102661" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="520b0211-4330-415f-f13d-db1c3becad08" from="68bd5813-6304-483b-cb4c-e41e6b8b6860" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="ab4de67c-d05b-4457-9f09-84c8c9ce90ff" from="2ef9fea0-0ebb-40b0-d251-226f60b3f3dc" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="70033a61-2ed9-4339-af1b-902e83e934d2" from="a8966d9e-e72c-4fa1-d844-aaa1132dc710" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="578ce0c2-d648-4836-c2a3-67b880b7f36b" from="117fb2ba-d07e-4efa-92da-3f089d29bc35" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="2fb9a8cd-abca-42dd-fdc9-f61a7c1ed930" from="ad761ccf-9b25-46f5-8986-1a6243ef37bb" to="43be7f9c-45de-453b-f092-973d866724e9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="9019e3ed-a506-4927-96a2-2a793fe21570" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="9d294237-be63-45b9-f860-3116af9db555">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="c77b5c2d-36a7-4c59-8ead-8e3a3feb881d" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="349ecf60-4635-4b44-c558-c5c29ab9fdcb">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="bcfb654d-23dd-4250-a7f6-3de5ac5fd60f" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="e54a604c-5d21-4fee-f764-bd0a4a3f9bd4">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="ea277c50-0c5a-4c60-a460-4a8ca75afbd9" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="f841c748-6251-49fc-9068-c8c3ca9f0b2c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1ec5dcfb-fbd6-486f-96e9-77ee644d11bc" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="34114343-5a1a-46f0-ae8d-bbc1cd421c49">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="cec530a8-cf35-4ce9-d2cc-ff0850085fe7" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="5ce59fe1-abe6-4fd7-f527-c8c282c43158">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1f2a133e-059f-420f-fcff-693d162cf8da" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="3c44a09b-86a3-4eed-9aaa-145e3a87c102">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="8b5b5df2-30f8-4e9a-891b-4696fd2837d1" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="4fe991a8-612f-43aa-f794-f8a31f6efdd9">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="238f99f3-70f8-4a9a-9673-402366eae0b8" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="33c1d131-eb16-4a98-db60-b37f31658731">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1205ba2f-e19d-42aa-b9ae-18a0bf929f0f" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="a3278c36-c99c-4c68-a406-71f94ffb549e">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="40df5a6b-03de-40e2-a91f-9c8f4badd142" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="98eaa29c-a79f-4d32-bff1-840c381ee2b5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="0c2afc46-6739-424c-ba40-020ea1239206" from="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5" to="171933f8-4b19-42f0-a383-b85d71883231">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="a70e6efe-9707-4027-c130-79069e75d6b7" from="9d294237-be63-45b9-f860-3116af9db555" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="dcb6b67a-6e17-4304-aff5-ef24b0928f72" from="349ecf60-4635-4b44-c558-c5c29ab9fdcb" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="afd3f04e-9ea9-4cff-e472-19ded1c84783" from="e54a604c-5d21-4fee-f764-bd0a4a3f9bd4" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="b0dbbaab-7405-46c0-bb25-89a3a41f888d" from="f841c748-6251-49fc-9068-c8c3ca9f0b2c" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="ecd0e0b4-7c08-4723-91b1-932bcae9b11d" from="34114343-5a1a-46f0-ae8d-bbc1cd421c49" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1d81360a-d452-4edc-f7d0-77c96b313a2e" from="5ce59fe1-abe6-4fd7-f527-c8c282c43158" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="553d65f2-9eb5-475a-c764-25909999b999" from="3c44a09b-86a3-4eed-9aaa-145e3a87c102" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="7696b9a0-2603-43a3-c601-2c84265086db" from="4fe991a8-612f-43aa-f794-f8a31f6efdd9" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="bf577ef3-d539-4eab-f9fa-074adbc799e2" from="33c1d131-eb16-4a98-db60-b37f31658731" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="d9fa9171-f808-485a-b390-28b925123ea8" from="a3278c36-c99c-4c68-a406-71f94ffb549e" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="324fa816-7253-4302-b798-48d487fd0ceb" from="98eaa29c-a79f-4d32-bff1-840c381ee2b5" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="6dae1fff-6fdb-41ac-9616-f8f8d5fd73e2" from="171933f8-4b19-42f0-a383-b85d71883231" to="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="28d68ab0-4896-4f9d-8e52-b7ff1551b68d" from="4132a658-d4ac-4535-afb3-590447d4e125" to="e8ef736c-330e-4003-dca9-1765b99ae111">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="c03f5c2e-4857-4556-8bb4-754fc013c256" from="4132a658-d4ac-4535-afb3-590447d4e125" to="8c49efa4-3a61-4168-e031-30603ba78b71">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="74dc8ad3-7922-4c92-bd19-e570903cb9b3" from="4132a658-d4ac-4535-afb3-590447d4e125" to="619f9cea-469f-4ef7-d679-f3388a1296d6">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="29a787d4-499f-41c1-c310-308c9ed0b2cb" from="4132a658-d4ac-4535-afb3-590447d4e125" to="c8eaff25-a1a2-405f-db33-b24ff3f473dc">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="d6ba21a3-5ec6-4263-ab38-d89a4b5f6b2e" from="4132a658-d4ac-4535-afb3-590447d4e125" to="41855335-9090-4472-ed6c-0a42c1eb481e">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="a5341139-096f-4d67-8123-4d56a30bacdf" from="4132a658-d4ac-4535-afb3-590447d4e125" to="3c475789-98d6-446e-8185-456cdb7a2941">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="46b9d7d1-9498-429b-942e-c64756062f5b" from="4132a658-d4ac-4535-afb3-590447d4e125" to="6d993e8e-9b24-4cf1-b238-ee1d56e5df96">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="25fc5a69-8277-4b1c-e81a-2c937fe8a762" from="4132a658-d4ac-4535-afb3-590447d4e125" to="1fd75a05-b2cb-42ba-adf9-312a6745b654">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="57e08106-572b-4810-f402-9566a6023625" from="4132a658-d4ac-4535-afb3-590447d4e125" to="f344fcfd-f5ce-4503-feac-f36fb4d77d56">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="999ed835-db85-42d9-f76c-2f84983fd839" from="4132a658-d4ac-4535-afb3-590447d4e125" to="6418c23d-334f-4a87-f5ce-bd778ca9a03c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="4fbd4d18-444e-494b-db7e-6050b4279a3d" from="4132a658-d4ac-4535-afb3-590447d4e125" to="e4269676-2a28-4e96-f526-d2fa18db5657">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="31812771-b736-4fb1-a92c-83236b09c18e" from="4132a658-d4ac-4535-afb3-590447d4e125" to="1a064b64-1437-4445-cd6c-20cf90aeadf1">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="fce62e1c-ad75-4ddb-ecb0-613e43cc57f3" from="e8ef736c-330e-4003-dca9-1765b99ae111" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="55ac4390-c627-4b2b-da91-0a05486cc9d2" from="8c49efa4-3a61-4168-e031-30603ba78b71" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="fcafd159-6fe0-4a22-8961-64e9be3a9c53" from="619f9cea-469f-4ef7-d679-f3388a1296d6" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="97650f5a-d54e-4e61-ae78-9c345a164e30" from="c8eaff25-a1a2-405f-db33-b24ff3f473dc" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="02128e35-45a5-4185-a199-22791d0f3e9a" from="41855335-9090-4472-ed6c-0a42c1eb481e" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="8a5956c4-7492-4981-b0cf-b6b45f082b18" from="3c475789-98d6-446e-8185-456cdb7a2941" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="5a6ca4ed-dc7c-436d-c86c-2dce636b4a3d" from="6d993e8e-9b24-4cf1-b238-ee1d56e5df96" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="36edc7d8-07e9-4cb3-a531-81d2e1e5b097" from="1fd75a05-b2cb-42ba-adf9-312a6745b654" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="9e612731-8d63-4190-91b7-4baba4b7bf49" from="f344fcfd-f5ce-4503-feac-f36fb4d77d56" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="a953d03e-dc60-476f-e337-d05eea89908b" from="6418c23d-334f-4a87-f5ce-bd778ca9a03c" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="627b7d2a-5117-410f-8ee4-639149982bef" from="e4269676-2a28-4e96-f526-d2fa18db5657" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="6adb2e4d-126d-46c0-d99b-ed158aab87e4" from="1a064b64-1437-4445-cd6c-20cf90aeadf1" to="67f74b68-5e55-4751-ebef-8478ecd45a08">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="bb2bb755-e5b6-4e1b-8743-fc8d015e2e58" from="3a01ceba-194f-4686-8c5f-94fdfdef0b32" to="a7ad9855-b52d-485c-e3f0-38c77bbcfbe5">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="a0b498a8-aa68-440e-a7e5-1bd3f06c873f" from="3127beb2-0d17-4ead-8c7f-44c27add5c6a" to="4132a658-d4ac-4535-afb3-590447d4e125">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Points/>
					</Geography>
				</Transition>
				<Transition id="6299539b-a242-4e20-940c-bad9422f56dc" from="eec06a43-bda6-48d6-966e-a4cc138b99ba" to="e7d1e8c4-7180-425f-9c8d-00e6cfd76454">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="1ffcd39d-8b2b-4ee4-9343-11fb492e20b7" from="43be7f9c-45de-453b-f092-973d866724e9" to="3a01ceba-194f-4686-8c5f-94fdfdef0b32">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="8da8749a-a62f-4056-8b75-4a78cdb5fe35" from="9be0c6d7-aac0-4c27-cb0a-b44d2daa1298" to="3127beb2-0d17-4ead-8c7f-44c27add5c6a">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined">
						<Points/>
					</Geography>
				</Transition>
				<Transition id="5e813d04-4164-48d6-ba68-eea693058a7f" from="67f74b68-5e55-4751-ebef-8478ecd45a08" to="eec06a43-bda6-48d6-966e-a4cc138b99ba">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="30da64f3-43c5-4f7d-f33b-9d8862a61a72" from="53e38984-e16c-4955-9f31-bc1121b22773" to="d99f85fc-16b6-4e36-83c1-9f254b781dea">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="b4a73de0-9025-4d88-d0bb-67011edbf48e" from="e7d1e8c4-7180-425f-9c8d-00e6cfd76454" to="bfbc7a30-e6e0-4c70-814e-e00f25cc3410">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="97b34544-7216-4b69-da54-9733802c3695" from="bfbc7a30-e6e0-4c70-814e-e00f25cc3410" to="c463caab-7b69-49de-a633-5ad90879d18e">
					<Description>是</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[isOk=1]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours priority="0"/>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
				<Transition id="94e89558-0df7-402e-b359-18e063c1f542" from="bfbc7a30-e6e0-4c70-814e-e00f25cc3410" to="53e38984-e16c-4955-9f31-bc1121b22773">
					<Description>否</Description>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[isOk=0]]>
						</ConditionText>
					</Condition>
					<GroupBehaviours priority="-1"/>
					<Receiver/>
					<Geography parent="d155a4d9-2f4d-43ce-c323-7fa265d7a85a" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AD05010053F4 AS DateTime), CAST(0x0000AD05010053FA AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (867, N'feec81b2-8eeb-4702-8fb4-68cbfb15b9ff', N'1', N'BookSellerProcess8056', N'BookSellerProcessCode8056', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="utf-8"?><Package><Participants><Participant type="Role" id="22fd046a-62f3-44e7-a8de-3134a8e08d1f" name="testrole" code="testrole" outerId="21" /></Participants><WorkflowProcesses><Process id="feec81b2-8eeb-4702-8fb4-68cbfb15b9ff" name="BookSellerProcess8056" code="BookSellerProcessCode8056" version="1"><Description></Description><Activities><Activity id="68ee75b3-57ab-465a-aee6-c5e79622d0e0" name="Start" code="Start" url=""><Description /><ActivityType type="StartNode" /><Geography parent="1c734982-1ef9-4a3f-bc08-0127b2aa68fd" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png"><Widget left="50" top="160" width="32" height="32" /></Geography></Activity><Activity id="ecb9568c-8a00-422f-b03d-279c5678c733" name="Task-001" code="9K37CG" url=""><Description /><ActivityType type="TaskNode" /><Performers><Performer id="22fd046a-62f3-44e7-a8de-3134a8e08d1f" /></Performers><Geography parent="1c734982-1ef9-4a3f-bc08-0127b2aa68fd" style=""><Widget left="210" top="160" width="72" height="32" /></Geography></Activity><Activity id="2d45de1b-829d-43dd-bf48-c695016998a2" name="Deliver Books" code="005" url=""><Description /><ActivityType type="TaskNode" /><Geography parent="1c734982-1ef9-4a3f-bc08-0127b2aa68fd" style=""><Widget left="370" top="160" width="72" height="32" /></Geography></Activity><Activity id="0fca2066-528a-4b31-9da7-c599566a060d" name="End" code="End" url=""><Description /><ActivityType type="EndNode" /><Geography parent="1c734982-1ef9-4a3f-bc08-0127b2aa68fd" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png"><Widget left="580" top="160" width="32" height="32" /></Geography></Activity></Activities><Transitions><Transition id="89db0016-8127-45a2-bb69-7dad978d4a1a" from="68ee75b3-57ab-465a-aee6-c5e79622d0e0" to="ecb9568c-8a00-422f-b03d-279c5678c733"><Description></Description><Geography parent="1c734982-1ef9-4a3f-bc08-0127b2aa68fd" /></Transition><Transition id="c324f4fb-bb13-49eb-b386-9231ee8afcb8" from="ecb9568c-8a00-422f-b03d-279c5678c733" to="2d45de1b-829d-43dd-bf48-c695016998a2"><Description></Description><Geography parent="1c734982-1ef9-4a3f-bc08-0127b2aa68fd" /></Transition><Transition id="1e70a20f-fc79-4695-a465-6e87c2da66fd" from="2d45de1b-829d-43dd-bf48-c695016998a2" to="0fca2066-528a-4b31-9da7-c599566a060d"><Description></Description><Geography parent="1c734982-1ef9-4a3f-bc08-0127b2aa68fd" /></Transition></Transitions></Process></WorkflowProcesses></Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AD0F00AD4F26 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (868, N'11f42989-a73b-4f58-bbe1-6d02843440e9', N'1', N'项目提请联合验收', N'项目提请联合验收', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="f8727908-e5d6-4bec-8ffc-b43b9941d9d1" name="进度员" code="1" outerId="23"/>
		<Participant type="Role" id="664ea588-2590-4a1c-a560-4f1321f2c42f" name="能源与设施管理部协调专员" code="D0C79F0C-B31A-4B20-9AE4-C9C7DBFF9AE9" outerId="24"/>
	</Participants>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="11f42989-a73b-4f58-bbe1-6d02843440e9" name="项目提请联合验收" code="项目提请联合验收" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="dac219ff-2306-4151-d711-3f1558b6a471" name="Start" code="SU568E" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="250" top="150" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8b401a83-7c05-4424-da1e-35403b74a850" name="进度员发起" code="GFUCCA" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="f8727908-e5d6-4bec-8ffc-b43b9941d9d1"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined">
						<Widget left="350" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5ecfc3d2-0b45-4153-a935-32508577c1ab" name="能源与设施管理部协调专员" code="4HDA59" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="664ea588-2590-4a1c-a560-4f1321f2c42f"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined">
						<Widget left="630" top="190" width="180" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a07dce72-6924-4a46-c3c7-26e0d890b143" name="能源与设施管理部供应商工程师" code="QGR82F" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined">
						<Widget left="630" top="110" width="180" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2617003b-9db7-4f32-f8c4-8043b10f625c" name="能源与设施管理部专业工程师" code="9EQ22T" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined">
						<Widget left="630" top="150" width="180" height="32"/>
					</Geography>
				</Activity>
				<Activity id="59e10ec1-c202-47d0-f299-750609096e16" name="gateway-split" code="F4S2RO" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="470" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8734c6be-6624-48d3-d63d-bdf4b9fb7218" name="End" code="USVHVA" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="920" top="190" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="94fcc8bf-571b-475b-9b32-54faf2e83bb9" from="dac219ff-2306-4151-d711-3f1558b6a471" to="8b401a83-7c05-4424-da1e-35403b74a850">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined"/>
				</Transition>
				<Transition id="e60edba2-d234-4527-e61b-3b3fa2d6106e" from="8b401a83-7c05-4424-da1e-35403b74a850" to="59e10ec1-c202-47d0-f299-750609096e16">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined"/>
				</Transition>
				<Transition id="21af1df5-d5dc-4c5d-f437-26334a9994a0" from="59e10ec1-c202-47d0-f299-750609096e16" to="a07dce72-6924-4a46-c3c7-26e0d890b143">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined"/>
				</Transition>
				<Transition id="f7e096bc-026d-43da-f545-85fc4b56eff5" from="59e10ec1-c202-47d0-f299-750609096e16" to="2617003b-9db7-4f32-f8c4-8043b10f625c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined"/>
				</Transition>
				<Transition id="be97ffbf-1186-4527-bb8f-45406d8294b5" from="59e10ec1-c202-47d0-f299-750609096e16" to="5ecfc3d2-0b45-4153-a935-32508577c1ab">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined"/>
				</Transition>
				<Transition id="08f93ee3-3abc-48f6-8830-5558847a96f6" from="5ecfc3d2-0b45-4153-a935-32508577c1ab" to="8734c6be-6624-48d3-d63d-bdf4b9fb7218">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="91ce0aaa-a295-4648-a0e0-9fefc66c11f6" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AD1600C00662 AS DateTime), CAST(0x0000AD1700C27394 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (869, N'11f42989-a73b-4f58-bbe1-6d02843440e9', N'2', N'项目提请联合验收', N'项目提请联合验收', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="f8727908-e5d6-4bec-8ffc-b43b9941d9d1" name="进度员" code="1" outerId="23"/>
		<Participant type="Role" id="664ea588-2590-4a1c-a560-4f1321f2c42f" name="能源与设施管理部协调专员" code="D0C79F0C-B31A-4B20-9AE4-C9C7DBFF9AE9" outerId="24"/>
	</Participants>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="11f42989-a73b-4f58-bbe1-6d02843440e9" name="项目提请联合验收" code="项目提请联合验收" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="dac219ff-2306-4151-d711-3f1558b6a471" name="Start" code="SU568E" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="250" top="150" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8b401a83-7c05-4424-da1e-35403b74a850" name="进度员发起" code="GFUCCA" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="f8727908-e5d6-4bec-8ffc-b43b9941d9d1"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined">
						<Widget left="350" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="5ecfc3d2-0b45-4153-a935-32508577c1ab" name="项目协调专员" code="4HDA59" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="664ea588-2590-4a1c-a560-4f1321f2c42f"/>
					</Performers>
					<Boundaries>
						<Boundary event="Timer" expression=""/>
					</Boundaries>
					<Sections>
						<Section name="myProperties">
							<![CDATA[]]>
						</Section>
					</Sections>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined">
						<Widget left="630" top="190" width="180" height="32"/>
					</Geography>
				</Activity>
				<Activity id="a07dce72-6924-4a46-c3c7-26e0d890b143" name="设备供应商工程师" code="QGR82F" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined">
						<Widget left="630" top="110" width="180" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2617003b-9db7-4f32-f8c4-8043b10f625c" name="系统工程师" code="9EQ22T" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined">
						<Widget left="630" top="150" width="180" height="32"/>
					</Geography>
				</Activity>
				<Activity id="59e10ec1-c202-47d0-f299-750609096e16" name="AndSplit" code="F4S2RO" url="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="AndSplit" gatewayJoinPass="null"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="470" top="150" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8734c6be-6624-48d3-d63d-bdf4b9fb7218" name="End" code="USVHVA" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="920" top="190" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="94fcc8bf-571b-475b-9b32-54faf2e83bb9" from="dac219ff-2306-4151-d711-3f1558b6a471" to="8b401a83-7c05-4424-da1e-35403b74a850">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined"/>
				</Transition>
				<Transition id="e60edba2-d234-4527-e61b-3b3fa2d6106e" from="8b401a83-7c05-4424-da1e-35403b74a850" to="59e10ec1-c202-47d0-f299-750609096e16">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined"/>
				</Transition>
				<Transition id="21af1df5-d5dc-4c5d-f437-26334a9994a0" from="59e10ec1-c202-47d0-f299-750609096e16" to="a07dce72-6924-4a46-c3c7-26e0d890b143">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined"/>
				</Transition>
				<Transition id="f7e096bc-026d-43da-f545-85fc4b56eff5" from="59e10ec1-c202-47d0-f299-750609096e16" to="2617003b-9db7-4f32-f8c4-8043b10f625c">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined"/>
				</Transition>
				<Transition id="be97ffbf-1186-4527-bb8f-45406d8294b5" from="59e10ec1-c202-47d0-f299-750609096e16" to="5ecfc3d2-0b45-4153-a935-32508577c1ab">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined"/>
				</Transition>
				<Transition id="08f93ee3-3abc-48f6-8830-5558847a96f6" from="5ecfc3d2-0b45-4153-a935-32508577c1ab" to="8734c6be-6624-48d3-d63d-bdf4b9fb7218">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="37ccd635-5b03-44b8-d2ac-dfd0a61305d9" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>', 0, NULL, NULL, 0, NULL, CAST(0x0000AD2000E6DF2A AS DateTime), CAST(0x0000AD2000E7410D AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (870, N'444db0c2-4dcb-4f86-c75d-43719b28cbb4', N'1', N'conditionstart', N'conditionstartcode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="444db0c2-4dcb-4f86-c75d-43719b28cbb4" name="conditionstart" code="conditionstartcode" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="e92bf520-9694-4d28-fb93-128094a3c5f7" name="Task" code="9LY5RN" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d33b2b34-355a-494c-d085-68860d7e9597" style="undefined">
						<Widget left="350" top="100" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c9796445-64eb-46a3-bf87-091d34c78c94" name="ConditionalStart" code="SUE8PQ" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="Conditional" expression="days==3" messageDirection="null"/>
					<Geography parent="d33b2b34-355a-494c-d085-68860d7e9597" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/conditional_start.png">
						<Widget left="140" top="100" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="bb5db0fe-0e48-4db2-ef89-3c8af570369d" from="c9796445-64eb-46a3-bf87-091d34c78c94" to="e92bf520-9694-4d28-fb93-128094a3c5f7">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d33b2b34-355a-494c-d085-68860d7e9597" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ', 0, NULL, N'', 0, NULL, CAST(0x0000ADAB0143DD1F AS DateTime), CAST(0x0000ADAC014CFDC1 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (871, N'161d72ab-385e-460a-9414-6449fb4b7689', N'1', N'interconditional', N'interconditional-code', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="161d72ab-385e-460a-9414-6449fb4b7689" name="interconditional" code="interconditional-code" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="4879b1eb-9e04-439b-8306-973c6ba49e59" name="Start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="ac57156e-a022-4da5-be20-5895f6f5d064" name="Task-001" code="task001" url="http://www.slickflow.com">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="">
						<Widget left="210" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="affc0322-ad35-4447-85e2-51ad99d6bdf6" name="Task-003" code="task003" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="">
						<Widget left="530" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="f63b8f9d-929f-4abe-a741-3a640e41e1f2" name="End" code="End" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="740" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4f4ef6b6-928e-45c3-b1a7-6121f939428d" name="InteConditional" code="QXKZYL" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="Conditional" expression="@day1-@day2&gt;3" messageDirection="null"/>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/conditional_intermediate.png">
						<Widget left="380" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="4210b56c-4b7e-4962-8008-44cbfd605959" from="4879b1eb-9e04-439b-8306-973c6ba49e59" to="ac57156e-a022-4da5-be20-5895f6f5d064">
					<Description></Description>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="null"/>
				</Transition>
				<Transition id="d45fb105-f4c8-4cf3-a562-7adaaa63df17" from="affc0322-ad35-4447-85e2-51ad99d6bdf6" to="f63b8f9d-929f-4abe-a741-3a640e41e1f2">
					<Description></Description>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="null"/>
				</Transition>
				<Transition id="118da3af-abcd-4f14-e7bb-d442d3a6abd0" from="ac57156e-a022-4da5-be20-5895f6f5d064" to="4f4ef6b6-928e-45c3-b1a7-6121f939428d">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="undefined"/>
				</Transition>
				<Transition id="158027f7-3930-456a-cec3-ccd1de05f4d0" from="4f4ef6b6-928e-45c3-b1a7-6121f939428d" to="affc0322-ad35-4447-85e2-51ad99d6bdf6">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="d5c46c04-9820-42bb-b02c-ac75b91b7211" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                               ', 0, NULL, N'', 0, NULL, CAST(0x0000ADB00114CA5D AS DateTime), CAST(0x0000ADBD00E634FF AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (872, N'95e2f41d-7a6a-47a1-a48b-fbba29769f6d', N'1', N'timerdelay', N'timerdelaycode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="95e2f41d-7a6a-47a1-a48b-fbba29769f6d" name="timerdelay" code="timerdelaycode" package="null">
			<Description></Description>
			<Activities>
				<Activity id="3d903a37-7d39-4c7e-8334-c54d9dc8d0ce" name="Start" code="Start" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="50" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="0d76bc9e-c20d-4cf9-90c5-8ed063a8048f" name="Task-001" code="task001" url="http://www.slickflow.com">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="">
						<Widget left="210" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="211f77c0-d730-42c5-ba6b-5dae6f1e0b50" name="Task-003" code="task003" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="">
						<Widget left="530" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="4e57a5ac-7efb-4410-a7de-d3b09119f7d1" name="End" code="End" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="740" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="c0d2a822-d24f-4d7f-f6b4-e6d09fe25819" name="TimerDelay" code="J3LIOI" url="">
					<Description></Description>
					<ActivityType type="IntermediateNode" trigger="Timer" expression="P2M10DT3H45M" messageDirection="null"/>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/intermediate_event_timer.png">
						<Widget left="390" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="f1f0dd47-8f2b-4a29-adfb-215179aa0ff2" from="3d903a37-7d39-4c7e-8334-c54d9dc8d0ce" to="0d76bc9e-c20d-4cf9-90c5-8ed063a8048f">
					<Description></Description>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="null"/>
				</Transition>
				<Transition id="1e1d0ba9-7615-4cc4-9347-8ca0f6f39c66" from="211f77c0-d730-42c5-ba6b-5dae6f1e0b50" to="4e57a5ac-7efb-4410-a7de-d3b09119f7d1">
					<Description></Description>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="null"/>
				</Transition>
				<Transition id="91902c2a-0a42-4caf-f699-c63868001b17" from="0d76bc9e-c20d-4cf9-90c5-8ed063a8048f" to="c0d2a822-d24f-4d7f-f6b4-e6d09fe25819">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="undefined"/>
				</Transition>
				<Transition id="d0fda576-5b90-467b-8347-768a93a9c95b" from="c0d2a822-d24f-4d7f-f6b4-e6d09fe25819" to="211f77c0-d730-42c5-ba6b-5dae6f1e0b50">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="bf9c0e4d-037e-450f-ed10-f1ba237a053d" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                       ', 0, NULL, N'', 0, NULL, CAST(0x0000ADB2011C780F AS DateTime), CAST(0x0000ADB2011D4CEB AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (873, N'8d903a57-569a-4fb8-a75b-8ecce4a4fb5a', N'1', N'timerstartup', N'timerstartupcode', 1, NULL, NULL, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="8d903a57-569a-4fb8-a75b-8ecce4a4fb5a" name="timerstartup" code="timerstartupcode" package="null">
			<Description></Description>
			<Activities>
				<Activity id="4d59e06c-7912-4cf8-af95-115c44b3be3e" name="Task-001" code="task001" url="http://www.slickflow.com">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="">
						<Widget left="210" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="779408cd-9647-43a9-9112-a2465c4f4bd0" name="Task-002" code="task002" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="">
						<Widget left="370" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="2428dedc-b391-4ec4-a003-599673758ce6" name="Task-003" code="task003" url="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="">
						<Widget left="530" top="160" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="47a5104c-c3e5-4b83-ba60-8e7be9b9388b" name="End" code="End" url="">
					<Description></Description>
					<ActivityType type="EndNode" trigger="null" expression="null" messageDirection="null"/>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="740" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="fcca748a-366f-4bed-979f-5b9218f21c78" name="TimerStart" code="BET790" url="">
					<Description></Description>
					<ActivityType type="StartNode" trigger="Timer" expression="* 2 * * *" messageDirection="null"/>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/start_event_timer.png">
						<Widget left="50" top="160" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="5a622d72-b436-4749-9893-109a325643a7" from="4d59e06c-7912-4cf8-af95-115c44b3be3e" to="779408cd-9647-43a9-9112-a2465c4f4bd0">
					<Description>t-001</Description>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="null"/>
				</Transition>
				<Transition id="1d9fa617-9058-4536-9dbd-30b36983540c" from="779408cd-9647-43a9-9112-a2465c4f4bd0" to="2428dedc-b391-4ec4-a003-599673758ce6">
					<Description></Description>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="null"/>
				</Transition>
				<Transition id="5d66b68f-1fd5-4468-b599-3cd9f6740cb9" from="2428dedc-b391-4ec4-a003-599673758ce6" to="47a5104c-c3e5-4b83-ba60-8e7be9b9388b">
					<Description></Description>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="null"/>
				</Transition>
				<Transition id="2586a52c-c338-4e2b-b3b8-4cf4a981f0d5" from="fcca748a-366f-4bed-979f-5b9218f21c78" to="4d59e06c-7912-4cf8-af95-115c44b3be3e">
					<Description></Description>
					<Condition/>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="938349b0-b26a-4d30-fe5c-4a39825b80b1" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ', 1, N'* 2 * * *', N'', 0, NULL, CAST(0x0000ADBA00FC0B27 AS DateTime), CAST(0x0000ADBA00FC3CD2 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [Version], [ProcessName], [ProcessCode], [IsUsing], [AppType], [PackageType], [PackageProcessID], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [StartType], [StartExpression], [Description], [EndType], [EndExpression], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (874, N'59fe0204-6850-4fda-91ec-795a55cca0e3', N'1', N'zzz', N'zzzcode', 1, NULL, NULL, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<Layout>
		<Groups/>
		<Messages/>
	</Layout>
	<WorkflowProcesses>
		<Process id="59fe0204-6850-4fda-91ec-795a55cca0e3" name="zzz" code="zzzcode" package="null">
			<Description>null</Description>
			<Activities>
				<Activity id="4bf8ba30-e977-49d7-b54d-597ffcf9c5b1" name="Start" code="NZ9J87" url="null">
					<Description></Description>
					<ActivityType type="StartNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="3db489d7-d329-4d8f-9142-02fcfc973610" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="270" top="240" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="9f94dc80-5d5c-4598-d9e6-805428923c72" name="Task" code="ELJMJL" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="3db489d7-d329-4d8f-9142-02fcfc973610" style="undefined">
						<Widget left="420" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="abd1b0c6-fd31-4449-94c5-b84d34181438" name="Task" code="LDWXX2" url="null">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="3db489d7-d329-4d8f-9142-02fcfc973610" style="undefined">
						<Widget left="630" top="240" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="78561020-3bc3-43d7-9736-81c0448368ac" name="End" code="H3ATN5" url="null">
					<Description></Description>
					<ActivityType type="EndNode" trigger="None" expression="null" messageDirection="null"/>
					<Geography parent="3db489d7-d329-4d8f-9142-02fcfc973610" style="symbol;image=Scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="800" top="240" width="32" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="fcf9047d-f625-4e05-849c-a6213ea8002b" from="4bf8ba30-e977-49d7-b54d-597ffcf9c5b1" to="9f94dc80-5d5c-4598-d9e6-805428923c72">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="3db489d7-d329-4d8f-9142-02fcfc973610" style="undefined"/>
				</Transition>
				<Transition id="fd20c470-4c37-48b0-cebb-de63611d3106" from="9f94dc80-5d5c-4598-d9e6-805428923c72" to="abd1b0c6-fd31-4449-94c5-b84d34181438">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="3db489d7-d329-4d8f-9142-02fcfc973610" style="undefined"/>
				</Transition>
				<Transition id="d102fb95-c62e-45fb-86cc-9136b95105d9" from="abd1b0c6-fd31-4449-94c5-b84d34181438" to="78561020-3bc3-43d7-9736-81c0448368ac">
					<Description></Description>
					<Condition type="null">
						<ConditionText/>
					</Condition>
					<GroupBehaviours/>
					<Receiver type="Default"/>
					<Geography parent="3db489d7-d329-4d8f-9142-02fcfc973610" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
</Package>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ', 0, NULL, N'', 0, NULL, CAST(0x0000ADBF00E65A3F AS DateTime), CAST(0x0000ADBF00F022F3 AS DateTime))
SET IDENTITY_INSERT [dbo].[WfProcess] OFF
/****** Object:  Table [dbo].[WfLog]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WfLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EventTypeID] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[Severity] [nvarchar](50) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Message] [nvarchar](500) NULL,
	[StackTrace] [nvarchar](4000) NULL,
	[InnerStackTrace] [nvarchar](4000) NULL,
	[RequestData] [nvarchar](2000) NULL,
	[Timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tmpTest]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpTest](
	[ID] [int] NOT NULL,
	[Title] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[tmpTest] ([ID], [Title]) VALUES (1, N'a999')
INSERT [dbo].[tmpTest] ([ID], [Title]) VALUES (2, N'B')
INSERT [dbo].[tmpTest] ([ID], [Title]) VALUES (3, N'C')
/****** Object:  Table [dbo].[SysUserResource]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysUserResource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ResourceID] [int] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysUserResource] ON
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (1, 7, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (2, 7, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (3, 7, 4)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (4, 7, 5)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (5, 8, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (6, 8, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (7, 8, 4)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (8, 8, 5)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (9, 11, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (10, 11, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (11, 11, 6)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (12, 12, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (13, 12, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (14, 12, 6)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (15, 9, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (16, 9, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (17, 9, 7)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (18, 10, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (19, 10, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (20, 10, 7)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (21, 13, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (22, 13, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (23, 13, 8)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (24, 14, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (25, 14, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (26, 14, 8)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (27, 15, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (28, 15, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (29, 15, 9)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (30, 15, 10)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (31, 16, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (32, 16, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (33, 16, 9)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (34, 16, 10)
SET IDENTITY_INSERT [dbo].[SysUserResource] OFF
/****** Object:  Table [dbo].[SysUser]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[EMail] [varchar](100) NULL,
 CONSTRAINT [PK_SysUser] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysUser] ON
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (1, N'Cindy', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (2, N'Henry', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (3, N'Test', N'jack@163.com')
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (4, N'LeeO', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (5, N'Ada', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (6, N'Lucy', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (7, N'Peter', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (8, N'Bill', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (9, N'Tuda', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (10, N'Jack', N'hr@ruochisoft.com')
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (11, N'Fisher', N'hr@ruochisoft.com')
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (12, N'Sherley', N'hr@ruochisoft.com')
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (13, N'Jimi', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (14, N'William', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (15, N'Damark', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (16, N'Smith', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (17, N'Yolanda', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (18, N'Jinny', NULL)
INSERT [dbo].[SysUser] ([ID], [UserName], [EMail]) VALUES (19, N'Susan', N'hr@ruochisoft.com')
SET IDENTITY_INSERT [dbo].[SysUser] OFF
/****** Object:  Table [dbo].[SysRoleUser]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysRoleUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[UserID] [int] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysRoleUser] ON
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (1, 8, 1)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (2, 7, 2)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (3, 4, 3)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (4, 3, 4)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (5, 2, 5)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (6, 1, 6)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (7, 9, 7)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (8, 9, 8)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (9, 10, 11)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (10, 10, 12)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (11, 11, 9)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (12, 11, 10)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (13, 12, 13)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (14, 12, 14)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (15, 13, 15)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (16, 13, 16)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (17, 14, 17)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (19, 2, 17)
SET IDENTITY_INSERT [dbo].[SysRoleUser] OFF
/****** Object:  Table [dbo].[SysRoleGroupResource]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysRoleGroupResource](
	[ID] [int] NOT NULL,
	[RgType] [smallint] NOT NULL,
	[RgID] [int] NOT NULL,
	[ResourceID] [int] NOT NULL,
	[PermissionType] [smallint] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (1, 1, 9, 1, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (2, 1, 9, 2, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (3, 1, 9, 4, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (4, 1, 9, 5, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (5, 1, 10, 1, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (6, 1, 10, 2, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (7, 1, 10, 6, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (8, 1, 11, 7, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (9, 1, 12, 8, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (10, 1, 13, 9, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (11, 1, 13, 10, 1)
/****** Object:  Table [dbo].[SysRole]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysRole](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleCode] [varchar](50) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysRole] ON
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (1, N'employees', N'普通员工')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (2, N'depmanager', N'部门经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (3, N'hrmanager', N'人事经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (4, N'director', N'主管总监')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (7, N'deputygeneralmanager', N'副总经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (8, N'generalmanager', N'总经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (9, N'salesmate', N'业务员')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (10, N'techmate', N'打样员')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (11, N'merchandiser', N'跟单员')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (12, N'qcmate', N'质检员')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (13, N'expressmate', N'包装员')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (14, N'finacemanager', N'财务经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (21, N'testrole', N'testrole')
SET IDENTITY_INSERT [dbo].[SysRole] OFF
/****** Object:  Table [dbo].[SysResource]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysResource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ResourceType] [smallint] NOT NULL,
	[ParentResourceID] [int] NOT NULL,
	[ResourceName] [nvarchar](50) NOT NULL,
	[ResourceCode] [varchar](100) NOT NULL,
	[OrderNo] [smallint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysResource] ON
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (1, 1, 0, N'生产订单系统', N'SfDemo.Made', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (2, 2, 1, N'生产订单流程', N'SfDemo.Made.POrder', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (4, 5, 2, N'同步订单', N'SfDemo.Made.POrder.SyncOrder', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (5, 5, 2, N'分派订单', N'SfDemo.Made.POrder.Dispatch', 2)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (6, 5, 2, N'打样', N'SfDemo.Made.POrder.Sample', 3)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (7, 5, 2, N'生产', N'SfDemo.Made.POrder.Manufacture', 4)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (8, 5, 2, N'质检', N'SfDemo.Made.POrder.QCCheck', 5)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (9, 5, 2, N'称重', N'SfDemo.Made.POrder.Weight', 6)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (10, 5, 2, N'发货', N'SfDemo.Made.POrder.Delivery', 7)
SET IDENTITY_INSERT [dbo].[SysResource] OFF
/****** Object:  Table [dbo].[SysEmployeeManager]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysEmployeeManager](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[EmpUserID] [int] NOT NULL,
	[ManagerID] [int] NOT NULL,
	[MgrUserID] [int] NOT NULL,
 CONSTRAINT [PK_SysEmployeeManager] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysEmployeeManager] ON
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (1, 1, 6, 2, 5)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (2, 4, 10, 5, 17)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (4, 6, 9, 3, 5)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (5, 4, 10, 7, 18)
SET IDENTITY_INSERT [dbo].[SysEmployeeManager] OFF
/****** Object:  Table [dbo].[SysEmployee]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysEmployee](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DeptID] [int] NOT NULL,
	[EmpCode] [varchar](50) NOT NULL,
	[EmpName] [nvarchar](50) NOT NULL,
	[UserID] [int] NULL,
	[Mobile] [varchar](20) NULL,
	[EMail] [varchar](100) NULL,
	[Remark] [nvarchar](500) NULL,
 CONSTRAINT [PK_SYSEMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysEmployee] ON
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (1, 2, N'0001', N'路天明', 6, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (2, 2, N'0002', N'张经理', 5, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (3, 3, N'0003', N'金经理', 18, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (4, 4, N'0004', N'阿杰', 10, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (5, 4, N'0005', N'崔经理', 17, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (6, 2, N'0010', N'张明', 9, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (7, 4, N'0030', N'金兰', 18, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[SysEmployee] OFF
/****** Object:  Table [dbo].[SysDepartment]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysDepartment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DeptCode] [varchar](50) NOT NULL,
	[DeptName] [nvarchar](100) NOT NULL,
	[ParentID] [int] NOT NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_SYSDEPARTMENT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysDepartment] ON
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (1, N'CP', N'SlickOne科技', 0, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (2, N'TH', N'技术部', 1, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (3, N'HR', N'人事部', 1, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (4, N'FN', N'财务部', 1, NULL)
SET IDENTITY_INSERT [dbo].[SysDepartment] OFF
/****** Object:  View [dbo].[vw_SysRoleUserView]    Script Date: 10/12/2021 16:52:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SysRoleUserView]
AS
SELECT  dbo.SysRoleUser.ID,
    dbo.SysRole.ID as RoleID, 
	dbo.SysRole.RoleName, 
	dbo.SysRole.RoleCode, 
	dbo.SysUser.ID as UserID,
	dbo.SysUser.UserName
FROM         dbo.SysRole LEFT JOIN
             dbo.SysRoleUser ON dbo.SysRole.ID = dbo.SysRoleUser.RoleID LEFT JOIN
             dbo.SysUser ON dbo.SysRoleUser.UserID = dbo.SysUser.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[24] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SysRole"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 110
               Right = 180
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysRoleUser"
            Begin Extent = 
               Top = 4
               Left = 313
               Bottom = 108
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysUser"
            Begin Extent = 
               Top = 165
               Left = 175
               Bottom = 254
               Right = 317
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SysRoleUserView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SysRoleUserView'
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_UserSave]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_UserSave]
   @userID			int,
   @userName		varchar(100)

AS

BEGIN

	SET NOCOUNT ON
	-- 检查条件
	IF EXISTS(SELECT 1 
			  FROM SysUser 
			  WHERE ID<>@userID 
				AND (UserName=@userName)
			  )
		RAISERROR ('插入或编辑用户数据失败: 有重复的名称已经存在!', 16, 1)

    --插入或者编辑				
	BEGIN TRY
		IF (@userID>0)
			UPDATE SysUser
			SET UserName=@userName
			WHERE ID=@userID
		ELSE
		    INSERT INTO SysUser(UserName)
		    VALUES(@userName)
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('插入或编辑用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_UserDelete]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_UserDelete]
   @userID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		DELETE FROM SysRoleUser WHERE UserID=@userID
		DELETE FROM SysUser WHERE ID=@userID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleUserDelete]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleUserDelete]
   @userID			int,
   @roleID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		IF (@userID = -1)
			DELETE FROM SysRoleUser WHERE RoleID=@roleID
		ELSE
			DELETE FROM SysRoleUser WHERE UserID=@userID AND RoleID=@roleID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除角色下的用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleSave]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleSave]
   @roleID			int,
   @roleCode		varchar(50),
   @roleName		nvarchar(100)

AS

BEGIN

	SET NOCOUNT ON
	-- 检查条件
	IF EXISTS(SELECT 1 
			  FROM SysRole 
			  WHERE ID<>@roleID 
				AND (RoleCode=@roleCode OR RoleName=@roleName)
			  )
		RAISERROR ('插入或编辑角色数据失败: 有重复的名称或者编码已经存在!', 16, 1)

    --插入或者编辑				
	BEGIN TRY
		IF (@roleID>0)
			UPDATE SysRole
			SET RoleCode=@roleCode, RoleName=@roleName
			WHERE ID=@roleID
		ELSE
		    INSERT INTO SysRole(RoleCode, RoleName)
		    VALUES(@roleCode, @roleName)
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('插入或编辑角色数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleDelete]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleDelete]
   @roleID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		DELETE FROM SysRoleUser WHERE RoleID=@roleID
		DELETE FROM SysRole WHERE ID=@roleID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除角色数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_DeptUserListRankQuery]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_sys_DeptUserListRankQuery]
   @roleIDs				varchar(8000),
   @curUserID			int,
   @receiverType			int

AS

BEGIN
    --ReceiverType= 1 上司
    --ReceiverType= 2 同级
    --ReceiverType= 3 下属
	SET NOCOUNT ON
	
    DECLARE @error int, @message varchar(4000)
    
    --Activity节点需要定义接收者类型，前提也需要定义角色信息
	IF (@receiverType = 0)
		BEGIN
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('无效的接收者类型@receiverType！查询失败: %d: %s', 16, 1, @error, @message)
		END
	ELSE IF (@roleIDs = '')
		BEGIN
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('无效的角色定义@@roleIDs！查询失败: %d: %s', 16, 1, @error, @message)
		END
		
	--ReceiverType=0, throw an error
	DECLARE @tblRoleIDS as TABLE(ID int)
	
	INSERT INTO @tblRoleIDS(ID)
	SELECT ID 
	FROM dbo.fn_com_SplitString(@roleIDs)
	
	BEGIN TRY
		IF (@receiverType = 1)	--上司
			BEGIN
				SELECT 
					U.ID AS UserID,
					U.UserName
				FROM SysUser U
				INNER JOIN SysEmployeeManager EM
					ON U.ID = EM.MgrUserID
				INNER JOIN SysRoleUser RU
				    ON U.ID = RU.UserID
				INNER JOIN @tblRoleIDS R
				    ON R.ID = RU.RoleID
				WHERE EM.EmpUserID = @curUserID
			END
		ELSE IF (@receiverType = 2) --同级
			BEGIN
				SELECT 
					U.ID AS UserID,
					U.UserName
				FROM SysUser U
				INNER JOIN SysEmployeeManager EM
					ON U.ID = EM.EmpUserID
				INNER JOIN SysRoleUser RU
				    ON U.ID = RU.UserID
				INNER JOIN @tblRoleIDS R
				    ON R.ID = RU.RoleID
				WHERE EM.MgrUserID IN
					(
						SELECT 
							MgrUserID
						FROM SysEmployeeManager
						WHERE EmpUserID = @curUserID
					)
			END
		ELSE IF (@receiverType = 3) --下属
			BEGIN
				SELECT 
					U.ID AS UserID,
					U.UserName
				FROM SysUser U
				INNER JOIN SysEmployeeManager EM
					ON U.ID = EM.EmpUserID
				INNER JOIN SysRoleUser RU
				    ON U.ID = RU.UserID
				INNER JOIN @tblRoleIDS R
				    ON R.ID = RU.RoleID
				WHERE EM.MgrUserID = @curUserID
			END
		
	END TRY
	BEGIN CATCH
		SELECT @error = ERROR_NUMBER()
			, @message = ERROR_MESSAGE();
		RAISERROR ('查询员工上司下属关系数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  Table [dbo].[WfActivityInstance]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfActivityInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[AppInstanceCode] [varchar](50) NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ActivityGUID] [varchar](100) NOT NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[ActivityCode] [varchar](50) NULL,
	[ActivityType] [smallint] NOT NULL,
	[ActivityState] [smallint] NOT NULL,
	[WorkItemType] [smallint] NOT NULL,
	[AssignedToUserIDs] [nvarchar](1000) NULL,
	[AssignedToUserNames] [nvarchar](2000) NULL,
	[BackwardType] [smallint] NULL,
	[BackSrcActivityInstanceID] [int] NULL,
	[BackOrgActivityInstanceID] [int] NULL,
	[GatewayDirectionTypeID] [smallint] NULL,
	[CanNotRenewInstance] [tinyint] NOT NULL,
	[ApprovalStatus] [smallint] NULL,
	[TokensRequired] [int] NOT NULL,
	[TokensHad] [int] NOT NULL,
	[JobTimerType] [smallint] NULL,
	[JobTimerStatus] [smallint] NULL,
	[TriggerExpression] [nvarchar](200) NULL,
	[OverdueDateTime] [datetime] NULL,
	[JobTimerTreatedDateTime] [datetime] NULL,
	[ComplexType] [smallint] NULL,
	[MergeType] [smallint] NULL,
	[MIHostActivityInstanceID] [int] NULL,
	[CompareType] [smallint] NULL,
	[CompleteOrder] [float] NULL,
	[SignForwardType] [smallint] NULL,
	[NextStepPerformers] [nvarchar](4000) NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[EndedDateTime] [datetime] NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfActivityInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[pr_eav_EntityAttrValuePivotGetPaged]    Script Date: 10/12/2021 16:52:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_eav_EntityAttrValuePivotGetPaged]
    @entityDefID	int = 0,		--表单定义ID
    @entityInfoID	int = 0,		--表单实例ID
	@createdUserID		varchar(100) = '',		--表单创建人
    @pageIndex  int = 1,  --当前页码 
    @pageSize INT = 100, --每页大小   
    @field nvarchar(40)='ID', --排序字段   
    @order nvarchar(10) = 'asc ',
	@rowsCount	int		OUTPUT --排序顺序   
AS


BEGIN

	SET NOCOUNT ON
	
	--判断有没有传入MatTypeID
	IF (@entityDefID = 0 and @createdUserID = '')
	BEGIN
		DECLARE @error int, @message varchar(4000)
		SELECT @error = ERROR_NUMBER()
			, @message = ERROR_MESSAGE();
		RAISERROR ('表单定义ID和创建用户ID不能同时为空！查询失败: %d: %s', 16, 1, @error, @message)
	END

	DECLARE @sql nvarchar(1000)
	DECLARE @countSql nvarchar(1000)
	DECLARE @query nvarchar(4000)

	--组建查询用到的SQL语句
	--1. 基本语句
	SET @sql = 'SELECT ID FROM EavEntityInfo WHERE 1=1'
	SET @countSql = 'SELECT @total=COUNT(1) FROM EavEntityInfo WHERE 1=1'


    --2. 限定条件
    IF (@entityDefID != 0)
    BEGIN
    	SET @sql = @sql + ' AND EntityDefID=' + CONVERT(varchar, @entityDefID)
		SET @countSql = @countSql + ' AND EntityDefID=' + CONVERT(varchar, @entityDefID)
    END
     
    
    --3. 获取总记录数，如果总记录数为0，则返回
	DECLARE @params nvarchar(500)
	SET @params = '@total int OUTPUT'
	EXEC sp_executesql @countSql, @params, @total=@rowsCount OUTPUT

	IF (@rowsCount = 0)
	BEGIN
		--选取空记录返回，用于Dapper构造动态类型对象
		SELECT
			EEI.ID,
			EEI.EntityDefID,
			EED.EntityName,
			EEI.ProcessGUID,
			EEI.CreatedUserName,
			EEI.CreatedUserID,
			EEI.CreatedDatetime
		FROM EavEntityInfo EEI
		INNER JOIN EavEntityDef EED
			ON EED.ID = EEI.EntityDefID
		WHERE EEI.ID = -1000

		RETURN
	END
	
	--4. 获取要分页的实体ID表
	DECLARE @tblEntityInfo TABLE(ID INT)

	INSERT INTO @tblEntityInfo
	EXEC dbo.pr_com_QuerySQLPaged @sql, @pageSize, @pageIndex, 'ID', 'asc'

	--5. 查询是否有动态扩展属性，如果没有，返回主表记录
	DECLARE @tblDynamicAttr	TABLE(
		EntityInfoID		int,
		TblName		nvarchar(50),
		AttrID		int,
		AttrCode	varchar(30),
		AttrName	nvarchar(50),
		AttrDataType	int,
		OrderID			int,
		Value		nvarchar(4000)
	)
	
	--将动态属性写入临时表
	INSERT INTO @tblDynamicAttr
	SELECT * FROM(
		SELECT
			EEAI.EntityInfoID
			,'EavEntityAttrInt' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAI.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrInt EEAI
			ON EEA.ID = EEAI.AttrID
		UNION ALL
		SELECT
			EEAN.EntityInfoID
			,'EavEntityAttrDecimal' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAN.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrDecimal EEAN
			ON EEA.ID = EEAN.AttrID
		UNION ALL
		SELECT
			EEAV.EntityInfoID
			,'EavEntityAttrVarchar' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAV.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrVarchar EEAV
			ON EEA.ID = EEAV.AttrID
		UNION ALL
		SELECT
			EEAD.EntityInfoID
			,'EavEntityAttrDatetime' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAD.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrDatetime EEAD
			ON EEA.ID = EEAD.AttrID
		UNION ALL
		SELECT
			EEAT.EntityInfoID
			,'EavEntityAttrText' as TblName
			,EEA.ID as AttrID
			,EEA.AttrCode
			,EEA.AttrName
			,EEA.AttrDataType
			,EEA.OrderID
			,CONVERT(nvarchar, EEAT.Value) as Value
			FROM EavEntityAttribute EEA
			INNER JOIN EavEntityAttrText EEAT
			ON EEA.ID = EEAT.AttrID
	) T
	WHERE T.EntityInfoID IN (SELECT ID FROM @tblEntityInfo) 
	ORDER BY 
		T.EntityInfoID, 
		T.OrderID

	DECLARE @dynamicRowsCount int
	SELECT @dynamicRowsCount = COUNT(1) FROM @tblDynamicAttr
	
	print 'dynamic rows count:' 
	print @dynamicRowsCount
	
	--如果没有动态扩展属性，则返回主表记录
	IF (@dynamicRowsCount = 0)
	BEGIN
		SELECT 
			EEI.ID, 
			EED.EntityName
		FROM EavEntityInfo EEI
		INNER JOIN EavEntityDef EED
			ON EED.ID = EEI.EntityDefID
		WHERE EEI.ID IN (
			SELECT ID FROM @tblEntityInfo) 

		RETURN
	END

	--6. 返回动态属性值的列表
	--物料自定义属性表的临时表
	--用于先将物料扩展属性填充到表里
	CREATE TABLE #myCustomEntityAttrValueTable
	(
		[ID] [int] NULL,
		[EntityDefID] [int] NULL,
		[EntityName] [nvarchar] (100) NULL,
		[EntityCode] [varchar](100) NULL,
		[AttrName] [nvarchar] (100) NULL,
		[AttrCode] [varchar](100) NULL,
		[OrderID]	[int] NULL,
		[Value] [nvarchar](max) NULL
	)

	--插入行记录到临时表
	INSERT INTO #myCustomEntityAttrValueTable
	SELECT 
		EEI.ID, 
		EEI.EntityDefID,
		EED.EntityName,
		EED.EntityCode,
		T.AttrName,
		T.AttrCode,
		T.OrderID,
		T.Value
	FROM EavEntityInfo EEI
	INNER JOIN EavEntityDef EED
		ON EED.ID = EEI.EntityDefID
	INNER JOIN EavEntityAttribute EEA
		ON EEA.EntityDefID = EED.ID
	INNER JOIN @tblEntityInfo T1
		ON T1.ID = EEI.ID
	LEFT JOIN @tblDynamicAttr T
		ON EEI.ID = T.EntityInfoID
	ORDER BY 
		T.EntityInfoID,
		T.OrderID
	
	
	--行列PIVOT过程
	DECLARE @QuestionList nvarchar(max);
	SELECT @QuestionList = STUFF(
		(
			SELECT 
				', ' + quotename(AttrCode) 
			FROM #myCustomEntityAttrValueTable 
			GROUP BY 
				AttrCode, 
				OrderID
			ORDER BY 
				OrderID
			FOR XML PATH('')
		), 
		1, 
		2, 
		''
	);
	
	--行列PIVOT过程SQL语句
	DECLARE @qry nvarchar(max);
	SET @qry = 'SELECT ID, EntityDefID, EntityName, EntityCode, ProcessGUID, ' 
		+ @QuestionList 
		+ ' FROM (
					SELECT ID, EntityDefID, EntityName, EntityCode, ProcessGUID, AttrCode, Value 
					FROM #myCustomEntityAttrValueTable 
			) UP
		PIVOT (
			MAX(Value) 
			FOR AttrCode IN (' + @QuestionList + ')
		) pvt
		ORDER BY 
			ID;';

	--执行输出
	print @qry
	EXEC sp_executesql @qry;


	--7. 销毁临时表
	DROP TABLE #myCustomEntityAttrValueTable 


END
GO
/****** Object:  Table [dbo].[WfTasks]    Script Date: 10/12/2021 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfTasks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityInstanceID] [int] NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ActivityGUID] [varchar](100) NOT NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[TaskType] [smallint] NOT NULL,
	[TaskState] [smallint] NOT NULL,
	[EntrustedTaskID] [int] NULL,
	[AssignedToUserID] [varchar](50) NOT NULL,
	[AssignedToUserName] [nvarchar](50) NOT NULL,
	[IsEMailSent] [tinyint] NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[EndedDateTime] [datetime] NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_SSIP_WfTasks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vwWfActivityInstanceTasks]    Script Date: 10/12/2021 16:52:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwWfActivityInstanceTasks]
AS
SELECT     dbo.WfTasks.ID AS TaskID, dbo.WfActivityInstance.AppName, dbo.WfActivityInstance.AppInstanceID, dbo.WfActivityInstance.ProcessGUID, 
                      dbo.WfProcessInstance.Version, dbo.WfTasks.ProcessInstanceID, dbo.WfActivityInstance.ActivityGUID, dbo.WfTasks.ActivityInstanceID, 
                      dbo.WfActivityInstance.ActivityName, dbo.WfActivityInstance.ActivityCode, dbo.WfActivityInstance.ActivityType, dbo.WfActivityInstance.WorkItemType, 
                      dbo.WfActivityInstance.BackSrcActivityInstanceID, dbo.WfActivityInstance.CreatedByUserID AS PreviousUserID, 
                      dbo.WfActivityInstance.CreatedByUserName AS PreviousUserName, dbo.WfActivityInstance.CreatedDateTime AS PreviousDateTime, dbo.WfTasks.TaskType, 
                      dbo.WfTasks.EntrustedTaskID, dbo.WfTasks.AssignedToUserID, dbo.WfTasks.AssignedToUserName, dbo.WfTasks.IsEMailSent, dbo.WfTasks.CreatedDateTime, 
                      dbo.WfTasks.LastUpdatedDateTime, dbo.WfTasks.EndedDateTime, dbo.WfTasks.EndedByUserID, dbo.WfTasks.EndedByUserName, dbo.WfTasks.TaskState, 
                      dbo.WfActivityInstance.ActivityState, dbo.WfTasks.RecordStatusInvalid, dbo.WfProcessInstance.ProcessState, dbo.WfActivityInstance.ComplexType, 
                      dbo.WfActivityInstance.MIHostActivityInstanceID, dbo.WfActivityInstance.ApprovalStatus, dbo.WfActivityInstance.CompleteOrder, 
                      dbo.WfProcessInstance.AppInstanceCode, dbo.WfProcessInstance.ProcessName, dbo.WfProcessInstance.CreatedByUserName, 
                      dbo.WfProcessInstance.CreatedDateTime AS PCreatedDateTime, CASE WHEN MIHostActivityInstanceID IS NULL THEN ActivityState ELSE
                          (SELECT     ActivityState
                            FROM          dbo.WfActivityInstance a WITH (NOLOCK)
                            WHERE      a.ID = dbo.WfActivityInstance.MIHostActivityInstanceID) END AS MiHostState
FROM         dbo.WfActivityInstance WITH (NOLOCK) INNER JOIN
                      dbo.WfTasks WITH (NOLOCK) ON dbo.WfActivityInstance.ID = dbo.WfTasks.ActivityInstanceID INNER JOIN
                      dbo.WfProcessInstance WITH (NOLOCK) ON dbo.WfActivityInstance.ProcessInstanceID = dbo.WfProcessInstance.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[51] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "WfProcessInstance"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WfActivityInstance"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WfTasks"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 249
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3930
         Alias = 2145
         Table = 2595
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWfActivityInstanceTasks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWfActivityInstanceTasks'
GO
/****** Object:  Default [DF__HrsLeave__LeaveT__5165187F]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[HrsLeave] ADD  CONSTRAINT [DF__HrsLeave__LeaveT__5165187F]  DEFAULT ((0)) FOR [LeaveType]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_State]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_State]  DEFAULT ((0)) FOR [ActivityState]
GO
/****** Object:  Default [DF_WfActivityInstance_WorkItemType]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_WfActivityInstance_WorkItemType]  DEFAULT ((0)) FOR [WorkItemType]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_CanInvokeNextActivity]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_CanInvokeNextActivity]  DEFAULT ((0)) FOR [CanNotRenewInstance]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_TokensRequired]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_TokensRequired]  DEFAULT ((1)) FOR [TokensRequired]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_CreatedDateTime]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_RecordStatusInvalid]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_WfProcess_Version]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_WfProcess_Version]  DEFAULT ((1)) FOR [Version]
GO
/****** Object:  Default [DF_WfProcess_IsUsing]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_WfProcess_IsUsing]  DEFAULT ((0)) FOR [IsUsing]
GO
/****** Object:  Default [DF_WfProcess_IsTimingStartup]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_WfProcess_IsTimingStartup]  DEFAULT ((0)) FOR [StartType]
GO
/****** Object:  Default [DF_WfProcess_EndType]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_WfProcess_EndType]  DEFAULT ((0)) FOR [EndType]
GO
/****** Object:  Default [DF_SSIP-WfPROCESS_CreatedDateTime]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_SSIP-WfPROCESS_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_WfProcessInstance_Version]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_Version]  DEFAULT ((1)) FOR [Version]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_State]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_State]  DEFAULT ((0)) FOR [ProcessState]
GO
/****** Object:  Default [DF_WfProcessInstance_ParentProcessInstanceID]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_ParentProcessInstanceID]  DEFAULT ((0)) FOR [ParentProcessInstanceID]
GO
/****** Object:  Default [DF_WfProcessInstance_InvokedActivityInstanceID]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_InvokedActivityInstanceID]  DEFAULT ((0)) FOR [InvokedActivityInstanceID]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_CreatedDateTime]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_RecordStatus]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_RecordStatus]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_SSIP_WfTasks_IsCompleted]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_IsCompleted]  DEFAULT ((0)) FOR [TaskState]
GO
/****** Object:  Default [DF_WfTasks_IsEMailSent]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_WfTasks_IsEMailSent]  DEFAULT ((0)) FOR [IsEMailSent]
GO
/****** Object:  Default [DF_SSIP_WfTasks_CreatedDateTime]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfTasks_RecordStatusInvalid]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_WfTransitionInstance_IsBackwardFlying]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_WfTransitionInstance_IsBackwardFlying]  DEFAULT ((0)) FOR [FlyingType]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_ConditionParseResult]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_ConditionParseResult]  DEFAULT ((0)) FOR [ConditionParseResult]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_CreatedDateTime]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_RecordStatusInvalid]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF__WfJobSche__Statu__73BA3083]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WhJobSchedule] ADD  CONSTRAINT [DF__WfJobSche__Statu__73BA3083]  DEFAULT ((0)) FOR [Status]
GO
/****** Object:  ForeignKey [FK_WfActivityInstance_ProcessInstanceID]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfActivityInstance]  WITH NOCHECK ADD  CONSTRAINT [FK_WfActivityInstance_ProcessInstanceID] FOREIGN KEY([ProcessInstanceID])
REFERENCES [dbo].[WfProcessInstance] ([ID])
GO
ALTER TABLE [dbo].[WfActivityInstance] CHECK CONSTRAINT [FK_WfActivityInstance_ProcessInstanceID]
GO
/****** Object:  ForeignKey [FK_WfTasks_ActivityInstanceID]    Script Date: 10/12/2021 16:52:00 ******/
ALTER TABLE [dbo].[WfTasks]  WITH NOCHECK ADD  CONSTRAINT [FK_WfTasks_ActivityInstanceID] FOREIGN KEY([ActivityInstanceID])
REFERENCES [dbo].[WfActivityInstance] ([ID])
GO
ALTER TABLE [dbo].[WfTasks] CHECK CONSTRAINT [FK_WfTasks_ActivityInstanceID]
GO
