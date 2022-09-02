CREATE TABLE [dbo].[PartPackaging_OrderHeader]
(
[OrderNo] [numeric] (8, 0) NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackagingCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PartPacka__Statu__277C2DB0] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PartPackag__Type__287051E9] DEFAULT ((0)),
[PackDisabled] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackD__29647622] DEFAULT ((0)),
[PackEnabled] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackE__2A589A5B] DEFAULT ((0)),
[PackDefault] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackD__2B4CBE94] DEFAULT ((0)),
[PackWarn] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackW__2C40E2CD] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PartPacka__RowCr__2D350706] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartPacka__RowCr__2E292B3F] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PartPacka__RowMo__2F1D4F78] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartPacka__RowMo__301173B1] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_OrderHeader] ADD CONSTRAINT [PK__PartPack__FFEE7451BA4ABC07] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_OrderHeader] ADD CONSTRAINT [UQ__PartPack__297269C330A96262] UNIQUE NONCLUSTERED  ([OrderNo], [PartCode], [PackagingCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_OrderHeader] ADD CONSTRAINT [FK__PartPacka__Order__249FC105] FOREIGN KEY ([OrderNo]) REFERENCES [dbo].[order_header] ([order_no])
GO
ALTER TABLE [dbo].[PartPackaging_OrderHeader] ADD CONSTRAINT [FK__PartPacka__Packa__26880977] FOREIGN KEY ([PackagingCode]) REFERENCES [dbo].[package_materials] ([code])
GO
ALTER TABLE [dbo].[PartPackaging_OrderHeader] ADD CONSTRAINT [FK__PartPacka__PartC__2593E53E] FOREIGN KEY ([PartCode]) REFERENCES [dbo].[part] ([part])
GO
