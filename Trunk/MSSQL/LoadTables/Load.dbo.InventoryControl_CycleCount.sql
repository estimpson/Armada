
insert
	dbo.InventoryControl_CycleCountHeaders
(	CycleCountNumber
,	Status
,	Description
,	CountBeginDT
,	CountEndDT
,	ExpectedCount
,	FoundCount
,	RecoveredCount
,	QtyAdjustedCount
,	LocationChangedCount
)
select
	cch.CycleCountNumber
,	cch.Status
,	Description = 'Migrated from monitor.'
,	cch.CountBeginDT
,	cch.CountEndDT
,	cco.ExpectedCount
,	cco.FoundCount
,	cco.RecoveryCount
,	cco.QtyAdjustedCount
,	cco.LocationChangedCount
from
	(	select
			CycleCountNumber = FT.udf_NumberFromMaskAndValue('CC_000000000', fcch.CC_ID, null)
		,	Status = case when fcch.CC_EndDT is not null then 2 else 1 end
		,	CountBeginDT = fcch.CC_BeginDT
		,	CountEndDT = fcch.CC_EndDT
		from
			rawArmada.dbo.FT_CycleCountHeaders fcch
	) cch
	join
		(	select
				CycleCountNumber = FT.udf_NumberFromMaskAndValue('CC_000000000', coalesce(fccfi.CCFI_CCID, fccbi.CCBI_CCID), null)
			,	ExpectedCount = count(fccbi.CCBI_ID)
			,	FoundCount = count(fccfi.CCFI_ID)
			,	RecoveryCount = count(case when fccbi.CCBI_ID is null then 1 end)
			,	QtyAdjustedCount = count(case when fccfi.CCFI_QtyEntered != fccfi.CCFI_QtySystem then 1 end)
			,	LocationChangedCount = 0
			from
				rawArmada.dbo.FT_CycleCountBeginInventory fccbi
				full outer join rawArmada.dbo.FT_CycleCountFoundInventory fccfi
					on fccfi.CCFI_CCID = fccbi.CCBI_CCID
					and fccfi.CCFI_Serial = fccbi.CCBI_Serial
			group by
				coalesce(fccfi.CCFI_CCID, fccbi.CCBI_CCID)
		) cco
		on cco.CycleCountNumber = cch.CycleCountNumber
order by
	1

insert
	dbo.InventoryControl_CycleCountObjects
(	CycleCountNumber
,	Line
,	Serial
,	Status
,	Type
,	Part
,	OriginalQuantity
,	CorrectedQuantity
,	Unit
,	OriginalLocation
,	CorrectedLocation
)
select
	cco.CycleCountNumber
,	Line = row_number() over (partition by cco.CycleCountNumber order by cco.Serial)
,	cco.Serial
,	cco.Status
,	cco.Type
,	cco.Part
,	cco.OriginalQuantity
,	cco.CorrectedQuantity
,	cco.Unit
,	cco.OriginalLocation
,	cco.CorrectedLocation
from
	(	select
			CycleCountNumber = FT.udf_NumberFromMaskAndValue('CC_000000000', coalesce(fccfi.CCFI_CCID, fccbi.CCBI_CCID), null)
		,	Serial = coalesce(fccfi.CCFI_Serial, fccbi.CCBI_Serial)
		,	Status = min
				(	case
						when fccfi.CCFI_CCID is null then -1
						when fccbi.CCBI_CCID is null then 5
						when fccfi.CCFI_QtyEntered != fccfi.CCFI_QtySystem then 2
						else 1
					end
				)          
		,	Type = 0
		,	Part = min(coalesce(fccfi.CCFI_Part, fccbi.CCBI_Part))
		,	OriginalQuantity = min(coalesce(fccbi.CCBI_Quantity, fccfi.CCFI_QtySystem))
		,	CorrectedQuantity = min(fccfi.CCFI_QtyEntered)
		,	Unit = min(pInv.standard_unit)
		,	OriginalLocation = min(coalesce(pInv.primary_location, 'N/A'))
		,	CorrectedLocation = null
		from
			rawArmada.dbo.FT_CycleCountBeginInventory fccbi
			full outer join rawArmada.dbo.FT_CycleCountFoundInventory fccfi
				on fccfi.CCFI_CCID = fccbi.CCBI_CCID
				and fccfi.CCFI_Serial = fccbi.CCBI_Serial
			join dbo.part_inventory pInv
				on pInv.part = coalesce(fccfi.CCFI_Part, fccbi.CCBI_Part)
		group by
			FT.udf_NumberFromMaskAndValue('CC_000000000', coalesce(fccfi.CCFI_CCID, fccbi.CCBI_CCID), null)
		,	coalesce(fccfi.CCFI_Serial, fccbi.CCBI_Serial)
	) cco
order by
	1
,	3

