CREATE TABLE [EDI3010].[PlanningAccums]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PlanningA__Statu__582D7F5F] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanningAc__Type__5921A398] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ReleaseNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsigneeCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPOLine] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerModelYear] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerECL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastQtyReceived] [numeric] (20, 6) NULL,
[LastQtyDT] [datetime] NULL,
[LastShipper] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastAccumQty] [numeric] (20, 6) NULL,
[LastAccumDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanningA__RowCr__5A15C7D1] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningA__RowCr__5B09EC0A] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanningA__RowMo__5BFE1043] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningA__RowMo__5CF2347C] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI3010].[PlanningAccums] ADD CONSTRAINT [PK__Planning__FFEE7450BEB3753E] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
