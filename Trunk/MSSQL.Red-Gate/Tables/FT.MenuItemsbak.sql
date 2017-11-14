CREATE TABLE [FT].[MenuItemsbak]
(
[MenuID] [uniqueidentifier] NOT NULL,
[MenuItemName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemOwner] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NULL,
[Type] [int] NULL,
[MenuText] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MenuIcon] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectClass] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[MenuItemsbak] ADD CONSTRAINT [PK__MenuItembak__C99ED251536D5C82] PRIMARY KEY NONCLUSTERED  ([MenuID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[MenuItemsbak] ADD CONSTRAINT [UQ__MenuItem_bak_8C34A66E5090EFD7] UNIQUE NONCLUSTERED  ([MenuItemName], [ItemOwner]) ON [PRIMARY]
GO
