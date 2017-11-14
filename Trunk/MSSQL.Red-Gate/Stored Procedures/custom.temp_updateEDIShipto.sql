SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [custom].[temp_updateEDIShipto]

as

begin

Select count(distinct ShipToCode) OrderCount, customerPart, max(ShipToCode) EDIShipToCode into
 #OrderCount
From
(

Select distinct ShiptoCode, CustomerPart From EDI2001.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDI2001.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDI2002.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDI2002.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDI2040.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDI2040.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDI3010.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDI3010.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDI3020.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDI3020.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDI3030.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDI3030.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDI3060.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDI3060.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDI4010.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDI4010.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDIFORD.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDIFORD.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDICHRY.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDICHRY.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDIEDIFACT96A.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDIEDIFACT96A.SHIPSchedules
union
Select distinct ShiptoCode, CustomerPart From EDIEDIFACT97A.PlanningReleases
union
Select distinct ShiptoCode, CustomerPart From EDIEDIFACT97A.SHIPSchedules
) EDIData

group by customerPart
having count(distinct ShipToCode) = 1

Select OrderCount, CustomerPart, Customer_part, destination, EDIShipToCode From #OrderCount OC left join order_header on OC.CustomerPart = order_header.customer_Part
where Destination != EDIShipToCode
order by 5

End
GO
