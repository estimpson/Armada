CREATE TABLE [FXSYS].[UserIndexes]
(
[TableName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IndexID] [int] NULL,
[IsUnique] [bit] NULL,
[IsClustered] [bit] NULL,
[IsPrimaryKey] [bit] NULL,
[IsUniqueConstraint] [bit] NULL,
[ColumnList] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
