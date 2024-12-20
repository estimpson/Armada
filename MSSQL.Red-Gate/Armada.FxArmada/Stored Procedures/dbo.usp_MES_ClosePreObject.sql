SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_MES_ClosePreObject]
	@Operator varchar (10)
,	@PreObjectSerial int
,	@TranDT datetime out
,	@Result int out
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
/*	Operator required:  */
if	not exists
	(	select
			1
		from
			employee
		where
			operator_code = @Operator
	) begin

	set @Result = 60001
	RAISERROR ('Invalid operator code %s in procedure %s.  Error: %d', 16, 1, @Operator, @ProcName, @Error)
	rollback tran @ProcName
	return
end

if	coalesce
	(	(	select
				max(part)
			from
				audit_trail
			where
				serial = @PreObjectSerial
			)
	,	''
	) = 'PALLET' begin
	set @Result = 0
	rollback tran @ProcName
	return	@Result
end

/*	Serial must be a Pre-Object:  */
if	not exists
	(	select
			*
		from
			dbo.WorkOrderObjects
		where
			Serial = @PreObjectSerial
	) begin
	set @Result = 100101
	RAISERROR ('Invalid pre-object serial %d in procedure %s.  Error: %d', 16, 1, @PreObjectSerial, @ProcName, @Error)
	rollback tran @ProcName
	return
end

/*	If PreObject has already been Job Completed, do nothing:  */
if	exists
	(	select
			*
		from
			audit_trail
		where
			type = 'J'
			and serial = @PreObjectSerial
	) begin
	set	@Result = 100100
	RAISERROR ('Serial %d already job completed in procedure %s.  Warning: %d', 10, 1, @PreObjectSerial, @ProcName, @Error)
	rollback tran @ProcName
	return
end

/*	Quantity must be valid:  */
declare
	@QtyRequested numeric(20,6)

select
	@QtyRequested = woo.Quantity
from
	dbo.WorkOrderObjects woo
where
	woo.Serial = @PreObjectSerial

if	not coalesce(@QtyRequested, 0) > 0 begin
	set @Result = 202001
	RAISERROR ('Invalid quantity requested %d in procedure %s.  Error: %d', 16, 1, @QtyRequested, @ProcName, @Error)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>

--- <Body>
/*	If this box exists, delete it.  */
if	exists
	(	select
			*
		from
			dbo.object o
		where
			o.serial = @PreObjectSerial
	) begin

	--- <Delete rows="1">
	set	@TableName = 'dbo.object'
	
	delete
		o
	from
		dbo.object o
	where
		o.serial = @PreObjectSerial
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Delete>
	
end
--- </Body>

--- <CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </CloseTran Required=Yes AutoCreate=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{
select
	*
from
	dbo.WorkOrderObjects woo
}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@Operator varchar(10)
,	@PreObjectSerial int

set	@Operator = 'ees'
set	@PreObjectSerial = 1844074

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_MES_ClosePreObject
	@Operator = @Operator
,	@PreObjectSerial = @PreObjectSerial
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	audit_trail
where
	date_stamp = @TranDT

select
	*
from
	object
where
	serial = @PreObjectSerial

--commit
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
