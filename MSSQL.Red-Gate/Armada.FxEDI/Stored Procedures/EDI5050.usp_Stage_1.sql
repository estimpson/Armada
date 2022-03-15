SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EDI5050].[usp_Stage_1]
	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings on
set @Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname
,	@TableName sysname
,	@ProcName sysname
,	@ProcReturn integer
,	@ProcResult integer
,	@Error integer
,	@RowCount integer

set @ProcName = user_name(objectproperty(@@PROCID, 'OwnerId')) + '.' + object_name(@@PROCID) -- e.g. EDI.usp_Test
--- </Error Handling>

--- <Tran Required=No AutoCreate=No TranDTParm=Yes>
set @TranDT = coalesce(@TranDT, getdate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
/*	Look for documents already in the queue.*/
if exists
(	select
		*
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '862'
		and left(ed.EDIStandard, 6) in
				( '005050', '005010' )
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
)
or exists
(	select
		*
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '830'
		and left(ed.EDIStandard, 6) in
				( '005050', '005010' )
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
)
begin
	goto queueError
end

/*	Move new and reprocessed Chrysler 862s and 830s to Staging. */
/*		Set new and requeued documents to in process.*/
--- <Update rows="*">
set @TableName = 'EDI.EDIDocuments'

if	exists
		(	select
				*
			from
				EDI.EDIDocuments ed
			where
				ed.Type = '862'
				and left(ed.EDIStandard, 6) in
						( '005050', '005010' )
				--and ed.TradingPartner in ( 'MPT MUNCIE' )
				and ed.Status in
						(	0	-- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'New'))
						,	2	-- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Requeued'))
						)
		)
begin
	update
		ed
	set
	ed	.Status = 100	-- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '862'
		and left(ed.EDIStandard, 6) in
				( '005050', '005010' )
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status in
				(	0	-- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'New'))
				,	2	-- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Requeued'))
				)
		and not exists
	(
		select
			1
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '862'
			and left(ed.EDIStandard, 6) in
					( '005050', '005010' )
			--and ed.TradingPartner in ( 'MPT MUNCIE' )
			and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	)

	select
		@Error	= @@ERROR
	,	@RowCount = @@ROWCOUNT

	if @Error != 0
	begin
		set @Result = 999999
		raiserror('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		goto queueError
	end
end
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDI.EDIDocuments'

if	exists
	(	select
			*
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '830'
			and  left(ed.EDIStandard,6) IN ('005050', '005010')
			--and ed.TradingPartner in ( 'MPT MUNCIE' )
			and ed.Status in
				(	0 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'New'))
				,	2 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Requeued'))
				)
	) begin
		
	update
		ed
	set
		ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '830'
		and  left(ed.EDIStandard,6) IN ('005050', '005010')
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status in
			(	0 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'New'))
			,	2 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Requeued'))
			)
		and not exists
		(	select
				1
			from
				EDI.EDIDocuments ed
			where
				ed.Type = '830'
				and  left(ed.EDIStandard,6) IN ('005050', '005010')
				--and ed.TradingPartner in ( 'MPT MUNCIE' )
				and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
		)

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		goto queueError
	end
end
--- </Update>

/*	Prepare data for Staging Tables...*/
/*		- prepare Ship Schedules...*/
if	exists
	(	select
			*
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '862'
			and  left(ed.EDIStandard,6) IN ('005050', '005010')
			--and ed.TradingPartner in ( 'MPT MUNCIE' )
			and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) begin

/*	Process "New" ship schedules */
/*	Get the "In-Process" ship schedules */
begin
	declare
		@ShipScheduleHeaders table
	(	RawDocumentGUID uniqueidentifier primary key
    ,	FullData xml not null
	,	DocumentImportDT datetime not null
	,	TradingPartner varchar(50) not null
	,	DocType varchar(6) not null
	,	Version varchar(20) not null
	,	ReleaseNo varchar(30) not null
	,	DocNumber varchar(50) not null
	,	ControlNumber varchar(10) not null
	,	DocumentDT datetime not null
	)

	insert
		@ShipScheduleHeaders
	(	RawDocumentGUID
	,	FullData
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	ReleaseNo
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)
	select
		RawDocumentGUID = ed.GUID
	,	FullData = ed.FullData
	,	DocumentImportDT = ed.RowCreateDT
	,	TradingPartner
	,	DocType = ed.Type
	,	Version
	,	ReleaseNo = coalesce(ed.fullData.value('(/TRN-862/SEG-BSS/DE[@code="0328"])[1]', 'varchar(30)'), ed.fullData.value('(/TRN-862/SEG-BSS/DE[@code="0127"])[1]', 'varchar(30)'))
	,	DocNumber
	,	ControlNumber
	,	DocumentDT = coalesce(ed.fullData.value('(/TRN-862/SEG-BSS/DE[@code="0373"])[2]', 'datetime'), ed.fullData.value('(/TRN-862/SEG-BSS/DE[@code="0373"])[1]', 'datetime'))
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '862'
		and  left(ed.EDIStandard,6) IN ('005050', '005010')
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))

end

--select
--	*
--from
--	@ShipScheduleHeaders ssh

/*	Get all of the orders contained in the in-process ship scedules */
begin
	declare
		@ShipScheduleOrders table
	(	RawDocumentGUID uniqueidentifier
    ,	FullData xml not null
	,	LINData xml not null
	,	ReleaseNo varchar(50) null
	,	ShipToCode varchar(50) null
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50) null
	,	ShipFromCode varchar(50) null
	,	SupplierCode varchar(50) null
	,	CustomerPart varchar(50) null
	,	CustomerPO varchar(50) null
	,	CustomerPOLine varchar(50) null
	,	CustomerModelYear varchar(50) null
	,	CustomerECL varchar(50) null
	)

	insert
		@ShipScheduleOrders
	(	RawDocumentGUID
	,	FullData
	,	LINData
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	)
	select
		RawDocumentGUID
	,	ed.FullData
	,	EDIData.Data.query('.')
	,	ReleaseNo = coalesce(ed.fullData.value('(/TRN-862/SEG-BSS/DE[@code="0328"])[1]', 'varchar(30)'), ed.fullData.value('(/TRN-862/SEG-BSS/DE[@code="0127"])[1]', 'varchar(30)'))
	,	ShipToCode = coalesce(EDIData.Data.value('(../SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'),ed.fullData.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'))
	,	AuxShipToCode = coalesce(EDIData.Data.value('(../../LOOP-N1 [SEG-N1 [DE[.="ST"][@code="0098"]]]/SEG-N4/DE[@code="0310"])[1]', 'varchar(50)'),ed.fullData.value('(/TRN-862/LOOP-N1 [SEG-N1 [DE[.="ST"][@code="0098"]]]/SEG-N4/DE[@code="0310"])[1]', 'varchar(50)'))
	,	ConsigneeCode = ed.FullData.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="IC"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	ShipFromCode = ed.FullData.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="SF"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	SupplierCode = ed.FullData.value('(/TRN-862/LOOP-N1/SEG-N1 [DE[.="SU"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	CustomerPart = EDIData.Data.value('(for $a in SEG-LIN/DE[@code="0235"] where $a="BP" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPO = EDIData.Data.value('(for $a in SEG-LIN/DE[@code="0235"] where $a="PO" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPOLine = coalesce(EDIData.Data.value('(for $a in SEG-LIN/DE[@code="0235"] where $a="PL" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)'),EDIData.Data.value('(SEG-LIN/DE[@code="0350"])[1]','char(30)'))
	,	CustomerModelYear = ''
	,	CustomerECL = ''
	from
		@ShipScheduleHeaders ed
		cross apply ed.fullData.nodes('/TRN-862/LOOP-LIN') as EDIData(Data)
end
	
--select
--	*
--from
--	@ShipScheduleOrders sso

/*	Get supplimental refs */
begin
	declare
		@ShipScheduleSupplementalValues table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	ValueQualifier varchar(50)
	,	Value varchar (50)
	)

	insert
		@ShipScheduleSupplementalValues
	select
		sso.RawDocumentGUID
	,	sso.ReleaseNo 
	,	sso.ShipToCode
	,	sso.AuxShipToCode
	,	sso.ConsigneeCode 
	,	sso.ShipFromCode 
	,	sso.SupplierCode	
	,	sso.CustomerPart
	,	sso.CustomerPO
	,	sso.CustomerPOLine
	,	sso.CustomerModelYear
	,	sso.CustomerECL
	,	ValueQualifier = EDIData.Data.value('(DE [@code="0128"])[1]', 'varchar(50)')
	,	Value = EDIData.Data.value('(DE [@code="0127"])[1]', 'varchar(50)')
	from
		@ShipScheduleOrders sso
		outer apply sso.LINData.nodes('/LOOP-LIN/SEG-REF') as EDIData(Data)
	order by
		2
	,	3
	,	7

	declare
		@ShipScheduleSupplemental table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) --Dock Code
	,	UserDefined2 varchar(50) --Line Feed Code	
	,	UserDefined3 varchar(50) --Reserve Line Feed Code
	,	UserDefined4 varchar(50) --Zone code
	,	UserDefined5 varchar(50) --Carrier reference
	,	UserDefined6 varchar(50) --Load planning number
	,	UserDefined7 varchar(50) --BOL number
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	,	UserDefined11 varchar(50) --11Z
	,	UserDefined12 varchar(50) --12Z
	,	UserDefined13 varchar(50) --13Z
	,	UserDefined14 varchar(50) --14Z
	,	UserDefined15 varchar(50) --15Z
	,	UserDefined16 varchar(50) --16Z
	,	UserDefined17 varchar(50) --17Z
	,	UserDefined18 varchar(50)
	,	UserDefined19 varchar(50)
	,	UserDefined20 varchar(50)
	)

	insert
		@ShipScheduleSupplemental
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5 
	,	UserDefined6 
	,	UserDefined7 
	,	UserDefined8 
	,	UserDefined9 
	,	UserDefined10 
	,	UserDefined11 
	,	UserDefined12 
	,	UserDefined13 
	,	UserDefined14 
	,	UserDefined15 
	,	UserDefined16 
	,	UserDefined17 
	,	UserDefined18 
	,	UserDefined19 
	,	UserDefined20 
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL 
	,	UserDefined1 = max(case when ValueQualifier = 'DK' then Value end)
	,	UserDefined2 = max(case when ValueQualifier = 'LF' then Value end)
	,	UserDefined3 = max(case when ValueQualifier = 'RL' then Value end)
	,	UserDefined4 = max(case when ValueQualifier = 'CN' then Value end)
	,	UserDefined5 = max(case when ValueQualifier = 'RU' then Value end)
	,	UserDefined6 = max(case when ValueQualifier = 'BM' then Value end)
	,	UserDefined7 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined8 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined9 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined10 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined11 = max(case when ValueQualifier = '11Z' then Value end)
	,	UserDefined12 = max(case when ValueQualifier = '12Z' then Value end)
	,	UserDefined13 = max(case when ValueQualifier = '13Z' then Value end)
	,	UserDefined14 = max(case when ValueQualifier = '14Z' then Value end)
	,	UserDefined15 = max(case when ValueQualifier = '15Z' then Value end)
	,	UserDefined16 = max(case when ValueQualifier = '16Z' then Value end)
	,	UserDefined17 = max(case when ValueQualifier = '17Z' then Value end)
	,	UserDefined18 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined19 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined20 = max(case when ValueQualifier = '??' then Value end)
	from
		@ShipScheduleSupplementalValues sssv
	group by
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL 
end

--select
--	*
--from
--	@ShipScheduleSupplemental sss

/*	Get shipping/receiving accums */
begin
	declare
		@ShipScheduleAccums table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	ReceivedAccum varchar(50)
	,	ReceivedAccumBeginDT varchar(50)
	,	ReceivedAccumEndDT varchar(50)
	,	ReceivedQty varchar(50)
	,	ReceivedQtyDT varchar(50)
	,	ReceivedShipper varchar(50)
	)

	insert
		@ShipScheduleAccums
	(	RawDocumentGUID
	,	ReleaseNo 
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode 
	,	ShipFromCode 
	,	SupplierCode	
	,	CustomerPart 
	,	CustomerPO 
	,	CustomerPOLine 
	,	CustomerModelYear 
	,	CustomerECL 
	,	ReceivedAccum
	,	ReceivedAccumBeginDT
	,	ReceivedAccumEndDT 
	,	ReceivedQty 
	,	ReceivedQtyDT 
	,	ReceivedShipper 
	)
	select
		sso.RawDocumentGUID
	,	sso.ReleaseNo 
	,	sso.ShipToCode
	,	sso.AuxShipToCode
	,	sso.ConsigneeCode 
	,	sso.ShipFromCode 
	,	sso.SupplierCode	
	,	sso.CustomerPart 
	,	sso.CustomerPO 
	,	sso.CustomerPOLine 
	,	sso.CustomerModelYear 
	,	sso.CustomerECL 
	,	ReceivedAccum = Accum.Data.value('(DE [@code="0380"])[1]', 'varchar(30)')
	,	ReceivedAccumBeginDT = Accum.Data.value('(DE [@code="0373"])[1]', 'varchar(30)')
	,	ReceivedAccumEndDT = Accum.Data.value('(DE [@code="0373"])[2]', 'varchar(30)')
	,	ReceivedQty = Shipped.Data.value('(DE [@code="0380"])[1]', 'varchar(30)')
	,	ReceivedQtyDT = Shipped.Data.value('(DE [@code="0373"])[1]', 'varchar(30)')
	,	ReceivedShipper = Shipped.Data.value('(DE [@code="0127"])[1]', 'varchar(30)') 
	from
		@ShipScheduleOrders sso
		outer apply sso.LINData.nodes('(/LOOP-LIN/LOOP-SHP/SEG-SHP [DE [@code="0374"][.="011"]])[1]') as Shipped(Data)
		outer apply sso.LINData.nodes('(/LOOP-LIN/LOOP-SHP/SEG-SHP [DE [@code="0374"][.="051"]])[1]') as Accum(Data)
	order by
		2
	,	3
	,	7

end 

--select
--	*
--from
--	@ShipScheduleAccums ssa

/*	Get auth accums */
begin
	declare
		@ShipScheduleAuthAccums table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	AuthAccum varchar(50)
	,	AuthAccumBeginDT varchar(50)
	,	AuthAccumEndDT varchar(50)
	)

	insert
		@ShipScheduleAuthAccums
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	AuthAccum
	,	AuthAccumBeginDT
	,	AuthAccumEndDT 
	)
	select
		sso.RawDocumentGUID
	,	sso.ReleaseNo 
	,	sso.ShipToCode
	,	sso.AuxShipToCode
	,	sso.ConsigneeCode 
	,	sso.ShipFromCode 
	,	sso.SupplierCode	
	,	sso.CustomerPart 
	,	sso.CustomerPO 
	,	sso.CustomerPOLine 
	,	sso.CustomerModelYear 
	,	sso.CustomerECL 
	,	AuthAccum = EDIData.Data.value('(DE [@code="0380"])[1]', 'varchar(30)')
	,	AuthAccumBeginDT = EDIData.Data.value('(DE [@code="0373"])[2]', 'varchar(30)')
	,	AuthAccumEndDT = EDIData.Data.value('(DE [@code="0373"])[1]', 'varchar(30)')
	from
		@ShipScheduleOrders sso
		outer apply sso.LINData.nodes('/LOOP-LIN/SEG-ATH') as EDIData(Data)

end

--select
--	*
--from
--	@ShipScheduleAuthAccums ssaa

/*	Get ship schedules */
begin
	declare
		@ShipSchedules table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	DateDue varchar(50)
	,	QuantityDue varchar(50)
	,	QuantityType varchar(50)
	)

	insert
		@ShipSchedules
	(	RawDocumentGUID
	,	ReleaseNo 
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode 
	,	ShipFromCode 
	,	SupplierCode	
	,	CustomerPart 
	,	CustomerPO 
	,	CustomerPOLine 
	,	CustomerModelYear 
	,	CustomerECL 
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5
	,	DateDue
	,	QuantityDue
	,	QuantityType
	)
	select
		sso.RawDocumentGUID
	,	sso.ReleaseNo 
	,	sso.ShipToCode
	,	sso.AuxShipToCode
	,	sso.ConsigneeCode 
	,	sso.ShipFromCode 
	,	sso.SupplierCode	
	,	sso.CustomerPart 
	,	sso.CustomerPO 
	,	sso.CustomerPOLine 
	,	sso.CustomerModelYear 
	,	sso.CustomerECL 
	,	UserDefined1 = ''
	,	UserDefined2 = ''
	,	UserDefined3 = ''
	,	UserDefined4 = ''
	,	UserDefined5 = Data.value('(for $a in DE[@code="0128"] where $a="DO" return $a/../DE[. >> $a][@code="0127"][1])[1]', 'varchar(30)')
	,	DateDue = Data.value('(DE[@code="0373"])[1]', 'varchar(50)')
	,	QuantityDue = Data.value('(DE[@code="0380"])[1]', 'varchar(50)')
	,	QuantityType = Data.value('(DE[@code="0680"])[1]', 'varchar(50)')
	from
		@ShipScheduleOrders sso
		cross apply sso.LINData.nodes('/LOOP-LIN/LOOP-FST[not(LOOP-JIT)]/SEG-FST') as EDIData(Data)
	order by
		2
	,	3
	,	7
end 

--select
--	*
--from
--	@ShipSchedules ss

end

/*		- prepare Release Plans...*/
if	exists
	(	select
			*
		from
			EDI.EDIDocuments ed
		where
			ed.Type = '830'
			and  left(ed.EDIStandard,6) IN ('005050', '005010')
			--and ed.TradingPartner in ( 'MPT MUNCIE' )
			and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
	) 
	begin

/*	Process "New" planning schedules */
/*	Get the "In-Process" planning schedules */
begin
	declare
		@PlanningHeaders table
	(	RawDocumentGUID uniqueidentifier
    ,	FullData xml
	,	DocumentImportDT datetime
	,	TradingPartner varchar(50)
	,	DocType varchar(6)
	,	Version varchar(20)
	,	ReleaseNo varchar(30)
	,	DocNumber varchar(50)
	,	ControlNumber varchar(10)
	,	DocumentDT datetime
	)

	insert
		@PlanningHeaders
	(	RawDocumentGUID
    ,	FullData
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	ReleaseNo
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)
	select
		RawDocumentGUID = ed.GUID
	,	FullData = ed.FullData
	,	DocumentImportDT = ed.RowCreateDT
	,	TradingPartner
	,	DocType = ed.Type
	,	Version
	,	ReleaseNo = coalesce(nullif(ed.FullData.value('(/TRN-830/SEG-BFR/DE[@code="0328"])[1]', 'varchar(30)'),''), ed.FullData.value('(/TRN-830/SEG-BFR/DE[@code="0127"])[1]', 'varchar(30)'))
	,	DocNumber
	,	ControlNumber
	,	DocumentDT = ed.FullData.value('(/TRN-830/SEG-BFR/DE[@code="0373"])[3]', 'datetime')
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '830'
		and  left(ed.EDIStandard,6) IN ('005050', '005010')
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
end

--select
--	*
--from
--	@PlanningHeaders ph

	
/*	Get all of the orders contained in the in-process ship scedules */
begin
	declare
		@PlanningOrders table
	(	RawDocumentGUID uniqueidentifier
    ,	FullData xml not null
	,	LINData xml not null
	,	ReleaseNo varchar(50) null
	,	ShipToCode varchar(50) null
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50) null
	,	ShipFromCode varchar(50) null
	,	SupplierCode varchar(50) null
	,	CustomerPart varchar(50) null
	,	CustomerPO varchar(50) null
	,	CustomerPOLine varchar(50) null
	,	CustomerModelYear varchar(50) null
	,	CustomerECL varchar(50) null
	)

	insert
		@PlanningOrders
	(	RawDocumentGUID
	,	FullData
	,	LINData
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	)
	select
		RawDocumentGUID
	,	ed.FullData
	,	EDIData.Data.query('.')
	,	ReleaseNo = coalesce(nullif(ed.FullData.value('(/TRN-830/SEG-BFR/DE[@code="0328"])[1]', 'varchar(30)'),''), ed.FullData.value('(/TRN-830/SEG-BFR/DE[@code="0127"])[1]', 'varchar(30)'))
	,	ShipToCode = coalesce(EDIData.Data.value('(../SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'),ed.fullData.value('(/TRN-830/LOOP-N1/SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)'), ed.fulldata.value('/*[1]/TRN-INFO[1]/@trading_partner', 'varchar(50)'))
	,	AuxShipToCode = coalesce(EDIData.Data.value('(../../LOOP-N1 [SEG-N1 [DE[.="ST"][@code="0098"]]]/SEG-N4/DE[@code="0310"])[1]', 'varchar(50)'),ed.fullData.value('(/TRN-830/LOOP-N1 [SEG-N1 [DE[.="ST"][@code="0098"]]]/SEG-N4/DE[@code="0310"])[1]', 'varchar(50)'))
	,	ConsigneeCode = ed.FullData.value('(/TRN-830/LOOP-N1/SEG-N1 [DE[.="IC"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	ShipFromCode = ed.FullData.value('(/TRN-830/LOOP-N1/SEG-N1 [DE[.="SF"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	SupplierCode = ed.FullData.value('(/TRN-830/LOOP-N1/SEG-N1 [DE[.="SU"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(50)')
	,	CustomerPart = EDIData.Data.value('(for $a in SEG-LIN/DE[@code="0235"] where $a="BP" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPO = EDIData.Data.value('(for $a in SEG-LIN/DE[@code="0235"] where $a="PO" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)')
	,	CustomerPOLine = coalesce(EDIData.Data.value('(for $a in SEG-LIN/DE[@code="0235"] where $a="PL" return $a/../DE[. >> $a][@code="0234"][1])[1]', 'varchar(30)'),EDIData.Data.value('(SEG-LIN/DE[@code="0350"])[1]','char(30)'))
	,	CustomerModelYear = ''
	,	CustomerECL = ''
	from
		@PlanningHeaders ed
		cross apply ed.fullData.nodes('/TRN-830/LOOP-LIN') as EDIData(Data)
end

--select
--	*
--from
--	@PlanningOrders po

/*	Get supplimental refs */
begin
	declare
		@PlanningSupplementalValues table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	ValueQualifier varchar(50)
	,	Value varchar (50)
	)

	insert
		@PlanningSupplementalValues
	select
		po.RawDocumentGUID
	,	po.ReleaseNo 
	,	po.ShipToCode
	,	po.AuxShipToCode
	,	po.ConsigneeCode 
	,	po.ShipFromCode 
	,	po.SupplierCode	
	,	po.CustomerPart
	,	po.CustomerPO
	,	po.CustomerPOLine
	,	po.CustomerModelYear
	,	po.CustomerECL
	,	ValueQualifier = EDIData.Data.value('(DE [@code="0128"])[1]', 'varchar(50)')
	,	Value = EDIData.Data.value('(DE [@code="0127"])[1]', 'varchar(50)')
	from
		@PlanningOrders po
		outer apply po.LINData.nodes('/LOOP-LIN/SEG-REF') as EDIData(Data)
	order by
		2
	,	3
	,	7

	declare
		@PlanningSupplemental table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) --Dock Code
	,	UserDefined2 varchar(50) --Line Feed Code	
	,	UserDefined3 varchar(50) --Reserve Line Feed Code
	,	UserDefined4 varchar(50) --Zone code
	,	UserDefined5 varchar(50)
	,	UserDefined6 varchar(50)
	,	UserDefined7 varchar(50)
	,	UserDefined8 varchar(50)
	,	UserDefined9 varchar(50)
	,	UserDefined10 varchar(50)
	,	UserDefined11 varchar(50) --11Z
	,	UserDefined12 varchar(50) --12Z
	,	UserDefined13 varchar(50) --13Z
	,	UserDefined14 varchar(50) --14Z
	,	UserDefined15 varchar(50) --15Z
	,	UserDefined16 varchar(50) --16Z
	,	UserDefined17 varchar(50) --17Z
	,	UserDefined18 varchar(50)
	,	UserDefined19 varchar(50)
	,	UserDefined20 varchar(50)
	)

	insert
		@PlanningSupplemental
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5 
	,	UserDefined6 
	,	UserDefined7 
	,	UserDefined8 
	,	UserDefined9 
	,	UserDefined10 
	,	UserDefined11 
	,	UserDefined12 
	,	UserDefined13 
	,	UserDefined14 
	,	UserDefined15 
	,	UserDefined16 
	,	UserDefined17 
	,	UserDefined18 
	,	UserDefined19 
	,	UserDefined20 
	)
	select
		psv.RawDocumentGUID
	,	psv.ReleaseNo
	,	psv.ShipToCode
	,	psv.AuxShipToCode
	,	psv.ConsigneeCode
	,	psv.ShipFromCode
	,	psv.SupplierCode
	,	psv.CustomerPart	
	,	psv.CustomerPO
	,	psv.CustomerPOLine
	,	psv.CustomerModelYear
	,	psv.CustomerECL 
	,	UserDefined1 = max(case when ValueQualifier = 'DK' then Value end)
	,	UserDefined2 = max(case when ValueQualifier = 'LF' then Value end)
	,	UserDefined3 = max(case when ValueQualifier = 'RL' then Value end)
	,	UserDefined4 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined5 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined6 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined7 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined8 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined9 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined10 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined11 = max(case when ValueQualifier = '11Z' then Value end)
	,	UserDefined12 = max(case when ValueQualifier = '12Z' then Value end)
	,	UserDefined13 = max(case when ValueQualifier = '13Z' then Value end)
	,	UserDefined14 = max(case when ValueQualifier = '14Z' then Value end)
	,	UserDefined15 = max(case when ValueQualifier = '15Z' then Value end)
	,	UserDefined16 = max(case when ValueQualifier = '16Z' then Value end)
	,	UserDefined17 = max(case when ValueQualifier = '17Z' then Value end)
	,	UserDefined18 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined19 = max(case when ValueQualifier = '??' then Value end)
	,	UserDefined20 = max(case when ValueQualifier = '??' then Value end)
	from
		@PlanningSupplementalValues psv
	group by
		psv.RawDocumentGUID
	,	psv.ReleaseNo
	,	psv.ShipToCode
	,	psv.AuxShipToCode
	,	psv.ConsigneeCode
	,	psv.ShipFromCode
	,	psv.SupplierCode
	,	psv.CustomerPart	
	,	psv.CustomerPO
	,	psv.CustomerPOLine
	,	psv.CustomerModelYear
	,	psv.CustomerECL 
end

--select
--	*
--from
--	@PlanningSupplemental ps

/*	Get shipping/receiving accums */
begin
	declare
		@PlanningAccums table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	ReceivedAccum varchar(50)
	,	ReceivedAccumBeginDT varchar(50)
	,	ReceivedAccumEndDT varchar(50)
	,	ReceivedQty varchar(50)
	,	ReceivedQtyDT varchar(50)
	,	ReceivedShipper varchar(50)
	)

	insert
		@PlanningAccums
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5 
	,	ReceivedAccum
	,	ReceivedAccumBeginDT
	,	ReceivedAccumEndDT 
	,	ReceivedQty 
	,	ReceivedQtyDT 
	,	ReceivedShipper 
	)
	select
		po.RawDocumentGUID
	,	po.ReleaseNo
	,	po.ShipToCode
	,	po.AuxShipToCode
	,	po.ConsigneeCode
	,	po.ShipFromCode
	,	po.SupplierCode
	,	po.CustomerPart	
	,	po.CustomerPO
	,	po.CustomerPOLine
	,	po.CustomerModelYear
	,	po.CustomerECL
	,	UserDefined1 = ''
	,	UserDefined2 = ''
	,	UserDefined3 = ''
	,	UserDefined4 = ''
	,	UserDefined5 = ''
	,	ReceivedAccum = Accum.Data.value('(DE [@code="0380"])[1]', 'varchar(30)')
	,	ReceivedAccumBeginDT = Accum.Data.value('(DE [@code="0373"])[1]', 'varchar(30)')
	,	ReceivedAccumEndDT = Accum.Data.value('(DE [@code="0373"])[2]', 'varchar(30)')
	,	ReceivedQty = Shipped.Data.value('(DE [@code="0380"])[1]', 'varchar(30)')
	,	ReceivedQtyDT = Shipped.Data.value('(DE [@code="0373"])[1]', 'varchar(30)')
	,	ReceivedShipper = Shipped.Data.value('(../SEG-REF/DE [@code="0127"])[1]', 'varchar(30)')
	from
		@PlanningOrders po
		outer apply po.LINData.nodes('(/LOOP-LIN/LOOP-SHP/SEG-SHP [DE [@code="0374"][.="011" or .="035" or .="050"]])[1]') as Shipped(Data)
		outer apply po.LINData.nodes('(/LOOP-LIN/LOOP-SHP/SEG-SHP [DE [@code="0374"][.="035"]] [DE [@code="0673"][.="02"]])[1]') as Accum(Data)
		--outer apply po.LINData.nodes('(/LOOP-LIN/LOOP-SHP/SEG-SHP [DE [@code="0374"][.="051" or .="004"]])[1]') as Accum(Data)
end

--select
--	*
--from
--	@PlanningAccums pa

/*	Get auth accums */
begin
	declare
		@PlanningAuthAccums table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	AuthAccum varchar(50)
	,	AuthAccumBeginDT varchar(50)
	,	AuthAccumEndDT varchar(50)
	,	FabAccum varchar(50)
	,	FabAccumBeginDT varchar(50)
	,	FabAccumEndDT varchar(50)
	,	RawAccum varchar(50)
	,	RawAccumBeginDT varchar(50)
	,	RawAccumEndDT varchar(50)
	)

	insert 
		@PlanningAuthAccums
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5 
	,	AuthAccum
	,	AuthAccumBeginDT
	,	AuthAccumEndDT
	,	FabAccum
	,	FabAccumBeginDT
	,	FabAccumEndDT 
	,	RawAccum
	,	RawAccumBeginDT
	,	RawAccumEndDT 
	)
	select
		po.RawDocumentGUID
	,	po.ReleaseNo
	,	po.ShipToCode
	,	po.AuxShipToCode
	,	po.ConsigneeCode
	,	po.ShipFromCode
	,	po.SupplierCode
	,	po.CustomerPart	
	,	po.CustomerPO
	,	po.CustomerPOLine
	,	po.CustomerModelYear
	,	po.CustomerECL
	,	UserDefined1 = ''
	,	UserDefined2 = ''
	,	UserDefined3 = ''
	,	UserDefined4 = ''
	,	UserDefined5 = ''
	,	AuthAccum = Data.value('(for $a in DE[@code="0672"] where $a="PQ" return $a/../DE[. >> $a][@code="0380"][1])[1]', 'varchar(30)')
	,	AuthAccumBeginDT = coalesce(Data.value('(for $a in DE[@code="0672"] where $a="PQ" return $a/../DE[. >> $a][@code="0373"][2])[1]', 'varchar(30)'),Data.value('(for $a in SEG-ATH/DE[@code="0672"] where $a="PQ" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')  ) 
	,	AuthAccumEndDT = Data.value('(for $a in DE[@code="0672"] where $a="PQ" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)') 
	,	FabAccum = Data.value('(for $a in DE[@code="0672"] where $a="FI" return $a/../DE[. >> $a][@code="0380"][1])[1]', 'varchar(30)')
	,	FabAccumBeginDT =  coalesce(Data.value('(for $a in DE[@code="0672"] where $a="FI" return $a/../DE[. >> $a][@code="0373"][2])[1]', 'varchar(30)'),Data.value('(for $a in SEG-ATH/DE[@code="0672"] where $a="FI" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')  )
	,	FabAccumEndDT =   Data.value('(for $a in DE[@code="0672"] where $a="FI" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')
	,	RawAccum = Data.value('(for $a in DE[@code="0672"] where $a="MT" return $a/../DE[. >> $a][@code="0380"][1])[1]', 'varchar(30)')
	,	RawAccumBeginDT =   coalesce(Data.value('(for $a in DE[@code="0672"] where $a="MT" return $a/../DE[. >> $a][@code="0373"][2])[1]', 'varchar(30)'),Data.value('(for $a in SEG-ATH/DE[@code="0672"] where $a="MT" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')  )
	,	RawAccumEndDT =  Data.value('(for $a in DE[@code="0672"] where $a="MT" return $a/../DE[. >> $a][@code="0373"][1])[1]', 'varchar(30)')
	from
		@PlanningOrders po
		outer apply po.LINData.nodes('/LOOP-LIN/SEG-ATH') as EDIData(Data)
end

--select
--	*
--from
--	@PlanningAuthAccums paa

/*	Get releases */
begin
	declare
		@PlanningReleases table
	(	RawDocumentGUID uniqueidentifier
	,	ReleaseNo varchar(50)
	,	ShipToCode varchar(50)
	,	AuxShipToCode varchar(50) null
	,	ConsigneeCode varchar(50)
	,	ShipFromCode varchar(50)
	,	SupplierCode varchar(50)	
	,	CustomerPart varchar(50)
	,	CustomerPO varchar(50)
	,	CustomerPOLine varchar(50)
	,	CustomerModelYear varchar(50)
	,	CustomerECL varchar(50)	
	,	UserDefined1 varchar(50) 
	,	UserDefined2 varchar(50) 
	,	UserDefined3 varchar(50) 
	,	UserDefined4 varchar(50)
	,	UserDefined5 varchar(50)
	,	DateDue varchar(50)
	,	QuantityDue varchar(50)
	,	QuantityType varchar(50)
	)


	insert
		@PlanningReleases
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5 
	,	DateDue
	,	QuantityDue
	,	QuantityType
	)
	select
		po.RawDocumentGUID
	,	po.ReleaseNo 
	,	po.ShipToCode 
	,	po.AuxShipToCode
	,	po.ConsigneeCode 
	,	po.ShipFromCode 
	,	po.SupplierCode	
	,	po.CustomerPart 
	,	po.CustomerPO 
	,	po.CustomerPOLine 
	,	po.CustomerModelYear 
	,	po.CustomerECL 
	,	UserDefined1 = ''
	,	UserDefined2 = ''
	,	UserDefined3 = ''
	,	UserDefined4 = ''
	,	UserDefined5 = Data.value('(for $a in DE[@code="0128"] where $a="DO" return $a/../DE[. >> $a][@code="0127"][1])[1]', 'varchar(30)')
	,	DateDue = Data.value('(DE[@code="0373"])[1]', 'varchar(50)')
	,	QuantityDue = Data.value('(DE[@code="0380"])[1]', 'varchar(50)')
	,	QuantityType = Data.value('(DE[@code="0680"])[1]', 'varchar(50)')
	from
		@PlanningOrders po
		cross apply po.LINData.nodes('/LOOP-LIN/LOOP-FST[not(LOOP-JIT)]/SEG-FST') as EDIData(Data)
	order by
		2
	,	3
	,	7
end

--select
--	*
--from
--	@PlanningReleases pr

end

/*	Write data to Staging Tables...*/
/*		- write Ship Schedules...*/
/*			- write Headers.*/
if	exists
	(	select
			*
		from
			@ShipScheduleHeaders fh
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingShipScheduleHeaders'

	insert
		FxArmada.EDI5050.StagingShipScheduleHeaders
	(	RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	Release
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)
	select
		RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	ReleaseNo
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	from
		@ShipScheduleHeaders fh

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Supplemental.*/
if	exists
	(	select
			*
		from
			@ShipScheduleSupplemental fs
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingShipScheduleSupplemental'
	
	insert 
		FxArmada.EDI5050.StagingShipScheduleSupplemental
	(	RawDocumentGUID
    ,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
    ,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5 
	,	UserDefined6 
	,	UserDefined7 
	,	UserDefined8 
	,	UserDefined9 
	,	UserDefined10 
	,	UserDefined11 
	,	UserDefined12 
	,	UserDefined13 
	,	UserDefined14 
	,	UserDefined15 
	,	UserDefined16 
	,	UserDefined17 
	,	UserDefined18 
	,	UserDefined19 
	,	UserDefined20 
    )
	select
		fs	.RawDocumentGUID
	,	fs.ReleaseNo
	,	fs.ShipToCode
	,	fs.AuxShipToCode
	,	fs.ConsigneeCode
	,	fs.ShipFromCode
	,	fs.SupplierCode
	,	fs.CustomerPart
	,	fs.CustomerPO
	,	fs.CustomerPOLine
	,	fs.CustomerModelYear
	,	fs.CustomerECL
	,	fs.UserDefined1		-- Dock Code
	,	fs.UserDefined2		-- Line Feed Code
	,	fs.UserDefined3		-- Zone Code
	,	fs.UserDefined4
	,	fs.UserDefined5
	,	fs.UserDefined6
	,	fs.UserDefined7
	,	fs.UserDefined8
	,	fs.UserDefined9
	,	fs.UserDefined10
	,	fs.UserDefined11	--Line11
	,	fs.UserDefined12	--Line12
	,	fs.UserDefined13	--Line13
	,	fs.UserDefined14	--Line14
	,	fs.UserDefined15	--Line15
	,	fs.UserDefined16	--Line16
	,	fs.UserDefined17	--Line17
	,	fs.UserDefined18
	,	fs.UserDefined19
	,	fs.UserDefined20
	from
		@ShipScheduleSupplemental fs

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Accums.*/
----------------------------------------------------------------------------------------------------------------------
if	exists
	(	select
			*
		from
			@ShipScheduleAccums fa
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingShipScheduleAccums'

	insert
		FxArmada.EDI5050.StagingShipScheduleAccums
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	ReferenceNo
	,	LastQtyReceived
	,	LastQtyDT
	,	LastShipper
	,	LastAccumQty
	,	LastAccumDT
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	ReferenceNo = ''
	,	LastQtyReceived = nullif(ReceivedQty, '')
	,	LastQtyDT =
			case
				when datalength(ReceivedQtyDT) = '6' then
					dbo.udf_GetDT('YYMMDD', ReceivedQtyDT)
				when datalength(ReceivedQtyDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', ReceivedQtyDT)
				else
					convert(datetime, ReceivedQtyDT)
			end
	,	LastShipper = ReceivedShipper
	,	LastAccumQty = nullif(ReceivedAccum, '')
	,	LastAccumDT =
			case
				when datalength(ReceivedAccumEndDT) = '6' then
					dbo.udf_GetDT('YYMMDD', ReceivedAccumEndDT)
				when datalength(ReceivedAccumEndDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', ReceivedAccumEndDT)
				else
					convert(datetime, ReceivedAccumEndDT)
			end
	from
		@ShipScheduleAccums
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

if	exists
	(	select
			*
		from
			@ShipScheduleAuthAccums fa
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingShipScheduleAuthAccums'

	insert
		FxArmada.EDI5050.StagingShipScheduleAuthAccums
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	PriorCUMStartDT
	,	PriorCUMEndDT
	,	PriorCUM
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	PriorCUMStartDT =
			case
				when datalength(AuthAccumBeginDT) = '6' then
					dbo.udf_GetDT('YYMMDD', AuthAccumBeginDT)
				when datalength(AuthAccumBeginDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', AuthAccumBeginDT)
				else
					convert(datetime, AuthAccumBeginDT)
			end
	,	PriorCUMEndDT =
			case
				when datalength(AuthAccumEndDT) = '6' then
					dbo.udf_GetDT('YYMMDD', AuthAccumEndDT)
				when datalength(AuthAccumEndDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', AuthAccumEndDT)
				else
					convert(datetime, AuthAccumEndDT)
			end
	,	PriorCUM = nullif(AuthAccum, '')
	from
		@ShipScheduleAuthAccums
	
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Releases.*/
if	exists
	(	select
			*
		from
			@ShipSchedules fr	
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingShipSchedules'

	insert
		FxArmada.EDI5050.StagingShipSchedules
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart	
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined5
	,	ScheduleType
	,	ReleaseQty
	,	ReleaseDT
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined5
	,	QuantityType
	,	ReleaseQty = convert(numeric(20, 6), nullif(QuantityDue, ''))
	,	ReleaseDT =
			case
				when datalength(DateDue) = '6' then
					dbo.udf_GetDT('YYMMDD', DateDue)
				when datalength(DateDue) = '8' then
					dbo.udf_GetDT('CCYYMMDD', DateDue)
				else
					convert(datetime, DateDue)
			end
	from
		@ShipSchedules
	

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

----------------------------------------------------------------------------------------------------------
/*		- write Release Plans...*/
/*			- write Headers.*/
if	exists
	(	select
			*
		from
			@PlanningHeaders fh
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingPlanningHeaders'

	insert
		FxArmada.EDI5050.StagingPlanningHeaders
	(	RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	Release
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	)
	select
		RawDocumentGUID
	,	DocumentImportDT
	,	TradingPartner
	,	DocType
	,	Version
	,	ReleaseNo
	,	DocNumber
	,	ControlNumber
	,	DocumentDT
	from
		@PlanningHeaders fh

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Supplemental.*/
if	exists
	(	select
			*
		from
			@PlanningSupplemental ps
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingShipScheduleSupplemental'
	
	insert
		FxArmada.EDI5050.StagingPlanningSupplemental
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5
	,	UserDefined6
	,	UserDefined7
	,	UserDefined8
	,	UserDefined9
	,	UserDefined10
	,	UserDefined11
	,	UserDefined12
	,	UserDefined13
	,	UserDefined14
	,	UserDefined15
	,	UserDefined16
	,	UserDefined17
	,	UserDefined18
	,	UserDefined19
	,	UserDefined20
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1	-- Dock Code
	,	UserDefined2	-- Line Feed Code
	,	UserDefined3	-- Zone Code
	,	UserDefined4
	,	UserDefined5
	,	UserDefined6
	,	UserDefined7
	,	UserDefined8
	,	UserDefined9
	,	UserDefined10
	,	UserDefined11	--Line11
	,	UserDefined12	--Line12
	,	UserDefined13	--Line13
	,	UserDefined14	--Line14
	,	UserDefined15	--Line15
	,	UserDefined16	--Line16
	,	UserDefined17	--Line17
	,	UserDefined18
	,	UserDefined19
	,	UserDefined20
	from
		@PlanningSupplemental

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Accums.*/
------------------------------------------------------------------------------------------------------------------------
if	exists
	(	select
			*
		from
			@PlanningAccums fa
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingPlanningAccums'

	insert
		FxArmada.EDI5050.StagingPlanningAccums
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	ReferenceNo
	,	LastQtyReceived
	,	LastQtyDT
	,	LastShipper
	,	LastAccumQty
	,	LastAccumDT
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	ReferenceNo = ''
	,	LastQtyReceived = nullif(ReceivedQty, '')
	,	LastQtyDT =
			case
				when datalength(ReceivedQtyDT) = '6' then
					dbo.udf_GetDT('YYMMDD', ReceivedQtyDT)
				when datalength(ReceivedQtyDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', ReceivedQtyDT)
				else
					convert(datetime, ReceivedQtyDT)
			end
	,	LastShipper = ReceivedShipper
	,	LastAccumQty = nullif(ReceivedAccum, '')
	,	LastAccumDT =
			case
				when datalength(ReceivedAccumEndDT) = '6' then
					dbo.udf_GetDT('YYMMDD', ReceivedAccumEndDT)
				when datalength(ReceivedAccumEndDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', ReceivedAccumEndDT)
				else
					convert(datetime, ReceivedAccumEndDT)
			end
	from
		@PlanningAccums
	
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Planning Auth Accums.*/
if	exists
	(	select
			1
		from
			@PlanningAuthAccums fa
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingPlanningAuthAccums'

	insert
		FxArmada.EDI5050.StagingPlanningAuthAccums
	(	RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	PriorCUM
	,	PriorCUMStartDT
	,	PriorCUMEndDT
	,	FABCUM
	,	FABCUMStartDT
	,	FABCUMEndDT
	,	RAWCUM
	,	RAWCUMStartDT
	,	RAWCUMEndDT
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	PriorCum = nullif(AuthAccum, '')
	,	PriorCUMStartDT =
			case
				when datalength(AuthAccumBeginDT) = '6' then
					dbo.udf_GetDT('YYMMDD', AuthAccumBeginDT)
				when datalength(AuthAccumBeginDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', AuthAccumBeginDT)
				else
					convert(datetime, AuthAccumBeginDT)
			end
	,	PriorCUMEndDT =
			case
				when datalength(AuthAccumEndDT) = '6' then
					dbo.udf_GetDT('YYMMDD', AuthAccumEndDT)
				when datalength(AuthAccumEndDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', AuthAccumEndDT)
				else
					convert(datetime, AuthAccumEndDT)
			end
	,	FabCum = nullif(FabAccum, '')
	,	FabCUMStartDT =
			case
				when datalength(FabAccumBeginDT) = '6' then
					dbo.udf_GetDT('YYMMDD', FabAccumBeginDT)
				when datalength(FabAccumBeginDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', FabAccumBeginDT)
				else
					convert(datetime, FabAccumBeginDT)
			end
	,	FabCUMEndDT =
			case
				when datalength(FabAccumEndDT) = '6' then
					dbo.udf_GetDT('YYMMDD', FabAccumEndDT)
				when datalength(FabAccumEndDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', FabAccumEndDT)
				else
					convert(datetime, FabAccumEndDT)
			end
	,	RawCum = nullif(RawAccum, '')
	,	RawCUMStartDT =
			case
				when datalength(RawAccumBeginDT) = '6' then
					dbo.udf_GetDT('YYMMDD', RawAccumBeginDT)
				when datalength(RawAccumBeginDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', RawAccumBeginDT)
				else
					convert(datetime, RawAccumBeginDT)
			end
	,	RawCUMEndDT =
			case
				when datalength(RawAccumEndDT) = '6' then
					dbo.udf_GetDT('YYMMDD', RawAccumEndDT)
				when datalength(RawAccumEndDT) = '8' then
					dbo.udf_GetDT('CCYYMMDD', RawAccumEndDT)
				else
					convert(datetime, RawAccumEndDT)
			end
	from
		@PlanningAuthAccums
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*			- write Releases.*/
if	exists
	(	select
			*
		from
			@PlanningReleases fr
	) begin
	--- <Insert rows="*">
	set	@TableName = 'FxArmada.EDI5050.StagingPlanningReleases'

	insert
		FxArmada.EDI5050.StagingPlanningReleases
	(
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5
	,	ScheduleType
	,	QuantityQualifier
	,	Quantity
	,	QuantityType
	,	DateType
	,	DateDT
	,	DateDTFormat
	)
	select
		RawDocumentGUID
	,	ReleaseNo
	,	ShipToCode
	,	AuxShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	SupplierCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerPOLine
	,	CustomerModelYear
	,	CustomerECL
	,	UserDefined1
	,	UserDefined2
	,	UserDefined3
	,	UserDefined4
	,	UserDefined5
	,	''
	,	''
	,	nullif(QuantityDue, '')
	,	QuantityType
	,	''
	,	case
			when datalength(DateDue) = '6' then
				dbo.udf_GetDT('YYMMDD', DateDue)
			when datalength(DateDue) = '8' then
				dbo.udf_GetDT('CCYYMMDD', DateDue)
			else
				convert(datetime, DateDue)
		end
	,	''
	from
		@PlanningReleases
	select
		@Error	= @@ERROR
	,	@RowCount = @@ROWCOUNT

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
	--- </Insert>
end

/*	Set in process documents to processed...*/
/*		- 862s.*/
if exists
(
	select
		*
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '862'
		and left(ed.EDIStandard, 6) in
				( '005050', '005010' )
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
)
begin
	--- <Update rows="*">
	set @TableName = 'EDI5050.ShipScheduleHeaders'

	update
		ed
	set
	ed	.Status = 1		-- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Processed'))
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '862'
		and left(ed.EDIStandard, 6) in
				( '005050', '005010' )
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))

	select
		@Error	= @@ERROR
	,	@RowCount = @@ROWCOUNT

	if @Error != 0
	begin
		set @Result = 999999
		raiserror('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
--- </Update>
end

/*		- 830s.*/
if exists
(
	select
		*
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '830'
		and left(ed.EDIStandard, 6) in
				( '005050', '005010' )
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))
)
begin
	--- <Update rows="*">
	set @TableName = 'EDI.EDIDocuments'

	update
		ed
	set
	ed	.Status = 1		-- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'Processed'))
	from
		EDI.EDIDocuments ed
	where
		ed.Type = '830'
		and left(ed.EDIStandard, 6) in
				( '005050', '005010' )
		--and ed.TradingPartner in ( 'MPT MUNCIE' )
		and ed.Status = 100 -- (select dbo.udf_StatusValue('EDI.EDIDocuments', 'InProcess'))

	select
		@Error	= @@ERROR
	,	@RowCount = @@ROWCOUNT

	if @Error != 0
	begin
		set @Result = 999999
		raiserror('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		return
	end
--- </Update>
end
--- </Body>

---	<Return>
set @Result = 0
return
	@Result
--- </Return>

---	<Error>
queueError:

set @Result = 100
raiserror('Chrysler documents already in process.  Use EDI5050.usp_ClearQueue to clear the queue if necessary.', 16, 1)
return
	
--- </Error>

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

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

begin transaction

execute
	@ProcReturn = EDI5050.usp_Stage_1
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go


Select 'StagingSSHeaders'
select
	*
from
	FxArmada.EDI5050.StagingShipScheduleHeaders sfh

Select 'StagingSSchedules'
select
	*
from
	FxArmada.EDI5050.StagingShipSchedules sfr

Select 'StagingSSAccums'
select 
	*
from
	FxArmada.EDI5050.StagingShipScheduleAccums sfs

Select 'StagingSSSupplemental'
select 
	*
from
	FxArmada.EDI5050.StagingShipScheduleSupplemental sfs
go

Select 'PlanningHeaders'
select
	*
from
	FxArmada.EDI5050.StagingPlanningHeaders sfh

Select 'PlanningReleases'
select
	*
from
	FxArmada.EDI5050.StagingPlanningReleases sfr

Select 'PlanningAccums'	
select 
	*
from
	FxArmada.EDI5050.StagingPlanningAccums sfa
Select 'PlanningAuthAccums'	

select 
	*
from
	FxArmada.EDI5050.StagingPlanningAuthAccums sfa

Select 'PlanningSupplemental'	
select 
	*
from
	FxArmada.EDI5050.StagingPlanningSupplemental sfa



rollback
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
