SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [custom].[ToyotaManifestsPerShipper]
as
SELECT pu.ShipperID, MD.ManifestNumber, OrderNo FROM ediToyota.ManifestDetails MD

JOIN
	EDIToyota.Pickups pu ON pu.RowID = MD.PickupID
GO
