SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[Shipping_OpenShipperList]
as
select
	ShipperNumber = 'L' + convert(varchar(49), s.id)
,	LegacyShipperID = s.id
,	ShipperType = coalesce(s.type, 'N')
,	IsStaged = case when s.status = 'S' then 1 else 0 end
,	StagedProgress = coalesce
		(	(	select
					sum(case when sd.qty_packed > sd.qty_required then sd.qty_required else sd.qty_packed end)
				from
					dbo.shipper_detail sd
				where
					sd.shipper = s.id
			)
			/
			(	select
					sum(sd.qty_required)
				from
					dbo.shipper_detail sd
				where
					sd.shipper = s.id
			)
		,	0
		)
,	HasOverStagedLine =
		case when exists
			(	select
					*
				from
					dbo.shipper_detail sd
				where
					sd.shipper = s.id
					and sd.qty_packed > sd.qty_required
			) then 1
			else 0
		end
,	CustomerCode = coalesce(s.customer, v.code)
,	CustomerName = coalesce(cc.name, v.name)
,	ShipToCode = s.destination
,	ShipToName = d.name
,	PacklistPrinted = case when s.printed = 'Y' then 1 else 0 end
,	Notes = s.notes
,	FreightType = s.freight_type
,	Carrier = s.ship_via
,	CarrierName = c.name
,	TransMode = s.trans_mode
,	TransDescription = tm.description
,	PremiumFreightAETCNumber = s.aetc_number
,	PRONumber = s.pro_number
,	TruckNumber = s.truck_number
,	ContainerSealNumber = s.seal_number
,	BillOfLadingNumber = s.bill_of_lading_number
,	DockCode = s.shipping_dock
,	BoxesStaged = s.staged_objs
,	PalletsStaged = s.staged_pallets
,	ShippingPlant = s.plant
,	GrossWeight = s.gross_weight
,	NetWeight = s.net_weight
,	TareWeight = s.tare_weight
,	ContainerMessage = s.container_message
,	PickListPrinted = s.picklist_printed
,	ScheduledShipDT = dateadd(minute, coalesce(datediff(minute, '1900-01-01', s.scheduled_ship_time), 0), dateadd(day, datediff(day, '1900-01-01', s.date_stamp), '1900-01-01'))
,	CustomerStatus = s.cs_status
,	PoolShipTo = s.bol_ship_to
,	PoolShipToName = dPool.name
,	PoolCarrier = s.bol_carrier
,	PoolCarrierName = cPool.name
,	ShippingOperator = s.operator
--,	RequiresRelabel = coalesce
--		(	(	select
--		 			max(1)
--		 		from
--		 			dbo.Shipping_RequiredRelabelObjectList ssrol
--				where
--					ssrol.LegacyShipperID = s.id
--		 	)
--		,	0
--		)
,	RequiresRelabel =
		case
			when
				s.type is null
				and exists
					(	select
							*
						from
							dbo.object o
								join dbo.Label_ObjectPrintHistory loph
									on loph.RowID =
										(	select
												max(RowID)
											from
												dbo.Label_ObjectPrintHistory loph2
											where
												loph2.Serial = o.serial
										)
								left join custom.Label_FinishedGoodsData lfgd
									on lfgd.Serial = o.serial
						where
							o.shipper = s.id
							and o.type is null
							and lfgd.LabelDataCheckSum != loph.LabelDataChecksum
					)
				then 1
			when
				s.type is null
				and exists
					(	select
							*
						from
							dbo.object o
								join dbo.Label_ObjectPrintHistory loph
									on loph.RowID =
										(	select
												max(RowID)
											from
												dbo.Label_ObjectPrintHistory loph2
											where
												loph2.Serial = o.serial
										)
								left join custom.Label_FinishedGoodsData_Master lfgdm
									on lfgdm.Serial = o.serial
						where
							o.shipper = s.id
							and o.type = 'S'
							and lfgdm.LabelDataCheckSum != loph.LabelDataChecksum
					)
				then 1
			else 0
		end
from
	dbo.shipper s
	left join dbo.destination d
		on d.destination = s.destination
	left join carrier c
		on c.scac = s.ship_via
	left join dbo.trans_mode tm
		on tm.code = s.trans_mode
	left join dbo.customer cc
		on cc.customer = s.customer
	left join dbo.vendor v
		on v.code = d.vendor
	left join dbo.destination dPool
		on dPool.destination = s.bol_ship_to
	left join dbo.carrier cPool
		on cPool.scac = s.bol_carrier
where
	s.status not in ('E', 'C', 'D', 'Z', 'T')
	and coalesce(s.type, 'N') in ('V', 'O', 'Q', 'N')
	and s.date_shipped is null
GO
