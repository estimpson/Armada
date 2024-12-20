SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_Notification_POSendEmail]
	@PONumber int
,	@EmailTo nvarchar(4000)
,	@EmailCC nvarchar(4000)
,	@EmailReplyTo nvarchar(4000)
,	@EmailSubject nvarchar(4000)
,	@EmailBody nvarchar(4000)
,	@EmailAttachmentNames nvarchar(4000)
,	@EmailFrom nvarchar(4000)
,	@MailItemID int = null out
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
--- <Call>	
set	@CallProcName = 'dbo.usp_Notification_SendEmail'
execute
	@ProcReturn = dbo.usp_Notification_SendEmail
	@EmailTo = @EmailTo
,	@EmailCC = @EmailCC
,	@EmailReplyTo = @EMailReplyTo
,	@EmailSubject = @EmailSubject
,	@EmailBody = @EmailBody
,	@EmailAttachmentNames = @EmailAttachmentNames
,	@EmailFrom = @EmailFrom
,	@MailItemID = @MailItemID out
,	@TranDT = @TranDT out
,	@Result = @Result out

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

--- <Insert rows="1">
set	@TableName = 'dbo.Notification_POLog'

insert
	dbo.Notification_POLog
(	PONumber
,	EmailTo
,	EmailCC
,	EmailReplyTo
,	EmailSubject
,	EmailBody
,	EmailAttachmentNames
,	EmailFrom
,	MailItemID
)
select
	PONumber = @PONumber
,	EmailTo = @EmailTo
,	EmailCC = @EmailCC
,	EmailReplyTo = @EmailReplyTo
,	EmailSubject = @EmailSubject
,	EmailBody = @EmailBody
,	EmailAttachmentNames = @EmailAttachmentNames
,	EmailFrom = @EmailFrom
,	MailItemID = @MailItemID

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
--- </Body>

--- <Tran AutoClose=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </Tran>

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
	@ProcReturn = dbo.usp_Notification_POSendEmail
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
