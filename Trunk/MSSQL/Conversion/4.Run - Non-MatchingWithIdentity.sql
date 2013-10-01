use FxArmada
print	'Load table dbo.audit_trail'
alter table dbo.audit_trail disable trigger all
go

set identity_insert dbo.audit_trail off
go

truncate table dbo.audit_trail

insert	dbo.audit_trail
(	serial,date_stamp,type,part,quantity,remarks,price,salesman,customer,vendor,po_number,operator,from_loc,to_loc,on_hand,lot,weight,status,shipper,flag,activity,unit,workorder,std_quantity,cost,control_number,custom1,custom2,custom3,custom4,custom5,plant,invoice_number,notes,gl_account,package_type,suffix,due_date,group_no,sales_order,release_no,dropship_shipper,std_cost,user_defined_status,engineering_level,posted,BF_NUMBER,parent_serial,origin,destination,sequence,object_type,part_name,start_date,field1,field2,show_on_shipper,tare_weight,kanban_number,dimension_qty_string,dim_qty_string_other,varying_dimension_code,invoice,invoice_line)
select	serial,date_stamp,type,part,quantity,remarks,price,salesman,customer,vendor,po_number,operator,from_loc,to_loc,on_hand,lot,weight,status,shipper,flag,activity,unit,workorder,std_quantity,cost,control_number,custom1,custom2,custom3,custom4,custom5,plant,invoice_number,notes,gl_account,package_type,suffix,due_date,group_no,sales_order,release_no,dropship_shipper,std_cost,user_defined_status,engineering_level,posted,BF_NUMBER,parent_serial,origin,destination,sequence,object_type,part_name,start_date,field1,field2,show_on_shipper,tare_weight,kanban_number,dimension_qty_string,dim_qty_string_other,varying_dimension_code,invoice,invoice_line
from	rawArmada.dbo.audit_trail
go

set identity_insert dbo.audit_trail off
go

alter table dbo.audit_trail enable trigger all
go

print	'Load table dbo.bill_of_material_ec'
alter table dbo.bill_of_material_ec disable trigger all
go

set identity_insert dbo.bill_of_material_ec off
go

truncate table dbo.bill_of_material_ec

insert	dbo.bill_of_material_ec
(	parent_part,part,start_datetime,end_datetime,type,quantity,unit_measure,reference_no,std_qty,scrap_factor,engineering_level,operator,substitute_part,date_changed,note)
select	parent_part,part,start_datetime,end_datetime,type,quantity,unit_measure,reference_no,std_qty,scrap_factor,engineering_level,operator,substitute_part,date_changed,note
from	rawArmada.dbo.bill_of_material_ec
go

set identity_insert dbo.bill_of_material_ec off
go

alter table dbo.bill_of_material_ec enable trigger all
go

print	'Load table dbo.Defects'
alter table dbo.Defects disable trigger all
go

set identity_insert dbo.Defects on
go

truncate table dbo.Defects

insert	dbo.Defects
(	TransactionDT, Machine, Part, DefectCode, QtyScrapped, Operator, Shift, WODID, DefectSerial, Comments, AuditTrailID, AreaToCharge)
select	defect_time, machine, part, reason, quantity, operator, shift, convert(int, work_order), convert(int, data_source), null, null, null
from	rawArmada.dbo.Defects
go

set identity_insert dbo.Defects off
go

alter table dbo.Defects enable trigger all
go

print	'Load table dbo.order_detail'
alter table dbo.order_detail disable trigger all
go

set identity_insert dbo.order_detail on
go

truncate table dbo.order_detail

insert	dbo.order_detail
(	order_no,part_number,type,product_name,quantity,price,notes,assigned,shipped,invoiced,status,our_cum,the_cum,due_date,sequence,destination,unit,committed_qty,row_id,group_no,cost,plant,release_no,flag,week_no,std_qty,customer_part,ship_type,dropship_po,dropship_po_row_id,suffix,packline_qty,packaging_type,weight,custom01,custom02,custom03,dimension_qty_string,engineering_level,alternate_price,box_label,pallet_label,id)
select	order_no,part_number,type,product_name,quantity,price,notes,assigned,shipped,invoiced,status,our_cum,the_cum,due_date,sequence,destination,unit,committed_qty,row_id,group_no,cost,plant,release_no,flag,week_no,std_qty,customer_part,ship_type,dropship_po,dropship_po_row_id,suffix,packline_qty,packaging_type,weight,custom01,custom02,custom03,dimension_qty_string,engineering_level,alternate_price,box_label,pallet_label,id
from	rawArmada.dbo.order_detail
go

set identity_insert dbo.order_detail off
go

alter table dbo.order_detail enable trigger all
go

