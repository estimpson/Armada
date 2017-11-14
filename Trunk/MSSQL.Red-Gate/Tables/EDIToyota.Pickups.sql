CREATE TABLE [EDIToyota].[Pickups]
(
[ReleaseDate] [datetime] NOT NULL,
[PickupDT] [datetime] NOT NULL,
[ShipToCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PickupCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperID] [int] NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__Pickups__Status__2325859A] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Pickups__Type__2419A9D3] DEFAULT ((0)),
[Racks] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Pickups__RowCrea__250DCE0C] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Pickups__RowCrea__2601F245] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Pickups__RowModi__26F6167E] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Pickups__RowModi__27EA3AB7] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIToyota].[Pickups] ADD CONSTRAINT [PK__Pickups__FFEE7451F246950B] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EDIToyota].[Pickups] ADD CONSTRAINT [UQ__Pickups__BD2597D82E07E622] UNIQUE NONCLUSTERED  ([PickupDT], [ShipToCode], [PickupCode], [ShipperID]) ON [PRIMARY]
GO
