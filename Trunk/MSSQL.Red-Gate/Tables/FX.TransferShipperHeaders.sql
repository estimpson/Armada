CREATE TABLE [FX].[TransferShipperHeaders]
(
[ShipperNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShipperHeaderID] [int] NOT NULL,
[ArrivalDockCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArrivalPlant] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUser] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TransferS__LastU__47919582] DEFAULT (suser_sname()),
[LastDT] [datetime] NOT NULL CONSTRAINT [DF__TransferS__LastD__4885B9BB] DEFAULT (getdate()),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowGUID] [uniqueidentifier] NULL CONSTRAINT [DF__TransferS__RowGU__4979DDF4] DEFAULT (newid())
) ON [PRIMARY]
GO
ALTER TABLE [FX].[TransferShipperHeaders] ADD CONSTRAINT [PK__Transfer__FFEE745140E497F3] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FX].[TransferShipperHeaders] ADD CONSTRAINT [UQ__Transfer__B174D9DD43C1049E] UNIQUE NONCLUSTERED  ([RowGUID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'FX', 'TABLE', N'TransferShipperHeaders', 'CONSTRAINT', N'UQ__Transfer__B174D9DD43C1049E'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'1170818140', 'SCHEMA', N'FX', 'TABLE', N'TransferShipperHeaders', 'CONSTRAINT', N'UQ__Transfer__B174D9DD43C1049E'
GO
