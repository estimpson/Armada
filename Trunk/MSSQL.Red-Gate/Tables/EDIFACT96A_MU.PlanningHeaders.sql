CREATE TABLE [EDIFACT96A_MU].[PlanningHeaders]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PlanningH__Statu__3CB3FF71] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanningHe__Type__3DA823AA] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanningH__RowCr__3E9C47E3] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningH__RowCr__3F906C1C] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanningH__RowMo__40849055] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningH__RowMo__4178B48E] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIFACT96A_MU].[PlanningHeaders] ADD CONSTRAINT [PK__Planning__FFEE745038FD06F0] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
