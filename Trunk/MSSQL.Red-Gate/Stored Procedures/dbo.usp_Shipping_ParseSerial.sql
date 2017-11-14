SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[usp_Shipping_ParseSerial]
	@TruckNumber varchar(30)
,	@SerialString varchar(30)
as

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer,
	@FirstNewSerial integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>


-- Get the length of the most recent serial number created
declare @MaxSerialLength int
select
	@MaxSerialLength = len(max(serial))
from
	object


-- Parse out a serial number from the string based on the max serial's length
--   and search for it in the Shipping_Objects table
declare
	@Serial int = 0
,	@ShipperID int

select
	@Serial = isnull(sdol.Serial, 0)
,	@ShipperID = sdol.LegacyShipperID
from 
	dbo.Shipping_DepartingObjectList sdol
where 
	convert(varchar, sdol.Serial) = right(@SerialString, @MaxSerialLength)
	and sdol.TruckNumber = @TruckNumber


-- Serial's may have recently rolled over into the millions, so
--   attempt to parse for an older serial
if (@Serial = 0) begin
	select
		@Serial = isnull(sdol.Serial, 0)
	,	@ShipperID = sdol.LegacyShipperID
	from 
		dbo.Shipping_DepartingObjectList sdol
	where 
		convert(varchar, Serial) = right(@SerialString, @MaxSerialLength - 1)
		and sdol.TruckNumber = @TruckNumber
end

--<Perform Label Validation>
-- Validate the correct labels are scanned for this shipment by comparing current
--  checksums against the checksum of the most recent version of the created labels.
/*	Record label data.*/
insert
	dbo.Label_ObjectScanHistory
(	Serial
,	LabelDataChecksum
,	LabelDataXML
)
select
	Serial = lfgd.Serial
,	LabelDataChecksum = lfgd.LabelDataCheckSum
,	LabelDataXML =
		(	select
				*
			from
				custom.Label_FinishedGoodsData lfgd1
			where
				lfgd1.Serial = @Serial
			for xml auto
		)
from
	dbo.object o
	join custom.Label_FinishedGoodsData lfgd
		on lfgd.Serial = o.serial
where
	o.serial = @Serial
	and o.type is null
union all
select
	Serial = lfgdm.Serial
,	LabelDataChecksum = lfgdm.LabelDataCheckSum
,	LabelDataXML =
		(	select
				*
			from
				custom.Label_FinishedGoodsData_Master lfgdm1
			where
				lfgdm1.Serial = @Serial
			for xml auto
		)
from
	dbo.object o
	join custom.Label_FinishedGoodsData_Master lfgdm
		on lfgdm.Serial = o.serial
where
	o.serial = @Serial
	and o.type = 'S'

declare 
	@BoxMismatchSerial int
,	@PalletMismatchSerial int

if	(	select
  			s.type
  		from
  			dbo.shipper s
		where
			s.id = @ShipperID
	) is null begin

	if ( (	
		select
			type
		from
			object
		where
			serial = @Serial ) = 'S' )begin

		/*	Validate pallet. */
		select
			@PalletMismatchSerial = lpv.Serial
		from
			dbo.Label_PalletVerification lpv
			join dbo.shipper sNormal
				on sNormal.id = @ShipperID
				and sNormal.type is null
		where
			lpv.Serial = @Serial
			and lpv.LabelMatch = 0
			and lpv.LastLabelData is not null

		if (@BoxMismatchSerial > 0) begin
			RAISERROR ('The label for pallet %d needs to be reprinted.  Procedure: %s. ', 16, 1, @PalletMismatchSerial, @ProcName)
			return
		end

		/*  Validate boxes on pallet  */
		select
			@BoxMismatchSerial = min(lbv.Serial)
		from
			dbo.object o
			join dbo.Label_BoxVerification lbv
				on lbv.Serial = o.serial
				and lbv.LabelMatch = 0
				and lbv.LastLabelData is not null
			join dbo.shipper sNormal
				on sNormal.id = @ShipperID
				and sNormal.type is null
		where
			o.parent_serial = @Serial

		if (@BoxMismatchSerial > 0) begin
			RAISERROR ('The label for box %d on pallet %d needs to be reprinted.  Procedure: %s. ', 16, 1, @BoxMismatchSerial, @PalletMismatchSerial, @ProcName)
			return
		end
	end
	else begin
		/*	Validate box. */
		select
			@BoxMismatchSerial = lbv.Serial
		from
			dbo.Label_BoxVerification lbv
			join dbo.shipper sNormal
				on sNormal.id = @ShipperID
				and sNormal.type is null
		where
			lbv.Serial = @Serial
			and lbv.LabelMatch = 0
			and lbv.LastLabelData is not null

		if (@BoxMismatchSerial > 0) begin
			RAISERROR ('The label for box %d needs to be reprinted.  Procedure: %s. ', 16, 1, @BoxMismatchSerial, @ProcName)
			return
		end
	end
	--</Perfrom Label Validation>
end

-- Return results
select
	ShipperNumber
,	CustomerCode
,	CustomerName
,	ShipToCode
,	ShipToName
,	TruckNumber
,	Serial
,	IsScannedToTruck
,	ObjectType
,	BoxCount
,	Type
,	ParentSerial
,	LabelPrintDT
,	LegacyShipperID
from
	Shipping_DepartingObjectList
where  
	TruckNumber = @TruckNumber 
	and Serial = @Serial
GO
