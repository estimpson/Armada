SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[usp_Maint_RebuildHighFragIndexes]
as
create table
	#HighFragIndexes
(	RebuildStatement nvarchar(max)
)

execute
	master..sp_foreachdb
	@command = '
use ?;
declare
	@dbid int = db_id();
insert
	#HighFragIndexes
select distinct
	N''
use ?;alter index all on ['' + schema_name(o.schema_id) + N''].['' + o.name + N''] rebuild with (sort_in_tempdb = on);''
from
	sys.dm_db_index_physical_stats(@dbid,null,null,null,null) as a
	join sys.indexes as b
		on a.object_id = b.object_id
		and a.index_id = b.index_id
	join sys.objects o
		on o.object_id = a.object_id
where
	o.schema_id != 4
	and b.name is not null
	and a.avg_fragmentation_in_percent > 30
	and a.page_count > 10;'

declare
	highFragIndexes cursor local forward_only for
select
	*
from
	#HighFragIndexes hfi

open
	highFragIndexes

while
	1 = 1 begin
	
	declare
		@rebuildStatement nvarchar(max)
	
	fetch
		highFragIndexes
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
	highFragIndexes
deallocate
	highFragIndexes
GO
