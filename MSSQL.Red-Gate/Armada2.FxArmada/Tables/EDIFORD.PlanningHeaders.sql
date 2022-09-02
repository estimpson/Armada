CREATE TABLE [EDIFORD].[PlanningHeaders]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PlanningH__Statu__5E458011] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanningHe__Type__5F39A44A] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanningH__RowCr__602DC883] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningH__RowCr__6121ECBC] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanningH__RowMo__621610F5] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningH__RowMo__630A352E] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIFORD].[PlanningHeaders] ADD CONSTRAINT [PK__Planning__FFEE745014FB3127] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
