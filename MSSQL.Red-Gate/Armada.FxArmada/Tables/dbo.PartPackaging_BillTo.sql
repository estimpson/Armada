CREATE TABLE [dbo].[PartPackaging_BillTo]
(
[BillToCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackagingCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PartPacka__Statu__08F7A690] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PartPackag__Type__09EBCAC9] DEFAULT ((0)),
[PackDisabled] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackD__0ADFEF02] DEFAULT ((0)),
[PackEnabled] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackE__0BD4133B] DEFAULT ((0)),
[PackDefault] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackD__0CC83774] DEFAULT ((0)),
[PackWarn] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackW__0DBC5BAD] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PartPacka__RowCr__0EB07FE6] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartPacka__RowCr__0FA4A41F] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PartPacka__RowMo__1098C858] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartPacka__RowMo__118CEC91] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_BillTo] ADD CONSTRAINT [PK__PartPack__FFEE745160BAFB92] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_BillTo] ADD CONSTRAINT [UQ__PartPack__811C3FAFF370784D] UNIQUE NONCLUSTERED  ([BillToCode], [PartCode], [PackagingCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_BillTo] ADD CONSTRAINT [FK__PartPacka__BillT__061B39E5] FOREIGN KEY ([BillToCode]) REFERENCES [dbo].[customer] ([customer])
GO
ALTER TABLE [dbo].[PartPackaging_BillTo] ADD CONSTRAINT [FK__PartPacka__Packa__08038257] FOREIGN KEY ([PackagingCode]) REFERENCES [dbo].[package_materials] ([code])
GO
ALTER TABLE [dbo].[PartPackaging_BillTo] ADD CONSTRAINT [FK__PartPacka__PartC__070F5E1E] FOREIGN KEY ([PartCode]) REFERENCES [dbo].[part] ([part])
GO
