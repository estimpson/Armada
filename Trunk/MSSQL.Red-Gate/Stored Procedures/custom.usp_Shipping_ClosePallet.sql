SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [custom].[usp_Shipping_ClosePallet]
	@PalletSerial int
,	@Shipper int
as
/*
Example:
begin transaction

declare	@ProcReturn int

execute	@ProcReturn = custom.usp_Shipping_ClosePallet
	@PalletSerial = 235320,
	@Shipper = 88180

go

--resume

rollback
:End Example
*/
set nocount on

--<Tran Required=Yes AutoCreate=Yes>
declare
	@TranCount smallint

select
    @TranCount = @@TranCount

if	@TranCount = 0 begin
    begin transaction Shipping_ClosePallet
end
save transaction Shipping_ClosePallet
--</Tran>

--<Error Handling>
declare
    @ProcReturn integer
,   @ProcResult integer
,   @Error integer
,   @RowCount integer
--</Error Handling>

--	Print pallet label...
insert
	dbo.print_queue
(	printed
,	serial_number
,	server_name
,	label_format
)
select
    printed = 0
,   serial_number = @PalletSerial
,   server_name = 'LBLSRV'
,   label_format = coalesce
		(	(	select
					min(order_header.pallet_label)
				from
					shipper_detail
					join order_header
						on shipper_detail.order_no = order_header.order_no
				where
					shipper_detail.shipper = @Shipper
					and shipper_detail.part_original = coalesce
					(	(	select
								max(part)
							from
								object
							where
								parent_serial = @PalletSerial
						)
					,	shipper_detail.part_original
					)
			)
		,	'PALLET'
		)
where
	exists
		(	select
				*
			from
				dbo.object o
			where
				o.parent_serial = @PalletSerial
		)

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction Shipping_ClosePallet
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
execute
	custom.usp_Shipping_ValidateSerial_forShipper
    @Serial = @PalletSerial
,   @Shipper = @Shipper
GO
