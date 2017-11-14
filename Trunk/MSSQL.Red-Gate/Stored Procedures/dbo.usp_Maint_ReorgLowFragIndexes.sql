SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[usp_Maint_ReorgLowFragIndexes]
as
create table
	#LowFragIndexes
(	ReorganizeStatement nvarchar(max)
)

execute
	master..sp_foreachdb
	@command = '
use ?;
declare
	@dbid int = db_id();
insert
	#LowFragIndexes
select distinct
	N''
use ?;alter index all on ['' + schema_name(o.schema_id) + N''].['' + o.name + N''] reorganize;''
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
	and a.avg_fragmentation_in_percent between 5 and 30
	and a.page_count > 10;'

declare
	lowFragIndexes cursor local forward_only for
select
	*
from
	#LowFragIndexes hfi

open
	lowFragIndexes

while
	1 = 1 begin
	
	declare
		@reorganizeStatement nvarchar(max)
	
	fetch
		lowFragIndexes
	into
		@reorganizeStatement
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	execute
		master..sp_sqlexec
		@reorganizeStatement
	
	print
		@reorganizeStatement
end

close
	lowFragIndexes
deallocate
	lowFragIndexes
GO
