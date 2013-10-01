insert
	FT.TypeDefn
(	TypeGUID
,	TypeTable
,	TypeColumn
,	TypeCode
,	TypeName
,	HelpText
)
select
	*
from
	FxSys.dbo.TypeDefn td

select
	*
from
	FT.TypeDefn td