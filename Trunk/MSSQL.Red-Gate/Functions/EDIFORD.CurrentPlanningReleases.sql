SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE FUNCTION [EDIFORD].[CurrentPlanningReleases]
()
RETURNS @CurrentPlanningReleases TABLE
(	RawDocumentGUID UNIQUEIDENTIFIER
,	ReleaseNo VARCHAR(50)
,	ShipToCode VARCHAR(15)
,	ShipFromCode VARCHAR(15)
,	ConsigneeCode VARCHAR(15)
,	CustomerPart VARCHAR(50)
,	CustomerPO VARCHAR(50)
,	CustomerModelYear VARCHAR(50)
,	NewDocument INT
)
AS
BEGIN
--- <Body>
	INSERT
		@CurrentPlanningReleases
	SELECT DISTINCT
		RawDocumentGUID = ph.RawDocumentGUID
	,	ReleaseNo = COALESCE(pr.ReleaseNo,'')
	,	ShipToCode = pr.ShipToCode
	,	ShipFromCode = COALESCE(pr.ShipFromCode,'')
	,	ConsigneeCode = COALESCE(pr.ConsigneeCode,'')
	,	CustomerPart = pr.CustomerPart
	,	CustomerPO = COALESCE(pr.CustomerPO,'')
	,	CustomerModelYear =  COALESCE(pr.CustomerModelYear,'')
	,	NewDocument =
			CASE
				WHEN ph.Status = 0 --(select dbo.udf_StatusValue('EDIFORD.PlanningHeaders', 'Status', 'New'))
					THEN 1
				ELSE 0
			END
	FROM
		(	SELECT
				ShipToCode = pr.ShipToCode
			,	ShipFromCode = COALESCE(pr.ShipFromCode,'')
			,	ConsigneeCode = ''
			,	CustomerPart = pr.CustomerPart
			,	CustomerPO = ''
			,	CustomerModelYear =  COALESCE(pr.CustomerModelYear,'')
			,	CheckLast = MAX
				(	  CONVERT(CHAR(20), ph.DocumentImportDT, 120)
					+ CONVERT(CHAR(20), ph.DocumentDT, 120)					
					+ CONVERT(CHAR(10), ph.DocNumber)
					+ CONVERT(CHAR(10), ph.ControlNumber)
					
				)
			FROM
				EDIFORD.PlanningHeaders ph
				JOIN EDIFORD.PlanningReleases pr
					ON pr.RawDocumentGUID = ph.RawDocumentGUID
			WHERE
				ph.Status IN
				(	0 --(select dbo.udf_StatusValue('EDIFORD.PlanningHeaders', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDIFORD.PlanningHeaders', 'Status', 'Active'))
				)
			GROUP BY
				pr.ShipToCode
			,	COALESCE(pr.ShipFromCode,'')
			,	pr.CustomerPart
			,	COALESCE(pr.CustomerModelYear,'')
		) cl
		JOIN EDIFORD.PlanningHeaders ph
			JOIN EDIFORD.PlanningReleases pr
				ON pr.RawDocumentGUID = ph.RawDocumentGUID
			ON 
						pr.ShipToCode = cl.ShipToCode
			AND COALESCE(pr.ShipFromCode, '') = cl.ShipFromCode
			AND pr.CustomerPart = cl.CustomerPart
			AND COALESCE(pr.CustomerModelYear,'') = cl.CustomerModelYear
			AND	(	CONVERT(CHAR(20), ph.DocumentImportDT, 120) 
						+ CONVERT(CHAR(20), ph.DocumentDT, 120)
						+ CONVERT(CHAR(10), ph.DocNumber)
					  + CONVERT(CHAR(10), ph.ControlNumber)
					
				) = cl.CheckLast
			LEFT JOIN
			EDIFord.BlanketOrders bo ON bo.EDIShipToCode = pr.ShipToCode
			WHERE ph.RowCreateDT>= DATEADD(dd, COALESCE(bo.PlanningReleaseHorizonDaysBack,-30), GETDATE())
			AND COALESCE(bo.ProcessPlanningRelease,1) = 1
--- </Body>

---	<Return>
	RETURN
END

GO
