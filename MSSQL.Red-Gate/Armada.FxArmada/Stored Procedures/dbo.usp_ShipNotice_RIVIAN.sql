SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_ShipNotice_RIVIAN]
	@ShipperID int
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
set	@TranDT = coalesce(@TranDT, getdate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare
	@PartialComplete char(1) = 'P'

create table
	#ASNFlatFile
(	LineId int identity
,	LineData char(79)
)

--	Line //
insert
	#ASNFlatFile
(
	LineData
)
select
	+	convert(char(12), '//STX12//856')
		-- 001-002 003-009 010-012: LineNo Mandatory 
	+	convert(char(12), coalesce(es.trading_partner_code, 'RIVIAN'))
		-- 013-024: Trading Partner
	+	convert(char(30), s.id)
		-- 025-054: Document Number
	+	@PartialComplete
from
	dbo.shipper s
	join dbo.edi_setups es
		on es.destination = s.destination
where
	s.id = @ShipperID

--	Line 01 -- Shipper ID
insert
	#ASNFlatFile
(	LineData
)
select
	'01'
		-- 001-002: LineNo
	+	'00'
		-- 003-004: BSN01 - Purpose Code
	+	convert(char(30), s.id)
		-- 005-034: BSN02 - Shipment Id  
	+	convert(char(8), @TranDT, 112)
		-- 035-042: BSN03 - ASN Date
	+	left(replace(convert(char(8), @TranDT, 108), ':', ''),4)
		-- 043-050: BSN04 - Time
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 02 -- Ship Date
insert
	#ASNFlatFile
(	LineData
)
select
	'02'
		-- 001-002: LineNo
	+	convert(char(8), @TranDT, 112)
		-- 003-009: DTM02 - Shipped Date
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 03 -- Gross Weight
insert
	#ASNFlatFile
(	LineData
)
select
	'03'
		-- 001-002: LineNo
	+	'WT'
		-- 003-004: MEA01 - Measurement Code
	+	convert(char(3), 'G')
		-- 005-007: MEA02 - Type (Gross)
	+	convert(char(22), convert(int, s.gross_weight))
		-- 008-029: MEA03 - Gross Weight
	+	'LB'
		-- 030-031: MEA0401 - UOM
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 04 -- Net Weight
insert
	#ASNFlatFile
(	LineData
)
select
	'04'
		-- 001-002: LineNo
	+	'WT'
		-- 003-004: MEA01 - Measurement Code
	+	convert(char(3), 'N')
		-- 005-007: MEA02 - Type (Net)
	+	convert(char(22), convert(int, s.net_weight))
		-- 008-029: MEA03 - Net Weight
	+	'LB'
		-- 030-031: MEA0401 - UOM
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 05 -- Lading Quantity
insert
	#ASNFlatFile
(	LineData
)
select
	'05'
		-- 001-002: LineNo
	+	convert(char(5), case when pm.returnable = 'Y' then 'AAA' else 'PLT' end)
		-- 003-007: TD101 - Package Code
	+	convert(char(8), count(*))
		-- 008-015: TD102 - Lading Quantity
from
	dbo.audit_trail at
	left join dbo.package_materials pm
		on pm.code = at.package_type
where
	at.type = 'S'
	and at.shipper = convert(varchar(12), @ShipperID)
	and at.object_type = 'S'
group by
	pm.returnable
union all
select
	'05'
		-- 001-002: LineNo
	+	convert(char(5), case when pm.returnable = 'Y' then 'CNT' else 'CTN' end)
		-- 003-007: TD101 - Package Code
	+	convert(char(8), count(*))
		-- 008-015: TD102 - Lading Quantity
from
	dbo.audit_trail at
	left join dbo.package_materials pm
		on pm.code = at.package_type
where
	at.type = 'S'
	and at.shipper = convert(varchar(12), @ShipperID)
	and at.object_type is null
group by
	pm.returnable

--	Line 06-07 -- Carrier
insert
	#ASNFlatFile
(	LineData
)
select
	'06'
		-- 001-002: LineNo
	+	convert(char(4), s.ship_via)
		-- 003-006: TD503 - Scac
	+	convert(char(2), 'H')
		-- 007-008: TD504 - Transportation Type
	+	convert(char(15), c.name)
		-- 009-043: TD505
from
	dbo.shipper s
	left join dbo.carrier c
		on c.scac = s.ship_via
where
	s.id = @ShipperID

--	Line 08 -- Truck
insert
	#ASNFlatFile
(	LineData
)
select
	'07'
		-- 001-002: LineNo
	+	'TL'
		-- 003-004: TD301 - Equipment Description Code
	+	convert(char(15), s.truck_number)
		-- 005-019: TD303 - Equipment Description Code
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 09 -- Tracking (BOL)
insert
	#ASNFlatFile
(	LineData
)
select
	'08'
		-- 001-002: LineNo
	+	convert(char(3), 'BM')
		-- 003-005: 2REF01 - Reference Id Type (BOL)
	+	convert(char(50), coalesce(s.bill_of_lading_number, s.id))
		-- 006-055: 2REF02 - Reference Id (BOL)
from
	dbo.shipper s
where
	s.id = @ShipperID

declare
	ShipperLines cursor local read_only
for
select
	coalesce(es.EDIShipToID, es.material_issuer)
,	d.name
,	d.address_1
,	d.address_2
,	d.address_3
,	es.supplier_code
,	sd.part_original
,	coalesce(nullif(sd.customer_po, ''), sd.release_no)
,	sd.release_no
,	sd.customer_part
,	PackDetails.BoxPackType
,	PackDetails.BoxPackName
,	PackDetails.BoxReturnable
,	PackDetails.PalletPackName
,	PackDetails.PalletReturnable
,	PackDetails.PackCount
,	PackDetails.PackQuantity
,	dock_code = oh.dock_code
from
	dbo.shipper_detail sd
		join dbo.order_header oh
			join dbo.destination d
				on d.destination = oh.destination
			join dbo.edi_setups es
				on es.destination = oh.destination
			on oh.order_no = sd.order_no
	cross apply
		(	select
				BoxPackType = at.package_type
			,	BoxPackName = coalesce(pm.name, at.package_type)
			,	BoxReturnable = coalesce(pm.returnable, 'N')
			,	PalletPackName = coalesce(pmPallet.name, atPallet.package_type)
			,	PalletReturnable = coalesce(pmPallet.returnable, 'N')
			,	PackQuantity = at.quantity
			,	PackCount = count(*)
			from
				dbo.audit_trail at
				left join dbo.package_materials pm
					on pm.code = at.package_type
				left join dbo.audit_trail atPallet
					left join dbo.package_materials pmPallet
						on pmPallet.code = atPallet.package_type
					on atPallet.type = 'S'
					and atPallet.shipper = convert(varchar(12), @ShipperID)
					and atPallet.serial = at.parent_serial
			where
				at.type = 'S'
				and at.part = sd.part_original
				and at.shipper = convert(varchar(12), @ShipperID)
			group by
				at.package_type
			,	coalesce(pm.name, at.package_type)
			,	coalesce(pm.returnable, 'N')
			,	coalesce(pmPallet.name, atPallet.package_type)
			,	coalesce(pmPallet.returnable, 'N')
			,	at.quantity
		) PackDetails
where
	sd.shipper = @ShipperID
	and sd.part not like 'CUM%'

open ShipperLines

declare
	@lineNo int = 1

while
	1 = 1 begin

	declare
		@shipTo varchar(20)
	,	@shipToName varchar(50)
	,	@shipToAddress1 varchar(50)
	,	@shipToAddress2 varchar(50)
	,	@shipToAddress3 varchar(50)
	,	@supplierCode varchar(20)
	,	@part varchar(25)
	,	@customerPO char(22)
	,	@releaseNo char(30)
	,	@customerPart varchar(30)
	,	@packageType varchar(25)
	,	@packageCodeEDI varchar(25)
	,	@returnableBox char(1)
	,	@palletCodeEDI varchar(25)
	,	@returnablePallet char(1)
	,	@packCount int
	,	@quantity int
	,	@dockCode char(50)

	fetch
		ShipperLines
	into
		@shipTo
	,	@shipToName
	,	@shipToAddress1
	,	@shipToAddress2
	,	@shipToAddress3
	,	@supplierCode
	,	@part
	,	@customerPO
	,	@releaseNo
	,	@customerPart
	,	@packageType
	,	@packageCodeEDI
	,	@returnableBox
	,	@palletCodeEDI
	,	@returnablePallet
	,	@packCount
	,	@quantity
	,	@dockCode

	if	@@FETCH_STATUS != 0 break

	-- Line 09-12 -- Part / Pack / Qty
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'09'
			-- 001-002: LineNo
		+	convert(char(20), @lineNo)
			-- 003-022: LIN01 - Line #
		+	'BP'
			-- 023-024: LIN02 - Product Id Type (Buyer's Part)
		+	convert(char(48), @customerPart)
			-- 025-072: LIN03 - Product Id (Buyer's Part)
		+	convert(char(2), '')
		--+	'CH'
			-- 073-074: LIN04 - Product Id Type (Country of Origin)
	union all
	select
		'10'
			-- 001-002: LineNo
		--+	convert(char(48), 'USA')
		+	convert(char(48), '')
			-- 003-050: LIN05 - Product Id (Counrry of Origin)
		+	convert(char(2), case when @returnableBox = 'Y' then 'RC' else '' end)
			-- 051-052: LIN06 - Product Id (Returnable Box)
	union all
	select
		'11'
			-- 001-002: LineNo
		+	convert(char(48), case when @returnableBox = 'Y' then @packageCodeEDI else '' end)
			-- 003-050: LIN07 - Product Id Type (Returnable Box)
		+	convert(char(2), case when @returnablePallet = 'Y' then 'RC' else '' end)
			-- 051-052: LIN08 - Product Id (Returnable Pallet)
	union all
	select
		'12'
			-- 001-002: LineNo
		+	convert(char(48), case when @returnablePallet = 'Y' then @palletCodeEDI else '' end)
			-- 003-050: LIN09 - Product Id Type (Returnable Pallet)
		+	convert(char(12), @quantity * @packCount)
			-- 051-062: SN102 - # of Units Shipped
		+	'EA'
			-- 063-064: SN103 - UOM

	-- Line 15 - DockCode
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'15'
			-- 001-002: LineNo
		+	convert(char(3), case when @dockCode > '' then 'DK' else '' end)
			-- 003-005: REF01 - Reference Id Type (Dock Code)
		+	convert(char(50), coalesce(@dockCode, ''))
			-- 006-054: REF02 - Reference Id (Dock Code)

	-- Line 16 - PO / Release
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'16'
			-- 001-002: LineNo
		+	convert(char(22), @customerPO)
			-- 003-024: PRF01 - PO #
		+	convert(char(30), coalesce(@releaseNo, ''))
			-- 025-054: PRF02 - Release #


	-- Line 17 - Ship From
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'17'
			-- 001-002: LineNo
		+	convert(char(3), 'SF')
			-- 003-005: N101 - Entity Id Code (Ship From)
		+	convert(char(5), coalesce(nullif(@supplierCode, ''), 'SUPPLIER'))
			-- 006-010: N104 - Id Code (Ship From)
		+	convert(char(60), 'ARMADA RUBBER MANUFACTURING CO')
			-- 011-070: N102 - Name (Ship From)

	-- Line 18 - Ship From
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'18'
			-- 001-002: LineNo
		+	convert(char(60), 'ARMADA RUBBER MANUFACTURING CO')
			-- 003-062: N201 - Name (Ship From)

	-- Line 20 - Ship From
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'20'
			-- 001-002: LineNo
		+	convert(char(55), '24586 ARMADA RIDGE ROAD')
			-- 003-057: N301 - Address (Ship From)

	-- Line 21 - Ship From
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'21'
			-- 001-002: LineNo
		+	convert(char(55), 'PO BOX 579')
			-- 003-057: N302 - Address Information (Ship From)

	-- Line 22 - Ship From
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'22'
			-- 001-002: LineNo
		+	convert(char(30), 'ARMADA')
			-- 003-032: N401 - City (Ship From)
		+	convert(char(2), 'MI')
			-- 033-034: N402 - State (Ship From)
		+	convert(char(15), '48005')
			-- 035-049: N102 - Zip (Ship From)
		+	convert(char(3), 'USA')
			-- 050-052: N402 - Country (Ship From)

	-- Line 17 - Ship To
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'17'
			-- 001-002: LineNo
		+	convert(char(3), 'ST')
			-- 003-005: N101 - Entity Id Code (Ship From)
		+	convert(char(5), coalesce(nullif(@shipTo, ''), 'SHIPTO'))
			-- 006-010: N104 - Id Code (Ship From)
		+	convert(char(60), @shipToName)
			-- 011-070: N102 - Name (Ship To)

	-- Line 18 - Ship To
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'18'
			-- 001-002: LineNo
		+	convert(char(60), @shipToName)
			-- 003-062: N201 - Name (Ship To)

	-- Line 20 - Ship To
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'20'
			-- 001-002: LineNo
		+	convert(char(55), @shipToAddress1)
			-- 003-057: N301 - Address (Ship To)

	-- Line 21 - Ship To
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'21'
			-- 001-002: LineNo
		+	convert(char(55), @shipToAddress2)
			-- 003-057: N302 - Address Information (Ship From)

	-- Line 22 - Ship To
	declare
		@shipToCity varchar(30)
	,	@shipToState varchar(2)
	,	@shipToZip varchar(15)

	;with SSZ_Rows (ID, Value)
	as
	(	select
			fsstr.ID
		,	fsstr.Value
		from
			dbo.fn_SplitStringToRows('NORMAL IL  61761', ' ') fsstr
		where
			rtrim(fsstr.Value) > ''
	),
	ZIP (ID, ZipCode)
	as
	(	select top(1)
 			sr.ID, sr.Value
 		from
 			SSZ_Rows sr
		order by
			sr.ID desc
	),
	STATE (ID, State)
	as
	(	select top(1)
 			sr.ID, sr.Value
 		from
 			SSZ_Rows sr
			join ZIP on
				sr.ID < ZIP.ID
		order by
			sr.ID desc
	),
	CITY (City)
	as
	(	select
 			replace(Fx.ToList(sr.Value), ', ', ' ')
 		from
 			SSZ_Rows sr
			join STATE on
				sr.ID < STATE.ID
	)
	select
		@shipToCity = CITY.City
	,	@ShipToState = STATE.State
	,	@ShipToZip = ZIP.ZipCode
	from
		ZIP
		cross join STATE
		cross join CITY

	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'22'
			-- 001-002: LineNo
		+	convert(char(30), @shipToCity)
			-- 003-032: N401 - City (Ship To)
		+	convert(char(2), @shipToState)
			-- 033-034: N402 - State (Ship To)
		+	convert(char(15), @ShipToZip)
			-- 035-049: N102 - Zip (Ship To)
		+	convert(char(3), 'USA')
			-- 050-052: N402 - Country (Ship To)

	declare
		Objects cursor local read_only
	for
	select
		at.serial % 100000 -- (5 digits)
	,	at.parent_serial % 100000 -- (5 digits)
	from
		dbo.audit_trail at
		left join dbo.package_materials pm
			on pm.code = at.package_type
	where
		at.type = 'S'
		and at.shipper = convert(varchar(12), @ShipperID)
		and at.part = @part
		and at.package_type = @packageType
		and at.quantity = @quantity

	open Objects

	while
		1 = 1 begin

		declare
			@serial int
		,	@palletSerial int

		fetch
			Objects
		into
			@serial
		,	@palletSerial

		if	@@FETCH_STATUS != 0 break

		-- Line 23 - Units
		insert
			#ASNFlatFile
		(	LineData
		)
		select
			'23'
				-- 001-002: LineNo
			+	convert(char(12), @quantity)
				-- 003-014: SN102 - # of Units Shipped
			+	'EA'
				-- 015-016: SN103 - UOM

		-- Line 27-28 - Box / Pallet Serial
		insert
			#ASNFlatFile
		(	LineData
		)
		select
			'24'
				-- 001-002: LineNo
			+	'MC'
				-- 003-004: MAN01 - Marks & Number Type (Master Carton)
			+	convert(char(48), @supplierCode + replace(convert(char(8), @TranDT, 10), '-', '') + convert(char(5), @serial))
				-- 005-052: MAN02 - Marks & Number (Box Serial)
			+	convert(char(2), case when @palletSerial is not null then 'W' else '' end)
				-- 053-054: MAN04 - Marks & Number (Qualifier)
		union all
		select
			'25'
				-- 001-002: LineNo
			+	coalesce(convert(char(48), @palletSerial), space(48))
				-- 003-050: MAN04 - Marks & Number (Pallet Serial)
	end

	set	@lineNo += 1

	close
		Objects
	deallocate
		Objects
end

close
	ShipperLines
deallocate
	ShipperLines
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

--- <ResultSet>
select
	convert (char(78), aff.LineData) + right('0' + convert(varchar(3), aff.LineId), 2)
from
	#ASNFlatFile aff
order by
	aff.LineId
--- </ResultSet>

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
	@ShipperID int = 390670

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_ShipNotice_RIVIAN
	@ShipperID = @ShipperID
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
