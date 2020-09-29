SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[IC_PartOnline]
AS
SELECT
	part.part
,	part.name
,	part.class
,	part.type
,	on_hand = COALESCE(po2.OnHand,0)
,	po.min_onhand
,	po.max_onhand
,	re_order = po.max_onhand - po2.OnHand
,	on_order =
		(	SELECT
				SUM(mjl.QtyRequired - mjl.QtyCompleted)
			 FROM
				dbo.MES_JobList mjl
			 WHERE
				mjl.PartCode = part.part
		) +
		(	SELECT
				SUM(quantity - received)
			FROM
				po_detail
			WHERE
				po_detail.part_number = part.part
		)
,	supply = COALESCE(pm.machine, po.default_vendor)
,	exhaust_date = nmps.DueDT
FROM
	dbo.part
	LEFT JOIN dbo.part_online po
		ON po.part = part.part
	LEFT JOIN dbo.part_machine pm
		ON pm.part = part.part
		AND pm.sequence = 1
	LEFT JOIN
		(	SELECT
				Part = p.part
			,	OnHand = COALESCE(SUM(o.std_quantity), 0)
			FROM
				dbo.part p
				LEFT JOIN dbo.object o
					ON o.part = p.part
				--added where clause for Armada 2015-01-31
				-- modified to only pull 'Approved' Inventory Andre S. Boulanger 2015-04-01
				WHERE o.status = 'A'
			GROUP BY
				p.part
		) po2
		ON po2.Part = part.part
	LEFT JOIN
		(	SELECT
				nm.Part
			,	DueDT = MIN(CASE WHEN nm.Balance > 0 THEN nm.RequiredDT END)
			FROM
				dbo.NetMPS nm
			GROUP BY
				nm.Part
		) nmps
		ON nmps.Part = part.part


GO
