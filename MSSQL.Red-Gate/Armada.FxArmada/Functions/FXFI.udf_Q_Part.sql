SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXFI].[udf_Q_Part]
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
			,	DefaultPackagingCode = defaultPack.code
			,	RequiresFinalInspection = 1
			,	DeflashMethod = 'MACHINE'
			from
				dbo.part p
				join dbo.part_inventory pInv
					on pInv.part = p.part
				cross apply
					(	select top (1)
							pp.quantity
						,	pm.code
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
