truncate table
	FT.Users
go

insert
	FT.Users
(	OperatorCode
)
select
	e.operator_code
from
	dbo.employee e

select
	*
from
	FT.Users u