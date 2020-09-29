SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_RemoveObject]
(	@Serial int,
	@Shipper int)
as
/*
Example:
begin transaction

declare	@ProcReturn int

execute	@ProcReturn = custom.usp_Shipping_RemoveObject
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
	begin transaction Shipping_RemoveObject
end
save transaction ShippingDock_RemoveObject
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Argument Validation:

--	I.	Stage object...
execute	@ProcReturn = msp_unstage_object
	@shipper = @Shipper,
	@serial = @Serial,
	@result = @ProcResult output

--	III.	Mark all objects as unverified.
update	object
set	custom5 = (case when part like 'CP%' or part like 'CT%' or part like 'EX%' or part = 'PALLET' then 'PKG' end)
where	shipper = @Shipper

update	shipper
set	status = 'O',
	scheduled_ship_time = null
where	id = @Shipper

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction Shipping_RemoveObject
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
execute	custom.usp_Shipping_ValidateSerial_forShipper
	@Serial = @Serial,
	@Shipper = @Shipper

GO
