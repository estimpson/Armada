SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[usp_InventoryControl_QuantityDiscrepancy]
	@Operator varchar(5)
,	@Serial int
,	@DeltaQty numeric(20,6)
,	@Notes varchar(254)
,	@TranDT datetime out
,	@Result integer out
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
save tran @ProcName
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
/*	If change in quantity is negative... */
if	@DeltaQty < 0 begin
/*		Create shortage audit trail. (i1) */
	declare
		@ShortageATType char(1)
	,	@ShortageATRemarks char(1)

	set	@ShortageATType = 'E'
	set @ShortageATRemarks = 'Shortage'

	--- <Insert rows="1">
	set	@TableName = 'dbo.audit_trail'

	insert
		dbo.audit_trail
	(
		serial
	,   date_stamp
	,   type
	,   part
	,   quantity
	,   remarks
	,   price
	,   salesman
	,   customer
	,   vendor
	,   po_number
	,   operator
	,   from_loc
	,   to_loc
	,   on_hand
	,   lot
	,   weight
	,   status
	,   shipper
	,   flag
	,   activity
	,   unit
	,   workorder
	,   std_quantity
	,   cost
	,   control_number
	,   custom1
	,   custom2
	,   custom3
	,   custom4
	,   custom5
	,   plant
	,   invoice_number
	,   notes
	,   gl_account
	,   package_type
	,   suffix
	,   due_date
	,   group_no
	,   sales_order
	,   release_no
	,   dropship_shipper
	,   std_cost
	,   user_defined_status
	,   engineering_level
	,   posted
	,   parent_serial
	,   origin
	,   destination
	,   sequence
	,   object_type
	,   part_name
	,   start_date
	,   field1
	,   field2
	,   show_on_shipper
	,   tare_weight
	,   kanban_number
	,   dimension_qty_string
	,   dim_qty_string_other
	,   varying_dimension_code
	)
	select
		serial = o.serial
	,   date_stamp = @TranDT
	,   type = @ShortageATType
	,   part = o.part
	,   quantity = dbo.udf_GetQtyFromStdQty(o.part, @DeltaQty, o.unit_measure)
	,   remarks = @ShortageATRemarks
	,   price = 0
	,   salesman = ''
	,   customer = o.customer
	,   vendor = ''
	,   po_number = o.po_number
	,   operator = @Operator
	,   from_loc = convert(varchar, @Serial)
	,   to_loc = o.location
	,   on_hand = dbo.udf_GetPartQtyOnHand(o.part) + @DeltaQty
	,   lot = o.lot
	,   weight = dbo.udf_GetPartNetWeight(o.part, @DeltaQty)
	,   status = o.status
	,   shipper = o.shipper
	,   flag = ''
	,   activity = ''
	,   unit = o.unit_measure
	,   workorder = o.workorder
	,   std_quantity = @DeltaQty
	,   cost = o.cost
	,   control_number = ''
	,   custom1 = o.custom1
	,   custom2 = o.custom2
	,   custom3 = o.custom3
	,   custom4 = o.custom4
	,   custom5 = o.custom5
	,   plant = o.plant
	,   invoice_number = ''
	,   notes = @Notes
	,   gl_account = ''
	,   package_type = o.package_type
	,   suffix = o.suffix
	,   due_date = o.date_due
	,   group_no = ''
	,   sales_order = ''
	,   release_no = ''
	,   dropship_shipper = 0
	,   std_cost = o.std_cost
	,   user_defined_status = o.user_defined_status
	,   engineering_level = o.engineering_level
	,   posted = o.posted
	,   parent_serial = o.parent_serial
	,   origin = o.origin
	,   destination = o.destination
	,   sequence = o.sequence
	,   object_type = o.type
	,   part_name = (select name from part where part = o.part)
	,   start_date = o.start_date
	,   field1 = o.field1
	,   field2 = o.field2
	,   show_on_shipper = o.show_on_shipper
	,   tare_weight = o.tare_weight
	,   kanban_number = o.kanban_number
	,   dimension_qty_string = o.dimension_qty_string
	,   dim_qty_string_other = o.dim_qty_string_other
	,   varying_dimension_code = o.varying_dimension_code
	from
		dbo.object o
	where
		serial = @Serial

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert>
end

/*	Else... */
else	begin

/*		Create excess audit trail. (i1) */
	declare
		@ExcessATType char(1)
	,	@ExcessATRemarks char(1)

	set	@ExcessATType = 'E'
	set @ExcessATRemarks = 'Excess'

	--- <Insert rows="1">
	set	@TableName = 'dbo.audit_trail'

	insert
		dbo.audit_trail
	(
		serial
	,   date_stamp
	,   type
	,   part
	,   quantity
	,   remarks
	,   price
	,   salesman
	,   customer
	,   vendor
	,   po_number
	,   operator
	,   from_loc
	,   to_loc
	,   on_hand
	,   lot
	,   weight
	,   status
	,   shipper
	,   flag
	,   activity
	,   unit
	,   workorder
	,   std_quantity
	,   cost
	,   control_number
	,   custom1
	,   custom2
	,   custom3
	,   custom4
	,   custom5
	,   plant
	,   invoice_number
	,   notes
	,   gl_account
	,   package_type
	,   suffix
	,   due_date
	,   group_no
	,   sales_order
	,   release_no
	,   dropship_shipper
	,   std_cost
	,   user_defined_status
	,   engineering_level
	,   posted
	,   parent_serial
	,   origin
	,   destination
	,   sequence
	,   object_type
	,   part_name
	,   start_date
	,   field1
	,   field2
	,   show_on_shipper
	,   tare_weight
	,   kanban_number
	,   dimension_qty_string
	,   dim_qty_string_other
	,   varying_dimension_code
	)
	select
		serial = o.serial
	,   date_stamp = @TranDT
	,   type = @ExcessATType
	,   part = o.part
	,   quantity = dbo.udf_GetQtyFromStdQty(o.part, @DeltaQty, o.unit_measure)
	,   remarks = @ExcessATRemarks
	,   price = 0
	,   salesman = ''
	,   customer = o.customer
	,   vendor = ''
	,   po_number = o.po_number
	,   operator = @Operator
	,   from_loc = convert(varchar, @Serial)
	,   to_loc = o.location
	,   on_hand = dbo.udf_GetPartQtyOnHand(o.part) + @DeltaQty
	,   lot = o.lot
	,   weight = dbo.udf_GetPartNetWeight(o.part, @DeltaQty)
	,   status = o.status
	,   shipper = o.shipper
	,   flag = ''
	,   activity = ''
	,   unit = o.unit_measure
	,   workorder = o.workorder
	,   std_quantity = @DeltaQty
	,   cost = o.cost
	,   control_number = ''
	,   custom1 = o.custom1
	,   custom2 = o.custom2
	,   custom3 = o.custom3
	,   custom4 = o.custom4
	,   custom5 = o.custom5
	,   plant = o.plant
	,   invoice_number = ''
	,   notes = @Notes
	,   gl_account = ''
	,   package_type = o.package_type
	,   suffix = o.suffix
	,   due_date = o.date_due
	,   group_no = ''
	,   sales_order = ''
	,   release_no = ''
	,   dropship_shipper = 0
	,   std_cost = o.std_cost
	,   user_defined_status = o.user_defined_status
	,   engineering_level = o.engineering_level
	,   posted = o.posted
	,   parent_serial = o.parent_serial
	,   origin = o.origin
	,   destination = o.destination
	,   sequence = o.sequence
	,   object_type = o.type
	,   part_name = (select name from part where part = o.part)
	,   start_date = o.start_date
	,   field1 = o.field1
	,   field2 = o.field2
	,   show_on_shipper = o.show_on_shipper
	,   tare_weight = o.tare_weight
	,   kanban_number = o.kanban_number
	,   dimension_qty_string = o.dimension_qty_string
	,   dim_qty_string_other = o.dim_qty_string_other
	,   varying_dimension_code = o.varying_dimension_code
	from
		dbo.object o
	where
		serial = @Serial

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert>
end

/*	Adjust object quantity. (u1) */
--- <Update rows="1">
set	@TableName = 'dbo.object'

update
	o
set
	std_quantity = std_quantity + @DeltaQty
,	quantity = dbo.udf_GetQtyFromStdQty(o.part, std_quantity + @DeltaQty, o.unit_measure)
,	weight = dbo.udf_GetPartNetWeight(o.part, std_quantity + @DeltaQty)
from
	dbo.object o
where
	serial = @Serial
	and
		std_quantity + @DeltaQty > 0

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

/*	Record part on hand. (dbo.usp_InventoryControl_UpdatePartOnHand) */
declare
	@partCode varchar(25)

set	@partCode =
	(
		select
			part
		from
			dbo.object o
		where
			serial = @Serial
	)

--- <Call>	
set	@CallProcName = 'dbo.usp_InventoryControl_UpdatePartOnHand'
execute
	@ProcReturn = dbo.usp_InventoryControl_UpdatePartOnHand
	@PartCode = @partCode
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

--- </Body>

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
	@ProcReturn = dbo.usp_InventoryControl_QuantityDiscrepancy
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
