CREATE TABLE [EDIToyota].[ManifestDetails]
(
[PickupID] [int] NULL,
[ManifestNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__ManifestD__Statu__17B3D2EE] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__ManifestDe__Type__18A7F727] DEFAULT ((0)),
[ReturnableContainer] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NOT NULL,
[Racks] [int] NOT NULL,
[OrderNo] [int] NULL,
[Plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrigPickupID] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ManifestD__RowCr__199C1B60] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ManifestD__RowCr__1A903F99] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ManifestD__RowMo__1B8463D2] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ManifestD__RowMo__1C78880B] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIToyota].[ManifestDetails] ADD CONSTRAINT [PK__Manifest__FFEE74513946619D] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EDIToyota].[ManifestDetails] ADD CONSTRAINT [UQ__Manifest__F3905BCDDFC9F98A] UNIQUE NONCLUSTERED  ([PickupID], [ManifestNumber], [CustomerPart]) ON [PRIMARY]
GO
ALTER TABLE [EDIToyota].[ManifestDetails] ADD CONSTRAINT [FK__ManifestD__OrigP__1B4F59A8] FOREIGN KEY ([OrigPickupID]) REFERENCES [EDIToyota].[Pickups] ([RowID])
GO
ALTER TABLE [EDIToyota].[ManifestDetails] ADD CONSTRAINT [FK__ManifestD__Picku__1C437DE1] FOREIGN KEY ([PickupID]) REFERENCES [EDIToyota].[Pickups] ([RowID])
GO
