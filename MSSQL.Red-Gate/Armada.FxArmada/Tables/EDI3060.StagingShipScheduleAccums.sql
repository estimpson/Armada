CREATE TABLE [EDI3060].[StagingShipScheduleAccums]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingSh__Statu__333B267B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingShi__Type__342F4AB4] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NOT NULL,
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingSh__RowCr__35236EED] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingSh__RowCr__36179326] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingSh__RowMo__370BB75F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingSh__RowMo__37FFDB98] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI3060].[StagingShipScheduleAccums] ADD CONSTRAINT [PK__StagingS__FFEE745076E736CA] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
