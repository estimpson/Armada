CREATE TABLE [EDIGRAM].[PlanningHeaders]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PlanningH__Statu__64D36A45] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanningHe__Type__65C78E7E] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[DocumentImportDT] [datetime] NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Release] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ControlNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanningH__RowCr__66BBB2B7] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningH__RowCr__67AFD6F0] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanningH__RowMo__68A3FB29] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningH__RowMo__69981F62] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIGRAM].[PlanningHeaders] ADD CONSTRAINT [PK__Planning__FFEE745030729CED] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
