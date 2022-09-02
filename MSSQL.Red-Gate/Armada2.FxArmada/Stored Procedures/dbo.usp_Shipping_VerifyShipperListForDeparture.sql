SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_Shipping_VerifyShipperListForDeparture]
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
declare
	@shippers table
(	ShipperNumber varchar(50)
,	LegacyShipperID int
)

insert
	@shippers
select
	ShipperNumber = shippers.ShipperNumber
,	LegacyShipperID = substring(shippers.ShipperNumber, 2, len(shippers.ShipperNumber) - 1)
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

/*	Validate that all shippers are valid. */
if	(	select
  			count(*)
  		from
  			@shippers
  	) !=
	(	select
			count(distinct s.id)
		from
			dbo.shipper s
				join @shippers sl
					on sl.LegacyShipperID = s.id
	) begin
    
	set	@Result = 999999
	RAISERROR ('Error during verification of shippers for departure in procedure %s.  A shipper in the list (%s) was not found.', 16, 1, @ProcName, @ShipperNumberList)
	rollback tran @ProcName
	return
end

/*	Validate that all shippers are staged. */
if	exists
	(	select
			*
		from
			dbo.Shipping_OpenShipperList sosl
				join @shippers sl
					on sl.ShipperNumber = sosl.ShipperNumber
		where
			sosl.IsStaged != 1
	) begin
    
	set	@Result = 999999
	RAISERROR ('Error during verification of shippers for departure in procedure %s.  A shipper in the list (%s) is not staged.', 16, 1, @ProcName, @ShipperNumberList)
	rollback tran @ProcName
	return
end

/*	Validate that all shippers have their packing list printed. */
if	exists
	(	select
			*
		from
			dbo.Shipping_OpenShipperList sosl
				join @shippers sl
					on sl.ShipperNumber = sosl.ShipperNumber
		where
			sosl.PacklistPrinted != 1
	) begin
    
	set	@Result = 999999
	RAISERROR ('Error during verification of shippers for departure in procedure %s.  A shipper in the list (%s) is not printed.', 16, 1, @ProcName, @ShipperNumberList)
	rollback tran @ProcName
	return
end

/*	Additional verifications can be added and optionally enforced by global switch. */
---	</ArgumentValidation>

--- <Body>
/*	Empty. */
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
set	@ShipperNumberList = 'L1050514,'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_VerifyShipperListForDeparture
	@User = @User
,	@ShipperNumberList = @ShipperNumberList
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
