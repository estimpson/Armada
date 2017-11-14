CREATE TABLE [EDIToyota].[ManifestDetailsDeleted]
(
[PickupID] [int] NULL,
[ManifestNumber] [char] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerPart] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__ManifestD__Statu__1D6CAC44] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__ManifestDe__Type__1E60D07D] DEFAULT ((0)),
[ReturnableContainer] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NOT NULL,
[Racks] [int] NOT NULL,
[OrderNo] [int] NULL,
[Plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrigPickupID] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ManifestD__RowCr__1F54F4B6] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ManifestD__RowCr__204918EF] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ManifestD__RowMo__213D3D28] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ManifestD__RowMo__22316161] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIToyota].[ManifestDetailsDeleted] ADD CONSTRAINT [PK__Manifest__FFEE74513D4B04CD] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EDIToyota].[ManifestDetailsDeleted] ADD CONSTRAINT [UQ__Manifest__F3905BCD5C83AF93] UNIQUE NONCLUSTERED  ([PickupID], [ManifestNumber], [CustomerPart]) ON [PRIMARY]
GO
ALTER TABLE [EDIToyota].[ManifestDetailsDeleted] ADD CONSTRAINT [FK__ManifestD__OrigP__1D37A21A] FOREIGN KEY ([OrigPickupID]) REFERENCES [EDIToyota].[Pickups] ([RowID])
GO
ALTER TABLE [EDIToyota].[ManifestDetailsDeleted] ADD CONSTRAINT [FK__ManifestD__Picku__1E2BC653] FOREIGN KEY ([PickupID]) REFERENCES [EDIToyota].[Pickups] ([RowID])
GO
