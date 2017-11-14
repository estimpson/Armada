SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[usp_MES_BatchBackflush]
	@Operator varchar(5)
,	@Override char(1)
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
/*	Discard any shortages where the job complete audit trail doesn't exist (serial was deleted). */
--- <Update rows="*">
set	@TableName = 'dbo.BackflushHeaders'

update
	bh
set	Status = -2
from
	dbo.BackflushHeaders bh
	join dbo.BackflushDetails bd
		on bd.BackflushNumber = bh.BackflushNumber
where
	bh.Status = -1
	and bd.QtyOverage > 0
	and bh.SerialProduced not in
		(	select
				Serial = at.serial
			from
				dbo.audit_trail at
				join dbo.part pFin
					on pFin.part = at.part
					and pFin.type = 'F'
				left join dbo.location l
					on l.code = at.to_loc
				left join dbo.part_machine pm
					on pm.part = at.part
					and pm.sequence = 1
			where
				at.type = 'J'
				and at.BF_Number is null
		)

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

declare
	completions cursor local read_only for
select
	Serial = at.serial
,	PartCode = at.part
,	PrimaryMachine = COALESCE(pm.machine,'PACKING')
,	Quantity = at.std_quantity
,	ToLoc = at.to_loc
,	WorkOrder = nullif(at.workorder, '')
,	Plant = l.plant
,	ATID = at.id
from
	dbo.audit_trail at
	join dbo.part pFin
		on pFin.part = at.part
		and pFin.type = 'F'
	left join dbo.location l
		on l.code = at.to_loc
	left join dbo.part_machine pm
		on pm.part = at.part
		and pm.sequence = 1
where
	at.type = 'J'
	and at.BF_Number is null

open
	completions

while
	1 = 1 begin
	
	declare
		@Serial int
	,	@PartCode varchar(50)
	,	@PrimaryMachine varchar(50)
	,	@Quantity numeric(20,6)
	,	@ToLoc varchar(50)
	,	@WorkOrder varchar(50)
	,	@Plant varchar(50)
	,	@ATID int

	fetch
		completions
	into
		@Serial
	,	@PartCode
	,	@PrimaryMachine
	,	@Quantity
	,	@ToLoc
	,	@WorkOrder
	,	@Plant
	,	@ATID

	if	@@FETCH_STATUS != 0 begin
		break
	end

	if	exists
		(	select
				*
			from
				dbo.BackflushHeaders bh
			where
				bh.SerialProduced = @Serial
				and bh.Status = -1
		) begin

		--- <Update rows="1+">
		set	@TableName = 'dbo.BackflushHeaders'
	
		update
			bh
		set
			Status = -2
		from
			dbo.BackflushHeaders bh
		where
			bh.SerialProduced = @Serial
			and bh.Status = -1
	
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
	
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
		if	@RowCount !> 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
			rollback tran @ProcName
			return
		end
		--- </Update>
	end

	/*	Create back flush header.  */
	--- <Insert rows="1">
	set	@TableName = 'dbo.BackflushHeaders'

	insert
		dbo.BackflushHeaders
	(	Status
	,	MachineCode
	,	PartProduced
	,	SerialProduced
	,	QtyProduced
	,	TranDT
	)
	select
		Status = case when @Override = 'Y' then 0 else 1 end
	,	MachineCode = @PrimaryMachine
	,	PartCode = @PartCode
	,	SerialProduced = @Serial
	,	QtyProduced = @Quantity
	,	TranDT = @TranDT

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

	declare
		@NewBackflushNumber varchar(50)

	set	@NewBackflushNumber =
		(	select
	 			bh.BackflushNumber
	 		from
	 			dbo.BackflushHeaders bh
	 		where
	 			bh.RowID = scope_identity()
		)

	/*	Perform back flush.  */
	execute @ProcReturn = dbo.usp_MES_Backflush
		@Operator = @Operator
	,	@BackflushNumber = @NewBackflushNumber
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out

	set @Error = @@Error
	if @ProcResult != 0 
		begin
			set @Result = 999999
			raiserror ('An error result was returned from the procedure %s', 16, 1, 'ProdControl_BackFlush')
			rollback tran @ProcName
			return
		end
	if @ProcReturn != 0 
		begin
			set @Result = 999999
			raiserror ('An error was returned from the procedure %s', 16, 1, 'ProdControl_BackFlush')
			rollback tran @ProcName
			return
		end
	if @Error != 0 
		begin
			set @Result = 999999
			raiserror ('An error occurred during the execution of the procedure %s', 16, 1, 'ProdControl_BackFlush')
			rollback tran @ProcName
			return
		end
	
	declare
		@bfhStatus int
	,	@bfRowID int

	select
		@bfhStatus = bh.Status
	,	@bfRowID = bh.RowID
	from
		dbo.BackflushHeaders bh
	where
		BackflushNumber = @NewBackflushNumber

	if	@bfhStatus = 0
		begin

		--- <Update rows="1">
		set	@TableName = 'dbo.audit_trail'
		
		update
			at
		set
			BF_Number = @bfRowID
		from
			dbo.audit_trail at
		where
			at.id = @ATID
		
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
			RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			rollback tran @ProcName
			return
		end
		--- </Update>
		
	end
end
close
	completions
deallocate
	completions

/*	Update part online. */
--- <Call>	
set	@CallProcName = 'dbo.usp_InventoryControl_UpdatePartOnHand'
execute
	@ProcReturn = dbo.usp_InventoryControl_UpdatePartOnHand
	    @PartCode = null
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out

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
	@Override char(1)
,	@Operator varchar(5)

set	@Override = 'N'
set	@Operator = 'EES'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_MES_BatchBackflush
	@Operator = @Operator
,	@Override = @Override
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
