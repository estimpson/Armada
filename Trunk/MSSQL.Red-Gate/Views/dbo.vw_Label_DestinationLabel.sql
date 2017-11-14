SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_Label_DestinationLabel]

AS

SELECT	
			s.id AS ShipperID,
			UPPER(d.destination) AS DestinationCode,
			UPPER(d.name) AS DestinationName,
			UPPER(d.address_1) AS DestinationAddress1,
			UPPER(d.address_2) AS DestinationAddress2,
			UPPER(d.address_3) AS DestinationAddress3,
			UPPER(d.address_4) AS DestinationAddress4,
			UPPER(p.company_name) AS CompanyName,
			UPPER(p.address_1) AS CompanyAddress1,
			UPPER(p.address_2) AS CompanyAddress2,
			UPPER(p.address_3) AS CompanyAddress3,
			UPPER(s.shipping_dock) AS ChryslerDock,
			UPPER(s.destination+COALESCE(s.shipping_dock, '')) AS ChryslerLocation,
			--GETDATE() AS date_stamp,
			s.date_stamp,
			CASE WHEN COALESCE(es.supplier_code,'') LIKE '10768%' THEN 1 ELSE NULL END AS ChryslerDestinationFlag,
			CASE WHEN COALESCE(es.supplier_code,'') LIKE '10768%' THEN NULL ELSE 1 END AS OtherDestinationFlag

								
FROM
		shipper s
JOIN
		destination d ON d.destination = s.destination
JOIN
		edi_setups es ON es.destination = d.destination
CROSS JOIN
		parameters p



GO
