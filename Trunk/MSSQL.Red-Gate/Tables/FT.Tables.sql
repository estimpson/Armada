CREATE TABLE [FT].[Tables]
(
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Schema] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HelpText] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUser] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Tables__LastUser__7A8729A3] DEFAULT (suser_sname()),
[LastDT] [datetime] NOT NULL CONSTRAINT [DF__Tables__LastDT__7B7B4DDC] DEFAULT (getdate()),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowGUID] [uniqueidentifier] NULL CONSTRAINT [DF__Tables__RowGUID__7C6F7215] DEFAULT (newid()),
[ObjectID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[Tables] ADD CONSTRAINT [PK__Tables__FFEE745175C27486] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[Tables] ADD CONSTRAINT [UQ__Tables__57703F1C789EE131] UNIQUE NONCLUSTERED  ([Name], [Schema]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'FT', 'TABLE', N'Tables', 'CONSTRAINT', N'UQ__Tables__57703F1C789EE131'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'2859854469', 'SCHEMA', N'FT', 'TABLE', N'Tables', 'CONSTRAINT', N'UQ__Tables__57703F1C789EE131'
GO
