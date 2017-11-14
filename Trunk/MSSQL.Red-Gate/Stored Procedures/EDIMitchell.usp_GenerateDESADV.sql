SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [EDIMitchell].[usp_GenerateDESADV]
	@ShipperID INT
,	@TranDT DATETIME = NULL OUT
,	@Result INT = NULL OUT
AS
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIMitchell.usp_Test
--- </Error Handling>

--- <Tran Required=No AutoCreate=No TranDTParm=Yes>
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
/*	Result set table. */
create table
	#ASNResultSet
(	FFdata char(80)
,	LineID int not null IDENTITY(1, 1) primary key
)

/*	Create envolope. */
insert
	#ASNResultSet
(	FFdata
)
select
	'//STX12//   '
		+ convert(char(12), coalesce(nullif(es.trading_partner_code, ''), 'N/S'))
		+ convert(char(30), s.id)
		+ convert(char(1), 'P') -- Partial Complete Flag
		+ convert(char(10), 'DESADV')
from
	dbo.shipper s
	join dbo.edi_setups es
		on es.destination = s.destination
where
	s.id = @ShipperID

/*	Create header. */
declare
	@DESADVDT datetime
,	@shipDT datetime
,	@grossWeight int
,	@netWeight int
,	@ladingQty int
,	@mBOL int
,	@MI varchar(25)
,	@ST varchar(25)
,	@dock varchar(10)
,	@modelYear varchar(4)
,	@SU varchar(20)
,	@TM varchar(10)
,	@SCAC varchar(20)
,	@TE varchar(30)

select
	@DESADVDT = getdate()
,	@shipDT = s.date_shipped
,	@grossWeight = convert(int, s.gross_weight)
,	@netWeight = convert(int, s.net_weight)
,	@ladingQty = coalesce(s.staged_pallets, 0) + coalesce(s.staged_objs,0)
,	@mBOL = convert(varchar, coalesce(s.bill_of_lading_number, s.id))
,	@MI = coalesce(es.material_issuer, '')
,	@ST = coalesce(es.EDIShipToID, '')
,	@dock = coalesce
			(	(	select
						max(oh.dock_code)
					from
						dbo.order_header oh
					where
						oh.order_no in
							(	select
									sd.order_no
								from
									dbo.shipper_detail sd
								where
									sd.shipper = @ShipperID
							)
				)
			,	''
			)
,	@modelYear = coalesce
			(	(	select
						max(oh.model_year)
					from
						dbo.order_header oh
					where
						oh.order_no in
							(	select
									sd.order_no
								from
									dbo.shipper_detail sd
								where
									sd.shipper = @ShipperID
							)
				)
			,	RIGHT(DATEPART(YEAR,GETDATE()),1)
			)
,	@SU = coalesce(es.supplier_code, '')
,	@TM = coalesce(s.trans_mode, '')
,	@SCAC = coalesce(s.ship_via, '')
,	@TE = coalesce(s.truck_number, '')
from
	dbo.shipper s
	join dbo.edi_setups es
		on es.destination = s.destination
where
	s.id = @ShipperID

insert
	#ASNResultSet
(	FFdata
)
select
	'01'
		+ convert(char(10), @ShipperID)
		+ '00 ' -- Purpose Code
union all
select
	'02'
		+ '137' -- Document generation
		+ convert(char(35), convert(varchar, @DESADVDT, 112) + left(replace(convert(varchar, @DESADVDT, 8), ':', ''), 4))
union all
select
	'02'
		+ '11 ' -- Despatch date/time
		+ convert(char(35), convert(varchar, @shipDT, 112) + left(replace(convert(varchar, @shipDT, 8), ':', ''), 4))
union all
select
	'03'
		+ 'G  ' -- Gross Weight
		+ 'LBR' -- Pounds
		+ convert(char(18), @grossWeight)
union all
select
	'03'
		+ 'N  ' -- Net Weight
		+ 'LBR' -- Pounds
		+ convert(char(18), @netWeight)
union all
select
	'03'
		+ 'SQ ' -- Lading units
		+ 'C62' -- Count
		+ convert(char(18), @ladingQty)
union all
select
	'04'
		+ 'MB ' -- Master Bill of Lading
		+ convert(char(35), @mBOL)
union all
select
	'05'
		+ 'MI ' -- Material Issuer
		+ convert(char(35), @MI)
		+'16 '
union all
select
	'05'
		+ 'ST ' -- Ship To
		+ convert(char(35), @ST)
		+ '92 '
		+ convert(char(3), '') -- space
		+ convert(char(25), @dock)
		
union all
select
	'05'
		+ 'SU ' -- Ship To
		+ convert(char(35), @SU)
		+ '16 '
union all
--select
--	'06'
--		+ convert(char(3), @TM)
--		+ convert(char(70), @SCAC)
--union all
select
	'08'
		+ '12 '
		+ convert(char(3), @TM)
		+ convert(char(17), @SCAC )
		+ convert(char(3), '182')
union all
select
	'09'
		+ 'TE '
		+ convert(char(17), @TE)
		

/*	Loop through customer parts on shipper. */
declare
	sd
cursor local for
select
	sd.customer_part
,	accumShipped = max(sd.accum_shipped)
,	shipQty = sum(sd.alternative_qty)
,	customerPO = max(coalesce(NULLIF(sd.customer_po,''), oh.customer_po,'NoPOonSalesOrder'))
from
	dbo.shipper_detail sd
join
	order_header oh on oh.order_no = sd.order_no
where
	sd.shipper = @ShipperID
group by
	sd.customer_part

open
	sd

declare
	@cp int = 1

while 1 = 1
	begin

	declare
		@customerPart varchar(30)
	,	@accumShipped int
	,	@shipQty int
	,	@customerPO varchar(20)

	fetch
		sd
	into
		@customerPart
	,	@accumShipped
	,	@shipQty
	,	@customerPO

	if	@@FETCH_STATUS != 0 begin
		break
	end

	insert
		#ASNResultSet
	(	FFdata
	)
	select
		'11'
			+ convert(char(3), @cp)

	/*	Loop through pack type/quantities. */
	declare
		packs
	cursor local for
	select
		cp.partCode
	,	cp.storageLocation
	,	packs2.packCode
	,	packs2.packCodeEDI
	,	packs2.boxCount
	from
		(	select
				partCode = sd.part_original
			,	storageLocation = coalesce
					(	(	select
								max(oh.line_feed_code)
							from
								dbo.order_header oh
							where
								oh.order_no = sd.order_no
						)
					,	''
					)
			from
				dbo.shipper_detail sd
			where
				sd.shipper = @ShipperID
				and sd.customer_part = @customerPart
		) cp
		cross apply
			(	select
					packCode = pm.code
				,	packCodeEDI = pm.name
				,	boxCount = count(*)
				from
					dbo.audit_trail at
					join dbo.package_materials pm
						on pm.code = at.package_type
				where
					at.type = 'S'
					and at.shipper = convert(varchar, @ShipperID)
					and at.part = cp.partCode
				group by
					pm.code
				,	pm.name
				union all
				select
					packCode = pm.code
				,	packCodeEDI = pm.name
				,	boxCount = count(*)
				from
					dbo.object o
					join dbo.package_materials pm
						on pm.code = o.package_type
				where
					o.shipper = @ShipperID
					and o.part = cp.partCode
				group by
					pm.code
				,	pm.name
			) packs2

	open
		packs

	while
		1 = 1 begin

		declare
			@partCode varchar(25)
		,	@storageLocation varchar(30)
		,	@packCode varchar(20)
		,	@packCodeEDI varchar(25)
		,	@boxCount int

		fetch
			packs
		into
			@partCode
		,	@storageLocation
		,	@packCode
		,	@packCodeEDI
		,	@boxCount

		if	@@FETCH_STATUS != 0 begin
			break
		end

		insert
			#ASNResultSet
		(	FFdata
		)
		select
			'12'
				+ convert(char(10), @boxCount)
				+ convert(char(17), @packCodeEDI)
		union all
		select
			'13'
				+ convert(char(35), @storageLocation)
		
		declare
			objs
		cursor local for
		select
			objSerial = at.serial
		,	objQty = convert(int, at.std_quantity)
		from
			dbo.audit_trail at
		where
			at.type = 'S'
			and at.shipper = convert(varchar, @ShipperID)
			and at.part = @partCode
			and at.package_type = @packCode
		union all
		select
			objSerial = o.serial
		,	objQty = convert(int, o.std_quantity)
		from
			dbo.object o
		where
			o.shipper = @ShipperID
			and o.part = @partCode
			and o.package_type = @packCode

		open
			objs

		WHILE
			1 = 1 BEGIN

			declare
				@objSerial int
			,	@objQty int

			fetch
				objs
			into
				@objSerial
			,	@objQty

			if	@@FETCH_STATUS != 0 begin
				break
			end

			INSERT
				#ASNResultSet
			(	FFdata
			)
			SELECT
				'14'
					+ 'AAK'+ CONVERT(CHAR(32), @objSerial)
					+ 'AWS'
					+ CONVERT(CHAR(35), @objQty)
					+ 'ZZ '
		END
		close objs
		deallocate objs
	END
	close packs
	deallocate packs

	insert
		#ASNResultSet
	(	FFdata
	)
	select
		'16'
			+ convert(char(35), @customerPart)
			+ 'IN '
			+ convert(char(35), right(@modelYear, 1))
			+ 'RY '
	union all
	select
		'19'
			+ '3  ' -- Cumulative shipped qty
			+ convert(char(14), @accumShipped)
			+ 'C62'
	union all
	select
		'19'
			+ '12 ' -- Cumulative shipped qty
			+ convert(char(14), @shipQty)
			+ 'C62'
	union all
	select
		'22'
			+ convert(char(35), @customerPO)

	
	SET @cp = @cp + 1
END
close sd
deallocate sd
--- </Body>

---	<Return Result Set>
SELECT
	ars.FFdata AS ffdata
FROM
	#ASNResultSet ars
ORDER BY
	ars.LineID ASC
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
	@ProcReturn = EDIMitchell.usp_GenerateDESADV
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
