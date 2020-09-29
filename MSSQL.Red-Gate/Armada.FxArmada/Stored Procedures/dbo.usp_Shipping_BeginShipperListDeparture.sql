SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_Shipping_BeginShipperListDeparture]
	@User varchar(5)
,	@ShipperNumberList varchar(8000)
,	@TruckNumber varchar(30)
,	@PRONumber varchar(35)
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
--- <Call>	
set	@CallProcName = 'dbo.usp_Shipping_VerifyShipperListForDeparture'
execute
	@ProcReturn = dbo.usp_Shipping_VerifyShipperListForDeparture
		@User = @User
	,	@ShipperNumberList = @ShipperNumberList
	,	@TranDT = @TranDT out
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

---	</ArgumentValidation>

--- <Body>
declare
	@shipperList table
(	ShipperNumber varchar(50)
,	LegacyShipperID int
)

insert
	@shipperList
select
	ShipperNumber = shippers.ShipperNumber
,	LegacyShipperID = substring(shippers.ShipperNumber, 2, len(shippers.ShipperNumber) - 1)
from
	(	select
			ShipperNumber = ltrim(fsstr.Value)
		from
			dbo.fn_SplitStringToRows(@ShipperNumberList, ',') fsstr
		where
			ltrim(fsstr.Value) > ''
	) shippers
group by
	shippers.ShipperNumber

/*	Set the status of the shipper to D (departing). */
--- <Update rows="1+">
set	@TableName = 'dbo.shipper'

update
	s
set
	status = 'D'
,	truck_number = @TruckNumber
,	pro_number = @PRONumber
,	operator = @User
from
	dbo.shipper s
	join @shipperList sl
		on s.id = sl.LegacyShipperID

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>

/*	(Re)create Shipping Objects records. */
--- <Delete rows="*">
set	@TableName = 'dbo.Shipping_Objects'

delete
	so
from
	dbo.Shipping_Objects so
		join @shipperList sl
			on so.ShipperNumber = sl.ShipperNumber

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>

--- <Insert rows="1+">
set	@TableName = 'dbo.Shipping_Objects'

insert
	dbo.Shipping_Objects
(	ShipperNumber
,	Serial
,	Type
,	ParentSerial
,	LabelPrintDT
)
select
	ShipperNumber = 'L' + convert(varchar(49), o.shipper)
,	Serial = o.serial
,	Type =
		case
			when o.Type = 'S' then 2
			when o.parent_serial > 0 then 3
			else 1
		end
,	ParentSerial = o.parent_serial
,	LabelPrinnull= null
from
	dbo.object o
		join @shipperList sl
			on o.shipper = sl.LegacyShipperID

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
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
	@User varchar(5)
,	@ShipperNumberList varchar(8000)

set	@User = 'EES'
set	@ShipperNumberList = 'L1050514,'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_BeginShipperListDeparture
	@User = @User
,	@ShipperNumberList = @ShipperNumberList
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
