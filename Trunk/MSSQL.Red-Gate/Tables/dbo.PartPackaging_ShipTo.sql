CREATE TABLE [dbo].[PartPackaging_ShipTo]
(
[ShipToCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackagingCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PartPacka__Statu__1839EA20] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PartPackag__Type__192E0E59] DEFAULT ((0)),
[PackDisabled] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackD__1A223292] DEFAULT ((0)),
[PackEnabled] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackE__1B1656CB] DEFAULT ((0)),
[PackDefault] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackD__1C0A7B04] DEFAULT ((0)),
[PackWarn] [tinyint] NULL CONSTRAINT [DF__PartPacka__PackW__1CFE9F3D] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PartPacka__RowCr__1DF2C376] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartPacka__RowCr__1EE6E7AF] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PartPacka__RowMo__1FDB0BE8] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartPacka__RowMo__20CF3021] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_ShipTo] ADD CONSTRAINT [PK__PartPack__FFEE745104AE3294] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_ShipTo] ADD CONSTRAINT [UQ__PartPack__C0B548BD33FF19F0] UNIQUE NONCLUSTERED  ([ShipToCode], [PartCode], [PackagingCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartPackaging_ShipTo] ADD CONSTRAINT [FK__PartPacka__Packa__1745C5E7] FOREIGN KEY ([PackagingCode]) REFERENCES [dbo].[package_materials] ([code])
GO
ALTER TABLE [dbo].[PartPackaging_ShipTo] ADD CONSTRAINT [FK__PartPacka__PartC__1651A1AE] FOREIGN KEY ([PartCode]) REFERENCES [dbo].[part] ([part])
GO
ALTER TABLE [dbo].[PartPackaging_ShipTo] ADD CONSTRAINT [FK__PartPacka__ShipT__155D7D75] FOREIGN KEY ([ShipToCode]) REFERENCES [dbo].[destination] ([destination])
GO
