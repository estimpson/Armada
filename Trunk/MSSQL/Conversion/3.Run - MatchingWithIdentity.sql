use FxArmada
print	'Load table dbo.cdi_ppdcr'
alter table dbo.cdi_ppdcr disable trigger all
go

set identity_insert dbo.cdi_ppdcr on
go

truncate table dbo.cdi_ppdcr

insert	dbo.cdi_ppdcr
(	id,p_age,pointsd)
select	id,p_age,pointsd
from	rawArmada.dbo.cdi_ppdcr
go

set identity_insert dbo.cdi_ppdcr off
go

alter table dbo.cdi_ppdcr enable trigger all
go

print	'Load table dbo.cdi_vprating'
alter table dbo.cdi_vprating disable trigger all
go

set identity_insert dbo.cdi_vprating on
go

truncate table dbo.cdi_vprating

insert	dbo.cdi_vprating
(	id,lrange,hrange,rating)
select	id,lrange,hrange,rating
from	rawArmada.dbo.cdi_vprating
go

set identity_insert dbo.cdi_vprating off
go

alter table dbo.cdi_vprating enable trigger all
go

print	'Load table dbo.cdipohistory'
alter table dbo.cdipohistory disable trigger all
go

set identity_insert dbo.cdipohistory on
go

truncate table dbo.cdipohistory

insert	dbo.cdipohistory
(	id,po_number,vendor,part,uom,date_due,type,last_recvd_date,last_recvd_amount,quantity,received,balance,price,row_id,release_no,raccuracy,premium_freight,premium_amount)
select	id,po_number,vendor,part,uom,date_due,type,last_recvd_date,last_recvd_amount,quantity,received,balance,price,row_id,release_no,raccuracy,premium_freight,premium_amount
from	rawArmada.dbo.cdipohistory
go

set identity_insert dbo.cdipohistory off
go

alter table dbo.cdipohistory enable trigger all
go

print	'Load table dbo.master_prod_sched'
alter table dbo.master_prod_sched disable trigger all
go

set identity_insert dbo.master_prod_sched on
go

truncate table dbo.master_prod_sched

insert	dbo.master_prod_sched
(	type,part,due,qnty,source,source2,origin,rel_date,tool,workcenter,machine,run_time,run_day,dead_start,material,job,material_qnty,setup,location,field1,field2,field3,field4,field5,status,sched_method,qty_completed,process,tool_num,workorder,qty_assigned,due_time,start_time,id,parent_id,begin_date,begin_time,end_date,end_time,po_number,po_row_id,week_no,plant,ship_type,ai_row)
select	type,part,due,qnty,source,source2,origin,rel_date,tool,workcenter,machine,run_time,run_day,dead_start,material,job,material_qnty,setup,location,field1,field2,field3,field4,field5,status,sched_method,qty_completed,process,tool_num,workorder,qty_assigned,due_time,start_time,id,parent_id,begin_date,begin_time,end_date,end_time,po_number,po_row_id,week_no,plant,ship_type,ai_row
from	rawArmada.dbo.master_prod_sched
go

set identity_insert dbo.master_prod_sched off
go

alter table dbo.master_prod_sched enable trigger all
go

print	'Load table dbo.shop_floor_calendar'
alter table dbo.shop_floor_calendar disable trigger all
go

set identity_insert dbo.shop_floor_calendar on
go

truncate table dbo.shop_floor_calendar

insert	dbo.shop_floor_calendar
(	ai_id,machine,begin_datetime,end_datetime,labor_code,crew_size)
select	ai_id,machine,begin_datetime,end_datetime,labor_code,crew_size
from	rawArmada.dbo.shop_floor_calendar
go

set identity_insert dbo.shop_floor_calendar off
go

alter table dbo.shop_floor_calendar enable trigger all
go

