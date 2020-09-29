SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[usp_Maint_RebuildDroppedColumnTables]
as
create table
	#DroppedColumnTables
(	RebuildStatement nvarchar(max)
)

execute
	master..sp_foreachdb
	@command = '
use ?;
declare
	@dbid int = db_id();
insert
	#DroppedColumnTables
select distinct
	N''
use ?;alter index all on ['' + schema_name(o.schema_id) + N''].['' + o.name + N''] rebuild with (sort_in_tempdb = on);''
from
	sys.system_internals_partitions p
	join sys.objects o
		on p.object_id = o.object_id
	join sys.system_internals_partition_columns pc
		on p.partition_id = pc.partition_id
where
	pc.is_dropped = 1'

declare
	droppedColumnTables cursor local forward_only for
select
	*
from
	#DroppedColumnTables hfi

open
	droppedColumnTables

while
	1 = 1 begin
	
	declare
		@rebuildStatement nvarchar(max)
	
	fetch
		droppedColumnTables
	into
		@rebuildStatement
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	execute
		master..sp_sqlexec
		@rebuildStatement
	
	print
		@rebuildStatement
end

close
	droppedColumnTables
deallocate
	droppedColumnTables
GO
