SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_Shipping_PartPackaging_SetDefaultPack]
	@ShipperID int
,	@ShipperPart varchar(35)
,	@PackagingCode varchar(20)
,	@TranDT datetime out
,	@Result integer out
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
/*	Set this package type as the default. */
--- <Update rows="1">
set	@TableName = 'dbo.Shipping_PartPackaging_Setup'

update
	spps
set
	PackDisabled = 0
,	PackEnabled = 1
,	PackDefault = 1
,	PackWarn = 0
from
	dbo.Shipping_PartPackaging_Setup spps
where
	spps.ShipperID = @ShipperID
	and spps.ShipperPart = @ShipperPart
	and spps.PackagingCode = @PackagingCode

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

/*	Make any other default package types not the default. */
--- <Update rows="*">
set	@TableName = 'dbo.Shipping_PartPackaging_Setup'

update
	spps
set
	PackDefault = 0
from
	dbo.Shipping_PartPackaging_Setup spps
where
	spps.ShipperID = @ShipperID
	and spps.ShipperPart = @ShipperPart
	and spps.PackagingCode != @PackagingCode
	and spps.PackDefault = 1

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

if	@TranCount = 0 begin
	commit tran @ProcName
	return
end

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
	@ShipperID int
,	@ShipperPart varchar(35)
,	@PackagingCode varchar(20)

set	@ShipperID = 56583
set	@ShipperPart = '2759'
set	@PackagingCode = 'PLT91'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_PartPackaging_SetDefaultPack
	@ShipperID = @ShipperID
,	@ShipperPart = @ShipperPart
,	@PackagingCode = @PackagingCode
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
