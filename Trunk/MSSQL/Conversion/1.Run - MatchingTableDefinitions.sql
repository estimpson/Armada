use FxArmada

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

print	'Load table dbo.account_code'
alter table dbo.account_code disable trigger all
go

truncate table dbo.account_code

insert	dbo.account_code
select	*
from	rawArmada.dbo.account_code
go

alter table dbo.account_code enable trigger all
go


print	'Load table dbo.activity_codes'
alter table dbo.activity_codes disable trigger all
go

truncate table dbo.activity_codes

insert	dbo.activity_codes
select	*
from	rawArmada.dbo.activity_codes
go

alter table dbo.activity_codes enable trigger all
go


print	'Load table dbo.activity_costs'
alter table dbo.activity_costs disable trigger all
go

truncate table dbo.activity_costs

insert	dbo.activity_costs
select	*
from	rawArmada.dbo.activity_costs
go

alter table dbo.activity_costs enable trigger all
go


print	'Load table dbo.admin'
alter table dbo.admin disable trigger all
go

truncate table dbo.admin

insert	dbo.admin
select	*
from	rawArmada.dbo.admin
go

alter table dbo.admin enable trigger all
go


print	'Load table dbo.alternative_parts'
alter table dbo.alternative_parts disable trigger all
go

truncate table dbo.alternative_parts

insert	dbo.alternative_parts
select	*
from	rawArmada.dbo.alternative_parts
go

alter table dbo.alternative_parts enable trigger all
go


print	'Load table dbo.asn_overlay_structure'
alter table dbo.asn_overlay_structure disable trigger all
go

truncate table dbo.asn_overlay_structure

insert	dbo.asn_overlay_structure
select	*
from	rawArmada.dbo.asn_overlay_structure
go

alter table dbo.asn_overlay_structure enable trigger all
go


print	'Load table dbo.bill_of_lading'
alter table dbo.bill_of_lading disable trigger all
go

truncate table dbo.bill_of_lading

insert	dbo.bill_of_lading
select	*
from	rawArmada.dbo.bill_of_lading
go

alter table dbo.bill_of_lading enable trigger all
go


print	'Load table dbo.carrier'
alter table dbo.carrier disable trigger all
go

truncate table dbo.carrier

insert	dbo.carrier
select	*
from	rawArmada.dbo.carrier
go

alter table dbo.carrier enable trigger all
go


print	'Load table dbo.category'
alter table dbo.category disable trigger all
go

truncate table dbo.category

insert	dbo.category
select	*
from	rawArmada.dbo.category
go

alter table dbo.category enable trigger all
go


print	'Load table dbo.commodity'
alter table dbo.commodity disable trigger all
go

truncate table dbo.commodity

insert	dbo.commodity
select	*
from	rawArmada.dbo.commodity
go

alter table dbo.commodity enable trigger all
go


print	'Load table dbo.company'
alter table dbo.company disable trigger all
go

truncate table dbo.company

insert	dbo.company
select	*
from	rawArmada.dbo.company
go

alter table dbo.company enable trigger all
go


print	'Load table dbo.company_info'
alter table dbo.company_info disable trigger all
go

truncate table dbo.company_info

insert	dbo.company_info
select	*
from	rawArmada.dbo.company_info
go

alter table dbo.company_info enable trigger all
go


print	'Load table dbo.contact'
alter table dbo.contact disable trigger all
go

truncate table dbo.contact

insert	dbo.contact
select	*
from	rawArmada.dbo.contact
go

alter table dbo.contact enable trigger all
go


print	'Load table dbo.contact_call_log'
alter table dbo.contact_call_log disable trigger all
go

truncate table dbo.contact_call_log

insert	dbo.contact_call_log
select	*
from	rawArmada.dbo.contact_call_log
go

alter table dbo.contact_call_log enable trigger all
go


print	'Load table dbo.CountriesWorld'
alter table dbo.CountriesWorld disable trigger all
go

truncate table dbo.CountriesWorld

insert	dbo.CountriesWorld
select	*
from	rawArmada.dbo.CountriesWorld
go

alter table dbo.CountriesWorld enable trigger all
go


print	'Load table dbo.custom_pbl_link'
alter table dbo.custom_pbl_link disable trigger all
go

truncate table dbo.custom_pbl_link

insert	dbo.custom_pbl_link
select	*
from	rawArmada.dbo.custom_pbl_link
go

alter table dbo.custom_pbl_link enable trigger all
go


print	'Load table dbo.customer_additional'
alter table dbo.customer_additional disable trigger all
go

truncate table dbo.customer_additional

insert	dbo.customer_additional
select	*
from	rawArmada.dbo.customer_additional
go

alter table dbo.customer_additional enable trigger all
go


print	'Load table dbo.customer_origin_code'
alter table dbo.customer_origin_code disable trigger all
go

truncate table dbo.customer_origin_code

insert	dbo.customer_origin_code
select	*
from	rawArmada.dbo.customer_origin_code
go

alter table dbo.customer_origin_code enable trigger all
go


print	'Load table dbo.customer_service_status'
alter table dbo.customer_service_status disable trigger all
go

truncate table dbo.customer_service_status

insert	dbo.customer_service_status
select	*
from	rawArmada.dbo.customer_service_status
go

alter table dbo.customer_service_status enable trigger all
go


print	'Load table dbo.defect_codes'
alter table dbo.defect_codes disable trigger all
go

truncate table dbo.defect_codes

insert	dbo.defect_codes
select	*
from	rawArmada.dbo.defect_codes
go

alter table dbo.defect_codes enable trigger all
go


print	'Load table dbo.department'
alter table dbo.department disable trigger all
go

truncate table dbo.department

insert	dbo.department
select	*
from	rawArmada.dbo.department
go

alter table dbo.department enable trigger all
go


print	'Load table dbo.destination'
alter table dbo.destination disable trigger all
go

truncate table dbo.destination

insert	dbo.destination
select	*
from	rawArmada.dbo.destination
go

alter table dbo.destination enable trigger all
go


print	'Load table dbo.destination_package'
alter table dbo.destination_package disable trigger all
go

truncate table dbo.destination_package

insert	dbo.destination_package
select	*
from	rawArmada.dbo.destination_package
go

alter table dbo.destination_package enable trigger all
go


print	'Load table dbo.dim_relation'
alter table dbo.dim_relation disable trigger all
go

truncate table dbo.dim_relation

insert	dbo.dim_relation
select	*
from	rawArmada.dbo.dim_relation
go

alter table dbo.dim_relation enable trigger all
go


print	'Load table dbo.dimensions'
alter table dbo.dimensions disable trigger all
go

truncate table dbo.dimensions

insert	dbo.dimensions
select	*
from	rawArmada.dbo.dimensions
go

alter table dbo.dimensions enable trigger all
go


print	'Load table dbo.down_pointer'
alter table dbo.down_pointer disable trigger all
go

truncate table dbo.down_pointer

insert	dbo.down_pointer
select	*
from	rawArmada.dbo.down_pointer
go

alter table dbo.down_pointer enable trigger all
go


print	'Load table dbo.downtime'
alter table dbo.downtime disable trigger all
go

truncate table dbo.downtime

insert	dbo.downtime
select	*
from	rawArmada.dbo.downtime
go

alter table dbo.downtime enable trigger all
go


print	'Load table dbo.dw_inquiry_files'
alter table dbo.dw_inquiry_files disable trigger all
go

truncate table dbo.dw_inquiry_files

insert	dbo.dw_inquiry_files
select	*
from	rawArmada.dbo.dw_inquiry_files
go

alter table dbo.dw_inquiry_files enable trigger all
go


print	'Load table dbo.edi_ff_layout'
alter table dbo.edi_ff_layout disable trigger all
go

truncate table dbo.edi_ff_layout

insert	dbo.edi_ff_layout
select	*
from	rawArmada.dbo.edi_ff_layout
go

alter table dbo.edi_ff_layout enable trigger all
go


print	'Load table dbo.edi_ff_loops'
alter table dbo.edi_ff_loops disable trigger all
go

truncate table dbo.edi_ff_loops

insert	dbo.edi_ff_loops
select	*
from	rawArmada.dbo.edi_ff_loops
go

alter table dbo.edi_ff_loops enable trigger all
go


print	'Load table dbo.edi_overlay_structure'
alter table dbo.edi_overlay_structure disable trigger all
go

truncate table dbo.edi_overlay_structure

insert	dbo.edi_overlay_structure
select	*
from	rawArmada.dbo.edi_overlay_structure
go

alter table dbo.edi_overlay_structure enable trigger all
go


print	'Load table dbo.edi_setups'
alter table dbo.edi_setups disable trigger all
go

truncate table dbo.edi_setups

insert	dbo.edi_setups
select	*
from	rawArmada.dbo.edi_setups
go

alter table dbo.edi_setups enable trigger all
go


print	'Load table dbo.employee'
alter table dbo.employee disable trigger all
go

truncate table dbo.employee

insert	dbo.employee
select	*
from	rawArmada.dbo.employee
go

alter table dbo.employee enable trigger all
go


print	'Load table dbo.exp_apdata_detail'
alter table dbo.exp_apdata_detail disable trigger all
go

truncate table dbo.exp_apdata_detail

insert	dbo.exp_apdata_detail
select	*
from	rawArmada.dbo.exp_apdata_detail
go

alter table dbo.exp_apdata_detail enable trigger all
go


print	'Load table dbo.exp_apdata_header'
alter table dbo.exp_apdata_header disable trigger all
go

truncate table dbo.exp_apdata_header

insert	dbo.exp_apdata_header
select	*
from	rawArmada.dbo.exp_apdata_header
go

alter table dbo.exp_apdata_header enable trigger all
go


print	'Load table dbo.filters'
alter table dbo.filters disable trigger all
go

truncate table dbo.filters

insert	dbo.filters
select	*
from	rawArmada.dbo.filters
go

alter table dbo.filters enable trigger all
go


print	'Load table dbo.gl_tran_type'
alter table dbo.gl_tran_type disable trigger all
go

truncate table dbo.gl_tran_type

insert	dbo.gl_tran_type
select	*
from	rawArmada.dbo.gl_tran_type
go

alter table dbo.gl_tran_type enable trigger all
go


print	'Load table dbo.group_technology'
alter table dbo.group_technology disable trigger all
go

truncate table dbo.group_technology

insert	dbo.group_technology
select	*
from	rawArmada.dbo.group_technology
go

alter table dbo.group_technology enable trigger all
go


print	'Load table dbo.gt_comp_list'
alter table dbo.gt_comp_list disable trigger all
go

truncate table dbo.gt_comp_list

insert	dbo.gt_comp_list
select	*
from	rawArmada.dbo.gt_comp_list
go

alter table dbo.gt_comp_list enable trigger all
go


print	'Load table dbo.interface_utilities'
alter table dbo.interface_utilities disable trigger all
go

truncate table dbo.interface_utilities

insert	dbo.interface_utilities
select	*
from	rawArmada.dbo.interface_utilities
go

alter table dbo.interface_utilities enable trigger all
go


print	'Load table dbo.inventory_accuracy_history'
alter table dbo.inventory_accuracy_history disable trigger all
go

truncate table dbo.inventory_accuracy_history

insert	dbo.inventory_accuracy_history
select	*
from	rawArmada.dbo.inventory_accuracy_history
go

alter table dbo.inventory_accuracy_history enable trigger all
go


print	'Load table dbo.inventory_parameters'
alter table dbo.inventory_parameters disable trigger all
go

truncate table dbo.inventory_parameters

insert	dbo.inventory_parameters
select	*
from	rawArmada.dbo.inventory_parameters
go

alter table dbo.inventory_parameters enable trigger all
go


print	'Load table dbo.issue_detail'
alter table dbo.issue_detail disable trigger all
go

truncate table dbo.issue_detail

insert	dbo.issue_detail
select	*
from	rawArmada.dbo.issue_detail
go

alter table dbo.issue_detail enable trigger all
go


print	'Load table dbo.issues'
alter table dbo.issues disable trigger all
go

truncate table dbo.issues

insert	dbo.issues
select	*
from	rawArmada.dbo.issues
go

alter table dbo.issues enable trigger all
go


print	'Load table dbo.issues_category'
alter table dbo.issues_category disable trigger all
go

truncate table dbo.issues_category

insert	dbo.issues_category
select	*
from	rawArmada.dbo.issues_category
go

alter table dbo.issues_category enable trigger all
go


print	'Load table dbo.issues_status'
alter table dbo.issues_status disable trigger all
go

truncate table dbo.issues_status

insert	dbo.issues_status
select	*
from	rawArmada.dbo.issues_status
go

alter table dbo.issues_status enable trigger all
go


print	'Load table dbo.issues_sub_category'
alter table dbo.issues_sub_category disable trigger all
go

truncate table dbo.issues_sub_category

insert	dbo.issues_sub_category
select	*
from	rawArmada.dbo.issues_sub_category
go

alter table dbo.issues_sub_category enable trigger all
go


print	'Load table dbo.kanban'
alter table dbo.kanban disable trigger all
go

truncate table dbo.kanban

insert	dbo.kanban
select	*
from	rawArmada.dbo.kanban
go

alter table dbo.kanban enable trigger all
go


print	'Load table dbo.labor'
alter table dbo.labor disable trigger all
go

truncate table dbo.labor

insert	dbo.labor
select	*
from	rawArmada.dbo.labor
go

alter table dbo.labor enable trigger all
go


print	'Load table dbo.limit_parts'
alter table dbo.limit_parts disable trigger all
go

truncate table dbo.limit_parts

insert	dbo.limit_parts
select	*
from	rawArmada.dbo.limit_parts
go

alter table dbo.limit_parts enable trigger all
go


print	'Load table dbo.link'
alter table dbo.link disable trigger all
go

truncate table dbo.link

insert	dbo.link
select	*
from	rawArmada.dbo.link
go

alter table dbo.link enable trigger all
go


print	'Load table dbo.location'
alter table dbo.location disable trigger all
go

truncate table dbo.location

insert	dbo.location
select	*
from	rawArmada.dbo.location
go

alter table dbo.location enable trigger all
go


print	'Load table dbo.location_limits'
alter table dbo.location_limits disable trigger all
go

truncate table dbo.location_limits

insert	dbo.location_limits
select	*
from	rawArmada.dbo.location_limits
go

alter table dbo.location_limits enable trigger all
go


print	'Load table dbo.log'
alter table dbo.log disable trigger all
go

truncate table dbo.log

insert	dbo.log
select	*
from	rawArmada.dbo.log
go

alter table dbo.log enable trigger all
go


print	'Load table dbo.m_in_customer_po'
alter table dbo.m_in_customer_po disable trigger all
go

truncate table dbo.m_in_customer_po

insert	dbo.m_in_customer_po
select	*
from	rawArmada.dbo.m_in_customer_po
go

alter table dbo.m_in_customer_po enable trigger all
go


print	'Load table dbo.m_in_customer_po_exceptions'
alter table dbo.m_in_customer_po_exceptions disable trigger all
go

truncate table dbo.m_in_customer_po_exceptions

insert	dbo.m_in_customer_po_exceptions
select	*
from	rawArmada.dbo.m_in_customer_po_exceptions
go

alter table dbo.m_in_customer_po_exceptions enable trigger all
go


print	'Load table dbo.m_in_release_plan'
alter table dbo.m_in_release_plan disable trigger all
go

truncate table dbo.m_in_release_plan

insert	dbo.m_in_release_plan
select	*
from	rawArmada.dbo.m_in_release_plan
go

alter table dbo.m_in_release_plan enable trigger all
go


print	'Load table dbo.m_in_release_plan_exceptions'
alter table dbo.m_in_release_plan_exceptions disable trigger all
go

truncate table dbo.m_in_release_plan_exceptions

insert	dbo.m_in_release_plan_exceptions
select	*
from	rawArmada.dbo.m_in_release_plan_exceptions
go

alter table dbo.m_in_release_plan_exceptions enable trigger all
go


print	'Load table dbo.m_in_ship_schedule'
alter table dbo.m_in_ship_schedule disable trigger all
go

truncate table dbo.m_in_ship_schedule

insert	dbo.m_in_ship_schedule
select	*
from	rawArmada.dbo.m_in_ship_schedule
go

alter table dbo.m_in_ship_schedule enable trigger all
go


print	'Load table dbo.m_in_ship_schedule_exceptions'
alter table dbo.m_in_ship_schedule_exceptions disable trigger all
go

truncate table dbo.m_in_ship_schedule_exceptions

insert	dbo.m_in_ship_schedule_exceptions
select	*
from	rawArmada.dbo.m_in_ship_schedule_exceptions
go

alter table dbo.m_in_ship_schedule_exceptions enable trigger all
go


print	'Load table dbo.machine'
alter table dbo.machine disable trigger all
go

truncate table dbo.machine

insert	dbo.machine
select	*
from	rawArmada.dbo.machine
go

alter table dbo.machine enable trigger all
go


print	'Load table dbo.machine_data_1050'
alter table dbo.machine_data_1050 disable trigger all
go

truncate table dbo.machine_data_1050

insert	dbo.machine_data_1050
select	*
from	rawArmada.dbo.machine_data_1050
go

alter table dbo.machine_data_1050 enable trigger all
go


print	'Load table dbo.machine_policy'
alter table dbo.machine_policy disable trigger all
go

truncate table dbo.machine_policy

insert	dbo.machine_policy
select	*
from	rawArmada.dbo.machine_policy
go

alter table dbo.machine_policy enable trigger all
go


print	'Load table dbo.machine_process'
alter table dbo.machine_process disable trigger all
go

truncate table dbo.machine_process

insert	dbo.machine_process
select	*
from	rawArmada.dbo.machine_process
go

alter table dbo.machine_process enable trigger all
go


print	'Load table dbo.machine_serial_comm'
alter table dbo.machine_serial_comm disable trigger all
go

truncate table dbo.machine_serial_comm

insert	dbo.machine_serial_comm
select	*
from	rawArmada.dbo.machine_serial_comm
go

alter table dbo.machine_serial_comm enable trigger all
go


print	'Load table dbo.mold'
alter table dbo.mold disable trigger all
go

truncate table dbo.mold

insert	dbo.mold
select	*
from	rawArmada.dbo.mold
go

alter table dbo.mold enable trigger all
go


print	'Load table dbo.object'
alter table dbo.object disable trigger all
go

truncate table dbo.object

insert	dbo.object
select	*
from	rawArmada.dbo.object
go

alter table dbo.object enable trigger all
go


print	'Load table dbo.order_header_inserted'
alter table dbo.order_header_inserted disable trigger all
go

truncate table dbo.order_header_inserted

insert	dbo.order_header_inserted
select	*
from	rawArmada.dbo.order_header_inserted
go

alter table dbo.order_header_inserted enable trigger all
go


print	'Load table dbo.package_materials'
alter table dbo.package_materials disable trigger all
go

truncate table dbo.package_materials

insert	dbo.package_materials
select	*
from	rawArmada.dbo.package_materials
go

alter table dbo.package_materials enable trigger all
go


print	'Load table dbo.part'
alter table dbo.part disable trigger all
go

truncate table dbo.part

insert	dbo.part
select	*
from	rawArmada.dbo.part
go

alter table dbo.part enable trigger all
go


print	'Load table dbo.part_characteristics'
alter table dbo.part_characteristics disable trigger all
go

truncate table dbo.part_characteristics

insert	dbo.part_characteristics
select	*
from	rawArmada.dbo.part_characteristics
go

alter table dbo.part_characteristics enable trigger all
go


print	'Load table dbo.part_class_definition'
alter table dbo.part_class_definition disable trigger all
go

truncate table dbo.part_class_definition

insert	dbo.part_class_definition
select	*
from	rawArmada.dbo.part_class_definition
go

alter table dbo.part_class_definition enable trigger all
go


print	'Load table dbo.part_class_type_cross_ref'
alter table dbo.part_class_type_cross_ref disable trigger all
go

truncate table dbo.part_class_type_cross_ref

insert	dbo.part_class_type_cross_ref
select	*
from	rawArmada.dbo.part_class_type_cross_ref
go

alter table dbo.part_class_type_cross_ref enable trigger all
go


print	'Load table dbo.part_customer'
alter table dbo.part_customer disable trigger all
go

truncate table dbo.part_customer

insert	dbo.part_customer
select	*
from	rawArmada.dbo.part_customer
go

alter table dbo.part_customer enable trigger all
go


print	'Load table dbo.part_gl_account'
alter table dbo.part_gl_account disable trigger all
go

truncate table dbo.part_gl_account

insert	dbo.part_gl_account
select	*
from	rawArmada.dbo.part_gl_account
go

alter table dbo.part_gl_account enable trigger all
go


print	'Load table dbo.part_inventory'
alter table dbo.part_inventory disable trigger all
go

truncate table dbo.part_inventory

insert	dbo.part_inventory
select	*
from	rawArmada.dbo.part_inventory
go

alter table dbo.part_inventory enable trigger all
go


print	'Load table dbo.part_location'
alter table dbo.part_location disable trigger all
go

truncate table dbo.part_location

insert	dbo.part_location
select	*
from	rawArmada.dbo.part_location
go

alter table dbo.part_location enable trigger all
go


print	'Load table dbo.part_machine_tool'
alter table dbo.part_machine_tool disable trigger all
go

truncate table dbo.part_machine_tool

insert	dbo.part_machine_tool
select	*
from	rawArmada.dbo.part_machine_tool
go

alter table dbo.part_machine_tool enable trigger all
go


print	'Load table dbo.part_machine_tool_list'
alter table dbo.part_machine_tool_list disable trigger all
go

truncate table dbo.part_machine_tool_list

insert	dbo.part_machine_tool_list
select	*
from	rawArmada.dbo.part_machine_tool_list
go

alter table dbo.part_machine_tool_list enable trigger all
go


print	'Load table dbo.part_online'
alter table dbo.part_online disable trigger all
go

truncate table dbo.part_online

insert	dbo.part_online
select	*
from	rawArmada.dbo.part_online
go

alter table dbo.part_online enable trigger all
go


print	'Load table dbo.part_packaging'
alter table dbo.part_packaging disable trigger all
go

truncate table dbo.part_packaging

insert	dbo.part_packaging
select	*
from	rawArmada.dbo.part_packaging
go

alter table dbo.part_packaging enable trigger all
go


print	'Load table dbo.part_purchasing'
alter table dbo.part_purchasing disable trigger all
go

truncate table dbo.part_purchasing

insert	dbo.part_purchasing
select	*
from	rawArmada.dbo.part_purchasing
go

alter table dbo.part_purchasing enable trigger all
go


print	'Load table dbo.part_revision'
alter table dbo.part_revision disable trigger all
go

truncate table dbo.part_revision

insert	dbo.part_revision
select	*
from	rawArmada.dbo.part_revision
go

alter table dbo.part_revision enable trigger all
go


print	'Load table dbo.part_tooling'
alter table dbo.part_tooling disable trigger all
go

truncate table dbo.part_tooling

insert	dbo.part_tooling
select	*
from	rawArmada.dbo.part_tooling
go

alter table dbo.part_tooling enable trigger all
go


print	'Load table dbo.part_type_definition'
alter table dbo.part_type_definition disable trigger all
go

truncate table dbo.part_type_definition

insert	dbo.part_type_definition
select	*
from	rawArmada.dbo.part_type_definition
go

alter table dbo.part_type_definition enable trigger all
go


print	'Load table dbo.part_unit_conversion'
alter table dbo.part_unit_conversion disable trigger all
go

truncate table dbo.part_unit_conversion

insert	dbo.part_unit_conversion
select	*
from	rawArmada.dbo.part_unit_conversion
go

alter table dbo.part_unit_conversion enable trigger all
go


print	'Load table dbo.part_vendor'
alter table dbo.part_vendor disable trigger all
go

truncate table dbo.part_vendor

insert	dbo.part_vendor
select	*
from	rawArmada.dbo.part_vendor
go

alter table dbo.part_vendor enable trigger all
go


print	'Load table dbo.partlist'
alter table dbo.partlist disable trigger all
go

truncate table dbo.partlist

insert	dbo.partlist
select	*
from	rawArmada.dbo.partlist
go

alter table dbo.partlist enable trigger all
go


print	'Load table dbo.pbcatfmt'
alter table dbo.pbcatfmt disable trigger all
go

truncate table dbo.pbcatfmt

insert	dbo.pbcatfmt
select	*
from	rawArmada.dbo.pbcatfmt
go

alter table dbo.pbcatfmt enable trigger all
go


print	'Load table dbo.pbcatvld'
alter table dbo.pbcatvld disable trigger all
go

truncate table dbo.pbcatvld

insert	dbo.pbcatvld
select	*
from	rawArmada.dbo.pbcatvld
go

alter table dbo.pbcatvld enable trigger all
go


print	'Load table dbo.phone'
alter table dbo.phone disable trigger all
go

truncate table dbo.phone

insert	dbo.phone
select	*
from	rawArmada.dbo.phone
go

alter table dbo.phone enable trigger all
go


print	'Load table dbo.plant_part'
alter table dbo.plant_part disable trigger all
go

truncate table dbo.plant_part

insert	dbo.plant_part
select	*
from	rawArmada.dbo.plant_part
go

alter table dbo.plant_part enable trigger all
go


print	'Load table dbo.price_promotion'
alter table dbo.price_promotion disable trigger all
go

truncate table dbo.price_promotion

insert	dbo.price_promotion
select	*
from	rawArmada.dbo.price_promotion
go

alter table dbo.price_promotion enable trigger all
go


print	'Load table dbo.process'
alter table dbo.process disable trigger all
go

truncate table dbo.process

insert	dbo.process
select	*
from	rawArmada.dbo.process
go

alter table dbo.process enable trigger all
go


print	'Load table dbo.product_line'
alter table dbo.product_line disable trigger all
go

truncate table dbo.product_line

insert	dbo.product_line
select	*
from	rawArmada.dbo.product_line
go

alter table dbo.product_line enable trigger all
go


print	'Load table dbo.quote'
alter table dbo.quote disable trigger all
go

truncate table dbo.quote

insert	dbo.quote
select	*
from	rawArmada.dbo.quote
go

alter table dbo.quote enable trigger all
go


print	'Load table dbo.quote_detail'
alter table dbo.quote_detail disable trigger all
go

truncate table dbo.quote_detail

insert	dbo.quote_detail
select	*
from	rawArmada.dbo.quote_detail
go

alter table dbo.quote_detail enable trigger all
go


print	'Load table dbo.region_code'
alter table dbo.region_code disable trigger all
go

truncate table dbo.region_code

insert	dbo.region_code
select	*
from	rawArmada.dbo.region_code
go

alter table dbo.region_code enable trigger all
go


print	'Load table dbo.report_library'
alter table dbo.report_library disable trigger all
go

truncate table dbo.report_library

insert	dbo.report_library
select	*
from	rawArmada.dbo.report_library
go

alter table dbo.report_library enable trigger all
go


print	'Load table dbo.report_list'
alter table dbo.report_list disable trigger all
go

truncate table dbo.report_list

insert	dbo.report_list
select	*
from	rawArmada.dbo.report_list
go

alter table dbo.report_list enable trigger all
go


print	'Load table dbo.requisition_account_project'
alter table dbo.requisition_account_project disable trigger all
go

truncate table dbo.requisition_account_project

insert	dbo.requisition_account_project
select	*
from	rawArmada.dbo.requisition_account_project
go

alter table dbo.requisition_account_project enable trigger all
go


print	'Load table dbo.requisition_detail'
alter table dbo.requisition_detail disable trigger all
go

truncate table dbo.requisition_detail

insert	dbo.requisition_detail
select	*
from	rawArmada.dbo.requisition_detail
go

alter table dbo.requisition_detail enable trigger all
go


print	'Load table dbo.requisition_group'
alter table dbo.requisition_group disable trigger all
go

truncate table dbo.requisition_group

insert	dbo.requisition_group
select	*
from	rawArmada.dbo.requisition_group
go

alter table dbo.requisition_group enable trigger all
go


print	'Load table dbo.requisition_group_account'
alter table dbo.requisition_group_account disable trigger all
go

truncate table dbo.requisition_group_account

insert	dbo.requisition_group_account
select	*
from	rawArmada.dbo.requisition_group_account
go

alter table dbo.requisition_group_account enable trigger all
go


print	'Load table dbo.requisition_group_project'
alter table dbo.requisition_group_project disable trigger all
go

truncate table dbo.requisition_group_project

insert	dbo.requisition_group_project
select	*
from	rawArmada.dbo.requisition_group_project
go

alter table dbo.requisition_group_project enable trigger all
go


print	'Load table dbo.requisition_header'
alter table dbo.requisition_header disable trigger all
go

truncate table dbo.requisition_header

insert	dbo.requisition_header
select	*
from	rawArmada.dbo.requisition_header
go

alter table dbo.requisition_header enable trigger all
go


print	'Load table dbo.requisition_notes'
alter table dbo.requisition_notes disable trigger all
go

truncate table dbo.requisition_notes

insert	dbo.requisition_notes
select	*
from	rawArmada.dbo.requisition_notes
go

alter table dbo.requisition_notes enable trigger all
go


print	'Load table dbo.requisition_project_number'
alter table dbo.requisition_project_number disable trigger all
go

truncate table dbo.requisition_project_number

insert	dbo.requisition_project_number
select	*
from	rawArmada.dbo.requisition_project_number
go

alter table dbo.requisition_project_number enable trigger all
go


print	'Load table dbo.requisition_security'
alter table dbo.requisition_security disable trigger all
go

truncate table dbo.requisition_security

insert	dbo.requisition_security
select	*
from	rawArmada.dbo.requisition_security
go

alter table dbo.requisition_security enable trigger all
go


print	'Load table dbo.sales_manager_code'
alter table dbo.sales_manager_code disable trigger all
go

truncate table dbo.sales_manager_code

insert	dbo.sales_manager_code
select	*
from	rawArmada.dbo.sales_manager_code
go

alter table dbo.sales_manager_code enable trigger all
go


print	'Load table dbo.salesrep'
alter table dbo.salesrep disable trigger all
go

truncate table dbo.salesrep

insert	dbo.salesrep
select	*
from	rawArmada.dbo.salesrep
go

alter table dbo.salesrep enable trigger all
go


print	'Load table dbo.serial_asn'
alter table dbo.serial_asn disable trigger all
go

truncate table dbo.serial_asn

insert	dbo.serial_asn
select	*
from	rawArmada.dbo.serial_asn
go

alter table dbo.serial_asn enable trigger all
go


print	'Load table dbo.shipper_container'
alter table dbo.shipper_container disable trigger all
go

truncate table dbo.shipper_container

insert	dbo.shipper_container
select	*
from	rawArmada.dbo.shipper_container
go

alter table dbo.shipper_container enable trigger all
go


print	'Load table dbo.shop_floor_time_log'
alter table dbo.shop_floor_time_log disable trigger all
go

truncate table dbo.shop_floor_time_log

insert	dbo.shop_floor_time_log
select	*
from	rawArmada.dbo.shop_floor_time_log
go

alter table dbo.shop_floor_time_log enable trigger all
go


print	'Load table dbo.tdata'
alter table dbo.tdata disable trigger all
go

truncate table dbo.tdata

insert	dbo.tdata
select	*
from	rawArmada.dbo.tdata
go

alter table dbo.tdata enable trigger all
go


print	'Load table dbo.temp_bom_stack'
alter table dbo.temp_bom_stack disable trigger all
go

truncate table dbo.temp_bom_stack

insert	dbo.temp_bom_stack
select	*
from	rawArmada.dbo.temp_bom_stack
go

alter table dbo.temp_bom_stack enable trigger all
go


print	'Load table dbo.temp_bomec_stack'
alter table dbo.temp_bomec_stack disable trigger all
go

truncate table dbo.temp_bomec_stack

insert	dbo.temp_bomec_stack
select	*
from	rawArmada.dbo.temp_bomec_stack
go

alter table dbo.temp_bomec_stack enable trigger all
go


print	'Load table dbo.temp_order_cum'
alter table dbo.temp_order_cum disable trigger all
go

truncate table dbo.temp_order_cum

insert	dbo.temp_order_cum
select	*
from	rawArmada.dbo.temp_order_cum
go

alter table dbo.temp_order_cum enable trigger all
go


print	'Load table dbo.temp_pops'
alter table dbo.temp_pops disable trigger all
go

truncate table dbo.temp_pops

insert	dbo.temp_pops
select	*
from	rawArmada.dbo.temp_pops
go

alter table dbo.temp_pops enable trigger all
go


print	'Load table dbo.term'
alter table dbo.term disable trigger all
go

truncate table dbo.term

insert	dbo.term
select	*
from	rawArmada.dbo.term
go

alter table dbo.term enable trigger all
go


print	'Load table dbo.time_log'
alter table dbo.time_log disable trigger all
go

truncate table dbo.time_log

insert	dbo.time_log
select	*
from	rawArmada.dbo.time_log
go

alter table dbo.time_log enable trigger all
go


print	'Load table dbo.trans_mode'
alter table dbo.trans_mode disable trigger all
go

truncate table dbo.trans_mode

insert	dbo.trans_mode
select	*
from	rawArmada.dbo.trans_mode
go

alter table dbo.trans_mode enable trigger all
go


print	'Load table dbo.unit_conversion'
alter table dbo.unit_conversion disable trigger all
go

truncate table dbo.unit_conversion

insert	dbo.unit_conversion
select	*
from	rawArmada.dbo.unit_conversion
go

alter table dbo.unit_conversion enable trigger all
go


print	'Load table dbo.unit_measure'
alter table dbo.unit_measure disable trigger all
go

truncate table dbo.unit_measure

insert	dbo.unit_measure
select	*
from	rawArmada.dbo.unit_measure
go

alter table dbo.unit_measure enable trigger all
go


print	'Load table dbo.unit_sub'
alter table dbo.unit_sub disable trigger all
go

truncate table dbo.unit_sub

insert	dbo.unit_sub
select	*
from	rawArmada.dbo.unit_sub
go

alter table dbo.unit_sub enable trigger all
go


print	'Load table dbo.user_definable_data'
alter table dbo.user_definable_data disable trigger all
go

truncate table dbo.user_definable_data

insert	dbo.user_definable_data
select	*
from	rawArmada.dbo.user_definable_data
go

alter table dbo.user_definable_data enable trigger all
go


print	'Load table dbo.user_definable_module_labels'
alter table dbo.user_definable_module_labels disable trigger all
go

truncate table dbo.user_definable_module_labels

insert	dbo.user_definable_module_labels
select	*
from	rawArmada.dbo.user_definable_module_labels
go

alter table dbo.user_definable_module_labels enable trigger all
go


print	'Load table dbo.user_defined_status'
alter table dbo.user_defined_status disable trigger all
go

truncate table dbo.user_defined_status

insert	dbo.user_defined_status
select	*
from	rawArmada.dbo.user_defined_status
go

alter table dbo.user_defined_status enable trigger all
go


print	'Load table dbo.vendor_custom'
alter table dbo.vendor_custom disable trigger all
go

truncate table dbo.vendor_custom

insert	dbo.vendor_custom
select	*
from	rawArmada.dbo.vendor_custom
go

alter table dbo.vendor_custom enable trigger all
go


print	'Load table dbo.vendor_service_status'
alter table dbo.vendor_service_status disable trigger all
go

truncate table dbo.vendor_service_status

insert	dbo.vendor_service_status
select	*
from	rawArmada.dbo.vendor_service_status
go

alter table dbo.vendor_service_status enable trigger all
go


print	'Load table dbo.work_order'
alter table dbo.work_order disable trigger all
go

truncate table dbo.work_order

insert	dbo.work_order
select	*
from	rawArmada.dbo.work_order
go

alter table dbo.work_order enable trigger all
go


print	'Load table dbo.workorder_detail'
alter table dbo.workorder_detail disable trigger all
go

truncate table dbo.workorder_detail

insert	dbo.workorder_detail
select	*
from	rawArmada.dbo.workorder_detail
go

alter table dbo.workorder_detail enable trigger all
go


print	'Load table dbo.workorder_detail_history'
alter table dbo.workorder_detail_history disable trigger all
go

truncate table dbo.workorder_detail_history

insert	dbo.workorder_detail_history
select	*
from	rawArmada.dbo.workorder_detail_history
go

alter table dbo.workorder_detail_history enable trigger all
go


print	'Load table dbo.workorder_header_history'
alter table dbo.workorder_header_history disable trigger all
go

truncate table dbo.workorder_header_history

insert	dbo.workorder_header_history
select	*
from	rawArmada.dbo.workorder_header_history
go

alter table dbo.workorder_header_history enable trigger all
go


print	'Load table dbo.xreport_library'
alter table dbo.xreport_library disable trigger all
go

truncate table dbo.xreport_library

insert	dbo.xreport_library
select	*
from	rawArmada.dbo.xreport_library
go

alter table dbo.xreport_library enable trigger all
go


