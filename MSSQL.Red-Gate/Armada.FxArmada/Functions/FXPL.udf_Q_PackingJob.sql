SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXPL].[udf_Q_PackingJob]
(	@PackingJobNumber varchar(50)
)
returns xml
as
begin
--- <Body>
	declare
		@result xml
        
	set	@result =
					coalesce
					(	(	select
								pjh.PackingJobNumber
							,	pjh.PackingOperator
							,	pjh.QualityBatchNumber
							,	pjh.PartCode
							,	pjh.PackagingCode
							,	pjh.SpecialInstructions
							,	pjh.PieceWeightQuantity
							,	pjh.PieceWeight
							,	pjh.PieceWeightTolerance
							,	pjh.PieceWeightValid
							,	pjh.PieceWeightDiscrepancyNote
							,	pjh.DeflashOperator
							,	pjh.DeflashMachine
							,	pjh.CompleteBoxes
							,	pjh.PartialBoxQuantity
							,	ShelfInventoryFlag = coalesce(pjh.ShelfInventoryFlag, -1)
							,	PreviousJobShelfInventoryFlag = coalesce
									(	(	select top(1)
												pjhPrev.ShelfInventoryFlag
											from
												FXPL.PackingJobHeaders pjhPrev
											where
												pjhPrev.PartCode = pjh.PartCode
												and pjhPrev.Status > 0
											order by
												pjhPrev.PackingCompleteDT desc
										)
									,	-1
									)
							,	pjh.RowID
							,	(	select
									pjo.PackingJobNumber
								,	pjo.Serial
								,	pjo.Quantity
								,	pjo.Printed
								,	pjo.RowID
								,	(	select
								 			pjc.PackingJobNumber
										,	pjc.FromSerial
										,	pjc.FromOriginalQuantity
										,	pjc.FromNewQuantity
										,	pjc.FromReprint
										,	pjc.ToSerial
										,	pjc.ToOriginalQuantity
										,	pjc.ToNewQuantity
										,	pjc.RowID
								 		from
								 			FXPL.PackingJobCombines pjc
										where
											pjc.PackingJobNumber = @PackingJobNumber
											and pjc.Status >= 0
											and pjc.ToSerial = pjo.Serial
										for xml raw ('Combines'), type
								 	)
								from
									FXPL.PackingJobObjects pjo
								where
									pjo.PackingJobNumber = @PackingJobNumber
									and pjo.Status >= 0
								for xml raw('Objects'), type
								)
							from
								FXPL.PackingJobHeaders pjh
							where
								pjh.PackingJobNumber = @PackingJobNumber
								and pjh.Status = 0
							for xml raw('PackingJob')
						),
						convert(xml, '<PackingJob></PackingJob>')
					)
--- </Body>

---	<Return>
	return
		@result
end
GO
