SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[Shipping_DepartingShipperList]
as
select
	so.ShipperNumber
,	CustomerCode = coalesce(sD.customer, v.code)
,	CustomerName = coalesce(c.name, v.name)
,	ShipToCode = sD.destination
,	ShipToName = d.name
,	TruckNumber = sD.truck_number
,	PRONumber = sD.pro_number
,	LegacyShipperID = sD.id
,	IsVerified =
		case when count(case when so.Status = 0 then 1 end) > 0 then 0 else 1 end
,	ObjectCount = count(*)
,	LooseBoxCount = count(case when so.Type = 1 then 1 end)
,	PalletCount = count(case when so.Type = 2 then 1 end)
,	BoxOnPalletCount = count(case when so.Type = 3 then 1 end)
,	VerifiedLooseBoxCount = count(case when so.Status != 0 and so.Type = 1 then 1 end)
,	VerifiedPalletCount = count(case when so.Status != 0 and so.Type = 2 then 1 end)
,	VerifiedBoxOnPalletCount = count(case when so.Status != 0 and so.Type = 3 then 1 end)
,	DepartureBeginDT = min(so.RowCreateDT)
,	IsOverrideScanning = case when count(case when so.Status = -1 then 1 end) > 0 then 1 else 0 end
from
	dbo.Shipping_Objects so
		join dbo.shipper sD
			on 'L' + convert(varchar(49), sd.id) = so.ShipperNumber
			and sD.status = 'D'
		join dbo.destination d
			on d.destination = sD.destination
		left join dbo.customer c
			on c.customer = sD.customer
		left join dbo.vendor v
			on v.code = d.vendor
group by
	so.ShipperNumber
,	sD.customer
,	c.name
,	v.code
,	v.name
,	sD.destination
,	d.name
,	sD.truck_number
,	sD.pro_number
,	sD.ID
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_Shipping_DepartingShipperList_PRONumberUpdate] on [dbo].[Shipping_DepartingShipperList] instead of update
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
	--- <Update rows="1">
	set	@TableName = 'dbo.shipper'
	
	update
		s
	set
		pro_number = sdsl.PRONumber
	from
		dbo.shipper s
		join inserted sdsl
			on sdsl.LegacyShipperID = s.id
	
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
	dbo.Shipping_DepartingShipperList
...

update
	...
from
	dbo.Shipping_DepartingShipperList
...

delete
	...
from
	dbo.Shipping_DepartingShipperList
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
