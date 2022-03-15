SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [EDI5050].[CurrentPlanningReleases]
()
returns @CurrentPlanningReleases table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(50)
,	AuxShipToCode varchar(50)
,	ShipFromCode varchar(50)
,	ConsigneeCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerPOLine varchar(30)
,	CustomerModelYear varchar(50)
,	NewDocument int
,	BlanketOrderNo numeric(8,0)
)
as
begin
	--- <Body>
	insert
		@CurrentPlanningReleases
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ShipFromCode
	,	ConsigneeCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	NewDocument
	,	BlanketOrderNo
	)
	select
		curr.RawDocumentGUID
	,	curr.ReleaseNo
	,	curr.ShipToCode
	,	curr.AuxShipToCode
	,	curr.ShipFromCode
	,	curr.ConsigneeCode
	,	curr.CustomerPart
	,	curr.CustomerPO
	,	curr.CustomerPOLine
	,	curr.CustomerModelYear
	,	curr.NewDocument
	,	bo.BlanketOrderNo
	from
		(	select
				ph.RawDocumentGUID
			,	pr.ReleaseNo
			,	pr.ShipToCode
			,	pr.AuxShipToCode
			,	pr.ShipFromCode
			,	pr.ConsigneeCode
			,	pr.CustomerPart
			,	pr.CustomerPO
			,	pr.CustomerPOLine
			,	pr.CustomerModelYear
			,	NewDocument = case when ph.Status = 0 then 1 else 0 end
			,	RowNumber = row_number() over
					(	partition by
							pr.ShipToCode
						,	pr.AuxShipToCode
						,	pr.ShipFromCode
						,	pr.ConsigneeCode
						,	pr.CustomerPart
						,	pr.CustomerPO
						,	pr.CustomerModelYear
						order by
							ph.DocumentImportDT desc
						,	ph.DocumentDT desc
						,	ph.DocNumber desc
						,	ph.ControlNumber desc
					)
			from
				EDI5050.PlanningHeaders ph
				cross apply
					(	select
							ReleaseNo = coalesce(pr.ReleaseNo, '')
						,	pr.ShipToCode
						,	AuxShipToCode = coalesce(pr.AuxShipToCode, '')
						,	ShipFromCode = coalesce(pr.ShipFromCode, '')
						,	ConsigneeCode = coalesce(pr.ConsigneeCode, '')
						,	pr.CustomerPart
						,	CustomerPO = coalesce(pr.CustomerPO, '')
						,	CustomerPOLine = coalesce(pr.CustomerPOLine, '')
						,	CustomerModelYear = coalesce(pr.CustomerModelYear, '')
						from
							EDI5050.PlanningReleases pr
						where
							pr.RawDocumentGUID = ph.RawDocumentGUID
						group by
							coalesce(pr.ReleaseNo, '')
						,	pr.ShipToCode
						,	coalesce(pr.AuxShipToCode, '')
						,	coalesce(pr.ShipFromCode, '')
						,	coalesce(pr.ConsigneeCode, '')
						,	pr.CustomerPart
						,	coalesce(pr.CustomerPO, '')
						,	coalesce(pr.CustomerPOLine, '')
						,	coalesce(pr.CustomerModelYear, '')
					) pr
			where
				ph.Status in
					(	0	--(select dbo.udf_StatusValue('EDI5050.ShipScheduleHeaders', 'Status', 'New'))
					,	1	--(select dbo.udf_StatusValue('EDI5050.ShipScheduleHeaders', 'Status', 'Active'))
					)
		) curr
	left join EDI5050.BlanketOrders bo
		on bo.EDIShipToCode = curr.ShipToCode
		and bo.AuxShipToCode = coalesce(curr.AuxShipToCode, '')
		and bo.CustomerPart = curr.CustomerPart
		and (bo.CheckCustomerPOPlanning = 0 or bo.CustomerPO = curr.CustomerPO)
		and (bo.CheckModelYearPlanning = 0 or bo.ModelYear830 = curr.CustomerModelYear)
		and bo.ActiveOrder = 1
	where
		curr.RowNumber = 1
	--- </Body>

	---	<Return>
	return
end
GO
