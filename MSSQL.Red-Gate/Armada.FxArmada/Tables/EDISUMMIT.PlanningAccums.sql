CREATE TABLE [EDISUMMIT].[PlanningAccums]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PlanningA__Statu__3183B987] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanningAc__Type__3277DDC0] DEFAULT ((0)),
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
[LastQtyReceived] [int] NULL,
[LastQtyDT] [datetime] NULL,
[LastAccumQty] [int] NULL,
[LastAccumDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanningA__RowCr__336C01F9] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningA__RowCr__34602632] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanningA__RowMo__35544A6B] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningA__RowMo__36486EA4] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDISUMMIT].[PlanningAccums] ADD CONSTRAINT [PK__Planning__FFEE74503AE2E42D] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
