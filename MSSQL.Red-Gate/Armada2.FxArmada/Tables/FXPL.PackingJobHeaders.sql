CREATE TABLE [FXPL].[PackingJobHeaders]
(
[PackingJobNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PackingJo__Packi__6EE357A3] DEFAULT ('0'),
[QualityBatchNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PackingJo__Statu__70CBA015] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PackingJob__Type__71BFC44E] DEFAULT ((0)),
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PackagingCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SpecialInstructions] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PieceWeightQuantity] [numeric] (20, 6) NOT NULL,
[PieceWeight] [numeric] (20, 6) NOT NULL,
[PieceWeightTolerance] [numeric] (20, 6) NOT NULL,
[PieceWeightValid] [bit] NOT NULL,
[PieceWeightDiscrepancyNote] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeflashOperator] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeflashMachine] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompleteBoxes] [int] NULL,
[PartialBoxQuantity] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PackingJo__RowCr__72B3E887] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PackingJo__RowCr__73A80CC0] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PackingJo__RowMo__749C30F9] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PackingJo__RowMo__75905532] DEFAULT (suser_name()),
[PackingOperator] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StandardPack] [numeric] (20, 6) NOT NULL,
[ShelfInventoryFlag] [int] NULL,
[JobDoneFlag] [int] NULL,
[PackingCompleteDT] [datetime] NULL,
[InspectionStartDT] [datetime] NULL,
[InspectionCompleteDT] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [FXPL].[tr_PackingJobHeaders_iAssignCode] on [FXPL].[PackingJobHeaders] for insert
as
set nocount on
set ansi_warnings off
declare
	@Result int

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
--- </Error Handling>

--- <Tran Required=No AutoCreate=No TranDTParm=No>
declare
	@TranDT datetime
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

--- <Body>
declare
	newRows cursor for
select
	i.RowID
from
	inserted i
where
	i.PackingJobNumber = '0'

open
	newRows

while
	1 = 1 begin
	
	declare
		@newRowID int
	
	fetch
		newRows
	into
		@newRowID
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	declare
		@NextNumber varchar(50)

	--- <Call>	
	set	@CallProcName = 'FT.usp_NextNumberInSequnce'
	execute
		@ProcReturn = FT.usp_NextNumberInSequnce
		@KeyName = 'FXPL.PackingJobHeaders.PackingJobNumber'
	,	@NextNumber = @NextNumber out
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return
	end
	--- </Call>

	--- <Update rows="1">
	set	@TableName = 'FXPL.PackingJobHeaders'

	update
		l
	set
		PackingJobNumber = @NextNumber
	from
		FXPL.PackingJobHeaders l
	where
		l.RowID = @newRowID

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
	--- </Body>
end

close
	newRows
deallocate
	newRows
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [FXPL].[tr_PackingJobHeaders_uRowModified] on [FXPL].[PackingJobHeaders] after update
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
		set	@TableName = 'FXPL.PackingJobHeaders'
		
		update
			pjh
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			FXPL.PackingJobHeaders pjh
			join inserted i
				on i.RowID = pjh.RowID
		
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
	FXPL.PackingJobHeaders
...

update
	...
from
	FXPL.PackingJobHeaders
...

delete
	...
from
	FXPL.PackingJobHeaders
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
ALTER TABLE [FXPL].[PackingJobHeaders] ADD CONSTRAINT [PK__PackingJ__FFEE74516913888D] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FXPL].[PackingJobHeaders] ADD CONSTRAINT [UQ__PackingJ__BD32CCC25F0793A4] UNIQUE NONCLUSTERED  ([PackingJobNumber]) ON [PRIMARY]
GO
ALTER TABLE [FXPL].[PackingJobHeaders] ADD CONSTRAINT [FK__PackingJo__Quali__000DE3A5] FOREIGN KEY ([QualityBatchNumber]) REFERENCES [dbo].[InventoryControl_QualityBatchHeaders] ([QualityBatchNumber])
GO
