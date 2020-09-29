SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_Shipping_CompleteShipperListDeparture]
	@User varchar(5)
,	@ShipperNumberList varchar(8000)
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
declare
	@shipperList table
(	ShipperNumber varchar(50)
,	LegacyShipperID int
)

insert
	@shipperList
select
	ShipperNumber = shippers.ShipperNumber
,	LegacyShipperID = convert(int, substring(shippers.ShipperNumber, 2, len(shippers.ShipperNumber) - 1))
from
	(	select
			ShipperNumber = ltrim(fsstr.Value)
		from
			dbo.fn_SplitStringToRows(@ShipperNumberList, ',') fsstr
		where
			ltrim(fsstr.Value) > ''
	) shippers
group by
	shippers.ShipperNumber

/*	Call shipout for each shipper in the list. */
declare
	shippers cursor local forward_only for
select
	sl.LegacyShipperID
from
	@shipperList sl

open
	shippers

while
	1 = 1 begin

	declare
		@shipperID int
	
	fetch
		shippers
	into
		@shipperID
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	--- <Call>	
	set	@CallProcName = 'dbo.usp_Shipping_ShipoutShipper'
	execute
		@ProcReturn = dbo.usp_Shipping_ShipoutShipper
			@User = @User
		,	@ShipperID = @shipperID
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
	  
end  
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
	@User varchar(5)
,	@ShipperNumberList varchar(8000)

set	@User = 'EES'
set	@ShipperNumberList = 'L1050558'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_CompleteShipperListDeparture
	@User = @User
,	@ShipperNumberList = @ShipperNumberList
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	dbo.audit_trail atS
where
	atS.type = 'S'
	and 'L' + atS.shipper = @ShipperNumberList
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
