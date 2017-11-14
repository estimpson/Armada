SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [custom].[vw_Label_DestinationLabel]

AS

SELECT	
			s.id AS ShipperID,
			d.destination AS DestinationCode,
			d.address_1 AS DestinationAddress1,
			d.address_2 AS DestinationAddress2,
			d.address_3 AS DestinationAddress3,
			d.address_4 AS DestinationAddress4,
			p.company_name AS CompanyName,
			p.address_1 AS CompanyAddress1,
			p.address_2 AS CompanyAddress2,
			p.address_3 AS CompanyAddress3,
			s.shipping_dock AS ChryslerDock,
			s.destination+COALESCE(s.shipping_dock, '') AS ChryslerLocation,
			GETDATE() AS date_stamp,
			CASE WHEN COALESCE(es.supplier_code,'') = '10768' THEN 1 ELSE 0 END AS ChryslerDestinationFlag



						
FROM
		shipper s
JOIN
		destination d ON d.destination = s.destination
JOIN
		edi_setups es ON es.destination = d.destination
CROSS JOIN
		parameters p


GO
