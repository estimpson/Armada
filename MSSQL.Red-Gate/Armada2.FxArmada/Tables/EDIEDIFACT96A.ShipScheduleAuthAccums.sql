CREATE TABLE [EDIEDIFACT96A].[ShipScheduleAuthAccums]
(
[Status] [int] NOT NULL CONSTRAINT [DF__ShipSched__Statu__406B0467] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__ShipSchedu__Type__415F28A0] DEFAULT ((0)),
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
[RAWCUMStartDT] [datetime] NULL,
[RAWCUMEndDT] [datetime] NULL,
[RAWCUM] [int] NULL,
[FabCUMStartDT] [datetime] NULL,
[FabCUMEndDT] [datetime] NULL,
[FabCUM] [int] NULL,
[PriorCUMStartDT] [datetime] NULL,
[PriorCUMEndDT] [datetime] NULL,
[PriorCUM] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ShipSched__RowCr__42534CD9] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ShipSched__RowCr__43477112] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ShipSched__RowMo__443B954B] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ShipSched__RowMo__452FB984] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIEDIFACT96A].[ShipScheduleAuthAccums] ADD CONSTRAINT [PK__ShipSche__FFEE74502A431231] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
