SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_Shipping_ScanToTruck_VerifySerial]
	@Operator varchar(5)
,	@TruckNumber varchar(50) = null
,	@ShipperNumber varchar(50) = null
,	@Serial int
,	@BoxCount int = null
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
/*	Validate Truck Number. */
if	not exists
		(	select
				*
			from
				dbo.Shipping_DepartingTruckList sdtl
			where
				sdtl.TruckNumber = coalesce(@TruckNumber, sdtl.TruckNumber)
		) begin
	set	@Result = 999999
	RAISERROR ('Error scanning object to truck in procedure %s.  Truck %s not departing.', 16, 1, @ProcName, @TruckNumber)
	rollback tran @ProcName
	return
end

/*	Validate Shipper Number. */
if	not exists
		(	select
				*
			from
				dbo.Shipping_DepartingShipperList sdsl
			where
				sdsl.ShipperNumber = coalesce(@ShipperNumber, sdsl.ShipperNumber)
		) begin
	set	@Result = 999999
	RAISERROR ('Error scanning object to truck in procedure %s.  Shipper %s not departing.', 16, 1, @ProcName, @ShipperNumber)
	rollback tran @ProcName
	return
end

/*	Validate Serial Number */
declare
	@type int

select
	@type = so.Type
from
	dbo.Shipping_Objects so
		join dbo.shipper sD
			on 'L' + convert(varchar(49), sd.id) = so.ShipperNumber
where
	sD.truck_number = coalesce(@TruckNumber, sD.truck_number)
	and so.ShipperNumber = coalesce(@ShipperNumber, so.ShipperNumber)
	and so.Serial = @Serial

/*	Not found...*/
if	coalesce(@type, -1) not in (1, 2, 3) begin

	set	@Result = 999999
	RAISERROR ('Error scanning object to truck in procedure %s.  Object %d not found.', 16, 1, @ProcName, @Serial)
	rollback tran @ProcName
	return
end

/*	Incorrect box count...*/
if	@type = 2
	and @BoxCount !=
		(	select
				count(*)
			from
				dbo.Shipping_Objects so
			where
				so.ShipperNumber = @ShipperNumber
				and so.ParentSerial = @Serial
		) begin

	set	@Result = 999999
	RAISERROR ('Error scanning object to truck in procedure %s.  Pallet %d does not have specified number of boxes.', 16, 1, @ProcName, @Serial)
	rollback tran @ProcName
	return
end

/*	Box on pallet scanned...*/
if	@type = 3 begin

	set	@Result = 999999
	RAISERROR ('Error scanning object to truck in procedure %s.  Object %d is a box on pallet.  Scan pallet instead.', 16, 1, @ProcName, @Serial)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>

--- <Body>
/*	Determine loose box or pallet. */
if	@type = 1 begin
	
	--- <Update rows="1">
	set	@TableName = 'dbo.Shipping_Objects'
	
	update
		so
	set
		Status = 1
	,	LoadingOperator = @Operator
	from
		dbo.Shipping_Objects so
			join dbo.shipper sD
				on 'L' + convert(varchar(49), sd.id) = so.ShipperNumber
	where
		sD.truck_number = coalesce(@TruckNumber, sD.truck_number)
		and so.ShipperNumber = coalesce(@ShipperNumber, so.ShipperNumber)
		and so.Serial = @Serial
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end
else if
	@type = 2 begin

	declare
		@expectedRows int
	set
		@expectedRows = @BoxCount + 1
	
	--- <Update rows="n">
	set	@TableName = 'dbo.Shipping_Objects'
	
	update
		so
	set
		Status = 1
	,	LoadingOperator = @Operator
	from
		dbo.Shipping_Objects so
		join dbo.shipper sD
			on 'L' + convert(varchar(49), sd.id) = so.ShipperNumber
	where
		sD.truck_number = coalesce(@TruckNumber, sD.truck_number)
		and so.ShipperNumber = coalesce(@ShipperNumber, so.ShipperNumber)
		and
		(	so.Serial = @Serial
			or so.ParentSerial = @Serial
		)
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != @expectedRows begin
		set	@Result = 999999
		RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, @expectedRows)
		rollback tran @ProcName
		return
	end
	--- </Update>
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
select
	*
from
	dbo.Shipping_ScantToTruckShipperList ssttsl
order by
	ssttsl.ShipperNumber

select
	*
from
	dbo.Shipping_ScantToTruckObjectList ssttol
order by
	ssttol.ShipperNumber
,	ssttol.Serial
}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@Operator varchar(5)
,	@ShipperNumber varchar(50)
,	@Serial int
,	@BoxCount int

set	@Operator = 'EES'
set	@ShipperNumber = 'L1050510'
set	@Serial = 1288269
set @BoxCount = 20

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_ScanToTruck_VerifySerial
	@Operator = @Operator
,	@ShipperNumber = @ShipperNumber
,	@Serial = @Serial
,	@BoxCount = @BoxCount
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	dbo.Shipping_ScantToTruckShipperList ssttsl
where
	ssttsl.ShipperNumber = @ShipperNumber

select
	*
from
	dbo.Shipping_ScantToTruckObjectList ssttol
where
	ssttol.ShipperNumber = @ShipperNumber
order by
	ssttol.ShipperNumber
,	ssttol.Serial
go

--commit
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
