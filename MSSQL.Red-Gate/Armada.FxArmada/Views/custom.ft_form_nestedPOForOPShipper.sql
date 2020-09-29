SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [custom].[ft_form_nestedPOForOPShipper]
as
SELECT  activity_router.parent_part AS PartReturning, 
		bom.part, 
		COALESCE(CONVERT(VARCHAR(15), po_number), 'Blanket PO Not Set-up')  PONumber
FROM dbo.activity_router 
JOIN
	dbo.bill_of_material bom ON bom.parent_part = activity_router.parent_part
	LEFT JOIN po_header poh ON poh.blanket_part = activity_router.parent_part AND COALESCE(poh.status,'') = 'A'
WHERE code IN ( SELECT code  FROM dbo.activity_codes WHERE flow_route_window LIKE '%Outside%') 
GO
