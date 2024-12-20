CREATE TABLE [FT].[StatusDefn]
(
[StatusGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__StatusDef__Statu__5A502F92] DEFAULT (newid()),
[StatusTable] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatusColumn] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatusCode] [int] NOT NULL,
[StatusName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HelpText] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StatusDef__RowCr__5B4453CB] DEFAULT (getdate()),
[RowCreateUser] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__StatusDef__RowCr__5C387804] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[StatusDefn] ADD CONSTRAINT [PK__StatusDe__3C1B65915867E720] PRIMARY KEY NONCLUSTERED  ([StatusGUID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[StatusDefn] ADD CONSTRAINT [UQ__StatusDe__62DBBDE9558B7A75] UNIQUE CLUSTERED  ([StatusTable], [StatusColumn], [StatusCode]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'FT', 'TABLE', N'StatusDefn', 'CONSTRAINT', N'UQ__StatusDe__62DBBDE9558B7A75'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'3334642149', 'SCHEMA', N'FT', 'TABLE', N'StatusDefn', 'CONSTRAINT', N'UQ__StatusDe__62DBBDE9558B7A75'
GO
