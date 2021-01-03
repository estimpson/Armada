SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [EDI].[EDIDocuments]
as
select
	red.ID
,	red.GUID
,	red.Status
,	red.FileName
,	FullData = red.Data
,	Data = red.HeaderData
,	HeaderData = red.HeaderData
,	TradingPartner = red.TradingPartnerA
,	Type = red.TypeA
,	Version = red.VersionA
,	EDIStandard = red.EDIStandardA
,	Release = red.ReleaseA
,	DocNumber = red.DocNumberA
,	ControlNumber = red.ControlNumberA
,	DeliverySchedule = red.DeliveryScheduleA
,	MessageNumber = red.MessageNumberA
--,	TradingPartner = EDI.udf_EDIDocument_TradingPartner(red.Data)
--,	Type = EDI.udf_EDIDocument_Type(red.data)
--,	Version = EDI.udf_EDIDocument_Version(red.data)
--,	EDIStandard = case 
--										When EDI.udf_EDIDocument_Version(red.data) like '%FORD%' THEN '00FORD'
--										when EDI.udf_EDIDocument_Version(red.data) like '%CHRY%' THEN '00CHRY'
--										when EDI.udf_EDIDocument_TradingPartner(red.Data) in ('CHRYSLER', 'OMMC') then '00CHRY'
--										when EDI.udf_EDIDocument_TradingPartner(red.Data) like '%TMM[A-Z]%' then '00TOYO'
--										ELSE coalesce(EDI.udf_EDIDocument_EDIRelease(red.data),EDI.udf_EDIDocument_Version(red.data))
--										END
--,	Release = EDI.udf_EDIDocument_Release(red.data)
--,	DocNumber = EDI.udf_EDIDocument_DocNumber(red.data)
--,	ControlNumber = EDI.udf_EDIDocument_ControlNumber(red.data)
--,	DeliverySchedule = EDI.udf_EDIDocument_DeliverySchedule(red.data)
--,	MessageNumber = EDI.udf_EDIDocument_MessageNumber(red.data)
,	red.RowTS
,	red.RowCreateDT
,	red.RowCreateUser
from
	EDI.RawEDIDocuments red
	join dbo.RawEDIData reFileTable
		on reFileTable.stream_id = red.GUID











GO
