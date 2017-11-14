SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[Shipping_DepartingTruckList]
as
select
	CustomerList = dbo.udf_TempCustomerList(sdsl.TruckNumber, sdsl.PRONumber)
,	ShipToList = dbo.udf_TempShipToList(sdsl.TruckNumber, sdsl.PRONumber)
,	sdsl.TruckNumber
,	PRONumber = sdsl.PRONumber
,	ShipperNumberList = dbo.udf_TempShipperList(sdsl.TruckNumber, sdsl.PRONumber)
,	LegacyShipperID = dbo.udf_TempLegacyShipperList(convert(varchar, sdsl.TruckNumber), sdsl.PRONumber)
,	IsVerified = min(sdsl.IsVerified)
,	ObjectCount = sum(sdsl.ObjectCount)
,	LooseBoxCount = sum(sdsl.LooseBoxCount)
,	PalletCount = sum(sdsl.PalletCount)
,	BoxOnPalletCount = sum(sdsl.BoxOnPalletCount)
,	VerifiedLooseBoxCount = sum(sdsl.VerifiedLooseBoxCount)
,	VerifiedPalletCount = sum(sdsl.VerifiedPalletCount)
,	VerifiedBoxOnPalletCount = sum(sdsl.VerifiedBoxOnPalletCount)
,	DepartureBeginDT = min(sdsl.DepartureBeginDT)
,	IsOverrideScanning = min(sdsl.IsOverrideScanning)
from
	dbo.Shipping_DepartingShipperList sdsl
group by
	sdsl.TruckNumber
,	sdsl.PRONumber
GO
