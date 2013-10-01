delete
	dbo.employee
where
	operator_code = 'EES'

insert
	dbo.employee
(	name
,	operator_code
,	password
,	serial_number
,	epassword
,	operatorlevel
)
select
	name = 'Eric Stimpson'
,	operator_code = 'EES'
,	password = '9646'
,	serial_number = null
,	epassword = null
,	operatorlevel = null

select
	*
from
	FT.Users u
where
	u.OperatorCode = 'EES'

