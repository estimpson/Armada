CREATE TABLE [dbo].[PartPackaging_OrderDetail]
(
[ReleaseID] [int] NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackagingCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PartPacka__Statu__36BE7140] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PartPackag__Type__37B29579] DEFAULT ((0)),
[PackDisabled] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackD__38A6B9B2] DEFAULT ((0)),
[PackEnabled] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackE__399ADDEB] DEFAULT ((0)),
[PackDefault] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackD__3A8F0224] DEFAULT ((0)),
[PackWarn] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackW__3B83265D] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PartPacka__RowCr__3C774A96] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartPacka__RowCr__3D6B6ECF] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PartPacka__RowMo__3E5F9308] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartPacka__RowMo__3F53B741] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_OrderDetail] ADD CONSTRAINT [PK__PartPack__FFEE7451C6750537] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_OrderDetail] ADD CONSTRAINT [UQ__PartPack__B7987C5AC0A80C39] UNIQUE NONCLUSTERED  ([ReleaseID], [PartCode], [PackagingCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_OrderDetail] ADD CONSTRAINT [FK__PartPacka__Packa__35CA4D07] FOREIGN KEY ([PackagingCode]) REFERENCES [dbo].[package_materials] ([code])
GO
ALTER TABLE [dbo].[PartPackaging_OrderDetail] ADD CONSTRAINT [FK__PartPacka__PartC__34D628CE] FOREIGN KEY ([PartCode]) REFERENCES [dbo].[part] ([part])
GO
ALTER TABLE [dbo].[PartPackaging_OrderDetail] ADD CONSTRAINT [FK__PartPacka__Relea__33E20495] FOREIGN KEY ([ReleaseID]) REFERENCES [dbo].[order_detail] ([id])
GO
