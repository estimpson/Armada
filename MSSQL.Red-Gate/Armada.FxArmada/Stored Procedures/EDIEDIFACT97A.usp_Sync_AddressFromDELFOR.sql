SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EDIEDIFACT97A].[usp_Sync_AddressFromDELFOR]
	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings on
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIEDIFACT97A.usp_Test
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
insert
	dbo.AddressFromDELFOR
(	RawDocumentGUID
,	ReleaseNo
,	ConsigneeCode
,	ShipFromCode
,	SupplierCode
,	SupplierAdd1
,	SupplierAdd2
,	SupplierAdd3
,	SupplierAdd4
,	SupplierName
,	SupplierStreet
,	SupplierCity
,	SupplierCountrySUB
,	SupplierPostalCode
,	SupplierCountry
,	ShipToCode
,	ShipToAdd1
,	ShipToAdd2
,	ShipToAdd3
,	ShipToAdd4
,	ShipToName
,	ShipToStreet
,	ShipToCity
,	ShipToCountrySUB
,	ShipToPostalCode
,	ShipToCountry
)
select
	*
from
	EDIEDIFACT97A.AddressFromDELFOR afd
where
	not exists
		(	select
				*
			from
				dbo.AddressFromDELFOR afd2
			where
				afd2.RawDocumentGUID = afd.RawDocumentGUID
		)

delete
	afd
from
	dbo.AddressFromDELFOR afd
where
	not exists
		(	select
				*
			from
				EDIEDIFACT97A.AddressFromDELFOR afd2
			where
				afd2.RawDocumentGUID = afd.RawDocumentGUID
		)
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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDIEDIFACT97A.usp_Sync_AddressFromDELFOR
	@Param1 = @Param1
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
