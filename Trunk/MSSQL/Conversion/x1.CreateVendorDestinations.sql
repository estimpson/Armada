
select
	*
from
	dbo.destination d
where
	d.destination in
	(	select
			v.code
		from
			dbo.vendor v
	)

insert
	dbo.destination
(	destination
,	name
,	address_1
,	address_2
,	address_3
,	vendor
,	address_4
,	address_5
,	address_6
,	default_currency_unit
,	cs_status
)
select
	destination = v.code
,	v.name
,	v.address_1
,	v.address_2
,	v.address_3
,	vendor = v.code
,	v.address_4
,	v.address_5
,	v.address_6
,	v.default_currency_unit
,	cs_status = 'Approved'
from
	dbo.vendor v
where
	v.code not in
	(	select
			d.destination
		from
			dbo.destination d
	)