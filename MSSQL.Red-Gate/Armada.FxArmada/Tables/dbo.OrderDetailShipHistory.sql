CREATE TABLE [dbo].[OrderDetailShipHistory]
(
[ShipperID] [int] NOT NULL,
[OrderNo] [int] NOT NULL,
[OH_OrderAccum] [numeric] (20, 6) NULL,
[SnapShotType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OD_OrderID] [int] NOT NULL,
[OD_Sequence] [int] NOT NULL,
[OD_RowID] [int] NOT NULL,
[OD_PartNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OD_Quantity] [numeric] (20, 6) NOT NULL,
[OD_StdQuantity] [numeric] (20, 6) NOT NULL,
[OD_DueDate] [datetime] NOT NULL,
[OD_ForecastType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OD_Unit] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OD_PriorAccum] [numeric] (20, 6) NULL,
[OD_PostAccum] [numeric] (20, 6) NULL,
[OD_ReleaseNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OD_RowCreateDT] [datetime] NULL,
[OD_RowCreateUser] [sys].[sysname] NULL,
[OD_RowModifiedDT] [datetime] NULL,
[OD_RowModifiedUser] [sys].[sysname] NULL,
[OD_XML] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__OrderDeta__RowCr__079A7747] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__OrderDeta__RowCr__088E9B80] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__OrderDeta__RowMo__0982BFB9] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__OrderDeta__RowMo__0A76E3F2] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_OrderDetailShipHistory_uRowModified] on [dbo].[OrderDetailShipHistory] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
		set	@TableName = 'dbo.OrderDetailShipHistory'
		
		update
			odsh
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			dbo.OrderDetailShipHistory odsh
			join inserted i
				on i.RowID = odsh.RowID
		
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
	dbo.OrderDetailShipHistory
...

update
	...
from
	dbo.OrderDetailShipHistory
...

delete
	...
from
	dbo.OrderDetailShipHistory
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
ALTER TABLE [dbo].[OrderDetailShipHistory] ADD CONSTRAINT [PK__OrderDet__FFEE7451461781BE] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
