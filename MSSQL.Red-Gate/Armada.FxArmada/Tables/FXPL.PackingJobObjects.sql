CREATE TABLE [FXPL].[PackingJobObjects]
(
[PackingJobNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PackingJo__Statu__5E7E8F11] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PackingJob__Type__5F72B34A] DEFAULT ((0)),
[Serial] [int] NOT NULL,
[Quantity] [numeric] (20, 6) NOT NULL,
[Printed] [bit] NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PackingJo__RowCr__6066D783] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PackingJo__RowCr__615AFBBC] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PackingJo__RowMo__624F1FF5] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PackingJo__RowMo__6343442E] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [FXPL].[tr_PackingJobObjects_uRowModified] on [FXPL].[PackingJobObjects] after update
as
declare
	@TranDT datetime
,	@Result int

set xact_abort off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FXPL.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	save tran @ProcName
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	
	--- <Body>
	if	not update(RowModifiedDT) begin
		--- <Update rows="*">
		set	@TableName = 'FXPL.PackingJobObjects'
		
		update
			pjo
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			FXPL.PackingJobObjects pjo
			join inserted i
				on i.RowID = pjo.RowID
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
		--- </Update>
		
		--- </Body>
	end
end try
begin catch
	declare
		@errorName int
	,	@errorSeverity int
	,	@errorState int
	,	@errorLine int
	,	@errorProcedures sysname
	,	@errorMessage nvarchar(2048)
	,	@xact_state int
	
	select
		@errorName = error_number()
	,	@errorSeverity = error_severity()
	,	@errorState = error_state ()
	,	@errorLine = error_line()
	,	@errorProcedures = error_procedure()
	,	@errorMessage = error_message()
	,	@xact_state = xact_state()

	if	xact_state() = -1 begin
		print 'Error number: ' + convert(varchar, @errorName)
		print 'Error severity: ' + convert(varchar, @errorSeverity)
		print 'Error state: ' + convert(varchar, @errorState)
		print 'Error line: ' + convert(varchar, @errorLine)
		print 'Error procedure: ' + @errorProcedures
		print 'Error message: ' + @errorMessage
		print 'xact_state: ' + convert(varchar, @xact_state)
		
		rollback transaction
	end
	else begin
		/*	Capture any errors in SP Logging. */
		rollback tran @ProcName
	end
end catch

---	<Return>
set	@Result = 0
return
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

begin transaction Test
go

insert
	FXPL.PackingJobObjects
...

update
	...
from
	FXPL.PackingJobObjects
...

delete
	...
from
	FXPL.PackingJobObjects
...
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
ALTER TABLE [FXPL].[PackingJobObjects] ADD CONSTRAINT [PK__PackingJ__FFEE74514DC3284F] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FXPL].[PackingJobObjects] ADD CONSTRAINT [UQ__PackingJ__8C92C2CB88BB297C] UNIQUE NONCLUSTERED  ([PackingJobNumber], [Serial]) ON [PRIMARY]
GO
ALTER TABLE [FXPL].[PackingJobObjects] ADD CONSTRAINT [FK__PackingJo__Packi__5D8A6AD8] FOREIGN KEY ([PackingJobNumber]) REFERENCES [FXPL].[PackingJobHeaders] ([PackingJobNumber])
GO
