CREATE TABLE [support].[order_detail_Audit]
(
[ShipperID] [int] NULL,
[PreFlag] [bit] NOT NULL,
[id] [int] NULL,
[order_no] [numeric] (8, 0) NULL,
[sequence] [numeric] (5, 0) NULL,
[part_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [numeric] (20, 6) NULL,
[price] [numeric] (20, 6) NULL,
[notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[assigned] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shipped] [numeric] (20, 6) NULL,
[invoiced] [numeric] (20, 6) NULL,
[status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[our_cum] [numeric] (20, 6) NULL,
[the_cum] [numeric] (20, 6) NULL,
[due_date] [datetime] NULL,
[destination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unit] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[committed_qty] [numeric] (20, 6) NULL,
[row_id] [int] NULL,
[group_no] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cost] [numeric] (20, 6) NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[release_no] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag] [int] NULL,
[week_no] [int] NULL,
[std_qty] [numeric] (20, 6) NULL,
[customer_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_po] [int] NULL,
[dropship_po_row_id] [int] NULL,
[suffix] [int] NULL,
[packline_qty] [numeric] (20, 6) NULL,
[packaging_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weight] [numeric] (20, 6) NULL,
[custom01] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom02] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom03] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dimension_qty_string] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[engineering_level] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[box_label] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pallet_label] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alternate_price] [decimal] (20, 6) NULL,
[promise_date] [datetime] NULL,
[RowId] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL,
[RowCreateUser] [sys].[sysname] NULL,
[RowModifiedDT] [datetime] NULL,
[RowModifiedUser] [sys].[sysname] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [support].[tr_order_detail_Audit_uRowModified] on [support].[order_detail_Audit] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. support.usp_Test
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
		set	@TableName = 'support.order_detail_Audit'
		
		update
			odAud
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			support.order_detail_Audit odAud
			join inserted i
				on i.RowID = odAud.RowID
		
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
	support.order_detail_Audit
...

update
	...
from
	support.order_detail_Audit
...

delete
	...
from
	support.order_detail_Audit
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
ALTER TABLE [support].[order_detail_Audit] ADD CONSTRAINT [PK__order_de__FFEE7431D10C2525] PRIMARY KEY CLUSTERED  ([RowId]) ON [PRIMARY]
GO
