SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_ReceivingDock_SetRemainingQty_ofReceiverLines]
(	@ReceiverLineID INT,
	@StdPackQty NUMERIC(20,6),
	@RemainingQty NUMERIC(20,6),
	@Result INT OUTPUT)
AS
/*

begin tran Test
select
	*
from
	dbo.ReceiverLines rl
	join dbo.ReceiverObjects ro on
		rl.ReceiverLineID = ro.ReceiverLineID
where
	rl.ReceiverLineID = 163

execute	dbo.usp_ReceivingDock_SetRemainingQty_ofReceiverLines
	@ReceiverLineID = 163,
	@StdPackQty = 50,
	@RemainingQty = 8200,
	@Result = 0
	
select
	*
from
	dbo.ReceiverLines rl
	join dbo.ReceiverObjects ro on
		rl.ReceiverLineID = ro.ReceiverLineID
where
	rl.ReceiverLineID = 163

--commit
rollback tran Test

*/
SET NOCOUNT ON
SET	@Result = 999999

--- <Error Handling>
DECLARE
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error INTEGER,
	@RowCount INTEGER

SET	@ProcName = USER_NAME(OBJECTPROPERTY (@@procid, 'OwnerId')) + '.' + OBJECT_NAME (@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes>
DECLARE
	@TranCount SMALLINT
SET	@TranCount = @@TranCount
IF	@TranCount = 0 BEGIN
	BEGIN TRAN @ProcName
END
SAVE TRAN @ProcName
--- </Tran>

--	Argument transformations:
--	Get remaining quantity.
DECLARE
	@RemainingBalance NUMERIC(20,6)

SET
	@RemainingBalance =
	(	SELECT
			balance
		FROM
			dbo.po_detail pod
			JOIN dbo.ReceiverLines rl ON
				pod.po_number = rl.PONumber
			AND
				pod.part_number = rl.PartCode
			AND
				pod.row_id = rl.POLineNo
			AND
				pod.date_due = rl.POLineDueDate
		WHERE
			ReceiverLineID = @ReceiverLineID)

--	Set std pack qty.
UPDATE
	dbo.ReceiverLines
SET
	StdPackQty = @StdPackQty,
	RemainingBoxes = CEILING(@RemainingQty / @StdPackQty)
WHERE
	dbo.ReceiverLines.ReceiverLineID = @ReceiverLineID

--	Delete any non-received boxes.
DELETE
	dbo.ReceiverObjects
WHERE
	ReceiverLineID = @ReceiverLineID
	AND
		Status = 0

--	Renumber any received boxes.
UPDATE
	dbo.ReceiverObjects
SET
	[LineNo] =
	(	SELECT
			COUNT(1)
		FROM
			dbo.ReceiverObjects ro2
		WHERE
			ReceiverLineID = @ReceiverLineID
			AND
				[LineNo] <= dbo.ReceiverObjects.[LineNo])
WHERE
	ReceiverLineID = @ReceiverLineID

--	Re-insert remaining objects.
INSERT
	dbo.ReceiverObjects
(	ReceiverLineID
,	[LineNo]
,	PONumber
,	POLineNo
,	POLineDueDate
,	PartCode
,	PartDescription
,	EngineeringLevel
,	QtyObject
,	PackageType
,	Location
,	Plant
,	DrAccount
,	CrAccount)
SELECT
	rl.ReceiverLineID
,	[LineNo] = ObjectRows.RowNumber + COALESCE(
	(	SELECT
			MAX([LineNo])
		FROM
			dbo.ReceiverObjects ro2
		WHERE
			ReceiverLineID = @ReceiverLineID), 0)
,	PONumber = rl.PONumber
,	POLineNo = rl.POLineNo
,	POLineDueDate = rl.POLineDueDate
,	PartCode = rl.PartCode
,	PartDescription = NULL
,	EngineeringLevel = p.engineering_level
,	QtyObject = CASE WHEN ObjectRows.RowNumber * rl.StdPackQty <= @RemainingQty THEN rl.StdPackQty ELSE @RemainingQty % rl.StdPackQty END
,	PackageType = rl.PackageType
,	Location = CASE COALESCE(p.class, 'N') WHEN 'N' THEN '' ELSE COALESCE( l.code,l2.code,'') END
,	Plant = COALESCE((SELECT MAX(plant) FROM po_header WHERE po_number =rl.PONumber),l.plant)
,	DrAccount = p.gl_account_code
,	CrAccount = pp.gl_account_code
FROM
	dbo.ReceiverLines rl
	JOIN dbo.udf_Rows(1000) ObjectRows ON
		ObjectRows.RowNumber <= rl.RemainingBoxes
	LEFT JOIN dbo.part p ON rl.PartCode = p.part
	LEFT JOIN dbo.part_inventory pi ON rl.PartCode = pi.part
	LEFT JOIN dbo.location l ON pi.primary_location = l.code
	LEFT JOIN dbo.part_purchasing pp ON rl.PartCode = pp.part
	LEFT JOIN po_header poh ON poh.po_number = rl.PONumber
	LEFT JOIN location l2 ON l2.code = poh.plant
WHERE
	rl.ReceiverLineID = @ReceiverLineID

--- <CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRAN @ProcName
END
--- </CloseTran Required=Yes AutoCreate=Yes>

---	<Return>
SET	@Result = 0
RETURN	@Result
--- </Return>




GO
