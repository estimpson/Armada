SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[Shipping_ASNShippers]
as
select
	ShipperNumber = 'L' + convert(varchar(49), s.id)
,	LegacyShipperID = s.id
,	ShipperType = coalesce(s.type, 'N')
,	ASNOverlayGroup = esASN.asn_overlay_group
,	IsASNSent = case when s.status = 'Z' then 1 else 0 end
from
	dbo.shipper s
		join dbo.edi_setups esASN
			on esASN.destination = s.destination
			and esASN.auto_create_asn = 'Y'
where
	s.status in ('C', 'Z')
	and coalesce(s.type, 'N') = 'N'
GO
