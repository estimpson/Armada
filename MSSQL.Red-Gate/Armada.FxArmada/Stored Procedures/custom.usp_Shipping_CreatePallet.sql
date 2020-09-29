SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [custom].[usp_Shipping_CreatePallet]
(	@Operator varchar (10)
--<Debug>
	, @Debug integer = 0
--</Debug>
)
as
/*
Example:
begin transaction

declare	@ProcReturn int

create table #PalletSerial
(	PalletSerial int)

insert	#PalletSerial
execute	@ProcReturn = custom.usp_Shipping_CreatePallet
	@Operator = 'MON'

select	@ProcReturn

select	*
from	object
where	serial in
	(	select	PalletSerial
		from	#PalletSerial)

select	*
from	audit_trail
where	serial in
	(	select	PalletSerial
		from	#PalletSerial)

rollback
:End Example
*/
set nocount on

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction Shipping_CreatePallet
end
save transaction Shipping_CreatePallet
--</Tran>

--	Argument Validation:
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	rollback tran Shipping_CreatePallet
	RAISERROR (60001, 16, 1, @Operator)
	select	null
	return
end

--	Declarations:
declare	@PalletSerial int,
	@Part varchar (25),
	@Quantity int,
	@WeekNo int,
	@Unit char (2),
	@Status char (1),
	@UserStatus varchar (10),
	@ObjectType char (1),
	@Location varchar (20),
	@Plant varchar (20),
	@TranType char (1),
	@Remark varchar (10),
	@Notes varchar (50)

set	@Part = 'PALLET'
set @Quantity = 1
set	@WeekNo = DatePart (week, GetDate ())
set	@Unit = 'EA'
set	@Status = 'A'
set	@UserStatus = 'APPROVED'
set	@ObjectType = 'S'
set	@Location = ''
set	@Plant = ''
set	@TranType = 'P'
set	@Remark = 'New Pallet'
set	@Notes = 'RF Shipping Dock new pallet.'

--	I.	Get next serial number.
--<Debug>
if	@Debug & 1 = 1 begin
	print	'I.	Get a block of serial numbers.'
end
--</Debug>
select	@PalletSerial = next_serial
from	parameters with (TABLOCKX)

while	exists
	(	select	serial
		from	object
		where	serial between @PalletSerial and @PalletSerial) or
	exists
	(	select	serial
		from	audit_trail
		where	serial between @PalletSerial and @PalletSerial) begin

	set	@PalletSerial = @PalletSerial + 1
end

update	parameters
set	next_serial = @PalletSerial + 1

--	II.	Create pallet.
--		B.	Create object.
insert	object
(	serial,
	part,
	quantity,
	location,
	last_date,
	unit_measure,
	operator,
	status,
	plant,
	last_time,
	user_defined_status,
	type)
select	@PalletSerial,
	@Part,
	@Quantity,
	@Location,
	GetDate (),
	@Unit,
	@Operator,
	@Status,
	@Plant,
	GetDate (),
	@UserStatus,
	@ObjectType

--		C.	Create pallet.
insert	audit_trail
(	serial,
	date_stamp,
	type,
	part,
	quantity,
	remarks,
	operator,
	from_loc,
	to_loc,
	weight,
	status,
	unit,
	std_quantity,
	plant,
	notes,
	package_type,
	std_cost,
	user_defined_status,
	tare_weight)
select	object.serial,
	object.last_date,
	@TranType,
	object.part,
	object.quantity,
	@Remark,
	object.operator,
	object.location,
	object.location,
	object.weight,
	object.status,
	object.unit_measure,
	object.std_quantity,
	object.plant,
	@Notes,
	object.package_type,
	object.cost,
	object.user_defined_status,
	object.tare_weight
from	object object
where	object.serial = @PalletSerial

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction Shipping_CreatePallet
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
select	@PalletSerial

GO
