SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [EDIEDIFACT97A].[AddressFromDELFOR]
as
select distinct
		RawDocumentGUID = ed.GUID
	,	ReleaseNo =		coalesce(	ed.fulldata.value('(/TRN-DELFOR/SEG-BGM/CE/DE[@code="1004"])[1]', 'varchar(50)'),'')
	,	ConsigneeCode = coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="IC"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(35)'),''	)
	,	ShipFromCode =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SF"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(35)'),''	)								
	,	SupplierCode =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(35)'),''	)
	,	SupplierAdd1 =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3124"])[1]', 'varchar(35)'),''	)
	,	SupplierAdd2 =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3124"])[2]', 'varchar(35)'),''	)
	,	SupplierAdd3 =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3124"])[3]', 'varchar(35)'),''	)	
	,	SupplierAdd4 =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3124"])[4]', 'varchar(35)'),''	)
	,	SupplierName =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/CE/DE[@code="3036"])[1]', 'varchar(35)'),''	)
	,	SupplierStreet =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/DE[@code="C059"])[1]', 'varchar(35)'),''	)
	,	SupplierCity =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/DE[@code="3164"])[1]', 'varchar(35)'),''	)
	,	SupplierCountrySUB =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/DE[@code="3229"])[1]', 'varchar(35)'),''	)
	,   SupplierPostalCode =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/DE[@code="3251"])[1]', 'varchar(35)'),''	)
	,	SupplierCountry =  coalesce(	ed.fulldata.value('(/TRN-DELFOR/LOOP-NAD/SEG-NAD [DE[.="SU"][@code="3035"]]/DE[@code="3207"])[1]', 'varchar(35)'),''	)
	,	ShipToCode =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(35)'),''	)
	,	ShipToAdd1 =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3124"])[1]', 'varchar(35)'),''	)
	,	ShipToAdd2 =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3124"])[2]', 'varchar(35)'),''	)
	,	ShipToAdd3 =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3124"])[3]', 'varchar(35)'),''	)	
	,	ShipToAdd4 =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3124"])[4]', 'varchar(35)'),''	)
	,	ShipToName =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/CE/DE[@code="3036"])[1]', 'varchar(35)'),''	)
	,	ShipToStreet =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/DE[@code="C059"])[1]', 'varchar(35)'),''	)
	,	ShipToCity =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/DE[@code="3164"])[1]', 'varchar(35)'),''	)
	,	ShipToCountrySUB =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/DE[@code="3229"])[1]', 'varchar(35)'),''	)
	,   ShipToPostalCode =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/DE[@code="3251"])[1]', 'varchar(35)'),''	)
	,	ShipToCountry =  coalesce(	EDIDataST.STReleases.value('(../LOOP-NAD/SEG-NAD [DE[.="ST"][@code="3035"]]/DE[@code="3207"])[1]', 'varchar(35)'),''	)

	from
		FxEDI.EDI.EDIDocuments ed
		Outer apply ed.fulldata.nodes('/TRN-DELFOR/LOOP-NAD') as EDIData(Releases)
		Outer apply ed.fulldata.nodes('/TRN-DELFOR/LOOP-GIS/LOOP-NAD') as EDIDataST(STReleases)
	where
		ed.HeaderData.value('/TRN-INFO[1]/@type', 'varchar(50)') = 'DELFOR'
		and ed.EDIStandard = '97A'
		and ed.guID in ( Select RawDocumentGUID From EDIEDIFACT97A.CurrentPlanningReleases())

GO
