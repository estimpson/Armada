SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_MES_BFHist_GetPartBOM]
	@TopPart varchar(25) = null
,	@WorkOrderNumber varchar(50) = null
,	@WorkOrderDetailLine float = null
,	@BackflushNumber varchar(50) = null
,	@Mode tinyint = 3 --1 full structure, configured values, running.
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
if	@Mode = 1 begin
	select
		mbhpr.TopPart
	,   mbhpr.TempWIP
	,   mbhpr.MachineList
	,   mbhpr.VendorList
	,   BOMComponent = space(mbhpr.BOMLevel * 3) + mbhpr.ChildPart
	,	mbhpr.ChildPart
	,   mbhpr.BOMID
	,   mbhpr.Sequence
	,   mbhpr.BOMLevel
	,   mbhpr.XQty
	,   mbhpr.XScrap
	,   mbhpr.XBufferTime
	,   mbhpr.XRunRate
	,   mbhpr.Hierarchy
	,   mbhpr.Infinite
	from
		dbo.MES_BFHist_PartRouter mbhpr
	where
		mbhpr.TopPart = coalesce
			(	@TopPart
			,	(	select
		 				max(wod.PartCode)
		 			from
		 				dbo.WorkOrderDetails wod
					where
						wod.WorkOrderNumber = @WorkOrderNumber
						and wod.Line = coalesce(@WorkOrderDetailLine, wod.Line)
		 		)
			,	(	select
		 				bh.PartProduced
		 			from
		 				dbo.BackflushHeaders bh
					where
						bh.BackflushNumber = @BackflushNumber
		 		)
			)
	order by
		mbhpr.Sequence
end
else if
	@Mode = 2 begin

	select
		TopPart = xr.TopPart
	,	TempWIP = case when p.type = 'T' then 1 else 0 end
	,	MachineList =
		(	select
 				FX.ToList(pm.machine)
 			from
 				dbo.part_machine pm
			where
				pm.part = xr.ChildPart
 		)
	,	VendorList =
		(	select
 				FX.ToList(pv.vendor)
 			from
 				dbo.part_vendor pv
			where
				pv.part = xr.ChildPart
 		)
	,   BOMComponent = space(xr.BOMLevel * 3) + xr.ChildPart
	,	xr.ChildPart
	,   xr.BOMID
	,   xr.Sequence
	,   xr.BOMLevel
	,   xr.XQty
	,   xr.XScrap
	,   xr.XBufferTime
	,   xr.XRunRate
	,   xr.Hierarchy
	,   xr.Infinite
	from
		FT.XRt xr
		left join dbo.part p
			on p.part = xr.ChildPart
		left join custom.Scheduling_InLineProcess silp
			on silp.TopPartCode = xr.TopPart
			and xr.Hierarchy like silp.Hierarchy + '%'
			and xr.BOMLevel = silp.BOMLevel + 1
		left join custom.Scheduling_InLineProcess silp2
			 on silp2.TopPartCode = xr.TopPart
			 and silp2.Sequence = xr.Sequence
		join dbo.WorkOrderDetails wod
			on wod.PartCode = xr.TopPart
	where
		(	WorkOrderNumber = @WorkOrderNumber
			and	Line = coalesce(@WorkOrderDetailLine, wod.Line)
		)
		and
		(	silp.ChildPartCode is not null
			or xr.Sequence = 0
		)
	order by
		wod.WorkOrderNumber
	,	wod.Line
	,	xr.Sequence
end
else if
	@Mode = 3 begin

	select
		TopPart = mjl.PartCode
	,	TempWIP = case when mjbom.Status = 4 then 1 else 0 end
	,	MachineList =
		(	select
 				FX.ToList(pm.machine)
 			from
 				dbo.part_machine pm
			where
				pm.part = mjbom.ChildPart
 		)
	,	VendorList =
		(	select
 				FX.ToList(pv.vendor)
 			from
 				dbo.part_vendor pv
			where
				pv.part = mjbom.ChildPart
 		)
	,   BOMComponent = space(xr.BOMLevel* 3) + mjbom.ChildPart
	,	xr.ChildPart
	,   xr.BOMID
	,   xr.Sequence
	,   xr.BOMLevel
	,   XQty = mjbom.XQty
	,   XScrap = mjbom.XScrap
	,   xr.XBufferTime
	,   xr.XRunRate
	,   xr.Hierarchy
	,   xr.Infinite
	from
		dbo.MES_JobList mjl
		join dbo.MES_JobBillOfMaterials mjbom
			on mjbom.WODID = mjl.WODID
		left join FT.XRt xr
			on xr.TopPart = mjl.PartCode
			and xr.Sequence = mjbom.ChildPartSequence
	where
		(	mjl.WorkOrderNumber = @WorkOrderNumber
			and	mjl.WorkOrderDetailLine = coalesce(@WorkOrderDetailLine, mjl.WorkOrderDetailLine)
		)
	union all
	select
		TopPart = mjl.PartCode
	,	TempWIP = 0
	,	MachineList =
		(	select
 				FX.ToList(pm.machine)
 			from
 				dbo.part_machine pm
			where
				pm.part = mjl.PartCode
 		)
	,	VendorList =
		(	select
 				FX.ToList(pv.vendor)
 			from
 				dbo.part_vendor pv
			where
				pv.part = mjl.PartCode
 		)
	,   BOMComponent = space(xr.BOMLevel* 3) + xr.ChildPart
	,	xr.ChildPart
	,   xr.BOMID
	,   xr.Sequence
	,   xr.BOMLevel
	,   xr.XQty
	,   xr.XScrap
	,   xr.XBufferTime
	,   xr.XRunRate
	,   xr.Hierarchy
	,   xr.Infinite
	from
		dbo.MES_JobList mjl
		left join FT.XRt xr
			on xr.TopPart = mjl.PartCode
			and xr.Sequence = 0
	where
		(	mjl.WorkOrderNumber = @WorkOrderNumber
			and	mjl.WorkOrderDetailLine = coalesce(@WorkOrderDetailLine, mjl.WorkOrderDetailLine)
		)
	order by
		8
end
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
	@TopPart varchar(25) = null
,	@WorkOrderNumber varchar(50) = null
,	@WorkOrderDetailLine float = null
,	@BackflushNumber varchar(50) = null

set	@BackflushNumber = 'BF_0000022634'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_MES_BFHist_GetPartBOM
	@BackflushNumber = @BackflushNumber
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
