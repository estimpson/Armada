SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_Shipping_OverrideShipperListScanning]
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
/*	Validate Shipper Numbers. */
if	not exists
		(	select
				*
			from
				dbo.Shipping_DepartingShipperList sdsl
			where
				sdsl.ShipperNumber in
					(	select
							ShipperNumber = ltrim(fsstr.Value)
						from
							dbo.fn_SplitStringToRows(@ShipperNumberList, ',') fsstr
						where
							ltrim(fsstr.Value) > ''
					)
		)
	or exists
		(	select
				*
			from
				(	select
							ShipperNumber = ltrim(fsstr.Value)
						from
							dbo.fn_SplitStringToRows(@ShipperNumberList, ',') fsstr
						where
							ltrim(fsstr.Value) > ''
				) shippers
			where
				ShipperNumber not in
					(	select
							sdsl.ShipperNumber
						from
							dbo.Shipping_DepartingShipperList sdsl
					)
										
		) begin
	set	@Result = 999999
	RAISERROR ('Error overriding scan to truck in procedure %s.  Invalid shipper(s) list.', 16, 1, @ProcName, @ShipperNumberList)
	rollback tran @ProcName
	return
end
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

/*	Set the status of all objects staged to any shipper in the shipper list. */
--- <Update rows="1+">
set	@TableName = 'dbo.Shipping_Objects'
	
update
	so
set
	Status = -1
,	LoadingOperator = @User
from
	dbo.Shipping_Objects so
	join @shipperList sl
		on sl.ShipperNumber = so.ShipperNumber
	
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
set	@ShipperNumberList = 'L1054986,L1055000,L1054999'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_OverrideShipperListScanning
	@User = @User
,	@ShipperNumberList = @ShipperNumberList
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

--	commit
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
