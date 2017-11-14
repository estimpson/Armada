SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_MES_BFHist_GetRecentWorkorderHistory]
	@RecentDT datetime
,	@WorkOrderNumber varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
select
	bh.BackflushNumber
,   bh.WorkOrderNumber
,   bh.WorkOrderDetailLine
,   bh.PartProduced
,   bh.SerialProduced
,	bh.TranDT
,   bh.QtyProduced
,	MissingComponentCount = count(distinct case when bd.QtyOverage > 0 then bd.PartConsumed end)
,	MissingComponents = FX.ToList(distinct case when bd.QtyOverage > 0 then bd.PartConsumed end)
from
	dbo.BackflushHeaders bh
	join dbo.BackflushDetails bd
		on bd.BackflushNumber = bh.BackflushNumber
where
	bh.TranDT > @RecentDT
	and bh.WorkOrderNumber = @WorkOrderNumber
group by
	bh.BackflushNumber
,   bh.WorkOrderNumber
,   bh.WorkOrderDetailLine
,   bh.PartProduced
,   bh.SerialProduced
,	bh.TranDT
,   bh.QtyProduced
order by
	1
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@RecentDT datetime
,	@WorkOrderNumber varchar(50)

set	@RecentDT = '2014-03-10'
set @WorkOrderNumber = 'WO_000000423'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_MES_BFHist_GetRecentWorkorderHistory
	@RecentDT = @RecentDT
,	@WorkOrderNumber = @WorkOrderNumber
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
