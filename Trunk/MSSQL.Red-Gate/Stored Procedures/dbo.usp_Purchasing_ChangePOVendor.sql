SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_Purchasing_ChangePOVendor]
	@PONumber INT
,	@NewVendorCode VARCHAR(10)
,	@TranDT DATETIME OUT
,	@Result INTEGER OUT
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET	@Result = 999999

--- <Error Handling>
DECLARE
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error INTEGER,
	@RowCount INTEGER

SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
DECLARE
	@TranCount SMALLINT

SET	@TranCount = @@TranCount
IF	@TranCount = 0 BEGIN
	BEGIN TRAN @ProcName
END
SAVE TRAN @ProcName
SET	@TranDT = COALESCE(@TranDT, GETDATE())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
/*	Update purchase order header with the new vendor. (u1) */
--- <Update rows="1">
SET	@TableName = 'dbo.po_header'

UPDATE
	ph
SET
	vendor_code = @NewVendorCode
FROM
	dbo.po_header ph
WHERE
	ph.po_number = @PONumber

SELECT
	@Error = @@Error,
	@RowCount = @@Rowcount

IF	@Error != 0 BEGIN
	SET	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	ROLLBACK TRAN @ProcName
	RETURN
END
IF	@RowCount != 1 BEGIN
	SET	@Result = 999999
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	ROLLBACK TRAN @ProcName
	RETURN
END
--- </Update>

/*	Update purchase order details with the new vendor. (u*) */
--- <Update rows="*">
SET	@TableName = 'dbo.po_detail'

UPDATE
	pd
SET
	vendor_code = @NewVendorCode
FROM
	dbo.po_detail pd
WHERE
	po_number = @PONumber

SELECT
	@Error = @@Error,
	@RowCount = @@Rowcount

IF	@Error != 0 BEGIN
	SET	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	ROLLBACK TRAN @ProcName
	RETURN
END
--- </Update>

--- </Body>

---	<Return>
SET	@Result = 0
RETURN
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
	@ProcReturn = dbo.usp_Purchasing_ChangePOVendor
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
