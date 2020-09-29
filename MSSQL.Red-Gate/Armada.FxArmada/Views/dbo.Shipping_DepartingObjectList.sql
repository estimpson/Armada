SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[Shipping_DepartingObjectList]
as
select
	so.ShipperNumber
,	CustomerCode = coalesce(sD.customer, d.vendor)
,	CustomerName = coalesce(c.name, v.name)
,	ShipToCode = sD.destination
,	ShipToName = d.name
,	TruckNumber = sD.truck_number
,	so.Serial
,	IsScannedToTruck = case when so.Status = 1 then 1 else 0 end
,	ObjectType = case when so.Type = 1 then 'Loose' when so.Type = 2 then 'Pallet' when so.Type = 3 then 'Box on Pallet' end
,	BoxCount =
		case
			when so.Type = 2 then
				(	select
						count(*)
					from
						dbo.Shipping_Objects
					where
						ShipperNumber = so.ShipperNumber
						and ParentSerial = so.Serial
				)
		end
,	so.Type
,	so.ParentSerial
,	so.LabelPrintDT
,	LegacyShipperID = sD.id
from
	dbo.Shipping_Objects so
		join dbo.shipper sD
			on 'L' + convert(varchar(49), sd.id) = so.ShipperNumber
		join dbo.destination d
			on d.destination = sD.destination
		left join dbo.customer c
			on c.customer = sd.customer
		left join dbo.vendor v
			on v.code = d.vendor
GO
