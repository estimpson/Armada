SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [custom].[ftvw_MasterBOL_Ford]

AS

SELECT 
parms.company_name,
parms.address_1,
parms.address_2,
parms.address_3,
parms.phone_number,
bol.bol_number,
s.date_stamp,
s.destination,
d.name,
sd.boxes_staged,
sd.customer_po,
sd.customer_part,
sd.part_name,
sd.qty_packed,
sd.gross_weight,
es.supplier_code,
COALESCE(d2.address_5,'') + CONVERT(VARCHAR(25), RIGHT( '000' + CONVERT( VARCHAR(25), DATEPART(DAYOFYEAR, COALESCE((SELECT MAX(date_stamp) FROM shipper s2 WHERE s2.bill_of_lading_number = bol.bol_number), GETDATE()))),3)) AS FordBillOfladingNumber,
mf2.message1,
mf2.message2
FROM
	Shipper s
JOIN
	destination d ON d.destination = s.destination
JOIN
	edi_setups es ON es.destination = s.destination
JOIN
	shipper_detail sd ON sd.shipper = s.id
JOIN
	Bill_of_lading bol ON bol.bol_number = s.bill_of_lading_number
LEFT JOIN
	destination d2 ON d2.destination = bol.destination
LEFT JOIN
	dbo.destination_message_file mf2 ON mf2.destination = d2.destination
CROSS JOIN
	dbo.parameters parms

--	SELECT * FROM custom.ftvw_MasterBOL_Ford WHERE (name LIKE 'FORD%' OR Name LIKE 'FMC%') ORDER BY bol_number DESC

--SELECT * FROM custom.ftvw_MasterBOL_Ford WHERE bol_number =	157241


GO
