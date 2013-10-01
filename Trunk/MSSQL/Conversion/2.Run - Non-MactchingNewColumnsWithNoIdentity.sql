use FxArmada
print	'Load table dbo.activity_router'
alter table dbo.activity_router disable trigger all
go

truncate table dbo.activity_router

insert	dbo.activity_router
(	parent_part,sequence,code,part,notes,labor,material,cost_bill,group_location,process,doc1,doc2,doc3,doc4,cost,price,cost_price_factor,time_stamp)
select	parent_part,sequence,code,part,notes,labor,material,cost_bill,group_location,process,doc1,doc2,doc3,doc4,cost,price,cost_price_factor,time_stamp
from	rawArmada.dbo.activity_router
go

alter table dbo.activity_router enable trigger all
go

print	'Load table dbo.currency_conversion'
alter table dbo.currency_conversion disable trigger all
go

truncate table dbo.currency_conversion

insert	dbo.currency_conversion
(	currency_code,rate,effective_date,currency_display_symbol)
select	currency_code,rate,effective_date,currency_display_symbol
from	rawArmada.dbo.currency_conversion
go

alter table dbo.currency_conversion enable trigger all
go

print	'Load table dbo.customer'
alter table dbo.customer disable trigger all
go

truncate table dbo.customer

insert	dbo.customer
(	customer,name,address_1,address_2,address_3,phone,fax,modem,contact,profile,company,salesrep,terms,category,label_bitmap,bitmap_filename,notes,create_date,address_4,address_5,address_6,default_currency_unit,show_euro_amount,cs_status,custom1,custom2,custom3,custom4,custom5,origin_code,sales_manager_code,region_code,empower_flag,auto_profile,check_standard_pack)
select	customer,name,address_1,address_2,address_3,phone,fax,modem,contact,profile,company,salesrep,terms,category,label_bitmap,bitmap_filename,notes,create_date,address_4,address_5,address_6,default_currency_unit,show_euro_amount,cs_status,custom1,custom2,custom3,custom4,custom5,origin_code,sales_manager_code,region_code,empower_flag,auto_profile,check_standard_pack
from	rawArmada.dbo.customer
go

alter table dbo.customer enable trigger all
go

print	'Load table dbo.downtime_codes'
alter table dbo.downtime_codes disable trigger all
go

truncate table dbo.downtime_codes

insert	dbo.downtime_codes
(	dt_code,code_group,code_description)
select	dt_code,code_group,code_description
from	rawArmada.dbo.downtime_codes
go

alter table dbo.downtime_codes enable trigger all
go

print	'Load table dbo.effective_change_notice'
alter table dbo.effective_change_notice disable trigger all
go

truncate table dbo.effective_change_notice

insert	dbo.effective_change_notice
(	part,effective_date,notes,engineering_level,operator)
select	part,effective_date,notes,engineering_level,coalesce(operator, '')
from	rawArmada.dbo.effective_change_notice
go

alter table dbo.effective_change_notice enable trigger all
go

print	'Load table dbo.freight_type_definition'
alter table dbo.freight_type_definition disable trigger all
go

truncate table dbo.freight_type_definition

insert	dbo.freight_type_definition
(	type_name)
select	type_name
from	rawArmada.dbo.freight_type_definition
go

alter table dbo.freight_type_definition enable trigger all
go

print	'Load table dbo.ole_objects'
alter table dbo.ole_objects disable trigger all
go

truncate table dbo.ole_objects

insert	dbo.ole_objects
(	id,ole_object,parent_id,date_stamp,serial,parent_type)
select	id,convert(image, convert(varbinary(max), convert(varchar(max), ole_object))),parent_id,date_stamp,serial,parent_type
from	rawArmada.dbo.ole_objects
go

alter table dbo.ole_objects enable trigger all
go

print	'Load table dbo.order_detail_inserted'
alter table dbo.order_detail_inserted disable trigger all
go

truncate table dbo.order_detail_inserted

insert	dbo.order_detail_inserted
(	order_no,sequence,part_number,type,product_name,quantity,price,notes,assigned,shipped,invoiced,status,our_cum,the_cum,due_date,destination,unit,committed_qty,row_id,group_no,cost,plant,release_no,flag,week_no,std_qty,customer_part,ship_type,dropship_po,dropship_po_row_id,suffix,packline_qty,packaging_type,weight,custom01,custom02,custom03,dimension_qty_string,engineering_level,box_label,pallet_label,alternate_price)
select	order_no,sequence,part_number,type,product_name,quantity,price,notes,assigned,shipped,invoiced,status,our_cum,the_cum,due_date,destination,unit,committed_qty,row_id,group_no,cost,plant,release_no,flag,week_no,std_qty,customer_part,ship_type,dropship_po,dropship_po_row_id,suffix,packline_qty,packaging_type,weight,custom01,custom02,custom03,dimension_qty_string,engineering_level,box_label,pallet_label,alternate_price
from	rawArmada.dbo.order_detail_inserted
go

alter table dbo.order_detail_inserted enable trigger all
go

print	'Load table dbo.parameters'
alter table dbo.parameters disable trigger all
go

truncate table dbo.parameters

insert	dbo.parameters
(	company_name,next_serial,default_rows,next_issue,sales_order,shipper,company_logo,show_program_name,purchase_order,address_1,address_2,address_3,admin_password,time_interval,next_invoice,next_requisition,delete_scrapped_objects,ipa,ipa_beginning_sequence,audit_trail_delete,invoice_add,plant_required,edit_po_number,over_receive,PHONE_NUMBER,shipping_label,bol_number,verify_packaging,fiscal_year_begin,SALES_TAX_ACCOUNT,FREIGHT_ACCOUNT,populate_parts,populate_locations,populate_machines,mandatory_lot_inventory,edi_process_days,set_asn_uop,shop_floor_check_u1,shop_floor_check_u2,shop_floor_check_u3,shop_floor_check_u4,shop_floor_check_u5,shop_floor_check_lot,lot_control_message,mandatory_qc_notes,asn_directory,next_db_change,fix_number,auto_stage_for_packline,ask_for_minicop,issue_file_location,accounting_interface_db,accounting_interface_type,accounting_interface_login,accounting_interface_pwd,accounting_pbl_name,accounting_cust_sync_dp,accounting_vend_sync_db,accounting_ap_dp_header,accounting_ar_dp,accounting_ap_dp_detail,inv_reg_col,scale_part_choice,accounting_profile,accounting_type,next_voucher,days_to_process,include_setuptime,sunday,monday,tuesday,wednesday,thursday,friday,saturday,workhours_in_day,order_type,pallet_package_type,clear_after_trans_jc,dda_required,dda_formula_type,shipper_required,calc_mtl_cost,issues_environment_message,base_currency,currency_display_symbol,euro_enabled,requisition,onhand_from_partonline,consolidate_mps,daily_horizon,weekly_horizon,fortnightly_horizon,monthly_horizon,next_workorder,audit_deletion)
select	company_name,next_serial,default_rows,next_issue,sales_order,shipper,company_logo,show_program_name,purchase_order,address_1,address_2,address_3,admin_password,time_interval,next_invoice,next_requisition,delete_scrapped_objects,ipa,ipa_beginning_sequence,audit_trail_delete,invoice_add,plant_required,edit_po_number,over_receive,PHONE_NUMBER,shipping_label,bol_number,verify_packaging,fiscal_year_begin,SALES_TAX_ACCOUNT,FREIGHT_ACCOUNT,populate_parts,populate_locations,populate_machines,mandatory_lot_inventory,edi_process_days,set_asn_uop,shop_floor_check_u1,shop_floor_check_u2,shop_floor_check_u3,shop_floor_check_u4,shop_floor_check_u5,shop_floor_check_lot,lot_control_message,mandatory_qc_notes,asn_directory,next_db_change,fix_number,auto_stage_for_packline,ask_for_minicop,issue_file_location,accounting_interface_db,accounting_interface_type,accounting_interface_login,accounting_interface_pwd,accounting_pbl_name,accounting_cust_sync_dp,accounting_vend_sync_db,accounting_ap_dp_header,accounting_ar_dp,accounting_ap_dp_detail,inv_reg_col,scale_part_choice,accounting_profile,accounting_type,next_voucher,days_to_process,include_setuptime,sunday,monday,tuesday,wednesday,thursday,friday,saturday,workhours_in_day,order_type,pallet_package_type,clear_after_trans_jc,dda_required,dda_formula_type,shipper_required,calc_mtl_cost,issues_environment_message,base_currency,currency_display_symbol,euro_enabled,requisition,onhand_from_partonline,consolidate_mps,daily_horizon,weekly_horizon,fortnightly_horizon,monthly_horizon,next_workorder,audit_deletion
from	rawArmada.dbo.parameters
go

alter table dbo.parameters enable trigger all
go

print	'Load table dbo.part_customer_price_matrix'
alter table dbo.part_customer_price_matrix disable trigger all
go

truncate table dbo.part_customer_price_matrix

insert	dbo.part_customer_price_matrix
(	part,customer,code,price,qty_break,discount,category,alternate_price)
select	part,customer,code,price,qty_break,discount,category,alternate_price
from	rawArmada.dbo.part_customer_price_matrix
go

alter table dbo.part_customer_price_matrix enable trigger all
go

print	'Load table dbo.part_machine'
alter table dbo.part_machine disable trigger all
go

truncate table dbo.part_machine

insert	dbo.part_machine
(	part,machine,sequence,mfg_lot_size,process_id,parts_per_cycle,parts_per_hour,cycle_unit,cycle_time,overlap_type,overlap_time,labor_code,activity,setup_time,crew_size)
select	part,machine,sequence,mfg_lot_size,process_id,parts_per_cycle,parts_per_hour,cycle_unit,cycle_time,overlap_type,overlap_time,labor_code,activity,setup_time,crew_size
from	rawArmada.dbo.part_machine
go

alter table dbo.part_machine enable trigger all
go

print	'Load table dbo.part_standard'
alter table dbo.part_standard disable trigger all
go

truncate table dbo.part_standard

insert	dbo.part_standard
(	part,price,cost,account_number,material,labor,burden,other,cost_cum,material_cum,burden_cum,other_cum,labor_cum,flag,premium,qtd_cost,qtd_material,qtd_labor,qtd_burden,qtd_other,qtd_cost_cum,qtd_material_cum,qtd_labor_cum,qtd_burden_cum,qtd_other_cum,planned_cost,planned_material,planned_labor,planned_burden,planned_other,planned_cost_cum,planned_material_cum,planned_labor_cum,planned_burden_cum,planned_other_cum,frozen_cost,frozen_material,frozen_burden,frozen_labor,frozen_other,frozen_cost_cum,frozen_material_cum,frozen_burden_cum,frozen_labor_cum,frozen_other_cum,cost_changed_date,qtd_changed_date,planned_changed_date,frozen_changed_date)
select	part,price,cost,account_number,material,labor,burden,other,cost_cum,material_cum,burden_cum,other_cum,labor_cum,flag,premium,qtd_cost,qtd_material,qtd_labor,qtd_burden,qtd_other,qtd_cost_cum,qtd_material_cum,qtd_labor_cum,qtd_burden_cum,qtd_other_cum,planned_cost,planned_material,planned_labor,planned_burden,planned_other,planned_cost_cum,planned_material_cum,planned_labor_cum,planned_burden_cum,planned_other_cum,frozen_cost,frozen_material,frozen_burden,frozen_labor,frozen_other,frozen_cost_cum,frozen_material_cum,frozen_burden_cum,frozen_labor_cum,frozen_other_cum,cost_changed_date,qtd_changed_date,planned_changed_date,frozen_changed_date
from	rawArmada.dbo.part_standard
go

alter table dbo.part_standard enable trigger all
go

print	'Load table dbo.part_vendor_price_matrix'
alter table dbo.part_vendor_price_matrix disable trigger all
go

truncate table dbo.part_vendor_price_matrix

insert	dbo.part_vendor_price_matrix
(	part,vendor,price,break_qty,code,alternate_price)
select	part,vendor,price,break_qty,code,alternate_price
from	rawArmada.dbo.part_vendor_price_matrix
go

alter table dbo.part_vendor_price_matrix enable trigger all
go

print	'Load table dbo.pbcatcol'
alter table dbo.pbcatcol disable trigger all
go

truncate table dbo.pbcatcol

insert	dbo.pbcatcol
(	pbc_tnam,pbc_tid,pbc_ownr,pbc_cnam,pbc_cid,pbc_labl,pbc_lpos,pbc_hdr,pbc_hpos,pbc_jtfy,pbc_mask,pbc_case,pbc_hght,pbc_wdth,pbc_ptrn,pbc_bmap,pbc_init,pbc_cmnt,pbc_edit,pbc_tag)
select	pbc_tnam,pbc_tid,pbc_ownr,pbc_cnam,pbc_cid,pbc_labl,pbc_lpos,pbc_hdr,pbc_hpos,pbc_jtfy,pbc_mask,pbc_case,pbc_hght,pbc_wdth,pbc_ptrn,pbc_bmap,pbc_init,pbc_cmnt,pbc_edit,pbc_tag
from	rawArmada.dbo.pbcatcol
go

alter table dbo.pbcatcol enable trigger all
go

print	'Load table dbo.pbcatedt'
alter table dbo.pbcatedt disable trigger all
go

truncate table dbo.pbcatedt

insert	dbo.pbcatedt
(	pbe_name,pbe_edit,pbe_type,pbe_cntr,pbe_seqn,pbe_flag,pbe_work)
select	pbe_name,pbe_edit,pbe_type,pbe_cntr,pbe_seqn,pbe_flag,pbe_work
from	rawArmada.dbo.pbcatedt
go

alter table dbo.pbcatedt enable trigger all
go

print	'Load table dbo.pbcattbl'
alter table dbo.pbcattbl disable trigger all
go

truncate table dbo.pbcattbl

insert	dbo.pbcattbl
(	pbt_tnam,pbt_tid,pbt_ownr,pbd_fhgt,pbd_fwgt,pbd_fitl,pbd_funl,pbd_fchr,pbd_fptc,pbd_ffce,pbh_fhgt,pbh_fwgt,pbh_fitl,pbh_funl,pbh_fchr,pbh_fptc,pbh_ffce,pbl_fhgt,pbl_fwgt,pbl_fitl,pbl_funl,pbl_fchr,pbl_fptc,pbl_ffce,pbt_cmnt)
select	pbt_tnam,pbt_tid,pbt_ownr,pbd_fhgt,pbd_fwgt,pbd_fitl,pbd_funl,pbd_fchr,pbd_fptc,pbd_ffce,pbh_fhgt,pbh_fwgt,pbh_fitl,pbh_funl,pbh_fchr,pbh_fptc,pbh_ffce,pbl_fhgt,pbl_fwgt,pbl_fitl,pbl_funl,pbl_fchr,pbl_fptc,pbl_ffce,pbt_cmnt
from	rawArmada.dbo.pbcattbl
go

alter table dbo.pbcattbl enable trigger all
go

print	'Load table dbo.po_detail'
alter table dbo.po_detail disable trigger all
go

truncate table dbo.po_detail

insert	dbo.po_detail
(	po_number,vendor_code,part_number,description,unit_of_measure,date_due,requisition_number,status,type,last_recvd_date,last_recvd_amount,cross_reference_part,account_code,notes,quantity,received,balance,active_release_cum,received_cum,price,row_id,invoice_status,invoice_date,invoice_qty,invoice_unit_price,RELEASE_NO,ship_to_destination,terms,week_no,plant,invoice_number,standard_qty,sales_order,dropship_oe_row_id,ship_type,dropship_shipper,price_unit,printed,selected_for_print,deleted,ship_via,release_type,dimension_qty_string,taxable,scheduled_time,truck_number,confirm_asn,job_cost_no,alternate_price,requisition_id)
select	po_number,vendor_code,part_number,description,unit_of_measure,date_due,requisition_number,status,type,last_recvd_date,last_recvd_amount,cross_reference_part,account_code,notes,quantity,received,balance,active_release_cum,received_cum,price,row_id,invoice_status,invoice_date,invoice_qty,invoice_unit_price,RELEASE_NO,ship_to_destination,terms,week_no,plant,invoice_number,standard_qty,sales_order,dropship_oe_row_id,ship_type,dropship_shipper,price_unit,printed,selected_for_print,deleted,ship_via,release_type,dimension_qty_string,taxable,scheduled_time,truck_number,confirm_asn,job_cost_no,alternate_price,requisition_id
from	rawArmada.dbo.po_detail
go

alter table dbo.po_detail enable trigger all
go

print	'Load table dbo.shipper'
alter table dbo.shipper disable trigger all
go

truncate table dbo.shipper

insert	dbo.shipper
(	id,destination,shipping_dock,ship_via,status,date_shipped,aetc_number,freight_type,printed,bill_of_lading_number,model_year_desc,model_year,customer,location,staged_objs,plant,type,invoiced,invoice_number,freight,tax_percentage,total_amount,gross_weight,net_weight,tare_weight,responsibility_code,trans_mode,pro_number,notes,time_shipped,truck_number,invoice_printed,seal_number,terms,tax_rate,staged_pallets,container_message,picklist_printed,dropship_reconciled,date_stamp,platinum_trx_ctrl_num,posted,scheduled_ship_time,currency_unit,show_euro_amount,cs_status,bol_ship_to,bol_carrier,operator)
select	id,destination,shipping_dock,ship_via,status,date_shipped,aetc_number,freight_type,printed,bill_of_lading_number,model_year_desc,model_year,customer,location,staged_objs,plant,type,invoiced,invoice_number,freight,tax_percentage,total_amount,gross_weight,net_weight,tare_weight,responsibility_code,trans_mode,pro_number,notes,time_shipped,truck_number,invoice_printed,seal_number,terms,tax_rate,staged_pallets,container_message,picklist_printed,dropship_reconciled,date_stamp,platinum_trx_ctrl_num,posted,scheduled_ship_time,currency_unit,show_euro_amount,cs_status,bol_ship_to,bol_carrier,operator
from	rawArmada.dbo.shipper
go

alter table dbo.shipper enable trigger all
go

print	'Load table dbo.shipper_detail'
alter table dbo.shipper_detail disable trigger all
go

truncate table dbo.shipper_detail

insert	dbo.shipper_detail
(	shipper,part,qty_required,qty_packed,qty_original,accum_shipped,order_no,customer_po,release_no,release_date,type,price,account_code,salesman,tare_weight,gross_weight,net_weight,date_shipped,assigned,packaging_job,note,operator,boxes_staged,pack_line_qty,alternative_qty,alternative_unit,week_no,taxable,price_type,cross_reference,customer_part,dropship_po,dropship_po_row_id,dropship_oe_row_id,suffix,part_name,part_original,total_cost,group_no,dropship_po_serial,dropship_invoice_serial,stage_using_weight,alternate_price,old_suffix,old_shipper)
select	shipper,part,qty_required,qty_packed,qty_original,accum_shipped,order_no,customer_po,release_no,release_date,type,price,account_code,salesman,tare_weight,gross_weight,net_weight,date_shipped,assigned,packaging_job,note,operator,boxes_staged,pack_line_qty,alternative_qty,alternative_unit,week_no,taxable,price_type,cross_reference,customer_part,dropship_po,dropship_po_row_id,dropship_oe_row_id,suffix,part_name,part_original,total_cost,group_no,dropship_po_serial,dropship_invoice_serial,stage_using_weight,alternate_price,old_suffix,old_shipper
from	rawArmada.dbo.shipper_detail
go

alter table dbo.shipper_detail enable trigger all
go

print	'Load table dbo.vendor'
alter table dbo.vendor disable trigger all
go

truncate table dbo.vendor

insert	dbo.vendor
(	code,name,outside_processor,contact,phone,terms,ytd_sales,balance,frieght_type,fob,buyer,plant,ship_via,company,address_1,address_2,address_3,fax,flag,partial_release_update,address_4,address_5,address_6,kanban,trusted,default_currency_unit,show_euro_amount,empower_flag,status)
select	code,name,outside_processor,contact,phone,terms,ytd_sales,balance,frieght_type,fob,buyer,plant,ship_via,company,address_1,address_2,address_3,fax,flag,partial_release_update,address_4,address_5,address_6,kanban,trusted,default_currency_unit,show_euro_amount,empower_flag,status
from	rawArmada.dbo.vendor
go

alter table dbo.vendor enable trigger all
go

print	'Load table dbo.xreport_datasource'
alter table dbo.xreport_datasource disable trigger all
go

truncate table dbo.xreport_datasource

insert	dbo.xreport_datasource
(	datasource_name,description,library_name,dw_name)
select	datasource_name,description,library_name,dw_name
from	rawArmada.dbo.xreport_datasource
go

alter table dbo.xreport_datasource enable trigger all
go

