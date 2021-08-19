SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EDI5050].[CurrentShipSchedules]
()
returns @CurrentSS table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(50)
,	AuxShipToCode varchar(50)
,	ShipFromCode varchar(50)
,	ConsigneeCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerModelYear varchar(50)
,	NewDocument int
,	BlanketOrderNo numeric(8,0)
)
as
begin
	--- <Body>
	insert
		@CurrentSS
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ShipFromCode
	,	ConsigneeCode
	,	CustomerPart
	,	CustomerPO
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
	,	curr.CustomerModelYear
	,	curr.NewDocument
	,	bo.BlanketOrderNo
	from
		(	select
				ssh.RawDocumentGUID
			,	ss.ReleaseNo
			,	ss.ShipToCode
			,	ss.AuxShipToCode
			,	ss.ShipFromCode
			,	ss.ConsigneeCode
			,	ss.CustomerPart
			,	ss.CustomerPO
			,	ss.CustomerModelYear
			,	NewDocument = case when ssh.Status = 0 then 1 else 0 end
			,	RowNumber = row_number() over
					(	partition by
							ss.ShipToCode
						,	ss.AuxShipToCode
						,	ss.ShipFromCode
						,	ss.ConsigneeCode
						,	ss.CustomerPart
						,	ss.CustomerPO
						,	ss.CustomerModelYear
						order by
							ssh.DocumentImportDT desc
						,	ssh.DocumentDT desc
						,	ssh.DocNumber desc
						,	ssh.ControlNumber desc
					)
			from
				EDI5050.ShipScheduleHeaders ssh
				cross apply
					(	select
							ReleaseNo = coalesce(ss.ReleaseNo, '')
						,	ss.ShipToCode
						,	AuxShipToCode = coalesce(ss.AuxShipToCode, '')
						,	ShipFromCode = coalesce(ss.ShipFromCode, '')
						,	ConsigneeCode = coalesce(ss.ConsigneeCode, '')
						,	ss.CustomerPart
						,	CustomerPO = coalesce(ss.CustomerPO, '')
						,	CustomerModelYear = coalesce(ss.CustomerModelYear, '')
						from
							EDI5050.ShipSchedules ss
						where
							ss.RawDocumentGUID = ssh.RawDocumentGUID
						group by
							coalesce(ss.ReleaseNo, '')
						,	ss.ShipToCode
						,	coalesce(ss.AuxShipToCode, '')
						,	coalesce(ss.ShipFromCode, '')
						,	coalesce(ss.ConsigneeCode, '')
						,	ss.CustomerPart
						,	coalesce(ss.CustomerPO, '')
						,	coalesce(ss.CustomerModelYear, '')
					) ss
			where
				ssh.Status in
					(	0	--(select dbo.udf_StatusValue('EDI5050.ShipScheduleHeaders', 'Status', 'New'))
					,	1	--(select dbo.udf_StatusValue('EDI5050.ShipScheduleHeaders', 'Status', 'Active'))
					)
		) curr
	left join EDI5050.BlanketOrders bo
		on bo.ShipToCode = curr.ShipToCode
		and bo.AuxShipToCode = coalesce(curr.AuxShipToCode, '')
		and bo.CustomerPart = curr.CustomerPart
		and (bo.CheckCustomerPOShipSchedule = 0 or bo.CustomerPO = curr.CustomerPO)
		and (bo.CheckModelYearShipSchedule = 0 or bo.ModelYear830 = curr.CustomerModelYear)
		and bo.ActiveOrder = 1
	where
		curr.RowNumber = 1

	--- </Body>

	---	<Return>
	return
end
GO
