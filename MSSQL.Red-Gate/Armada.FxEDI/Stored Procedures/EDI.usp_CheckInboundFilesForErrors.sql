SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EDI].[usp_CheckInboundFilesForErrors]
as
select
	ed.GUID
,	ed.FileName
,	ed.TradingPartner
,	ed.Type
,	ed.Version
,	ed.EDIStandard
,	ed.Release
,	ed.DocNumber
,	ed.RowCreateDT
,	Error = Error.Data.value('@message[1]', 'varchar(255)')
into
	#errorFiles
from
	FxEDI.EDI.EDIDocuments ed
	cross apply ed.FullData.nodes ('*/ERROR') as Error(Data)
where
	ed.RowCreateDT > getdate() - 3
	and ed.Status > 0

if	@@rowcount = 0 return 0

declare
	@html nvarchar(max)
,	@EmailTableName sysname = N'#errorFiles'

exec FxArmada.FT.usp_TableToHTML
	@tableName = @EmailTableName
,	@orderBy = N'RowCreateDT'
,	@html = @html output
,	@includeRowNumber = 0
,	@camelCaseHeaders = 1

declare
	@EmailBody nvarchar(max)
,	@EmailHeader nvarchar(max) = N'Error in Inbound EDI Files'

select
	@EmailBody = N'<H1>' + @EmailHeader + N'</H1>' + @html

print @emailBody

exec msdb.dbo.sp_send_dbmail
	@profile_name = 'FxArmadaMail1'
,	@recipients = 'czurawski@armadarubber.com'
,	@copy_recipients = 'estimpson@fore-thought.com'
,	@subject = @EmailHeader
,	@body = @EmailBody
,	@body_format = 'HTML'
,	@importance = 'High'

update
	ed
set ed.Status = -1
from
	FxEDI.EDI.EDIDocuments ed
	join #errorFiles ef
		on ef.GUID = ed.GUID
GO
