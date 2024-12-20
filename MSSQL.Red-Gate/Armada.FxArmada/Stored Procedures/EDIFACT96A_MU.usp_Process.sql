SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [EDIFACT96A_MU].[usp_Process]
	@TranDT DATETIME = NULL OUT
,	@Result INTEGER = NULL OUT
,	@Testing INT = 1
--<Debug>
,	@Debug INTEGER = 0
--</Debug>
AS
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET	@Result = 999999

--<Debug>
DECLARE	@ProcStartDT DATETIME
DECLARE	@StartDT DATETIME
IF @Debug & 1 = 1 BEGIN
	SET	@StartDT = GETDATE ()
	PRINT	'START.   ' + CONVERT (VARCHAR (50), @StartDT)
	SET	@ProcStartDT = GETDATE ()
END
--</Debug>

--- <Error Handling>
DECLARE
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error INTEGER,
	@RowCount INTEGER

SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. EDIFACT96A_MU.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
DECLARE
	@TranCount SMALLINT

SET	@TranCount = @@TranCount
IF	@TranCount = 0 BEGIN
	BEGIN TRAN @ProcName
END
ELSE BEGIN
	SAVE TRAN @ProcName
END
SET	@TranDT = COALESCE(@TranDT, GETDATE())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
--<Debug>
IF @Debug & 1 = 1 BEGIN
	PRINT	'Determine the current 830s and 862s.'
	PRINT	'	Active are all 862s for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).'
	SET	@StartDT = GETDATE ()
END
--</Debug>
/*	Determine the current 830s and 862s. */
/*		Active are all 862s for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).*/
DECLARE
	@Current862s TABLE
(	RawDocumentGUID UNIQUEIDENTIFIER
,	ReleaseNo VARCHAR(50)
,	ShipToCode VARCHAR(15)
,	ShipFromCode VARCHAR(15)
,	ConsigneeCode VARCHAR(15)
,	CustomerPart VARCHAR(35)
,	CustomerPO VARCHAR(35)
,	CustomerModelYear VARCHAR(35)
,	NewDocument INT
)

INSERT
	@Current862s
SELECT DISTINCT
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
FROM
	EDIFACT96A_MU.CurrentShipSchedules ()

--<Debug>
IF @Debug & 1 = 1 BEGIN
	PRINT	'	Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.'
END
--</Debug>
/*		Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.  */
DECLARE
	@Current830s TABLE
(	RawDocumentGUID UNIQUEIDENTIFIER
,	ReleaseNo VARCHAR(50)
,	ShipToCode VARCHAR(15)
,	ShipFromCode VARCHAR(15)
,	ConsigneeCode VARCHAR(15)
,	CustomerPart VARCHAR(35)
,	CustomerPO VARCHAR(35)
,	CustomerModelYear VARCHAR(35)
,	NewDocument INT
)

INSERT
	@Current830s
SELECT DISTINCT
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
FROM
	EDIFACT96A_MU.CurrentPlanningReleases ()

--<Debug>
if @Debug & 1 = 1 begin
	print	'...determined.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

/*		If the current 862s and 830s are already "Active", done. */
if	not exists
	(	select
			*
		from
			@Current862s cd
		where
			cd.NewDocument = 1
	)
	and not exists
	(	select
			*
		from
			@Current830s cd
		where
			cd.NewDocument = 1
	)
	and @Testing = 0 begin
	set @Result = 100
	rollback transaction @ProcName
	RETURN
END

--<Debug>
if @Debug & 1 = 1 begin
	print	'Mark "Active" 862s and 830s.'
	SET	@StartDT = GETDATE ()
END
--- <Update rows="*">
set	@TableName = 'EDIFACT96A_MU.SchipSchedules'

update
	ss
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.ShipSchedules', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDIFACT96A_MU.ShipSchedules', 'Status', 'Replaced'))
		end
from
	EDIFACT96A_MU.ShipSchedules ss
	left join @Current862s c
		on ss.RawDocumentGUID = c.RawDocumentGUID
		and ss.ShipToCode = c.ShipToCode
		and ss.CustomerPart = c.CustomerPart
		and coalesce(ss.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(ss.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')
where
	ss.Status in
	(	0 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	RETURN
END
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDIFACT96A_MU.ShipScheduleHeaders'

update
	ssh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDIFACT96A_MU.ShipSchedules ss
				where
					ss.RawDocumentGUID = ssh.RawDocumentGUID
					and ss.Status = 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDIFACT96A_MU.ShipScheduleHeaders ssh
where
	ssh.Status in
	(	0 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	RETURN
END
--- </Update>
--<Debug>
if @Debug & 1 = 1 begin
	print	'...marked.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

--- <Update rows="*">
set	@TableName = 'EDIFACT96A_MU.PlanningReleases'

update
	PR
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'Replaced'))
		end
from
	EDIFACT96A_MU.PlanningReleases PR
	left join @Current830s c
		on PR.RawDocumentGUID = c.RawDocumentGUID
		and PR.ShipToCode = c.ShipToCode
		and PR.CustomerPart = c.CustomerPart
		and coalesce(PR.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(PR.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')

where
	PR.Status in
	(	0 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	RETURN
END
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDIFACT96A_MU.PlanningHeaders'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDIFACT96A_MU.PlanningReleases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDIFACT96A_MU.PlanningHeaders fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	RETURN
END
--- </Update>
--<Debug>
if @Debug & 1 = 1 begin
	print	'...marked.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

if	@Testing > 1 begin
	select
		'ShipScheduleHeaders'

	select
		*
	from
		EDIFACT96A_MU.ShipScheduleHeaders fh

	select
		'PlanningHeaders'
		
	SELECT
		*
	FROM
		EDIFACT96A_MU.PlanningHeaders fh
END

--<Debug>
if @Debug & 1 = 1 begin
	print	'Write new releases.'
	print	'	Calculate raw releases from active 862s and 830s.'
	SET	@StartDT = GETDATE ()
END
--</Debug>
/*	Write new releases. */
/*		Calculate raw releases from active 862s and 830s. */
declare
	@RawReleases table
(	RowID int not null IDENTITY(1, 1) primary key
,	Status int default(0)
, ReleaseType int
,	OrderNo int
,	Type tinyint
,	ReleaseDT datetime
,	BlanketPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	CustomerPO varchar(20)
,	ModelYear varchar(4)
,	OrderUnit char(2)
,	QtyShipper numeric(20,6)
,	Line int
,	ReleaseNo varchar(30)
,	DockCode varchar(30) null
,	LineFeedCode varchar(30) null
,	ReserveLineFeedCode varchar(30) null
,	QtyRelease numeric(20,6)
,	StdQtyRelease numeric(20,6)
,	ReferenceAccum numeric(20,6)
,	CustomerAccum numeric(20,6)
,	RelPrior numeric(20,6)
,	RelPost numeric(20,6)
,	NewDocument int
,	unique
	(	OrderNo
	,	NewDocument
	,	RowID
	)
,	unique
	(	OrderNo
	,	RowID
	,	RelPost
	,	QtyRelease
	,	StdQtyRelease
	)
,	unique
	(	OrderNo
	,	Type
	,	RowID
	)
)

insert
	@RawReleases
(	ReleaseType
, OrderNo
,	Type
,	ReleaseDT
,	BlanketPart
,	CustomerPart
,	ShipToID
,	CustomerPO
,	ModelYear
,	OrderUnit
,	ReleaseNo
,	QtyRelease
,	StdQtyRelease
,	ReferenceAccum
,	CustomerAccum
,	NewDocument
)
/*		Add releases due today when behind and no release for today exists. */

Select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = ft.fn_TruncDate('dd', getdate())
,	BlanketPart = min(bo.PartCode)
,	CustomerPart = min(bo.CustomerPart)
,	ShipToID = min(bo.ShipToCode)
,	CustomerPO = min(bo.CustomerPO)
,	ModelYear = min(bo.ModelYear)
,	OrderUnit = min(bo.OrderUnit)
,	ReleaseNo = 'Accum Demand'
,	QtyRelease = 0
,	StdQtyRelease = 0
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then min(coalesce(convert(int,bo.AccumShipped),0))
												When 'C' 
												then min(coalesce(convert(int,fa.LastAccumQty),0))
												else min(coalesce(convert(int,bo.AccumShipped),0))
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then min(coalesce(convert(int,bo.AccumShipped),0))
												When 'P' 
												then min(coalesce(convert(int,faa.PriorCUM),0))
												else min(coalesce(convert(int,fa.LastAccumQty),0))
												end
	,	(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIFACT96A_MU.ShipScheduleHeaders fh
	join EDIFACT96A_MU.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIFACT96A_MU.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDIFACT96A_MU.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDIFACT96A_MU.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
		join
				(Select * From @Current862s) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = c.CustomerModelYear
				)
where
		not exists
		(	select
				*
			from
				EDIFACT96A_MU.ShipSchedules ss
			where
				ss.status = 1 and
				ss.RawDocumentGUID = c.RawDocumentGUID and
				ss.RawDocumentGUID = fr.RawDocumentGUID
				and ss.CustomerPart = fr.CustomerPart
				and ss.ShipToCode = fr.ShipToCode
				and	ss.ReleaseDT = ft.fn_TruncDate('dd', getdate())
		)
	and fh.Status = 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.ShipScheduleHeaders', 'Status', 'Active'))
	and		c.RawDocumentGUID = fr.RawDocumentGUID
group by
	bo.BlanketOrderNo
,	fh.RawDocumentGUID
, bo.ReferenceAccum
, bo.AdjustmentAccum 
having
					case bo.AdjustmentAccum 
												When 'N' 
												then min(coalesce(convert(int,bo.AccumShipped),0))
												When 'P' 
												then min(coalesce(convert(int,faa.PriorCUM),0))
												else min(coalesce(convert(int,fa.LastAccumQty),0))
												end > 
												case bo.ReferenceAccum 
												When 'N' 
												then min(coalesce(convert(int,bo.AccumShipped),0))
												When 'C' 
												then min(coalesce(convert(int,fa.LastAccumQty),0))
												else min(coalesce(convert(int,bo.AccumShipped),0))
												end

/*		862s. */
union all
select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,fa.LastAccumQty),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'P' 
												then coalesce(convert(int,faa.PriorCUM),0)
												else coalesce(convert(int,fa.LastAccumQty),0)
												end
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIFACT96A_MU.ShipScheduleHeaders fh
	join EDIFACT96A_MU.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIFACT96A_MU.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDIFACT96A_MU.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDIFACT96A_MU.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
		join
				(Select * From @Current862s) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = c.CustomerModelYear
				)
where		c.RawDocumentGUID = fr.RawDocumentGUID
and			fh.Status = 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.ShipScheduleHeaders', 'Status', 'Active'))
		

/*		830s. */
Union all
select
	ReleaseType = 2
,	OrderNo = bo.BlanketOrderNo
,	Type = (	case 
					when bo.PlanningFlag = 'P' then 2
					when bo.PlanningFlag = 'F' then 1
					when bo.planningFlag = 'A' and fr.ScheduleType not in ('C', 'A', 'Z') then 2
					else 1
					end
			  )
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = case  WHEN fr.suppliercode =  'A0144' then fr.Userdefined5 WHEN fr.suppliercode IN ( 'ARM701', 'ARM101' ) AND fr.Userdefined5 IS NOT NULL THEN fr.UserDefined5 ELSE fr.ReleaseNo end
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,bo.AccumShipped),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'P' 
												then coalesce(convert(int,bo.AccumShipped),0)
												else coalesce(convert(int,bo.AccumShipped),0) -- 
												end
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current830s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIFACT96A_MU.PlanningHeaders fh
	join EDIFACT96A_MU.PlanningReleases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIFACT96A_MU.PlanningAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDIFACT96A_MU.PlanningAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDIFACT96A_MU.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOPlanning = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearPlanning = 0
			or bo.ModelYear830 = fr.CustomerModelYear
		)
		join
				(Select * From @Current830s) c 
				on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearPlanning = 0
							or bo.ModelYear830  = c.CustomerModelYear
				)
where		c.RawDocumentGUID = fr.RawDocumentGUID
	and		fh.Status = 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningHeaders', 'Status', 'Active'))
	and		fr.Status = 1 --(select dbo.udf_StatusValue('EDIFACT96A_MU.PlanningReleases', 'Status', 'Active'))
	--and coalesce(nullif(fr.Scheduletype,''),'4') in ('4')
	
order by
		2,1,4

/*		Calculate orders to update. */
update
	rr
set
	NewDocument =
	(	select
			max(NewDocument)
		from
			@RawReleases rr2
		where
			rr2.OrderNo = rr.OrderNo
	)
from
	@RawReleases rr

if	@Testing = 0 begin
	delete
		rr
	from
		@RawReleases rr
	where
		rr.NewDocument = 0
end

--Andre S. Boulanger FT, LLC  - Remove planning rows that are due before last firm row
DELETE RRP   
FROM  @RawReleases RRP
OUTER APPLY ( SELECT TOP 1 ReleaseDT LastFirmDate FROM @RawReleases RRF WHERE RRF.OrderNo = RRP.OrderNo AND RRF.Type = 1 ORDER BY ReleaseDT DESC ) FirmReleases
WHERE RRP.Type = 2 AND RRP.ReleaseDT <= FirmReleases.LastFirmDate


update
	@RawReleases
set
	RelPost = CustomerAccum + coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and ReleaseType = rr.ReleaseType
			and	RowID <= rr.RowID), 0)
from
	@RawReleases rr

	
update
	@RawReleases
set
	RelPost =  coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and ReleaseType = rr.ReleaseType
			and	RowID <= rr.RowID
			AND ReleaseType = 2), 0) 
from
	@RawReleases rr
WHERE
	rr.ReleaseType = 2

/*		Calculate running cumulatives. */


update
	@RawReleases
set
	RelPost =  rr.relPost  + COALESCE(dbo.fn_GreaterOf(MaxFirmAccum.MaxSSAccum,RefPlanAccum.MaxPlnAccum) , rr.ReferenceAccum)
from
	@RawReleases rr
OUTER APPLY (SELECT TOP 1 rr3.RelPost MaxSSAccum FROM @RawReleases rr3 WHERE rr3.ReleaseType =  1 AND rr3.OrderNo = rr.OrderNo order BY rr3.RelPost desc ) AS MaxFirmAccum
OUTER APPLY (SELECT max(rr4.ReferenceAccum) MaxPlnAccum FROM @RawReleases rr4 WHERE rr4.ReleaseType =  2 AND rr4.OrderNo = rr.OrderNo ) AS RefPlanAccum
WHERE
	rr.ReleaseType = 2

	update
	rr
set
	RelPost = case when rr.ReferenceAccum > rr.RelPost then rr.ReferenceAccum else rr.RelPost end
from
	@RawReleases rr


update
	rr
set
	RelPrior = coalesce (
	(	select
			max(RelPost)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID < rr.RowID), ReferenceAccum)
from
	@RawReleases rr



		--For Armada Only..Update Release Number with Accum Increase if customer's accum causes the qty to be increased
	update
	rr
set
		releaseNo = 'Accum Increase'
from
	@RawReleases rr
where
		RelPost-RelPrior > QtyRelease



update
	rr
set
	QtyRelease = RelPost - RelPrior
,	StdQtyRelease = RelPost - RelPrior
from
	@RawReleases rr

update
	rr
set
	Status = -1
from
	@RawReleases rr
where
	QtyRelease <= 0


/* Move Planning Release dates beyond last Ship Schedule Date that has a quantity due*/
update
	rr
set
	ReleaseDT = dateadd(dd,1,(select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1and Status>-1))
from
	@RawReleases rr
where
	rr.ReleaseType = 2
	and rr.ReleaseDT <= (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1 and Status>-1)
/*	Calculate order line numbers and committed quantity. */
update
	rr
set	Line =
	(	select
			count(*)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID <= rr.RowID
			and Status = 0
	)
,	QtyShipper = shipSchedule.qtyRequired
from
	@RawReleases rr
	left join
	(	select
			orderNo = sd.order_no
		,	qtyRequired = sum(qty_required)
		from
			dbo.shipper_detail sd
			join dbo.shipper s
				on s.id = sd.shipper
		where 
			s.type is null
			and s.status in ('O', 'A', 'S')
		group by
			sd.order_no
	) shipSchedule
		on shipSchedule.orderNo = rr.OrderNo
where
	rr.status = 0

--<Debug>
if @Debug & 1 = 1 begin
	print	'	...calculated.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

--<Debug>
if @Debug & 1 = 1 begin
	print	'	Replace order detail.'
	SET	@StartDT = GETDATE ()
END
--</Debug>

if	@Testing = 2 begin
	select
		'@RawReleases'
	
	SELECT
		*
	FROM
		@RawReleases rr
END

/*		Replace order detail. */
if	@Testing = 0 begin

	if	objectproperty(object_id('dbo.order_detail_deleted'), 'IsTable') is not null begin
		drop table dbo.order_detail_deleted
	end
	select
		*
	into
		dbo.order_detail_deleted
	from
		dbo.order_detail od
	where
		od.order_no in (select OrderNo from @RawReleases)
	order by
		order_no
	,	due_date
	,	sequence
	
	--- <Delete rows="*">
	set	@TableName = 'dbo.order_detail'
	
	delete
		od
	from
		dbo.order_detail od
	where
		od.order_no in (select OrderNo from @RawReleases)
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		RETURN
	END
	--- </Delete>
	
	--- <Insert rows="*">
	set	@TableName = 'dbo.order_detail'
	
	insert
		dbo.order_detail
	(	order_no, sequence, part_number, product_name, type, quantity
	,	status, notes, unit, due_date, release_no, destination
	,	customer_part, row_id, flag, ship_type, packline_qty, packaging_type
	,	weight, plant, week_no, std_qty, our_cum, the_cum, price
	,	alternate_price, committed_qty
	)
	select
		order_no = rr.OrderNo
	,	sequence = rr.Line + coalesce((select max (sequence) from order_detail where order_no = rr.OrderNo), 0)
	,	part_number = rr.BlanketPart
	,	product_name = (select name from dbo.part where part = rr.BlanketPart)
	,	type = case rr.Type when 1 then 'F' when 2 then 'P' end
	,	quantity = rr.RelPost - rr.relPrior
	,	status = ''
	,	notes = 'Processed Date : '+ convert(varchar, getdate(), 120) + ' ~ ' + case rr.Type when 1 then 'EDI Processed Release' when 2 then 'EDI Processed Release' end
	,	unit = (select unit from order_header where order_no = rr.OrderNo)
	,	due_date = rr.ReleaseDT
	,	release_no = rr.ReleaseNo
	,	destination = rr.ShipToID
	,	customer_part = rr.CustomerPart
	,	row_id = rr.Line + coalesce((select max (row_id) from order_detail where order_no = rr.OrderNo), 0)
	,	flag = 1
	,	ship_type = 'N'
	,	packline_qty = 0
	,	packaging_type = bo.PackageType
	,	weight = (rr.RelPost - rr.relPrior) * bo.UnitWeight
	,	plant = (select plant from order_header where order_no = rr.OrderNo)
	,	week_no = datediff(wk, (select fiscal_year_begin from parameters), rr.ReleaseDT) + 1
	,	std_qty = rr.RelPost - rr.relPrior
	,	our_cum = rr.RelPrior
	,	the_cum = rr.RelPost
	,	price = (select price from order_header where order_no = rr.OrderNo)
	,	alternate_price = (select alternate_price from order_header where order_no = rr.OrderNo)
	,	committed_qty = coalesce
		(	case
				when rr.QtyShipper > rr.RelPost - bo.AccumShipped then rr.RelPost - rr.relPrior
				when rr.QtyShipper > rr.RelPrior - bo.AccumShipped then rr.QtyShipper - (rr.RelPrior - bo.AccumShipped)
			end
		,	0
		)
	from
		@RawReleases rr
		join EDIFACT96A_MU.BlanketOrders bo
			on bo.BlanketOrderNo = rr.OrderNo
	where
		rr.Status = 0
	order by
		1, 2
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		RETURN
	END
	--- </Insert>
	
	/*	Set dock code, line feed code, and reserve line feed code. */
	/*if  exists
		(	select
				*
			from
				dbo.order_header oh
				join EDIFACT96A_MU.PlanningHeaders fh
					join EDIFACT96A_MU.PlanningSupplemental ps
						on ps.RawDocumentGUID = fh.RawDocumentGUID
					join EDIFACT96A_MU.BlanketOrders bo
						on bo.EDIShipToCode = coalesce (ps.ConsigneeCode, ps.ShipToCode)
						and bo.CustomerPart = ps.CustomerPart
					on bo.BlanketOrderNo = oh.order_no
				join @Current830s c
					on ps.RawDocumentGUID = c.RawDocumentGUID
					and ps.ShipToCode = c.ShipToCode
					and coalesce(ps.ShipFromCode,'') = coalesce(c.ShipFromCode,'')
					and coalesce(ps.ConsigneeCode, '') = coalesce(c.ConsigneeCode, '')
					and ps.CustomerPart = c.CustomerPart
			where 
				coalesce(oh.dock_code,'') != coalesce(ps.UserDefined1, '')
				or coalesce(oh.line_feed_code,'') != coalesce(ps.UserDefined2,'')
				or coalesce(oh.zone_code,'') != coalesce(ps.UserDefined3,'')
		) or
		exists
		(	select
				*
			from
				dbo.order_header oh
				join EDIFACT96A_MU.ShipScheduleHeaders fh
					join EDIFACT96A_MU.ShipScheduleSupplemental sss
						on sss.RawDocumentGUID = fh.RawDocumentGUID
					join EDIFACT96A_MU.BlanketOrders bo
						on bo.EDIShipToCode = sss.ShipToCode
						and bo.CustomerPart = sss.CustomerPart
					on bo.BlanketOrderNo = oh.order_no
				join @Current862s c
					on sss.RawDocumentGUID = c.RawDocumentGUID
					and sss.ShipToCode = c.ShipToCode
					and sss.CustomerPart = c.CustomerPart
			where 
				coalesce(oh.dock_code,'') != coalesce(sss.UserDefined1, '')
				or coalesce(oh.line_feed_code,'') != coalesce(sss.UserDefined2,'')
				or coalesce(oh.zone_code,'') != coalesce(sss.UserDefined3,'')
		) begin
		*/
		/*
		insert
			EDIFACT96A_MU.LabelInfoHeader
		(	SystemDT
		)
		select
			@TranDT
		
		insert 	
			EDIFACT96A_MU.LabelInfoHeader
		(	HeaderTimeStamp
		,	OrderNo
		,	NewDockCode
		,	OldDockCode
		,	NewLineFeed
		,	OldLineFeed
		,	NewReserveLineFeed
		,	OldReserveLineFeed
		)
		select
			HeaderTimeStamp
		,	rr.OrderNo
		,	rr.DockCode
		,	oh.dock_code
		,	rr.LineFeedCode
		,	oh.line_feed_code
		,	rr.ReserveLineFeedCode
		,	oh.zone_code
		from
			dbo.order_header oh
			join @RawReleases rr
				on rr.OrderNo = oh.order_no
				   and rr.RowID =
				   (	select
							min(rr2.RowID)
						from
							@RawReleases rr2
						where
							rr2.OrderNo = oh.order_no
							and rr2.Type = 1
					)
			cross join
			(	select
					convert(int,@@DBTS) as HeaderTimeStamp
			) HeaderTimeStamp
		where
			coalesce(oh.dock_code,'') != coalesce(rr.DockCode,'')
			or coalesce(oh.line_feed_code,'') != coalesce(rr.LineFeedCode,'')
			or coalesce(oh.zone_code,'') != coalesce(rr.ReserveLineFeedCode,'')
		*/
		
		--- <Update rows="*">
		set	@TableName = 'dbo.order_header'
		
			--- <Update rows="*">
		set	@TableName = 'dbo.order_header'
		
		update
			oh
		set
			custom01 = rtrim(prs.UserDefined4)
		,	dock_code = rtrim(prs.UserDefined4)
		,	line_feed_code = rtrim(prs.UserDefined5)
		,	zone_code = rtrim(prs.UserDefined3)

		from
			dbo.order_header oh
		join
				EDIFACT96A_MU.blanketOrders bo
		on
				bo.BlanketOrderNo = oh.order_no
		join
				(Select * From @Current830s) cpr 
			on
				cpr.CustomerPart = bo.customerpart and
				cpr.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = cpr.CustomerPO
				)
					and	(	bo.CheckModelYearPlanning= 0
							or bo.ModelYear830 = cpr.CustomerModelYear
				)
		  join
				EDIFACT96A_MU.PlanningSupplemental prs
		on
				prs.RawDocumentGUID = cpr.RawDocumentGUID and
				prs.CustomerPart = cpr.CustomerPart and
				coalesce(prs.CustomerPO,'') = coalesce(cpr.CustomerPO,'') and
				coalesce(prs.CustomerModelYear,'') = coalesce(cpr.CustomerModelYear,'')  and
				prs.ShipToCode = cpr.ShipToCode
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			RETURN
		END
		
		--- <Update rows="*">
		set	@TableName = 'dbo.order_header'
		
		update
			oh
		set
			custom01 = rtrim(sss.UserDefined4)
		,	dock_code = rtrim(sss.UserDefined4)
		,	line_feed_code = rtrim(sss.UserDefined5)
		,	zone_code = rtrim(sss.UserDefined6)
		,	line11 = rtrim(sss.UserDefined11)
		,	line12 = rtrim(sss.UserDefined12)
		,	line13 = rtrim(sss.UserDefined13)
		,	line14 = rtrim(sss.UserDefined14)
		,	line15 = rtrim(sss.UserDefined15)
		,	line16 = rtrim(sss.UserDefined16)
		,	line17 = rtrim(sss.UserDefined17)
		from
			dbo.order_header oh
		join
				EDIFACT96A_MU.blanketOrders bo
		on
				bo.BlanketOrderNo = oh.order_no
		join
				(Select * From @Current862s) css 
			on
				css.CustomerPart = bo.customerpart and
				css.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = css.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = css.CustomerModelYear
				)
		  join
				EDIFACT96A_MU.ShipScheduleSupplemental sss
		on
				sss.RawDocumentGUID = css.RawDocumentGUID and
				sss.CustomerPart = css.CustomerPart and
				coalesce(sss.CustomerPO,'') = coalesce(css.CustomerPO,'') and
				coalesce(sss.CustomerModelYear,'') = coalesce(css.CustomerModelYear,'')  and
				sss.ShipToCode = css.ShipToCode
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		IF	@Error != 0 BEGIN
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			RETURN
		END
	END
	--- </Update>
--end
ELSE BEGIN
	if	@Testing > 1 begin
		select 'raw releases'
		
		select
			Type
		,	OrderNo
		,	BlanketPart
		,	CustomerPart
		,	ShipToID
		,	CustomerPO
		,	ModelYear
		,	OrderUnit
		,	QtyShipper
		,	Line
		,	ReleaseNo
		,	QtyRelease
		,	StdQtyRelease
		,	ReferenceAccum
		,	RelPrior
		,	RelPost
		,	ReleaseDT
		from
			@RawReleases
		order by
			OrderNo
		,	RowID
		
		select 'to be deleted'

		select
			od.*
		from
			dbo.order_detail od
		where
			od.order_no in (select OrderNo from @RawReleases)
		order by
			order_no
		,	due_date
		
		/*	to be inserted*/
		
		SELECT 'to be inserted'
	END
		
	SELECT
		order_no = rr.OrderNo
	,	sequence = rr.Line
	,	part_number = rr.BlanketPart
	,	product_name = (SELECT name FROM dbo.part WHERE part = rr.BlanketPart)
	,	type = CASE rr.Type WHEN 1 THEN 'F' WHEN 2 THEN 'P' END
	,	quantity = rr.RelPost - rr.relPrior
	,	status = ''
	,	notes = 'Processed Date : '+ CONVERT(VARCHAR, GETDATE(), 120) + ' ~ ' + CASE rr.Type WHEN 1 THEN 'EDI Processed Release' WHEN 2 THEN 'EDI Processed Release' END
	,	unit = (SELECT unit FROM order_header WHERE order_no = rr.OrderNo)
	,	due_date = rr.ReleaseDT
	,	release_no = rr.ReleaseNo
	,	destination = rr.ShipToID
	,	customer_part = rr.CustomerPart
	,	row_id = rr.Line
	,	flag = 1
	,	ship_type = 'N'
	,	packline_qty = 0
	,	packaging_type = bo.PackageType
	,	weight = (rr.RelPost - rr.relPrior) * bo.UnitWeight
	,	plant = (SELECT plant FROM order_header WHERE order_no = rr.OrderNo)
	,	week_no = DATEDIFF(wk, (SELECT fiscal_year_begin FROM parameters), rr.ReleaseDT) + 1
	,	std_qty = rr.RelPost - rr.relPrior
	,	our_cum = rr.RelPrior
	,	the_cum = rr.RelPost
	,	price = (SELECT price FROM order_header WHERE order_no = rr.OrderNo)
	,	alternate_price = (SELECT alternate_price FROM order_header WHERE order_no = rr.OrderNo)
	,	committed_qty = COALESCE
		(	CASE
				WHEN rr.QtyShipper > rr.RelPost - bo.AccumShipped THEN rr.RelPost - rr.relPrior
				WHEN rr.QtyShipper > rr.RelPrior - bo.AccumShipped THEN rr.QtyShipper - (rr.RelPrior - bo.AccumShipped)
			END
		,	0
		)
	FROM
		@RawReleases rr
		JOIN EDIFACT96A_MU.BlanketOrders bo
			ON bo.BlanketOrderNo = rr.OrderNo
	ORDER BY
		1, 2
END
--<Debug>
if @Debug & 1 = 1 begin
	print	'	...replaced.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>
--- </Body>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert (varchar, DateDiff (ms, @ProcStartDT, GetDate ())) + ' ms'
end
--</Debug>

--- <Closetran AutoRollback=Yes>
if	@TranCount = 0 begin
	rollback tran @ProcName
end
--- </Closetran>

---	<Return>
--if	@Testing != 0
--	and @@trancount > 0 begin
--	rollback tran @ProcName
--end
/* Start E-Mail Alerts and Exceptions*/

Declare @EDIOrdersAlert table (
	TradingPartner varchar(30) NULL,
	DocumentType varchar(30) NULL, --'PR - Planning Release; SS - ShipSchedule'
	AlertType varchar(100) NULL,
	ReleaseNo varchar(100) NULL,
	ShipToCode varchar(100) NULL,
	ConsigneeCode varchar(100) NULL,
	ShipFromCode varchar(100) NULL,
	CustomerPart varchar(100) NULL,
	CustomerPO varchar(100) NULL,
	CustomerModelYear varchar NULL,
	Description varchar (max)
	)
		
insert	
	@EDIOrdersAlert
(	TradingPartner,
	DocumentType,
	AlertType,
	ReleaseNo ,
	ShipToCode,
	ConsigneeCode,
	ShipFromCode,
	CustomerPart,
	CustomerPO,
	CustomerModelYear,
	Description 
)

Select
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  ' Exception'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Please Add Blanket Order to Fx and Reprocess EDI'
from
	@Current862s a
Where
		coalesce(a.newDocument,0) = 1
and not exists
( Select 1 from 
		EDIFACT96A_MU.ShipSchedules b
 Join 
	EDIFACT96A_MU.BlanketOrders bo on b.CustomerPart = bo.CustomerPart
and
	b.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = b.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = b.CustomerModelYear)
where
				a.RawDocumentGUID = b.RawDocumentGUID and
				a.CustomerPart = b.CustomerPart and
				a.ShipToCode = b.ShipToCode and
				coalesce(a.customerPO,'') = coalesce(b.CustomerPO,'') and
				coalesce(a.CustomerModelYear,'') = coalesce(b.CustomerModelYear,'')
)
union
Select
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' Exception'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Please Add Blanket Order to Fx and Reprocess EDI'
from
	@Current830s a
Where
		coalesce(a.newDocument,0) = 1
and not exists
( Select 1 from 
		EDIFACT96A_MU.PlanningReleases b
 Join 
	EDIFACT96A_MU.BlanketOrders bo on b.CustomerPart = bo.CustomerPart
and
	b.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = b.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = b.CustomerModelYear)
where
				a.RawDocumentGUID = b.RawDocumentGUID and
				a.CustomerPart = b.CustomerPart and
				a.ShipToCode = b.ShipToCode and
				coalesce(a.customerPO,'') = coalesce(b.CustomerPO,'') and
				coalesce(a.CustomerModelYear,'') = coalesce(b.CustomerModelYear,'')
)
union

--Orders Processed
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  ' OrderProcessed'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current862s a
	 Join 
	EDIFACT96A_MU.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = a.CustomerModelYear)
	Where
		coalesce(a.newDocument,0) = 1 

union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' OrderProcessed'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current830s a
	 Join 
	EDIFACT96A_MU.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = a.CustomerModelYear)
	Where
		coalesce(a.newDocument,0) = 1

--Accums Reporting
union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ convert(varchar(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ convert(varchar(15), coalesce(ssa.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ convert(varchar(15), coalesce(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ convert(varchar(15), coalesce(ssa.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ convert(varchar(15), coalesce(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ convert(varchar(15), coalesce(ssaa.PriorCUM,0))
from
	@Current862s a
	 Join 
	EDIFACT96A_MU.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = a.CustomerModelYear)
	left join
		EDIFACT96A_MU.ShipScheduleAccums ssa on 
		ssa.RawDocumentGUID = a.RawDocumentGUID and
		ssa.ShipToCode = a.ShipToCode and
		ssa.CustomerPart = a.CustomerPart and
		coalesce(ssa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(ssa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDIFACT96A_MU.ShipScheduleAuthAccums ssaa on 
		ssaa.RawDocumentGUID = a.RawDocumentGUID and
		ssaa.ShipToCode = a.ShipToCode and
		ssaa.CustomerPart = a.CustomerPart and
		coalesce(ssaa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(ssaa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
										
	Where
		coalesce(a.newDocument,0) = 1 and
		coalesce(bo.AccumShipped,0) != coalesce(ssa.LastAccumQty,0)


union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ convert(varchar(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ convert(varchar(15), coalesce(pra.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ convert(varchar(15), coalesce(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ convert(varchar(15), coalesce(pra.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ convert(varchar(15), coalesce(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ convert(varchar(15), coalesce(praa.PriorCUM,0))
from
	@Current830s  a
	 Join 
	EDIFACT96A_MU.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = a.CustomerModelYear)
	left join
		EDIFACT96A_MU.PlanningAccums pra on 
		pra.RawDocumentGUID = a.RawDocumentGUID and
		pra.ShipToCode = a.ShipToCode and
		pra.CustomerPart = a.CustomerPart and
		coalesce(pra.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(pra.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDIFACT96A_MU.PlanningAuthAccums praa on 
		praa.RawDocumentGUID = a.RawDocumentGUID and
		praa.ShipToCode = a.ShipToCode and
		praa.CustomerPart = a.CustomerPart and
		coalesce(praa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(praa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
										
	Where
		coalesce(a.newDocument,0) = 1 and
		coalesce(bo.AccumShipped,0) != coalesce(pra.LastAccumQty,0)


order by 1,2,5,4,7


--Update Order Header with Customer's Accum Received ---Armada Only

Update oh
		set oh.raw_cum = coalesce(ssa.LastAccumQty,0)
from
	@Current862s a
	 Join 
	EDIFACT96A_MU.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = a.CustomerModelYear)
	left join
		EDIFACT96A_MU.ShipScheduleAccums ssa on 
		ssa.RawDocumentGUID = a.RawDocumentGUID and
		ssa.ShipToCode = a.ShipToCode and
		ssa.CustomerPart = a.CustomerPart and
		coalesce(ssa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(ssa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDIFACT96A_MU.ShipScheduleAuthAccums ssaa on 
		ssaa.RawDocumentGUID = a.RawDocumentGUID and
		ssaa.ShipToCode = a.ShipToCode and
		ssaa.CustomerPart = a.CustomerPart and
		coalesce(ssaa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(ssaa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
join
		order_header oh on oh.order_no = bo.BlanketOrderNo
										
	Where
		coalesce(a.newDocument,0) = 1

Update oh
		set oh.fab_cum = 
			case bo.AdjustmentAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'P' 
												then coalesce(convert(int,praa.PriorCUM),0)
												else coalesce(convert(int,pra.LastAccumQty),0)
												END
from
	@Current830s  a
	 Join 
	EDIFACT96A_MU.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = a.CustomerModelYear)
	left join
		EDIFACT96A_MU.PlanningAccums pra on 
		pra.RawDocumentGUID = a.RawDocumentGUID and
		pra.ShipToCode = a.ShipToCode and
		pra.CustomerPart = a.CustomerPart and
		coalesce(pra.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(pra.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDIFACT96A_MU.PlanningAuthAccums praa on 
		praa.RawDocumentGUID = a.RawDocumentGUID and
		praa.ShipToCode = a.ShipToCode and
		praa.CustomerPart = a.CustomerPart and
		coalesce(praa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(praa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
join
		order_header oh on oh.order_no = bo.BlanketOrderNo										
	Where
		coalesce(a.newDocument,0) = 1

Select	*
into	#EDIAlerts
From	@EDIOrdersAlert

Select	TradingPartner ,
				DocumentType , --'PR - Planning Release; SS - ShipSchedule'
				AlertType ,
				ReleaseNo ,
				ShipToCode,
				ConsigneeCode ,				
				CustomerPart ,
				CustomerPO ,
				Description 
				
into	#EDIAlertsEmail
From	@EDIOrdersAlert


If Exists (Select 1 From #EDIAlerts)

Begin
		

		declare
			@html nvarchar(max),
			@EmailTableName sysname  = N'#EDIAlertsEmail'
		
		exec [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			,	@orderBy = N'AlertType'
			,	@html = @html OUTPUT
			,	@includeRowNumber = 0
			,	@camelCaseHeaders = 1
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'EDI Processing for EDIFACT96A_MU' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'FxArmadaMail1'-- sysname
	,		@recipients = 'czurawski@armadarubber.com' -- varchar(max)
	,		@copy_recipients = 'aboulanger@fore-thought.com' -- varchar(max)
	, 	@subject = @EmailHeader
	,  	@body = @EmailBody
	,  	@body_format = 'HTML'
	,		@importance = 'High' 
					

INSERT [EDIAlerts].[ProcessedReleases]

(	 EDIGroup
	,TradingPartner
	,DocumentType --'PR - Planning Release; SS - ShipSchedule'
	,AlertType 
	,ReleaseNo
	,ShipToCode
	,ConsigneeCode 
	,ShipFromCode 
	,CustomerPart
	,CustomerPO
	,CustomerModelYear
	,Description
)


SELECT 
	'EDIFACT96A_MU'
	,*
FROM
	#EDIAlerts
UNION
SELECT
	'EDIFACT96A_MU'
	,TradingPartner = COALESCE((SELECT MAX(TradingPartner) FROM fxEDI.EDI.EDIDocuments WHERE GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  'Exception Quantity Due'
,	ReleaseNo =  COALESCE(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  COALESCE(a.ConsigneeCode,'')
,	ShipFromCode = COALESCE(a.ShipFromCode,'')
,	CustomerPart = COALESCE(a.CustomerPart,'')
,	CustomerPO = COALESCE(a.CustomerPO,'')
,	CustomerModelYear = COALESCE(a.CustomerModelYear,'')
, Description = 'Qty Due : ' + CONVERT(VARCHAR(MAX), c.ReleaseQty) + ' on - ' + CONVERT(VARCHAR(MAX), c.ReleaseDT)
FROM
	@Current862s a
JOIN
		EDIFACT96A_MU.ShipSchedules c
ON			c.RawDocumentGUID = a.RawDocumentGUID AND
				a.CustomerPart = c.CustomerPart AND
				a.ShipToCode =c.ShipToCode AND
				COALESCE(a.customerPO,'') = COALESCE(c.CustomerPO,'') AND
				COALESCE(a.CustomerModelYear,'') = COALESCE(c.CustomerModelYear,'')
WHERE
		COALESCE(a.newDocument,0) = 1
AND NOT EXISTS
( SELECT 1 FROM 
		EDIFACT96A_MU.ShipSchedules b
 JOIN 
	EDIFACT96A_MU.BlanketOrders bo ON b.CustomerPart = bo.CustomerPart
AND
	b.ShipToCode = bo.EDIShipToCode
AND
(	bo.CheckCustomerPOShipSchedule = 0
	OR bo.CustomerPO = b.CustomerPO)
AND
(	bo.CheckModelYearShipSchedule = 0
	OR bo.ModelYear862 = b.CustomerModelYear)
WHERE
				a.RawDocumentGUID = b.RawDocumentGUID AND
				a.CustomerPart = b.CustomerPart AND
				a.ShipToCode = b.ShipToCode AND
				COALESCE(a.customerPO,'') = COALESCE(b.CustomerPO,'') AND
				COALESCE(a.CustomerModelYear,'') = COALESCE(b.CustomerModelYear,''))

UNION
SELECT
	'EDIFACT96A_MU'
	,TradingPartner = COALESCE((SELECT MAX(TradingPartner) FROM fxEDI.EDI.EDIDocuments WHERE GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  'Exception Quantity Due'
,	ReleaseNo =  COALESCE(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  COALESCE(a.ConsigneeCode,'')
,	ShipFromCode = COALESCE(a.ShipFromCode,'')
,	CustomerPart = COALESCE(a.CustomerPart,'')
,	CustomerPO = COALESCE(a.CustomerPO,'')
,	CustomerModelYear = COALESCE(a.CustomerModelYear,'')
,  Description = 'Qty Due : ' + CONVERT(VARCHAR(MAX), c.ReleaseQty) + ' on - ' + CONVERT(VARCHAR(MAX), c.ReleaseDT)
FROM
	@Current830s a
JOIN
		EDIFACT96A_MU.PlanningReleases c
ON			c.RawDocumentGUID = a.RawDocumentGUID AND
				a.CustomerPart = c.CustomerPart AND
				a.ShipToCode =c.ShipToCode AND
				COALESCE(a.customerPO,'') = COALESCE(c.CustomerPO,'') AND
				COALESCE(a.CustomerModelYear,'') = COALESCE(c.CustomerModelYear,'')
WHERE
		COALESCE(a.newDocument,0) = 1
AND  NOT EXISTS
( SELECT 1 FROM 
		EDIFACT96A_MU.PlanningReleases b
 JOIN 
	EDIFACT96A_MU.BlanketOrders bo ON b.CustomerPart = bo.CustomerPart
AND
	b.ShipToCode = bo.EDIShipToCode
AND
(	bo.CheckCustomerPOPlanning = 0
	OR bo.CustomerPO = b.CustomerPO)
AND
(	bo.CheckModelYearPlanning = 0
	OR bo.ModelYear830 = b.CustomerModelYear)
WHERE
				a.RawDocumentGUID = b.RawDocumentGUID AND
				a.CustomerPart = b.CustomerPart AND
				a.ShipToCode = b.ShipToCode AND
				COALESCE(a.customerPO,'') = COALESCE(b.CustomerPO,'') AND
				COALESCE(a.CustomerModelYear,'') = COALESCE(b.CustomerModelYear,''))

END



/* End E-Mail and Exceptions */


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

begin transaction
go

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDIFACT96A_MU.usp_Process
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Testing = 0


set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go


go

--commit transaction
rollback transaction

go

set statistics io off
set statistics time off
go

}

Results {
}
*/






















































GO
