select
	*
from
	dbo.destination d
where
	d.name like '%NOVEM%'

select
	*
from
	dbo.edi_setups es
where
	es.destination in ('NOVCAN', 'NOVQUE', 'NOVTRO', 'NOVVOR')

select
	*
from
	dbo.shipper s
where
	s.destination in ('NOVCAN', 'NOVQUE', 'NOVTRO', 'NOVVOR')

exec usp_ShipNotice_NOVEM 367577

select
	*
from
	dbo.destination d
where
	d.name like 'FAURECIA%'

select
	*
from
	dbo.edi_setups es
where
	es.destination like 'FAU%'
