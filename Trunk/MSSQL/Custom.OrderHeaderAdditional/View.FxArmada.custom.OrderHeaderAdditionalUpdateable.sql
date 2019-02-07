
/*
Create View.FxArmada.custom.OrderHeaderAdditionalUpdateable.sql
*/

use FxArmada
go

--drop table custom.OrderHeaderAdditionalUpdateable
if	objectproperty(object_id('custom.OrderHeaderAdditionalUpdateable'), 'IsView') = 1 begin
	drop view custom.OrderHeaderAdditionalUpdateable
end
go

create view custom.OrderHeaderAdditionalUpdateable
as
select
	oh.order_no
,	oh.order_date
,	oh.blanket_part
,	oh.customer
,	oh.destination
,	oh.model_year
,	oh.customer_part
,	oh.custom01
,	oh.custom02
,	oh.custom03
,	oh.contact
,	oh.unit
,	oh.begin_kanban_number
,	oh.end_kanban_number
,	oh.line11
,	oh.line12
,	oh.line13
,	oh.line14
,	oh.line15
,	oh.line16
,	oh.line17
,	oha.PPAP_DueDate
,	oha.PPAP_RawDate
,	oha.CustomerPartDescription
,	oha.Custom1
,	oha.Custom2
from
	dbo.order_header oh
	left join custom.OrderHeaderAdditional oha
		on oha.OrderNo = oh.order_no
go


/*
Create ViewTrigger.FxArmada.dbo.tr_OrderHeaderAdditionalUpdateable_u.View.dbo.OrderHeaderAdditionalUpdateable.sql
*/

--use FxArmada
--go

if	objectproperty(object_id('custom.tr_OrderHeaderAdditionalUpdateable_u'), 'IsTrigger') = 1 begin
	drop trigger custom.tr_OrderHeaderAdditionalUpdateable_u
end
go

create trigger custom.tr_OrderHeaderAdditionalUpdateable_u on custom.OrderHeaderAdditionalUpdateable instead of update
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
	/*	Create custom.OrderHeaderAdditional row if missing. */
	if	exists
		(	select
				*
			from
				Inserted i
			where
				not exists
					(	select
							*
						from
							custom.OrderHeaderAdditional oha
						where
							oha.OrderNo = i.order_no
					)
		) begin
			--- <Insert rows="1+">
			set	@TableName = 'custom.OrderHeaderAdditional'
		
			insert
				custom.OrderHeaderAdditional
				(	OrderNo
				,	PPAP_DueDate
				,	PPAP_RawDate
				,	CustomerPartDescription
				,	Custom1
				,	Custom2
				)
			select
				i.order_no
			,	i.PPAP_DueDate
			,	i.PPAP_RawDate
			,	i.CustomerPartDescription
			,	i.Custom1
			,	i.Custom2
			from
				Inserted i
			where
				not exists
					(	select
							*
						from
							custom.OrderHeaderAdditional oha
						where
							oha.OrderNo = i.order_no
					)
		
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
		
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount <= 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Insert>
		end

	/*	Do updates. */
	--- <Update rows="*">
	set	@TableName = 'dbo.order_header'
	
	update
		oh
	set
		oh.order_date = i.order_date
	,	oh.blanket_part = i.blanket_part
	,	oh.customer = i.customer
	,	oh.destination = i.destination
	,	oh.model_year = i.model_year
	,	oh.customer_part = i.customer_part
	,	oh.custom01 = i.custom01
	,	oh.custom02 = i.custom02
	,	oh.custom03 = i.custom03
	,	oh.contact = i.contact
	,	oh.unit = i.unit
	,	oh.begin_kanban_number = i.begin_kanban_number
	,	oh.end_kanban_number = i.end_kanban_number
	,	oh.line11 = i.line11
	,	oh.line12 = i.line12
	,	oh.line13 = i.line13
	,	oh.line14 = i.line14
	,	oh.line15 = i.line15
	,	oh.line16 = i.line16
	,	oh.line17 = i.line17
	from
		dbo.order_header oh
		join Inserted i
			on i.order_no = oh.order_no
	
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

	--- <Update rows="*">
	set	@TableName = 'custom.OrderHeaderAdditional'
	
	update
		oha
	set
		oha.PPAP_DueDate = i.PPAP_DueDate
	,	oha.PPAP_RawDate = i.PPAP_RawDate
	,	oha.CustomerPartDescription = i.CustomerPartDescription
	,	oha.Custom1 = i.Custom1
	,	oha.Custom2 = i.Custom2
	from
		custom.OrderHeaderAdditional oha
		join Inserted i
			on i.order_no = oha.OrderNo
	
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
	dbo.OrderHeaderAdditionalUpdateable
...

update
	...
from
	dbo.OrderHeaderAdditionalUpdateable
...

delete
	...
from
	dbo.OrderHeaderAdditionalUpdateable
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
go

