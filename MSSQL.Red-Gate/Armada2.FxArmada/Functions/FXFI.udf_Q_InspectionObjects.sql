SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXFI].[udf_Q_InspectionObjects]
(	@InspectionJobNumber varchar(50)
)
returns xml
as
begin
--- <Body>
	declare
		@result xml
        
	set	@result =
		(	select
				ijo.InspectionJobNumber
			,	ijo.Serial
			,	ijo.InspectionStatus
			--,	FXPL.udf_Q_Part(pjh.PartCode)
			,	QuantityCompleted = pjo.Quantity
			,	QuantityAfterCombine =
					(	select top(1)
							pjc.ToNewQuantity
						from
							FXPL.PackingJobCombines pjc
						where
							pjc.PackingJobNumber = pjo.PackingJobNumber
							and pjc.ToSerial = pjo.Serial
							and pjc.Status >= 0
						order by
							pjc.RowID desc
					)
			,	pjo.Printed
			,	pjo.RowID
			,	(	select
						ijon.InspectionJobNumber
					,	ijon.Serial
					,	ijon.Note
					,	ijon.CreatedByOperator
					,	CreateDT = ijon.RowCreateDT
					,	NoteID = ijon.RowID
					from
						FXFI.InspectionJobObjectNotes ijon
					where
						ijon.InspectionJobNumber = ijh.InspectionJobNumber
						and ijon.Serial = ijo.Serial
						and ijon.Status >= 0
					for xml raw ('Notes'), type
				)
			,	(	select
						ijop.InspectionJobNumber
					,	ijop.Serial
					,	ijop.PictureFileGUID
					,	ijop.PictureFileName
					,	ijop.Note
					,	ijop.CreatedByOperator
					,	CreateDT = ijop.RowCreateDT
					,	PictureID = ijop.RowID
					from
						FXFI.InspectionJobObjectPictures ijop
					where
						ijop.InspectionJobNumber = ijh.InspectionJobNumber
						and ijop.Serial = ijo.Serial
						and ijop.Status >= 0
					for xml raw ('Pictures'), type
				)
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
						pjc.PackingJobNumber = ijh.PackingJobNumber
						and pjc.Status >= 0
						and pjc.ToSerial = pjo.Serial
					for xml raw ('Combines'), type
				)
			from
				FXFI.InspectionJobObjects ijo
				join FXFI.InspectionJobHeaders ijh
					on ijh.InspectionJobNumber = ijo.InspectionJobNumber
				join FXPL.PackingJobHeaders pjh
					on pjh.PackingJobNumber = ijh.PackingJobNumber
				join FXPL.PackingJobObjects pjo
					on pjo.PackingJobNumber = ijh.PackingJobNumber
					and pjo.Serial = ijo.Serial
			where
				ijo.InspectionJobNumber = @InspectionJobNumber
				and pjo.Status >= 0
			for xml raw('Objects'), type
			)

--- </Body>

---	<Return>
	return
		@result
end
GO
