
--	Remove duplicates caused by trailing space(s).
delete
	rawArmada.dbo.part_purchasing
where
	part + 'x' = '14185 x'

delete
	rawArmada.dbo.shipper_container
where
	convert(varchar, shipper) + container_type + 'x' in
		(	'75643 x'
		,	'75984 x'
		,	'55558 x')

delete
	rawArmada.dbo.xreport_library
where
	name + 'x' = 'TGUSA x'

delete
	rawArmada.dbo.activity_router
where
	parent_part + 'x' = '14185x'

