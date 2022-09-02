SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXFI].[udf_Q_CompletedPackingJobs]
()
returns xml
as
begin
--- <Body>
	declare
		@result xml

	set @result =
		(	select
				pjh.PackingJobNumber
			,	pjh.PackingOperator
			,	pjh.QualityBatchNumber
			,	FXFI.udf_Q_Part(pjh.PartCode)
			,	FXFI.udf_Q_PartPackaging(pjh.PartCode, pjh.PackagingCode)
			,	pjh.SpecialInstructions
			,	pjh.PieceWeightQuantity
			,	pjh.PieceWeight
			,	pjh.PieceWeightTolerance
			,	pjh.PieceWeightValid
			,	pjh.PieceWeightDiscrepancyNote
			,	pjh.DeflashOperator
			,	DeflashMachineCode = pjh.DeflashMachine
			,	pjh.CompleteBoxes
			,	pjh.PartialBoxQuantity
			,	pjh.ShelfInventoryFlag
			,	pjh.RowID
			,	FXFI.udf_Q_PackingObjects(pjh.PackingJobNumber)
			from
				FXPL.PackingJobHeaders pjh
			where
				pjh.Status = 1
				and not exists
					(	select
							*
						from
							FXFI.InspectionJobHeaders ijh
						where
							ijh.PackingJobNumber = pjh.PackingJobNumber
							and ijh.Status > 0
					)
			for xml raw('CompletedPackingJob')
		)

--- </Body>

---	<Return>
	return
		@result
end
GO
