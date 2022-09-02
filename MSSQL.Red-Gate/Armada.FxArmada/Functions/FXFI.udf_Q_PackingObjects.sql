SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FXFI].[udf_Q_PackingObjects]
(	@PackingJobNumber varchar(50)
)
returns xml
as
begin
--- <Body>
	declare
		@result xml
        
	set	@result =
		(	select
				pjo.PackingJobNumber
			,	pjo.Serial
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
						pjc.PackingJobNumber = pjh.PackingJobNumber
						and pjc.Status >= 0
						and pjc.ToSerial = pjo.Serial
					for xml raw ('Combines'), type
				)
			from
				FXPL.PackingJobObjects pjo
					join FXPL.PackingJobHeaders pjh on
						pjh.PackingJobNumber = pjo.PackingJobNumber
			where
				pjo.PackingJobNumber = @PackingJobNumber
				and pjo.Status >= 0
				and pjh.Status >= 0
			for xml raw('Objects'), type
			)

--- </Body>

---	<Return>
	return
		@result
end
GO
