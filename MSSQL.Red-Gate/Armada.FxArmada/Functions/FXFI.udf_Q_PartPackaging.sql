SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXFI].[udf_Q_PartPackaging]
(	@PartCode varchar(25)
,	@PackageCode varchar(25)
)
returns xml
as
begin
--- <Body>
	declare
		@result xml
        
	set	@result =
		(	select
				PartCode = pp.part
			,	PackageCode	= pm.code
			,	PackageDescription = pm.name
			,	StandardPack = pp.quantity
			,	SpecialInstructions = pp.SpecialInstructions
			from
				dbo.part_packaging pp
				join dbo.package_materials pm
					on pm.code = pp.code
			where
				pp.part = @PartCode
				and pp.code = @PackageCode
			for xml raw('PartPackaging'), type
		)

--- </Body>

---	<Return>
	return
		@result
end
GO
