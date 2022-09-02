SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [custom].[usp_Shipping_CreatePallet_forShipper]
(	@Shipper int)
as
/*
Example:
begin transaction

insert	#PalletSerial
execute	@ProcReturn = custom.usp_Shipping_CreatePallet_forShipper
	@Shipper = 88180

rollback
:End Example
*/
set nocount on

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
select	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction Shipping_CreatePallet_forShipper
end
save transaction Shipping_CreatePallet_forShipper
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Argument Validation:

--	Declarations:
declare	@Operator varchar (5),
	@PalletSerial int,
	@Part varchar (25),
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

select	@Operator = 'Mon'
select	@Part = 'PALLET'
select	@WeekNo = DatePart (week, GetDate ())
select	@Unit = 'EA'
select	@Status = 'A'
select	@UserStatus = 'APPROVED'
select	@ObjectType = 'S'
select	@Location = ''
select	@Plant = ''
select	@TranType = 'P'
select	@Remark = 'New Pallet'
select	@Notes = 'RF Shipping Dock new pallet.'


--	I.	Get next serial number.
	select	@PalletSerial = next_serial
	from	parameters

	while	exists
		(	select	serial
			from	object
			where	serial between @PalletSerial and @PalletSerial) or
		exists
		(	select	serial
			from	audit_trail
			where	serial between @PalletSerial and @PalletSerial) begin

		select	@PalletSerial = @PalletSerial + 1
	end

	update	parameters
	set	next_serial = @PalletSerial + 1

--	II.	Create pallet.
--		B.	Create object.
	insert	object
	(	serial,
		part,
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
		@TranCount,
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

--	III.	Stage pallet.
	execute	@ProcReturn = msp_stage_object
		@shipper = @Shipper,
		@serial = @PalletSerial,
		@parent_serial = null,
		@create_sd = 'N',
		@pkg_override = null,
		@result = @ProcResult output
		

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction Shipping_CreatePallet_forShipper
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
execute	custom.usp_Shipping_ValidateSerial_forShipper
	@Serial = @PalletSerial,
	@Shipper = @Shipper

GO
