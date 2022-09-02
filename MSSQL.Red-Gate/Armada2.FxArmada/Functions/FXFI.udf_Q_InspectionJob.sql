SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXFI].[udf_Q_InspectionJob]
(	@InspectionJobNumber varchar(50)
)
returns xml
as
begin
--- <Body>
	declare
		@result xml

	set @result =
		(	select
				ijh.InspectionJobNumber
			,	ijh.InspectionOperator
			,	ijh.InspectionStatus
			,	pjh.PackingJobNumber
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
			,	pjh.JobDoneFlag
			,	pjh.RowID
			,	FXFI.udf_Q_InspectionObjects(ijh.InspectionJobNumber)
			,	(	select
						ijhn.InspectionJobNumber
					,	ijhn.Note
					,	ijhn.CreatedByOperator
					,	CreateDT = ijhn.RowCreateDT
					,	NoteID = ijhn.RowID
					from
						FXFI.InspectionJobHeaderNotes ijhn
					where
						ijhn.InspectionJobNumber = ijh.InspectionJobNumber
						and ijhn.Status >= 0
					for xml raw ('Notes'), type
				)
			,	(	select
						ijhp.InspectionJobNumber
					,	ijhp.PictureFileGUID
					,	ijhp.PictureFileName
					,	ijhp.Note
					,	ijhp.CreatedByOperator
					,	CreateDT = ijhp.RowCreateDT
					,	PictureID = ijhp.RowID
					from
						FXFI.InspectionJobHeaderPictures ijhp
					where
						ijhp.InspectionJobNumber = ijh.InspectionJobNumber
						and ijhp.Status >= 0
					for xml raw ('Pictures'), type
				)
			,	(	select
			 			ib.PartCode
					,	ib.PictureFileName
					,	ib.PictureFileGUID
					,	ib.Note
					,	ib.CreatedByOperator
					,	ib.RemovedByOperator
					,	CreateDT = ib.RowCreateDT
					,	BulletinID = ib.RowID
			 		from
			 			FXFI.InspectionBulletins ib
					where
						ib.PartCode = pjh.PartCode
						and ib.Status >= 0
					for xml	raw ('Bulletins'), type
			 	)
			from
				FXFI.InspectionJobHeaders ijh
				join FXPL.PackingJobHeaders pjh
					on pjh.PackingJobNumber = ijh.PackingJobNumber
			where
				ijh.InspectionJobNumber = @InspectionJobNumber
				and ijh.Status = 0
			for xml raw('InspectionJob')
		)

--- </Body>

---	<Return>
	return
		@result
end
GO
