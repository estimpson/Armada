CREATE TABLE [FT].[MenuItems]
(
[MenuID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__MenuItems__MenuI__5555A4F4] DEFAULT (newid()),
[MenuItemName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemOwner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NULL,
[Type] [int] NULL,
[MenuText] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MenuIcon] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectClass] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[MenuItems] ADD CONSTRAINT [PK__MenuItem__C99ED251536D5C82] PRIMARY KEY NONCLUSTERED  ([MenuID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[MenuItems] ADD CONSTRAINT [UQ__MenuItem__8C34A66E5090EFD7] UNIQUE NONCLUSTERED  ([MenuItemName], [ItemOwner]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'FT', 'TABLE', N'MenuItems', 'CONSTRAINT', N'UQ__MenuItem__8C34A66E5090EFD7'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'902580537', 'SCHEMA', N'FT', 'TABLE', N'MenuItems', 'CONSTRAINT', N'UQ__MenuItem__8C34A66E5090EFD7'
GO
