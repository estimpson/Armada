set nocount on
go

/*
	The following validates the template values and guarantees that a valid database
	was specified and that the connected user is a valid dbo.
*/
use FxArmada
go

declare	@error int; set @error = @@error
if	@error = 911 begin
	raiserror ('Database not found.  Reload script.', 20, 1) with LOG
end
else if	@error = 170 begin
	raiserror ('Before running, set template values using Ctrl+Shift+M.', 20, 1) with LOG
end
else if	@error = 102 begin
	raiserror ('Before running, set template values using Ctrl+Shift+M.', 20, 1) with LOG
end
else if	@error != 0 begin
	raiserror ('Unknown error running script.  Contact support.', 20, 1) with LOG
end
else if current_user != 'dbo' begin
	raiserror ('Script must be run by database owner.  Change login and run again.', 20, 1) with LOG
end
go

/*
Create view FxArmada.dbo.TableStructure
*/
if	objectproperty(object_id('dbo.TableStructure'), 'IsView') = 1 begin
	drop view dbo.TableStructure
end
go

create view dbo.TableStructure
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
go

use rawArmada
go

declare	@error int; set @error = @@error
if	@error = 911 begin
	raiserror ('Database not found.  Reload script.', 20, 1) with LOG
end
else if	@error = 170 begin
	raiserror ('Before running, set template values using Ctrl+Shift+M.', 20, 1) with LOG
end
else if	@error = 102 begin
	raiserror ('Before running, set template values using Ctrl+Shift+M.', 20, 1) with LOG
end
else if	@error != 0 begin
	raiserror ('Unknown error running script.  Contact support.', 20, 1) with LOG
end
else if current_user != 'dbo' begin
	raiserror ('Script must be run by database owner.  Change login and run again.', 20, 1) with LOG
end
go

/*
Create view rawArmada.dbo.RawStructure
*/
if	objectproperty(object_id('dbo.RawStructure'), 'IsView') = 1 begin
	drop view dbo.RawStructure
end
go

create view dbo.RawStructure
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
go

print 'use FxArmada'

/*
Generate insert statements for all tables that have matching definitions and contain identity columns.
*/

declare	@TableName sysname,
	@ColumnName sysname,
	@InsertIdentitySyntax nvarchar(max),
	@ColumnList nvarchar(max)

declare	IdentityTables cursor local for
select	TableStructure.TableName
from	(	select	TableName,
			TableChecksum = CHECKSUM_AGG(BINARY_CHECKSUM(*)),
			TableChecksumAlt = CHECKSUM_AGG(BINARY_CHECKSUM(TableName, colorder, name, usertype, length, prec, scale, isnullable))
		from	FxArmada.dbo.TableStructure TS
		group by
			TableName) TableStructure
	join
	(	select	TableName,
			TableChecksum = CHECKSUM_AGG(BINARY_CHECKSUM(*)),
			TableChecksumAlt = CHECKSUM_AGG(BINARY_CHECKSUM(TableName, colorder, name, usertype, length, prec, scale, isnullable))
		from	rawArmada.dbo.RawStructure RS
		group by
			TableName) RawStructure on TableStructure.TableName = RawStructure.TableName
where	TableStructure.TableChecksum != RawStructure.TableChecksum and
	TableStructure.TableChecksumAlt = RawStructure.TableChecksumAlt
order by
	1

open	IdentityTables

fetch	IdentityTables
into	@TableName

while	@@FETCH_STATUS = 0 begin
	
	set	@InsertIdentitySyntax = N'print	''Load table ' + @TableName + '''
alter table ' + @TableName + ' disable trigger all
go

set identity_insert ' + @TableName + ' on
go

truncate table ' + @TableName + '

insert	' + @TableName + '
(	'

	declare	TableColumns cursor local for
	select	name
	from	FxArmada.dbo.TableStructure TS
	where	TableName = @TableName
	order by
		colorder
	
	open	TableColumns
	
	fetch	TableColumns
	into	@ColumnName
		
	set	@InsertIdentitySyntax = @InsertIdentitySyntax + @ColumnName
	set	@ColumnList = @ColumnName
	
	fetch	TableColumns
	into	@ColumnName
		
	while	@@FETCH_STATUS = 0 begin
		set	@InsertIdentitySyntax = @InsertIdentitySyntax + ',' + @ColumnName
		set	@ColumnList = @ColumnList + ',' + @ColumnName
		
		fetch	TableColumns
		into	@ColumnName
	end
	
	close	TableColumns
	deallocate
		TableColumns
	
	set	@InsertIdentitySyntax = @InsertIdentitySyntax + ')
select	' + @ColumnList + '
from	rawArmada.' + @TableName + '
go

set identity_insert ' + @TableName + ' off
go

alter table ' + @TableName + ' enable trigger all
go

'
	
	print	@InsertIdentitySyntax
	
	fetch	IdentityTables
	into	@TableName
	
	set	@InsertIdentitySyntax = ''
end

close	IdentityTables
