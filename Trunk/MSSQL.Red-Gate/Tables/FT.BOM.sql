CREATE TABLE [FT].[BOM]
(
[BOMID] [int] NOT NULL,
[ParentPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChildPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StdQty] [numeric] (20, 6) NULL,
[ScrapFactor] [numeric] (20, 6) NULL,
[SubstitutePart] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[BOM] ADD CONSTRAINT [PK__BOM__CA12FCBB6F8056A2] PRIMARY KEY CLUSTERED  ([BOMID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BOM_1] ON [FT].[BOM] ([ChildPart], [ParentPart]) ON [PRIMARY]
GO
ALTER TABLE [FT].[BOM] ADD CONSTRAINT [UQ__BOM__E64C4993725CC34D] UNIQUE NONCLUSTERED  ([ParentPart], [ChildPart]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'FT', 'TABLE', N'BOM', 'CONSTRAINT', N'UQ__BOM__E64C4993725CC34D'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'-818568116', 'SCHEMA', N'FT', 'TABLE', N'BOM', 'CONSTRAINT', N'UQ__BOM__E64C4993725CC34D'
GO
