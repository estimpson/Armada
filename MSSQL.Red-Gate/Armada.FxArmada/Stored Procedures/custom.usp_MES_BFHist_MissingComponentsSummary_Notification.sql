SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [custom].[usp_MES_BFHist_MissingComponentsSummary_Notification]
	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. custom.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare
	@FromDT datetime = FT.fn_TruncDate('day', getdate()) - .75
,	@ToDT datetime
set	@ToDT = @FromDT + 1

select
	umbhghs.PartProduced
,   umbhghs.WorkOrderNumber
,   umbhghs.JobID
,   umbhghs.QtyPerBox
,   umbhghs.BoxesProduced
,   umbhghs.MissingComponentCount
,   umbhghs.MissingDescription
into
	#BFHist_Summary
from
	dbo.usp_MES_BFHist_GetHistorySummary(@FromDT, @ToDT) umbhghs
where
	umbhghs.MissingComponentCount > 0

declare
	@html nvarchar(max)

--- <Call>	
set	@CallProcName = 'FT.usp_TableToHTML'
execute
	@ProcReturn = FT.usp_TableToHTML
	    @tableName = N'#BFHist_Summary'
	,   @html = @html out
	,   @orderBy = null
	,   @includeRowNumber = 1
	,   @camelCaseHeaders = 1 -- bit

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

--- <Call>
declare
	@EmailHeader nvarchar(max) = 'Missing Components in Backflush'
,	@EmailBody nvarchar(max)

set	@EmailBody = N'<H1>' + @EmailHeader + ': ' + convert(varchar, @FromDT) + ' to ' + convert(varchar, @ToDT) + N'</H1>' + @html

set	@CallProcName = 'msdb.dbo.sp_send_dbmail'
execute
	@ProcReturn = msdb.dbo.sp_send_dbmail
		@profile_name = 'Profile1'
	--,  	@recipients = 'estimpson@fore-thought.com'
	,  	@recipients = 'Mark.Scyzoryk@tsmcorp.com;Jim.Gasparovich@tsmcorp.com;danmiarka@TSMCorp.com'
	, 	@subject = @EmailHeader
	,  	@body = @EmailBody
	,  	@body_format = 'HTML'
	,	@importance = 'High'  -- varchar(6)	

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
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

declare
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = custom.usp_MES_BFHist_MissingComponentsSummary_Notification
	@Param1 = @Param1
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
