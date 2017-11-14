SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [custom].[usp_Shipping_StageBox]
(	@BoxSerial INT,
	@PalletSerial INT,
	@Shipper INT)
AS
/*
Example:
begin transaction

declare	@ProcReturn int

execute	@ProcReturn = custom.usp_Shipping_StageBox
	@BoxSerial = 235320,
	@PalletSerial = null,
	@Shipper = 88180

select	*
from	object
where	shipper = 88180
go

--resume

rollback
:End Example
*/
SET NOCOUNT ON

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT
SELECT	@TranCount = @@TranCount
IF	@TranCount = 0 BEGIN
	BEGIN TRANSACTION Shipping_StageBox
END
SAVE TRANSACTION Shipping_StageBox
--</Tran>

--<Error Handling>
DECLARE	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error INTEGER,
	@RowCount INTEGER
--</Error Handling>

--	Argument Validation:
IF	@PalletSerial <= 0 BEGIN
	SELECT	@PalletSerial = NULL
END

--	I.	Stage object...
EXECUTE	@ProcReturn = msp_stage_object
	@shipper = @Shipper,
	@serial = @BoxSerial,
	@parent_serial = @PalletSerial,
	@create_sd = 'N',
	@pkg_override = NULL,
	@result = @ProcResult OUTPUT

--	II.	Mark all objects (except pallets) as unverified.
UPDATE	object
SET	custom5 = (CASE WHEN part LIKE 'CP%' OR part LIKE 'CT%' OR part LIKE 'EX%' OR part = 'PALLET' OR part = '00000EXP' THEN 'PKG' END),
	destination = (SELECT destination FROM shipper WHERE id = @Shipper)
WHERE	shipper = @Shipper

UPDATE	shipper
SET	scheduled_ship_time = NULL
WHERE	id = @Shipper

UPDATE	shipper
SET	status = 'S'
WHERE	id = @Shipper AND
	NOT EXISTS
	(	SELECT	1
		FROM	shipper_detail
		WHERE	shipper = @Shipper AND
			ISNULL (qty_packed, -1) < qty_required)

--	III.	Print box label...
INSERT dbo.print_queue
(
	printed
,	serial_number
,	label_format
,	server_name
)
SELECT
	printed = 0
,	serial_number = @BoxSerial
,	label_format = order_header.box_label
,	server_name = 'LBLSRV'
FROM	shipper_detail
	JOIN order_header ON shipper_detail.order_no = order_header.order_no
WHERE	shipper_detail.shipper = @Shipper AND
	shipper_detail.part_original IN (SELECT part FROM object WHERE serial = @BoxSerial)


--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION Shipping_StageBox
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
EXECUTE	custom.usp_Shipping_ValidateSerial_forShipper
	@Serial = @BoxSerial,
	@Shipper = @Shipper


GO
