SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [custom].[MES_BFHist_AccumulatedBackflushDiscrepancy]
as
select
	ccLastByPart.Part
,	ccLastByPart.LastCycleCountDT
,	OnHand = coalesce(inv.OnHand, 0)
,	bfHist.AccumConsumed
,	bfHist.AccumDiscrepancy
,	ConsumptionDiscrepancyPct = bfHist.AccumDiscrepancy / nullif(bfHist.AccumConsumed, 0)
,	InventoryDiscrepancyPct = bfHist.AccumDiscrepancy / nullif(inv.OnHand, 0)
from
	(	select
			ccHist.Part
		,	LastCycleCountDT = max(ccHist.CountEndDT)
		from
			(	select
					iccch.CycleCountNumber
				,	Part = substring(iccch.Description, 24, len(iccch.Description) - 25)
				,	iccch.CountEndDT
				from
					dbo.InventoryControl_CycleCountHeaders iccch
				where
					iccch.CountEndDT is not null
					and iccch.Description like 'All inventory of part%'
				union
				select
					iccco.CycleCountNumber
				,	iccco.Part
				,	iccch.CountEndDT
				from
					dbo.InventoryControl_CycleCountObjects iccco
						join dbo.InventoryControl_CycleCountHeaders iccch
							on iccch.CycleCountNumber = iccco.CycleCountNumber
				where
					iccch.CountEndDT is not null
				group by
					iccco.CycleCountNumber
				,	iccco.Part
				,	iccch.CountEndDT
				having
					count(distinct iccco.Serial) > 3
			) ccHist
		group by
			ccHist.Part
	) ccLastByPart
	left join
		(	select
				Part = o.part
			,	OnHand = sum(o.std_quantity)
			from
				dbo.object o
			where
				o.status = 'A'
			group by
				o.part
		) inv
		on inv.Part = ccLastByPart.Part
	cross apply
		(	select
				AccumConsumed = sum(bd.QtyIssue)
			,	AccumDiscrepancy = sum(bd.QtyOverage)
			from
				dbo.BackflushDetails bd
			where
				bd.PartConsumed = ccLastByPart.Part
				and bd.RowCreateDT > ccLastByPart.LastCycleCountDT
		) bfHist
where
	exists
		(	select
				AccumConsumed = sum(bd.QtyIssue)
			,	AccumDiscrepancy = sum(bd.QtyOverage)
			from
				dbo.BackflushDetails bd
			where
				bd.PartConsumed = ccLastByPart.Part
				and bd.RowCreateDT > ccLastByPart.LastCycleCountDT - 90
		)
GO
