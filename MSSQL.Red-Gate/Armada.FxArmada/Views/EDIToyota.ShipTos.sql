SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [EDIToyota].[ShipTos]
AS
SELECT
	ShipToCode = COALESCE(ds.destination, es.destination)
,	EDIShipToCode = es.EDIShipToID
,	FOB = ds.fob
,	Carrier = ds.scac_code
,	TransMode = ds.trans_mode
,	FreightType = ds.freight_type
,	ShipperNote = ds.note_for_shipper
,	Kanban = es.material_issuer
FROM
	dbo.destination_shipping ds
	JOIN dbo.edi_setups es
		ON es.destination = ds.destination
WHERE
	trading_partner_code LIKE '%TMM%' or Trading_partner_code LIKE '%TOYOTA%'



GO
