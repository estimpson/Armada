SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[TableStructure]
as
select
	TableName = schema_name(t.schema_id) + '.' + t.name
,	ColOrder = c.column_id
,	Name = c.name
,	UserType = convert(smallint, columnproperty(c.object_id, c.name, 'oldusertype'))
,	Length = c.max_length
,	Prec = convert(smallint,
	  case when c.system_type_id in (34, 35, 99) then null
	  when c.system_type_id = 36 then c.precision
	  when c.max_length = -1 then -1
	  else odbcprec(c.system_type_id, c.max_length, c.precision) end)
,	Scale = odbcscale(c.system_type_id, scale)
,	IsNullable = c.is_nullable
,	IsIdentity = convert(smallint, c.is_identity)
from
	sys.columns c
	join sys.tables t
		on t.object_id = c.object_id
where
	objectproperty(c.object_id, 'IsUserTable') = 1
GO
