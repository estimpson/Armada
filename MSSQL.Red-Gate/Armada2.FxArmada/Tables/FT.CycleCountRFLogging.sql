CREATE TABLE [FT].[CycleCountRFLogging]
(
[ProcName] [sys].[sysname] NOT NULL CONSTRAINT [DF__CycleCoun__ProcN__255CDCA3] DEFAULT (object_name(@@procid)),
[ActionTaken] [int] NOT NULL,
[ActionTakenMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartDT] [datetime] NULL CONSTRAINT [DF__CycleCoun__Start__265100DC] DEFAULT (getdate()),
[EndDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CycleCoun__RowCr__27452515] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CycleCoun__RowCr__2839494E] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CycleCoun__RowMo__292D6D87] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CycleCoun__RowMo__2A2191C0] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[CycleCountRFLogging] ADD CONSTRAINT [PK__CycleCou__FFEE74514E20A57C] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
