SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [custom].[usp_Shipping_StagePallet]
(	@PalletSerial int,
	@Shipper int)
as
/*
Example:
begin transaction

declare	@ProcReturn int

execute	@ProcReturn = custom.usp_Shipping_StagePallet
	@PalletSerial = 235320,
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
	begin transaction Shipping_StagePallet
end
save transaction Shipping_StagePallet
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Argument Validation:


--	I.	Stage object...
execute	@ProcReturn = msp_stage_object
	@shipper = @Shipper,
	@serial = @PalletSerial,
	@parent_serial = null,
	@create_sd = 'N',
	@pkg_override = null,
	@result = @ProcResult output

--	II.	Mark all objects (except pallets) as unverified.
update	object
set	custom5 = (case when part like 'CP%' or part like 'CT%' or part like 'EX%' or part = 'PALLET' or part = '00000EXP' then 'PKG' end),
	destination = (select destination from shipper where id = @Shipper)
where	shipper = @Shipper

update	shipper
set	scheduled_ship_time = null
where	id = @Shipper

update	shipper
set	status = 'S'
where	id = @Shipper and
	not exists
	(	select	1
		from	shipper_detail
		where	shipper = @Shipper and
			isnull (qty_packed, -1) < qty_required)


--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction RFShippingDock_StagePallet
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
execute	custom.usp_Shipping_ValidateSerial_forShipper
	@Serial = @PalletSerial,
	@Shipper = @Shipper

GO
