CREATE TABLE [custom].[OrderHeaderAdditional]
(
[OrderNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__OrderHead__Order__25190DDC] DEFAULT ('0'),
[Status] [int] NOT NULL CONSTRAINT [DF__OrderHead__Statu__260D3215] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__OrderHeade__Type__2701564E] DEFAULT ((0)),
[PPAP_DueDate] [datetime] NULL,
[PPAP_RawDate] [datetime] NULL,
[CustomerPartDescription] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__OrderHead__RowCr__27F57A87] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__OrderHead__RowCr__28E99EC0] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__OrderHead__RowMo__29DDC2F9] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__OrderHead__RowMo__2AD1E732] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [custom].[tr_OrderHeaderAdditional_uRowModified] on [custom].[OrderHeaderAdditional] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. custom.usp_Test
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
		set	@TableName = 'custom.OrderHeaderAdditional'
		
		update
			oha
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			custom.OrderHeaderAdditional oha
			join inserted i
				on i.RowID = oha.RowID
		
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
	custom.OrderHeaderAdditional
...

update
	...
from
	custom.OrderHeaderAdditional
...

delete
	...
from
	custom.OrderHeaderAdditional
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
ALTER TABLE [custom].[OrderHeaderAdditional] ADD CONSTRAINT [PK__OrderHea__FFEE7451EC9DBEFC] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [custom].[OrderHeaderAdditional] ADD CONSTRAINT [UQ__OrderHea__C3907C7574659A98] UNIQUE NONCLUSTERED  ([OrderNo]) ON [PRIMARY]
GO
