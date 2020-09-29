SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [custom].[usp_Shipping_VerifySerial]
(	@Serial int,
	@Shipper int)
as
/*
Example:
begin transaction

declare	@ProcReturn int

execute	@ProcReturn = custom.usp_Shipping_VerifySerial
	@Operator= 'mon',
	@Serial = 235320,
	@Shipper = 88180

select	*
from	object
where	shipper = 88180
go

--resume

rollback
:End Example
*/
set nocount on

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
select	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction Shipping_VerifySerial
end
save transaction Shipping_VerifySerial
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Argument Validation:
declare	@Operator varchar (5)

select	@Operator = 'mon'

update	object
set	custom5 = @Operator
where	serial = @Serial and
	shipper = @Shipper

update	shipper
set	status = 'S',
	scheduled_ship_time = getdate ()
where	id = @Shipper and
	not exists
	(	select	1
		from	object
		where	shipper = @Shipper and
			custom5 is null) and
	not exists
	(	select	1
		from	shipper_detail
		where	shipper = @Shipper and
			isnull (qty_packed, -1) < qty_required)

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction Shipping_VerifySerial
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
execute	custom.usp_Shipping_ValidateSerial_forShipper
	@Serial = @Serial,
	@Shipper = @Shipper

GO
