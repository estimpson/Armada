SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXPL].[udf_Q_Part]
(	@PartCode varchar(25)
)
returns xml
as
begin
--- <Body>
	declare
		@result xml
        
	set	@result =
		(	select
				PartCode = p.part
			,	PartDescription = p.name + coalesce(' [' + p.cross_ref + ']', '') + coalesce(' - ' + p.description_long, '')
			,	UnitWeight = pInv.unit_weight
			,	WeightTolerance = 0.03
			,	DefaultPackaging = defaultPack.code
			,	RequiresFinalInspection = 1
			,	DeflashMethod = 'MACHINE'
			,	ShelfInventory = -1
			,	PackagingList = 
				(	select
						PackageCode	= pm.code
					,	PackageDescription = pm.name
					,	StandardPack = pp.quantity
					,	SpecialInstructions = pp.SpecialInstructions
					from
						dbo.part_packaging pp
						join dbo.package_materials pm
							on pm.code = pp.code
					where
						p.part = pp.part
					for xml raw('Packaging'), type
				)
			from
				dbo.part p
				join dbo.part_inventory pInv
					on pInv.part = p.part
				cross apply
					(	select	top (1)
								pp.quantity
						,		pm.code
						from
							dbo.part_packaging pp
							join dbo.package_materials pm
								on pm.code = pp.code
						where
							pp.part = p.part
						order by
							case
								when pm.type = 'B' then
									1
								else
									2
							end
						,	pp.quantity desc
					) defaultPack
				left join dbo.part_characteristics pc
					on pc.part = p.part
				outer apply
					(	select	top (1)
								*
						from
							dbo.part_machine pm2
						where
							pm2.part = p.part
						order by
							pm2.sequence
					) pmach
				outer	apply
					(	select	top (1)
								ar.code
						,		ar.notes
						from
							dbo.activity_router ar
						where
							ar.parent_part = p.part
						order by
							ar.sequence
					) ar
				outer apply
					(	select	top (1)
								childActivity = ar2.code
						,		childPart = ar2.part
						,		childGT = ar2.group_location
						,		childLevel = xr.BOMLevel
						from
							FT.XRt xr
							join dbo.activity_router ar2
								on ar2.part = xr.ChildPart
						where
							xr.TopPart = p.part
					) childar
			where
				p.part = @PartCode
			for xml raw('Part'), type
		)

--- </Body>

---	<Return>
	return
		@result
end
GO
