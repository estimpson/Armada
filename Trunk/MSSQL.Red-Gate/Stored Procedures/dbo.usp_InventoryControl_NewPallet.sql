SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[usp_InventoryControl_NewPallet]
	@User varchar(5)
,	@Location varchar(10)
,	@PackageCode varchar(20) = null
,	@Notes varchar(254) = null
,	@WorkOrder varchar(10) = null
,	@PalletCount int = 1
,	@PalletSerial int out
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
/*	Get a new serial. */
--- <Call>	
set	@CallProcName = 'monitor.usp_NewSerialBlock'
execute
	@ProcReturn = monitor.usp_NewSerialBlock
		@SerialBlockSize = @PalletCount
	,	@FirstNewSerial = @PalletSerial out
	,	@Result = @ProcResult out
	
set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

/*	Create new object(s). */
--- <Insert rows="n">
set	@TableName = 'dbo.object'

insert
	dbo.object
(	serial
,	part
,	location
,	last_date
,	unit_measure
,	operator
,	status
,	quantity
,	plant
,	std_quantity
,	package_type
,	last_time
,	user_defined_status
,	type
,	workorder
)
select
	@PalletSerial + urSerial.RowNumber - 1
,	'PALLET'
,	@Location
,	@TranDT
,	null
,	@User
,	'A'
,	null
,	(select l.plant from dbo.location l where l.code = @Location)
,	null
,	package_type = @PackageCode
,	@TranDT
,	'Approved'
,	'S'
,	workorder = @workOrder
from
	dbo.udf_Rows(@PalletCount) urSerial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != @PalletCount begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, @PalletCount)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Create new audit trail.  */
declare
	@TranType char(1) = 'P'
,	@Remark varchar(10) = 'New Pallet'
--- <Insert rows="n">
set	@TableName = 'dbo.audit_trail'

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	operator
,	from_loc
,	to_loc
,	lot
,	weight
,	status
,	unit
,	std_quantity
,	plant
,	notes
,	package_type
,	std_cost
,	user_defined_status
,	tare_weight
,	workorder
)	
select
	o.serial
,	o.last_date
,	@TranType
,	o.part
,	0
,	@Remark
,	o.operator
,	o.location
,	o.location
,	o.lot
,	o.weight
,	o.status
,	o.unit_measure
,	o.std_quantity
,	o.plant
,	@Notes
,	o.package_type
,	o.cost
,	o.user_defined_status
,	o.tare_weight
,	o.workorder
from
	dbo.object o
where
	o.serial between @PalletSerial and @PalletSerial + @PalletCount - 1

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != @PalletCount begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, @PalletCount)
	rollback tran @ProcName
	return
end
--- </Insert>
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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_StageBox
	@Param1 = @Param1
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
