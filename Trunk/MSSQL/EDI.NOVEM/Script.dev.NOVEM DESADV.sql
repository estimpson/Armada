begin transaction
go

declare
	@ShipperID int = 367577
,	@PartialComplete char(1) = 'P'


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
	+	convert(char(12), '//STX12//')
		-- 001-002 003-009 010-012: LineNo Mandatory 
	+	convert(char(12), coalesce(es.trading_partner_code, 'HBPO'))
		-- 013-024: Trading Partner
	+	convert(char(30), s.id)
		-- 025-054: Document Number
	+	@PartialComplete
		-- 055: Partial Transaction
	+	convert(char(10), 'DESADV')
		-- 056-065: TransactionID
	+	'DESADV'
		-- 066-071: Document Class
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
	+	convert(char(35), s.id)
		-- 003-037: BGM0201
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 02 Loop -- Ship Date / Current Date / Arrival Date
insert
	#ASNFlatFile
(	LineData
)
select
	'02'
		-- 001-002: LineNo
	+	convert(char(3), '137') -- CurrentDate
		-- 003-005: DTM0101
	+	convert(char(15), convert(char(8), getdate(), 112) + left(replace(convert(char, getdate(), 108), ':', ''),4) + '203') -- DateTime
		-- 006-020: DTM0102
from
	dbo.shipper s
where
	s.id = @ShipperID
union all
select
	'02'
		-- 001-002: LineNo
	+	convert(char(3), '11') -- DeliveryDate
		-- 003-005: DTM0101
	+	convert(char(35), convert(char(8), getdate(), 112) + left(replace(convert(char, getdate(), 108), ':', ''),4) + '203') -- DateTime
		-- 006-040: DTM0102
from
	dbo.shipper s
where
	s.id = @ShipperID
union all
select
	'02'
		-- 001-002: LineNo
	+	convert(char(3), '132') -- ShipDate
		-- 003-005: DTM0101
	+	convert(char(35), convert(char(8), getdate() + 2, 112) + left(replace(convert(char, s.date_shipped, 108), ':', ''),4) + '203') -- DateTime
		-- 006-040: DTM0102
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 03 Loop -- Gross Weight / Net Weight / Lading Qty
insert
	#ASNFlatFile
(	LineData
)
select
	'03'
		-- 001-002: LineNo
	+	convert(char(3), 'G')
		-- 003-005: Measure MEA0201
	+	convert(char(3), 'LB')
		-- 006-008: Measure MEA0301
	+	convert(char(18), convert(int, s.gross_weight))
		-- 009-026: Measure MEA0302
from
	dbo.shipper s
where
	s.id = @ShipperID
union all
select
	'03'
		-- 001-002: LineNo
	+	convert(char(3), 'N')
		-- 003-005: Measure MEA0201
	+	convert(char(3), 'LB')
		-- 006-008: Measure MEA0301
	+	convert(char(18), convert(int, s.net_weight))
		-- 009-026: Measure MEA0301
from
	dbo.shipper s
where
	s.id = @ShipperID
union all
select
	'03'
		-- 001-002: LineNo
	+	convert(char(3), 'SQ')
		-- 003-005: Measure MEA0201
	+	convert(char(3), 'C62')
		-- 006-008: Measure MEA0301
	+	convert(char(18), convert(int,
			(	select
					sum(sd.qty_packed)
				from
					dbo.shipper_detail sd
				where
					sd.shipper = @ShipperID
			)))
		-- 009-026: Measure MEA0301
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 04 -- Master BOL
insert
	#ASNFlatFile
(	LineData
)
select
	'04'
		-- 001-002: LineNo
	+	convert(char(35), coalesce(s.bill_of_lading_number, s.id))
		-- 003-037: RFF0102
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 05 Loop -- Supplier / Ship From / Ship To 
insert
	#ASNFlatFile
(	LineData
)
select
	'05'
		-- 001-002: LineNo
	+	convert(char(3), 'SU')
		-- 003-005:  NAD01
	+	convert(char(35), es.supplier_code)
		-- 006-040:  NAD0201
from
	dbo.shipper s
	join dbo.edi_setups es
		on es.destination = s.destination
where
	s.id = @ShipperID
--union all
--select
--	'05'
--		-- 001-002: LineNo
--	+	convert(char(3), 'SF')
--		-- 003-005:  NAD01
--	+	convert(char(35), es.supplier_code)
--		-- 006-040:  NAD0201
--from
--	dbo.shipper s
--	join dbo.edi_setups es
--		on es.destination = s.destination
--where
--	s.id = @ShipperID
union all
select
	'05'
		-- 001-002: LineNo
	+	convert(char(3), 'ST')
		-- 003-005:  NAD01
	+	convert(char(35), es.EDIShipToID)
		-- 006-040:  NAD0201
from
	dbo.shipper s
	join dbo.edi_setups es
		on es.destination = s.destination
where
	s.id = @ShipperID

--	Line 08 -- Dock Code
insert
	#ASNFlatFile
(	LineData
)
select
	'08'
		-- 001-002: LineNo
	+	convert(char(25), coalesce(s.shipping_dock, ''))
		-- 003-027: LOC0201
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 11 -- Carrier
insert
	#ASNFlatFile
(	LineData
)
select
	'11'
		-- 001-002: LineNo
	+	convert(char(17), '') -- Delivery Reference No (not used)
		-- 003-019: TDT02
	+	convert(char(17), '') -- Delivery Trans Mode (not used)
		-- 020-036: TDT0302
	+	convert(char(17), s.ship_via) -- Delivery Carrier
		-- 037-053: TDT00501
from
	dbo.shipper s
where
	s.id = @ShipperID

--	Line 12 -- Trailer
insert
	#ASNFlatFile
(	LineData
)
select
	'12'
		-- 001-002: LineNo
	+	convert(char(17), s.truck_number) -- Trailer Number
		-- 003-019: EQD0201
from
	dbo.shipper s
where
	s.id = @ShipperID

declare
	ShipperLines cursor local
for
select
	sd.part_original
,	sd.customer_po
,	sd.customer_part
,	at.package_type
,	coalesce(pm.name, at.package_type)
,	packCount = count(*)
,	at.quantity
from
	dbo.shipper_detail sd
	join dbo.audit_trail at
		left join dbo.package_materials pm
			on pm.code = at.package_type
		on at.type = 'S'
		and at.part = sd.part_original
		and at.shipper = convert(varchar(12), sd.shipper)
where
	sd.shipper = @ShipperID
	and sd.part not like 'CUM%'
group by
	sd.part_original
,	sd.customer_po
,	sd.customer_part
,	at.package_type
,	coalesce(pm.name, at.package_type)
,	at.quantity

open ShipperLines

declare
	@cpsCounter int = 1

while
	1 = 1 begin

	declare
		@part varchar(25)
	,	@customerPO varchar(25)
	,	@customerPart varchar(30)
	,	@packageType varchar(25)
	,	@packageCodeEDI varchar(25)
	,	@packCount int
	,	@quantity int

	fetch
		ShipperLines
	into
		@part
	,	@customerPO
	,	@customerPart
	,	@packageType
	,	@packageCodeEDI
	,	@packCount
	,	@quantity

	if	@@FETCH_STATUS != 0 break

	-- Line 13
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'13'
			-- 001-002: LineNo
		+	convert(char(12), @cpsCounter)
			-- 003-014: 1CPS01
		+	convert(char(12), '')
			-- 015-026: 1CPS02
		+	convert(char(3), '1')
			-- 027-029: 1CPS03

	-- Line 14
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'14'
			-- 001-002: LineNo
		+	convert(char(10), @packCount)
			-- 003-012: 1PAC01
		+	convert(char(3), '')
			-- 013-015: 1PAC0202
		+	convert(char(17), @packageCodeEDI)
			-- 016-032: 1PAC0301

	-- Line 16
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'16'
			-- 001-002: LineNo
		+	convert(char(3), '16')
			-- 003-005: 1PCI0401

	declare
		Objects cursor local
	for
	select
		at.serial
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

		fetch
			Objects
		into
			@serial

		if	@@FETCH_STATUS != 0 break

		-- Line 17
		insert
			#ASNFlatFile
		(	LineData
		)
		select
			'17'
				-- 001-002: LineNo
			+	convert(char(9), @serial)
				-- 003-011: 1GIN0201

	end

	-- Line 18
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'18'
			-- 001-002: LineNo
		+	convert(char(35), @customerPart)
			-- 003-037: 1LIN0301
		+	convert(char(3), '')
			-- 038-040: 1LIN06
		+	convert(char(35), @part)
			-- 041-075: 1PIA0201
		+	convert(char(3), 'SA')
			-- 076-079: 1PIA0202

	-- Line 20
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'20'
			-- 001-002: LineNo
		+	convert(char(17), @quantity)
			-- 003-019: 1QTY0102
		+	convert(char(17), 'PCE')
			-- 020-022: 1QTY0103

	-- Line 21
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'21'
			-- 001-002: LineNo
		+	convert(char(17), 'USA')
			-- 003-005: 1ALI01

	-- Line 28
	insert
		#ASNFlatFile
	(	LineData
	)
	select
		'28'
			-- 001-002: LineNo
		+	convert(char(35), @customerPO)
			-- 003-037: 1RFF0102

	set	@cpsCounter += 1

	close
		Objects
	deallocate
		Objects
end

close
	ShipperLines
deallocate
	ShipperLines

-- Line 29
insert
	#ASNFlatFile
(	LineData
)
select
	'29'
		-- 001-002: LineNo
	+	convert(char(3), '171') -- CurrentDate
		-- 003-005: DTM0101
	+	convert(char(15), convert(char(8), getdate(), 112) + left(replace(convert(char, getdate(), 108), ':', ''),4) + '203') -- DateTime
		-- 006-020: DTM0102

select
	convert (char(79), aff.LineData) + right(aff.LineId, 1)
from
	#ASNFlatFile aff
order by
	aff.LineId
go

rollback
go
