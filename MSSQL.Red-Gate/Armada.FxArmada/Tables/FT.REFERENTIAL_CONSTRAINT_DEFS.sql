CREATE TABLE [FT].[REFERENTIAL_CONSTRAINT_DEFS]
(
[CONSTRAINT_CATALOG] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONSTRAINT_SCHEMA] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONSTRAINT_NAME] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TABLE_CATALOG] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TABLE_SCHEMA] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TABLE_NAME] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COLUMN_NAME] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORDINAL_POSITION] [int] NOT NULL,
[UNIQUE_CONSTRAINT_CATALOG] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UNIQUE_CONSTRAINT_SCHEMA] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UNIQUE_CONSTRAINT_NAME] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UNIQUE_TABLE_CATALOG] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UNIQUE_TABLE_SCHEMA] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UNIQUE_TABLE_NAME] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UNIQUE_COLUMN_NAME] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
