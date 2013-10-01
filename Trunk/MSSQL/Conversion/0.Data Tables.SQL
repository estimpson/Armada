begin transaction
go

--------------------------------------------------------------------------------------------------
--    Create tables
--------------------------------------------------------------------------------------------------

CREATE TABLE dbo."pbcatcol"
(
	"pbc_tnam"      		char(129) NOT NULL,
	"pbc_tid"       		integer NULL,
	"pbc_ownr"      		char(129) NOT NULL,
	"pbc_cnam"      		char(129) NOT NULL,
	"pbc_cid"       		smallint NULL,
	"pbc_labl"      		varchar(254) NULL,
	"pbc_lpos"      		smallint NULL,
	"pbc_hdr"       		varchar(254) NULL,
	"pbc_hpos"      		smallint NULL,
	"pbc_jtfy"      		smallint NULL,
	"pbc_mask"      		varchar(31) NULL,
	"pbc_case"      		smallint NULL,
	"pbc_hght"      		smallint NULL,
	"pbc_wdth"      		smallint NULL,
	"pbc_ptrn"      		varchar(31) NULL,
	"pbc_bmap"      		char(1) NULL,
	"pbc_init"      		varchar(254) NULL,
	"pbc_cmnt"      		varchar(254) NULL,
	"pbc_edit"      		varchar(31) NULL,
	"pbc_tag"       		varchar(254) NULL
)
go

CREATE TABLE dbo."pbcatfmt"
(
	"pbf_name"      		varchar(30) NOT NULL,
	"pbf_frmt"      		varchar(254) NULL,
	"pbf_type"      		smallint NULL,
	"pbf_cntr"      		integer NULL
)
go

CREATE TABLE dbo."trans_mode"
(
	"code"  			varchar(2) NOT NULL,
	"description"   		varchar(50) NULL,
	PRIMARY KEY ("code")
)
go

CREATE TABLE dbo."pbcattbl"
(
	"pbt_tnam"      		char(129) NOT NULL,
	"pbt_tid"       		integer NULL,
	"pbt_ownr"      		char(129) NOT NULL,
	"pbd_fhgt"      		smallint NULL,
	"pbd_fwgt"      		smallint NULL,
	"pbd_fitl"      		char(1) NULL,
	"pbd_funl"      		char(1) NULL,
	"pbd_fchr"      		smallint NULL,
	"pbd_fptc"      		smallint NULL,
	"pbd_ffce"      		char(18) NULL,
	"pbh_fhgt"      		smallint NULL,
	"pbh_fwgt"      		smallint NULL,
	"pbh_fitl"      		char(1) NULL,
	"pbh_funl"      		char(1) NULL,
	"pbh_fchr"      		smallint NULL,
	"pbh_fptc"      		smallint NULL,
	"pbh_ffce"      		char(18) NULL,
	"pbl_fhgt"      		smallint NULL,
	"pbl_fwgt"      		smallint NULL,
	"pbl_fitl"      		char(1) NULL,
	"pbl_funl"      		char(1) NULL,
	"pbl_fchr"      		smallint NULL,
	"pbl_fptc"      		smallint NULL,
	"pbl_ffce"      		char(18) NULL,
	"pbt_cmnt"      		varchar(254) NULL
)
go

CREATE TABLE dbo."customer_additional"
(
	"customer"      		varchar(10) NOT NULL,
	"type"  			varchar(10) NOT NULL,
	"platinum_id"   		varchar(5) NULL,
	"start_date"    		datetime NULL,
	"end_date"      		datetime NULL,
	"closure_rate"  		numeric(5,2) NULL,
	"ontime_rate"   		numeric(5,2) NULL,
	"return_rate"   		numeric(5,2) NULL,
	PRIMARY KEY ("customer")
)
go

CREATE TABLE dbo."edi_setups"
(
	"destination"   		varchar(20) NOT NULL,
	"supplier_code" 		varchar(20) NOT NULL,
	"trading_partner_code"  	varchar(20) NOT NULL,
	"release_flag"  		char(1) NOT NULL,
	"auto_create_asn"       	char(1) NOT NULL,
	"asn_overlay_group"     	varchar(3) NULL,
	"equipment_description" 	varchar(20) NULL,
	"pool_flag"     		char(1) NOT NULL,
	"pool_code"     		varchar(20) NULL,
	"material_issuer"       	varchar(25) NULL,
	"id_code_type"  		varchar(10) NULL,
	"check_model_year"      	char(1) NULL,
	"check_po"      		char(1) NULL,
	"prev_cum_in_asn"       	char(1) NULL,
	"parent_destination"    	varchar(20) NULL,
	PRIMARY KEY ("destination")
)
go

CREATE TABLE dbo."destination_shipping"
(
	"destination"   		varchar(20) NOT NULL,
	"scac_code"     		varchar(4) NOT NULL,
	"trans_mode"    		varchar(2) NOT NULL,
	"dock_code_flag"        	char(1) NOT NULL,
	"model_year_flag"       	char(1) NULL,
	"fob"   			varchar(20) NULL,
	"freigt_type"   		varchar(20) NULL,
	"note_for_shipper"      	varchar(200) NULL,
	"note_for_bol"  		varchar(200) NULL,
	"print_shipper_note"    	char(1) NULL,
	"print_bol_note"        	char(1) NULL,
	"allow_mult_po" 		char(1) NULL,
	"ship_day"      		varchar(10) NULL,
	"will_call_customer"    	char(1) NULL,
	"allow_overstage"       	char(1) NULL,
	PRIMARY KEY ("destination")
)
go
CREATE TABLE dbo."defect_codes"
(
	"code"  			varchar(10) NOT NULL,
	"name"  			varchar(30) NOT NULL,
	"code_group"    		varchar(25) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."location"
(
	"code"  			varchar(10) NOT NULL,
	"name"  			varchar(30) NOT NULL,
	"type"  			varchar(5) NOT NULL,
	"group_no"      		varchar(25) NULL,
	"sequence"      		numeric(3,0) NULL,
	"plant" 			varchar(10) NULL,
	"status"        		char(1) NULL,
	"secured_location"      	char(1) NULL,
	"label_on_transfer"     	char(1) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."machine"
(
	"machine_no"    		varchar(10) NOT NULL,
	"mach_descp"    		varchar(35) NULL,
	"status"        		char(1) NULL,
	"cell"  			varchar(10) NULL,
	"speed" 			numeric(20,6) NULL,
	"redraw_graph"  		char(1) NULL,
	"current_rate"  		numeric(20,6) NULL,
	"standard_rate" 		numeric(20,6) NULL,
	"varying_rate_1"        	numeric(20,6) NULL,
	"varying_rate_2"        	numeric(20,6) NULL,
	"indirect"      		numeric(20,6) NULL,
	"sga"   			numeric(20,6) NULL,
	"qted_rate"     		numeric(20,6) NULL,
	"qted_variable" 		numeric(20,6) NULL,
	"qted_indirect" 		numeric(20,6) NULL,
	"qted_sga"      		numeric(20,6) NULL,
	"plnd_rate"     		numeric(20,6) NULL,
	"plnd_variable" 		numeric(20,6) NULL,
	"plnd_indirect" 		numeric(20,6) NULL,
	"plnd_sga"      		numeric(20,6) NULL,
	"frzn_rate"     		numeric(20,6) NULL,
	"frzn_variable" 		numeric(20,6) NULL,
	"frzn_indirect" 		numeric(20,6) NULL,
	"frzn_sga"      		numeric(20,6) NULL,
	"burden_type"   		varchar(1) NULL,
	"gl_segment"    		varchar(50) NULL,
	PRIMARY KEY ("machine_no")
)
go
CREATE TABLE dbo."order_header"
(
	"order_no"      		numeric(8,0) NOT NULL,
	"customer"      		varchar(10) NULL,
	"order_date"    		datetime NULL,
	"contact"       		varchar(35) NULL,
	"destination"   		varchar(20) NULL,
	"blanket_part"  		varchar(25) NULL,
	"model_year"    		varchar(4) NULL,
	"customer_part" 		varchar(35) NULL,
	"box_label"     		varchar(25) NULL,
	"pallet_label"  		varchar(25) NULL,
	"standard_pack" 		numeric(20,6) NULL,
	"our_cum"       		numeric(20,6) NULL,
	"the_cum"       		numeric(20,6) NULL,
	"order_type"    		char(1) NULL,
	"amount"        		numeric(20,6) NULL,
	"shipped"       		numeric(20,6) NULL,
	"deposit"       		numeric(20,6) NULL,
	"artificial_cum"        	char(1) NULL,
	"shipper"       		integer NULL,
	"status"        		char(1) NULL,
	"location"      		varchar(10) NULL,
	"ship_type"     		char(1) NULL,
	"unit"  			varchar(2) NULL,
	"revision"      		varchar(10) NULL,
	"customer_po"   		varchar(20) NULL,
	"blanket_qty"   		numeric(20,6) NULL,
	"price" 			numeric(20,6) NULL,
	"price_unit"    		char(1) NULL,
	"salesman"      		varchar(25) NULL,
	"zone_code"     		varchar(30) NULL,
	"term"  			varchar(20) NULL,
	"dock_code"     		varchar(10) NULL,
	"package_type"  		varchar(20) NULL,
	"plant" 			varchar(10) NULL,
	"notes" 			varchar(255) NULL,
	"shipping_unit" 		varchar(15) NULL,
	"line_feed_code"        	varchar(30) NULL,
	"fab_cum"       		numeric(15,2) NULL,
	"raw_cum"       		numeric(15,2) NULL,
	"fab_date"      		datetime NULL,
	"raw_date"      		datetime NULL,
	"po_expiry_date"        	datetime NULL,
	"begin_kanban_number"   	varchar(6) NULL,
	"end_kanban_number"     	varchar(6) NULL,
	"line11"        		varchar(35) NULL,
	"line12"        		varchar(35) NULL,
	"line13"        		varchar(35) NULL,
	"line14"        		varchar(35) NULL,
	"line15"        		varchar(35) NULL,
	"line16"        		varchar(35) NULL,
	"line17"        		varchar(35) NULL,
	"custom01"      		varchar(30) NULL,
	"custom02"      		varchar(30) NULL,
	"custom03"      		varchar(30) NULL,
	"quote" 			integer NULL,
	"due_date"      		datetime NULL,
	"engineering_level"     	varchar(25) NULL,
	"currency_unit" 		varchar(3) NULL,
	"alternate_price"       	numeric(20,6) NULL,
	"show_euro_amount"      	smallint NULL,
	"cs_status"     		varchar(20) NULL,
	PRIMARY KEY ("order_no")
)
go
CREATE TABLE dbo."part"
(
	"part"  			varchar(25) NOT NULL,
	"name"  			varchar(100) NOT NULL,
	"cross_ref"     		varchar(50) NULL,
	"class" 			char(1) NOT NULL,
	"type"  			char(1) NULL,
	"commodity"     		varchar(30) NULL,
	"group_technology"      	varchar(25) NULL,
	"quality_alert" 		char(1) NULL,
	"description_short"     	varchar(50) NULL,
	"description_long"      	varchar(255) NULL,
	"serial_type"   		char(1) NULL,
	"product_line"  		varchar(25) NULL,
	"configuration" 		char(1) NULL,
	"standard_cost" 		numeric(20,6) NULL,
	"user_defined_1"        	varchar(30) NULL,
	"user_defined_2"        	varchar(30) NULL,
	"flag"  			integer NULL,
	"engineering_level"     	varchar(10) NULL,
	"drawing_number"        	varchar(25) NULL,
	"gl_account_code"       	varchar(50) NULL,
	"eng_effective_date"    	datetime NULL,
	"low_level_code"        	integer NULL,
	PRIMARY KEY ("part")
)
go
CREATE TABLE dbo."quote"
(
	"quote_number"  		integer NOT NULL,
	"customer"      		varchar(10) NULL,
	"quote_date"    		datetime NULL,
	"contact"       		varchar(25) NULL,
	"amount"        		numeric(20,6) NULL,
	"status"        		char(1) NULL,
	"destination"   		varchar(25) NULL,
	"salesman"      		varchar(35) NULL,
	"notes" 			varchar(255) NULL,
	"expire_date"   		datetime NULL,
	"lock_flag"     		smallint NULL,
	PRIMARY KEY ("quote_number")
)
go
CREATE TABLE dbo."quote_detail"
(
	"quote_number"  		integer NOT NULL,
	"sequence"      		smallint NOT NULL,
	"type"  			char(1) NULL,
	"group_no"      		varchar(10) NULL,
	"part"  			varchar(25) NULL,
	"product_name"  		varchar(50) NULL,
	"price" 			numeric(20,6) NULL,
	"mode"  			char(1) NULL,
	"quantity"      		numeric(20,6) NULL,
	"cost"  			numeric(20,6) NULL,
	"notes" 			varchar(255) NULL,
	"unit"  			varchar(2) NULL,
	"dimension_qty_string"  	varchar(50) NULL,
	PRIMARY KEY ("quote_number", "sequence")
)
go
CREATE TABLE dbo."object"
(
	"serial"        		integer NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"location"      		varchar(10) NOT NULL,
	"last_date"     		datetime NOT NULL,
	"unit_measure"  		varchar(2) NULL,
	"operator"      		varchar(10) NOT NULL,
	"status"        		char(1) NOT NULL,
	"destination"   		varchar(20) NULL,
	"station"       		varchar(10) NULL,
	"origin"        		varchar(20) NULL,
	"cost"  			numeric(20,6) NULL,
	"weight"        		numeric(20,6) NULL,
	"parent_serial" 		numeric(10,0) NULL,
	"note"  			varchar(254) NULL,
	"quantity"      		numeric(20,6) NULL,
	"last_time"     		datetime NULL,
	"date_due"      		datetime NULL,
	"customer"      		varchar(15) NULL,
	"sequence"      		integer NULL,
	"shipper"       		integer NULL,
	"lot"   			varchar(20) NULL,
	"type"  			char(1) NULL,
	"po_number"     		varchar(30) NULL,
	"name"  			varchar(254) NULL,
	"plant" 			varchar(10) NULL,
	"start_date"    		datetime NULL,
	"std_quantity"  		numeric(20,6) NULL,
	"package_type"  		varchar(20) NULL,
	"field1"        		varchar(10) NULL,
	"field2"        		varchar(10) NULL,
	"custom1"       		varchar(50) NULL,
	"custom2"       		varchar(50) NULL,
	"custom3"       		varchar(50) NULL,
	"custom4"       		varchar(50) NULL,
	"custom5"       		varchar(50) NULL,
	"show_on_shipper"       	char(1) NULL,
	"tare_weight"   		numeric(20,6) NULL,
	"suffix"        		integer NULL,
	"std_cost"      		numeric(20,6) NULL,
	"user_defined_status"   	varchar(30) NULL,
	"workorder"     		varchar(10) NULL,
	"engineering_level"     	varchar(10) NULL,
	"kanban_number" 		varchar(6) NULL,
	"dimension_qty_string"  	varchar(50) NULL,
	"dim_qty_string_other"  	varchar(50) NULL,
	"varying_dimension_code"        numeric(2,0) NULL,
	"posted"        		char(1) NULL,
	PRIMARY KEY ("serial")
)
go
GRANT SELECT ON dbo."object" TO "PUBLIC"
go
CREATE TABLE dbo."down_pointer"
(
	"node"  			integer NOT NULL,
	"time_stamp"    		datetime NOT NULL,
	"date_stamp"    		datetime NOT NULL,
	PRIMARY KEY ("node")
)
go
CREATE TABLE dbo."downtime_codes"
(
	"dt_code"       		varchar(10) NOT NULL,
	"code_group"    		varchar(25) NULL,
	"code_description"      	varchar(35) NOT NULL,
	PRIMARY KEY ("dt_code")
)
go
CREATE TABLE dbo."mold"
(
	"mold_number"   		varchar(10) NOT NULL,
	"name"  			varchar(50) NULL,
	"cavities"      		numeric(10,0) NULL,
	PRIMARY KEY ("mold_number")
)
go
CREATE TABLE dbo."po_header"
(
	"po_number"     		integer NOT NULL,
	"vendor_code"   		varchar(10) NOT NULL,
	"po_date"       		datetime NULL,
	"date_due"      		datetime NULL,
	"terms" 			varchar(20) NULL,
	"fob"   			varchar(20) NULL,
	"ship_via"      		varchar(15) NULL,
	"ship_to_destination"   	varchar(25) NULL,
	"status"        		char(1) NULL,
	"type"  			char(1) NULL,
	"description"   		varchar(100) NULL,
	"plant" 			varchar(10) NULL,
	"freight_type"  		varchar(20) NULL,
	"buyer" 			varchar(30) NULL,
	"printed"       		char(1) NULL,
	"notes" 			varchar(255) NULL,
	"total_amount"  		numeric(20,6) NULL,
	"shipping_fee"  		numeric(20,6) NULL,
	"sales_tax"     		numeric(20,6) NULL,
	"blanket_orderded_qty"  	numeric(20,6) NULL,
	"blanket_frequency"     	varchar(15) NULL,
	"blanket_duration"      	numeric(5,0) NULL,
	"blanket_qty_per_release"       numeric(20,6) NULL,
	"blanket_part"  		varchar(25) NULL,
	"blanket_vendor_part"   	varchar(30) NULL,
	"price" 			numeric(20,6) NULL,
	"std_unit"      		varchar(2) NULL,
	"ship_type"     		varchar(10) NULL,
	"flag"  			integer NULL,
	"release_no"    		integer NULL,
	"release_control"       	char(1) NULL,
	"tax_rate"      		numeric(4,2) NULL,
	"scheduled_time"        	datetime NULL,
	"trusted"       		varchar(1) NULL,
	"currency_unit" 		varchar(3) NULL,
	"show_euro_amount"      	smallint NULL,
	PRIMARY KEY ("po_number")
)
go
CREATE TABLE dbo."po_detail"
(
	"po_number"     		integer NOT NULL,
	"vendor_code"   		varchar(10) NOT NULL,
	"part_number"   		varchar(25) NOT NULL,
	"description"   		varchar(100) NULL,
	"unit_of_measure"       	varchar(2) NULL,
	"date_due"      		datetime NOT NULL,
	"requisition_number"    	varchar(10) NULL,
	"status"        		char(1) NULL,
	"type"  			char(1) NULL,
	"last_recvd_date"       	datetime NULL,
	"last_recvd_amount"     	numeric(20,6) NULL,
	"cross_reference_part"  	varchar(25) NULL,
	"account_code"  		varchar(50) NULL,
	"notes" 			varchar(255) NULL,
	"quantity"      		numeric(20,6) NULL,
	"received"      		numeric(20,6) NULL,
	"balance"       		numeric(20,6) NULL,
	"active_release_cum"    	numeric(20,6) NULL,
	"received_cum"  		numeric(20,6) NULL,
	"price" 			numeric(20,6) NULL,
	"row_id"        		numeric(20,0) NOT NULL,
	"invoice_status"        	char(1) NULL,
	"invoice_date"  		datetime NULL,
	"invoice_qty"   		numeric(20,6) NULL,
	"invoice_unit_price"    	numeric(20,6) NULL,
	"RELEASE_NO"    		integer NULL,
	"ship_to_destination"   	varchar(25) NULL,
	"terms" 			varchar(20) NULL,
	"week_no"       		integer NULL,
	"plant" 			varchar(10) NULL,
	"invoice_number"        	varchar(10) NULL,
	"standard_qty"  		numeric(20,6) NULL,
	"sales_order"   		integer NULL,
	"dropship_oe_row_id"    	integer NULL,
	"ship_type"     		char(1) NULL,
	"dropship_shipper"      	integer NULL,
	"price_unit"    		char(1) NULL,
	"printed"       		char(1) NULL,
	"selected_for_print"    	char(1) NULL,
	"deleted"       		char(1) NULL,
	"ship_via"      		varchar(15) NULL,
	"release_type"  		char(1) NULL,
	"dimension_qty_string"  	varchar(50) NULL,
	"taxable"       		char(1) NULL,
	"scheduled_time"        	datetime NULL,
	"truck_number"  		varchar(30) NULL,
	"confirm_asn"   		char(1) NULL,
	"job_cost_no"   		varchar(25) NULL,
	"alternate_price"       	numeric(20,6) NULL,
	"requisition_id"        	integer NULL,
	PRIMARY KEY ("po_number", "part_number", "date_due", "row_id")
)
go
CREATE TABLE dbo."vendor"
(
	"code"  			varchar(10) NOT NULL,
	"name"  			varchar(35) NOT NULL,
	"outside_processor"     	char(1) NULL,
	"contact"       		varchar(35) NULL,
	"phone" 			varchar(20) NULL,
	"terms" 			varchar(20) NULL,
	"ytd_sales"     		numeric(20,6) NULL,
	"balance"       		numeric(20,6) NULL,
	"frieght_type"  		varchar(15) NULL,
	"fob"   			varchar(10) NULL,
	"buyer" 			varchar(30) NULL,
	"plant" 			varchar(10) NULL,
	"ship_via"      		varchar(15) NULL,
	"company"       		varchar(10) NULL,
	"address_1"     		varchar(50) NULL,
	"address_2"     		varchar(50) NULL,
	"address_3"     		varchar(50) NULL,
	"fax"   			varchar(20) NULL,
	"flag"  			integer NULL,
	"partial_release_update"        char(1) NULL,
	"address_4"     		varchar(40) NULL,
	"address_5"     		varchar(40) NULL,
	"address_6"     		varchar(40) NULL,
	"kanban"        		char(1) NULL,
	"trusted"       		varchar(1) NULL,
	"default_currency_unit" 	varchar(3) NULL,
	"show_euro_amount"      	smallint NULL,
	"empower_flag"  		char(8) NULL,
	"status"        		varchar(20) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."pbcatvld"
(
	"pbv_name"      		varchar(30) NOT NULL,
	"pbv_vald"      		varchar(254) NULL,
	"pbv_type"      		smallint NULL,
	"pbv_cntr"      		integer NULL,
	"pbv_msg"       		varchar(254) NULL
)
go

CREATE TABLE dbo."pbcatedt"
(
	"pbe_name"      		varchar(30) NOT NULL,
	"pbe_edit"      		varchar(254) NULL,
	"pbe_type"      		smallint NULL,
	"pbe_cntr"      		integer NULL,
	"pbe_seqn"      		smallint NOT NULL,
	"pbe_flag"      		integer NULL,
	"pbe_work"      		char(32) NULL
)
go

CREATE TABLE dbo."unit_measure"
(
	"unit"  			varchar(2) NOT NULL,
	"description"   		varchar(30) NOT NULL,
	PRIMARY KEY ("unit")
)
go
CREATE TABLE dbo."activity_codes"
(
	"code"  			varchar(25) NOT NULL,
	"value_add_status"      	char(1) NOT NULL,
	"notes" 			varchar(255) NOT NULL,
	"industry"      		varchar(25) NULL,
	"budget"        		numeric(20,6) NULL,
	"actual"        		numeric(20,6) NULL,
	"qty"   			numeric(20,6) NULL,
	"flow_route_window"     	varchar(55) NULL,
	"generate_mps_records"  	char(1) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."activity_costs"
(
	"parent_part"   		varchar(25) NOT NULL,
	"activity"      		varchar(10) NOT NULL,
	"location"      		varchar(10) NOT NULL,
	"cpt"   			numeric(20,6) NULL,
	"trans_qty"     		integer NULL,
	"amount"        		numeric(20,6) NULL,
	"material_cost" 		numeric(20,6) NULL,
	"labor" 			numeric(20,6) NULL,
	"burden"        		numeric(20,6) NULL,
	"vari_burden"   		numeric(20,6) NULL,
	"user_1"        		numeric(20,6) NULL,
	"user_2"        		numeric(20,6) NULL,
	"user_3"        		numeric(20,6) NULL,
	"user_4"        		numeric(20,6) NULL,
	"user_5"        		numeric(20,6) NULL,
	"notes" 			varchar(255) NULL,
	"sequence"      		numeric(5,0) NULL,
	"price" 			numeric(20,6) NULL,
	"cost"  			numeric(20,6) NULL,
	"multiplier"    		numeric(20,6) NULL,
	PRIMARY KEY ("parent_part", "activity", "location")
)
go
CREATE TABLE dbo."activity_router"
(
	"parent_part"   		varchar(25) NOT NULL,
	"sequence"      		numeric(5,0) NOT NULL,
	"code"  			varchar(25) NOT NULL,
	"part"  			varchar(25) NULL,
	"notes" 			varchar(255) NULL,
	"labor" 			varchar(25) NULL,
	"material"      		char(1) NULL,
	"cost_bill"     		char(1) NULL,
	"group_location"        	varchar(10) NULL,
	"process"       		varchar(25) NULL,
	"doc1"  			varchar(35) NULL,
	"doc2"  			varchar(35) NULL,
	"doc3"  			varchar(35) NULL,
	"doc4"  			varchar(35) NULL,
	"cost"  			numeric(20,6) NULL,
	"price" 			numeric(20,6) NULL,
	"cost_price_factor"     	numeric(20,6) NULL,
	"time_stamp"    		float NULL,
	PRIMARY KEY ("parent_part", "sequence")
)
go
CREATE TABLE dbo."company_info"
(
	"name"  			varchar(30) NOT NULL,
	"address"       		varchar(255) NOT NULL,
	"phone" 			varchar(15) NULL,
	"contact"       		varchar(30) NULL,
	PRIMARY KEY ("name")
)
go
CREATE TABLE dbo."audit_trail"
(
	"serial"        		integer NOT NULL,
	"date_stamp"    		datetime NOT NULL,
	"type"  			char(1) NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"remarks"       		varchar(10) NOT NULL,
	"price" 			numeric(20,6) NULL,
	"salesman"      		varchar(10) NULL,
	"customer"      		varchar(10) NULL,
	"vendor"        		varchar(10) NULL,
	"po_number"     		varchar(30) NULL,
	"operator"      		varchar(5) NOT NULL,
	"from_loc"      		varchar(10) NULL,
	"to_loc"        		varchar(10) NULL,
	"on_hand"       		numeric(20,6) NULL,
	"lot"   			varchar(20) NULL,
	"weight"        		numeric(20,6) NULL,
	"status"        		char(1) NOT NULL,
	"shipper"       		varchar(20) NULL,
	"flag"  			char(1) NULL,
	"activity"      		varchar(25) NULL,
	"unit"  			varchar(2) NULL,
	"workorder"     		varchar(10) NULL,
	"std_quantity"  		numeric(20,6) NULL,
	"cost"  			numeric(20,6) NULL,
	"control_number"        	varchar(254) NULL,
	"custom1"       		varchar(50) NULL,
	"custom2"       		varchar(50) NULL,
	"custom3"       		varchar(50) NULL,
	"custom4"       		varchar(50) NULL,
	"custom5"       		varchar(50) NULL,
	"plant" 			varchar(10) NULL,
	"invoice_number"        	varchar(15) NULL,
	"notes" 			varchar(254) NULL,
	"gl_account"    		varchar(15) NULL,
	"package_type"  		varchar(20) NULL,
	"suffix"        		integer NULL,
	"due_date"      		datetime NULL,
	"group_no"      		varchar(10) NULL,
	"sales_order"   		varchar(15) NULL,
	"release_no"    		varchar(15) NULL,
	"dropship_shipper"      	integer NULL,
	"std_cost"      		numeric(20,6) NULL,
	"user_defined_status"   	varchar(30) NULL,
	"engineering_level"     	varchar(10) NULL,
	"posted"        		char(1) NULL,
	"BF_NUMBER"     		integer NULL,
	"parent_serial" 		numeric(10,0) NULL,
	"origin"        		varchar(20) NULL,
	"destination"   		varchar(20) NULL,
	"sequence"      		integer NULL,
	"object_type"   		char(1) NULL,
	"part_name"     		varchar(254) NULL,
	"start_date"    		datetime NULL,
	"field1"        		varchar(10) NULL,
	"field2"        		varchar(10) NULL,
	"show_on_shipper"       	char(1) NULL,
	"tare_weight"   		numeric(20,6) NULL,
	"kanban_number" 		varchar(6) NULL,
	"dimension_qty_string"  	varchar(50) NULL,
	"dim_qty_string_other"  	varchar(50) NULL,
	"varying_dimension_code"        numeric(2,0) NULL,
	"invoice"       		char(25) NULL,
	"invoice_line"  		smallint NULL,
	PRIMARY KEY ("serial", "date_stamp")
)
go
CREATE TABLE dbo."unit_conversion"
(
	"code"  			varchar(10) NOT NULL,
	"unit1" 			varchar(2) NOT NULL,
	"unit2" 			varchar(2) NOT NULL,
	"conversion"    		numeric(20,14) NOT NULL,
	"sequence"      		integer NULL,
	PRIMARY KEY ("code", "unit1", "unit2")
)
go
CREATE TABLE dbo."part_unit_conversion"
(
	"part"  			varchar(25) NOT NULL,
	"code"  			varchar(10) NOT NULL,
	PRIMARY KEY ("part", "code")
)
go
CREATE TABLE dbo."part_vendor"
(
	"part"  			varchar(25) NOT NULL,
	"vendor"        		varchar(10) NOT NULL,
	"vendor_part"   		varchar(25) NULL,
	"vendor_standard_pack"  	numeric(20,6) NULL,
	"accum_received"        	numeric(20,6) NULL,
	"accum_shipped" 		numeric(20,6) NULL,
	"outside_process"       	char(1) NULL,
	"qty_over_received"     	numeric(20,6) NULL,
	"receiving_um"  		varchar(10) NULL,
	"part_name"     		varchar(100) NULL,
	"lead_time"     		numeric(6,2) NULL,
	"min_on_order"  		numeric(20,6) NULL,
	"beginning_inventory_date"      datetime NULL,
	"note"  			text NULL,
	PRIMARY KEY ("part", "vendor")
)
go
CREATE TABLE dbo."part_inventory"
(
	"part"  			varchar(25) NOT NULL,
	"standard_pack" 		numeric(20,6) NULL,
	"unit_weight"   		numeric(20,6) NULL,
	"standard_unit" 		varchar(2) NULL,
	"cycle" 			varchar(10) NULL,
	"abc"   			char(1) NULL,
	"saftey_stock_qty"      	numeric(20,6) NULL,
	"primary_location"      	varchar(10) NULL,
	"location_group"        	varchar(10) NULL,
	"ipa"   			char(1) NULL,
	"label_format"  		varchar(30) NULL,
	"shelf_life_days"       	numeric(3,0) NULL,
	"material_issue_type"   	char(1) NULL,
	"safety_part"   		char(1) NULL,
	"upc_code"      		varchar(15) NULL,
	"dim_code"      		varchar(2) NULL,
	"configurable"  		char(1) NULL,
	"next_suffix"   		integer NULL,
	"drop_ship_part"        	char(1) NULL,
	PRIMARY KEY ("part")
)
go
CREATE TABLE dbo."part_characteristics"
(
	"part"  			varchar(25) NOT NULL,
	"unit_weight"   		numeric(20,6) NULL,
	"length_x"      		numeric(20,6) NULL,
	"height_y"      		numeric(20,6) NULL,
	"width_z"       		numeric(20,6) NULL,
	"color" 			varchar(15) NULL,
	"hazardous"     		char(1) NULL,
	"part_size"     		varchar(50) NULL,
	"user_defined_1"        	varchar(50) NULL,
	"package_type"  		char(1) NULL,
	"returnable"    		char(1) NULL,
	PRIMARY KEY ("part")
)
go
CREATE TABLE dbo."customer"
(
	"customer"      		varchar(10) NOT NULL,
	"name"  			varchar(50) NOT NULL,
	"address_1"     		varchar(50) NULL,
	"address_2"     		varchar(50) NULL,
	"address_3"     		varchar(50) NULL,
	"phone" 			varchar(20) NULL,
	"fax"   			varchar(20) NULL,
	"modem" 			varchar(20) NULL,
	"contact"       		varchar(35) NULL,
	"profile"       		varchar(255) NULL,
	"company"       		varchar(10) NULL,
	"salesrep"      		varchar(10) NULL,
	"terms" 			varchar(20) NULL,
	"category"      		varchar(25) NULL,
	"label_bitmap"  		varbinary(max) NULL,
	"bitmap_filename"       	varchar(50) NULL,
	"notes" 			varchar(255) NULL,
	"create_date"   		datetime NULL,
	"address_4"     		varchar(40) NULL,
	"address_5"     		varchar(40) NULL,
	"address_6"     		varchar(40) NULL,
	"default_currency_unit" 	varchar(3) NULL,
	"show_euro_amount"      	smallint NULL,
	"cs_status"     		varchar(20) NULL,
	"custom1"       		varchar(25) NULL,
	"custom2"       		varchar(25) NULL,
	"custom3"       		varchar(25) NULL,
	"custom4"       		varchar(25) NULL,
	"custom5"       		varchar(25) NULL,
	"origin_code"   		varchar(25) NULL,
	"sales_manager_code"    	varchar(10) NULL,
	"region_code"   		varchar(10) NULL,
	"empower_flag"  		char(8) NULL,
	"auto_profile"  		char(1) NULL,
	"check_standard_pack"   	char(1) NULL,
	PRIMARY KEY ("customer")
)
go
CREATE TABLE dbo."contact"
(
	"name"  			varchar(35) NOT NULL,
	"title" 			varchar(35) NULL,
	"notes" 			varchar(255) NULL,
	"company"       		varchar(35) NULL,
	"phone" 			varchar(20) NULL,
	"company_id"    		varchar(10) NULL,
	"fax_number"    		varchar(20) NULL,
	"email1"        		varchar(255) NULL,
	"email2"        		varchar(255) NULL,
	"customer"      		varchar(10) NULL,
	"destination"   		varchar(20) NULL,
	"vendor"        		varchar(10) NULL,
	PRIMARY KEY ("name")
)
go
CREATE TABLE dbo."company"
(
	"id"    			varchar(10) NOT NULL,
	"name"  			varchar(35) NULL,
	"city"  			varchar(35) NULL,
	"state" 			varchar(2) NULL,
	"zip"   			varchar(9) NULL,
	"address_3"     		varchar(35) NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."product_line"
(
	"id"    			varchar(25) NOT NULL,
	"notes" 			varchar(255) NULL,
	"flag"  			char(1) NULL,
	"gl_segment"    		varchar(50) NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."phone"
(
	"name"  			varchar(14) NOT NULL,
	"namel" 			varchar(15) NOT NULL,
	"phone" 			varchar(12) NOT NULL,
	"company"       		varchar(32) NOT NULL,
	"title" 			varchar(20) NULL,
	"address"       		varchar(32) NULL,
	"city"  			varchar(18) NULL,
	"state" 			varchar(2) NULL,
	"zip"   			varchar(5) NULL,
	"rem1"  			varchar(65) NULL,
	"rem2"  			varchar(65) NULL,
	"car"   			varchar(12) NULL,
	"fax"   			varchar(12) NULL,
	"home"  			varchar(12) NULL,
	"modem" 			varchar(12) NULL,
	"cat"   			varchar(10) NULL,
	"type"  			char(1) NULL,
	"company_id"    		varchar(10) NULL,
	PRIMARY KEY ("name", "namel")
)
go
CREATE TABLE dbo."process"
(
	"id"    			varchar(25) NOT NULL,
	"name"  			varchar(255) NULL,
	"cycle_time"    		integer NULL,
	"cycle_unit"    		integer NULL,
	"operators"     		integer NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."part_online"
(
	"part"  			varchar(25) NOT NULL,
	"on_hand"       		numeric(20,6) NULL,
	"on_demand"     		numeric(20,6) NULL,
	"on_schedule"   		numeric(20,6) NULL,
	"bom_net_out"   		numeric(20,6) NULL,
	"min_onhand"    		numeric(20,6) NULL,
	"max_onhand"    		numeric(20,6) NULL,
	"default_vendor"        	varchar(10) NULL,
	"default_po_number"     	integer NULL,
	"kanban_po_requisition" 	char(1) NULL,
	"kanban_required"       	char(1) NULL,
	PRIMARY KEY ("part")
)
go
CREATE TABLE dbo."parameters"
(
	"company_name"  		varchar(50) NOT NULL,
	"next_serial"   		integer NOT NULL,
	"default_rows"  		integer NULL,
	"next_issue"    		integer NULL,
	"sales_order"   		integer NULL,
	"shipper"       		integer NULL,
	"company_logo"  		varchar(30) NULL,
	"show_program_name"     	char(1) NULL,
	"purchase_order"        	numeric(10,0) NULL,
	"address_1"     		varchar(30) NULL,
	"address_2"     		varchar(30) NULL,
	"address_3"     		varchar(30) NULL,
	"admin_password"        	varchar(5) NULL,
	"time_interval" 		integer NULL,
	"next_invoice"  		integer NULL,
	"next_requisition"      	integer NULL,
	"delete_scrapped_objects"       char(1) NULL,
	"ipa"   			char(1) NULL,
	"ipa_beginning_sequence"        integer NULL,
	"audit_trail_delete"    	char(1) NULL,
	"invoice_add"   		char(1) NULL,
	"plant_required"        	char(1) NULL,
	"edit_po_number"        	char(1) NULL,
	"over_receive"  		char(1) NULL,
	"PHONE_NUMBER"  		varchar(15) NULL,
	"shipping_label"        	varchar(30) NULL,
	"bol_number"    		integer NULL,
	"verify_packaging"      	char(1) NULL,
	"fiscal_year_begin"     	datetime NULL,
	"SALES_TAX_ACCOUNT"     	varchar(50) NULL,
	"FREIGHT_ACCOUNT"       	varchar(50) NULL,
	"populate_parts"        	char(1) NULL,
	"populate_locations"    	char(1) NULL,
	"populate_machines"     	char(1) NULL,
	"mandatory_lot_inventory"       char(1) NULL,
	"edi_process_days"      	integer NULL,
	"set_asn_uop"   		char(1) NULL,
	"shop_floor_check_u1"   	char(1) NULL,
	"shop_floor_check_u2"   	char(1) NULL,
	"shop_floor_check_u3"   	char(1) NULL,
	"shop_floor_check_u4"   	char(1) NULL,
	"shop_floor_check_u5"   	char(1) NULL,
	"shop_floor_check_lot"  	char(1) NULL,
	"lot_control_message"   	varchar(255) NULL,
	"mandatory_qc_notes"    	char(1) NULL,
	"asn_directory" 		varchar(25) NULL,
	"next_db_change"        	integer NULL,
	"fix_number"    		integer NULL,
	"auto_stage_for_packline"       char(1) NULL,
	"ask_for_minicop"       	char(1) NULL,
	"issue_file_location"   	varchar(250) NULL,
	"accounting_interface_db"       varchar(25) NULL,
	"accounting_interface_type"     varchar(25) NULL,
	"accounting_interface_login"    varchar(10) NULL,
	"accounting_interface_pwd"      varchar(10) NULL,
	"accounting_pbl_name"   	varchar(50) NULL,
	"accounting_cust_sync_dp"       varchar(50) NULL,
	"accounting_vend_sync_db"       varchar(50) NULL,
	"accounting_ap_dp_header"       varchar(50) NULL,
	"accounting_ar_dp"      	varchar(50) NULL,
	"accounting_ap_dp_detail"       varchar(50) NULL,
	"inv_reg_col"   		varchar(25) NULL,
	"scale_part_choice"     	char(1) NULL,
	"accounting_profile"    	varchar(50) NULL,
	"accounting_type"       	varchar(25) NULL,
	"next_voucher"  		integer NULL,
	"days_to_process"       	integer NULL,
	"include_setuptime"     	char(1) NULL,
	"sunday"        		char(1) NULL,
	"monday"        		char(1) NULL,
	"tuesday"       		char(1) NULL,
	"wednesday"     		char(1) NULL,
	"thursday"      		char(1) NULL,
	"friday"        		char(1) NULL,
	"saturday"      		char(1) NULL,
	"workhours_in_day"      	integer NULL,
	"order_type"    		char(1) NULL,
	"pallet_package_type"   	char(1) NULL,
	"clear_after_trans_jc"  	char(1) NULL,
	"dda_required"  		char(1) NULL,
	"dda_formula_type"      	char(1) NULL,
	"shipper_required"      	varchar(1) NULL,
	"calc_mtl_cost" 		varchar(1) NULL,
	"issues_environment_message"    varchar(255) NULL,
	"base_currency" 		varchar(3) NULL,
	"currency_display_symbol"       varchar(10) NULL,
	"euro_enabled"  		smallint NULL,
	"requisition"   		varchar(1) NULL,
	"onhand_from_partonline"        char(1) NULL,
	"consolidate_mps"       	char(1) NULL,
	"daily_horizon" 		integer NULL,
	"weekly_horizon"        	integer NULL,
	"fortnightly_horizon"   	integer NULL,
	"monthly_horizon"       	integer NULL,
	"next_workorder"        	integer NULL,
	"audit_deletion"        	char(1) NULL,
	PRIMARY KEY ("company_name")
)
go
CREATE TABLE dbo."shipper"
(
	"id"    			integer NOT NULL,
	"destination"   		varchar(20) NOT NULL,
	"shipping_dock" 		varchar(15) NULL,
	"ship_via"      		varchar(20) NULL,
	"status"        		char(1) NULL,
	"date_shipped"  		datetime NULL,
	"aetc_number"   		varchar(20) NULL,
	"freight_type"  		varchar(30) NULL,
	"printed"       		char(1) NULL,
	"bill_of_lading_number" 	integer NULL,
	"model_year_desc"       	varchar(15) NULL,
	"model_year"    		varchar(4) NULL,
	"customer"      		varchar(25) NULL,
	"location"      		varchar(20) NULL,
	"staged_objs"   		integer NULL,
	"plant" 			varchar(10) NULL,
	"type"  			char(1) NULL,
	"invoiced"      		char(1) NULL,
	"invoice_number"        	integer NULL,
	"freight"       		numeric(15,6) NULL,
	"tax_percentage"        	numeric(6,3) NULL,
	"total_amount"  		numeric(15,6) NULL,
	"gross_weight"  		numeric(20,6) NULL,
	"net_weight"    		numeric(20,6) NULL,
	"tare_weight"   		numeric(20,6) NULL,
	"responsibility_code"   	char(1) NULL,
	"trans_mode"    		varchar(10) NULL,
	"pro_number"    		varchar(35) NULL,
	"notes" 			varchar(254) NULL,
	"time_shipped"  		datetime NULL,
	"truck_number"  		varchar(30) NULL,
	"invoice_printed"       	char(1) NULL,
	"seal_number"   		varchar(25) NULL,
	"terms" 			varchar(25) NULL,
	"tax_rate"      		numeric(20,6) NULL,
	"staged_pallets"        	integer NULL,
	"container_message"     	varchar(100) NULL,
	"picklist_printed"      	char(1) NULL,
	"dropship_reconciled"   	char(1) NULL,
	"date_stamp"    		datetime NULL,
	"platinum_trx_ctrl_num" 	varchar(16) NULL,
	"posted"        		char(1) NULL,
	"scheduled_ship_time"   	datetime NULL,
	"currency_unit" 		varchar(3) NULL,
	"show_euro_amount"      	smallint NULL,
	"cs_status"     		varchar(20) NULL,
	"bol_ship_to"   		varchar(20) NULL,
	"bol_carrier"   		varchar(35) NULL,
	"operator"      		varchar(5) NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."destination"
(
	"destination"   		varchar(20) NOT NULL,
	"name"  			varchar(50) NULL,
	"company"       		varchar(10) NULL,
	"type"  			varchar(2) NULL,
	"address_1"     		varchar(50) NULL,
	"address_2"     		varchar(50) NULL,
	"address_3"     		varchar(50) NULL,
	"customer"      		varchar(10) NULL,
	"vendor"        		varchar(10) NULL,
	"flag"  			integer NULL,
	"salestax_flag" 		char(1) NULL,
	"salestax_rate" 		numeric(7,4) NULL,
	"plant" 			varchar(10) NULL,
	"scheduler"     		varchar(15) NULL,
	"gl_segment"    		varchar(50) NULL,
	"address_4"     		varchar(40) NULL,
	"address_5"     		varchar(40) NULL,
	"address_6"     		varchar(40) NULL,
	"default_currency_unit" 	varchar(3) NULL,
	"show_euro_amount"      	smallint NULL,
	"cs_status"     		varchar(20) NULL,
	"region_code"   		varchar(10) NULL,
	"custom1"       		varchar(10) NULL,
	"custom2"       		varchar(10) NULL,
	"custom3"       		varchar(10) NULL,
	"custom4"       		varchar(10) NULL,
	"custom5"       		varchar(10) NULL,
	"custom6"       		varchar(10) NULL,
	"custom7"       		varchar(10) NULL,
	"custom8"       		varchar(10) NULL,
	"custom9"       		varchar(10) NULL,
	"custom10"      		varchar(10) NULL,
	PRIMARY KEY ("destination")
)
go
CREATE TABLE dbo."shipper_detail"
(
	"shipper"       		integer NOT NULL,
	"part"  			varchar(35) NOT NULL,
	"qty_required"  		numeric(20,6) NULL,
	"qty_packed"    		numeric(20,6) NULL,
	"qty_original"  		numeric(20,6) NULL,
	"accum_shipped" 		numeric(20,6) NULL,
	"order_no"      		numeric(8,0) NULL,
	"customer_po"   		varchar(25) NULL,
	"release_no"    		varchar(30) NULL,
	"release_date"  		datetime NULL,
	"type"  			char(1) NULL,
	"price" 			numeric(20,6) NULL,
	"account_code"  		varchar(75) NULL,
	"salesman"      		varchar(10) NULL,
	"tare_weight"   		numeric(20,6) NULL,
	"gross_weight"  		numeric(20,6) NULL,
	"net_weight"    		numeric(20,6) NULL,
	"date_shipped"  		datetime NULL,
	"assigned"      		varchar(35) NULL,
	"packaging_job" 		varchar(15) NULL,
	"note"  			varchar(750) NULL,
	"operator"      		varchar(5) NULL,
	"boxes_staged"  		integer NULL,
	"pack_line_qty" 		numeric(20,6) NULL,
	"alternative_qty"       	numeric(20,6) NULL,
	"alternative_unit"      	varchar(15) NULL,
	"week_no"       		integer NULL,
	"taxable"       		char(1) NULL,
	"price_type"    		char(1) NULL,
	"cross_reference"       	varchar(25) NULL,
	"customer_part" 		varchar(30) NULL,
	"dropship_po"   		integer NULL,
	"dropship_po_row_id"    	integer NULL,
	"dropship_oe_row_id"    	integer NULL,
	"suffix"        		integer NULL,
	"part_name"     		varchar(100) NULL,
	"part_original" 		varchar(25) NULL,
	"total_cost"    		numeric(20,6) NULL,
	"group_no"      		varchar(10) NULL,
	"dropship_po_serial"    	integer NULL,
	"dropship_invoice_serial"       integer NULL,
	"stage_using_weight"    	char(1) NULL,
	"alternate_price"       	numeric(20,6) NULL,
	"old_suffix"    		integer NULL,
	"old_shipper"   		integer NULL,
	PRIMARY KEY ("shipper", "part")
)
go
CREATE TABLE dbo."dw_inquiry_files"
(
	"datawindow_name"       	varchar(30) NOT NULL,
	"screen_title"  		varchar(40) NULL,
	"table_name"    		varchar(20) NOT NULL,
	"primary_column"        	varchar(20) NULL,
	"change_buttons"        	char(1) NULL,
	"chain_parameter"       	varchar(20) NULL,
	"window_chain"  		varchar(30) NULL,
	"accept_args"   		char(1) NULL,
	"sequence"      		smallint NULL,
	"retrieve_all"  		char(1) NULL,
	"modifiable"    		char(1) NULL,
	"print_button"  		char(1) NULL,
	"auto_number_on_add"    	char(1) NULL,
	"graph_chain"   		varchar(30) NULL,
	"secondary_column"      	varchar(20) NULL,
	"append_title"  		varchar(30) NULL,
	"utility_1"     		varchar(30) NULL,
	"utility_2"     		varchar(30) NULL,
	"util_1_text"   		varchar(30) NULL,
	"util_1_icon"   		varchar(30) NULL,
	"util_2_text"   		varchar(30) NULL,
	"util_2_icon"   		varchar(30) NULL,
	"primary_column_3"      	varchar(20) NULL,
	"primary_column_4"      	varchar(20) NULL,
	"primary_column_5"      	varchar(20) NULL,
	"key_other_than_primary"        smallint NULL,
	"normal_open_dblclk"    	char(1) NULL,
	"parm_field_on_add"     	varchar(30) NULL,
	"number_on_retrieve"    	char(1) NULL,
	"add_chain"     		varchar(30) NULL,
	"util1_parameter"       	varchar(30) NULL,
	"util2_parameter"       	varchar(30) NULL,
	"normal_open_on_add"    	char(1) NULL,
	"normal_open_with_parm" 	char(1) NULL,
	"dummy_col"     		numeric(6,2) NULL,
	"default_operator"      	varchar(10) NULL,
	PRIMARY KEY ("datawindow_name")
)
go
CREATE TABLE dbo."part_purchasing"
(
	"part"  			varchar(25) NOT NULL,
	"buyer" 			varchar(25) NULL,
	"min_order_qty" 		numeric(20,6) NULL,
	"reorder_trigger_qty"   	numeric(20,6) NULL,
	"min_on_hand_qty"       	numeric(20,6) NULL,
	"primary_vendor"        	varchar(10) NULL,
	"gl_account_code"       	varchar(50) NULL,
	PRIMARY KEY ("part")
)
go
CREATE TABLE dbo."commodity"
(
	"id"    			varchar(25) NOT NULL,
	"notes" 			varchar(255) NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."part_standard"
(
	"part"  			varchar(25) NOT NULL,
	"price" 			numeric(20,6) NULL,
	"cost"  			numeric(20,6) NULL,
	"account_number"        	varchar(50) NULL,
	"material"      		numeric(20,6) NULL,
	"labor" 			numeric(20,6) NULL,
	"burden"        		numeric(20,6) NULL,
	"other" 			numeric(20,6) NULL,
	"cost_cum"      		numeric(20,6) NULL,
	"material_cum"  		numeric(20,6) NULL,
	"burden_cum"    		numeric(20,6) NULL,
	"other_cum"     		numeric(20,6) NULL,
	"labor_cum"     		numeric(20,6) NULL,
	"flag"  			integer NULL,
	"premium"       		char(1) NULL,
	"qtd_cost"      		numeric(20,6) NULL,
	"qtd_material"  		numeric(20,6) NULL,
	"qtd_labor"     		numeric(20,6) NULL,
	"qtd_burden"    		numeric(20,6) NULL,
	"qtd_other"     		numeric(20,6) NULL,
	"qtd_cost_cum"  		numeric(20,6) NULL,
	"qtd_material_cum"      	numeric(20,6) NULL,
	"qtd_labor_cum" 		numeric(20,6) NULL,
	"qtd_burden_cum"        	numeric(20,6) NULL,
	"qtd_other_cum" 		numeric(20,6) NULL,
	"planned_cost"  		numeric(20,6) NULL,
	"planned_material"      	numeric(20,6) NULL,
	"planned_labor" 		numeric(20,6) NULL,
	"planned_burden"        	numeric(20,6) NULL,
	"planned_other" 		numeric(20,6) NULL,
	"planned_cost_cum"      	numeric(20,6) NULL,
	"planned_material_cum"  	numeric(20,6) NULL,
	"planned_labor_cum"     	numeric(20,6) NULL,
	"planned_burden_cum"    	numeric(20,6) NULL,
	"planned_other_cum"     	numeric(20,6) NULL,
	"frozen_cost"   		numeric(20,6) NULL,
	"frozen_material"       	numeric(20,6) NULL,
	"frozen_burden" 		numeric(20,6) NULL,
	"frozen_labor"  		numeric(20,6) NULL,
	"frozen_other"  		numeric(20,6) NULL,
	"frozen_cost_cum"       	numeric(20,6) NULL,
	"frozen_material_cum"   	numeric(20,6) NULL,
	"frozen_burden_cum"     	numeric(20,6) NULL,
	"frozen_labor_cum"      	numeric(20,6) NULL,
	"frozen_other_cum"      	numeric(20,6) NULL,
	"cost_changed_date"     	datetime NULL,
	"qtd_changed_date"      	datetime NULL,
	"planned_changed_date"  	datetime NULL,
	"frozen_changed_date"   	datetime NULL,
	PRIMARY KEY ("part")
)
go
CREATE TABLE dbo."part_customer_price_matrix"
(
	"part"  			varchar(25) NOT NULL,
	"customer"      		varchar(25) NOT NULL,
	"code"  			varchar(10) NULL,
	"price" 			numeric(20,6) NULL,
	"qty_break"     		numeric(20,6) NOT NULL,
	"discount"      		numeric(20,6) NULL,
	"category"      		varchar(25) NULL,
	"alternate_price"       	numeric(20,6) NULL,
	PRIMARY KEY ("part", "customer", "qty_break")
)
go
CREATE TABLE dbo."workorder_detail"
(
	"workorder"     		varchar(10) NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"qty_required"  		numeric(20,6) NULL,
	"qty_completed" 		numeric(20,6) NULL,
	"parts_per_cycle"       	numeric(20,6) NULL,
	"run_time"      		numeric(20,6) NULL,
	"scrapped"      		numeric(20,6) NULL,
	"balance"       		numeric(20,6) NULL,
	"plant" 			varchar(20) NULL,
	"parts_per_hour"        	numeric(20,6) NULL,
	PRIMARY KEY ("workorder", "part")
)
go
CREATE TABLE dbo."effective_change_notice"
(
	"part"  			varchar(25) NOT NULL,
	"effective_date"        	datetime NOT NULL,
	"notes" 			varchar(255) NULL,
	"engineering_level"     	varchar(10) NULL,
	"operator"      		varchar(5) NULL,
	PRIMARY KEY ("part", "effective_date")
)
go
CREATE TABLE dbo."group_technology"
(
	"id"    			varchar(25) NOT NULL,
	"notes" 			varchar(255) NULL,
	"source_type"   		varchar(10) NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."labor"
(
	"id"    			varchar(25) NOT NULL,
	"group_no"      		varchar(25) NULL,
	"standard_rate" 		numeric(20,6) NULL,
	"notes" 			varchar(255) NULL,
	"current_rate"  		numeric(20,6) NULL,
	"varying_rate_1"        	numeric(20,6) NULL,
	"varying_rate_2"        	numeric(20,6) NULL,
	"indirect"      		numeric(20,6) NULL,
	"sga"   			numeric(20,6) NULL,
	"qted_rate"     		numeric(20,6) NULL,
	"qted_variable" 		numeric(20,6) NULL,
	"qted_indirect" 		numeric(20,6) NULL,
	"qted_sga"      		numeric(20,6) NULL,
	"plnd_rate"     		numeric(20,6) NULL,
	"plnd_variable" 		numeric(20,6) NULL,
	"plnd_indirect" 		numeric(20,6) NULL,
	"plnd_sga"      		numeric(20,6) NULL,
	"frzn_rate"     		numeric(20,6) NULL,
	"frzn_variable" 		numeric(20,6) NULL,
	"frzn_indirect" 		numeric(20,6) NULL,
	"frzn_sga"      		numeric(20,6) NULL,
	"gl_segment"    		varchar(50) NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."machine_process"
(
	"machine"       		varchar(25) NOT NULL,
	"process"       		varchar(10) NOT NULL,
	PRIMARY KEY ("machine", "process")
)
go
CREATE TABLE dbo."part_machine"
(
	"part"  			varchar(25) NOT NULL,
	"machine"       		varchar(15) NOT NULL,
	"sequence"      		integer NULL,
	"mfg_lot_size"  		numeric(20,6) NULL,
	"process_id"    		varchar(25) NULL,
	"parts_per_cycle"       	numeric(20,6) NULL,
	"parts_per_hour"        	numeric(20,6) NULL,
	"cycle_unit"    		varchar(10) NULL,
	"cycle_time"    		numeric(20,6) NULL,
	"overlap_type"  		char(1) NULL,
	"overlap_time"  		numeric(6,2) NULL,
	"labor_code"    		varchar(25) NULL,
	"activity"      		varchar(25) NULL,
	"setup_time"    		numeric(20,6) NULL,
	"crew_size"     		numeric(20,6) NULL,
	PRIMARY KEY ("part", "machine")
)
go
CREATE TABLE dbo."department"
(
	"code"  			varchar(30) NOT NULL,
	"name"  			varchar(50) NOT NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."salesrep"
(
	"salesrep"      		varchar(10) NOT NULL,
	"name"  			varchar(40) NOT NULL,
	"commission_rate"       	numeric(7,4) NOT NULL,
	"commission_type"       	char(1) NOT NULL,
	PRIMARY KEY ("salesrep")
)
go
CREATE TABLE dbo."carrier"
(
	"name"  			varchar(35) NOT NULL,
	"scac"  			varchar(4) NOT NULL,
	"trans_mode"    		varchar(2) NOT NULL,
	"phone" 			varchar(20) NULL,
	PRIMARY KEY ("name")
)
go
CREATE TABLE dbo."part_customer"
(
	"part"  			varchar(25) NOT NULL,
	"customer"      		varchar(10) NOT NULL,
	"customer_part" 		varchar(25) NOT NULL,
	"customer_standard_pack"        numeric(20,6) NOT NULL,
	"taxable"       		char(1) NULL,
	"customer_unit" 		varchar(3) NULL,
	"type"  			char(1) NULL,
	"upc_code"      		varchar(11) NULL,
	"blanket_price" 		numeric(20,6) NULL,
	PRIMARY KEY ("part", "customer")
)
go
CREATE TABLE dbo."package_materials"
(
	"code"  			varchar(20) NOT NULL,
	"name"  			varchar(25) NULL,
	"type"  			char(1) NOT NULL,
	"returnable"    		char(1) NOT NULL,
	"weight"        		numeric(12,6) NOT NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."part_packaging"
(
	"part"  			varchar(25) NOT NULL,
	"code"  			varchar(20) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"manual_tare"   		char(1) NULL,
	"label_format"  		varchar(25) NULL,
	"round_to_whole_number" 	char(1) NULL,
	"package_is_object"     	char(1) NULL,
	"inactivity_time"       	smallint NULL,
	"threshold_upper"       	numeric(20,6) NULL,
	"threshold_lower"       	numeric(20,6) NULL,
	"unit"  			varchar(3) NULL,
	"stage_using_weight"    	char(1) NULL,
	"inactivity_amount"     	numeric(20,6) NULL,
	"threshold_upper_type"  	varchar(1) NULL,
	"threshold_lower_type"  	varchar(1) NULL,
	"serial_type"   		varchar(25) NULL,
	PRIMARY KEY ("part", "code")
)
go
CREATE TABLE dbo."machine_policy"
(
	"machine"       		varchar(10) NOT NULL,
	"job_change"    		char(1) NOT NULL,
	"schedule_queue"        	char(1) NOT NULL,
	"start_stop_login"      	char(1) NOT NULL,
	"process_control"       	char(1) NOT NULL,
	"access_inventory_control"      char(1) NOT NULL,
	"material_substitution" 	char(1) NOT NULL,
	"change_std_pack"       	char(1) NOT NULL,
	"change_packaging"      	char(1) NOT NULL,
	"change_unit"   		char(1) NOT NULL,
	"job_completion_delete" 	char(1) NOT NULL,
	"material_issue_delete" 	char(1) NOT NULL,
	"defects_delete"        	char(1) NOT NULL,
	"downtime_delete"       	char(1) NOT NULL,
	"smallest_downtime_increment"   integer NOT NULL,
	"downtime_histogram_days"       integer NOT NULL,
	"work_order_display_window"     varchar(60) NULL,
	"packaging_line"        	char(1) NULL,
	"operator_required"     	char(1) NULL,
	"supervisorclose"       	char(1) NULL,
	PRIMARY KEY ("machine")
)
go
CREATE TABLE dbo."asn_overlay_structure"
(
	"overlay_group" 		varchar(10) NOT NULL,
	"column_name"   		varchar(25) NOT NULL,
	"line"  			integer NOT NULL,
	"position"      		integer NOT NULL,
	"section"       		char(1) NOT NULL,
	"length"        		integer NULL,
	"hard_code_value"       	varchar(25) NULL,
	"error" 			char(1) NULL,
	PRIMARY KEY ("overlay_group", "column_name", "line", "position", "section")
)
go
CREATE TABLE dbo."bill_of_lading"
(
	"bol_number"    		integer NOT NULL,
	"scac_transfer" 		varchar(35) NULL,
	"scac_pickup"   		varchar(35) NULL,
	"trans_mode"    		varchar(10) NULL,
	"equipment_initial"     	varchar(10) NULL,
	"equipment_description" 	varchar(10) NULL,
	"status"        		char(1) NULL,
	"printed"       		char(1) NULL,
	"gross_weight"  		numeric(7,2) NULL,
	"net_weight"    		numeric(7,2) NULL,
	"tare_weight"   		numeric(7,2) NULL,
	"destination"   		varchar(20) NULL,
	"lading_quantity"       	numeric(20,6) NULL,
	"total_boxes"   		numeric(20,6) NULL,
	PRIMARY KEY ("bol_number")
)
go
CREATE TABLE dbo."temp_order_cum"
(
	"order_no"      		numeric(8,0) NOT NULL,
	"our_cum"       		numeric(20,6) NULL,
	"the_cum"       		numeric(20,6) NULL,
	PRIMARY KEY ("order_no")
)
go
CREATE TABLE dbo."temp_pops"
(
	"name"  			varchar(45) NOT NULL,
	"number"        		varchar(20) NOT NULL,
	"area"  			varchar(5) NULL,
	PRIMARY KEY ("name", "number")
)
go
CREATE TABLE dbo."order_detail"
(
	"order_no"      		numeric(8,0) NOT NULL,
	"part_number"   		varchar(25) NOT NULL,
	"type"  			char(1) NULL,
	"product_name"  		varchar(100) NULL,
	"quantity"      		numeric(20,6) NULL,
	"price" 			numeric(20,6) NULL,
	"notes" 			varchar(255) NULL,
	"assigned"      		varchar(35) NULL,
	"shipped"       		numeric(20,6) NULL,
	"invoiced"      		numeric(20,6) NULL,
	"status"        		char(1) NULL,
	"our_cum"       		numeric(20,6) NULL,
	"the_cum"       		numeric(20,6) NULL,
	"due_date"      		datetime NULL,
	"sequence"      		numeric(5,0) NOT NULL,
	"destination"   		varchar(25) NULL,
	"unit"  			varchar(2) NULL,
	"committed_qty" 		numeric(20,6) NULL,
	"row_id"        		integer NULL,
	"group_no"      		varchar(10) NULL,
	"cost"  			numeric(20,6) NULL,
	"plant" 			varchar(10) NULL,
	"release_no"    		varchar(30) NULL,
	"flag"  			integer NULL,
	"week_no"       		integer NULL,
	"std_qty"       		numeric(20,6) NULL,
	"customer_part" 		varchar(30) NULL,
	"ship_type"     		char(1) NULL,
	"dropship_po"   		integer NULL,
	"dropship_po_row_id"    	integer NULL,
	"suffix"        		integer NULL,
	"packline_qty"  		numeric(20,6) NULL DEFAULT 0,
	"packaging_type"        	varchar(20) NULL,
	"weight"        		numeric(20,6) NULL,
	"custom01"      		varchar(30) NULL,
	"custom02"      		varchar(30) NULL,
	"custom03"      		varchar(30) NULL,
	"dimension_qty_string"  	varchar(50) NULL,
	"engineering_level"     	varchar(25) NULL,
	"alternate_price"       	numeric(20,6) NULL,
	"box_label"     		varchar(25) NULL,
	"pallet_label"  		varchar(25) NULL,
	"id"    			integer NOT NULL IDENTITY(1, 1),
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."link"
(
	"type"  			char(1) NOT NULL,
	"order_no"      		integer NOT NULL,
	"order_detail_id"       	integer NOT NULL,
	"mps_origin"    		integer NOT NULL,
	"mps_row_id"    		integer NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	PRIMARY KEY ("type", "order_no", "order_detail_id", "mps_origin", "mps_row_id")
)
go
CREATE TABLE dbo."shipper_container"
(
	"shipper"       		integer NOT NULL,
	"container_type"        	varchar(15) NOT NULL,
	"quantity"      		integer NULL,
	"weight"        		numeric(20,6) NULL,
	"group_flag"    		char(1) NULL,
	PRIMARY KEY ("shipper", "container_type")
)
go
CREATE TABLE dbo."user_definable_module_labels"
(
	"module"        		varchar(10) NOT NULL,
	"sequence"      		integer NOT NULL,
	"label" 			varchar(15) NOT NULL,
	"calculated_field"      	char(1) NULL,
	PRIMARY KEY ("module", "sequence")
)
go
CREATE TABLE dbo."plant_part"
(
	"plant" 			varchar(10) NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"min_onhand"    		numeric(20,6) NULL,
	"min_onorder"   		numeric(20,6) NULL,
	PRIMARY KEY ("plant", "part")
)
go
CREATE TABLE dbo."user_definable_data"
(
	"module"        		varchar(10) NOT NULL,
	"sequence"      		integer NOT NULL,
	"code"  			varchar(50) NOT NULL,
	"description"   		varchar(255) NULL,
	PRIMARY KEY ("module", "sequence", "code")
)
go
CREATE TABLE dbo."edi_overlay_structure"
(
	"overlay_group" 		varchar(10) NOT NULL,
	"data_set"      		varchar(3) NOT NULL,
	"column_name"   		varchar(25) NOT NULL,
	"line"  			integer NOT NULL,
	"position"      		integer NOT NULL,
	"length"        		integer NOT NULL,
	"last_line_in_detail_section"   char(1) NULL,
	"filter_value"  		varchar(15) NULL,
	"kanban"        		char(1) NULL,
	PRIMARY KEY ("overlay_group", "data_set", "column_name", "line", "position")
)
go
CREATE TABLE dbo."workorder_detail_history"
(
	"workorder"     		varchar(10) NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"qty_required"  		numeric(20,6) NULL,
	"qty_completed" 		numeric(20,6) NULL,
	"parts_per_cycle"       	numeric(20,6) NULL,
	"run_time"      		numeric(20,6) NULL,
	"scrapped"      		numeric(20,6) NULL,
	"balance"       		numeric(20,6) NULL,
	"plant" 			varchar(20) NULL,
	"parts_per_hour"        	numeric(20,6) NULL,
	PRIMARY KEY ("workorder", "part")
)
go
CREATE TABLE dbo."inventory_parameters"
(
	"record_number" 		float NOT NULL,
	"machine_number"        	varchar(20) NULL,
	"jc_machine"    		char(1) NULL,
	"jc_part"       		char(1) NULL,
	"jc_packaging"  		char(1) NULL,
	"jc_location_to"        	char(1) NULL,
	"jc_operator"   		char(1) NULL,
	"jc_number_of"  		char(1) NULL,
	"jc_qty"        		char(1) NULL,
	"jc_unit"       		char(1) NULL,
	"mi_machine"    		char(1) NULL,
	"mi_operator"   		char(1) NULL,
	"mi_serial"     		char(1) NULL,
	"mi_qty"        		char(1) NULL,
	"mi_unit"       		char(1) NULL,
	"bo_operator"   		char(1) NULL,
	"bo_serial"     		char(1) NULL,
	"bo_number_of"  		char(1) NULL,
	"bo_qty"        		char(1) NULL,
	"bo_unit"       		char(1) NULL,
	"jc_allow_zero_qty"     	char(1) NULL,
	"jc_parts_mode" 		char(1) NULL,
	"limit_locations"       	char(1) NULL,
	"jc_material_lot"       	char(1) NULL,
	"limit_locations_jc"    	char(1) NULL,
	"limit_locations_mi"    	char(1) NULL,
	"limit_locations_tr"    	char(1) NULL,
	PRIMARY KEY ("record_number")
)
go
CREATE TABLE dbo."location_limits"
(
	"trans_code"    		char(1) NOT NULL,
	"location_code" 		varchar(10) NOT NULL,
	PRIMARY KEY ("trans_code", "location_code")
)
go
CREATE TABLE dbo."po_detail_history"
(
	"po_number"     		integer NOT NULL,
	"vendor_code"   		varchar(10) NOT NULL,
	"part_number"   		varchar(25) NOT NULL,
	"description"   		varchar(100) NULL,
	"unit_of_measure"       	varchar(2) NULL,
	"date_due"      		datetime NOT NULL,
	"requisition_number"    	varchar(10) NULL,
	"status"        		char(1) NULL,
	"type"  			char(1) NULL,
	"last_recvd_date"       	datetime NULL,
	"last_recvd_amount"     	numeric(20,6) NULL,
	"cross_reference_part"  	varchar(25) NULL,
	"account_code"  		varchar(50) NULL,
	"notes" 			varchar(255) NULL,
	"quantity"      		numeric(20,6) NULL,
	"received"      		numeric(20,6) NULL,
	"balance"       		numeric(20,6) NULL,
	"active_release_cum"    	numeric(20,6) NULL,
	"received_cum"  		numeric(20,6) NULL,
	"price" 			numeric(20,6) NULL,
	"row_id"        		numeric(20,0) NOT NULL,
	"invoice_status"        	char(1) NULL,
	"invoice_date"  		datetime NULL,
	"invoice_qty"   		numeric(20,6) NULL,
	"invoice_unit_price"    	numeric(20,6) NULL,
	"release_no"    		integer NULL,
	"ship_to_destination"   	varchar(25) NULL,
	"terms" 			varchar(20) NULL,
	"week_no"       		integer NULL,
	"plant" 			varchar(10) NULL,
	"invoice_number"        	varchar(10) NULL,
	"standard_qty"  		numeric(20,6) NULL,
	"sales_order"   		integer NULL,
	"dropship_oe_row_id"    	integer NULL,
	"ship_type"     		char(1) NULL,
	"dropship_shipper"      	integer NULL,
	"price_unit"    		char(1) NULL,
	"printed"       		char(1) NULL,
	"selected_for_print"    	char(1) NULL,
	"deleted"       		char(1) NULL,
	"ship_via"      		varchar(15) NULL,
	"release_type"  		char(1) NULL,
	"dimension_qty_string"  	varchar(50) NULL,
	"taxable"       		char(1) NULL,
	"job_cost_no"   		varchar(25) NULL,
	"requisition_id"        	integer NULL,
	"cum_invoiced_quantity" 	numeric(18,6) NULL,
	"cum_invoiced_amount"   	numeric(18,6) NULL,
	"posted"        		char(1) NULL,
	"alternate_price"       	numeric(20,6) NULL
)
go
CREATE TABLE dbo."destination_package"
(
	"destination"   		varchar(20) NOT NULL,
	"package"       		varchar(20) NOT NULL,
	"customer_box_code"     	varchar(20) NULL,
	"cum"   			integer NULL,
	PRIMARY KEY ("destination", "package")
)
go
CREATE TABLE dbo."user_defined_status"
(
	"display_name"  		varchar(30) NOT NULL,
	"type"  			char(1) NULL,
	"base"  			char(1) NULL,
	PRIMARY KEY ("display_name")
)
go
CREATE TABLE dbo."price_promotion"
(
	"promotion"     		integer NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"customer"      		varchar(10) NOT NULL,
	"category"      		varchar(25) NOT NULL,
	"price" 			numeric(20,6) NOT NULL,
	"start_date"    		datetime NOT NULL,
	"end_date"      		datetime NOT NULL,
	"note"  			varchar(255) NULL,
	PRIMARY KEY ("promotion")
)
go
CREATE TABLE dbo."category"
(
	"code"  			varchar(10) NOT NULL,
	"name"  			varchar(25) NULL,
	"markup"        		numeric(20,6) NULL,
	"multiplier"    		char(1) NULL,
	"premium"       		numeric(20,6) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."limit_parts"
(
	"part"  			varchar(25) NOT NULL,
	PRIMARY KEY ("part")
)
go
CREATE TABLE dbo."interface_utilities"
(
	"transaction_type"      	varchar(10) NOT NULL,
	"sequence"      		integer NOT NULL,
	"name"  			varchar(50) NOT NULL,
	"type"  			char(1) NOT NULL,
	"parameters"    		varchar(255) NULL,
	PRIMARY KEY ("transaction_type", "sequence")
)
go
CREATE TABLE dbo."term"
(
	"description"   		varchar(20) NOT NULL,
	"type"  			varchar(25) NOT NULL,
	"due_day"       		integer NULL,
	"discount_days" 		integer NULL,
	"discount_percentage"   	numeric(5,2) NULL,
	"eom_cut_off"   		integer NULL
)
go
CREATE TABLE dbo."alternative_parts"
(
	"main_part"     		varchar(25) NOT NULL,
	"alt_part"      		varchar(25) NOT NULL,
	PRIMARY KEY ("main_part", "alt_part")
)
go
CREATE TABLE dbo."destination_conversion"
(
	"customer"      		char(50) NULL,
	"dest_new"      		char(50) NULL,
	"dest_old"      		char(50) NULL
)
go
CREATE TABLE dbo."destination_message_file"
(
	"destination"   		char(20) NOT NULL,
	"message1"      		char(50) NULL,
	"message10"     		char(50) NULL,
	"message2"      		char(50) NULL,
	"message3"      		char(50) NULL,
	"message4"      		char(50) NULL,
	"message5"      		char(50) NULL,
	"message6"      		char(50) NULL,
	"message7"      		char(50) NULL,
	"message8"      		char(50) NULL,
	"message9"      		char(50) NULL,
	PRIMARY KEY ("destination")
)
go
CREATE TABLE dbo."bill_of_material_ec"
(
	"parent_part"   		varchar(25) NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"start_datetime"        	datetime NOT NULL,
	"end_datetime"  		datetime NULL,
	"type"  			char(1) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"unit_measure"  		varchar(2) NOT NULL,
	"reference_no"  		varchar(50) NULL,
	"std_qty"       		numeric(20,6) NULL,
	"scrap_factor"  		numeric(20,6) NOT NULL,
	"engineering_level"     	varchar(10) NULL,
	"operator"      		varchar(5) NULL,
	"substitute_part"       	varchar(25) NULL,
	"date_changed"  		datetime NOT NULL,
	"note"  			varchar(255) NULL,
	PRIMARY KEY ("parent_part", "part", "start_datetime")
)
go
CREATE TABLE dbo."contact_call_log"
(
	"contact"       		varchar(35) NOT NULL,
	"start_date"    		datetime NOT NULL,
	"call_subject"  		varchar(100) NOT NULL,
	"call_content"  		text NOT NULL,
	"stop_date"     		datetime NULL,
	PRIMARY KEY ("contact", "start_date")
)
go
CREATE TABLE dbo."currency_conversion"
(
	"currency_code" 		varchar(10) NOT NULL,
	"rate"  			numeric(20,6) NOT NULL,
	"effective_date"        	datetime NOT NULL,
	"currency_display_symbol"       varchar(10) NULL,
	PRIMARY KEY ("currency_code", "effective_date")
)
go
CREATE TABLE dbo."customer_origin_code"
(
	"code"  			varchar(25) NOT NULL,
	"description"   		varchar(50) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."customer_service_status"
(
	"status_name"   		varchar(20) NOT NULL,
	"status_type"   		varchar(1) NOT NULL,
	"default_value" 		varchar(1) NOT NULL,
	PRIMARY KEY ("status_name")
)
go
CREATE TABLE dbo."dim_relation"
(
	"dim_code"      		varchar(2) NOT NULL,
	"dimension"     		varchar(10) NULL,
	"delete_flag"   		varchar(1) NULL,
	"dim_qty"       		numeric(9,3) NULL,
	"relationship"  		varchar(254) NULL,
	PRIMARY KEY ("dim_code")
)
go
CREATE TABLE dbo."dimensions"
(
	"dim_code"      		varchar(2) NOT NULL,
	"dimension"     		varchar(10) NOT NULL,
	"delete_flag"   		varchar(1) NULL,
	"dim_qty"       		numeric(9,3) NULL,
	"varying_dimension"     	numeric(1,0) NULL,
	PRIMARY KEY ("dim_code", "dimension")
)
go
CREATE TABLE dbo."edi_ff_layout"
(
	"transaction_set"       	char(3) NOT NULL,
	"overlay_group" 		char(3) NOT NULL,
	"line"  			char(2) NOT NULL,
	"field" 			char(2) NOT NULL,
	"field_description"     	varchar(25) NOT NULL,
	"data_type"     		char(2) NOT NULL,
	"position"      		integer NOT NULL,
	"length"        		integer NOT NULL,
	"segment"       		varchar(6) NULL,
	"description"   		varchar(25) NOT NULL,
	"version"       		varchar(6) NOT NULL,
	"version_date"  		datetime NOT NULL,
	PRIMARY KEY ("transaction_set", "overlay_group", "line", "field")
)
go
CREATE TABLE dbo."edi_ff_loops"
(
	"transaction_set"       	char(3) NOT NULL,
	"overlay_group" 		char(3) NOT NULL,
	"line"  			integer NOT NULL,
	"max_loops"     		integer NOT NULL,
	"loop_line"     		integer NULL,
	"line_name"     		varchar(25) NULL,
	"loop_name"     		varchar(25) NULL,
	"used"  			char(1) NULL,
	"loop_used"     		char(1) NULL,
	PRIMARY KEY ("transaction_set", "overlay_group", "line")
)
go
CREATE TABLE dbo."gl_tran_type"
(
	"code"  			varchar(1) NOT NULL,
	"name"  			varchar(25) NOT NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."issues"
(
	"issue_number"  		integer NOT NULL,
	"issue" 			text NOT NULL,
	"status"        		varchar(25) NULL,
	"solution"      		text NULL,
	"start_date"    		datetime NOT NULL,
	"stop_date"     		datetime NULL,
	"category"      		varchar(50) NOT NULL,
	"sub_category"  		varchar(50) NULL,
	"priority_level"        	smallint NOT NULL,
	"product_line"  		varchar(50) NULL,
	"product_code"  		varchar(50) NULL,
	"origin_type"   		varchar(50) NOT NULL,
	"origin"        		varchar(50) NOT NULL,
	"assigned_to"   		varchar(50) NULL,
	"authorized_by" 		varchar(50) NULL,
	"documentation_change"  	varchar(1) NULL,
	"fax_sheet"     		varchar(1) NULL,
	"environment"   		varchar(255) NULL,
	"entered_by"    		varchar(50) NULL,
	"product_component"     	varchar(25) NULL,
	PRIMARY KEY ("issue_number")
)
go
CREATE TABLE dbo."issues_category"
(
	"category"      		varchar(50) NOT NULL,
	"default_value" 		varchar(1) NOT NULL,
	PRIMARY KEY ("category")
)
go
CREATE TABLE dbo."issues_status"
(
	"status"        		varchar(25) NOT NULL,
	"type"  			varchar(1) NOT NULL,
	"default_value" 		varchar(1) NOT NULL,
	PRIMARY KEY ("status")
)
go
CREATE TABLE dbo."machine_data_1050"
(
	"machine"       		varchar(10) NOT NULL,
	"last_reset"    		datetime NULL,
	"status"        		char(1) NULL,
	"downtime"      		numeric(20,6) NULL,
	"cycle" 			numeric(20,6) NULL,
	"counter"       		numeric(20,6) NULL,
	"avg_cycle"     		numeric(20,6) NULL,
	PRIMARY KEY ("machine")
)
go
CREATE TABLE dbo."part_class_definition"
(
	"class" 			char(1) NOT NULL,
	"class_name"    		varchar(25) NOT NULL,
	"status_flag"   		binary(8) NULL,
	PRIMARY KEY ("class")
)
go
CREATE TABLE dbo."part_gl_account"
(
	"part"  			varchar(25) NOT NULL,
	"tran_type"     		varchar(2) NOT NULL,
	"gl_account_no_db"      	varchar(50) NULL,
	"gl_account_no_cr"      	varchar(50) NULL,
	"name"  			varchar(50) NULL,
	PRIMARY KEY ("part", "tran_type")
)
go
CREATE TABLE dbo."part_location"
(
	"part"  			varchar(25) NOT NULL,
	"location"      		varchar(10) NOT NULL,
	"days_onhand"   		numeric(20,6) NULL,
	"maximum"       		numeric(20,6) NULL,
	"minimum"       		numeric(20,6) NULL,
	"reorder_qty"   		numeric(20,6) NULL,
	"destination"   		varchar(10) NULL,
	PRIMARY KEY ("part", "location")
)
go
CREATE TABLE dbo."part_machine_tool"
(
	"part"  			varchar(25) NOT NULL,
	"machine"       		varchar(10) NOT NULL,
	"tool"  			varchar(25) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	PRIMARY KEY ("part", "machine", "tool")
)
go
CREATE TABLE dbo."part_tooling"
(
	"part"  			varchar(25) NOT NULL,
	"tool_number"   		varchar(25) NOT NULL,
	"qty_part_per_tool"     	numeric(20,6) NOT NULL,
	PRIMARY KEY ("part", "tool_number")
)
go
CREATE TABLE dbo."part_machine_tool_list"
(
	"part"  			varchar(25) NOT NULL,
	"machine"       		varchar(10) NOT NULL,
	"station_id"    		varchar(25) NOT NULL,
	"station_type"  		char(1) NOT NULL,
	"tool"  			varchar(25) NOT NULL,
	"tool_qty"      		integer NOT NULL,
	"parts_per_tool"        	integer NOT NULL,
	"tool_list_no"  		varchar(50) NULL,
	PRIMARY KEY ("part", "machine", "station_id", "tool")
)
go
CREATE TABLE dbo."part_type_definition"
(
	"type"  			char(1) NOT NULL,
	"type_name"     		varchar(25) NOT NULL,
	"status_flag"   		binary(8) NULL,
	PRIMARY KEY ("type")
)
go
CREATE TABLE dbo."partlist"
(
	"part"  			varchar(25) NOT NULL
)
go
CREATE TABLE dbo."report_list"
(
	"report"        		varchar(25) NOT NULL,
	"description"   		varchar(255) NULL,
	PRIMARY KEY ("report")
)
go
CREATE TABLE dbo."unit_sub"
(
	"unit_group"    		varchar(2) NOT NULL,
	"sequence"      		numeric(3,0) NOT NULL,
	"sub_unit"      		varchar(10) NULL,
	"name_1"        		varchar(10) NULL,
	"name_2"        		varchar(10) NULL,
	"short_name"    		varchar(2) NULL,
	"symbol"        		varchar(1) NULL,
	"factor"        		numeric(6,2) NULL,
	PRIMARY KEY ("unit_group", "sequence")
)
go
CREATE TABLE dbo."vendor_custom"
(
	"code"  			varchar(10) NOT NULL,
	"custom1"       		varchar(25) NULL,
	"custom2"       		varchar(25) NULL,
	"custom3"       		varchar(25) NULL,
	"custom4"       		varchar(25) NULL,
	"custom5"       		varchar(25) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."issue_detail"
(
	"issue_number"  		integer NOT NULL,
	"status_old"    		varchar(25) NOT NULL,
	"status_new"    		varchar(25) NOT NULL,
	"date_stamp"    		datetime NOT NULL,
	"notes" 			text NOT NULL,
	"origin"        		varchar(50) NOT NULL,
	PRIMARY KEY ("issue_number", "date_stamp")
)
go
CREATE TABLE dbo."issues_sub_category"
(
	"category"      		varchar(50) NOT NULL,
	"sub_category"  		varchar(50) NOT NULL,
	"default_value" 		varchar(1) NOT NULL,
	PRIMARY KEY ("category", "sub_category")
)
go
CREATE TABLE dbo."machine_serial_comm"
(
	"machine"       		varchar(10) NOT NULL,
	"serial_port"   		smallint NOT NULL,
	"serial_prompt" 		char(1) NOT NULL,
	"serial_interface"      	varchar(10) NULL,
	"winwedge_location"     	varchar(255) NULL,
	"wwconfig_location"     	varchar(255) NULL,
	"amount_field"  		smallint NULL,
	"steady_field"  		smallint NULL,
	"steady_char"   		varchar(1) NULL,
	PRIMARY KEY ("machine")
)
go
CREATE TABLE dbo."part_class_type_cross_ref"
(
	"class" 			char(1) NOT NULL,
	"type"  			char(1) NOT NULL,
	PRIMARY KEY ("class", "type")
)
go
CREATE TABLE dbo."part_revision"
(
	"part"  			varchar(25) NOT NULL,
	"revision"      		varchar(10) NOT NULL,
	"engineering_level"     	varchar(10) NOT NULL,
	"effective_datetime"    	datetime NOT NULL,
	"notes" 			varchar(255) NULL,
	PRIMARY KEY ("part", "revision", "engineering_level")
)
go
CREATE TABLE dbo."region_code"
(
	"code"  			varchar(10) NOT NULL,
	"description"   		varchar(50) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."report_library"
(
	"name"  			varchar(25) NOT NULL,
	"report"        		varchar(25) NOT NULL,
	"type"  			varchar(1) NOT NULL,
	"object_name"   		varchar(255) NOT NULL,
	"library_name"  		varchar(255) NOT NULL,
	"preview"       		varchar(1) NULL,
	"print_setup"   		varchar(1) NULL,
	"printer"       		varchar(255) NULL,
	"copies"        		float NULL,
	PRIMARY KEY ("name", "report")
)
go
CREATE TABLE dbo."sales_manager_code"
(
	"code"  			varchar(10) NOT NULL,
	"description"   		varchar(50) NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."addresses"
(
	"address_id"    		char(25) NOT NULL,
	"address_1"     		char(50) NULL,
	"address_2"     		char(50) NULL,
	"address_3"     		char(50) NULL,
	"city"  			char(25) NULL,
	"state" 			char(25) NULL,
	"postal_code"   		char(10) NULL,
	"country"       		char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("address_id")
)
go
CREATE TABLE dbo."allocation_definitions"
(
	"allocation"    		char(25) NOT NULL,
	"ledger_account"        	char(50) NOT NULL,
	"allocation_percent"    	numeric(12,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"fiscal_year"   		varchar(5) NULL,
	"ledger"        		varchar(25) NULL,
	"import_batch"  		varchar(25) NULL,
	PRIMARY KEY ("allocation", "ledger_account")
)
go
CREATE TABLE dbo."bank_accounts"
(
	"bank_alias"    		char(25) NOT NULL,
	"bank_name"     		char(40) NULL,
	"bank_account_number"   	char(40) NULL,
	"contact_id"    		char(25) NULL,
	"ledger"        		char(40) NULL,
	"ledger_account"        	char(50) NULL,
	"direct_deposit"        	char(1) NULL,
	"direct_deposit_origin_number"  char(10) NULL,
	"last_check_number"     	integer NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"currency"      		char(25) NULL,
	"routing_number"        	char(40) NULL,
	"deposit_identifier_format"     char(40) NULL,
	"last_direct_deposit_number"    integer NULL,
	"status"        		char(1) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("bank_alias")
)
go
CREATE TABLE dbo."bank_register"
(
	"bank_alias"    		char(25) NOT NULL,
	"document_class"        	varchar(25) NOT NULL,
	"document_number"       	integer NOT NULL,
	"check_void_nsf"        	char(1) NOT NULL,
	"document_id1"  		char(25) NULL,
	"document_id2"  		char(25) NULL,
	"document_id3"  		varchar(25) NULL,
	"document_type" 		varchar(25) NOT NULL,
	"document_date" 		datetime NULL,
	"document_amount"       	numeric(14,2) NULL,
	"ledger_account_code"   	char(50) NULL,
	"gl_date"       		datetime NULL,
	"gl_entry"      		char(25) NULL,
	"fiscal_year"   		char(5) NULL,
	"period"        		smallint NULL,
	"exchanged_amount"      	numeric(14,2) NULL,
	"document_exchange_rate"        numeric(12,6) NULL,
	"reconciled"    		char(1) NULL,
	"reconciled_date"       	datetime NULL,
	"reconciled_id" 		char(25) NULL,
	"document_group_id"     	char(25) NULL,
	"document_group_date"   	datetime NULL,
	"applied_amount"        	numeric(14,2) NULL,
	"last_date_applied"     	datetime NULL,
	"last_fiscal_year_applied"      char(5) NULL,
	"last_period_applied"   	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"offset_ledger_account_code"    char(50) NULL,
	"ledger"        		char(40) NULL,
	"bank_account_debit_credit"     char(1) NULL,
	"document_reference"    	char(50) NULL,
	"document_remarks"      	varchar(max) NULL,
	"pay_address_1" 		varchar(50) NULL,
	"pay_address_2" 		varchar(50) NULL,
	"pay_address_3" 		varchar(50) NULL,
	"pay_city"      		varchar(25) NULL,
	"pay_state"     		varchar(25) NULL,
	"pay_postal_code"       	varchar(10) NULL,
	"pay_country"   		varchar(50) NULL,
	"pay_vendor_name"       	varchar(40) NULL,
	"pay_vendor_name_2"     	varchar(40) NULL,
	"bank_account"  		varchar(25) NULL,
	"transit_routing_no"    	varchar(25) NULL,
	"direct_deposit"        	char(1) NULL,
	"dd_account_type"       	char(1) NULL,
	"application_currency"  	varchar(25) NULL,
	"application_check_amount"      numeric(18,6) NULL,
	"application_applied_amount"    numeric(18,6) NULL,
	"approved"      		char(1) NULL,
	"currency"      		varchar(25) NULL,
	"status"        		varchar(25) NULL,
	"document_reference2"   	varchar(50) NULL,
	"pos_document_batch"    	varchar(25) NULL,
	"document_source"       	varchar(25) NULL,
	PRIMARY KEY ("bank_alias", "document_class", "document_number", "check_void_nsf")
)
go
CREATE TABLE dbo."bank_statements"
(
	"bank_alias"    		char(25) NOT NULL,
	"statement_date"        	datetime NOT NULL,
	"ending_balance"        	numeric(18,6) NOT NULL,
	"changed_date"  		datetime NOT NULL,
	"changed_user_id"       	char(25) NOT NULL,
	PRIMARY KEY ("bank_alias", "statement_date")
)
go
CREATE TABLE dbo."banks"
(
	"bank_name"     		char(40) NOT NULL,
	"address_id"    		char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"status"        		char(1) NULL,
	PRIMARY KEY ("bank_name")
)
go
CREATE TABLE dbo."companies"
(
	"company"       		char(25) NOT NULL,
	"company_name"  		char(40) NULL,
	"taxpayer_id_number"    	char(11) NULL,
	"address_id"    		char(25) NULL,
	"transmitter_control_code"      char(5) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"contact_1099"  		char(40) NULL,
	"phone_1099_contact"    	char(25) NULL,
	"net_futa_rate" 		char(1) NULL,
	"employment_ins_contr_rate"     numeric(18,6) NULL,
	"business_number"       	varchar(15) NULL,
	"w2_contact"    		varchar(27) NULL,
	"w2_contact_phone"      	varchar(15) NULL,
	"w2_contact_extension"  	varchar(5) NULL,
	"w2_contact_email"      	varchar(40) NULL,
	"w2_contact_fax"        	varchar(10) NULL,
	"w2_contact_notification"       char(1) NULL,
	"w2_pin"        		varchar(17) NULL,
	"email_1099_contact"    	varchar(40) NULL,
	"active_inactive"       	char(1) NULL,
	"trade_name"    		varchar(50) NULL,
	PRIMARY KEY ("company")
)
go
CREATE TABLE dbo."contacts"
(
	"contact_id"    		char(25) NOT NULL,
	"last_name"     		char(40) NULL,
	"first_name"    		char(40) NULL,
	"title" 			char(50) NULL,
	"phone" 			char(25) NULL,
	"fax_phone"     		char(25) NULL,
	"email_address" 		varchar(250) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("contact_id")
)
go
CREATE TABLE dbo."freight"
(
	"freight"       		char(25) NOT NULL,
	"freight_description"   	char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("freight")
)
go
CREATE TABLE dbo."freight_terms"
(
	"freight_term"  		char(25) NOT NULL,
	"freight_term_description"      char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("freight_term")
)
go
CREATE TABLE dbo."identifier_formats"
(
	"identifier_type"       	char(25) NOT NULL,
	"identifier_format"     	char(40) NOT NULL,
	"prefix"        		char(15) NULL,
	"starting_number"       	integer NULL,
	"increment_by"  		smallint NULL,
	"maximum_number"        	integer NULL,
	"next_number"   		integer NULL,
	"suffix"        		char(15) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("identifier_type", "identifier_format")
)
go
CREATE TABLE dbo."identifier_types"
(
	"identifier_type"       	char(25) NOT NULL,
	"system"        		char(2) NOT NULL,
	"installed_module"      	varchar(25) NULL,
	PRIMARY KEY ("identifier_type", "system")
)
go
CREATE TABLE dbo."navigation_group_options"
(
	"navigation_group"      	char(40) NOT NULL,
	"tablet"        		char(25) NOT NULL,
	"option_description"    	char(50) NOT NULL,
	"option_type"   		char(1) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("navigation_group", "tablet", "option_description")
)
go
CREATE TABLE dbo."navigation_groups"
(
	"navigation_group"      	char(40) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("navigation_group")
)
go
CREATE TABLE dbo."navigation_options"
(
	"option_description"    	char(40) NOT NULL,
	"option_type"   		char(1) NULL,
	"option_parameters"     	char(255) NULL,
	"option_help_message"   	char(100) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"menu"  			char(1) NULL,
	"menu_module"   		varchar(25) NULL,
	"menu_item_sort_order"  	integer NULL,
	"active_inactive"       	char(1) NULL,
	"standard"      		char(1) NULL,
	PRIMARY KEY ("option_description")
)
go
CREATE TABLE dbo."navigation_tablet_options"
(
	"tablet"        		char(25) NOT NULL,
	"option_description"    	char(50) NOT NULL,
	"option_type"   		char(1) NOT NULL,
	"option_order"  		smallint NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"installed_module"      	varchar(25) NULL,
	"standard"      		char(1) NULL,
	PRIMARY KEY ("tablet", "option_description")
)
go
CREATE TABLE dbo."navigation_tablets"
(
	"tablet"        		char(25) NOT NULL,
	"tablet_title"  		char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	"standard"      		char(1) NULL,
	PRIMARY KEY ("tablet")
)
go
CREATE TABLE dbo."preferences_site"
(
	"preference"    		char(50) NOT NULL,
	"value" 			char(100) NULL,
	"user_changeable"       	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("preference")
)
go
CREATE TABLE dbo."preferences_standard"
(
	"preference"    		char(50) NOT NULL,
	"description"   		char(255) NULL,
	"value" 			char(100) NULL,
	"user_changeable"       	char(1) NULL,
	"version"       		char(25) NULL,
	"validate_style"        	char(1) NULL,
	"validate_object"       	varchar(max) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	"installed_module"      	varchar(25) NULL,
	"value_standard"        	varchar(100) NULL,
	PRIMARY KEY ("preference")
)
go
CREATE TABLE dbo."preferences_user"
(
	"preference"    		char(50) NOT NULL,
	"security_id"   		char(25) NOT NULL,
	"value" 			char(100) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	"preference_source"     	varchar(25) NULL,
	PRIMARY KEY ("preference", "security_id")
)
go
CREATE TABLE dbo."taxes"
(
	"tax"   			char(25) NOT NULL,
	"tax_authority" 		char(40) NULL,
	"tax_percent"   		numeric(12,6) NULL,
	"include_tax"   		char(25) NULL,
	"capitalize_tax"        	char(1) NULL,
	"ledger"        		char(40) NULL,
	"dr_ledger_account"     	char(50) NULL,
	"cr_ledger_account"     	char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"contract_id"   		char(25) NULL,
	"contract_account_id"   	char(25) NULL,
	"costrevenue_type_id"   	char(25) NULL,
	PRIMARY KEY ("tax")
)
go
CREATE TABLE dbo."terms"
(
	"terms" 			char(25) NOT NULL,
	"terms_description"     	char(40) NULL,
	"net_days"      		smallint NULL,
	"disc_percent"  		numeric(12,6) NULL,
	"disc_days"     		smallint NULL,
	"eom_flag"      		char(1) NULL,
	"eom_cutoff"    		smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("terms")
)
go
CREATE TABLE dbo."unit_identifier_formats"
(
	"unit"  			char(25) NOT NULL,
	"identifier_type"       	char(25) NOT NULL,
	"identifier_format"     	char(40) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("unit", "identifier_type")
)
go
CREATE TABLE dbo."user_names"
(
	"security_id"   		char(25) NOT NULL,
	"password"      		char(15) NULL,
	"primary_tablet"        	char(25) NULL,
	"last_name"     		char(30) NULL,
	"first_name"    		char(30) NULL,
	"restricted"    		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"email_address" 		varchar(250) NULL,
	"email_notification"    	char(1) NULL,
	"membership_provider_username"  varchar(255) NULL,
	"created_date"  		datetime NULL,
	"last_activity_date"    	datetime NULL,
	"secured_for_empower"   	char(1) NULL,
	"secured_for_portal"    	char(1) NULL,
	"active_inactive"       	char(1) NULL,
	"locked"        		char(1) NULL,
	PRIMARY KEY ("security_id")
)
go
CREATE TABLE dbo."user_navigation_groups"
(
	"security_id"   		char(25) NOT NULL,
	"navigation_group"      	char(40) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("security_id", "navigation_group")
)
go
CREATE TABLE dbo."balance_definition"
(
	"fiscal_year"   		char(5) NOT NULL,
	"balance_name"  		char(25) NOT NULL,
	"balancing_required"    	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("fiscal_year", "balance_name")
)
go
CREATE TABLE dbo."calendar_periods"
(
	"fiscal_year"   		char(5) NOT NULL,
	"calendar"      		char(40) NOT NULL,
	"period"        		smallint NOT NULL,
	"period_name"   		char(25) NULL,
	"period_start_date"     	datetime NULL,
	"period_end_date"       	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	"period_class"  		varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "calendar", "period")
)
go
CREATE TABLE dbo."chart_of_accounts"
(
	"fiscal_year"   		char(5) NOT NULL,
	"coa"   			char(40) NOT NULL,
	"account"       		char(25) NOT NULL,
	"account_description"   	char(50) NULL,
	"balance_profit"        	char(1) NULL,
	"debit_credit_stat"     	char(1) NULL,
	"profit_group"  		char(25) NULL,
	"profit_group_description"      char(50) NULL,
	"coa_level_1"   		char(25) NULL,
	"coa_level_2"   		char(25) NULL,
	"coa_level_3"   		char(25) NULL,
	"coa_level_4"   		char(25) NULL,
	"coa_level_5"   		char(25) NULL,
	"coa_level_6"   		char(25) NULL,
	"coa_level_7"   		char(25) NULL,
	"coa_level_8"   		char(25) NULL,
	"coa_level_9"   		char(25) NULL,
	"coa_level_10"  		char(25) NULL,
	"coa_level_1_description"       char(50) NULL,
	"coa_level_2_description"       char(50) NULL,
	"coa_level_3_description"       char(50) NULL,
	"coa_level_4_description"       char(50) NULL,
	"coa_level_5_description"       char(50) NULL,
	"coa_level_6_description"       char(50) NULL,
	"coa_level_7_description"       char(50) NULL,
	"coa_level_8_description"       char(50) NULL,
	"coa_level_9_description"       char(50) NULL,
	"coa_level_10_description"      char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"cash_flow_line"        	smallint NULL,
	"prior_year_purchases_account"  varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	"wages_benefits"        	char(1) NULL,
	PRIMARY KEY ("fiscal_year", "coa", "account")
)
go
CREATE TABLE dbo."currencies"
(
	"currency"      		char(25) NOT NULL,
	"currency_description"  	char(50) NULL,
	"base_currency" 		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("currency")
)
go
CREATE TABLE dbo."exchange_rates"
(
	"currency"      		char(25) NOT NULL,
	"effective_on_date"     	datetime NOT NULL,
	"effective_off_date"    	datetime NULL,
	"exchange_rate" 		numeric(12,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("currency", "effective_on_date")
)
go
CREATE TABLE dbo."gl_cost_transactions"
(
	"document_type" 		char(25) NOT NULL,
	"document_id1"  		char(25) NOT NULL,
	"document_id2"  		char(25) NOT NULL,
	"document_id3"  		char(25) NOT NULL,
	"document_line" 		smallint NOT NULL,
	"ledger_account"        	char(50) NOT NULL,
	"contract_id"   		char(25) NOT NULL,
	"contract_account_id"   	char(25) NOT NULL,
	"costrevenue_type_id"   	char(25) NOT NULL,
	"fiscal_year"   		char(5) NULL,
	"ledger"        		char(40) NULL,
	"gl_entry"      		char(25) NULL,
	"period"        		smallint NULL,
	"transaction_date"      	datetime NULL,
	"amount"        		numeric(18,6) NULL,
	"document_amount"       	numeric(18,6) NULL,
	"document_currency"     	char(25) NULL,
	"exchange_date" 		datetime NULL,
	"exchange_rate" 		numeric(12,6) NULL,
	"document_reference1"   	char(50) NULL,
	"document_reference2"   	char(50) NULL,
	"document_remarks"      	varchar(max) NULL,
	"application"   		char(25) NULL,
	"quantity"      		numeric(18,6) NULL,
	"unit_of_measure"       	char(25) NULL,
	"user_defined_text"     	char(50) NULL,
	"user_defined_number"   	numeric(18,6) NULL,
	"user_defined_date"     	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"update_balances"       	char(1) NULL,
	"fa_depreciation_calc_id"       varchar(40) NULL,
	PRIMARY KEY ("document_type", "document_id1", "document_id2", "document_id3", "document_line", "ledger_account", "contract_id", "contract_account_id", "costrevenue_type_id")
)
go
CREATE TABLE dbo."journal_entries"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"gl_entry"      		char(25) NOT NULL,
	"period"        		smallint NULL,
	"balance_name"  		char(40) NULL,
	"je_description"        	char(50) NULL,
	"entry_date"    		datetime NULL,
	"entry_type"    		char(3) NULL,
	"je_committed"  		char(3) NULL,
	"related_gl_entry"      	char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"currency"      		varchar(25) NULL,
	"document_date" 		datetime NULL,
	"document_amount"       	numeric(18,6) NULL,
	"ledger_amount" 		numeric(18,6) NULL,
	"status"        		varchar(25) NULL,
	"approved"      		char(1) NULL,
	"batch" 			varchar(25) NULL,
	"unit"  			varchar(25) NULL,
	"document_type" 		varchar(25) NULL,
	"transaction_type"      	varchar(25) NULL,
	"document_comment"      	text NULL,
	"document_source"       	varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "gl_entry")
)
go
CREATE TABLE dbo."journal_entry_lines"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"gl_entry"      		char(25) NOT NULL,
	"ledger_account"        	char(50) NOT NULL,
	"period"        		smallint NULL,
	"balance_name"  		char(40) NULL,
	"amount"        		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "gl_entry", "ledger_account")
)
go
CREATE TABLE dbo."ledger_accounts"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"ledger_account"        	char(50) NOT NULL,
	"organization_level"    	char(40) NULL,
	"organization"  		char(40) NULL,
	"coa"   			char(40) NULL,
	"account"       		char(25) NULL,
	"active_inactive"       	char(1) NULL,
	"posting_reporting"     	char(1) NULL,
	"balance_profit"        	char(1) NULL,
	"exchange_method"       	char(1) NULL,
	"exchange_ledger_account"       char(50) NULL,
	"exchange_gain_loss_account"    char(50) NULL,
	"exchange_historical_date"      datetime NULL,
	"exchange_historical_rate"      numeric(14,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"bank_register_update"  	char(1) NULL,
	"encumbrance_ledger_account"    char(50) NULL,
	"profit_loss_ledger_account"    char(50) NULL,
	"exchange_gain_ledger_account"  varchar(50) NULL,
	"exchange_loss_ledger_account"  varchar(50) NULL,
	"next_year_ledger"      	varchar(40) NULL,
	"next_year_ledger_account"      varchar(50) NULL,
	"encumbrance_group"     	varchar(50) NULL,
	"cost_account_required" 	char(1) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "ledger_account")
)
go
CREATE TABLE dbo."ledger_balances"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"ledger_account"        	char(50) NOT NULL,
	"balance_name"  		char(25) NOT NULL,
	"period"        		smallint NOT NULL,
	"period_amount" 		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"to_ledger_account"     	varchar(50) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "ledger_account", "balance_name", "period")
)
go
CREATE TABLE dbo."ledger_definition"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"posting_consolidating" 	char(1) NULL,
	"calendar"      		char(40) NULL,
	"coa"   			char(40) NULL,
	"currency"      		char(25) NULL,
	"entry_identifier"      	char(40) NULL,
	"ledger_account_scheme" 	char(10) NULL,
	"last_period_closed"    	smallint NULL,
	"profit_loss_ledger_account"    char(50) NULL,
	"retained_earnings_ledger_acct" char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("fiscal_year", "ledger")
)
go
CREATE TABLE dbo."ledger_organization_levels"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"organization_level"    	char(40) NOT NULL,
	"display_order" 		smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "organization_level")
)
go
CREATE TABLE dbo."ledger_organizations"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"organization_level"    	char(40) NOT NULL,
	"organization"  		char(40) NOT NULL,
	"organization_description"      char(50) NULL,
	"reports_to_organization_level" char(40) NULL,
	"reports_to_organization"       char(40) NULL,
	"ledger_account_segment"        char(40) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"due_from_account"      	char(25) NULL,
	"pay_to_account"        	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "organization_level", "organization")
)
go
CREATE TABLE dbo."posting_relationships"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"ledger_account"        	char(50) NOT NULL,
	"relationship"  		char(10) NOT NULL,
	"to_ledger"     		char(40) NOT NULL,
	"to_ledger_account"     	char(50) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "ledger_account", "relationship", "to_ledger", "to_ledger_account")
)
go
CREATE TABLE dbo."sje_names"
(
	"sje_name"      		char(50) NOT NULL,
	"file_name"     		char(100) NOT NULL,
	"sje_comments"  		varchar(max) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(40) NULL,
	PRIMARY KEY ("sje_name")
)
go
CREATE TABLE dbo."spread_rules"
(
	"spread_rule"   		char(40) NOT NULL,
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"period"        		smallint NOT NULL,
	"rule_percent"  		numeric(12,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(40) NULL,
	PRIMARY KEY ("spread_rule", "fiscal_year", "ledger", "period")
)
go
CREATE TABLE dbo."ap_applications"
(
	"check_selection_identifier"    char(25) NOT NULL,
	"bank_alias"    		char(25) NOT NULL,
	"id_number"     		integer NOT NULL,
	"id_sequence"   		integer NOT NULL,
	"stub_id_number"        	integer NULL,
	"stub_number"   		smallint NULL,
	"number_of_stubs"       	smallint NULL,
	"check_number"  		integer NULL,
	"reversed"      		char(1) NULL,
	"reversal"      		char(1) NULL,
	"pay_unit"      		char(25) NULL,
	"pay_vendor"    		char(25) NULL,
	"buy_unit"      		char(25) NULL,
	"vendor"        		char(25) NULL,
	"invoice_cm"    		char(25) NULL,
	"inv_cm_flag"   		char(1) NULL,
	"discount_flag" 		char(1) NULL,
	"separate_check"        	char(1) NULL,
	"open_amount"   		numeric(18,6) NULL,
	"pay_amount"    		numeric(18,6) NULL,
	"due_date"      		datetime NULL,
	"discount_date" 		datetime NULL,
	"ledger_account_code"   	char(50) NULL,
	"inv_cm_date"   		datetime NULL,
	"applied_date"  		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"applied_to_invoice_cm" 	char(25) NULL,
	"gain_loss_amount"      	numeric(18,6) NULL,
	"exchanged_pay_amount"  	numeric(18,6) NULL,
	"direct_deposit"        	char(1) NULL,
	"applied_to_vendor"     	varchar(25) NULL,
	"fiscal_year"   		varchar(5) NULL,
	"ledger"        		varchar(40) NULL,
	"period"        		smallint NULL,
	"gl_entry"      		varchar(25) NULL,
	PRIMARY KEY ("check_selection_identifier", "bank_alias", "id_number", "id_sequence")
)
go
CREATE TABLE dbo."ap_check_selection_identifiers"
(
	"check_selection_identifier"    char(25) NOT NULL,
	"pay_unit"      		char(25) NULL,
	"pay_vendor"    		varchar(max) NULL,
	"buy_unit"      		varchar(max) NULL,
	"vendor"        		varchar(max) NULL,
	"bank_alias"    		varchar(max) NULL,
	"latest_due_date"       	datetime NULL,
	"latest_discount_date"  	datetime NULL,
	"earliest_discount_date"        datetime NULL,
	"check_selection_status"        char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"direct_deposit"        	char(1) NULL,
	"vendor_class"  		varchar(max) NULL,
	"document_class"        	varchar(max) NULL,
	PRIMARY KEY ("check_selection_identifier")
)
go
CREATE TABLE dbo."ap_document_classes"
(
	"document_class"        	char(25) NOT NULL,
	"document_class_description"    char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("document_class")
)
go
CREATE TABLE dbo."ap_headers"
(
	"vendor"        		char(25) NOT NULL,
	"inv_cm_flag"   		char(1) NOT NULL,
	"invoice_cm"    		char(25) NOT NULL,
	"buy_unit"      		char(25) NOT NULL,
	"pay_unit"      		char(25) NULL,
	"pay_vendor"    		char(25) NULL,
	"batch" 			char(25) NULL,
	"entered_datetime"      	datetime NULL,
	"contract"      		char(40) NULL,
	"purchase_order"        	char(25) NULL,
	"voucher"       		char(25) NULL,
	"bank_alias"    		char(25) NULL,
	"terms" 			char(25) NULL,
	"inv_cm_date"   		datetime NULL,
	"received_date" 		datetime NULL,
	"due_date"      		datetime NULL,
	"discount_date" 		datetime NULL,
	"inv_cm_amount" 		numeric(14,2) NULL,
	"tax_amount"    		numeric(14,2) NULL,
	"freight_amount"        	numeric(14,2) NULL,
	"applied_amount"        	numeric(14,2) NULL,
	"select_for_pay_amount" 	numeric(14,2) NULL,
	"matched"       		char(1) NULL,
	"matched_reason"        	char(25) NULL,
	"approved"      		char(1) NULL,
	"approved_reason"       	char(25) NULL,
	"hold_inv_cm"   		char(1) NULL,
	"separate_check"        	char(1) NULL,
	"ledger_account_code"   	char(50) NULL,
	"discount_ledger_account_code"  char(50) NULL,
	"gl_entry"      		char(25) NULL,
	"gl_date"       		datetime NULL,
	"fiscal_year"   		char(5) NULL,
	"period"        		smallint NULL,
	"currency"      		char(25) NULL,
	"check_selection_identifier"    char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"ledger"        		char(40) NULL,
	"intercompany"  		char(1) NULL,
	"document_class"        	char(25) NULL,
	"approver"      		char(25) NULL,
	"exchanged_amount"      	numeric(18,6) NULL,
	"exchanged_sel_for_pay_amount"  numeric(18,6) NULL,
	"exchanged_applied_amount"      numeric(18,6) NULL,
	"check_message" 		varchar(max) NULL,
	"approved_date" 		datetime NULL,
	"direct_deposit"        	char(1) NULL,
	"pay_vendor_name"       	varchar(40) NULL,
	"pay_vendor_name_2"     	varchar(40) NULL,
	"pay_address_1" 		varchar(50) NULL,
	"pay_address_2" 		varchar(50) NULL,
	"pay_address_3" 		varchar(50) NULL,
	"pay_city"      		varchar(25) NULL,
	"pay_state"     		varchar(25) NULL,
	"pay_postal_code"       	varchar(10) NULL,
	"pay_country"   		varchar(50) NULL,
	"document_source"       	varchar(25) NULL,
	PRIMARY KEY ("vendor", "inv_cm_flag", "invoice_cm")
)
go
CREATE TABLE dbo."ap_items"
(
	"vendor"        		char(25) NOT NULL,
	"inv_cm_flag"   		char(1) NOT NULL,
	"invoice_cm"    		char(25) NOT NULL,
	"inv_cm_line"   		smallint NOT NULL,
	"inv_cm_sort_line"      	smallint NULL,
	"purchase_order"        	char(25) NULL,
	"purchase_order_line"   	smallint NULL,
	"line_type"     		char(2) NULL,
	"item"  			char(25) NULL,
	"item_description"      	varchar(max) NULL,
	"location"      		char(25) NULL,
	"tax_1" 			char(25) NULL,
	"tax_2" 			char(25) NULL,
	"freight"       		char(25) NULL,
	"code_1099"     		char(1) NULL,
	"expense_analysis"      	char(25) NULL,
	"ledger_account_code"   	char(50) NULL,
	"variance_ledger_account"       char(50) NULL,
	"receiver"      		char(25) NULL,
	"quantity"      		numeric(12,3) NULL,
	"unit_of_measure"       	char(25) NULL,
	"price" 			numeric(14,5) NULL,
	"extended_amount"       	numeric(14,2) NULL,
	"approved"      		char(1) NULL,
	"approved_reason"       	char(25) NULL,
	"matched"       		char(1) NULL,
	"matched_reason"        	char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"purchase_order_sort_line"      numeric(8,2) NULL,
	"bill_of_lading"        	varchar(25) NULL,
	"c1099r_employee_contrb_amt"    numeric(18,6) NULL,
	"c1099r_fed_tax_withheld_amt"   numeric(18,6) NULL,
	"c1099r_distribution_code"      varchar(25) NULL,
	"c1099r_total_distribution"     char(1) NULL,
	"c1099r_taxable_amt_not_det"    char(1) NULL,
	"c1099r_ira_sep_simple" 	char(1) NULL,
	"amleadsrcid"   		integer NULL,
	"amleadexpenseid"       	integer NULL,
	"amleadexpense_adstart" 	datetime NULL,
	"amleadexpense_adend"   	datetime NULL,
	"sycampusid"    		integer NULL,
	PRIMARY KEY ("vendor", "inv_cm_flag", "invoice_cm", "inv_cm_line")
)
go
CREATE TABLE dbo."buyers"
(
	"buyer" 			char(25) NOT NULL,
	"buyer_description"     	char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("buyer")
)
go
CREATE TABLE dbo."expense_analyses"
(
	"expense_analysis"      	char(25) NOT NULL,
	"expense_analysis_description"  char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("expense_analysis")
)
go
CREATE TABLE dbo."locations"
(
	"location"      		char(25) NOT NULL,
	"location_description"  	char(50) NULL,
	"address_id"    		char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("location")
)
go
CREATE TABLE dbo."po_document_classes"
(
	"document_class"        	char(25) NOT NULL,
	"document_class_description"    char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("document_class")
)
go
CREATE TABLE dbo."po_types"
(
	"po_type"       		char(25) NOT NULL,
	"po_type_description"   	varchar(max) NULL,
	"approve_freight"       	char(1) NULL,
	"receive"       		char(1) NULL,
	"print_quantity"        	char(1) NULL,
	"print_price"   		char(1) NULL,
	"print_amount"  		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"pay_on_receipt"        	char(1) NULL,
	"expense_on_receipt"    	char(1) NULL,
	"approve_inv_by_item"   	char(1) NULL,
	"approve_inv_by_po_amount"      char(1) NULL,
	"approve_tax"   		char(1) NULL,
	"approver_is_buyer"     	char(1) NULL,
	"invoice_approver_source"       char(20) NULL,
	"not_to_exceed" 		char(1) NULL,
	"blanket"       		char(1) NULL,
	PRIMARY KEY ("po_type")
)
go
CREATE TABLE dbo."units_payables_purchasing"
(
	"unit"  			char(25) NOT NULL,
	"name"  			char(40) NULL,
	"ledger"        		char(40) NULL,
	"status"        		char(1) NULL,
	"gl_entry_frequency"    	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"company"       		char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("unit")
)
go
CREATE TABLE dbo."vendor_classes"
(
	"vendor_class"  		char(25) NOT NULL,
	"vendor_class_description"      char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("vendor_class")
)
go
CREATE TABLE dbo."vendors"
(
	"vendor"        		char(25) NOT NULL,
	"status"        		char(1) NULL,
	"intercompany"  		char(1) NULL,
	"vendor_class"  		char(25) NULL,
	"vendor_name"   		char(40) NULL,
	"vendor_name_2" 		char(40) NULL,
	"contact_id"    		char(25) NULL,
	"address_id"    		char(25) NULL,
	"pay_vendor"    		char(25) NULL,
	"pay_contact_id"        	char(25) NULL,
	"pay_address_id"        	char(25) NULL,
	"hdr_contract"  		char(40) NULL,
	"hdr_terms"     		char(25) NULL,
	"hdr_separate_check"    	char(1) NULL,
	"hdr_hold_payment"      	char(1) NULL,
	"hdr_invoice_limit"     	numeric(18,6) NULL,
	"hdr_ledger"    		char(40) NULL,
	"hdr_ledger_account_code"       char(50) NULL,
	"hdr_disc_ledger_account_code"  char(50) NULL,
	"item_ledger_account_code"      char(50) NULL,
	"item_expense_analysis" 	char(25) NULL,
	"item_tax_1"    		char(25) NULL,
	"item_tax_2"    		char(25) NULL,
	"item_freight"  		char(25) NULL,
	"chk_bank_alias"        	char(25) NULL,
	"chk_remittance_advice" 	char(1) NULL,
	"chk_minimum_check_amount"      numeric(18,6) NULL,
	"d1099_1099_code"       	char(1) NULL,
	"d1099_1099_name"       	char(40) NULL,
	"d1099_federal_tax_id"  	char(11) NULL,
	"d1099_state_tax_id"    	char(11) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"hdr_currency"  		char(25) NULL,
	"hdr_buy_unit"  		char(25) NULL,
	"hdr_pay_unit"  		char(25) NULL,
	"item_contract_id"      	char(25) NULL,
	"item_contract_account_id"      char(25) NULL,
	"item_costrevenue_type_id"      char(25) NULL,
	"item_rni_ledger_account"       char(50) NULL,
	"hdr_po_type"   		char(25) NULL,
	"hdr_po_document_class" 	char(25) NULL,
	"hdr_buyer"     		char(25) NULL,
	"hdr_freight_terms"     	char(25) NULL,
	"hdr_location"  		char(25) NULL,
	"hdr_po_comments"       	varchar(max) NULL,
	"disadvantaged_business_class"  char(25) NULL,
	"chk_check_name"        	char(40) NULL,
	"chk_check_name_2"      	char(40) NULL,
	"d1099_1099_name_2"     	char(40) NULL,
	"hdr_invoice_approver"  	char(25) NULL,
	"hdr_po_approver"       	char(25) NULL,
	"bank_account"  		char(25) NULL,
	"transit_routing_no"    	char(25) NULL,
	"prenotes_required"     	smallint NULL,
	"prenotes_given"        	smallint NULL,
	"last_document_group_id"        char(25) NULL,
	"direct_deposit"        	char(1) NULL,
	"dd_account_type"       	char(1) NULL,
	"security_company"      	char(25) NULL,
	"hdr_sales_terms"       	char(25) NULL,
	"hdr_sales_terms_location"      char(25) NULL,
	"payment_notification_method"   char(1) NULL,
	"po_notification_method"        char(1) NULL,
	PRIMARY KEY ("vendor")
)
go
CREATE TABLE dbo."account_managers"
(
	"account_manager"       	char(25) NOT NULL,
	"account_manager_description"   char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"commission_percent"    	numeric(18,6) NULL,
	PRIMARY KEY ("account_manager")
)
go
CREATE TABLE dbo."ar_applications"
(
	"application_number"    	integer NOT NULL,
	"application_line"      	smallint NOT NULL,
	"application_type"      	char(6) NULL,
	"document_type" 		char(1) NULL,
	"document"      		char(25) NULL,
	"reversed"      		char(1) NULL,
	"reversal"      		char(1) NULL,
	"bill_unit"     		char(25) NULL,
	"bill_customer" 		char(25) NULL,
	"check_number"  		varchar(25) NULL,
	"applied_document_type" 	char(1) NULL,
	"applied_document"      	char(25) NULL,
	"applied_amount"        	numeric(18,6) NULL,
	"applied_date"  		datetime NULL,
	"fiscal_year"   		char(5) NULL,
	"period"        		smallint NULL,
	"gl_entry"      		char(25) NULL,
	"ledger_account_code"   	char(50) NULL,
	"offset_ledger_account_code"    char(50) NULL,
	"ledger"        		char(40) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"exchanged_amount"      	numeric(18,6) NULL,
	"offset_exchanged_amount"       numeric(18,6) NULL,
	"gain_loss_amount"      	numeric(18,6) NULL,
	"offset_gain_loss_amount"       numeric(18,6) NULL,
	PRIMARY KEY ("application_number", "application_line")
)
go
CREATE TABLE dbo."ar_customers"
(
	"customer"      		char(25) NOT NULL,
	"status"        		char(1) NULL,
	"intercompany"  		char(1) NULL,
	"customer_class"        	char(25) NULL,
	"customer_name" 		char(100) NULL,
	"bill_customer" 		char(25) NULL,
	"bill_address_id"       	char(25) NULL,
	"bill_contact_id"       	char(25) NULL,
	"remit_to"      		varchar(50) NULL,
	"statement_cycle"       	char(25) NULL,
	"purge_option"  		char(25) NULL,
	"collection_agent"      	char(25) NULL,
	"db_number"     		char(25) NULL,
	"credit_rating" 		char(25) NULL,
	"tax_exempt_number"     	char(25) NULL,
	"writeoff_ledger_account"       char(50) NULL,
	"writeoff_limit"        	numeric(18,6) NULL,
	"delinquent_days"       	smallint NULL,
	"delinquent_dollars"    	numeric(18,6) NULL,
	"hdr_ship_unit" 		char(25) NULL,
	"hdr_bill_unit" 		char(25) NULL,
	"hdr_contract_po"       	char(25) NULL,
	"hdr_freight_terms"     	char(25) NULL,
	"hdr_price_group"       	char(25) NULL,
	"hdr_terms"     		char(25) NULL,
	"hdr_finance_charge"    	char(25) NULL,
	"hdr_comments"  		varchar(max) NULL,
	"hdr_doc_printed"       	char(1) NULL,
	"hdr_doc_approved"      	char(1) NULL,
	"hdr_doc_class" 		char(25) NULL,
	"hdr_currency"  		char(25) NULL,
	"hdr_account_manager"   	char(25) NULL,
	"hdr_send_doc_to"       	char(10) NULL,
	"hdr_ledger"    		char(40) NULL,
	"hdr_ledger_account_code"       char(50) NULL,
	"hdr_disc_ledger_account_code"  char(50) NULL,
	"item_tax_1"    		char(25) NULL,
	"item_tax_2"    		char(25) NULL,
	"item_sales_analysis"   	char(25) NULL,
	"item_ledger_account_code"      char(50) NULL,
	"item_contract_id"      	char(25) NULL,
	"item_contract_account_id"      char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"lock_box_id"   		char(40) NULL,
	"credit_limit"  		numeric(18,6) NULL,
	"underpay_receivables_account"  char(50) NULL,
	"overpay_sales_account" 	char(50) NULL,
	"overpay_liability_account"     char(50) NULL,
	"sales_terms"   		varchar(25) NULL,
	"discount_percent"      	numeric(18,6) NULL,
	"allow_backorder"       	char(1) NULL,
	"consolidator"  		varchar(25) NULL,
	"sales_agent"   		varchar(25) NULL,
	"order_processor"       	varchar(25) NULL,
	"territory"     		varchar(25) NULL,
	"inventory_location"    	varchar(25) NULL,
	"payment_method"        	varchar(25) NULL,
	"bank_draft_bank_name_address"  varchar(max) NULL,
	"security_company"      	varchar(25) NULL,
	"sales_terms_location"  	varchar(25) NULL,
	"send_order_to" 		varchar(10) NULL,
	"order_notification"    	varchar(6) NULL,
	"port_loading"  		varchar(25) NULL,
	"port_discharge"        	varchar(25) NULL,
	"ship_via"      		varchar(25) NULL,
	"freight_carrier"       	varchar(25) NULL,
	"invoice_notification"  	varchar(6) NULL,
	"cc_card"       		varchar(25) NULL,
	"cc_expiration_month"   	smallint NULL,
	"cc_expiration_year"    	smallint NULL,
	"cc_member"     		varchar(25) NULL,
	"mailing_list"  		varchar(25) NULL,
	PRIMARY KEY ("customer")
)
go
CREATE TABLE dbo."ar_customer_notes"
(
	"customer"      		char(25) NOT NULL,
	"note_date"     		datetime NOT NULL,
	"note"  			varchar(max) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"follow_up_date"        	datetime NULL,
	PRIMARY KEY ("customer", "note_date")
)
go
CREATE TABLE dbo."ar_document_classes"
(
	"document_class"        	char(25) NOT NULL,
	"document_class_description"    char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("document_class")
)
go
CREATE TABLE dbo."ar_headers"
(
	"document_type" 		char(1) NOT NULL,
	"document"      		char(25) NOT NULL,
	"ship_unit"     		char(25) NULL,
	"bill_unit"     		char(25) NULL,
	"ship_customer" 		char(25) NULL,
	"bill_customer" 		char(25) NULL,
	"send_doc_to"   		char(10) NULL,
	"contract_po"   		char(25) NULL,
	"freight_terms" 		char(25) NULL,
	"price_group"   		char(25) NULL,
	"account_manager"       	char(25) NULL,
	"document_class"        	char(25) NULL,
	"terms" 			char(25) NULL,
	"finance_charge"        	char(25) NULL,
	"currency"      		char(25) NULL,
	"intercompany"  		char(1) NULL,
	"printed"       		char(1) NULL,
	"document_comments"     	varchar(max) NULL,
	"tax_exempt_number"     	char(25) NULL,
	"fiscal_year"   		char(5) NULL,
	"ledger"        		char(40) NULL,
	"gl_entry"      		char(25) NULL,
	"period"        		smallint NULL,
	"gl_date"       		datetime NULL,
	"ledger_account_code"   	char(50) NULL,
	"amount"        		numeric(18,6) NULL,
	"exchanged_amount"      	numeric(18,6) NULL,
	"tax_amount"    		numeric(18,6) NULL,
	"freight_amount"        	numeric(18,6) NULL,
	"applied_amount"        	numeric(18,6) NULL,
	"document_date" 		datetime NULL,
	"due_date"      		datetime NULL,
	"discount_date" 		datetime NULL,
	"last_finance_chg_date" 	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"batch" 			char(25) NULL,
	"exchanged_applied_amount"      numeric(18,6) NULL,
	"ship_contact"  		char(50) NULL,
	"bill_contact"  		char(50) NULL,
	"sales_order"   		char(25) NULL,
	"bill_of_lading"        	char(25) NULL,
	"ship_name"     		varchar(100) NULL,
	"ship_address_1"        	varchar(50) NULL,
	"ship_address_2"        	varchar(50) NULL,
	"ship_address_3"        	varchar(50) NULL,
	"ship_city"     		varchar(25) NULL,
	"ship_state"    		varchar(25) NULL,
	"ship_postal_code"      	varchar(10) NULL,
	"ship_country"  		varchar(50) NULL,
	"bill_name"     		varchar(100) NULL,
	"bill_address_1"        	varchar(50) NULL,
	"bill_address_2"        	varchar(50) NULL,
	"bill_address_3"        	varchar(50) NULL,
	"bill_city"     		varchar(25) NULL,
	"bill_state"    		varchar(25) NULL,
	"bill_postal_code"      	varchar(10) NULL,
	"bill_country"  		varchar(50) NULL,
	"sales_agent"   		varchar(25) NULL,
	"sales_terms"   		varchar(25) NULL,
	"sales_terms_location"  	varchar(25) NULL,
	"territory"     		varchar(25) NULL,
	"ship_to_location"      	varchar(25) NULL,
	"shipper"       		varchar(25) NULL,
	"ship_contact_email_address"    varchar(250) NULL,
	"bill_contact_email_address"    varchar(250) NULL,
	"inventory_location"    	varchar(25) NULL,
	"update_inventory"      	char(1) NULL,
	"cc_card"       		varchar(25) NULL,
	"cc_expiration_month"   	smallint NULL,
	"cc_expiration_year"    	smallint NULL,
	"cc_member"     		varchar(25) NULL,
	"cc_manual"     		varchar(25) NULL,
	"cc_cardpresent"        	varchar(25) NULL,
	"payment_method"        	varchar(25) NULL,
	"pos_check_number"      	varchar(25) NULL,
	"pos_verification_id"   	varchar(25) NULL,
	"amount_tendered"       	numeric(18,6) NULL,
	"pos_paid"      		char(1) NULL,
	"pos_security_id"       	varchar(25) NULL,
	"program"       		varchar(25) NULL,
	"program_event" 		varchar(25) NULL,
	"document_source"       	varchar(25) NULL,
	"lease" 			varchar(25) NULL,
	"ship_contact_phone"    	varchar(25) NULL,
	"ship_contact_fax_phone"        varchar(25) NULL,
	"bill_contact_phone"    	varchar(25) NULL,
	"bill_contact_fax_phone"        varchar(25) NULL,
	"cc_troutd"     		varchar(25) NULL,
	"pos_register"  		varchar(25) NULL,
	"pos_cashier"   		varchar(25) NULL,
	"cc_type"       		varchar(25) NULL,
	PRIMARY KEY ("document_type", "document")
)
go
CREATE TABLE dbo."ar_items"
(
	"document_type" 		char(1) NOT NULL,
	"document"      		char(25) NOT NULL,
	"document_line" 		smallint NOT NULL,
	"sort_line"     		smallint NULL,
	"line_type"     		char(2) NULL,
	"item"  			char(50) NULL,
	"item_description"      	varchar(max) NULL,
	"sales_analysis"        	char(25) NULL,
	"ledger_account_code"   	char(50) NULL,
	"tax_1" 			char(25) NULL,
	"tax_2" 			char(25) NULL,
	"quantity"      		numeric(18,6) NULL,
	"pricing_uom"   		char(25) NULL,
	"item_price"    		numeric(18,6) NULL,
	"extended_amount"       	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"selling_uom"   		char(25) NULL,
	"sales_analysis_uom"    	char(25) NULL,
	"selling_to_price_conv" 	numeric(18,5) NULL,
	"selling_to_sa_conv"    	numeric(18,5) NULL,
	"total_cost"    		numeric(18,6) NULL,
	"shipper"       		varchar(25) NULL,
	"shipper_line"  		smallint NULL,
	"invoice_line_comment"  	text NULL,
	"sales_agent_percent"   	numeric(18,6) NULL,
	"account_manager_percent"       numeric(18,6) NULL,
	"country_of_origin"     	varchar(25) NULL,
	"sales_order"   		varchar(25) NULL,
	"so_line"       		smallint NULL,
	"customer_item" 		varchar(50) NULL,
	"discount_eligible"     	char(1) NULL,
	PRIMARY KEY ("document_type", "document", "document_line")
)
go
CREATE TABLE dbo."collection_agents"
(
	"collection_agent"      	char(25) NOT NULL,
	"collection_agent_description"  char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("collection_agent")
)
go
CREATE TABLE dbo."customer_classes"
(
	"customer_class"        	char(25) NOT NULL,
	"customer_class_description"    char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("customer_class")
)
go
CREATE TABLE dbo."item_preferences"
(
	"item"  			char(50) NOT NULL,
	"description"   		varchar(max) NULL,
	"pricing_uom"   		char(25) NULL,
	"sales_analysis"        	char(25) NULL,
	"ledger"        		char(40) NULL,
	"ledger_account"        	char(50) NULL,
	"contract_id"   		char(25) NULL,
	"contract_account_id"   	char(25) NULL,
	"costrevenue_type_id"   	char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"selling_uom"   		char(25) NULL,
	"sales_analysis_uom"    	char(25) NULL,
	"selling_to_price_conv" 	numeric(18,5) NULL,
	"selling_to_sa_conv"    	numeric(18,5) NULL,
	PRIMARY KEY ("item")
)
go
CREATE TABLE dbo."item_price_groups"
(
	"item"  			char(50) NOT NULL,
	"price_group"   		char(25) NOT NULL,
	"min_quantity"  		numeric(18,6) NOT NULL,
	"max_quantity"  		numeric(18,6) NULL,
	"price" 			numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"sales_agent_percent"   	numeric(18,6) NULL,
	"account_manager_percent"       numeric(18,6) NULL,
	"customer_item" 		varchar(50) NULL,
	PRIMARY KEY ("item", "price_group", "min_quantity")
)
go
CREATE TABLE dbo."remit_to_identifiers"
(
	"remit_to"      		varchar(50) NOT NULL,
	"address_id"    		char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("remit_to")
)
go
CREATE TABLE dbo."sales_analyses"
(
	"sales_analysis"        	char(25) NOT NULL,
	"sales_analysis_description"    char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("sales_analysis")
)
go
CREATE TABLE dbo."standard_clauses"
(
	"standard_clause"       	char(25) NOT NULL,
	"comments"      		varchar(max) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("standard_clause")
)
go
CREATE TABLE dbo."units_receivables"
(
	"unit"  			char(25) NOT NULL,
	"name"  			char(40) NULL,
	"ledger"        		char(40) NULL,
	"status"        		char(1) NULL,
	"gl_entry_frequency"    	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"company"       		char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("unit")
)
go
CREATE TABLE dbo."commodities"
(
	"commodity"     		char(25) NOT NULL,
	"commodity_description" 	char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("commodity")
)
go
CREATE TABLE dbo."items"
(
	"item"  			char(50) NOT NULL,
	"item_description"      	varchar(max) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"commodity"     		char(25) NULL,
	"standard_uom"  		varchar(25) NULL,
	"sales_selling_uom_to_standard" numeric(18,6) NULL,
	"sales_price_uom_to_standard"   numeric(18,6) NULL,
	"item_type"     		varchar(25) NULL,
	"sales_pricing_uom"     	varchar(25) NULL,
	"sales_selling_uom"     	varchar(25) NULL,
	"sales_analysis"        	varchar(25) NULL,
	"sales_ledger_account"  	varchar(50) NULL,
	"sales_cost_account"    	varchar(50) NULL,
	"ledger"        		varchar(40) NULL,
	"purchased"     		char(1) NULL,
	"sold"  			char(1) NULL,
	"inventoried"   		char(1) NULL,
	"security_company"      	varchar(25) NULL,
	"fulfillment"   		char(1) NULL,
	"package_length"        	numeric(18,6) NULL,
	"package_height"        	numeric(18,6) NULL,
	"package_width" 		numeric(18,6) NULL,
	"package_gross_weight"  	numeric(18,6) NULL,
	"package_net_weight"    	numeric(18,6) NULL,
	"package_weight_uom"    	varchar(25) NULL,
	"package_uom"   		varchar(25) NULL,
	"package_dimensions_uom"        varchar(25) NULL,
	"package_uom_to_standard"       numeric(18,6) NULL,
	"discount_eligible"     	char(1) NULL,
	"container_uom" 		varchar(25) NULL,
	"container_uom_to_package"      numeric(18,6) NULL,
	"pos_group"     		varchar(25) NULL,
	"pos_description"       	varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	"package_label_name"    	varchar(25) NULL,
	"container_label_name"  	varchar(25) NULL,
	"status"        		char(1) NULL,
	PRIMARY KEY ("item")
)
go
CREATE TABLE dbo."po_headers"
(
	"purchase_order"        	char(25) NOT NULL,
	"buy_vendor"    		char(25) NOT NULL,
	"buy_unit"      		char(25) NULL,
	"pay_vendor"    		char(25) NULL,
	"pay_unit"      		char(25) NULL,
	"buyer" 			char(25) NULL,
	"batch" 			char(25) NULL,
	"entered_datetime"      	datetime NULL,
	"po_type"       		char(25) NULL,
	"po_date"       		datetime NULL,
	"status"        		char(1) NULL,
	"status_reason" 		char(1) NULL,
	"requester"     		char(25) NULL,
	"confirmed_by"  		char(25) NULL,
	"confirmed_date"        	datetime NULL,
	"approved"      		char(1) NULL,
	"printed"       		char(1) NULL,
	"approve_freight"       	char(1) NULL,
	"pay_on_receipt"        	char(1) NULL,
	"expense_on_receipt"    	char(1) NULL,
	"fob"   			char(1) NULL,
	"terms" 			char(25) NULL,
	"freight_terms" 		char(25) NULL,
	"location"      		char(25) NULL,
	"currency"      		char(25) NULL,
	"document_comments"     	varchar(max) NULL,
	"amount"        		numeric(18,6) NULL,
	"tax_amount"    		numeric(18,6) NULL,
	"freight_amount"        	numeric(18,6) NULL,
	"fiscal_year"   		char(5) NULL,
	"ledger"        		char(40) NULL,
	"gl_entry"      		char(25) NULL,
	"period"        		smallint NULL,
	"gl_date"       		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"document_class"        	char(25) NULL,
	"approve_tax"   		char(1) NULL,
	"approver"      		char(25) NULL,
	"commit_to_gl"  		char(1) NULL,
	"buy_contact"   		char(50) NULL,
	"pay_contact"   		char(50) NULL,
	"invoice_approver"      	char(25) NULL,
	"sales_order"   		varchar(25) NULL,
	"sales_terms"   		varchar(25) NULL,
	"sales_terms_location"  	varchar(25) NULL,
	"blanket"       		char(1) NULL,
	"document_source"       	varchar(25) NULL,
	"po_comments_standard_clause"   varchar(25) NULL,
	PRIMARY KEY ("purchase_order")
)
go
CREATE TABLE dbo."po_items"
(
	"purchase_order"        	char(25) NOT NULL,
	"po_line"       		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"line_type"     		char(2) NULL,
	"item"  			char(50) NULL,
	"item_description"      	varchar(max) NULL,
	"vendors_item"  		char(50) NULL,
	"status"        		char(1) NULL,
	"status_reason" 		char(1) NULL,
	"receiver"      		char(1) NULL,
	"invoice"       		char(1) NULL,
	"print_po_receiver"     	char(1) NULL,
	"tax_1" 			char(25) NULL,
	"tax_2" 			char(25) NULL,
	"freight_carrier"       	char(25) NULL,
	"expense_analysis"      	char(25) NULL,
	"ledger_account_code"   	char(50) NULL,
	"variance_ledger_account"       char(50) NULL,
	"encumber_ledger_account_code"  char(50) NULL,
	"requested_by"  		char(25) NULL,
	"quantity_ordered"      	numeric(18,6) NULL,
	"quantity_received"     	numeric(18,6) NULL,
	"quantity_invoiced"     	numeric(18,6) NULL,
	"quantity_cancelled"    	numeric(18,6) NULL,
	"quantity_tolerance"    	numeric(18,6) NULL,
	"purchasing_uom"        	char(25) NULL,
	"po_pricing_uom"        	char(25) NULL,
	"purchasing_to_po_pricing_conv" numeric(18,6) NULL,
	"price" 			numeric(18,6) NULL,
	"receiver_price"        	numeric(18,6) NULL,
	"price_tolerance"       	numeric(18,6) NULL,
	"extended_amount"       	numeric(18,6) NULL,
	"invoiced_amount"       	numeric(18,6) NULL,
	"cancelled_amount"      	numeric(18,6) NULL,
	"required_date" 		datetime NULL,
	"ship_date"     		datetime NULL,
	"eta_date"      		datetime NULL,
	"last_expedite_date"    	datetime NULL,
	"closed_date"   		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"inventoried"   		char(1) NULL,
	"po_quantity_uom_to_standard"   numeric(18,6) NULL,
	"sales_order"   		varchar(25) NULL,
	"so_line"       		smallint NULL,
	"po_release"    		varchar(25) NULL,
	"blanket_line"  		smallint NULL,
	"amleadsrcid"   		integer NULL,
	"package_uom"   		varchar(25) NULL,
	"package_uom_to_purchasing"     numeric(18,6) NULL,
	"sycampusid"    		integer NULL,
	"package_label_name"    	varchar(25) NULL,
	PRIMARY KEY ("purchase_order", "po_line")
)
go
CREATE TABLE dbo."po_receivers"
(
	"purchase_order"        	char(25) NOT NULL,
	"bill_of_lading"        	char(25) NOT NULL,
	"location"      		char(25) NULL,
	"clerk" 			char(25) NULL,
	"freight_carrier"       	char(25) NULL,
	"ledger_account_code"   	char(50) NULL,
	"fiscal_year"   		char(5) NULL,
	"ledger"        		char(40) NULL,
	"gl_entry"      		char(25) NULL,
	"period"        		smallint NULL,
	"gl_date"       		datetime NULL,
	"received_date" 		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"document_source"       	varchar(25) NULL,
	PRIMARY KEY ("purchase_order", "bill_of_lading")
)
go
CREATE TABLE dbo."po_receiver_items"
(
	"purchase_order"        	char(25) NOT NULL,
	"bill_of_lading"        	char(25) NOT NULL,
	"bol_line"      		smallint NOT NULL,
	"receiver"      		char(25) NOT NULL,
	"invoice"       		char(25) NULL,
	"inv_line"      		smallint NULL,
	"item"  			char(50) NULL,
	"approved"      		char(1) NULL,
	"receiver_comments"     	varchar(max) NULL,
	"ledger_account_code"   	char(50) NULL,
	"quantity_received"     	numeric(18,6) NULL,
	"unit_cost"     		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"total_cost"    		numeric(18,6) NULL,
	"po_line"       		smallint NULL,
	"freight_cost"  		numeric(18,6) NULL,
	"other_cost"    		numeric(18,6) NULL,
	"container_id"  		varchar(25) NULL,
	"package"       		varchar(25) NULL,
	"country_of_origin"     	varchar(25) NULL,
	PRIMARY KEY ("purchase_order", "bill_of_lading", "bol_line", "receiver")
)
go
CREATE TABLE dbo."vendor_items"
(
	"vendor"        		char(50) NOT NULL,
	"item"  			char(25) NOT NULL,
	"vendors_item"  		char(50) NULL,
	"po_contract"   		char(25) NULL,
	"rating"        		char(5) NULL,
	"received"      		char(1) NULL,
	"invoice_method"        	char(1) NULL,
	"buyer" 			char(25) NULL,
	"purchasing_uom"        	char(25) NULL,
	"po_pricing_uom"        	char(25) NULL,
	"purchasing_to_po_pricing_conv" numeric(18,6) NULL,
	"receiver_tol_units"    	numeric(18,6) NULL,
	"receiver_tol_percent"  	numeric(5,2) NULL,
	"price_tol_dollars"     	numeric(18,6) NULL,
	"price_tol_percent"     	numeric(5,2) NULL,
	"shipping_quantity"     	numeric(18,6) NULL,
	"taxable_1"     		char(1) NULL,
	"taxable_2"     		char(1) NULL,
	"last_purchase_order"   	char(25) NULL,
	"last_po_date"  		datetime NULL,
	"last_po_quantity"      	numeric(18,6) NULL,
	"last_po_price" 		numeric(18,6) NULL,
	"last_po_lead_time"     	smallint NULL,
	"avg_po_lead_time"      	smallint NULL,
	"number_of_orders"      	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"expense_ledger_account"        char(50) NULL,
	"price" 			numeric(18,6) NULL,
	"number_of_receipts"    	smallint NULL,
	"ledger"        		char(40) NULL,
	"po_quantity_uom_to_standard"   numeric(18,6) NULL,
	"po_price_uom_to_standard"      numeric(18,6) NULL,
	"expense_analysis"      	char(25) NULL,
	"primary_vendor"        	char(1) NULL,
	"required_days" 		smallint NULL,
	"gross_price"   		numeric(18,6) NULL,
	"discount"      		numeric(18,6) NULL,
	"package_uom"   		varchar(25) NULL,
	"package_uom_to_purchasing"     numeric(18,6) NULL,
	"label_name"    		varchar(25) NULL,
	PRIMARY KEY ("vendor", "item")
)
go
CREATE TABLE dbo."approver_notes"
(
	"document_type" 		char(25) NOT NULL,
	"document_id1"  		char(25) NOT NULL,
	"document_id2"  		char(25) NOT NULL,
	"document_id3"  		char(25) NOT NULL,
	"approver"      		char(25) NOT NULL,
	"note_date"     		datetime NOT NULL,
	"approver_notes"        	varchar(max) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("document_type", "document_id1", "document_id2", "document_id3", "approver", "note_date")
)
go
CREATE TABLE dbo."cost_accounts"
(
	"cost_account"  		char(25) NOT NULL,
	"cost_account_description"      char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"budget"        		numeric(18,6) NULL,
	"cost_id"       		varchar(25) NULL,
	"account"       		varchar(25) NULL,
	"cost_sub"      		varchar(25) NULL,
	"coa"   			varchar(40) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("cost_account")
)
go
CREATE TABLE dbo."cash_flow_lines"
(
	"cash_flow_section"     	char(25) NOT NULL,
	"cash_flow_line"        	smallint NOT NULL,
	"cash_flow_line_description"    char(50) NOT NULL,
	"reverse_sign"  		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("cash_flow_section", "cash_flow_line")
)
go
CREATE TABLE dbo."cash_flow_sections"
(
	"cash_flow_section"     	char(25) NOT NULL,
	"cash_flow_section_description" char(50) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("cash_flow_section")
)
go
CREATE TABLE dbo."req_headers"
(
	"requisition"   		char(25) NOT NULL,
	"requester"     		char(25) NULL,
	"batch" 			char(25) NULL,
	"document_class"        	char(25) NULL,
	"requisition_date"      	datetime NULL,
	"buy_unit"      		char(25) NULL,
	"fiscal_year"   		char(5) NULL,
	"ledger"        		char(40) NULL,
	"gl_date"       		datetime NULL,
	"period"        		integer NULL,
	"gl_entry"      		char(25) NULL,
	"printed"       		char(1) NULL,
	"currency"      		char(25) NULL,
	"status"        		char(1) NULL,
	"amount"        		numeric(18,6) NULL,
	"tax_amount"    		numeric(18,6) NULL,
	"freight_amount"        	numeric(18,6) NULL,
	"document_comments"     	varchar(max) NULL,
	"print_comments_on_po"  	char(1) NULL,
	"entered_datetime"      	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"email_notification"    	char(1) NULL,
	"receipt_email_notification"    char(1) NULL,
	"document_source"       	varchar(25) NULL,
	"requisition_reason"    	text NULL,
	"po_comments_standard_clause"   varchar(25) NULL,
	PRIMARY KEY ("requisition")
)
go
CREATE TABLE dbo."req_items"
(
	"requisition"   		char(25) NOT NULL,
	"req_line"      		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"line_type"     		char(2) NULL,
	"item"  			char(25) NULL,
	"item_description"      	varchar(max) NULL,
	"vendors_item"  		char(50) NULL,
	"tax_1" 			char(25) NULL,
	"tax_2" 			char(25) NULL,
	"freight_carrier"       	char(25) NULL,
	"expense_analysis"      	char(25) NULL,
	"ledger_account_code"   	char(50) NULL,
	"variance_ledger_account"       char(50) NULL,
	"status"        		char(1) NULL,
	"purchase_order"        	char(25) NULL,
	"po_line"       		integer NULL,
	"quantity_ordered"      	numeric(18,6) NULL,
	"quantity_tolerance"    	numeric(18,6) NULL,
	"purchasing_uom"        	char(25) NULL,
	"po_pricing_uom"        	char(25) NULL,
	"purchasing_to_po_pricing_conv" numeric(18,6) NULL,
	"price" 			numeric(18,6) NULL,
	"price_tolerance"       	numeric(18,6) NULL,
	"extended_amount"       	numeric(18,6) NULL,
	"required_date" 		datetime NULL,
	"shipping_date" 		datetime NULL,
	"eta_date"      		datetime NULL,
	"location"      		char(25) NULL,
	"buy_vendor"    		char(25) NULL,
	"pay_unit"      		char(25) NULL,
	"buyer" 			char(25) NULL,
	"po_type"       		char(25) NULL,
	"invoice_approver"      	char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"amleadsrcid"   		integer NULL,
	"package_uom"   		varchar(25) NULL,
	"package_uom_to_purchasing"     numeric(18,6) NULL,
	"sycampusid"    		integer NULL,
	PRIMARY KEY ("requisition", "req_line")
)
go
CREATE TABLE dbo."signature_list_accounts"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"signature_list"        	char(50) NOT NULL,
	"organization_level"    	char(25) NOT NULL,
	"beginning_organization"        char(25) NOT NULL,
	"ending_organization"   	char(25) NOT NULL,
	"beginning_account"     	char(25) NOT NULL,
	"ending_account"        	char(25) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "signature_list", "organization_level", "beginning_organization", "ending_organization", "beginning_account", "ending_account")
)
go
CREATE TABLE dbo."signature_lists"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"signature_list"        	char(50) NOT NULL,
	"approver"      		char(25) NOT NULL,
	"priority"      		char(25) NULL,
	"breakpoint"    		integer NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"approver_sequence"     	integer NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "signature_list", "approver")
)
go
CREATE TABLE dbo."backflush_log"
(
	"id"    			varchar(255) NULL,
	"val"   			integer NULL
)
go
CREATE TABLE dbo."log"
(
	"spid"  			integer NOT NULL,
	"id"    			integer NOT NULL,
	"message"       		varchar(255) NOT NULL,
	PRIMARY KEY ("spid", "id")
)
go
CREATE TABLE dbo."delfor_cytd"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"cum_qty_code"  		varchar(35) NULL,
	"cum_qty"       		varchar(35) NULL,
	"cum_date_code" 		varchar(35) NULL,
	"cum_date"      		varchar(35) NULL,
	"last_shipper_number"   	varchar(35) NULL,
	"last_ship_date_code"   	varchar(35) NULL,
	"last_ship_date"        	varchar(35) NULL
)
go
CREATE TABLE dbo."delfor_releases"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"item1" 			varchar(35) NULL,
	"item_type1"    		varchar(35) NULL,
	"item2" 			varchar(35) NULL,
	"item_type2"    		varchar(35) NULL,
	"item3" 			varchar(35) NULL,
	"item_type3"    		varchar(35) NULL,
	"item4" 			varchar(35) NULL,
	"item_type4"    		varchar(35) NULL,
	"item5" 			varchar(35) NULL,
	"item_type5"    		varchar(35) NULL,
	"ref_qual"      		varchar(35) NULL,
	"ref_no"        		varchar(35) NULL,
	"forecast_type" 		varchar(35) NULL,
	"quantity"      		varchar(35) NULL,
	"start_date"    		varchar(35) NULL
)
go
CREATE TABLE dbo."deljit_oh"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"model_year"    		varchar(35) NULL,
	"ecl"   			varchar(35) NULL,
	"dock_code"     		varchar(35) NULL,
	"line_feed_code"        	varchar(35) NULL
)
go
CREATE TABLE dbo."deljit_cytd"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"model_year"    		varchar(35) NULL,
	"prev_cum_qty"  		varchar(35) NULL,
	"prev_cum_uom"  		varchar(35) NULL,
	"prev_cum_start_date"   	varchar(35) NULL,
	"prev_cum_end_date"     	varchar(35) NULL,
	"cytd_ship_qty" 		varchar(35) NULL,
	"cytd_uom"      		varchar(35) NULL,
	"cytd_start_date"       	varchar(35) NULL,
	"despatch_date" 		varchar(35) NULL,
	"last_shipper"  		varchar(35) NULL
)
go
CREATE TABLE dbo."order_validation"
(
	"releases"      		varchar(255) NULL
)
go
CREATE TABLE dbo."gm_pilot_releases"
(
	"customer_part" 		varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"customer_po"   		varchar(35) NULL,
	"model_year"    		varchar(35) NULL,
	"release_no"    		varchar(35) NULL,
	"quantity"      		varchar(35) NULL,
	"release_date"  		varchar(35) NULL
)
go
CREATE TABLE dbo."delfor_oh"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"item1" 			varchar(35) NULL,
	"item_type1"    		varchar(35) NULL,
	"item2" 			varchar(35) NULL,
	"item_type2"    		varchar(35) NULL,
	"item3" 			varchar(35) NULL,
	"item_type3"    		varchar(35) NULL,
	"item4" 			varchar(35) NULL,
	"item_type4"    		varchar(35) NULL,
	"item5" 			varchar(35) NULL,
	"item_type5"    		varchar(35) NULL,
	"dock_code1"    		varchar(35) NULL,
	"dock_code2"    		varchar(35) NULL,
	"loc_qual"      		varchar(35) NULL,
	"loc"   			varchar(35) NULL,
	"ecl"   			varchar(35) NULL
)
go
CREATE TABLE dbo."deljit_releases"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"model_year"    		varchar(35) NULL,
	"quantity"      		varchar(35) NULL,
	"date_time"     		varchar(35) NULL
)
go
CREATE TABLE dbo."sat_deljit_releases"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"po_number"     		varchar(35) NULL,
	"quantity"      		varchar(35) NULL,
	"ship_date"     		varchar(35) NULL
)
go
CREATE TABLE dbo."sat_deljit_oh"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"po_number"     		varchar(35) NULL,
	"dock_code"     		varchar(35) NULL,
	"std_pack_qty"  		varchar(35) NULL
)
go
CREATE TABLE dbo."sat_deljit_kanban"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"po_number"     		varchar(35) NULL,
	"zone_code"     		varchar(35) NULL,
	"custom01"      		varchar(35) NULL,
	"line11"        		varchar(35) NULL,
	"line_feed"     		varchar(35) NULL,
	"line12"        		varchar(35) NULL,
	"custom02"      		varchar(35) NULL,
	"custom03"      		varchar(35) NULL,
	"std_pack_qty"  		varchar(35) NULL,
	"begin_kanban"  		varchar(35) NULL,
	"end_kanban"    		varchar(35) NULL
)
go
CREATE TABLE dbo."sat_delfor_releases"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"model_year"    		varchar(35) NULL,
	"quantity"      		varchar(35) NULL,
	"start_date"    		varchar(35) NULL
)
go
CREATE TABLE dbo."deljit_kanban"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"model_year"    		varchar(35) NULL,
	"line11"        		varchar(35) NULL,
	"line12"        		varchar(35) NULL,
	"line13"        		varchar(35) NULL,
	"line14"        		varchar(35) NULL,
	"line15"        		varchar(35) NULL,
	"line16"        		varchar(35) NULL,
	"line17"        		varchar(35) NULL
)
go
CREATE TABLE dbo."xreport_datasource"
(
	"datasource_name"       	varchar(8) NOT NULL,
	"description"   		varchar(50) NOT NULL,
	"library_name"  		varchar(50) NULL,
	"dw_name"       		varchar(50) NOT NULL,
	PRIMARY KEY ("datasource_name")
)
go
CREATE TABLE dbo."xreport_library"
(
	"name"  			varchar(25) NOT NULL,
	"report"        		varchar(25) NOT NULL,
	"datasource"    		varchar(8) NOT NULL,
	"xlabelformat"  		varchar(50) NOT NULL,
	PRIMARY KEY ("name", "report")
)
go
CREATE TABLE dbo."Generic_830_fab_raw"
(
	"release_number"        	varchar(30) NULL,
	"supplier_code" 		varchar(7) NULL,
	"customer_part" 		varchar(30) NULL,
	"po"    			varchar(30) NULL,
	"ecl"   			varchar(30) NULL,
	"ship_to"       		varchar(7) NULL,
	"cum_type"      		varchar(2) NULL,
	"cum_date"      		varchar(6) NULL,
	"quantity"      		varchar(10) NULL
)
go
CREATE TABLE dbo."generic_schedule"
(
	"reference_number"      	varchar(50) NULL,
	"supplier_code" 		varchar(50) NULL,
	"ship_to"       		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"dock_code"     		varchar(25) NULL,
	"line_feed"     		varchar(25) NULL,
	"zone_code"     		varchar(25) NULL,
	"quantity"      		varchar(15) NULL,
	"ran_number"    		varchar(7) NULL,
	"delivery_date" 		varchar(12) NULL,
	"routing_code"  		varchar(35) NULL
)
go
CREATE TABLE dbo."m_Generic830_release_date"
(
	"process_date"  		datetime NULL DEFAULT getdate(),
	"release_number"        	varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"po_number"     		varchar(50) NULL,
	"ship_to"       		varchar(50) NULL,
	"transaction_type"      	varchar(1) NULL
)
go
CREATE TABLE dbo."m_Generic830_po"
(
	"release_number"        	varchar(50) NULL,
	"supplier_code" 		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"po_number"     		varchar(50) NULL,
	"ecl"   			varchar(50) NULL,
	"ship_to"       		varchar(50) NULL
)
go
CREATE TABLE dbo."Generic_830_last_ship"
(
	"release_number"        	varchar(50) NULL,
	"supplier_code" 		varchar(30) NULL,
	"customer_part" 		varchar(35) NULL,
	"customer_po"   		varchar(50) NULL,
	"ecl"   			varchar(35) NULL,
	"ship_to"       		varchar(20) NULL,
	"line_feed"     		varchar(25) NULL,
	"drop_point"    		varchar(25) NULL,
	"qty_type"      		varchar(3) NULL,
	"quantity"      		varchar(15) NULL,
	"date_type"     		varchar(3) NULL,
	"delivery_date" 		varchar(35) NULL,
	"last_ship_day" 		varchar(35) NULL
)
go
CREATE TABLE dbo."Generic_830_notes"
(
	"release_number"        	varchar(50) NULL,
	"release_date"  		varchar(35) NULL,
	"note"  			varchar(255) NULL
)
go
CREATE TABLE dbo."Generic_830_releases"
(
	"release_number"        	varchar(50) NULL,
	"supplier_code" 		varchar(30) NULL,
	"customer_part" 		varchar(35) NULL,
	"po_number"     		varchar(50) NULL,
	"ecl"   			varchar(35) NULL,
	"ship_to"       		varchar(35) NULL,
	"line_feed"     		varchar(25) NULL,
	"drop_point"    		varchar(25) NULL,
	"quantity"      		varchar(20) NULL,
	"ship_del_pattern1"     	varchar(3) NULL,
	"ship_del_pattern2"     	varchar(3) NULL,
	"forcast_type"  		varchar(3) NULL,
	"forcast_timing_type"   	varchar(3) NULL,
	"delivery_date" 		varchar(35) NULL
)
go
CREATE TABLE dbo."generic_862_linefeed"
(
	"reference_number"      	varchar(50) NULL,
	"supplier_code" 		varchar(50) NULL,
	"ship_to"       		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"dock_code"     		varchar(50) NULL,
	"line_feed"     		varchar(50) NULL,
	"zone_code"     		varchar(50) NULL
)
go
CREATE TABLE dbo."edi_generic_cums"
(
	"destination"   		char(50) NULL,
	"customer_part" 		char(50) NULL,
	"the_cum"       		char(50) NULL,
	"our_cum"       		char(50) NULL
)
go
CREATE TABLE dbo."m_generic830_auth_cum"
(
	"ship_to"       		char(25) NULL,
	"customer_part" 		varchar(30) NULL,
	"auth_type"     		char(3) NULL,
	"generic_cum"   		varchar(15) NULL,
	"qty_type"      		char(3) NULL,
	"qytd"  			varchar(15) NULL
)
go
CREATE TABLE dbo."m_in_release_plan_ch"
(
	"customer_part" 		varchar(35) NOT NULL,
	"shipto_id"     		varchar(20) NOT NULL,
	"customer_po"   		varchar(20) NULL,
	"model_year"    		varchar(4) NULL,
	"release_no"    		varchar(30) NOT NULL,
	"quantity_qualifier"    	char(1) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"release_dt_qualifier"  	char(1) NOT NULL,
	"release_dt"    		datetime NOT NULL
)
go
CREATE TABLE dbo."freight_type_definition"
(
	"type_name"     		varchar(20) NOT NULL,
	PRIMARY KEY ("type_name")
)
go
CREATE TABLE dbo."ap_recurring_invoices"
(
	"vendor"        		char(25) NOT NULL,
	"invoice"       		char(25) NOT NULL,
	"frequency"     		char(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("vendor", "invoice")
)
go
CREATE TABLE dbo."doc_approvers"
(
	"document_type" 		char(25) NOT NULL,
	"document_id1"  		char(25) NOT NULL,
	"document_id2"  		char(25) NOT NULL,
	"document_id3"  		char(25) NOT NULL,
	"approval_sequence"     	smallint NOT NULL,
	"approver"      		char(25) NULL,
	"breakpoint"    		integer NULL,
	"priority"      		char(25) NULL,
	"approved_by"   		char(25) NULL,
	"approved_date" 		datetime NULL,
	"approved"      		char(25) NULL,
	"next_to_approve"       	char(1) NULL,
	"approver_comment"      	varchar(max) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("document_type", "document_id1", "document_id2", "document_id3", "approval_sequence")
)
go
CREATE TABLE dbo."budget_headers"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"organization_level"    	char(40) NOT NULL,
	"organization"  		char(40) NOT NULL,
	"budget_amount" 		numeric(18,6) NULL,
	"approved"      		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"date_submitted"        	datetime NULL,
	"balance_name"  		varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "organization_level", "organization")
)
go
CREATE TABLE dbo."ar_delinquent_customers"
(
	"collection_agent"      	char(25) NOT NULL,
	"customer"      		char(25) NOT NULL,
	"as_of_date"    		datetime NULL,
	"delinquent_amount"     	numeric(18,6) NULL,
	"number_of_invoices"    	integer NULL,
	"max_past_due_days"     	integer NULL,
	"ave_past_due_days"     	integer NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("collection_agent", "customer")
)
go
CREATE TABLE dbo."fd5_830_releases"
(
	"ship_to"       		varchar(5) NULL,
	"customer_part" 		varchar(30) NULL,
	"customer_po"   		varchar(30) NULL,
	"ecl"   			varchar(30) NULL,
	"cum_qty"       		varchar(30) NULL,
	"date_indicator"        	varchar(30) NULL,
	"date1" 			varchar(30) NULL,
	"date2" 			varchar(30) NULL,
	"delivery_time" 		varchar(30) NULL,
	"release_number"        	varchar(30) NULL
)
go
CREATE TABLE dbo."fd5_830_fab_raw"
(
	"fab_date"      		varchar(10) NULL,
	"fab_cum"       		varchar(15) NULL,
	"fab_start_date"        	varchar(10) NULL,
	"raw_date"      		varchar(10) NULL,
	"raw_cum"       		varchar(15) NULL,
	"raw_start_date"        	varchar(10) NULL,
	"ship_to"       		varchar(30) NULL,
	"customer_part" 		varchar(30) NULL,
	"customer_po"   		varchar(30) NULL,
	"ecl"   			varchar(30) NULL
)
go
CREATE TABLE dbo."fd5_830_oh_data"
(
	"ship_to"       		varchar(20) NULL,
	"buyer" 			varchar(5) NULL,
	"bill_to"       		varchar(5) NULL,
	"consignee"     		varchar(5) NULL,
	"ford_part"     		varchar(30) NULL,
	"ford_po"       		varchar(30) NULL,
	"ecl"   			varchar(30) NULL,
	"euro_fin_code" 		varchar(30) NULL,
	"issue_date"    		datetime NULL,
	"effective_date"        	datetime NULL,
	"customer_order_no"     	varchar(16) NULL,
	"part_status"   		varchar(2) NULL,
	"expeditor"     		varchar(35) NULL,
	"exp_phone"     		varchar(21) NULL,
	"plant_dock"    		varchar(35) NULL,
	"plant_dock_phone"      	varchar(21) NULL,
	"note"  			varchar(60) NULL
)
go
CREATE TABLE dbo."ford862_container"
(
	"ship_to"       		varchar(50) NULL,
	"ship_from"     		varchar(50) NULL,
	"consignee"     		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"std_pack"      		varchar(50) NULL,
	"weight_per_thousand"   	varchar(50) NULL,
	"container"     		varchar(50) NULL
)
go
CREATE TABLE dbo."fd5_862_cytd"
(
	"ship_to"       		varchar(5) NULL,
	"customer_part" 		varchar(30) NULL,
	"po_number"     		varchar(30) NULL,
	"cytd_qty"      		varchar(30) NULL
)
go
CREATE TABLE dbo."m_ford830_consignee"
(
	"ship_to"       		varchar(50) NULL,
	"consignee"     		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"customer_po"   		varchar(50) NULL
)
go
CREATE TABLE dbo."fd5_830_cytd"
(
	"ship_to"       		varchar(20) NULL,
	"customer_part" 		varchar(30) NULL,
	"po_number"     		varchar(30) NULL,
	"cytd_qty"      		varchar(30) NULL
)
go
CREATE TABLE dbo."ford862_descrepency"
(
	"ship_to"       		varchar(50) NULL,
	"ship_from"     		varchar(50) NULL,
	"consignee"     		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"quantity_qualifier"    	varchar(50) NULL,
	"quantity"      		varchar(50) NULL,
	"last_asn_date" 		varchar(50) NULL,
	"last_shipper_id"       	varchar(50) NULL
)
go
CREATE TABLE dbo."ford862_linefeed"
(
	"ship_to"       		varchar(50) NULL,
	"ship_from"     		varchar(50) NULL,
	"consignee"     		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"pl"    			varchar(10) NULL,
	"location_type" 		varchar(50) NULL,
	"delivery_location"     	varchar(50) NULL
)
go
CREATE TABLE dbo."ford862_ship_schedule"
(
	"ship_to"       		varchar(50) NULL,
	"ship_from"     		varchar(50) NULL,
	"consignee"     		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"quantity"      		varchar(50) NULL,
	"ship_date"     		varchar(50) NULL,
	"ship_time"     		varchar(50) NULL,
	"release_number"        	varchar(30) NULL
)
go
CREATE TABLE dbo."m_ford862_release_date"
(
	"release_date"  		varchar(30) NULL,
	"release_number"        	varchar(30) NULL,
	"ship_to"       		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL
)
go
CREATE TABLE dbo."m_ford830_release_date"
(
	"release_date"  		varchar(30) NULL,
	"release_number"        	varchar(30) NULL,
	"ship_to"       		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL
)
go
CREATE TABLE dbo."m_in_forcast_plan"
(
	"customer_part" 		varchar(35) NOT NULL,
	"shipto_id"     		varchar(20) NOT NULL,
	"customer_po"   		varchar(20) NULL,
	"model_year"    		varchar(4) NULL,
	"release_no"    		varchar(30) NOT NULL,
	"quantity_qualifier"    	char(1) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"release_dt_qualifier"  	char(1) NOT NULL,
	"release_dt"    		datetime NOT NULL
)
go
CREATE TABLE dbo."order_detail_inserted"
(
	"order_no"      		numeric(8,0) NOT NULL,
	"sequence"      		numeric(5,0) NOT NULL,
	"part_number"   		varchar(25) NOT NULL,
	"type"  			char(1) NULL,
	"product_name"  		varchar(50) NULL,
	"quantity"      		numeric(20,6) NULL,
	"price" 			numeric(20,6) NULL,
	"notes" 			varchar(255) NULL,
	"assigned"      		varchar(35) NULL,
	"shipped"       		numeric(20,6) NULL,
	"invoiced"      		numeric(20,6) NULL,
	"status"        		char(1) NULL,
	"our_cum"       		numeric(20,6) NULL,
	"the_cum"       		numeric(20,6) NULL,
	"due_date"      		datetime NULL,
	"destination"   		varchar(25) NULL,
	"unit"  			varchar(2) NULL,
	"committed_qty" 		numeric(20,6) NULL,
	"row_id"        		integer NULL,
	"group_no"      		varchar(10) NULL,
	"cost"  			numeric(20,6) NULL,
	"plant" 			varchar(10) NULL,
	"release_no"    		varchar(30) NULL,
	"flag"  			integer NULL,
	"week_no"       		integer NULL,
	"std_qty"       		numeric(20,6) NULL,
	"customer_part" 		varchar(30) NULL,
	"ship_type"     		char(1) NULL,
	"dropship_po"   		integer NULL,
	"dropship_po_row_id"    	integer NULL,
	"suffix"        		integer NULL,
	"packline_qty"  		numeric(20,6) NULL,
	"packaging_type"        	varchar(20) NULL,
	"weight"        		numeric(20,6) NULL,
	"custom01"      		varchar(30) NULL,
	"custom02"      		varchar(30) NULL,
	"custom03"      		varchar(30) NULL,
	"dimension_qty_string"  	varchar(50) NULL,
	"engineering_level"     	varchar(25) NULL,
	"box_label"     		varchar(25) NULL,
	"pallet_label"  		varchar(25) NULL,
	"alternate_price"       	numeric(20,6) NULL
)
go
CREATE TABLE dbo."order_header_inserted"
(
	"order_no"      		numeric(8,0) NOT NULL,
	"order_date"    		datetime NOT NULL,
	"blanket_part"  		varchar(25) NULL,
	"model_year"    		varchar(4) NULL,
	"customer_part" 		varchar(35) NULL,
	"standard_pack" 		numeric(20,6) NULL,
	"our_cum"       		numeric(20,6) NULL,
	"the_cum"       		numeric(20,6) NULL,
	"order_type"    		char(1) NULL,
	"shipped"       		numeric(20,6) NULL,
	"shipped_date"  		datetime NULL,
	"shipper"       		integer NULL,
	"status"        		char(1) NULL,
	"unit"  			varchar(2) NULL,
	"revision"      		varchar(10) NULL,
	"customer_po"   		varchar(20) NULL,
	"blanket_qty"   		numeric(20,6) NULL,
	"salesman"      		varchar(25) NULL,
	"zone_code"     		varchar(30) NULL,
	"dock_code"     		varchar(10) NULL,
	"package_type"  		varchar(20) NULL,
	"notes" 			varchar(255) NULL,
	"shipping_unit" 		varchar(15) NULL,
	"line_feed_code"        	varchar(30) NULL,
	"fab_cum"       		numeric(15,2) NULL,
	"raw_cum"       		numeric(15,2) NULL,
	"fab_date"      		datetime NULL,
	"raw_date"      		datetime NULL,
	"begin_kanban_number"   	varchar(6) NULL,
	"end_kanban_number"     	varchar(6) NULL,
	"line11"        		varchar(21) NULL,
	"line12"        		varchar(21) NULL,
	"line13"        		varchar(21) NULL,
	"line14"        		varchar(21) NULL,
	"line15"        		varchar(21) NULL,
	"line16"        		varchar(21) NULL,
	"line17"        		varchar(21) NULL,
	"custom01"      		varchar(30) NULL,
	"custom02"      		varchar(30) NULL,
	"custom03"      		varchar(30) NULL,
	"cs_status"     		varchar(20) NULL,
	"engineering_level"     	varchar(25) NULL,
	"review_date"   		datetime NULL,
	"reviewed_by"   		varchar(25) NULL,
	PRIMARY KEY ("order_no", "order_date")
)
go
CREATE TABLE dbo."monitor_inventory_accounts"
(
	"fiscal_year"   		char(5) NOT NULL,
	"ledger"        		char(40) NOT NULL,
	"product_line"  		char(25) NOT NULL,
	"audit_trail_type"      	char(1) NOT NULL,
	"part_type"     		char(1) NOT NULL,
	"sort_line"     		integer NULL,
	"empower_interface"     	char(1) NULL,
	"material_debit"        	char(50) NULL,
	"material_credit"       	char(50) NULL,
	"material_variance"     	char(50) NULL,
	"labor_debit"   		char(50) NULL,
	"labor_credit"  		char(50) NULL,
	"burden_debit"  		char(50) NULL,
	"burden_credit" 		char(50) NULL,
	"other_debit"   		char(50) NULL,
	"other_credit"  		char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "product_line", "audit_trail_type", "part_type")
)
go
CREATE TABLE dbo."m_release_date"
(
	"process_date"  		datetime NULL DEFAULT getdate(),
	"release_number"        	varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"po_number"     		varchar(50) NULL,
	"ship_to"       		varchar(50) NULL,
	"transaction_type"      	varchar(1) NULL
)
go

CREATE TABLE dbo."m_chrysler830_po"
(
	"release_number"        	varchar(50) NULL,
	"supplier_code" 		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"po_number"     		varchar(50) NULL,
	"ecl"   			varchar(50) NULL,
	"ship_to"       		varchar(50) NULL
)
go

CREATE TABLE dbo."chrysler_830_fab_raw"
(
	"release_number"        	varchar(30) NULL,
	"supplier_code" 		varchar(7) NULL,
	"customer_part" 		varchar(30) NULL,
	"po"    			varchar(30) NULL,
	"ecl"   			varchar(30) NULL,
	"ship_to"       		varchar(7) NULL,
	"cum_type"      		varchar(2) NULL,
	"cum_date"      		varchar(6) NULL,
	"quantity"      		varchar(10) NULL
)
go

CREATE TABLE dbo."chrysler_830_last_ship"
(
	"release_number"        	varchar(8) NULL,
	"supplier_code" 		varchar(7) NULL,
	"customer_part" 		varchar(30) NULL,
	"customer_po"   		varchar(13) NULL,
	"ecl"   			varchar(30) NULL,
	"ship_to"       		varchar(7) NULL,
	"line_feed"     		varchar(8) NULL,
	"drop_point"    		varchar(8) NULL,
	"qty_type"      		varchar(2) NULL,
	"quantity"      		varchar(10) NULL,
	"date_type"     		varchar(3) NULL,
	"date"  			varchar(6) NULL,
	"last_ship_day" 		varchar(6) NULL
)
go

CREATE TABLE dbo."chrysler_830_notes"
(
	"release_number"        	varchar(10) NULL,
	"release_date"  		varchar(10) NULL,
	"note"  			varchar(70) NULL
)
go

CREATE TABLE dbo."chrysler_830_releases"
(
	"release_number"        	varchar(10) NULL,
	"supplier_code" 		varchar(7) NULL,
	"customer_part" 		varchar(30) NULL,
	"po_number"     		varchar(13) NULL,
	"ecl"   			varchar(30) NULL,
	"ship_to"       		varchar(7) NULL,
	"line_feed"     		varchar(12) NULL,
	"drop_point"    		varchar(12) NULL,
	"quantity"      		varchar(12) NULL,
	"ship_del_pattern1"     	varchar(1) NULL,
	"ship_del_pattern2"     	varchar(1) NULL,
	"forcast_type"  		varchar(1) NULL,
	"forcast_timing_type"   	varchar(1) NULL,
	"date"  			varchar(6) NULL
)
go

CREATE TABLE dbo."chrysler_862_linefeed"
(
	"reference_number"      	varchar(50) NULL,
	"supplier_code" 		varchar(50) NULL,
	"ship_to"       		varchar(50) NULL,
	"customer_part" 		varchar(50) NULL,
	"dock_code"     		varchar(50) NULL,
	"line_feed"     		varchar(50) NULL,
	"zone_code"     		varchar(50) NULL
)
go

CREATE TABLE dbo."chrysler_862_schedule"
(
	"reference_number"      	varchar(9) NULL,
	"supplier_code" 		varchar(7) NULL,
	"ship_to"       		varchar(7) NULL,
	"customer_part" 		varchar(10) NULL,
	"dock_code"     		varchar(8) NULL,
	"line_feed"     		varchar(8) NULL,
	"zone_code"     		varchar(8) NULL,
	"quantity"      		varchar(10) NULL,
	"date"  			varchar(6) NULL,
	"ran_number"    		varchar(7) NULL,
	"delivery_date" 		varchar(6) NULL,
	"routing_code"  		varchar(35) NULL
)
go

CREATE TABLE dbo."edi_ch1862_cums"
(
	"destination"   		char(7) NULL,
	"customer_part" 		char(10) NULL,
	"the_cum"       		char(10) NULL,
	"our_cum"       		char(10) NULL
)
go
GRANT SELECT, INSERT, DELETE, UPDATE, ALTER, REFERENCES ON dbo."edi_ch1862_cums" TO "PUBLIC" WITH GRANT OPTION
go
CREATE TABLE dbo."edi_ch1830_cums"
(
	"model_year"    		char(1) NULL,
	"destination"   		char(7) NULL,
	"customer_part" 		char(10) NULL,
	"the_cum"       		char(9) NULL,
	"our_cum"       		char(9) NULL
)
go

CREATE TABLE dbo."m_chrysler830_auth_cum"
(
	"release_no"    		varchar(30) NULL,
	"ship_to"       		char(7) NULL,
	"customer_part" 		varchar(30) NULL,
	"auth_type"     		char(2) NULL,
	"chrysler_cum"  		varchar(10) NULL,
	"qty_type"      		char(2) NULL,
	"qytd"  			varchar(10) NULL
)
go

CREATE TABLE dbo."deljit_releases_jci"
(
	"release_number"        	varchar(35) NULL,
	"ship_to_id"    		varchar(35) NULL,
	"buyer_part"    		varchar(35) NULL,
	"item_type"     		varchar(35) NULL,
	"additional_item"       	varchar(35) NULL,
	"quantity_type" 		varchar(35) NULL,
	"quantity"      		varchar(35) NULL,
	"date_type"     		varchar(35) NULL,
	"ship_date"     		varchar(35) NULL,
	"desadv_no"     		varchar(35) NULL
)
go
CREATE TABLE dbo."cdipohistory"
(
	"id"    			integer NOT NULL IDENTITY(1, 1),
	"po_number"     		integer NULL,
	"vendor"        		varchar(10) NULL,
	"part"  			varchar(25) NULL,
	"uom"   			varchar(2) NULL,
	"date_due"      		datetime NULL,
	"type"  			varchar(1) NULL,
	"last_recvd_date"       	datetime NULL,
	"last_recvd_amount"     	numeric(20,6) NULL,
	"quantity"      		numeric(20,6) NULL,
	"received"      		numeric(20,6) NULL,
	"balance"       		numeric(20,6) NULL,
	"price" 			numeric(20,6) NULL,
	"row_id"        		integer NULL,
	"release_no"    		integer NULL,
	"raccuracy"     		char(1) NULL DEFAULT 'A',
	"premium_freight"       	char(1) NULL DEFAULT 'N',
	"premium_amount"        	numeric(20,2) NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."cdi_ppdcr"
(
	"id"    			integer NOT NULL IDENTITY(1, 1),
	"p_age" 			integer NULL,
	"pointsd"       		integer NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."cdi_vprating"
(
	"id"    			integer NOT NULL IDENTITY(1, 1),
	"lrange"        		integer NULL,
	"hrange"        		integer NULL,
	"rating"        		varchar(25) NULL,
	PRIMARY KEY ("id")
)
go
CREATE TABLE dbo."mdata"
(
	"pmcode"        		varchar(20) NOT NULL,
	"mcode" 			varchar(20) NOT NULL,
	"mname" 			varchar(50) NULL,
	"switch"        		char(1) NULL DEFAULT 'N',
	"display"       		char(1) NULL DEFAULT 'N',
	PRIMARY KEY ("mcode")
)
go
CREATE TABLE dbo."tdata"
(
	"mcode" 			varchar(20) NOT NULL,
	"ucode" 			varchar(5) NOT NULL,
	"gcode" 			varchar(20) NULL,
	"scode" 			varchar(250) NULL DEFAULT '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
	"escode"        		text NULL,
	"type"  			char(1) NULL DEFAULT 'U',
	PRIMARY KEY ("mcode", "ucode")
)
go
CREATE TABLE dbo."vendor_service_status"
(
	"status_name"   		varchar(20) NOT NULL,
	"status_type"   		varchar(1) NOT NULL,
	"default_value" 		varchar(1) NOT NULL,
	PRIMARY KEY ("status_name")
)
go
CREATE TABLE dbo."admin"
(
	"version"       		varchar(50) NOT NULL,
	"db_invoice_sync"       	char(1) NULL
)
go
CREATE TABLE dbo."custom_pbl_link"
(
	"button_text"   		varchar(15) NOT NULL,
	"menu_text"     		varchar(25) NOT NULL,
	"module"        		varchar(25) NOT NULL,
	"mdi_microhelp" 		varchar(254) NULL,
	"open_window"   		varchar(254) NULL,
	"type"  			varchar(254) NULL,
	"command_line"  		varchar(254) NULL,
	"sql_script"    		varchar(254) NULL,
	"button_pic"    		varchar(254) NULL,
	PRIMARY KEY ("module")
)
go
CREATE TABLE dbo."defects"
(
	"machine"       		varchar(10) NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"reason"        		varchar(20) NULL,
	"quantity"      		numeric(20,6) NULL,
	"operator"      		varchar(10) NULL,
	"shift" 			char(1) NULL,
	"work_order"    		varchar(10) NULL,
	"data_source"   		varchar(10) NULL,
	"defect_date"   		datetime NOT NULL,
	"defect_time"   		datetime NOT NULL,
	PRIMARY KEY ("machine", "defect_date", "defect_time")
)
go
CREATE TABLE dbo."downtime"
(
	"trans_date"    		datetime NOT NULL,
	"machine"       		varchar(10) NOT NULL,
	"reason_code"   		varchar(10) NULL,
	"reason_name"   		varchar(35) NULL,
	"down_time"     		numeric(20,6) NULL,
	"notes" 			varchar(255) NULL,
	"employee"      		varchar(10) NULL,
	"shift" 			char(1) NULL,
	"job"   			varchar(10) NULL,
	"part"  			varchar(15) NULL,
	"qty"   			numeric(20,6) NULL,
	"type"  			char(1) NULL,
	"production_pointer"    	varchar(10) NULL,
	"data_source"   		varchar(10) NULL,
	"trans_time"    		datetime NOT NULL,
	PRIMARY KEY ("trans_date", "machine", "trans_time")
)
go
CREATE TABLE dbo."employee"
(
	"name"  			varchar(40) NOT NULL,
	"operator_code" 		varchar(5) NOT NULL,
	"password"      		varchar(5) NOT NULL,
	"serial_number" 		integer NULL,
	"epassword"     		text NULL,
	"operatorlevel" 		integer NULL,
	PRIMARY KEY ("operator_code")
)
go
ALTER TABLE dbo."employee" ADD UNIQUE ( "password"
)
go
CREATE TABLE dbo."exp_apdata_detail"
(
	"sequence_num"  		integer NULL,
	"status_code"   		integer NOT NULL,
	"trx_ctrl_num"  		varchar(16) NOT NULL,
	"trx_type"      		integer NOT NULL,
	"sequence_id"   		integer NOT NULL,
	"po_ctrl_num"   		varchar(8) NULL,
	"unit_price"    		float NULL,
	"amt_freight"   		float NULL,
	"amt_tax"       		float NULL,
	"amt_misc"      		float NULL,
	"gl_exp_acct"   		varchar(32) NOT NULL,
	"line_description"      	varchar(60) NULL,
	PRIMARY KEY ("trx_ctrl_num", "sequence_id")
)
go
CREATE TABLE dbo."exp_apdata_header"
(
	"sequence_num"  		integer NULL,
	"status_code"   		integer NULL,
	"trx_ctrl_num"  		varchar(16) NOT NULL,
	"trx_type"      		integer NULL,
	"doc_ctrl_num"  		varchar(16) NULL,
	"user_trx_type_code"    	varchar(8) NULL,
	"batch_code"    		varchar(16) NOT NULL,
	"date_applied_j"        	integer NULL,
	"date_doc_j"    		integer NULL,
	"vendor_code"   		varchar(12) NULL,
	"terms_code"    		varchar(8) NULL,
	"date_applied_d"        	datetime NULL,
	"date_doc_d"    		datetime NULL,
	PRIMARY KEY ("trx_ctrl_num", "batch_code")
)
go
CREATE TABLE dbo."gt_comp_list"
(
	"spid"  			integer NOT NULL,
	"part_number"   		varchar(25) NOT NULL,
	"cur_level"     		integer NOT NULL,
	"processed"     		char(1) NOT NULL
)
go
CREATE TABLE dbo."inventory_accuracy_history"
(
	"code"  			varchar(15) NOT NULL,
	"type"  			char(1) NOT NULL,
	"date_counted"  		datetime NOT NULL,
	"accuracy_percentage"   	numeric(5,2) NOT NULL,
	"total_objects" 		integer NULL,
	"total_discrepency"     	integer NULL,
	"group_no"      		varchar(15) NULL,
	PRIMARY KEY ("code", "date_counted")
)
go
CREATE TABLE dbo."master_prod_sched"
(
	"type"  			char(1) NULL,
	"part"  			varchar(25) NOT NULL,
	"due"   			datetime NOT NULL,
	"qnty"  			numeric(20,6) NOT NULL,
	"source"        		integer NOT NULL,
	"source2"       		varchar(15) NULL,
	"origin"        		numeric(8,0) NOT NULL,
	"rel_date"      		datetime NULL,
	"tool"  			varchar(15) NULL,
	"workcenter"    		varchar(10) NULL,
	"machine"       		varchar(10) NOT NULL,
	"run_time"      		numeric(20,6) NOT NULL,
	"run_day"       		numeric(20,6) NULL,
	"dead_start"    		datetime NOT NULL,
	"material"      		varchar(15) NULL,
	"job"   			varchar(15) NOT NULL,
	"material_qnty" 		numeric(20,6) NULL,
	"setup" 			numeric(20,6) NOT NULL,
	"location"      		varchar(10) NULL,
	"field1"        		varchar(10) NULL,
	"field2"        		varchar(10) NULL,
	"field3"        		varchar(10) NULL,
	"field4"        		varchar(10) NULL,
	"field5"        		varchar(10) NULL,
	"status"        		char(1) NOT NULL,
	"sched_method"  		char(1) NULL,
	"qty_completed" 		numeric(20,6) NULL,
	"process"       		varchar(25) NULL,
	"tool_num"      		varchar(15) NULL,
	"workorder"     		varchar(10) NULL,
	"qty_assigned"  		numeric(20,6) NULL,
	"due_time"      		datetime NULL,
	"start_time"    		datetime NULL,
	"id"    			numeric(12,0) NOT NULL,
	"parent_id"     		numeric(12,0) NULL,
	"begin_date"    		datetime NULL,
	"begin_time"    		datetime NULL,
	"end_date"      		datetime NULL,
	"end_time"      		datetime NULL,
	"po_number"     		integer NULL,
	"po_row_id"     		integer NULL,
	"week_no"       		integer NULL,
	"plant" 			varchar(15) NULL,
	"ship_type"     		char(1) NULL,
	"ai_row"        		integer NOT NULL IDENTITY(1, 1),
	PRIMARY KEY ("ai_row")
)
go
CREATE TABLE dbo."ole_objects"
(
	"id"    			varchar(255) NOT NULL,
	"ole_object"    		text NULL,
	"parent_id"     		varchar(100) NOT NULL,
	"date_stamp"    		datetime NULL,
	"serial"        		integer NOT NULL,
	"parent_type"   		char(1) NULL,
	PRIMARY KEY ("serial")
)
go
CREATE TABLE dbo."production_shift"
(
	"part"  			varchar(25) NOT NULL,
	"location"      		varchar(10) NOT NULL,
	"machine"       		varchar(10) NULL,
	"tool"  			varchar(15) NULL,
	"activity"      		varchar(10) NULL,
	"date_stamp"    		datetime NULL,
	"time_stamp"    		datetime NULL,
	"type"  			varchar(1) NULL,
	"production_time"       	numeric(10,2) NULL,
	"start_time"    		datetime NULL,
	"stop_time"     		datetime NULL,
	"production_rate"       	numeric(10,2) NULL,
	"fixtures_cavities"     	numeric(10,2) NULL,
	"transaction_number"    	varchar(10) NULL,
	"transaction_datetime" 	datetime NOT NULL,
	"data_source"   		varchar(10) NULL,
	"acum_production_qty"   	numeric(20,6) NULL,
	"average_cycle_time"    	numeric(5,0) NULL,
	"quantity"      		numeric(20,6) NULL,
	"work_order_number"     	varchar(10) NULL,
	PRIMARY KEY ("part", "transaction_datetime")
)
go
CREATE TABLE dbo."shop_floor_calendar"
(
	"ai_id" 			integer NOT NULL IDENTITY(1, 1),
	"machine"       		varchar(10) NOT NULL,
	"begin_datetime"        	datetime NOT NULL,
	"end_datetime"  		datetime NULL,
	"labor_code"    		varchar(25) NULL,
	"crew_size"     		integer NULL,
	PRIMARY KEY ("ai_id")
)
go
ALTER TABLE dbo."shop_floor_calendar" ADD UNIQUE ( "machine", "begin_datetime"
)
go
CREATE TABLE dbo."shop_floor_time_log"
(
	"log_date"      		datetime NOT NULL,
	"shift" 			smallint NULL,
	"operator"      		varchar(10) NOT NULL,
	"activity"      		varchar(25) NULL,
	"location"      		varchar(10) NULL,
	"part"  			varchar(25) NULL,
	"qty"   			numeric(20,6) NULL,
	"labor_hours"   		numeric(10,2) NULL,
	"work_order"    		varchar(10) NULL,
	"transaction_date_time" 	datetime NOT NULL,
	"status"        		varchar(1) NULL,
	PRIMARY KEY ("operator", "transaction_date_time")
)
go
CREATE TABLE dbo."temp_bom_stack"
(
	"part"  			varchar(25) NULL,
	"partlevel"     		smallint NULL,
	"spid"  			smallint NULL
)
go
CREATE TABLE dbo."temp_bomec_stack"
(
	"parent_part"   		varchar(25) NULL,
	"part"  			varchar(25) NULL,
	"item_level"    		smallint NULL,
	"start_datetime"        	datetime NULL,
	"end_datetime"  		datetime NULL,
	"substitute_part"       	varchar(1) NULL,
	"type"  			varchar(1) NULL,
	"spid"  			integer NOT NULL
)
go
CREATE TABLE dbo."time_log"
(
	"id"    			integer NOT NULL,
	"employee"      		varchar(35) NULL,
	"time_logged"   		numeric(5,2) NULL,
	"notes" 			varchar(255) NULL,
	"log_date"      		datetime NOT NULL,
	"log_time"      		datetime NOT NULL,
	"type"  			char(1) NULL,
	"source"        		integer NULL,
	"workorder"     		varchar(10) NULL,
	PRIMARY KEY ("id", "log_date", "log_time")
)
go
CREATE TABLE dbo."kanban"
(
	"kanban_number" 		varchar(6) NOT NULL,
	"order_no"      		numeric(8,0) NOT NULL,
	"line11"        		varchar(21) NULL,
	"line12"        		varchar(21) NULL,
	"line13"        		varchar(21) NULL,
	"line14"        		varchar(21) NULL,
	"line15"        		varchar(21) NULL,
	"line16"        		varchar(21) NULL,
	"line17"        		varchar(21) NULL,
	"status"        		char(1) NOT NULL,
	"standard_quantity"     	numeric(20,6) NOT NULL,
	PRIMARY KEY ("kanban_number", "order_no")
)
go
CREATE TABLE dbo."part_vendor_price_matrix"
(
	"part"  			varchar(25) NOT NULL,
	"vendor"        		varchar(10) NOT NULL,
	"price" 			numeric(20,6) NOT NULL,
	"break_qty"     		numeric(20,6) NOT NULL,
	"code"  			varchar(10) NULL,
	"alternate_price"       	numeric(20,6) NULL,
	PRIMARY KEY ("part", "vendor", "break_qty")
)
go
CREATE TABLE dbo."work_order"
(
	"work_order"    		varchar(10) NOT NULL,
	"tool"  			varchar(10) NULL,
	"due_date"      		datetime NULL,
	"cycles_required"       	numeric(10,0) NULL,
	"cycles_completed"      	numeric(10,0) NULL,
	"machine_no"    		varchar(10) NOT NULL,
	"process_id"    		varchar(25) NULL,
	"customer_part" 		varchar(25) NULL,
	"setup_time"    		numeric(6,2) NULL,
	"cycles_hour"   		numeric(6,0) NULL,
	"standard_pack" 		numeric(8,0) NULL,
	"sequence"      		integer NOT NULL,
	"cycle_time"    		integer NULL,
	"start_date"    		datetime NULL,
	"start_time"    		datetime NULL,
	"end_date"      		datetime NULL,
	"end_time"      		datetime NULL,
	"runtime"       		numeric(20,6) NULL,
	"employee"      		varchar(35) NULL,
	"type"  			char(1) NULL,
	"accum_run_time"        	numeric(20,6) NULL,
	"cycle_unit"    		varchar(15) NULL,
	"material_shortage"     	char(1) NULL,
	"lot_control_activated" 	char(1) NULL,
	"plant" 			varchar(20) NULL,
	"order_no"      		numeric(8,0) NULL,
	"destination"   		varchar(20) NULL,
	"customer"      		varchar(20) NULL,
	"note"  			varchar(255) NULL,
	PRIMARY KEY ("work_order")
)
go
CREATE TABLE dbo."workorder_header_history"
(
	"work_order"    		varchar(10) NOT NULL,
	"tool"  			varchar(10) NULL,
	"due_date"      		datetime NULL,
	"cycles_required"       	numeric(10,0) NULL,
	"cycles_completed"      	numeric(10,0) NULL,
	"machine_no"    		varchar(10) NOT NULL,
	"process_id"    		varchar(25) NULL,
	"customer_part" 		varchar(25) NULL,
	"setup_time"    		numeric(6,2) NULL,
	"cycles_hour"   		numeric(6,0) NULL,
	"standard_pack" 		numeric(8,0) NULL,
	"sequence"      		integer NOT NULL,
	"cycle_time"    		integer NULL,
	"start_date"    		datetime NULL,
	"start_time"    		datetime NULL,
	"end_date"      		datetime NULL,
	"end_time"      		datetime NULL,
	"runtime"       		numeric(20,6) NULL,
	"employee"      		varchar(35) NULL,
	"type"  			char(1) NULL,
	"accum_run_time"        	numeric(20,6) NULL,
	"cycle_unit"    		varchar(15) NULL,
	"material_shortage"     	char(1) NULL,
	"lot_control_activated" 	char(1) NULL,
	"plant" 			varchar(20) NULL,
	"order_no"      		numeric(8,0) NULL,
	"destination"   		varchar(20) NULL,
	"customer"      		varchar(20) NULL,
	"note"  			varchar(255) NULL,
	PRIMARY KEY ("work_order", "machine_no", "sequence")
)
go
CREATE TABLE dbo."m_in_release_plan"
(
	"customer_part" 		varchar(35) NOT NULL,
	"shipto_id"     		varchar(20) NOT NULL,
	"customer_po"   		varchar(20) NULL,
	"model_year"    		varchar(4) NULL,
	"release_no"    		varchar(30) NOT NULL,
	"quantity_qualifier"    	char(1) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"release_dt_qualifier"  	char(1) NOT NULL,
	"release_dt"    		datetime NOT NULL
)
go
CREATE TABLE dbo."m_in_release_plan_exceptions"
(
	"logid" 			integer NOT NULL,
	"customer_part" 		varchar(35) NOT NULL,
	"shipto_id"     		varchar(20) NOT NULL,
	"customer_po"   		varchar(20) NULL,
	"model_year"    		varchar(4) NULL,
	"release_no"    		varchar(30) NOT NULL,
	"quantity_qualifier"    	char(1) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"release_dt_qualifier"  	char(1) NOT NULL,
	"release_dt"    		datetime NOT NULL
)
go
CREATE TABLE dbo."m_in_customer_po"
(
	"plant" 			varchar(10) NULL,
	"shipto_id"     		varchar(20) NOT NULL,
	"customer_po"   		varchar(20) NULL,
	"customer_part" 		varchar(35) NOT NULL,
	"release_no"    		varchar(30) NOT NULL,
	"order_unit"    		char(2) NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"release_dt_qualifier"  	char(1) NOT NULL,
	"release_dt"    		datetime NOT NULL,
	"release_type_qualifier"        char(1) NOT NULL
)
go
CREATE TABLE dbo."m_in_customer_po_exceptions"
(
	"logid" 			integer NOT NULL,
	"plant" 			varchar(10) NULL,
	"shipto_id"     		varchar(20) NOT NULL,
	"customer_po"   		varchar(20) NULL,
	"customer_part" 		varchar(35) NOT NULL,
	"release_no"    		varchar(30) NOT NULL,
	"order_unit"    		char(2) NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"release_dt_qualifier"  	char(1) NOT NULL,
	"release_dt"    		datetime NOT NULL,
	"release_type_qualifier"        char(1) NOT NULL
)
go
CREATE TABLE dbo."m_in_ship_schedule"
(
	"customer_part" 		varchar(35) NOT NULL,
	"shipto_id"     		varchar(20) NOT NULL,
	"customer_po"   		varchar(20) NULL,
	"model_year"    		varchar(4) NULL,
	"release_no"    		varchar(30) NOT NULL,
	"quantity_qualifier"    	char(1) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"release_dt_qualifier"  	char(1) NOT NULL,
	"release_dt"    		datetime NOT NULL
)
go
CREATE TABLE dbo."m_in_ship_schedule_exceptions"
(
	"logid" 			integer NOT NULL,
	"customer_part" 		varchar(35) NOT NULL,
	"shipto_id"     		varchar(20) NOT NULL,
	"customer_po"   		varchar(20) NULL,
	"model_year"    		varchar(4) NULL,
	"release_no"    		varchar(30) NOT NULL,
	"quantity_qualifier"    	char(1) NOT NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"release_dt_qualifier"  	char(1) NOT NULL,
	"release_dt"    		datetime NOT NULL
)
go
CREATE TABLE dbo."serial_asn"
(
	"serial"        		integer NOT NULL,
	"part"  			varchar(25) NOT NULL,
	"shipper"       		integer NOT NULL,
	"package_type"  		varchar(25) NULL
)
go
CREATE TABLE dbo."requisition_security"
(
	"operator_code" 		varchar(8) NOT NULL,
	"password"      		varchar(8) NOT NULL,
	"security_level"        	integer NULL,
	"dollar"        		numeric(20,6) NULL,
	"approver"      		varchar(8) NULL,
	"approver_password"     	varchar(8) NULL,
	"backup_approver"       	varchar(8) NULL,
	"backup_approver_password"      varchar(8) NULL,
	"backup_approver_end_date"      datetime NULL,
	"dollar_week_limit"     	numeric(20,6) NULL,
	"account_group_code"    	varchar(25) NULL,
	"project_group_code"    	varchar(25) NULL,
	"self_dollar_limit"     	numeric(20,6) NULL,
	"name"  			varchar(40) NULL,
	PRIMARY KEY ("operator_code")
)
go
CREATE TABLE dbo."requisition_header"
(
	"requisition_number"    	integer NOT NULL,
	"vendor_code"   		varchar(10) NULL,
	"ship_to_destination"   	varchar(25) NULL,
	"terms" 			varchar(20) NULL,
	"fob"   			varchar(20) NULL,
	"requested_date"        	datetime NOT NULL,
	"requisitioner" 		varchar(8) NOT NULL,
	"ship_via"      		varchar(15) NULL,
	"notes" 			text NULL,
	"approved"      		varchar(1) NULL,
	"approver"      		varchar(8) NULL,
	"creation_date" 		datetime NOT NULL,
	"status"        		varchar(10) NOT NULL,
	"approval_date" 		datetime NULL,
	"freight_type"  		varchar(15) NULL,
	"status_notes"  		text NULL,
	PRIMARY KEY ("requisition_number")
)
go
CREATE TABLE dbo."requisition_detail"
(
	"requisition_number"    	integer NOT NULL,
	"part_number"   		varchar(25) NOT NULL,
	"description"   		varchar(50) NULL,
	"account_no"    		varchar(50) NULL,
	"deliver_to_operator"   	varchar(10) NULL,
	"expected_cost" 		numeric(20,6) NULL,
	"quantity"      		numeric(20,6) NOT NULL,
	"date_required" 		datetime NOT NULL,
	"notes" 			text NULL,
	"row_id"        		integer NOT NULL,
	"po_number"     		integer NULL,
	"vendor_code"   		varchar(10) NULL,
	"service_flag"  		varchar(1) NULL,
	"unit_of_measure"       	varchar(2) NULL,
	"unit_cost"     		numeric(20,6) NULL,
	"extended_cost" 		numeric(20,6) NULL,
	"status"        		varchar(10) NULL,
	"status_notes"  		text NULL,
	"po_rowid"      		integer NULL,
	"project_number"        	varchar(50) NULL,
	PRIMARY KEY ("requisition_number", "row_id")
)
go
CREATE TABLE dbo."requisition_notes"
(
	"code"  			varchar(25) NOT NULL,
	"notes" 			text NULL,
	PRIMARY KEY ("code")
)
go
CREATE TABLE dbo."requisition_account_project"
(
	"account_number"        	varchar(50) NOT NULL,
	"project_number"        	varchar(50) NOT NULL,
	PRIMARY KEY ("account_number", "project_number")
)
go
CREATE TABLE dbo."requisition_project_number"
(
	"project_number"        	varchar(50) NOT NULL,
	"description"   		varchar(255) NULL,
	PRIMARY KEY ("project_number")
)
go
CREATE TABLE dbo."account_code"
(
	"account_no"    		varchar(50) NOT NULL,
	"description"   		varchar(255) NULL,
	PRIMARY KEY ("account_no")
)
go
CREATE TABLE dbo."requisition_group"
(
	"group_code"    		varchar(25) NOT NULL,
	"description"   		varchar(255) NULL,
	PRIMARY KEY ("group_code")
)
go
CREATE TABLE dbo."requisition_group_account"
(
	"group_code"    		varchar(25) NOT NULL,
	"account_no"    		varchar(50) NOT NULL,
	PRIMARY KEY ("group_code", "account_no")
)
go
CREATE TABLE dbo."requisition_group_project"
(
	"group_code"    		varchar(25) NOT NULL,
	"project_number"        	varchar(50) NOT NULL,
	PRIMARY KEY ("group_code", "project_number")
)
go
CREATE TABLE dbo."filters"
(
	"filtername"    		varchar(10) NOT NULL,
	"sequence"      		integer NOT NULL,
	"module"        		varchar(30) NOT NULL,
	"filterdate"    		datetime NOT NULL,
	"leftparenthesis"       	varchar(10) NULL,
	"column_name"   		varchar(255) NOT NULL,
	"roperator"     		varchar(15) NOT NULL,
	"value" 			varchar(255) NOT NULL,
	"loperator"     		varchar(10) NULL,
	"operator"      		varchar(5) NULL,
	"rightparenthesis"      	varchar(10) NULL,
	PRIMARY KEY ("filtername", "sequence")
)
go
CREATE TABLE dbo."approver_substitutes"
(
	"approver"      		char(25) NOT NULL,
	"approver_substitute"   	char(25) NOT NULL,
	"start_date"    		datetime NOT NULL,
	"end_date"      		datetime NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("approver", "approver_substitute", "start_date")
)
go
CREATE TABLE dbo."employee_attribute_definition"
(
	"attribute_type"        	char(25) NOT NULL,
	"text_1_text"   		char(25) NULL,
	"text_1_reqd"   		char(1) NULL,
	"text_1_table_name"     	char(25) NULL,
	"text_2_text"   		char(25) NULL,
	"text_2_reqd"   		char(1) NULL,
	"text_2_table_name"     	char(25) NULL,
	"text_3_text"   		char(25) NULL,
	"text_3_reqd"   		char(1) NULL,
	"text_3_table_name"     	char(25) NULL,
	"text_4_text"   		char(25) NULL,
	"text_4_reqd"   		char(1) NULL,
	"text_4_table_name"     	char(25) NULL,
	"text_5_text"   		char(25) NULL,
	"text_5_reqd"   		char(1) NULL,
	"text_5_table_name"     	char(25) NULL,
	"text_6_text"   		char(25) NULL,
	"text_6_reqd"   		char(1) NULL,
	"text_6_table_name"     	char(25) NULL,
	"text_7_text"   		char(25) NULL,
	"text_7_reqd"   		char(1) NULL,
	"text_7_table_name"     	char(25) NULL,
	"text_8_text"   		char(25) NULL,
	"text_8_reqd"   		char(1) NULL,
	"text_8_table_name"     	char(25) NULL,
	"text_9_text"   		char(25) NULL,
	"text_9_reqd"   		char(1) NULL,
	"text_9_table_name"     	char(25) NULL,
	"text_10_text"  		char(25) NULL,
	"text_10_reqd"  		char(1) NULL,
	"text_10_table_name"    	char(25) NULL,
	"text_11_text"  		char(25) NULL,
	"text_11_reqd"  		char(1) NULL,
	"text_11_table_name"    	char(25) NULL,
	"text_12_text"  		char(25) NULL,
	"text_12_reqd"  		char(1) NULL,
	"text_12_table_name"    	char(25) NULL,
	"text_13_text"  		char(25) NULL,
	"text_13_reqd"  		char(1) NULL,
	"text_13_table_name"    	char(25) NULL,
	"text_14_text"  		char(25) NULL,
	"text_14_reqd"  		char(1) NULL,
	"text_14_table_name"    	char(25) NULL,
	"text_15_text"  		char(25) NULL,
	"text_15_reqd"  		char(1) NULL,
	"text_15_table_name"    	char(25) NULL,
	"text_16_text"  		char(25) NULL,
	"text_16_reqd"  		char(1) NULL,
	"text_16_table_name"    	char(25) NULL,
	"text_17_text"  		char(25) NULL,
	"text_17_reqd"  		char(1) NULL,
	"text_17_table_name"    	char(25) NULL,
	"text_18_text"  		char(25) NULL,
	"text_18_reqd"  		char(1) NULL,
	"text_18_table_name"    	char(25) NULL,
	"text_19_text"  		char(25) NULL,
	"text_19_reqd"  		char(1) NULL,
	"text_19_table_name"    	char(25) NULL,
	"text_20_text"  		char(25) NULL,
	"text_20_reqd"  		char(1) NULL,
	"text_20_table_name"    	char(25) NULL,
	"integer_1_text"        	char(25) NULL,
	"integer_1_reqd"        	char(1) NULL,
	"integer_2_text"        	char(25) NULL,
	"integer_2_reqd"        	char(1) NULL,
	"integer_3_text"        	char(25) NULL,
	"integer_3_reqd"        	char(1) NULL,
	"integer_4_text"        	char(25) NULL,
	"integer_4_reqd"        	char(1) NULL,
	"integer_5_text"        	char(25) NULL,
	"integer_5_reqd"        	char(1) NULL,
	"numeric_1_text"        	char(25) NULL,
	"numeric_1_reqd"        	char(1) NULL,
	"numeric_2_text"        	char(25) NULL,
	"numeric_2_reqd"        	char(1) NULL,
	"numeric_3_text"        	char(25) NULL,
	"numeric_3_reqd"        	char(1) NULL,
	"numeric_4_text"        	char(25) NULL,
	"numeric_4_reqd"        	char(1) NULL,
	"numeric_5_text"        	char(25) NULL,
	"numeric_5_reqd"        	char(1) NULL,
	"date_1_text"   		char(25) NULL,
	"date_1_reqd"   		char(1) NULL,
	"date_2_text"   		char(25) NULL,
	"date_2_reqd"   		char(1) NULL,
	"date_3_text"   		char(25) NULL,
	"date_3_reqd"   		char(1) NULL,
	"date_4_text"   		char(25) NULL,
	"date_4_reqd"   		char(1) NULL,
	"date_5_text"   		char(25) NULL,
	"date_5_reqd"   		char(1) NULL,
	"date_6_text"   		char(25) NULL,
	"date_6_reqd"   		char(1) NULL,
	"date_7_text"   		char(25) NULL,
	"date_7_reqd"   		char(1) NULL,
	"date_8_text"   		char(25) NULL,
	"date_8_reqd"   		char(1) NULL,
	"date_9_text"   		char(25) NULL,
	"date_9_reqd"   		char(1) NULL,
	"date_10_text"  		char(25) NULL,
	"date_10_reqd"  		char(1) NULL,
	"changed_user_id"       	char(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("attribute_type")
)
go
CREATE TABLE dbo."item_locations"
(
	"item"  			char(50) NOT NULL,
	"location"      		char(25) NOT NULL,
	"inventory_uom" 		char(25) NULL,
	"inventory_uom_to_standard"     numeric(18,6) NULL,
	"count_cycle"   		char(25) NULL,
	"receive_ledger_account"        char(50) NULL,
	"issue_ledger_account"  	char(50) NULL,
	"adjust_ledger_account" 	char(50) NULL,
	"minimum_ave_cost"      	numeric(18,6) NULL,
	"maximum_ave_cost"      	numeric(18,6) NULL,
	"reorder_quantity"      	numeric(18,6) NULL,
	"safety_stock"  		numeric(18,6) NULL,
	"create_po_req" 		char(25) NULL,
	"on_hand_quantity"      	numeric(18,6) NULL,
	"on_order_quantity"     	numeric(18,6) NULL,
	"sold_quantity" 		numeric(18,6) NULL,
	"reserved_quantity"     	numeric(18,6) NULL,
	"inventory_amount"      	numeric(18,6) NULL,
	"average_cost"  		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"serial_required"       	char(1) NULL,
	"ledger"        		char(40) NULL,
	"unit"  			char(25) NULL,
	"section"       		char(25) NULL,
	"aisle" 			char(25) NULL,
	"shelf" 			char(25) NULL,
	"currency"      		char(25) NULL,
	"receive_ledger_account_credit" char(50) NULL,
	"issue_ledger_account_credit"   char(50) NULL,
	"adjust_ledger_account_credit"  char(50) NULL,
	"item_ledger_account_group"     varchar(25) NULL,
	"item_reorder_rule"     	varchar(25) NULL,
	"max_reorder_on_hand"   	numeric(18,6) NULL,
	"active_inactive"       	char(1) NULL,
	"serial_assignment"     	char(1) NULL,
	"serials_by"    		char(1) NULL,
	PRIMARY KEY ("item", "location")
)
go
CREATE TABLE dbo."item_transactions"
(
	"item"  			char(50) NOT NULL,
	"location"      		char(25) NOT NULL,
	"serial_number" 		char(50) NOT NULL,
	"gl_date"       		datetime NULL,
	"gl_entry"      		char(50) NULL,
	"fiscal_year"   		char(25) NULL,
	"period"        		smallint NULL,
	"transaction_type"      	char(25) NULL,
	"quantity"      		numeric(18,6) NULL,
	"amount"        		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"unit"  			char(25) NULL,
	"note"  			varchar(max) NULL,
	"debit_ledger_account"  	char(50) NULL,
	"credit_ledger_account" 	char(50) NULL,
	"batch" 			char(50) NULL,
	"ledger"        		char(40) NULL,
	"document_type" 		char(25) NOT NULL,
	"document_id1"  		char(25) NOT NULL,
	"document_id2"  		char(25) NOT NULL,
	"document_id3"  		char(25) NOT NULL,
	"document_line" 		smallint NOT NULL,
	"container_id"  		char(25) NULL,
	"country_of_origin"     	char(25) NULL,
	"package"       		char(25) NULL,
	"unit_cost"     		numeric(18,6) NULL,
	"transfer_id"   		varchar(25) NULL,
	"item_production_id"    	varchar(25) NULL,
	PRIMARY KEY ("document_type", "document_id1", "document_id2", "document_id3", "document_line")
)
go
CREATE TABLE dbo."sales_terms"
(
	"sales_term"    		char(25) NOT NULL,
	"sales_term_description"        char(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("sales_term")
)
go
CREATE TABLE dbo."secured_columns"
(
	"secured_column_name"   	char(40) NOT NULL,
	"security_enabled"      	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"secured_column_start"  	smallint NULL,
	"secured_column_length" 	smallint NULL,
	"installed_module"      	varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("secured_column_name")
)
go
CREATE TABLE dbo."units_inventory"
(
	"unit"  			char(25) NOT NULL,
	"name"  			char(40) NULL,
	"ledger"        		char(40) NULL,
	"status"        		char(1) NULL,
	"gl_entry_frequency"    	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"company"       		char(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("unit")
)
go
CREATE TABLE dbo."user_secured_columns"
(
	"security_id"   		char(25) NOT NULL,
	"secured_column_name"   	char(40) NOT NULL,
	"valid_values"  		varchar(max) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	"active_inactive"       	char(1) NULL,
	"user_secured_column_id"        integer NOT NULL IDENTITY(1, 1),
	PRIMARY KEY ("security_id", "secured_column_name", "user_secured_column_id")
)
go
CREATE TABLE dbo."ar_customer_ship_locations"
(
	"customer"      		varchar(25) NOT NULL,
	"ship_location" 		varchar(25) NOT NULL,
	"ship_name"     		varchar(100) NULL,
	"ship_address_id"       	varchar(25) NULL,
	"ship_contact_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"primary_ship_location" 	char(1) NULL,
	"label_name"    		varchar(25) NULL,
	PRIMARY KEY ("customer", "ship_location")
)
go
CREATE TABLE dbo."sales_agents"
(
	"sales_agent"   		varchar(25) NOT NULL,
	"sales_agent_description"       varchar(50) NULL,
	"commission_percent"    	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("sales_agent")
)
go
CREATE TABLE dbo."territories"
(
	"territory"     		varchar(25) NOT NULL,
	"territory_description" 	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("territory")
)
go
CREATE TABLE dbo."computed_values"
(
	"row_number"    		smallint NOT NULL,
	"numeric_18_6"  		numeric(18,6) NOT NULL,
	"numeric_18_5"  		numeric(18,5) NOT NULL,
	"numeric_18_4"  		numeric(18,4) NOT NULL,
	"numeric_18_3"  		numeric(18,3) NOT NULL,
	"numeric_18_2"  		numeric(18,2) NOT NULL,
	"numeric_18_1"  		numeric(18,1) NOT NULL,
	"null_date"     		datetime NULL,
	"text_column"   		varchar(3800) NULL,
	PRIMARY KEY ("row_number")
)
go
CREATE TABLE dbo."employee_attribute_validations"
(
	"validation_table_name" 	varchar(25) NOT NULL,
	"valid_value"   		varchar(25) NOT NULL,
	"description"   		varchar(250) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("validation_table_name", "valid_value")
)
go
CREATE TABLE dbo."item_ledger_account_groups"
(
	"item_ledger_account_group"     varchar(25) NOT NULL,
	"ledger"        		varchar(40) NULL,
	"receive_ledger_account"        varchar(50) NULL,
	"issue_ledger_account"  	varchar(50) NULL,
	"adjust_ledger_account" 	varchar(50) NULL,
	"receive_ledger_account_credit" varchar(50) NULL,
	"issue_ledger_account_credit"   varchar(50) NULL,
	"adjust_ledger_account_credit"  varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("item_ledger_account_group")
)
go
CREATE TABLE dbo."cost_identifier_notes"
(
	"cost_id"       		varchar(25) NOT NULL,
	"cost_sub"      		varchar(25) NOT NULL,
	"note_date"     		datetime NOT NULL,
	"cost_id_note"  		text NULL,
	"follow_up_date"        	datetime NULL,
	"resolved_date" 		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("cost_id", "cost_sub", "note_date")
)
go
CREATE TABLE dbo."allocation_rules"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"allocation_rule"       	varchar(40) NOT NULL,
	"allocation_description"        varchar(50) NULL,
	"allocation_sequence"   	integer NOT NULL,
	"je_reference"  		varchar(50) NULL,
	"je_reason"     		varchar(50) NULL,
	"je_comment"    		text NULL,
	"reverse_next_period"   	char(1) NULL,
	"ledger"        		varchar(40) NOT NULL,
	"allocate_from_org_level"       varchar(40) NULL,
	"allocate_from_organization"    varchar(250) NULL,
	"allocate_from_account" 	varchar(250) NULL,
	"allocate_from_period_ytd"      varchar(25) NULL,
	"allocate_by_org_level" 	varchar(40) NULL,
	"allocate_by_organization"      varchar(250) NULL,
	"allocate_by_account"   	varchar(250) NULL,
	"allocate_by_period_ytd"        varchar(25) NULL,
	"allocate_to_org_level" 	varchar(40) NULL,
	"allocate_to_organization"      varchar(250) NULL,
	"allocate_to_account"   	varchar(50) NOT NULL,
	"offset_to_org_level"   	varchar(40) NULL,
	"offset_to_organization"        varchar(250) NULL,
	"offset_to_account"     	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "allocation_rule", "ledger")
)
go
CREATE TABLE dbo."item_bill_of_material"
(
	"item"  			varchar(50) NOT NULL,
	"raw_material_item"     	varchar(50) NOT NULL,
	"quantity"      		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("item", "raw_material_item")
)
go
CREATE TABLE dbo."item_reorder_rules"
(
	"item_reorder_rule"     	varchar(25) NOT NULL,
	"description"   		varchar(50) NULL,
	"reorder_rule_style"    	varchar(50) NULL,
	"season_offset_jan"     	integer NULL,
	"season_offset_feb"     	integer NULL,
	"season_offset_mar"     	integer NULL,
	"season_offset_apr"     	integer NULL,
	"season_offset_may"     	integer NULL,
	"season_offset_jun"     	integer NULL,
	"season_offset_jul"     	integer NULL,
	"season_offset_aug"     	integer NULL,
	"season_offset_sep"     	integer NULL,
	"season_offset_oct"     	integer NULL,
	"season_offset_nov"     	integer NULL,
	"season_offset_dec"     	integer NULL,
	"reorder_percent_jan"   	numeric(18,6) NULL,
	"reorder_percent_feb"   	numeric(18,6) NULL,
	"reorder_percent_mar"   	numeric(18,6) NULL,
	"reorder_percent_apr"   	numeric(18,6) NULL,
	"reorder_percent_may"   	numeric(18,6) NULL,
	"reorder_percent_jun"   	numeric(18,6) NULL,
	"reorder_percent_jul"   	numeric(18,6) NULL,
	"reorder_percent_aug"   	numeric(18,6) NULL,
	"reorder_percent_sep"   	numeric(18,6) NULL,
	"reorder_percent_oct"   	numeric(18,6) NULL,
	"reorder_percent_nov"   	numeric(18,6) NULL,
	"reorder_percent_dec"   	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("item_reorder_rule")
)
go
CREATE TABLE dbo."req_bids"
(
	"requisition"   		varchar(25) NOT NULL,
	"vendor_name"   		varchar(50) NOT NULL,
	"buy_vendor"    		varchar(25) NULL,
	"bid_send_date" 		datetime NULL,
	"bid_received_date"     	datetime NULL,
	"bid_amount"    		numeric(18,6) NULL,
	"number_of_days_to_deliver"     integer NULL,
	"bid_comment"   		text NULL,
	"award_reason"  		varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("requisition", "vendor_name")
)
go
CREATE TABLE dbo."body_parts"
(
	"body_part"     		varchar(25) NOT NULL,
	"body_part_description" 	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("body_part")
)
go
CREATE TABLE dbo."companies_wcb"
(
	"wcb_group"     		varchar(25) NOT NULL,
	"province_id"   		varchar(25) NULL,
	"wcb_business_number"   	varchar(25) NULL,
	"company"       		varchar(25) NOT NULL,
	"rate_id"       		varchar(25) NULL,
	"rate_event"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"wcb_group_description" 	varchar(50) NULL,
	"security_unit" 		varchar(25) NULL,
	PRIMARY KEY ("wcb_group", "company")
)
go
CREATE TABLE dbo."crew_calendar_dates"
(
	"crew"  			varchar(25) NOT NULL,
	"calendar_date" 		datetime NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("crew", "calendar_date")
)
go
CREATE TABLE dbo."crew_calendars"
(
	"crew"  			varchar(25) NOT NULL,
	"calendar_date" 		datetime NOT NULL,
	"calendar_date_id"      	varchar(25) NOT NULL,
	"shift_worked"  		varchar(25) NULL,
	"scheduled_hours"       	numeric(18,6) NULL,
	"scheduled_pay_type"    	varchar(25) NULL,
	"scheduled_rate_event"  	varchar(25) NULL,
	"additional_hours_pay_type"     varchar(25) NULL,
	"additional_hours_rate_event"   varchar(25) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("crew", "calendar_date", "calendar_date_id")
)
go
CREATE TABLE dbo."crew_call_history"
(
	"crew"  			varchar(25) NULL,
	"employee"      		varchar(25) NOT NULL,
	"position"      		varchar(25) NOT NULL,
	"scheduled_date"        	datetime NULL,
	"call_date_time"        	datetime NOT NULL,
	"action_taken"  		varchar(25) NULL,
	"called_by"     		varchar(25) NULL,
	"call_comment"  		text NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("employee", "position", "call_date_time")
)
go
CREATE TABLE dbo."crew_cycle_pay_types"
(
	"crew"  			varchar(25) NOT NULL,
	"cycle_id"      		varchar(25) NOT NULL,
	"scheduled_hours"       	numeric(18,6) NULL,
	"scheduled_pay_type"    	varchar(25) NOT NULL,
	"scheduled_rate_event"  	varchar(25) NULL,
	"additional_hours_pay_type"     varchar(25) NULL,
	"additional_hours_rate_event"   varchar(25) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"sort_line"     		smallint NULL,
	PRIMARY KEY ("crew", "cycle_id", "scheduled_pay_type")
)
go
CREATE TABLE dbo."crew_cycles"
(
	"crew"  			varchar(25) NOT NULL,
	"cycle_id"      		varchar(25) NOT NULL,
	"number_of_days"        	integer NOT NULL,
	"on_or_off"     		varchar(25) NOT NULL,
	"shift_worked"  		varchar(25) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("crew", "cycle_id", "number_of_days", "on_or_off")
)
go
CREATE TABLE dbo."crew_position_dates"
(
	"crew"  			varchar(25) NOT NULL,
	"begin_date"    		datetime NOT NULL,
	"end_date"      		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("crew", "begin_date")
)
go
CREATE TABLE dbo."crew_positions"
(
	"crew"  			varchar(25) NOT NULL,
	"position_id"   		varchar(25) NOT NULL,
	"position"      		varchar(25) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"begin_date"    		datetime NOT NULL,
	"employee"      		varchar(25) NULL,
	"rate_id"       		varchar(25) NULL,
	"employee_percent"      	numeric(18,6) NULL,
	PRIMARY KEY ("crew", "position_id", "begin_date")
)
go
CREATE TABLE dbo."crew_schedule_by_employee"
(
	"crew"  			varchar(25) NOT NULL,
	"work_date"     		datetime NOT NULL,
	"position_id"   		varchar(25) NOT NULL,
	"position"      		varchar(25) NOT NULL,
	"employee"      		varchar(25) NOT NULL,
	"pay_type"      		varchar(25) NOT NULL,
	"record_type"   		char(1) NOT NULL,
	"employee_percent"      	numeric(18,6) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"hours" 			numeric(18,6) NULL,
	PRIMARY KEY ("crew", "work_date", "position_id", "employee", "pay_type", "record_type")
)
go
CREATE TABLE dbo."crew_shifts"
(
	"shift_worked"  		varchar(25) NOT NULL,
	"shift_description"     	text NOT NULL,
	"changed_user_id"       	varchar(25) NOT NULL,
	"changed_date"  		datetime NOT NULL,
	PRIMARY KEY ("shift_worked")
)
go
CREATE TABLE dbo."crews"
(
	"crew"  			varchar(25) NOT NULL,
	"crew_description"      	text NULL,
	"location"      		varchar(25) NULL,
	"division"      		varchar(25) NULL,
	"unit"  			varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"schedule_start_day"    	varchar(25) NULL,
	"signature_list"        	varchar(25) NULL,
	"entry_user_id" 		varchar(25) NULL,
	PRIMARY KEY ("crew")
)
go
CREATE TABLE dbo."employee_injuries"
(
	"employee"      		varchar(25) NOT NULL,
	"injury_date"   		datetime NOT NULL,
	"injury_type"   		varchar(25) NOT NULL,
	"body_part"     		varchar(25) NOT NULL,
	"location"      		varchar(25) NULL,
	"injury_description"    	text NULL,
	"return_date"   		datetime NULL,
	"days_lost"     		integer NULL,
	"treatment_location"    	varchar(50) NULL,
	"treatment_physician"   	varchar(50) NULL,
	"treatment_cost"        	numeric(18,6) NULL,
	"treatment_date"        	datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"osha_report"   		char(1) NULL,
	"injury_id"     		varchar(25) NULL,
	"supervisor"    		varchar(25) NULL,
	"unit"  			varchar(25) NULL,
	"division"      		varchar(25) NULL,
	"position"      		varchar(25) NULL,
	"crew"  			varchar(25) NULL,
	"job_related"   		char(1) NULL,
	"cause" 			varchar(25) NULL,
	PRIMARY KEY ("employee", "injury_date", "injury_type", "body_part")
)
go
CREATE TABLE dbo."injury_types"
(
	"injury_type"   		varchar(25) NOT NULL,
	"injury_type_description"       text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("injury_type")
)
go
CREATE TABLE dbo."pyhr_divisions"
(
	"division"      		varchar(25) NOT NULL,
	"division_description"  	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("division")
)
go
CREATE TABLE dbo."t4a_definition_basis"
(
	"t4_box"        		varchar(10) NOT NULL,
	"document"      		varchar(5) NOT NULL,
	"document_type" 		varchar(25) NOT NULL,
	"database_column"       	varchar(10) NULL,
	"operator"      		char(1) NULL,
	"payer" 			char(1) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"t4a_footnote_code"     	varchar(2) NULL,
	PRIMARY KEY ("t4_box", "document", "document_type", "payer")
)
go
CREATE TABLE dbo."time_card_headers"
(
	"payroll_cycle" 		varchar(25) NOT NULL,
	"time_card_group"       	varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"approved"      		char(1) NULL,
	"date_submitted"        	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"begin_payroll_date"    	datetime NULL,
	PRIMARY KEY ("payroll_cycle", "time_card_group", "payroll_date")
)
go
CREATE TABLE dbo."po_scoreboard_notes"
(
	"purchase_order"        	varchar(25) NOT NULL,
	"note_date"     		datetime NOT NULL,
	"purchase_order_note"   	text NULL,
	"follow_up_date"        	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	char(25) NULL,
	PRIMARY KEY ("purchase_order", "note_date")
)
go
CREATE TABLE dbo."expense_types"
(
	"expense_type"  		varchar(25) NOT NULL,
	"expense_type_description"      text NULL,
	"ledger"        		varchar(40) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("expense_type")
)
go
CREATE TABLE dbo."expenses_header"
(
	"expense_report"        	varchar(25) NOT NULL,
	"vendor"        		varchar(25) NULL,
	"expense_report_date"   	datetime NULL,
	"reason"        		text NULL,
	"fiscal_year"   		varchar(5) NULL,
	"buy_unit"      		varchar(25) NULL,
	"pay_unit"      		varchar(25) NULL,
	"status"        		char(1) NULL,
	"ledger"        		varchar(40) NULL,
	"gl_date"       		datetime NULL,
	"period"        		smallint NULL,
	"gl_entry"      		varchar(25) NULL,
	"currency"      		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"batch" 			varchar(25) NULL,
	"email_notification"    	char(1) NULL,
	"invoice_cm"    		varchar(25) NULL,
	"inv_cm_date"   		datetime NULL,
	"pay_vendor"    		varchar(25) NULL,
	"received_date" 		datetime NULL,
	"due_date"      		datetime NULL,
	"discount_date" 		datetime NULL,
	"inv_cm_gl_date"        	datetime NULL,
	"inv_cm_period" 		smallint NULL,
	"inv_cm_fiscal_year"    	varchar(5) NULL,
	"terms" 			varchar(25) NULL,
	"inv_cm_batch"  		varchar(25) NULL,
	"purchase_order"        	varchar(25) NULL,
	"approver"      		varchar(25) NULL,
	"approved"      		char(1) NULL,
	"bank_alias"    		varchar(25) NULL,
	"document_class"        	varchar(25) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"discount_ledger_account_code"  varchar(50) NULL,
	"inv_cm_gl_entry"       	varchar(25) NULL,
	"hold_inv_cm"   		char(1) NULL,
	"separate_check"        	char(1) NULL,
	"direct_deposit"        	char(1) NULL,
	"check_message" 		text NULL,
	"intercompany"  		char(1) NULL,
	"inv_cm_ledger" 		varchar(40) NULL,
	"pay_vendor_name"       	varchar(40) NULL,
	"pay_vendor_name_2"     	varchar(40) NULL,
	"pay_address_1" 		varchar(50) NULL,
	"pay_address_2" 		varchar(50) NULL,
	"pay_address_3" 		varchar(50) NULL,
	"pay_city"      		varchar(25) NULL,
	"pay_state"     		varchar(25) NULL,
	"pay_postal_code"       	varchar(10) NULL,
	"pay_country"   		varchar(50) NULL,
	"inv_cm_flag"   		char(1) NULL,
	"expense_amount"        	numeric(18,6) NULL,
	"reimbursed_amount"     	numeric(18,6) NULL,
	"created_by"    		varchar(25) NULL,
	PRIMARY KEY ("expense_report")
)
go
CREATE TABLE dbo."expenses_items"
(
	"expense_report"        	varchar(25) NOT NULL,
	"expense_line"  		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"activity_date" 		datetime NULL,
	"expense_type"  		varchar(25) NULL,
	"expense_description"   	text NULL,
	"expense_amount"        	numeric(18,6) NULL,
	"reimbursed_amount"     	numeric(18,6) NULL,
	"receipt"       		char(1) NULL,
	"charge_card_memo"      	varchar(25) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"expense_analysis"      	varchar(25) NULL,
	"location"      		varchar(50) NULL,
	"purpose"       		varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("expense_report", "expense_line")
)
go
CREATE TABLE dbo."ar_recurring_invoices"
(
	"document"      		varchar(25) NOT NULL,
	"suffix"        		varchar(25) NULL,
	"frequency"     		varchar(25) NULL,
	"end_date"      		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("document")
)
go
CREATE TABLE dbo."ar_customer_attributes"
(
	"customer"      		varchar(25) NOT NULL,
	"text_1"        		varchar(25) NULL,
	"text_2"        		varchar(25) NULL,
	"text_3"        		varchar(25) NULL,
	"text_4"        		varchar(25) NULL,
	"text_5"        		varchar(25) NULL,
	"text_6"        		varchar(25) NULL,
	"text_7"        		varchar(25) NULL,
	"text_8"        		varchar(25) NULL,
	"text_9"        		varchar(25) NULL,
	"text_10"       		varchar(25) NULL,
	"text_11"       		varchar(25) NULL,
	"text_12"       		varchar(25) NULL,
	"text_13"       		varchar(25) NULL,
	"text_14"       		varchar(25) NULL,
	"text_15"       		varchar(25) NULL,
	"text_16"       		varchar(25) NULL,
	"text_17"       		varchar(25) NULL,
	"text_18"       		varchar(25) NULL,
	"text_19"       		varchar(25) NULL,
	"text_20"       		varchar(25) NULL,
	"integer_1"     		integer NULL,
	"integer_2"     		integer NULL,
	"integer_3"     		integer NULL,
	"integer_4"     		integer NULL,
	"integer_5"     		integer NULL,
	"numeric_1"     		numeric(18,6) NULL,
	"numeric_2"     		numeric(18,6) NULL,
	"numeric_3"     		numeric(18,6) NULL,
	"numeric_4"     		numeric(18,6) NULL,
	"numeric_5"     		numeric(18,6) NULL,
	"date_1"        		datetime NULL,
	"date_2"        		datetime NULL,
	"date_3"        		datetime NULL,
	"date_4"        		datetime NULL,
	"date_5"        		datetime NULL,
	"date_6"        		datetime NULL,
	"date_7"        		datetime NULL,
	"date_8"        		datetime NULL,
	"date_9"        		datetime NULL,
	"date_10"       		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("customer")
)
go
CREATE TABLE dbo."vendor_attributes"
(
	"vendor"        		varchar(25) NOT NULL,
	"text_1"        		varchar(25) NULL,
	"text_2"        		varchar(25) NULL,
	"text_3"        		varchar(25) NULL,
	"text_4"        		varchar(25) NULL,
	"text_5"        		varchar(25) NULL,
	"text_6"        		varchar(25) NULL,
	"text_7"        		varchar(25) NULL,
	"text_8"        		varchar(25) NULL,
	"text_9"        		varchar(25) NULL,
	"text_10"       		varchar(25) NULL,
	"text_11"       		varchar(25) NULL,
	"text_12"       		varchar(25) NULL,
	"text_13"       		varchar(25) NULL,
	"text_14"       		varchar(25) NULL,
	"text_15"       		varchar(25) NULL,
	"text_16"       		varchar(25) NULL,
	"text_17"       		varchar(25) NULL,
	"text_18"       		varchar(25) NULL,
	"text_19"       		varchar(25) NULL,
	"text_20"       		varchar(25) NULL,
	"integer_1"     		integer NULL,
	"integer_2"     		integer NULL,
	"integer_3"     		integer NULL,
	"integer_4"     		integer NULL,
	"integer_5"     		integer NULL,
	"numeric_1"     		numeric(18,6) NULL,
	"numeric_2"     		numeric(18,6) NULL,
	"numeric_3"     		numeric(18,6) NULL,
	"numeric_4"     		numeric(18,6) NULL,
	"numeric_5"     		numeric(18,6) NULL,
	"date_1"        		datetime NULL,
	"date_2"        		datetime NULL,
	"date_3"        		datetime NULL,
	"date_4"        		datetime NULL,
	"date_5"        		datetime NULL,
	"date_6"        		datetime NULL,
	"date_7"        		datetime NULL,
	"date_8"        		datetime NULL,
	"date_9"        		datetime NULL,
	"date_10"       		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("vendor")
)
go
CREATE TABLE dbo."PrintQueue_Object"
(
	"ID"    			integer NOT NULL IDENTITY(1, 1),
	"PrintQueueName"        	varchar(50) NULL,
	"Status"        		smallint NULL,
	"Serial"        		integer NULL,
	"LabelFormat"   		varchar(50) NULL,
	PRIMARY KEY ("ID")
)
go
CREATE TABLE dbo."FT_CycleCountHeaders"
(
	"CC_ID" 			integer NOT NULL IDENTITY(1, 1),
	"CC_BeginDT"    		datetime NULL,
	"CC_EndDT"      		datetime NULL,
	PRIMARY KEY ("CC_ID")
)
go
CREATE TABLE dbo."FT_CycleCountBeginInventory"
(
	"CCBI_ID"       		integer NOT NULL IDENTITY(1, 1),
	"CCBI_CCID"     		integer NOT NULL,
	"CCBI_Serial"   		integer NOT NULL,
	"CCBI_Part"     		varchar(25) NULL,
	"CCBI_Quantity" 		numeric(20,6) NULL,
	PRIMARY KEY ("CCBI_ID")
)
go
ALTER TABLE dbo."FT_CycleCountBeginInventory" ADD UNIQUE ( "CCBI_CCID", "CCBI_Serial"
)
go
CREATE TABLE dbo."FT_CycleCountFoundInventory"
(
	"CCFI_ID"       		integer NOT NULL IDENTITY(1, 1),
	"CCFI_CCID"     		integer NOT NULL,
	"CCFI_User"     		varchar(10) NULL,
	"CCFI_Serial"   		integer NOT NULL,
	"CCFI_Part"     		varchar(25) NULL,
	"CCFI_QtyEntered"       	numeric(20,6) NULL,
	"CCFI_QtySystem"        	numeric(20,6) NULL,
	PRIMARY KEY ("CCFI_ID")
)
go
ALTER TABLE dbo."FT_CycleCountFoundInventory" ADD UNIQUE ( "CCFI_CCID", "CCFI_Serial"
)
go
CREATE TABLE dbo."SyntaxFromSQL"
(
	"SPID"  			integer NOT NULL DEFAULT @@spid,
	PRIMARY KEY ("SPID")
)
go
CREATE TABLE dbo."temp_scanned_to_be_del"
(
	"PartScanned"   		varchar(25) NOT NULL
)
go

CREATE TABLE dbo."CountriesWorld"
(
	"CountryCode"   		char(2) NOT NULL,
	"CountryName"   		varchar(50) NULL,
	PRIMARY KEY ("CountryCode")
)
go
CREATE TABLE dbo."States"
(
	"StateCode"     		char(2) NOT NULL,
	"StateName"     		varchar(50) NULL,
	PRIMARY KEY ("StateCode")
)
go
CREATE TABLE dbo."po_releases"
(
	"purchase_order"        	varchar(25) NOT NULL,
	"po_release"    		varchar(25) NOT NULL,
	"po_release_id" 		varchar(40) NULL,
	"release_date"  		datetime NULL,
	"printed"       		char(1) NULL,
	"status"        		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("purchase_order", "po_release")
)
go
CREATE TABLE dbo."po_blanket_items"
(
	"purchase_order"        	varchar(25) NOT NULL,
	"blanket_line"  		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"line_type"     		varchar(2) NULL,
	"item"  			varchar(50) NULL,
	"item_description"      	text NULL,
	"vendors_item"  		varchar(50) NULL,
	"receiver"      		char(1) NULL,
	"invoice"       		char(1) NULL,
	"tax_1" 			varchar(25) NULL,
	"tax_2" 			varchar(25) NULL,
	"freight_carrier"       	varchar(25) NULL,
	"expense_analysis"      	varchar(25) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"variance_ledger_account"       varchar(50) NULL,
	"cost_account"  		varchar(25) NULL,
	"max_quantity_ordered"  	numeric(18,6) NULL,
	"purchasing_uom"        	varchar(25) NULL,
	"po_pricing_uom"        	varchar(25) NULL,
	"purchasing_to_po_pricing_conv" numeric(18,6) NULL,
	"po_quantity_uom_to_standard"   numeric(18,6) NULL,
	"max_price"     		numeric(18,6) NULL,
	"max_extended_amount"   	numeric(18,6) NULL,
	"inventoried"   		char(1) NULL,
	"cum_quantity_ordered"  	numeric(18,6) NULL,
	"cum_extended_amount"   	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"package_uom"   		varchar(25) NULL,
	"package_uom_to_purchasing"     numeric(18,6) NULL,
	"package_label_name"    	varchar(25) NULL,
	PRIMARY KEY ("purchase_order", "blanket_line")
)
go
CREATE TABLE dbo."user_secured_columns_temp"
(
	"security_id"   		varchar(25) NOT NULL,
	"secured_column_name"   	varchar(40) NOT NULL,
	"valid_values"  		text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"active_inactive"       	char(1) NULL
)
go
CREATE TABLE dbo."preferences_site_backup"
(
	"preference"    		varchar(50) NOT NULL,
	"value" 			varchar(100) NULL,
	"user_changeable"       	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL
)
go
CREATE TABLE dbo."absence_schedule_by_employee"
(
	"employee"      		varchar(25) NOT NULL,
	"week_start_date"       	datetime NOT NULL,
	"work_date"     		datetime NOT NULL,
	"row_id"        		varchar(25) NOT NULL,
	"pay_type"      		varchar(25) NOT NULL,
	"hours" 			numeric(18,6) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"note"  			text NULL,
	PRIMARY KEY ("employee", "week_start_date", "work_date", "row_id", "pay_type")
)
go
CREATE TABLE dbo."absence_schedule_headers"
(
	"employee"      		varchar(25) NOT NULL,
	"week_start_date"       	datetime NOT NULL,
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"approved"      		char(1) NULL,
	"date_submitted"        	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("employee", "week_start_date")
)
go
CREATE TABLE dbo."account_mapping"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"old_account"   		varchar(50) NOT NULL,
	"old_account_description"       varchar(100) NULL,
	"ledger_account"        	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "old_account")
)
go
CREATE TABLE dbo."allocations"
(
	"allocation"    		varchar(25) NOT NULL,
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(25) NOT NULL,
	"active_inactive"       	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("allocation", "fiscal_year", "ledger")
)
go
CREATE TABLE dbo."api_gl_cost_headers"
(
	"document_type" 		varchar(25) NOT NULL,
	"document_id1"  		varchar(25) NOT NULL,
	"document_id2"  		varchar(25) NOT NULL,
	"document_id3"  		varchar(25) NOT NULL,
	"approved"      		char(1) NULL,
	"balance_name"  		varchar(25) NULL,
	"currency"      		varchar(25) NULL,
	"document_amount"       	numeric(18,6) NULL,
	"document_date" 		datetime NULL,
	"document_reference1"   	varchar(50) NULL,
	"document_reference2"   	varchar(50) NULL,
	"document_remarks"      	text NULL,
	"document_source"       	varchar(25) NULL,
	"fiscal_year"   		varchar(5) NULL,
	"gl_date"       		datetime NULL,
	"gl_entry"      		varchar(25) NULL,
	"ledger"        		varchar(40) NULL,
	"ledger_amount" 		numeric(18,6) NULL,
	"period"        		smallint NULL,
	"status"        		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("document_type", "document_id1", "document_id2", "document_id3")
)
go
CREATE TABLE dbo."api_gl_cost_items"
(
	"document_type" 		varchar(25) NOT NULL,
	"document_id1"  		varchar(25) NOT NULL,
	"document_id2"  		varchar(25) NOT NULL,
	"document_id3"  		varchar(25) NOT NULL,
	"document_line" 		smallint NOT NULL,
	"document_amount"       	numeric(18,6) NULL,
	"document_reference1"   	varchar(50) NULL,
	"document_reference2"   	varchar(50) NULL,
	"document_remarks"      	text NULL,
	"quantity"      		numeric(18,6) NULL,
	"unit_of_measure"       	varchar(25) NULL,
	"unit_cost"     		numeric(18,6) NULL,
	"sort_line"     		numeric(8,2) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("document_type", "document_id1", "document_id2", "document_id3", "document_line")
)
go
CREATE TABLE dbo."applicant_applied_positions"
(
	"applicant"     		varchar(25) NOT NULL,
	"position"      		varchar(25) NOT NULL,
	"applied_date"  		datetime NOT NULL,
	"position_comment"      	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"position_requisition"  	varchar(25) NOT NULL,
	"active_inactive"       	char(1) NULL,
	"status"        		varchar(25) NULL,
	"application"   		varchar(25) NULL,
	"approved"      		char(1) NULL,
	PRIMARY KEY ("applicant", "position_requisition")
)
go
CREATE TABLE dbo."applicant_attributes"
(
	"applicant"     		varchar(25) NOT NULL,
	"text_1"        		varchar(25) NULL,
	"text_2"        		varchar(25) NULL,
	"text_3"        		varchar(25) NULL,
	"text_4"        		varchar(25) NULL,
	"text_5"        		varchar(25) NULL,
	"text_6"        		varchar(25) NULL,
	"text_7"        		varchar(25) NULL,
	"text_8"        		varchar(25) NULL,
	"text_9"        		varchar(25) NULL,
	"text_10"       		varchar(25) NULL,
	"text_11"       		varchar(25) NULL,
	"text_12"       		varchar(25) NULL,
	"text_13"       		varchar(25) NULL,
	"text_14"       		varchar(25) NULL,
	"text_15"       		varchar(25) NULL,
	"text_16"       		varchar(25) NULL,
	"text_17"       		varchar(25) NULL,
	"text_18"       		varchar(25) NULL,
	"text_19"       		varchar(25) NULL,
	"text_20"       		varchar(25) NULL,
	"integer_1"     		integer NULL,
	"integer_2"     		integer NULL,
	"integer_3"     		integer NULL,
	"integer_4"     		integer NULL,
	"integer_5"     		integer NULL,
	"numeric_1"     		numeric(18,6) NULL,
	"numeric_2"     		numeric(18,6) NULL,
	"numeric_3"     		numeric(18,6) NULL,
	"numeric_4"     		numeric(18,6) NULL,
	"numeric_5"     		numeric(18,6) NULL,
	"date_1"        		datetime NULL,
	"date_2"        		datetime NULL,
	"date_3"        		datetime NULL,
	"date_4"        		datetime NULL,
	"date_5"        		datetime NULL,
	"date_6"        		datetime NULL,
	"date_7"        		datetime NULL,
	"date_8"        		datetime NULL,
	"date_9"        		datetime NULL,
	"date_10"       		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("applicant")
)
go
CREATE TABLE dbo."applicant_certificates"
(
	"applicant"     		varchar(25) NOT NULL,
	"certificate"   		varchar(25) NOT NULL,
	"certificate_date"      	datetime NOT NULL,
	"expire_date"   		datetime NULL,
	"rating"        		numeric(18,6) NULL,
	"certificate_comment"   	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"cert_identity" 		integer NOT NULL IDENTITY(1, 1),
	PRIMARY KEY ("applicant", "certificate", "certificate_date", "cert_identity")
)
go
CREATE TABLE dbo."applicant_decisions"
(
	"applicant"     		varchar(25) NOT NULL,
	"decision_date" 		datetime NULL,
	"decision"      		varchar(25) NULL,
	"decision_comment"      	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"position_requisition"  	varchar(25) NOT NULL,
	PRIMARY KEY ("applicant", "position_requisition")
)
go
CREATE TABLE dbo."applicant_degrees"
(
	"applicant"     		varchar(25) NOT NULL,
	"entry_date"    		datetime NOT NULL,
	"degree"        		varchar(25) NULL,
	"institution"   		varchar(50) NULL,
	"area_of_study" 		varchar(50) NULL,
	"date_graduated"        	datetime NULL,
	"degree_comment"        	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"degree_identity"       	integer NOT NULL IDENTITY(1, 1),
	PRIMARY KEY ("applicant", "entry_date", "degree_identity")
)
go
CREATE TABLE dbo."applicant_interviews"
(
	"applicant"     		varchar(25) NOT NULL,
	"interviewer"   		varchar(25) NOT NULL,
	"interview_date"        	datetime NOT NULL,
	"interview_time"        	datetime NOT NULL,
	"completed_date"        	datetime NULL,
	"rating"        		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"interview_comment"     	text NULL,
	"position_requisition"  	varchar(25) NOT NULL,
	PRIMARY KEY ("applicant", "interviewer", "interview_date", "interview_time", "position_requisition")
)
go
CREATE TABLE dbo."applicant_references"
(
	"applicant"     		varchar(25) NOT NULL,
	"company"       		varchar(50) NOT NULL,
	"phone" 			varchar(25) NOT NULL,
	"contact"       		varchar(50) NOT NULL,
	"reference_comments"    	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("applicant", "company", "phone", "contact")
)
go
CREATE TABLE dbo."applicant_scoreboard_notes"
(
	"applicant"     		varchar(25) NOT NULL,
	"position_requisition"  	varchar(25) NOT NULL,
	"note_date"     		datetime NOT NULL,
	"note"  			text NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"follow_up_date"        	datetime NULL,
	PRIMARY KEY ("applicant", "position_requisition", "note_date")
)
go
CREATE TABLE dbo."applicant_sources"
(
	"applicant_source"      	varchar(25) NOT NULL,
	"description"   		varchar(250) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("applicant_source")
)
go
CREATE TABLE dbo."applicant_work_history"
(
	"applicant"     		varchar(25) NOT NULL,
	"position"      		varchar(25) NOT NULL,
	"begin_date"    		datetime NOT NULL,
	"end_date"      		datetime NULL,
	"company"       		varchar(50) NULL,
	"employer"      		varchar(50) NULL,
	"salary"        		numeric(18,6) NULL,
	"position_comment"      	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("applicant", "position", "begin_date")
)
go
CREATE TABLE dbo."applicants"
(
	"applicant"     		varchar(25) NOT NULL,
	"applicant_last_name"   	varchar(50) NULL,
	"applicant_first_name"  	varchar(50) NULL,
	"applicant_source"      	varchar(25) NULL,
	"address_id"    		varchar(25) NULL,
	"social_security_number"        varchar(11) NULL,
	"home_phone"    		varchar(25) NULL,
	"office_phone"  		varchar(25) NULL,
	"email_address" 		varchar(250) NULL,
	"birth_date"    		datetime NULL,
	"gender"        		char(1) NULL,
	"race"  			char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	"address_2_id"  		varchar(25) NULL,
	"ipeds_ethnic_hispanic" 	char(1) NULL,
	"ipeds_race_white"      	char(1) NULL,
	"ipeds_race_black"      	char(1) NULL,
	"ipeds_race_asian"      	char(1) NULL,
	"ipeds_race_indian"     	char(1) NULL,
	"ipeds_race_hawaiian"   	char(1) NULL,
	"ipeds_non_resident_alien"      char(1) NULL,
	PRIMARY KEY ("applicant")
)
go
CREATE TABLE dbo."applications"
(
	"application"   		varchar(25) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(50) NULL,
	"active_inactive"       	varchar(25) NULL,
	"application_description"       varchar(50) NULL,
	PRIMARY KEY ("application")
)
go
CREATE TABLE dbo."application_answers"
(
	"position_requisition"  	varchar(25) NOT NULL,
	"applicant"     		varchar(25) NOT NULL,
	"question_id"   		varchar(25) NOT NULL,
	"question_answer"       	varchar(400) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"application"   		varchar(25) NOT NULL,
	PRIMARY KEY ("position_requisition", "applicant", "question_id", "application")
)
go
CREATE TABLE dbo."application_forms"
(
	"application"   		varchar(25) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(50) NULL,
	"active_inactive"       	varchar(25) NULL,
	"application_form_description"  varchar(50) NULL,
	PRIMARY KEY ("application")
)
go
CREATE TABLE dbo."application_questions"
(
	"application"   		varchar(25) NOT NULL,
	"question_id"   		varchar(25) NOT NULL,
	"question_page" 		integer NULL,
	"line_no"       		integer NULL,
	"question_text" 		varchar(400) NULL,
	"active_inactive"       	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"validate_style"        	char(1) NULL,
	"validate_object"       	varchar(400) NULL,
	"answer_required"       	char(1) NULL,
	PRIMARY KEY ("application", "question_id")
)
go
CREATE TABLE dbo."ar_customer_programs"
(
	"customer"      		varchar(25) NOT NULL,
	"program"       		varchar(25) NOT NULL,
	"enroll_date"   		datetime NULL,
	"cancel_date"   		datetime NULL,
	"active_inactive"       	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"ship_to_location"      	varchar(25) NULL,
	"document_comments"     	text NULL,
	"inventory_location"    	varchar(25) NULL,
	"include_freight"       	char(1) NULL,
	"program_identity"      	integer NOT NULL IDENTITY(1, 1),
	"pos_security_id"       	varchar(25) NULL,
	PRIMARY KEY ("customer", "program", "program_identity")
)
go
CREATE TABLE dbo."ar_lease_documents"
(
	"lease" 			varchar(25) NOT NULL,
	"lease_document_identity"       integer NOT NULL IDENTITY(1, 1),
	"lease_document_type"   	varchar(25) NULL,
	"document_start_date"   	datetime NULL,
	"document_expire_date"  	datetime NULL,
	"document_notify_date"  	datetime NULL,
	"document_reference"    	varchar(50) NULL,
	"document_remarks"      	text NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"lease_document_status" 	varchar(25) NULL,
	PRIMARY KEY ("lease", "lease_document_identity")
)
go
CREATE TABLE dbo."ar_lease_items"
(
	"lease" 			varchar(25) NOT NULL,
	"lease_item_identity"   	integer NOT NULL IDENTITY(1, 1),
	"item"  			varchar(25) NOT NULL,
	"item_description"      	text NULL,
	"quantity"      		numeric(18,6) NULL,
	"item_price"    		numeric(18,6) NULL,
	"extended_amount"       	numeric(18,6) NULL,
	"selling_uom"   		varchar(25) NULL,
	"ledger_account_code"   	varchar(25) NULL,
	"sort_line"     		smallint NULL,
	"cost_account"  		varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	"taxable_1"     		char(1) NULL,
	"taxable_2"     		char(1) NULL,
	"begin_date"    		datetime NULL,
	"end_date"      		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"lease_space"   		varchar(25) NULL,
	PRIMARY KEY ("lease", "lease_item_identity")
)
go
CREATE TABLE dbo."ar_lease_notes"
(
	"lease" 			varchar(25) NOT NULL,
	"note_date"     		datetime NOT NULL,
	"note"  			text NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"follow_up_date"        	datetime NULL,
	PRIMARY KEY ("lease", "note_date")
)
go
CREATE TABLE dbo."ar_leases"
(
	"lease" 			varchar(25) NOT NULL,
	"lease_description"     	text NULL,
	"ship_customer" 		varchar(25) NULL,
	"frequency"     		varchar(25) NULL,
	"lease_original_date"   	datetime NULL,
	"lease_start_date"      	datetime NULL,
	"lease_expire_date"     	datetime NULL,
	"lease_notify_date"     	datetime NULL,
	"rate_expire_date"      	datetime NULL,
	"rate_notify_date"      	datetime NULL,
	"active_inactive"       	char(1) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"ship_to_location"      	varchar(25) NULL,
	"document_comments"     	text NULL,
	"invoice_cycle" 		varchar(25) NULL,
	"monday_flag"   		char(1) NULL,
	"tuesday_flag"  		char(1) NULL,
	"wednesday_flag"        	char(1) NULL,
	"thursday_flag" 		char(1) NULL,
	"friday_flag"   		char(1) NULL,
	"saturday_flag" 		char(1) NULL,
	"sunday_flag"   		char(1) NULL,
	PRIMARY KEY ("lease")
)
go
CREATE TABLE dbo."ar_program_event_items"
(
	"program"       		varchar(25) NOT NULL,
	"program_event" 		varchar(25) NOT NULL,
	"item"  			varchar(25) NOT NULL,
	"quantity"      		numeric(18,6) NULL,
	"ledger_account_code"   	varchar(25) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"sort_line"     		smallint NULL,
	"cost_account"  		varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	"taxable_1"     		char(1) NULL,
	"taxable_2"     		char(1) NULL,
	"freight"       		char(1) NULL,
	PRIMARY KEY ("program", "program_event", "item")
)
go
CREATE TABLE dbo."ar_program_events"
(
	"program"       		varchar(25) NOT NULL,
	"program_event" 		varchar(25) NOT NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"shipping_handling_amount"      numeric(18,6) NULL,
	"program_event_description"     varchar(50) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("program", "program_event")
)
go
CREATE TABLE dbo."ar_programs"
(
	"program"       		varchar(25) NOT NULL,
	"program_description"   	varchar(50) NULL,
	"active_inactive"       	char(1) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("program")
)
go
CREATE TABLE dbo."arrear_transactions"
(
	"employee"      		varchar(25) NOT NULL,
	"document"      		varchar(25) NOT NULL,
	"document_type" 		varchar(25) NOT NULL,
	"arrear_line"   		integer NOT NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"amount"        		numeric(18,6) NULL,
	"transaction_type"      	varchar(25) NULL,
	"transaction_date"      	datetime NULL,
	"transaction_reference" 	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("employee", "document", "document_type", "arrear_line")
)
go
CREATE TABLE dbo."awards"
(
	"award" 			varchar(25) NOT NULL,
	"award_type"    		char(1) NOT NULL,
	"award_description"     	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("award", "award_type")
)
go
CREATE TABLE dbo."bank_register_items"
(
	"bank_alias"    		varchar(25) NOT NULL,
	"document_class"        	varchar(25) NOT NULL,
	"document_number"       	integer NOT NULL,
	"check_void_nsf"        	char(1) NOT NULL,
	"document_line" 		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"unit_of_measure"       	varchar(25) NULL,
	"quantity"      		numeric(18,6) NULL,
	"document_amount"       	numeric(18,6) NULL,
	"document_reference1"   	varchar(50) NULL,
	"document_reference2"   	varchar(50) NULL,
	"document_remarks"      	text NULL,
	"unit_cost"     		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("bank_alias", "document_class", "document_number", "check_void_nsf", "document_line")
)
go
CREATE TABLE dbo."benefit_adjustments"
(
	"employee"      		varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"entry_datetime"        	datetime NOT NULL,
	"payroll_cycle" 		varchar(25) NULL,
	"benefit_type"  		varchar(25) NULL,
	"amount"        		numeric(18,6) NULL,
	"basis" 			numeric(18,6) NULL,
	"unit"  			varchar(25) NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"check_sequence"        	smallint NULL,
	"voucher"       		varchar(25) NULL,
	"check_void"    		char(1) NULL,
	"status"        		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"arrear_calculation_id" 	varchar(25) NULL,
	"arrear_voucher"        	varchar(25) NULL,
	"basis_hours"   		numeric(18,6) NULL,
	"adjustment_identity"   	integer NOT NULL IDENTITY(1, 1),
	"cr_ledger_account_code"        varchar(50) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"cost_account_code"     	varchar(25) NULL,
	"cr_cost_account_code"  	varchar(25) NULL,
	PRIMARY KEY ("employee", "payroll_date", "entry_datetime", "adjustment_identity")
)
go
CREATE TABLE dbo."benefit_basis"
(
	"benefit"       		varchar(25) NOT NULL,
	"basis_document"        	varchar(5) NOT NULL,
	"basis_document_type"   	varchar(25) NOT NULL,
	"basis_operator"        	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("benefit", "basis_document", "basis_document_type")
)
go
CREATE TABLE dbo."benefit_rates"
(
	"benefit"       		varchar(25) NOT NULL,
	"age_years"     		smallint NOT NULL,
	"age_months"    		smallint NOT NULL,
	"rate_id"       		varchar(25) NULL,
	"rate_event"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"rate_unit"     		smallint NULL,
	PRIMARY KEY ("benefit", "age_years", "age_months")
)
go
CREATE TABLE dbo."benefits"
(
	"benefit_type"  		varchar(25) NOT NULL,
	"benefit_description"   	varchar(50) NULL,
	"check_stub_description"        varchar(50) NULL,
	"employment_types"      	varchar(250) NULL,
	"eligibility_hire_seniority"    varchar(25) NULL,
	"eligibility_years"     	smallint NULL,
	"eligibility_months"    	smallint NULL,
	"eligibility_days"      	smallint NULL,
	"enrollment_month"      	smallint NULL,
	"enrollment_day"        	smallint NULL,
	"automatic_enrollment"  	char(1) NULL,
	"priority"      		smallint NULL,
	"arrear"        		char(1) NULL,
	"vendor"        		varchar(25) NULL,
	"item"  			varchar(25) NULL,
	"number_selections_per_year"    smallint NULL,
	"recalc_as_of_month"    	smallint NULL,
	"recalc_as_of_day"      	smallint NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"basis_factor"  		numeric(18,6) NULL,
	"basis_adjustment"      	numeric(18,6) NULL,
	"basis_round"   		varchar(10) NULL,
	"basis_round_unit"      	smallint NULL,
	"basis_maximum" 		numeric(18,6) NULL,
	"benefit_style" 		varchar(25) NULL,
	"payer" 			char(1) NULL,
	"ledger"        		varchar(40) NULL,
	"check_sequence"        	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"use_employee_pay_freq" 	char(1) NULL,
	"number_payments_per_year"      smallint NULL,
	"basis_style"   		varchar(25) NULL,
	"security_unit" 		varchar(25) NULL,
	"cost_based_on" 		char(1) NULL,
	"rate_id_scheme"        	varchar(25) NULL,
	"default_rate_event"    	varchar(25) NULL,
	"basis_minimum" 		numeric(18,6) NULL,
	"recalc_age_as_of_month"        smallint NULL,
	"recalc_age_as_of_day"  	smallint NULL,
	"recalc_age_update_flag"        char(1) NULL,
	"cost_account_code"     	varchar(25) NULL,
	"enrollment_style"      	varchar(25) NULL,
	"cr_cost_account_code"  	varchar(25) NULL,
	PRIMARY KEY ("benefit_type")
)
go
CREATE TABLE dbo."budget_api_gl_cost"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"organization_level"    	varchar(40) NOT NULL,
	"organization"  		varchar(40) NOT NULL,
	"balance_name"  		varchar(25) NOT NULL,
	"ledger_account"        	varchar(40) NOT NULL,
	"period"        		smallint NOT NULL,
	"amount"        		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "organization_level", "organization", "balance_name", "ledger_account", "period")
)
go
CREATE TABLE dbo."budget_items"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"organization_level"    	varchar(40) NOT NULL,
	"organization"  		varchar(40) NOT NULL,
	"balance_name"  		varchar(25) NOT NULL,
	"ledger_account"        	varchar(40) NOT NULL,
	"budget"        		numeric(18,6) NULL,
	"spread_rule"   		varchar(40) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "organization_level", "organization", "balance_name", "ledger_account")
)
go
CREATE TABLE dbo."budget_notes"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"ledger_account"        	varchar(50) NOT NULL,
	"note"  			text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "ledger_account")
)
go
CREATE TABLE dbo."calculation_adjustments"
(
	"employee"      		varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"entry_datetime"        	datetime NOT NULL,
	"payroll_cycle" 		varchar(25) NULL,
	"adjustment_code"       	varchar(25) NULL,
	"adjustment_document_type"      varchar(25) NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"check_sequence"        	smallint NULL,
	"voucher"       		varchar(25) NULL,
	"check_void"    		char(1) NULL,
	"status"        		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"adjustment_identity"   	integer NOT NULL IDENTITY(1, 1),
	PRIMARY KEY ("employee", "payroll_date", "entry_datetime", "adjustment_identity")
)
go
CREATE TABLE dbo."cert_training_enrollments"
(
	"certificate"   		varchar(25) NOT NULL,
	"class_date"    		datetime NOT NULL,
	"location"      		varchar(25) NOT NULL,
	"employee"      		varchar(25) NOT NULL,
	"enroll_date"   		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"graduated"     		char(1) NULL,
	"ceu_units"     		numeric(18,6) NULL,
	"class_hours"   		numeric(18,6) NULL,
	"starting_time" 		datetime NOT NULL,
	PRIMARY KEY ("certificate", "class_date", "location", "employee", "starting_time")
)
go
CREATE TABLE dbo."cert_training_schedules"
(
	"certificate"   		varchar(25) NOT NULL,
	"class_date"    		datetime NOT NULL,
	"location"      		varchar(25) NOT NULL,
	"class_size"    		integer NULL,
	"instructor"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"status"        		char(1) NULL,
	"starting_time" 		datetime NOT NULL,
	PRIMARY KEY ("certificate", "class_date", "location", "starting_time")
)
go
CREATE TABLE dbo."certificates"
(
	"certificate"   		varchar(25) NOT NULL,
	"description"   		varchar(250) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"curriculum"    		varchar(50) NULL,
	"ceu_units"     		numeric(18,6) NULL,
	"class_hours"   		numeric(18,6) NULL,
	"prerequisite"  		varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("certificate")
)
go
CREATE TABLE dbo."coa_headers"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"coa"   			varchar(40) NOT NULL,
	"active_inactive"       	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(50) NULL,
	PRIMARY KEY ("fiscal_year", "coa")
)
go
CREATE TABLE dbo."coa_items"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"coa"   			varchar(40) NOT NULL,
	"account"       		varchar(50) NOT NULL,
	"account_type"  		char(1) NOT NULL,
	"account_description"   	varchar(50) NULL,
	"account_level" 		smallint NULL,
	"balance_profit"        	char(1) NULL,
	"debit_credit_stat"     	char(1) NULL,
	"cash_flow_line"        	smallint NULL,
	"parent_account"        	varchar(40) NULL,
	"prior_year_purchases_account"  varchar(25) NULL,
	"sort_line"     		numeric(8,2) NULL,
	"wages_benefits"        	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(50) NULL,
	PRIMARY KEY ("fiscal_year", "coa", "account", "account_type")
)
go
CREATE TABLE dbo."cobra_responses"
(
	"employee"      		varchar(25) NOT NULL,
	"social_security"       	varchar(25) NOT NULL,
	"event" 			varchar(25) NOT NULL,
	"event_date"    		datetime NOT NULL,
	"enrolled"      		char(1) NULL,
	"ending_coverage_date"  	datetime NULL,
	"notify_date"   		datetime NULL,
	"response_date" 		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("employee", "social_security", "event", "event_date")
)
go
CREATE TABLE dbo."companies_eir"
(
	"eir_business_number"   	varchar(25) NOT NULL,
	"rate_id"       		varchar(25) NOT NULL,
	"company"       		varchar(25) NOT NULL,
	"business_number_description"   varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"contact_name"  		varchar(40) NULL,
	"contact_phone" 		varchar(15) NULL,
	"contact_extension"     	varchar(5) NULL,
	"rate_event"    		varchar(25) NULL,
	PRIMARY KEY ("eir_business_number")
)
go
CREATE TABLE dbo."company_state_filings"
(
	"company"       		varchar(25) NOT NULL,
	"state_id"      		varchar(2) NOT NULL,
	"taxpayer_id_number"    	varchar(25) NULL,
	"sui_percent"   		numeric(12,6) NULL,
	"contact_name"  		varchar(50) NULL,
	"contact_phone" 		varchar(15) NULL,
	"contact_extension"     	varchar(10) NULL,
	"employer_id_number"    	varchar(25) NULL,
	"seasonal_indicator"    	varchar(2) NULL,
	"remitter_number"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"rate_id"       		varchar(25) NULL,
	"rate_event"    		varchar(25) NULL,
	PRIMARY KEY ("company", "state_id")
)
go
CREATE TABLE dbo."cost_coa"
(
	"account"       		varchar(25) NOT NULL,
	"account_description"   	varchar(50) NULL,
	"profit_group"  		varchar(25) NULL,
	"profit_group_description"      varchar(50) NULL,
	"coa_level_1"   		varchar(25) NULL,
	"coa_level_2"   		varchar(25) NULL,
	"coa_level_3"   		varchar(25) NULL,
	"coa_level_4"   		varchar(25) NULL,
	"coa_level_5"   		varchar(25) NULL,
	"coa_level_6"   		varchar(25) NULL,
	"coa_level_7"   		varchar(25) NULL,
	"coa_level_8"   		varchar(25) NULL,
	"coa_level_9"   		varchar(25) NULL,
	"coa_level_10"  		varchar(25) NULL,
	"coa_level_1_description"       varchar(50) NULL,
	"coa_level_2_description"       varchar(50) NULL,
	"coa_level_3_description"       varchar(50) NULL,
	"coa_level_4_description"       varchar(50) NULL,
	"coa_level_5_description"       varchar(50) NULL,
	"coa_level_6_description"       varchar(50) NULL,
	"coa_level_7_description"       varchar(50) NULL,
	"coa_level_8_description"       varchar(50) NULL,
	"coa_level_9_description"       varchar(50) NULL,
	"coa_level_10_description"      varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"account_type"  		char(1) NULL,
	"coa"   			varchar(40) NOT NULL,
	PRIMARY KEY ("account", "coa")
)
go
CREATE TABLE dbo."cost_id_security"
(
	"user_id"       		varchar(25) NOT NULL,
	"cost_id"       		varchar(25) NOT NULL,
	PRIMARY KEY ("user_id", "cost_id")
)
go
CREATE TABLE dbo."cost_identifier_attributes"
(
	"cost_id"       		varchar(25) NOT NULL,
	"cost_sub"      		varchar(25) NOT NULL,
	"text_1"        		varchar(25) NULL,
	"text_2"        		varchar(25) NULL,
	"text_3"        		varchar(25) NULL,
	"text_4"        		varchar(25) NULL,
	"text_5"        		varchar(25) NULL,
	"text_6"        		varchar(25) NULL,
	"text_7"        		varchar(25) NULL,
	"text_8"        		varchar(25) NULL,
	"text_9"        		varchar(25) NULL,
	"text_10"       		varchar(25) NULL,
	"text_11"       		varchar(25) NULL,
	"text_12"       		varchar(25) NULL,
	"text_13"       		varchar(25) NULL,
	"text_14"       		varchar(25) NULL,
	"text_15"       		varchar(25) NULL,
	"text_16"       		varchar(25) NULL,
	"text_17"       		varchar(25) NULL,
	"text_18"       		varchar(25) NULL,
	"text_19"       		varchar(25) NULL,
	"text_20"       		varchar(25) NULL,
	"integer_1"     		integer NULL,
	"integer_2"     		integer NULL,
	"integer_3"     		integer NULL,
	"integer_4"     		integer NULL,
	"integer_5"     		integer NULL,
	"numeric_1"     		numeric(18,6) NULL,
	"numeric_2"     		numeric(18,6) NULL,
	"numeric_3"     		numeric(18,6) NULL,
	"numeric_4"     		numeric(18,6) NULL,
	"numeric_5"     		numeric(18,6) NULL,
	"date_1"        		datetime NULL,
	"date_2"        		datetime NULL,
	"date_3"        		datetime NULL,
	"date_4"        		datetime NULL,
	"date_5"        		datetime NULL,
	"date_6"        		datetime NULL,
	"date_7"        		datetime NULL,
	"date_8"        		datetime NULL,
	"date_9"        		datetime NULL,
	"date_10"       		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("cost_id", "cost_sub")
)
go
CREATE TABLE dbo."cost_identifier_classes"
(
	"cost_id_class" 		varchar(25) NOT NULL,
	"cost_id_class_description"     varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("cost_id_class")
)
go
CREATE TABLE dbo."cost_identifiers"
(
	"cost_id"       		varchar(25) NOT NULL,
	"description"   		text NULL,
	"start_date"    		datetime NULL,
	"closed_date"   		datetime NULL,
	"status"        		char(1) NULL,
	"percent_complete"      	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"cost_sub"      		varchar(25) NOT NULL,
	"customer"      		varchar(25) NULL,
	"fa_asset_id"   		varchar(50) NULL,
	"fa_unit"       		varchar(25) NULL,
	"fa_asset_class"        	varchar(25) NULL,
	"fa_asset_description"  	text NULL,
	"fa_asset_location"     	varchar(25) NULL,
	"fa_asset_group"        	varchar(25) NULL,
	"security_company"      	varchar(25) NULL,
	"coa"   			varchar(40) NULL,
	"cost_id_class" 		varchar(25) NULL,
	"grant_id"      		varchar(25) NULL,
	PRIMARY KEY ("cost_id", "cost_sub")
)
go
CREATE TABLE dbo."datawindow_formats"
(
	"datawindow_format"     	varchar(50) NOT NULL,
	"datawindow_name"       	varchar(50) NOT NULL,
	"column_name"   		varchar(50) NOT NULL,
	"display_order" 		smallint NULL,
	"column_heading"        	varchar(50) NULL,
	"column_width"  		smallint NULL,
	"column_enabled"        	char(1) NULL,
	"column_visible"        	char(1) NULL,
	"allow_visible_change"  	char(1) NULL,
	"allow_enabled_change"  	char(1) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"force_enabled_when_visible"    char(1) NULL,
	PRIMARY KEY ("datawindow_format", "datawindow_name", "column_name")
)
go
CREATE TABLE dbo."dd_foreign_banks"
(
	"dd_foreign_bank"       	varchar(25) NOT NULL,
	"dd_foreign_bank_name"  	varchar(50) NULL,
	"dd_foreign_bank_id"    	varchar(50) NULL,
	"address_id"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("dd_foreign_bank")
)
go
CREATE TABLE dbo."deduction_adjustments"
(
	"employee"      		varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"entry_datetime"        	datetime NOT NULL,
	"payroll_cycle" 		varchar(25) NULL,
	"deduction_type"        	varchar(25) NULL,
	"amount"        		numeric(18,6) NULL,
	"basis" 			numeric(18,6) NULL,
	"unit"  			varchar(25) NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"check_sequence"        	smallint NULL,
	"voucher"       		varchar(25) NULL,
	"check_void"    		char(1) NULL,
	"status"        		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"arrear_calculation_id" 	varchar(25) NULL,
	"arrear_voucher"        	varchar(25) NULL,
	"basis_hours"   		numeric(18,6) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"adjustment_identity"   	integer NOT NULL IDENTITY(1, 1),
	"cr_cost_account_code"  	varchar(25) NULL,
	PRIMARY KEY ("employee", "payroll_date", "entry_datetime", "adjustment_identity")
)
go
CREATE TABLE dbo."deduction_rate_basis"
(
	"deduction_type"        	varchar(25) NOT NULL,
	"basis_document"        	varchar(5) NOT NULL,
	"basis_document_type"   	varchar(25) NOT NULL,
	"basis_operator"        	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("deduction_type", "basis_document", "basis_document_type")
)
go
CREATE TABLE dbo."deduction_types"
(
	"deduction_type"        	varchar(25) NOT NULL,
	"deduction_type_description"    varchar(50) NULL,
	"check_stub_description"        varchar(50) NULL,
	"priority"      		smallint NULL,
	"arrear"        		char(1) NULL,
	"employee_ded_type_required"    char(1) NULL,
	"ledger"        		varchar(40) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"check_sequence"        	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"vendor"        		varchar(25) NULL,
	"item"  			varchar(25) NULL,
	"create_invoice_by"     	char(1) NULL,
	"security_unit" 		varchar(25) NULL,
	"rate_id_scheme"        	varchar(25) NULL,
	"default_rate_event"    	varchar(25) NULL,
	"deduction_style"       	varchar(25) NULL,
	"title_iii"     		char(1) NULL,
	"cr_cost_account_code"  	varchar(25) NULL,
	PRIMARY KEY ("deduction_type")
)
go
CREATE TABLE dbo."degrees"
(
	"degree"        		varchar(25) NOT NULL,
	"description"   		varchar(250) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("degree")
)
go
CREATE TABLE dbo."edi_file_imports"
(
	"edi_file_name" 		varchar(50) NOT NULL,
	"edi_received_datetime" 	datetime NOT NULL,
	"edi_document_number"   	varchar(25) NULL,
	"edi_control_number"    	varchar(50) NULL,
	"edi_customer"  		varchar(25) NULL,
	"edi_file_status"       	char(1) NULL,
	"edi_error_file"        	varchar(50) NULL,
	"edi_completed_datetime"        datetime NULL,
	"empower_batch" 		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"edi_error_message"     	varchar(250) NULL,
	PRIMARY KEY ("edi_file_name")
)
go
CREATE TABLE dbo."edi_planning_headers"
(
	"sales_order"   		varchar(25) NOT NULL,
	"so_release"    		varchar(25) NOT NULL,
	"last_ship_date"        	datetime NULL,
	"last_ship_qty" 		numeric(18,6) NULL,
	"cum_ytd_ship_qty"      	numeric(18,6) NULL,
	"cum_ytd_reqd_qty"      	numeric(18,6) NULL,
	"fab_qty"       		numeric(18,6) NULL,
	"fab_date"      		datetime NULL,
	"mat_qty"       		numeric(18,6) NULL,
	"mat_date"      		datetime NULL,
	"horizon_start_date"    	datetime NULL,
	"horizon_end_date"      	datetime NULL,
	"cum_start_date"        	datetime NULL,
	"cum_end_date"  		datetime NULL,
	"edi_planning_comment"  	varchar(400) NULL,
	"batch" 			varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("sales_order", "so_release")
)
go
CREATE TABLE dbo."edi_planning_items"
(
	"sales_order"   		varchar(25) NOT NULL,
	"so_release"    		varchar(25) NOT NULL,
	"line_no"       		integer NOT NULL,
	"req_type"      		char(1) NULL,
	"scheduled_date"        	datetime NULL,
	"scheduled_qty" 		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"scheduled_net_qty"     	numeric(18,6) NULL,
	PRIMARY KEY ("sales_order", "so_release", "line_no")
)
go
CREATE TABLE dbo."edi_ship_schedule_headers"
(
	"sales_order"   		varchar(25) NOT NULL,
	"so_release"    		varchar(25) NOT NULL,
	"last_ship_date"        	datetime NULL,
	"last_ship_qty" 		numeric(18,6) NULL,
	"cum_ytd_ship_qty"      	numeric(18,6) NULL,
	"cum_ytd_reqd_qty"      	numeric(18,6) NULL,
	"edi_ship_schedule_comment"     varchar(400) NULL,
	"batch" 			varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("sales_order", "so_release")
)
go
CREATE TABLE dbo."edi_ship_schedule_items"
(
	"sales_order"   		varchar(25) NOT NULL,
	"so_release"    		varchar(25) NOT NULL,
	"line_no"       		integer NOT NULL,
	"req_type"      		char(1) NULL,
	"scheduled_date"        	datetime NULL,
	"scheduled_qty" 		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"scheduled_net_qty"     	numeric(18,6) NULL
)
go
CREATE TABLE dbo."eeoc_classes"
(
	"eeoc_class"    		varchar(25) NOT NULL,
	"eeoc_description"      	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("eeoc_class")
)
go
CREATE TABLE dbo."eeoc_races"
(
	"eeoc_race"     		varchar(25) NOT NULL,
	"eeoc_reporting_type"   	varchar(25) NOT NULL,
	"eeoc_sort"     		smallint NULL,
	"eeoc_race_description" 	varchar(50) NULL,
	PRIMARY KEY ("eeoc_race", "eeoc_reporting_type")
)
go
CREATE TABLE dbo."employee_absences"
(
	"employee"      		varchar(25) NOT NULL,
	"pay_type"      		varchar(25) NOT NULL,
	"date_worked"   		datetime NOT NULL,
	"entry_date"    		datetime NOT NULL,
	"payroll_date"  		datetime NULL,
	"absence_comment"       	text NULL,
	"supervisor"    		text NULL,
	"hours" 			numeric(18,6) NULL,
	"cost"  			numeric(18,6) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"absence_identity"      	integer NOT NULL IDENTITY(1, 1),
	"time_card_identity"    	integer NULL,
	PRIMARY KEY ("employee", "pay_type", "date_worked", "entry_date", "absence_identity")
)
go
CREATE TABLE dbo."employee_attributes"
(
	"employee"      		varchar(25) NOT NULL,
	"text_1"        		varchar(25) NULL,
	"text_2"        		varchar(25) NULL,
	"text_3"        		varchar(25) NULL,
	"text_4"        		varchar(25) NULL,
	"text_5"        		varchar(25) NULL,
	"text_6"        		varchar(25) NULL,
	"text_7"        		varchar(25) NULL,
	"text_8"        		varchar(25) NULL,
	"text_9"        		varchar(25) NULL,
	"text_10"       		varchar(25) NULL,
	"text_11"       		varchar(25) NULL,
	"text_12"       		varchar(25) NULL,
	"text_13"       		varchar(25) NULL,
	"text_14"       		varchar(25) NULL,
	"text_15"       		varchar(25) NULL,
	"text_16"       		varchar(25) NULL,
	"text_17"       		varchar(25) NULL,
	"text_18"       		varchar(25) NULL,
	"text_19"       		varchar(25) NULL,
	"text_20"       		varchar(25) NULL,
	"integer_1"     		integer NULL,
	"integer_2"     		integer NULL,
	"integer_3"     		integer NULL,
	"integer_4"     		integer NULL,
	"integer_5"     		integer NULL,
	"numeric_1"     		numeric(18,6) NULL,
	"numeric_2"     		numeric(18,6) NULL,
	"numeric_3"     		numeric(18,6) NULL,
	"numeric_4"     		numeric(18,6) NULL,
	"numeric_5"     		numeric(18,6) NULL,
	"date_1"        		datetime NULL,
	"date_2"        		datetime NULL,
	"date_3"        		datetime NULL,
	"date_4"        		datetime NULL,
	"date_5"        		datetime NULL,
	"date_6"        		datetime NULL,
	"date_7"        		datetime NULL,
	"date_8"        		datetime NULL,
	"date_9"        		datetime NULL,
	"date_10"       		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("employee")
)
go
CREATE TABLE dbo."employee_awards"
(
	"employee"      		varchar(25) NOT NULL,
	"award_date"    		datetime NOT NULL,
	"award_type"    		char(1) NOT NULL,
	"award" 			varchar(25) NOT NULL,
	"reason"        		varchar(25) NULL,
	"award_comment" 		text NULL,
	"unit"  			varchar(25) NULL,
	"division"      		varchar(25) NULL,
	"location"      		varchar(25) NULL,
	"followup_date" 		datetime NULL,
	"followup_comment"      	text NULL,
	"supervisor"    		varchar(25) NULL,
	"end_date"      		datetime NULL,
	"expire_date"   		datetime NULL,
	"union_rep"     		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"employee_awards_identity"      numeric(18,0) NOT NULL IDENTITY(1, 1),
	PRIMARY KEY ("employee", "award_date", "award_type", "award", "employee_awards_identity")
)
go
CREATE TABLE dbo."employee_benefits"
(
	"employee"      		varchar(25) NOT NULL,
	"benefit"       		varchar(25) NOT NULL,
	"begin_date"    		datetime NULL,
	"end_date"      		datetime NULL,
	"basis" 			numeric(18,6) NULL,
	"amount"        		numeric(18,6) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"check_sequence"        	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"rate_id"       		varchar(25) NULL,
	"rate_event"    		varchar(25) NULL,
	"deposit_account"       	varchar(50) NULL,
	"dependent_id"  		varchar(25) NULL,
	"max_ben_year"  		numeric(18,6) NULL,
	"max_ben_ltd"   		numeric(18,6) NULL,
	"import_batch"  		varchar(25) NULL,
	"cost_account_code"     	varchar(25) NULL,
	"cr_cost_account_code"  	varchar(25) NULL,
	PRIMARY KEY ("employee", "benefit")
)
go
CREATE TABLE dbo."employee_certificates"
(
	"employee"      		varchar(25) NOT NULL,
	"certificate"   		varchar(25) NOT NULL,
	"certificate_date"      	datetime NOT NULL,
	"expire_date"   		datetime NULL,
	"rating"        		numeric(18,6) NULL,
	"certificate_comment"   	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"class_date"    		datetime NULL,
	"location"      		varchar(25) NULL,
	"hours_of_training"     	numeric(18,6) NULL,
	"ceu_units"     		numeric(18,6) NULL,
	"training_dollars_spent"        numeric(18,6) NULL,
	"cert_identity" 		integer NOT NULL IDENTITY(1, 1),
	PRIMARY KEY ("employee", "certificate", "certificate_date", "cert_identity")
)
go
CREATE TABLE dbo."employee_deduction_types"
(
	"employee"      		varchar(25) NOT NULL,
	"deduction_type"        	varchar(25) NOT NULL,
	"rate_id"       		varchar(25) NULL,
	"begin_date"    		datetime NULL,
	"end_date"      		datetime NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"max_ded_cycle" 		numeric(18,6) NULL,
	"max_ded_year"  		numeric(18,6) NULL,
	"max_ded_ltd"   		numeric(18,6) NULL,
	"vendor"        		varchar(25) NULL,
	"item"  			varchar(25) NULL,
	"bank_account"  		varchar(35) NULL,
	"dd_status"     		varchar(2) NULL,
	"dd_bank_alias" 		varchar(25) NULL,
	"transit_routing_no"    	varchar(25) NULL,
	"prenotes_required"     	smallint NULL,
	"prenotes_given"        	smallint NULL,
	"check_sequence"        	smallint NULL,
	"dd_account_type"       	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"check_message" 		text NULL,
	"rate_event"    		varchar(25) NULL,
	"import_batch"  		varchar(25) NULL,
	"cr_cost_account_code"  	varchar(25) NULL,
	"dd_foreign"    		char(1) NULL,
	"dd_foreign_bank"       	varchar(25) NULL,
	PRIMARY KEY ("employee", "deduction_type")
)
go
CREATE TABLE dbo."employee_degrees"
(
	"employee"      		varchar(25) NOT NULL,
	"entry_date"    		datetime NOT NULL,
	"degree"        		varchar(25) NULL,
	"institution"   		varchar(50) NULL,
	"area_of_study" 		varchar(50) NULL,
	"date_graduated"        	datetime NULL,
	"degree_comment"        	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"degree_identity"       	integer NOT NULL IDENTITY(1, 1),
	"highest_degree"        	char(1) NULL,
	PRIMARY KEY ("employee", "entry_date", "degree_identity")
)
go
CREATE TABLE dbo."employee_dependents"
(
	"employee"      		varchar(25) NOT NULL,
	"dependent_id"  		varchar(25) NOT NULL,
	"last_name"     		varchar(25) NULL,
	"first_name"    		varchar(25) NULL,
	"address_id"    		varchar(25) NULL,
	"relationship"  		varchar(25) NULL,
	"home_phone"    		varchar(25) NULL,
	"work_phone"    		varchar(25) NULL,
	"birth_date"    		datetime NULL,
	"student"       		char(1) NULL,
	"handicapped"   		char(1) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"social_security"       	varchar(25) NULL,
	PRIMARY KEY ("employee", "dependent_id")
)
go
CREATE TABLE dbo."employee_equipment"
(
	"employee"      		varchar(25) NOT NULL,
	"equipment_code"        	varchar(25) NOT NULL,
	"equipment_description" 	varchar(250) NULL,
	"equipment_comment"     	text NULL,
	"equipment_model"       	varchar(25) NULL,
	"equipment_serial_number"       varchar(25) NULL,
	"issued_date"   		datetime NULL,
	"return_date"   		datetime NULL,
	"renew_date"    		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"entry_date"    		datetime NOT NULL,
	PRIMARY KEY ("employee", "equipment_code", "entry_date")
)
go
CREATE TABLE dbo."employee_pay_types"
(
	"employee"      		varchar(25) NOT NULL,
	"pay_type"      		varchar(25) NOT NULL,
	"begin_date"    		datetime NULL,
	"end_date"      		datetime NULL,
	"rate_id"       		varchar(25) NULL,
	"rate_event"    		varchar(25) NULL,
	"check_sequence"        	smallint NULL,
	"pay_ledger_account_code"       varchar(50) NULL,
	"pay_cost_account_code" 	varchar(50) NULL,
	"hours_ledger_account_code"     varchar(50) NULL,
	"hours_cost_account_code"       varchar(50) NULL,
	"standard_cycle_hours"  	numeric(18,6) NULL,
	"max_hours_cycle"       	numeric(18,6) NULL,
	"max_pay_cycle" 		numeric(18,6) NULL,
	"max_hours_year"        	numeric(18,6) NULL,
	"max_pay_year"  		numeric(18,6) NULL,
	"max_hours_ltd" 		numeric(18,6) NULL,
	"max_pay_ltd"   		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"base_pay"      		char(1) NULL,
	"rate_id_change_date"   	datetime NULL,
	"import_batch"  		varchar(25) NULL,
	PRIMARY KEY ("employee", "pay_type")
)
go
CREATE TABLE dbo."employee_positions"
(
	"employee"      		varchar(25) NOT NULL,
	"begin_date"    		datetime NOT NULL,
	"position"      		varchar(25) NOT NULL,
	"end_date"      		datetime NULL,
	"location"      		varchar(25) NULL,
	"unit"  			varchar(25) NULL,
	"primary_position"      	char(1) NULL,
	"position_comment"      	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"fte"   			numeric(18,6) NULL,
	"division"      		varchar(25) NULL,
	PRIMARY KEY ("employee", "begin_date", "position")
)
go
CREATE TABLE dbo."employee_retirement_plans"
(
	"employee"      		varchar(25) NOT NULL,
	"retirement_plan"       	varchar(25) NOT NULL,
	"begin_date"    		datetime NULL,
	"end_date"      		datetime NULL,
	"percent_rate_id"       	varchar(25) NULL,
	"amount_rate_id"        	varchar(25) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"r_cr_ledger_account_code"      varchar(50) NULL,
	"r_dr_ledger_account_code"      varchar(50) NULL,
	"check_sequence"        	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"deposit_account"       	varchar(50) NULL,
	"import_batch"  		varchar(25) NULL,
	"cost_account_code"     	varchar(25) NULL,
	PRIMARY KEY ("employee", "retirement_plan")
)
go
CREATE TABLE dbo."employee_review_scoreboard_not"
(
	"employee"      		varchar(25) NOT NULL,
	"scheduled_date"        	datetime NOT NULL,
	"note_date"     		datetime NOT NULL,
	"employee_review_note"  	text NULL,
	"follow_up_date"        	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("employee", "scheduled_date", "note_date")
)
go
CREATE TABLE dbo."employee_reviews"
(
	"employee"      		varchar(25) NOT NULL,
	"scheduled_date"        	datetime NOT NULL,
	"completed_date"        	datetime NULL,
	"effective_date"        	datetime NULL,
	"reviewer"      		varchar(50) NULL,
	"review_reason" 		varchar(25) NULL,
	"review_comments"       	text NULL,
	"review_rating" 		numeric(18,6) NULL,
	"rate_id"       		varchar(25) NULL,
	"rate_effective_date"   	datetime NULL,
	"position"      		varchar(25) NULL,
	"position_effective"    	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"lump_sum_payment"      	numeric(18,6) NULL,
	"review_document"       	varchar(50) NULL,
	"position_review_document"      varchar(50) NULL,
	"approved"      		char(1) NULL,
	"status"        		char(1) NULL,
	PRIMARY KEY ("employee", "scheduled_date")
)
go
CREATE TABLE dbo."employee_tax_types"
(
	"employee"      		varchar(25) NOT NULL,
	"tax_type"      		varchar(25) NOT NULL,
	"marital_status"        	char(1) NULL,
	"exemptions"    		smallint NULL,
	"additional_tax"        	numeric(18,6) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"check_sequence"        	smallint NULL,
	"begin_date"    		datetime NULL,
	"end_date"      		datetime NULL,
	"exempt"        		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"fcit_annual_taxable_reduction" numeric(18,6) NULL,
	"wcb_group"     		varchar(25) NULL,
	"federal_tax_credit_rate_id"    varchar(25) NULL,
	"federal_tax_credit_rate_event" varchar(25) NULL,
	"prov_tax_credit_rate_id"       varchar(25) NULL,
	"prov_tax_credit_rate_event"    varchar(25) NULL,
	"import_batch"  		varchar(25) NULL,
	"cost_account_code"     	varchar(25) NULL,
	PRIMARY KEY ("employee", "tax_type")
)
go
CREATE TABLE dbo."employee_terminations"
(
	"employee"      		varchar(25) NOT NULL,
	"termination_date"      	datetime NOT NULL,
	"interview_date"        	datetime NULL,
	"interviewer"   		varchar(50) NULL,
	"termination_reason"    	varchar(25) NULL,
	"termination_comments"  	text NULL,
	"new_employment_type"   	varchar(25) NULL,
	"select_for_calc_thru_date"     datetime NULL,
	"pay_thru_date" 		datetime NULL,
	"deductions_thru_date"  	datetime NULL,
	"benefits_thru_date"    	datetime NULL,
	"retirements_thru_date" 	datetime NULL,
	"position_end_date"     	datetime NULL,
	"equipment_return_date" 	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"hire_date"     		datetime NULL,
	"deceased_date" 		datetime NULL,
	"new_employment_status" 	varchar(25) NULL,
	"unit"  			varchar(25) NULL,
	"location"      		varchar(25) NULL,
	"employment_type"       	varchar(25) NULL,
	"pay_frequency" 		integer NULL,
	"recall_status" 		char(1) NULL,
	"expected_recall_date"  	datetime NULL,
	"roe_last_date_paid"    	datetime NULL,
	"term_or_leave" 		char(1) NULL,
	"roe_created"   		char(1) NULL,
	"roe_final_ppe_date"    	datetime NULL,
	PRIMARY KEY ("employee", "termination_date")
)
go
CREATE TABLE dbo."employee_time_card_defaults"
(
	"employee"      		varchar(25) NOT NULL,
	"time_card_sort"        	varchar(25) NOT NULL,
	"scheduled_hours"       	numeric(18,6) NULL,
	"pieces_paid"   		numeric(18,6) NULL,
	"pay_type"      		varchar(25) NULL,
	"rate_id"       		varchar(25) NULL,
	"rate_event"    		varchar(25) NULL,
	"additional_hours_pay_type"     varchar(25) NULL,
	"additional_hours_rate_id"      varchar(25) NULL,
	"additional_hours_rate_event"   varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"start_time"    		datetime NULL,
	"end_time"      		datetime NULL,
	"import_batch"  		varchar(25) NULL,
	PRIMARY KEY ("employee", "time_card_sort")
)
go
CREATE TABLE dbo."employee_ytd_balances"
(
	"calendar_year" 		smallint NOT NULL,
	"employee"      		varchar(25) NOT NULL,
	"document"      		varchar(3) NOT NULL,
	"document_type" 		varchar(25) NOT NULL,
	"hours" 			numeric(18,6) NULL,
	"amount"        		numeric(18,6) NULL,
	"basis_amount"  		numeric(18,6) NULL,
	"payer" 			varchar(25) NOT NULL,
	"gross_amount"  		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"hours_worked"  		numeric(18,6) NULL,
	"pieces_paid"   		numeric(18,6) NULL,
	"amount_banked" 		numeric(18,6) NULL,
	"hours_banked"  		numeric(18,6) NULL,
	"basis_hours"   		numeric(18,6) NULL,
	PRIMARY KEY ("calendar_year", "employee", "document", "document_type", "payer")
)
go
CREATE TABLE dbo."employees"
(
	"employee"      		varchar(25) NOT NULL,
	"unit"  			varchar(25) NULL,
	"employee_last_name"    	varchar(50) NULL,
	"employee_first_name"   	varchar(50) NULL,
	"address_id"    		varchar(25) NULL,
	"social_security_number"        varchar(11) NULL,
	"location"      		varchar(25) NULL,
	"employment_status"     	varchar(25) NULL,
	"home_phone"    		varchar(25) NULL,
	"office_phone"  		varchar(25) NULL,
	"email_address" 		varchar(250) NULL,
	"birth_date"    		datetime NULL,
	"hire_date"     		datetime NULL,
	"termination_date"      	datetime NULL,
	"seniority_date"        	datetime NULL,
	"currency"      		varchar(25) NULL,
	"check_bank_alias"      	varchar(25) NULL,
	"check_type"    		varchar(2) NULL,
	"bank_account"  		varchar(35) NULL,
	"transit_routing_no"    	varchar(25) NULL,
	"prenotes_required"     	smallint NULL,
	"prenotes_given"        	smallint NULL,
	"pay_frequency" 		integer NULL,
	"employment_type"       	varchar(25) NULL,
	"employee_picture"      	varchar(50) NULL,
	"emergency_contact_id"  	varchar(25) NULL,
	"gender"        		char(1) NULL,
	"race"  			char(1) NULL,
	"direct_deposit"        	char(1) NULL,
	"contract_length"       	char(1) NULL,
	"eeoc_pay_type" 		varchar(25) NULL,
	"dd_account_type"       	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"deceased_date" 		datetime NULL,
	"time_card_group"       	varchar(25) NULL,
	"time_card_group_sort"  	varchar(50) NULL,
	"select_for_calc_thru_date"     datetime NULL,
	"home_email_address"    	varchar(250) NULL,
	"notification_method"   	char(1) NULL,
	"send_email_notification_to"    char(1) NULL,
	"division"      		varchar(25) NULL,
	"eir_business_number"   	varchar(25) NULL,
	"ipeds_faculty_status"  	char(1) NULL,
	"ipeds_position"        	varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	"ipeds_ethnic_hispanic" 	char(1) NULL,
	"ipeds_race_white"      	char(1) NULL,
	"ipeds_race_black"      	char(1) NULL,
	"ipeds_race_asian"      	char(1) NULL,
	"ipeds_race_indian"     	char(1) NULL,
	"ipeds_race_hawaiian"   	char(1) NULL,
	"ipeds_non_resident_alien"      char(1) NULL,
	"tenure_date"   		datetime NULL,
	"faculty_status"        	char(1) NULL,
	"current_contract_length"       numeric(18,6) NULL,
	"dd_foreign"    		char(1) NULL,
	"dd_foreign_bank"       	varchar(25) NULL,
	PRIMARY KEY ("employee")
)
go
CREATE TABLE dbo."employment_types"
(
	"employment_type"       	varchar(25) NOT NULL,
	"employment_type_description"   varchar(50) NULL,
	"eeoc_trainee"  		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"eeoc_full_time"        	char(1) NULL,
	"ipeds_graduate_assistant"      char(1) NULL,
	PRIMARY KEY ("employment_type")
)
go
CREATE TABLE dbo."entitlement_balances"
(
	"entitle_year"  		smallint NOT NULL,
	"employee"      		varchar(25) NOT NULL,
	"entitlement"   		varchar(25) NOT NULL,
	"hours_accrued" 		numeric(18,6) NULL,
	"hours_accrued_carryover"       numeric(18,6) NULL,
	"hours_taken"   		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"amount_accrued"        	numeric(18,6) NULL,
	"amount_accrued_carryover"      numeric(18,6) NULL,
	"amount_taken"  		numeric(18,6) NULL,
	PRIMARY KEY ("entitle_year", "employee", "entitlement")
)
go
CREATE TABLE dbo."entitlement_los"
(
	"entitlement"   		varchar(25) NOT NULL,
	"service_years" 		smallint NOT NULL,
	"service_months"        	smallint NOT NULL,
	"service_days"  		smallint NOT NULL,
	"max_accrue_hours"      	numeric(18,6) NULL,
	"max_balance_hours"     	numeric(18,6) NULL,
	"hours_to_accrue_annually"      numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"percent_to_accrue"     	numeric(12,6) NULL,
	"max_balance_dollars"   	numeric(18,6) NULL,
	"max_carryover_hours"   	numeric(18,6) NULL,
	"max_payout_hours"      	numeric(18,6) NULL,
	"max_payout_dollars"    	numeric(18,6) NULL,
	"max_accrue_dollars"    	numeric(18,6) NULL,
	"max_carryover_dollars" 	numeric(18,6) NULL,
	PRIMARY KEY ("entitlement", "service_years", "service_months", "service_days")
)
go
CREATE TABLE dbo."entitlement_proration_basis"
(
	"entitlement"   		varchar(25) NOT NULL,
	"pay_type"      		varchar(25) NOT NULL,
	"basis_operator"        	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"document"      		varchar(25) NULL,
	PRIMARY KEY ("entitlement", "pay_type")
)
go
CREATE TABLE dbo."entitlement_transactions"
(
	"entitle_year"  		smallint NOT NULL,
	"employee"      		varchar(25) NOT NULL,
	"entitlement"   		varchar(25) NOT NULL,
	"entered_date"  		datetime NOT NULL,
	"transaction_type"      	varchar(25) NULL,
	"transaction_date"      	datetime NULL,
	"transaction_reference" 	varchar(50) NULL,
	"pay_type"      		varchar(25) NULL,
	"accrued_entitlement"   	varchar(25) NULL,
	"hours" 			numeric(18,6) NULL,
	"accrual_id"    		varchar(25) NULL,
	"accrual_status"        	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"amount"        		numeric(18,6) NULL,
	"entered_date_taken"    	datetime NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"payroll_cycle" 		varchar(25) NULL,
	"status"        		char(1) NULL,
	"check_sequence"        	smallint NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"voucher"       		varchar(25) NULL,
	"check_void"    		char(1) NULL,
	"rate"  			numeric(18,6) NULL,
	"entitlement_identity"  	integer NOT NULL IDENTITY(1, 1),
	"time_card_identity"    	integer NULL,
	"entitlement_comment"   	text NULL,
	PRIMARY KEY ("entitle_year", "employee", "entitlement", "entered_date", "entitlement_identity")
)
go
CREATE TABLE dbo."entitlements"
(
	"entitlement"   		varchar(25) NOT NULL,
	"description"   		varchar(50) NULL,
	"employment_types"      	varchar(250) NULL,
	"accruals_per_year"     	smallint NULL,
	"anniversary_date_only" 	char(1) NULL,
	"balance_entitlement"   	varchar(25) NULL,
	"print_on_check"        	char(1) NULL,
	"eligibility_hire_seniority"    varchar(10) NULL,
	"hired_before_date"     	datetime NULL,
	"min_hours_standard_accrual"    numeric(18,6) NULL,
	"max_hours_standard_accrual"    numeric(18,6) NULL,
	"min_hours_prorated_accrual"    numeric(18,6) NULL,
	"max_hours_prorated_accrual"    numeric(18,6) NULL,
	"standard_hours"        	numeric(18,6) NULL,
	"reduce_current_year_balance"   char(1) NULL,
	"check_stub_description"        varchar(50) NULL,
	"eligibility_years"     	smallint NULL,
	"eligibility_months"    	smallint NULL,
	"eligibility_days"      	smallint NULL,
	"enrollment_month"      	smallint NULL,
	"enrollment_day"        	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"security_unit" 		varchar(25) NULL,
	"entitlement_style"     	varchar(25) NULL,
	"allow_negative"        	char(1) NULL,
	"pay_type"      		varchar(25) NULL,
	"allow_negative_dollars"        char(1) NULL,
	"ledger"        		varchar(40) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"check_sequence"        	smallint NULL,
	"carryover_negative_hours"      char(1) NULL,
	"carryover_negative_dollars"    char(1) NULL,
	"enrollment_style"      	varchar(25) NULL,
	"entitlement_transfer_overage"  varchar(25) NULL,
	PRIMARY KEY ("entitlement")
)
go
CREATE TABLE dbo."equipment_codes"
(
	"equipment_code"        	varchar(25) NOT NULL,
	"equipment_code_description"    text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("equipment_code")
)
go
CREATE TABLE dbo."fa_asset_attributes"
(
	"asset_id"      		varchar(50) NOT NULL,
	"text_1"        		varchar(25) NULL,
	"text_2"        		varchar(25) NULL,
	"text_3"        		varchar(25) NULL,
	"text_4"        		varchar(25) NULL,
	"text_5"        		varchar(25) NULL,
	"text_6"        		varchar(25) NULL,
	"text_7"        		varchar(25) NULL,
	"text_8"        		varchar(25) NULL,
	"text_9"        		varchar(25) NULL,
	"text_10"       		varchar(25) NULL,
	"text_11"       		varchar(25) NULL,
	"text_12"       		varchar(25) NULL,
	"text_13"       		varchar(25) NULL,
	"text_14"       		varchar(25) NULL,
	"text_15"       		varchar(25) NULL,
	"text_16"       		varchar(25) NULL,
	"text_17"       		varchar(25) NULL,
	"text_18"       		varchar(25) NULL,
	"text_19"       		varchar(25) NULL,
	"text_20"       		varchar(25) NULL,
	"integer_1"     		integer NULL,
	"integer_2"     		integer NULL,
	"integer_3"     		integer NULL,
	"integer_4"     		integer NULL,
	"integer_5"     		integer NULL,
	"numeric_1"     		numeric(18,6) NULL,
	"numeric_2"     		numeric(18,6) NULL,
	"numeric_3"     		numeric(18,6) NULL,
	"numeric_4"     		numeric(18,6) NULL,
	"numeric_5"     		numeric(18,6) NULL,
	"date_1"        		datetime NULL,
	"date_2"        		datetime NULL,
	"date_3"        		datetime NULL,
	"date_4"        		datetime NULL,
	"date_5"        		datetime NULL,
	"date_6"        		datetime NULL,
	"date_7"        		datetime NULL,
	"date_8"        		datetime NULL,
	"date_9"        		datetime NULL,
	"date_10"       		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("asset_id")
)
go
CREATE TABLE dbo."fa_asset_books"
(
	"asset_id"      		varchar(50) NOT NULL,
	"depreciation_book"     	varchar(25) NOT NULL,
	"asset_life"    		numeric(12,5) NULL,
	"in_service_date"       	datetime NULL,
	"depreciation_date"     	datetime NULL,
	"depreciation_method"   	varchar(25) NULL,
	"original_cost" 		numeric(18,6) NULL,
	"salvage_value" 		numeric(18,6) NULL,
	"amount_expensed"       	numeric(18,6) NULL,
	"depreciable_basis"     	numeric(18,6) NULL,
	"fiscal_year"   		varchar(5) NULL,
	"fiscal_period" 		integer NULL,
	"current_period_depreciation"   numeric(18,6) NULL,
	"ytd_depreciation"      	numeric(18,6) NULL,
	"ltd_depreciation"      	numeric(18,6) NULL,
	"net_value"     		numeric(18,6) NULL,
	"prior_year_depreciation"       numeric(18,6) NULL,
	"life_unit_of_measure"  	varchar(15) NULL,
	"units_ltd"     		numeric(18,6) NULL,
	"new_used"      		char(1) NULL,
	"processing_mode"       	char(1) NULL,
	"currency"      		varchar(25) NULL,
	"historical_exchange_rate"      numeric(18,6) NULL,
	"depreciation_basis_adj"        numeric(18,6) NULL,
	"ltd_depreciation_adj"  	numeric(18,6) NULL,
	"gain_loss"     		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"rsl_cost"      		numeric(18,6) NULL,
	"rsl_life"      		numeric(12,5) NULL,
	"rsl_life_unit_of_measure"      varchar(15) NULL,
	"rsl_fiscal_year"       	varchar(5) NULL,
	"rsl_fiscal_period"     	smallint NULL,
	"bonus_depreciation"    	numeric(18,6) NULL,
	PRIMARY KEY ("asset_id", "depreciation_book")
)
go
CREATE TABLE dbo."fa_asset_depreciation_audit"
(
	"asset_id"      		varchar(50) NOT NULL,
	"depreciation_book"     	varchar(25) NOT NULL,
	"fiscal_year"   		varchar(5) NOT NULL,
	"fiscal_period" 		integer NOT NULL,
	"ledger_account"        	varchar(50) NOT NULL,
	"ledger"        		varchar(40) NULL,
	"asset_life"    		numeric(18,6) NULL,
	"depreciation_method"   	varchar(25) NULL,
	"depreciation_basis"    	numeric(18,6) NULL,
	"depreciation_ltd"      	numeric(18,6) NULL,
	"depreciation_period"   	numeric(18,6) NULL,
	"depreciation_calc_id"  	varchar(40) NOT NULL,
	"depreciation_date"     	datetime NULL,
	"gl_entry"      		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"depreciation_accum_or_exp"     char(1) NULL,
	"glentry_fiscal_year"   	varchar(5) NULL,
	"glentry_fiscal_period" 	integer NULL,
	"gl_date"       		datetime NULL,
	"document_source"       	varchar(25) NULL,
	PRIMARY KEY ("asset_id", "depreciation_book", "fiscal_year", "fiscal_period", "ledger_account", "depreciation_calc_id")
)
go
CREATE TABLE dbo."fa_asset_dispositions"
(
	"asset_id"      		varchar(50) NOT NULL,
	"disposition_reason"    	varchar(25) NULL,
	"disposition_comment"   	varchar(255) NULL,
	"disposition_date"      	datetime NULL,
	"disposition_fiscal_year"       varchar(5) NULL,
	"disposition_period"    	integer NULL,
	"disposition_proceeds"  	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"ledger"        		varchar(25) NULL,
	"gl_entry"      		varchar(25) NULL,
	PRIMARY KEY ("asset_id")
)
go
CREATE TABLE dbo."fa_asset_groups"
(
	"asset_id"      		varchar(50) NOT NULL,
	"asset_group"   		varchar(25) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("asset_id", "asset_group")
)
go
CREATE TABLE dbo."fa_asset_history"
(
	"asset_id"      		varchar(50) NOT NULL,
	"asset_event"   		varchar(25) NOT NULL,
	"asset_event_date"      	datetime NOT NULL,
	"sequence_number"       	numeric(4,0) NOT NULL,
	"column_changed"        	varchar(30) NOT NULL,
	"old_value"     		varchar(50) NULL,
	"new_value"     		varchar(50) NULL,
	"event_reason"  		varchar(255) NULL,
	"ledger"        		varchar(40) NULL,
	"fiscal_year"   		varchar(5) NULL,
	"fiscal_period" 		numeric(4,0) NULL,
	"gl_entry"      		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"acquisition_asset"     	varchar(50) NULL,
	"depreciation_accumulated"      varchar(50) NULL,
	"depreciation_book"     	varchar(25) NULL,
	"depreciation_calc_id"  	varchar(40) NULL,
	"glentry_fiscal_year"   	varchar(5) NULL,
	"glentry_fiscal_period" 	integer NULL,
	"gl_date"       		datetime NULL,
	PRIMARY KEY ("asset_id", "asset_event", "asset_event_date", "sequence_number", "column_changed")
)
go
CREATE TABLE dbo."fa_asset_uop"
(
	"asset_id"      		varchar(50) NOT NULL,
	"uop_date"      		datetime NOT NULL,
	"uop_units"     		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("asset_id", "uop_date")
)
go
CREATE TABLE dbo."fa_assets"
(
	"asset_id"      		varchar(50) NOT NULL,
	"unit"  			varchar(25) NULL,
	"asset_description"     	text NULL,
	"manufacturer"  		varchar(50) NULL,
	"model" 			varchar(50) NULL,
	"serial"        		varchar(50) NULL,
	"asset_bitmap"  		varchar(50) NULL,
	"personal_real" 		varchar(2) NULL,
	"own_lease"     		varchar(2) NULL,
	"vendor"        		varchar(50) NULL,
	"purchase_document"     	varchar(25) NULL,
	"count_cycle"   		varchar(25) NULL,
	"personal_use_pct"      	numeric(4,2) NULL,
	"personal_use_name"     	varchar(40) NULL,
	"replacement_cost_index"        varchar(25) NULL,
	"insurance_carrier"     	varchar(40) NULL,
	"asset_location"        	varchar(25) NULL,
	"property_tax_jurisdiction"     varchar(25) NULL,
	"itc_years"     		numeric(5,2) NULL,
	"itc_percent"   		numeric(5,2) NULL,
	"itc_amount"    		numeric(18,6) NULL,
	"itc_basis_reduction"   	numeric(18,6) NULL,
	"itr_percent"   		numeric(5,2) NULL,
	"itr_amount"    		numeric(18,6) NULL,
	"itr_basis_increase"    	numeric(18,6) NULL,
	"mintax_life"   		numeric(5,2) NULL,
	"mintax_method" 		varchar(25) NULL,
	"ace_life"      		numeric(5,2) NULL,
	"status"        		char(1) NULL,
	"acquisition_date"      	datetime NULL,
	"location_date" 		datetime NULL,
	"itr_date"      		datetime NULL,
	"disposition_date"      	datetime NULL,
	"disposition_proceeds_amount"   numeric(18,6) NULL,
	"replacement_cost_year" 	integer NULL,
	"replacement_cost_amount"       numeric(18,6) NULL,
	"asset_short_description"       varchar(50) NULL,
	"physical_inventory_id" 	varchar(25) NULL,
	"asset_class"   		varchar(25) NULL,
	"acquisition_asset"     	varchar(50) NULL,
	"acquisition_liability" 	varchar(50) NULL,
	"depreciation_accumulated"      varchar(50) NULL,
	"depreciation_expense"  	varchar(50) NULL,
	"disposition_gain_loss" 	varchar(50) NULL,
	"disposition_proceeds"  	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"gl_date"       		datetime NULL,
	"last_date_counted"     	datetime NULL,
	"last_employee_counted" 	varchar(50) NULL,
	"acq_asset_cost_account"        varchar(50) NULL,
	"acq_liability_cost_account"    varchar(50) NULL,
	"invoice"       		varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("asset_id")
)
go
CREATE TABLE dbo."fa_classes"
(
	"fa_class"      		varchar(25) NOT NULL,
	"fa_class_description"  	varchar(50) NULL,
	"personal_real" 		char(1) NULL,
	"own_lease"     		char(1) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("fa_class")
)
go
CREATE TABLE dbo."fa_classes_account_preferences"
(
	"fa_class"      		varchar(25) NOT NULL,
	"acquisition_asset"     	varchar(50) NULL,
	"acquisition_liability" 	varchar(50) NULL,
	"depreciation_accumulated"      varchar(50) NULL,
	"depreciation_expense"  	varchar(50) NULL,
	"disposition_proceeds"  	varchar(50) NULL,
	"disposition_gain_loss" 	varchar(50) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("fa_class")
)
go
CREATE TABLE dbo."fa_classes_book_preferences"
(
	"fa_class"      		varchar(25) NOT NULL,
	"depreciation_book"     	varchar(25) NOT NULL,
	"asset_life"    		numeric(12,5) NULL,
	"life_unit_of_measure"  	varchar(15) NULL,
	"depreciation_method"   	varchar(25) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"new_used"      		char(1) NULL,
	PRIMARY KEY ("fa_class", "depreciation_book")
)
go
CREATE TABLE dbo."fa_cost_index_percents"
(
	"replacement_cost_index"        varchar(25) NOT NULL,
	"relative_year" 		smallint NOT NULL,
	"relative_percent"      	numeric(5,2) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("replacement_cost_index", "relative_year")
)
go
CREATE TABLE dbo."fa_cost_indexes"
(
	"replacement_cost_index"        varchar(25) NOT NULL,
	"cost_index_description"        varchar(50) NULL,
	"base_year"     		smallint NULL,
	"base_percent"  		numeric(5,2) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("replacement_cost_index")
)
go
CREATE TABLE dbo."fa_depn_calc_id"
(
	"depreciation_calc_id"  	varchar(40) NOT NULL,
	"depreciation_date"     	datetime NOT NULL,
	"fiscal_year"   		varchar(5) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"source"        		varchar(25) NULL,
	"asset_id"      		varchar(50) NULL,
	PRIMARY KEY ("depreciation_calc_id")
)
go
CREATE TABLE dbo."fa_depreciation_books"
(
	"depreciation_book"     	varchar(40) NOT NULL,
	"depn_audit_trail"      	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("depreciation_book")
)
go
CREATE TABLE dbo."fa_depreciation_rates"
(
	"depreciation_method"   	varchar(25) NOT NULL,
	"in_service_year"       	smallint NOT NULL,
	"in_service_month"      	smallint NOT NULL,
	"recovery_year" 		smallint NOT NULL,
	"depreciation_rate"     	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("depreciation_method", "in_service_year", "in_service_month", "recovery_year")
)
go
CREATE TABLE dbo."fa_groups"
(
	"asset_group"   		varchar(25) NOT NULL,
	"description"   		varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("asset_group")
)
go
CREATE TABLE dbo."fa_locations"
(
	"asset_location"        	varchar(25) NOT NULL,
	"asset_location_description"    varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"location_source"       	varchar(2) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("asset_location")
)
go
CREATE TABLE dbo."fa_phy_inv_results"
(
	"physical_inventory_id" 	varchar(25) NOT NULL,
	"asset_id"      		varchar(50) NOT NULL,
	"phy_inv_date"  		datetime NULL,
	"phy_inv_employee"      	varchar(50) NULL,
	"phy_inv_location"      	varchar(25) NULL,
	"phy_inv_depn_account"  	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("physical_inventory_id", "asset_id")
)
go
CREATE TABLE dbo."fa_property_tax_jurisdictions"
(
	"property_tax_jurisdiction"     varchar(25) NOT NULL,
	"property_tax_jurisdiction_nam" varchar(40) NULL,
	"address_id"    		varchar(25) NULL,
	"contact_id"    		varchar(25) NULL,
	"tax_filing_month"      	smallint NULL,
	"tax_filing_year"       	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("property_tax_jurisdiction")
)
go
CREATE TABLE dbo."installed_modules"
(
	"installed_module"      	varchar(25) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"empowernet_installed"  	bit NULL,
	"application"   		varchar(25) NULL
)
go
CREATE TABLE dbo."ipeds_academic_ranks"
(
	"academic_rank" 		varchar(25) NOT NULL,
	"academic_rank_description"     varchar(50) NULL,
	"academic_rank_sort"    	smallint NULL,
	PRIMARY KEY ("academic_rank")
)
go
CREATE TABLE dbo."ipeds_primary_functions"
(
	"primary_function"      	varchar(25) NOT NULL,
	"primary_function_description"  varchar(50) NULL,
	"primary_function_sort" 	smallint NULL,
	PRIMARY KEY ("primary_function")
)
go
CREATE TABLE dbo."item_attributes"
(
	"item"  			varchar(50) NOT NULL,
	"text_1"        		varchar(25) NULL,
	"text_2"        		varchar(25) NULL,
	"text_3"        		varchar(25) NULL,
	"text_4"        		varchar(25) NULL,
	"text_5"        		varchar(25) NULL,
	"text_6"        		varchar(25) NULL,
	"text_7"        		varchar(25) NULL,
	"text_8"        		varchar(25) NULL,
	"text_9"        		varchar(25) NULL,
	"text_10"       		varchar(25) NULL,
	"text_11"       		varchar(25) NULL,
	"text_12"       		varchar(25) NULL,
	"text_13"       		varchar(25) NULL,
	"text_14"       		varchar(25) NULL,
	"text_15"       		varchar(25) NULL,
	"text_16"       		varchar(25) NULL,
	"text_17"       		varchar(25) NULL,
	"text_18"       		varchar(25) NULL,
	"text_19"       		varchar(25) NULL,
	"text_20"       		varchar(25) NULL,
	"integer_1"     		integer NULL,
	"integer_2"     		integer NULL,
	"integer_3"     		integer NULL,
	"integer_4"     		integer NULL,
	"integer_5"     		integer NULL,
	"numeric_1"     		numeric(18,6) NULL,
	"numeric_2"     		numeric(18,6) NULL,
	"numeric_3"     		numeric(18,6) NULL,
	"numeric_4"     		numeric(18,6) NULL,
	"numeric_5"     		numeric(18,6) NULL,
	"date_1"        		datetime NULL,
	"date_2"        		datetime NULL,
	"date_3"        		datetime NULL,
	"date_4"        		datetime NULL,
	"date_5"        		datetime NULL,
	"date_6"        		datetime NULL,
	"date_7"        		datetime NULL,
	"date_8"        		datetime NULL,
	"date_9"        		datetime NULL,
	"date_10"       		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("item")
)
go
CREATE TABLE dbo."item_containers"
(
	"container_id"  		varchar(25) NOT NULL,
	"container"     		varchar(25) NULL,
	"container_uom" 		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"container_gross_weight"        numeric(18,6) NULL,
	"container_net_weight"  	numeric(18,6) NULL,
	"container_weight_uom"  	varchar(25) NULL,
	"container_gross_weight_kgs"    numeric(18,6) NULL,
	"container_net_weight_kgs"      numeric(18,6) NULL,
	"container_width"       	numeric(18,6) NULL,
	"container_length"      	numeric(18,6) NULL,
	"container_height"      	numeric(18,6) NULL,
	"container_dimensions_uom"      varchar(25) NULL,
	"purchase_order"        	varchar(25) NULL,
	"bill_of_lading"        	varchar(25) NULL,
	PRIMARY KEY ("container_id")
)
go
CREATE TABLE dbo."item_container_packages"
(
	"container_id"  		varchar(25) NOT NULL,
	"package"       		varchar(25) NOT NULL,
	"package_type"  		varchar(25) NULL,
	"package_gross_weight"  	numeric(18,6) NULL,
	"package_net_weight"    	numeric(18,6) NULL,
	"package_uom"   		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"package_weight_uom"    	varchar(25) NULL,
	"package_width" 		numeric(18,6) NULL,
	"package_length"        	numeric(18,6) NULL,
	"package_height"        	numeric(18,6) NULL,
	"package_dimensions_uom"        varchar(25) NULL,
	"package_gross_weight_kgs"      numeric(18,6) NULL,
	"package_net_weight_kgs"        numeric(18,6) NULL,
	"purchase_order"        	varchar(25) NULL,
	"bill_of_lading"        	varchar(25) NULL,
	PRIMARY KEY ("container_id", "package")
)
go
CREATE TABLE dbo."item_production"
(
	"item_production_id"    	varchar(25) NOT NULL,
	"item"  			varchar(25) NULL,
	"location"      		varchar(25) NULL,
	"batch" 			varchar(25) NULL,
	"gl_date"       		datetime NULL,
	"gl_entry"      		varchar(50) NULL,
	"fiscal_year"   		varchar(25) NULL,
	"period"        		smallint NULL,
	"quantity"      		numeric(18,6) NULL,
	"unit_cost"     		numeric(18,6) NULL,
	"amount"        		numeric(18,6) NULL,
	"debit_ledger_account"  	varchar(50) NULL,
	"credit_ledger_account" 	varchar(50) NULL,
	"ledger"        		varchar(40) NULL,
	"unit"  			varchar(25) NULL,
	"inventory_uom" 		varchar(25) NULL,
	"inventory_uom_to_standard"     numeric(18,6) NULL,
	"serial_uom"    		varchar(25) NULL,
	"serial_uom_to_standard"        numeric(18,6) NULL,
	"note"  			varchar(4000) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("item_production_id")
)
go
CREATE TABLE dbo."item_serial"
(
	"item"  			varchar(50) NOT NULL,
	"location"      		varchar(25) NOT NULL,
	"serial_number" 		varchar(50) NOT NULL,
	"on_hand_quantity"      	numeric(18,6) NULL,
	"sold_quantity" 		numeric(18,6) NULL,
	"reserved_quantity"     	numeric(18,6) NULL,
	"inventory_amount"      	numeric(18,6) NULL,
	"average_cost"  		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"country_of_origin"     	varchar(50) NULL,
	"container_id"  		varchar(25) NULL,
	"package"       		varchar(25) NULL,
	"physical_inventory_id" 	varchar(25) NULL,
	"quantity_at_selection" 	numeric(18,6) NULL,
	PRIMARY KEY ("item", "location", "serial_number")
)
go
CREATE TABLE dbo."iv_headers"
(
	"document_id1"  		varchar(25) NOT NULL,
	"document_id2"  		varchar(25) NULL,
	"document_id3"  		varchar(25) NULL,
	"document_type" 		varchar(25) NOT NULL,
	"transaction_type"      	varchar(25) NULL,
	"document_date" 		datetime NULL,
	"batch" 			varchar(25) NULL,
	"status"        		varchar(25) NULL,
	"approved"      		char(1) NULL,
	"currency"      		varchar(25) NULL,
	"gl_date"       		datetime NULL,
	"period"        		integer NULL,
	"ledger"        		varchar(25) NULL,
	"fiscal_year"   		varchar(25) NULL,
	"gl_entry"      		varchar(25) NULL,
	"document_amount"       	numeric(18,6) NULL,
	"ledger_amount" 		numeric(18,6) NULL,
	"unit"  			varchar(25) NULL,
	"document_comment"      	text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"document_source"       	varchar(25) NULL,
	"receipt_issue" 		varchar(25) NULL,
	PRIMARY KEY ("document_id1", "document_type")
)
go
CREATE TABLE dbo."iv_items"
(
	"document_id1"  		varchar(25) NOT NULL,
	"document_type" 		varchar(25) NOT NULL,
	"document_line" 		integer NOT NULL,
	"item"  			varchar(25) NULL,
	"location"      		varchar(25) NULL,
	"serial_number" 		varchar(25) NULL,
	"quantity"      		numeric(18,6) NULL,
	"document_amount"       	numeric(18,6) NULL,
	"unit_of_measure"       	varchar(25) NULL,
	"sort_line"     		integer NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"unit_cost"     		numeric(18,6) NULL,
	PRIMARY KEY ("document_id1", "document_type", "document_line")
)
go
CREATE TABLE dbo."journal_entry_headers"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"gl_entry"      		varchar(25) NOT NULL,
	"period"        		smallint NULL,
	"document_date" 		datetime NULL,
	"currency"      		varchar(25) NULL,
	"document_type" 		varchar(25) NULL,
	"document_amount"       	numeric(18,6) NULL,
	"ledger_amount" 		numeric(18,6) NULL,
	"status"        		varchar(25) NULL,
	"approved"      		char(1) NULL,
	"document_source"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"batch" 			varchar(25) NULL,
	"document_comment"      	text NULL,
	"balance_name"  		varchar(40) NULL,
	"je_description"        	varchar(50) NULL,
	"related_gl_entry"      	varchar(25) NULL,
	"gl_date"       		datetime NULL
)
go
CREATE TABLE dbo."journal_entry_items"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"gl_entry"      		varchar(25) NOT NULL,
	"document_line" 		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"document_amount"       	numeric(18,6) NULL,
	"document_reference1"   	varchar(50) NULL,
	"document_reference2"   	varchar(50) NULL,
	"document_remarks"      	text NULL,
	"quantity"      		numeric(18,6) NULL,
	"unit_of_measure"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"unit_cost"     		numeric(18,6) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "gl_entry", "document_line")
)
go
CREATE TABLE dbo."label_objects"
(
	"label_name"    		varchar(25) NOT NULL,
	"label_object"  		varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"labels_per_page"       	smallint NULL,
	"label_type"    		varchar(25) NULL,
	PRIMARY KEY ("label_name")
)
go
CREATE TABLE dbo."lease_buildings"
(
	"lease_building"        	varchar(25) NOT NULL,
	"lease_building_description"    text NULL,
	"lease_site"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("lease_building")
)
go
CREATE TABLE dbo."lease_calendar_dates"
(
	"lease_space"   		varchar(25) NOT NULL,
	"calendar_date" 		datetime NOT NULL,
	"lease" 			varchar(25) NULL,
	"lease_customer"        	varchar(25) NULL,
	"scheduled_customer"    	varchar(25) NULL,
	"attended_customer"     	varchar(25) NULL,
	"lease_calendar_identity"       integer NOT NULL IDENTITY(1, 1),
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"amount_collected"      	numeric(18,6) NULL,
	PRIMARY KEY ("lease_space", "calendar_date", "lease_calendar_identity")
)
go
CREATE TABLE dbo."lease_document_types"
(
	"lease_document_type"   	varchar(25) NOT NULL,
	"lease_document_type_desc"      varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("lease_document_type")
)
go
CREATE TABLE dbo."lease_sites"
(
	"lease_site"    		varchar(25) NOT NULL,
	"lease_site_description"        text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("lease_site")
)
go
CREATE TABLE dbo."lease_spaces"
(
	"lease_space"   		varchar(25) NOT NULL,
	"lease_space_description"       varchar(100) NULL,
	"lease_building"        	varchar(25) NULL,
	"dimensions"    		varchar(100) NULL,
	"start_date"    		datetime NULL,
	"end_date"      		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("lease_space")
)
go
CREATE TABLE dbo."ledger_period_applications"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"period"        		smallint NOT NULL,
	"application"   		varchar(25) NOT NULL,
	"closed"        		bit NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "period", "application")
)
go
CREATE TABLE dbo."ledger_periods"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"period"        		smallint NOT NULL,
	"ap_closed"     		char(1) NULL,
	"ar_closed"     		char(1) NULL,
	"ba_closed"     		char(1) NULL,
	"co_closed"     		char(1) NULL,
	"fa_closed"     		char(1) NULL,
	"gl_closed"     		char(1) NULL,
	"iv_closed"     		char(1) NULL,
	"py_closed"     		char(1) NULL,
	"po_closed"     		char(1) NULL,
	"so_closed"     		char(1) NULL,
	"cv_closed"     		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "period")
)
go
CREATE TABLE dbo."nav_opt_changes"
(
	"nav_opt_changes_identity"      integer NOT NULL IDENTITY(1, 1),
	"old_option_description"        varchar(40) NOT NULL,
	"new_option_description"        varchar(40) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NOT NULL,
	PRIMARY KEY ("nav_opt_changes_identity")
)
go
CREATE TABLE dbo."nav_tab_opt_changes"
(
	"nav_tab_opt_changes_identity"  integer NOT NULL IDENTITY(1, 1),
	"option_description"    	varchar(40) NOT NULL,
	"old_tablet"    		varchar(25) NOT NULL,
	"new_tablet"    		varchar(25) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NOT NULL,
	PRIMARY KEY ("nav_tab_opt_changes_identity")
)
go
CREATE TABLE dbo."pay_types"
(
	"pay_type"      		varchar(25) NOT NULL,
	"pay_type_description"  	varchar(50) NULL,
	"check_stub_description"        varchar(50) NULL,
	"employee_pay_type_required"    char(1) NULL,
	"entitlement"   		varchar(25) NULL,
	"absence_tracking"      	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"reduction_pay_type"    	varchar(25) NULL,
	"rate_id_scheme"        	varchar(25) NULL,
	"default_rate_event"    	varchar(25) NULL,
	"ledger"        		varchar(40) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"security_unit" 		varchar(25) NULL,
	"hours_ledger_account_code"     varchar(50) NULL,
	"entitlement_accrued_taken"     char(1) NULL,
	"entitlement_accrued_factor"    numeric(18,6) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"paid"  			char(1) NULL,
	"worked"        		char(1) NULL,
	"banked"        		char(1) NULL,
	"ncr"   			char(1) NULL,
	"base_pay"      		char(1) NULL,
	"piece_pay"     		char(1) NULL,
	"t4a"   			char(1) NULL,
	"workstudy"     		char(1) NULL,
	"time_of_day"   		char(1) NULL,
	"pay_periods_taxed"     	smallint NULL,
	PRIMARY KEY ("pay_type")
)
go
CREATE TABLE dbo."payroll_adjustments"
(
	"employee"      		varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"entry_datetime"        	datetime NOT NULL,
	"payroll_cycle" 		varchar(25) NULL,
	"document"      		varchar(25) NULL,
	"document_type" 		varchar(25) NULL,
	"hours" 			numeric(18,6) NULL,
	"rate"  			numeric(18,6) NULL,
	"amount"        		numeric(18,6) NULL,
	"basis" 			numeric(18,6) NULL,
	"gross" 			numeric(18,6) NULL,
	"unit"  			varchar(25) NULL,
	"payer" 			char(1) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"cost_account_code"     	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"basis_hours"   		numeric(18,6) NULL,
	"eir_business_number"   	varchar(25) NULL,
	PRIMARY KEY ("employee", "payroll_date", "entry_datetime")
)
go
CREATE TABLE dbo."payroll_cycles"
(
	"payroll_cycle" 		varchar(25) NOT NULL,
	"cycle_begin_date"      	datetime NULL,
	"cycle_end_date"        	datetime NULL,
	"check_date"    		datetime NULL,
	"pay_types_calc_sels"   	text NULL,
	"deduction_types_calc_sels"     text NULL,
	"benefit_types_calc_sels"       text NULL,
	"unit"  			varchar(25) NULL,
	"gl_date_1"     		datetime NULL,
	"gl_period_1_percent"   	numeric(18,6) NULL,
	"gl_date_2"     		datetime NULL,
	"gl_period_2_percent"   	numeric(18,6) NULL,
	"period_end_date"       	datetime NULL,
	"retirement_types_calc_sels"    text NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"calculation_status"    	varchar(25) NULL,
	"fiscal_year_1" 		varchar(5) NULL,
	"fiscal_year_2" 		varchar(5) NULL,
	"check_gl_date" 		datetime NULL,
	"check_fiscal_year"     	varchar(5) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"override_direct_deposit"       char(1) NULL,
	"entitlements_calc_sels"        text NULL,
	"entitle_year"  		smallint NULL,
	"check_message" 		varchar(250) NULL,
	"suppress_message_emp_ids"      text NULL,
	"print_in_progress"     	char(1) NULL,
	"history_import_id"     	varchar(25) NULL,
	PRIMARY KEY ("payroll_cycle")
)
go
CREATE TABLE dbo."payroll_documents"
(
	"document"      		varchar(25) NOT NULL,
	"document_description"  	varchar(50) NULL,
	"sort_order"    		integer NOT NULL,
	"summation_sign"        	char(1) NULL,
	PRIMARY KEY ("document")
)
go
CREATE TABLE dbo."payroll_document_mapping"
(
	"import_value"  		varchar(50) NOT NULL,
	"document"      		varchar(25) NULL,
	"document_type" 		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("import_value")
)
go
CREATE TABLE dbo."payroll_rate_dates"
(
	"rate_id"       		varchar(25) NOT NULL,
	"begin_date"    		datetime NOT NULL,
	"end_date"      		datetime NOT NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"import_batch"  		varchar(25) NULL,
	"contract_amount"       	numeric(18,6) NULL,
	"number_of_payments"    	integer NULL,
	"contract_annual_amount"        numeric(18,6) NULL,
	PRIMARY KEY ("rate_id", "begin_date")
)
go
CREATE TABLE dbo."payroll_rate_ids"
(
	"rate_id"       		varchar(25) NOT NULL,
	"empower_rate_style"    	varchar(50) NOT NULL,
	"freq_per_year" 		integer NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"rate_id_description"   	varchar(50) NULL,
	"security_unit" 		varchar(25) NULL,
	"import_batch"  		varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("rate_id")
)
go
CREATE TABLE dbo."payroll_rate_rates"
(
	"rate_id"       		varchar(25) NOT NULL,
	"begin_date"    		datetime NOT NULL,
	"rate_event"    		varchar(25) NOT NULL,
	"rate"  			numeric(18,6) NULL,
	"ledger"        		varchar(25) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"cost_account_code"     	varchar(50) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"rate_action"   		varchar(25) NULL,
	"rate_action_value"     	numeric(18,6) NULL,
	"base_rate_event"       	varchar(25) NULL,
	"import_batch"  		varchar(25) NULL,
	PRIMARY KEY ("rate_id", "begin_date", "rate_event")
)
go
CREATE TABLE dbo."payroll_voucher_items"
(
	"payroll_calculation_id"        varchar(25) NOT NULL,
	"voucher"       		varchar(25) NOT NULL,
	"voucher_sequence"      	varchar(25) NOT NULL,
	"voucher_line"  		integer NOT NULL,
	"check_void"    		char(1) NOT NULL,
	"check_type"    		char(1) NULL,
	"document"      		varchar(25) NULL,
	"document_type" 		varchar(25) NULL,
	"payer" 			char(1) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"cost_account_code"     	varchar(25) NULL,
	"amount"        		numeric(18,6) NULL,
	"basis" 			numeric(18,6) NULL,
	"hours" 			numeric(18,6) NULL,
	"rate"  			numeric(18,6) NULL,
	"source"        		varchar(25) NULL,
	"gross" 			numeric(18,6) NULL,
	"pay_periods_taxed"     	smallint NULL,
	"update_ytd_balances"   	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"bank_alias"    		varchar(25) NULL,
	"bank_account"  		varchar(35) NULL,
	"transit_routing_no"    	varchar(25) NULL,
	"direct_deposit"        	char(1) NULL,
	"dd_account_type"       	char(1) NULL,
	"basis_hours"   		numeric(18,6) NULL,
	"hours_worked"  		numeric(18,6) NULL,
	"pieces_paid"   		numeric(18,6) NULL,
	"amount_banked" 		numeric(18,6) NULL,
	"hours_ledger_account"  	varchar(50) NULL,
	"wcb_group"     		varchar(25) NULL,
	"hours_banked"  		numeric(18,6) NULL,
	"entitle_year"  		smallint NULL,
	"dd_foreign"    		char(1) NULL,
	"dd_foreign_bank"       	varchar(25) NULL,
	PRIMARY KEY ("payroll_calculation_id", "voucher", "voucher_sequence", "voucher_line", "check_void")
)
go
CREATE TABLE dbo."payroll_vouchers"
(
	"payroll_calculation_id"        varchar(25) NOT NULL,
	"voucher"       		varchar(25) NOT NULL,
	"voucher_sequence"      	varchar(25) NOT NULL,
	"employee"      		varchar(25) NULL,
	"unit"  			varchar(25) NULL,
	"bank_alias"    		varchar(25) NULL,
	"check_number"  		integer NULL,
	"check_void"    		char(1) NOT NULL,
	"check_type"    		char(1) NULL,
	"currency"      		varchar(25) NULL,
	"period_end_date"       	datetime NULL,
	"calendar_year" 		smallint NULL,
	"amount"        		numeric(18,6) NULL,
	"exchanged_amount"      	numeric(18,6) NULL,
	"fiscal_year"   		varchar(5) NULL,
	"period"        		smallint NULL,
	"gl_entry"      		varchar(25) NULL,
	"gl_date"       		datetime NULL,
	"ledger"        		varchar(40) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"direct_deposit"        	char(1) NULL,
	"employment_type"       	varchar(25) NULL,
	"location"      		varchar(25) NULL,
	"bank_account"  		varchar(35) NULL,
	"transit_routing_no"    	varchar(25) NULL,
	"dd_account_type"       	char(1) NULL,
	"check_message" 		varchar(250) NULL,
	"eir_business_number"   	varchar(25) NULL,
	"t4a"   			char(1) NULL,
	"province_id"   		varchar(3) NULL,
	"document_source"       	varchar(25) NULL,
	"dd_foreign"    		char(1) NULL,
	"dd_foreign_bank"       	varchar(25) NULL,
	PRIMARY KEY ("payroll_calculation_id", "voucher", "voucher_sequence", "check_void")
)
go
CREATE TABLE dbo."pos_register_cashiers"
(
	"pos_register"  		varchar(25) NOT NULL,
	"pos_cashier"   		varchar(25) NOT NULL,
	"pos_cashier_description"       varchar(50) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	PRIMARY KEY ("pos_register", "pos_cashier")
)
go
CREATE TABLE dbo."pos_registers"
(
	"pos_register"  		varchar(25) NOT NULL,
	"pccharge_user" 		varchar(25) NULL,
	"pos_register_description"      varchar(50) NULL,
	"pccharge_path" 		varchar(100) NULL,
	"pccharge_processor"    	varchar(25) NULL,
	"pccharge_merchant"     	varchar(25) NULL,
	"pccharge_timeout"      	smallint NULL,
	"pccharge_lastvaliddate"        varchar(25) NULL,
	"changed_user_id"       	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"pos_customer"  		varchar(25) NULL,
	"default_customer"      	varchar(25) NULL,
	"payment_credit_enabled"        varchar(25) NULL,
	"payment_cash_enabled"  	varchar(25) NULL,
	"payment_check_enabled" 	varchar(25) NULL,
	"payment_onaccount_enabled"     varchar(25) NULL,
	"print_invoice_credit"  	varchar(25) NULL,
	"print_invoice_cash"    	varchar(25) NULL,
	"print_invoice_check"   	varchar(25) NULL,
	"print_invoice_onaccount"       varchar(25) NULL,
	"print_receipt_credit"  	varchar(25) NULL,
	"print_receipt_cash"    	varchar(25) NULL,
	"print_receipt_check"   	varchar(25) NULL,
	"invoice_printer"       	varchar(75) NULL,
	"receipt_printer"       	varchar(75) NULL,
	"receipt_name_source"   	varchar(25) NULL,
	"freight_ledger_account"        varchar(50) NULL,
	"inventory_location"    	varchar(25) NULL,
	"number_of_receipts"    	smallint NULL,
	PRIMARY KEY ("pos_register")
)
go
CREATE TABLE dbo."pos_security_ids"
(
	"pos_security_id"       	varchar(25) NOT NULL,
	"pos_security_id_first_name"    varchar(25) NULL,
	"pos_security_id_last_name"     varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("pos_security_id")
)
go
CREATE TABLE dbo."position_budgets"
(
	"fiscal_year"   		varchar(5) NOT NULL,
	"ledger"        		varchar(40) NOT NULL,
	"organization_level"    	varchar(40) NOT NULL,
	"organization"  		varchar(40) NOT NULL,
	"position_budget_line"  	smallint NOT NULL,
	"sort_line"     		smallint NULL,
	"position"      		varchar(25) NULL,
	"annual_salary" 		numeric(18,6) NULL,
	"position_fte"  		numeric(18,6) NULL,
	"number_of_months"      	smallint NULL,
	"budget_salary" 		numeric(18,6) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"employee"      		varchar(25) NULL,
	"position_requisition"  	varchar(25) NULL,
	"status"        		char(1) NULL,
	"budget_note"   		text NULL,
	"fiscal_year_ledger"    	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"position_budget_id"    	integer NOT NULL IDENTITY(1, 1),
	"approved"      		char(1) NULL,
	"fringe_benefit_percent"        numeric(12,6) NULL,
	"budget_fringe_benefits"        numeric(18,6) NULL,
	PRIMARY KEY ("fiscal_year", "ledger", "organization_level", "organization", "position_budget_line")
)
go
CREATE TABLE dbo."position_categories"
(
	"position_category"     	varchar(25) NOT NULL,
	"position_category_description" text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("position_category")
)
go
CREATE TABLE dbo."position_certificates"
(
	"position"      		varchar(25) NOT NULL,
	"certificate"   		varchar(25) NOT NULL,
	"required"      		char(1) NULL,
	"minimum_rating"        	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("position", "certificate")
)
go
CREATE TABLE dbo."position_families"
(
	"position_family"       	varchar(25) NOT NULL,
	"position_family_description"   text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("position_family")
)
go
CREATE TABLE dbo."position_requisitions"
(
	"position_requisition"  	varchar(25) NOT NULL,
	"position_budget_id"    	integer NULL,
	"position"      		varchar(25) NOT NULL,
	"organization_level"    	varchar(40) NOT NULL,
	"organization"  		varchar(40) NOT NULL,
	"status"        		char(1) NULL,
	"employee"      		varchar(25) NULL,
	"date_opened"   		datetime NULL,
	"date_closed"   		datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"position_requisition_comment"  text NULL,
	"approved"      		char(1) NULL,
	"expected_start_date"   	datetime NULL,
	"fiscal_year"   		varchar(5) NULL,
	"ledger"        		varchar(40) NULL,
	"active_inactive"       	char(1) NULL,
	"application"   		varchar(25) NULL,
	"recruiter"     		varchar(25) NULL,
	PRIMARY KEY ("position_requisition")
)
go
CREATE TABLE dbo."positions"
(
	"position"      		varchar(25) NOT NULL,
	"position_description"  	varchar(50) NULL,
	"grade" 			varchar(25) NULL,
	"pay_type"      		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"eeoc_class"    		varchar(25) NULL,
	"review_form_file"      	varchar(25) NULL,
	"eeoc_function" 		varchar(25) NULL,
	"security_unit" 		varchar(25) NULL,
	"ipeds_primary_function"        varchar(25) NULL,
	"ipeds_academic_rank"   	varchar(25) NULL,
	"position_category"     	varchar(25) NULL,
	"position_family"       	varchar(25) NULL,
	"job_description"       	text NULL,
	"fringe_benefit_percent"        numeric(12,6) NULL,
	"fringe_benefit_account"        varchar(25) NULL,
	"application"   		varchar(25) NULL,
	"position_description_document" varchar(100) NULL,
	PRIMARY KEY ("position")
)
go
CREATE TABLE dbo."province_identifiers"
(
	"province_id"   		varchar(3) NOT NULL,
	"province_name" 		varchar(50) NULL,
	PRIMARY KEY ("province_id")
)
go
CREATE TABLE dbo."py_check_sort_temporary"
(
	"sort1" 			varchar(125) NULL,
	"sort2" 			varchar(125) NULL,
	"sort3" 			varchar(125) NULL,
	"sort4" 			varchar(125) NULL,
	"employee"      		varchar(25) NULL,
	"voucher"       		varchar(25) NULL,
	"check_amount"  		numeric(18,6) NULL
)
go
CREATE TABLE dbo."pyhr_locations"
(
	"location"      		varchar(25) NOT NULL,
	"location_description"  	varchar(50) NULL,
	"address_id"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("location")
)
go
CREATE TABLE dbo."retirement_adjustments"
(
	"employee"      		varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"entry_datetime"        	datetime NOT NULL,
	"payroll_cycle" 		varchar(25) NULL,
	"retirement_plan"       	varchar(25) NULL,
	"amount"        		numeric(18,6) NULL,
	"basis" 			numeric(18,6) NULL,
	"payer" 			char(1) NULL,
	"unit"  			varchar(25) NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"check_sequence"        	smallint NULL,
	"voucher"       		varchar(25) NULL,
	"check_void"    		char(1) NULL,
	"status"        		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"arrear_calculation_id" 	varchar(25) NULL,
	"arrear_voucher"        	varchar(25) NULL,
	"basis_hours"   		numeric(18,6) NULL,
	"adjustment_identity"   	integer NOT NULL IDENTITY(1, 1),
	"cr_ledger_account_code"        varchar(50) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"cost_account_code"     	varchar(25) NULL,
	PRIMARY KEY ("employee", "payroll_date", "entry_datetime", "adjustment_identity")
)
go
CREATE TABLE dbo."retirement_plan_group_basis"
(
	"retirement_plan_group" 	varchar(25) NOT NULL,
	"basis_document"        	varchar(5) NOT NULL,
	"basis_document_type"   	varchar(25) NOT NULL,
	"basis_operator"        	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("retirement_plan_group", "basis_document", "basis_document_type")
)
go
CREATE TABLE dbo."retirement_plans"
(
	"retirement_plan"       	varchar(25) NOT NULL,
	"retirement_plan_description"   varchar(50) NULL,
	"check_stub_description"        varchar(50) NULL,
	"employee_percent_rate_id"      varchar(25) NULL,
	"employee_amount_rate_id"       varchar(25) NULL,
	"employee_bt_retirement_plan"   varchar(25) NULL,
	"employee_at_retirement_plan"   varchar(25) NULL,
	"employer_retirement_plan"      varchar(25) NULL,
	"e_cr_ledger_account_code"      varchar(50) NULL,
	"r_cr_ledger_account_code"      varchar(50) NULL,
	"r_dr_ledger_account_code"      varchar(50) NULL,
	"employment_types"      	varchar(250) NULL,
	"eligibility_hire_seniority"    varchar(25) NULL,
	"eligibility_years"     	smallint NULL,
	"eligibility_months"    	smallint NULL,
	"eligibility_days"      	smallint NULL,
	"enrollment_month"      	smallint NULL,
	"enrollment_day"        	smallint NULL,
	"automatic_enrollment"  	char(1) NULL,
	"employee_percent_rate_event"   varchar(25) NULL,
	"employee_amount_rate_event"    varchar(25) NULL,
	"priority"      		smallint NULL,
	"arrear"        		char(1) NULL,
	"vendor"        		varchar(25) NULL,
	"item"  			varchar(25) NULL,
	"employer_percent_rate_id"      varchar(25) NULL,
	"employer_amount_rate_id"       varchar(25) NULL,
	"ledger"        		varchar(40) NULL,
	"check_sequence"        	smallint NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"employee_rate_style"   	varchar(25) NULL,
	"employer_rate_style"   	varchar(25) NULL,
	"security_unit" 		varchar(25) NULL,
	"employee_breakpoint"   	varchar(25) NULL,
	"employer_breakpoint"   	varchar(25) NULL,
	"plan_number"   		varchar(25) NULL,
	"retirement_plan_group" 	varchar(25) NULL,
	"cost_account_code"     	varchar(25) NULL,
	"enrollment_style"      	varchar(25) NULL,
	PRIMARY KEY ("retirement_plan")
)
go
CREATE TABLE dbo."retirement_plan_groups"
(
	"retirement_plan_group" 	varchar(25) NOT NULL,
	"retirement_plan_group_desc"    varchar(50) NULL,
	"employer_match_max_percent"    numeric(18,6) NULL,
	"employer_match_multiplier"     numeric(18,6) NULL,
	"employee_contribution_limit"   numeric(18,6) NULL,
	"employee_basis_limit"  	numeric(18,6) NULL,
	"employee_max_percent"  	numeric(18,6) NULL,
	"employer_match_max_amount"     numeric(18,6) NULL,
	"employer_match_basis_limit"    numeric(18,6) NULL,
	"employer_basis_limit"  	numeric(18,6) NULL,
	"employer_max_percent"  	numeric(18,6) NULL,
	"employer_contribution_limit"   numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"security_unit" 		varchar(25) NULL,
	"employer_match_method" 	varchar(25) NULL,
	PRIMARY KEY ("retirement_plan_group")
)
go
CREATE TABLE dbo."review_reasons"
(
	"review_reason" 		varchar(25) NOT NULL,
	"description"   		varchar(250) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("review_reason")
)
go
CREATE TABLE dbo."rl1_definition_basis"
(
	"rl1_box"       		varchar(10) NOT NULL,
	"document"      		varchar(5) NOT NULL,
	"document_type" 		varchar(25) NOT NULL,
	"database_column"       	varchar(10) NULL,
	"operator"      		char(1) NULL,
	"payer" 			char(1) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("rl1_box", "document", "document_type", "payer")
)
go
CREATE TABLE dbo."salary_grades"
(
	"grade" 			varchar(25) NOT NULL,
	"minimum_salary"        	numeric(18,6) NULL,
	"midpoint_salary"       	numeric(18,6) NULL,
	"maximum_salary"        	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("grade")
)
go
CREATE TABLE dbo."selection_form_values"
(
	"selection_form_id"     	integer NOT NULL,
	"control_id"    		varchar(50) NOT NULL,
	"control_text"  		varchar(255) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("selection_form_id", "control_id")
)
go
CREATE TABLE dbo."state_identifiers"
(
	"state_id"      		varchar(2) NOT NULL,
	"state_name"    		varchar(50) NULL,
	"state_code"    		varchar(2) NULL,
	PRIMARY KEY ("state_id")
)
go
CREATE TABLE dbo."so_blanket_items"
(
	"sales_order"   		varchar(25) NOT NULL,
	"blanket_line"  		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"item"  			varchar(50) NULL,
	"customer_item" 		varchar(50) NULL,
	"item_description"      	text NULL,
	"tax_1" 			varchar(25) NULL,
	"tax_2" 			varchar(25) NULL,
	"sales_analysis"        	varchar(25) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"cost_account"  		varchar(25) NULL,
	"selling_qty_uom"       	varchar(25) NULL,
	"selling_price_uom"     	varchar(25) NULL,
	"selling_to_price_conv" 	numeric(18,6) NULL,
	"blanket_price" 		numeric(18,6) NULL,
	"cum_quantity_ordered"  	numeric(18,6) NULL,
	"cum_extended_amount"   	numeric(18,6) NULL,
	"fulfillment"   		char(1) NULL,
	"fulfillment_location"  	varchar(25) NULL,
	"so_line_comment"       	text NULL,
	"selling_uom_to_standard"       numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("sales_order", "blanket_line")
)
go
CREATE TABLE dbo."so_blanket_freight_expenses"
(
	"sales_order"   		varchar(25) NOT NULL,
	"blanket_line"  		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"item"  			varchar(25) NULL,
	"item_description"      	text NULL,
	"freight_carrier"       	varchar(25) NULL,
	"cum_invoiced_amount"   	numeric(18,6) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"cost_account"  		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("sales_order", "blanket_line")
)
go
CREATE TABLE dbo."so_blanket_other_expenses"
(
	"sales_order"   		varchar(25) NOT NULL,
	"blanket_line"  		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"item"  			varchar(25) NULL,
	"item_description"      	varchar(50) NULL,
	"blanket_price" 		numeric(18,6) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"cost_account"  		varchar(25) NULL,
	"tax_1" 			varchar(25) NULL,
	"tax_2" 			varchar(25) NULL,
	"cum_quantity_invoiced" 	numeric(18,6) NULL,
	"cum_invoiced_amount"   	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("sales_order", "blanket_line")
)
go
CREATE TABLE dbo."so_consolidators"
(
	"consolidator"  		varchar(25) NOT NULL,
	"consolidator_description"      varchar(50) NULL,
	"address_id"    		varchar(25) NULL,
	"contact_id"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("consolidator")
)
go
CREATE TABLE dbo."so_freight_expenses"
(
	"sales_order"   		varchar(25) NOT NULL,
	"item"  			varchar(25) NULL,
	"freight_carrier"       	varchar(25) NULL,
	"estimated_cost"        	numeric(18,6) NULL,
	"invoiced_amount"       	numeric(18,6) NULL,
	"po_vendor"     		varchar(25) NULL,
	"po_unit"       		varchar(25) NULL,
	"po_type"       		varchar(25) NULL,
	"po_date"       		datetime NULL,
	"po_location"   		varchar(25) NULL,
	"po_buyer"      		varchar(25) NULL,
	"po_required_date"      	datetime NULL,
	"so_line"       		smallint NOT NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"sort_line"     		numeric(8,2) NULL,
	"po_freight_terms"      	varchar(25) NULL,
	"po_sales_terms"        	varchar(25) NULL,
	"po_sales_terms_location"       varchar(25) NULL,
	"item_description"      	text NULL,
	"po_ledger_account"     	varchar(50) NULL,
	"po_cost_account"       	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"po_currency"   		varchar(25) NULL,
	"po_ship_date"  		datetime NULL,
	"po_eta_date"   		datetime NULL,
	"po_terms"      		varchar(25) NULL,
	"po_fiscal_year"        	varchar(5) NULL,
	"po_gl_date"    		datetime NULL,
	"po_document_class"     	varchar(25) NULL,
	"purchase_order"        	varchar(25) NULL,
	"po_line"       		smallint NULL,
	"shipped_amount"        	numeric(18,6) NULL,
	"cancelled_amount"      	numeric(18,6) NULL,
	"so_release"    		varchar(25) NULL,
	"blanket_line"  		smallint NULL,
	PRIMARY KEY ("sales_order", "so_line")
)
go
CREATE TABLE dbo."so_headers"
(
	"sales_order"   		varchar(25) NOT NULL,
	"ship_customer" 		varchar(25) NULL,
	"bill_name"     		varchar(100) NULL,
	"bill_contact"  		varchar(50) NULL,
	"bill_address_1"        	varchar(50) NULL,
	"bill_address_2"        	varchar(50) NULL,
	"bill_address_3"        	varchar(50) NULL,
	"bill_city"     		varchar(25) NULL,
	"bill_state"    		varchar(25) NULL,
	"bill_postal_code"      	varchar(10) NULL,
	"bill_country"  		varchar(50) NULL,
	"bill_contact_email_address"    varchar(250) NULL,
	"bill_contact_fax_phone"        varchar(25) NULL,
	"bill_contact_phone"    	varchar(25) NULL,
	"customer_reference"    	varchar(50) NULL,
	"quote_date"    		datetime NULL,
	"quote_expiration_date" 	datetime NULL,
	"fiscal_year"   		varchar(5) NULL,
	"sales_agent"   		varchar(25) NULL,
	"account_manager"       	varchar(25) NULL,
	"order_processor"       	varchar(25) NULL,
	"sales_terms"   		varchar(25) NULL,
	"territory"     		varchar(25) NULL,
	"document_class"        	varchar(25) NULL,
	"document_type" 		char(1) NULL,
	"bill_unit"     		varchar(25) NULL,
	"currency"      		varchar(25) NULL,
	"price_group"   		varchar(25) NULL,
	"discount_percent"      	numeric(18,6) NULL,
	"payment_method"        	varchar(25) NULL,
	"payment_terms" 		varchar(25) NULL,
	"deposit_required"      	numeric(18,6) NULL,
	"deposit_received"      	numeric(18,6) NULL,
	"ship_name"     		varchar(100) NULL,
	"ship_address_1"        	varchar(50) NULL,
	"ship_address_2"        	varchar(50) NULL,
	"ship_address_3"        	varchar(50) NULL,
	"ship_city"     		varchar(25) NULL,
	"ship_state"    		varchar(25) NULL,
	"ship_postal_code"      	varchar(10) NULL,
	"ship_country"  		varchar(50) NULL,
	"ship_contact"  		varchar(50) NULL,
	"ship_contact_email_address"    varchar(250) NULL,
	"ship_contact_fax_phone"        varchar(25) NULL,
	"ship_contact_phone"    	varchar(25) NULL,
	"ship_markings" 		text NULL,
	"port_loading"  		varchar(25) NULL,
	"port_discharge"        	varchar(25) NULL,
	"quote_notification"    	varchar(6) NULL,
	"shipping_advice_notification"  varchar(6) NULL,
	"ship_via"      		varchar(25) NULL,
	"allow_backorder"       	char(1) NULL,
	"acknowledgement_printed"       datetime NULL,
	"approved"      		char(1) NULL,
	"confirmation_received_date"    datetime NULL,
	"confirmation_by"       	varchar(50) NULL,
	"acknowledgement_required"      char(1) NULL,
	"quote_required"        	char(1) NULL,
	"intercompany"  		char(1) NULL,
	"location"      		varchar(25) NULL,
	"finance_charge"        	varchar(25) NULL,
	"quote_revision_date"   	datetime NULL,
	"quote_revision_number" 	smallint NULL,
	"sales_term_location"   	varchar(25) NULL,
	"freight_terms" 		varchar(25) NULL,
	"freight_carrier"       	varchar(25) NULL,
	"lcd_issuing_bank_address"      text NULL,
	"lcd_advising_bank_address"     text NULL,
	"lcd_number"    		varchar(50) NULL,
	"lcd_cover_description" 	text NULL,
	"lcd_amount"    		numeric(18,6) NULL,
	"lcd_currency"  		varchar(25) NULL,
	"lcd_applicant" 		text NULL,
	"lcd_beneficiary"       	text NULL,
	"lcd_expiration_date"   	datetime NULL,
	"status_note"   		text NULL,
	"so_amount"     		numeric(18,6) NULL,
	"exchanged_amount"      	numeric(18,6) NULL,
	"target_ship_date"      	datetime NULL,
	"merchandise_amount"    	numeric(18,6) NULL,
	"other_expense_amount"  	numeric(18,6) NULL,
	"freight_amount"        	numeric(18,6) NULL,
	"tax_amount"    		numeric(18,6) NULL,
	"confirmation_requested_date"   datetime NULL,
	"ship_to_location"      	varchar(25) NULL,
	"consolidator"  		varchar(25) NULL,
	"consolidator_name"     	varchar(50) NULL,
	"consolidator_address_1"        varchar(50) NULL,
	"consolidator_address_2"        varchar(50) NULL,
	"consolidator_address_3"        varchar(50) NULL,
	"consolidator_city"     	varchar(25) NULL,
	"consolidator_state"    	varchar(25) NULL,
	"consolidator_postal_code"      varchar(25) NULL,
	"consolidator_country"  	varchar(50) NULL,
	"consolidator_contact"  	varchar(50) NULL,
	"consolidator_phone"    	varchar(25) NULL,
	"consolidator_fax_phone"        varchar(25) NULL,
	"consolidator_email_address"    varchar(250) NULL,
	"ship_unit"     		varchar(25) NULL,
	"bill_customer" 		varchar(25) NULL,
	"order_priority"        	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"ledger"        		varchar(40) NULL,
	"so_ship_date"  		datetime NULL,
	"so_eta_date"   		datetime NULL,
	"so_cost"       		numeric(18,6) NULL,
	"so_merchandise_cost"   	numeric(18,6) NULL,
	"so_other_expense_cost" 	numeric(18,6) NULL,
	"so_freight_cost"       	numeric(18,6) NULL,
	"cancelled_date"        	datetime NULL,
	"cancelled_reason"      	varchar(25) NULL,
	"discount_item" 		varchar(50) NULL,
	"discount_item_description"     text NULL,
	"discount_item_percent" 	numeric(18,6) NULL,
	"discount_item_basis"   	numeric(18,6) NULL,
	"discount_item_amount"  	numeric(18,6) NULL,
	"discount_item_ledger_account"  varchar(50) NULL,
	"discount_item_cost_account"    varchar(25) NULL,
	"discount_item_sales_analysis"  varchar(25) NULL,
	"discount_item_tax_1"   	varchar(25) NULL,
	"discount_item_tax_2"   	varchar(25) NULL,
	"discount_item_agent_percent"   numeric(18,6) NULL,
	"discount_item_manager_percent" numeric(18,6) NULL,
	"label_name"    		varchar(25) NULL,
	PRIMARY KEY ("sales_order")
)
go
CREATE TABLE dbo."so_items"
(
	"sales_order"   		varchar(25) NOT NULL,
	"so_line"       		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"item"  			varchar(50) NULL,
	"customer_item" 		varchar(50) NULL,
	"item_description"      	text NULL,
	"status"        		char(1) NULL,
	"status_reason" 		varchar(25) NULL,
	"tax_1" 			varchar(25) NULL,
	"tax_2" 			varchar(25) NULL,
	"freight"       		varchar(25) NULL,
	"sales_analysis"        	varchar(25) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"quantity_ordered"      	numeric(18,6) NULL,
	"quantity_shipped"      	numeric(18,6) NULL,
	"quantity_cancelled"    	numeric(18,6) NULL,
	"selling_qty_uom"       	varchar(25) NULL,
	"selling_price_uom"     	varchar(25) NULL,
	"selling_to_price_conv" 	numeric(18,6) NULL,
	"price_list"    		numeric(18,6) NULL,
	"price_discount"        	numeric(18,6) NULL,
	"price_net"     		numeric(18,6) NULL,
	"cost_list"     		numeric(18,6) NULL,
	"cost_discount" 		numeric(18,6) NULL,
	"cost_net"      		numeric(18,6) NULL,
	"po_purchasing_uom"     	varchar(25) NULL,
	"po_po_pricing_uom"     	varchar(25) NULL,
	"po_purchasing_to_pricing_conv" numeric(18,6) NULL,
	"selling_to_purchasing_conv"    numeric(18,6) NULL,
	"selling_extended_amount"       numeric(18,6) NULL,
	"cost_extended_amount"  	numeric(18,6) NULL,
	"fulfillment"   		char(1) NULL,
	"purchase_order"        	varchar(25) NULL,
	"po_line"       		smallint NULL,
	"po_unit"       		varchar(25) NULL,
	"po_buyer"      		varchar(25) NULL,
	"po_type"       		varchar(25) NULL,
	"po_date"       		datetime NULL,
	"po_sales_terms"        	varchar(25) NULL,
	"po_sales_terms_location"       varchar(25) NULL,
	"po_freight_terms"      	varchar(25) NULL,
	"fulfillment_location"  	varchar(25) NULL,
	"po_currency"   		varchar(25) NULL,
	"so_line_comment"       	text NULL,
	"line_type"     		varchar(2) NULL,
	"po_quantity_ordered"   	numeric(18,6) NULL,
	"po_vendor"     		varchar(25) NULL,
	"po_required_date"      	datetime NULL,
	"po_ship_date"  		datetime NULL,
	"po_eta_date"   		datetime NULL,
	"selling_uom_to_standard"       numeric(18,6) NULL,
	"po_quantity_uom_to_standard"   numeric(18,6) NULL,
	"mark_up_down"  		char(1) NULL,
	"mark_up_down_percent"  	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"sales_agent_percent"   	numeric(18,6) NULL,
	"account_manager_percent"       numeric(18,6) NULL,
	"po_terms"      		varchar(25) NULL,
	"po_fiscal_year"        	varchar(5) NULL,
	"po_gl_date"    		datetime NULL,
	"po_document_class"     	varchar(25) NULL,
	"po_tax_1"      		varchar(25) NULL,
	"po_tax_2"      		varchar(25) NULL,
	"po_ledger_account"     	varchar(50) NULL,
	"po_cost_account"       	varchar(25) NULL,
	"shipped_amount"        	numeric(18,6) NULL,
	"cancelled_amount"      	numeric(18,6) NULL,
	"inventoried"   		char(1) NULL,
	"po_quantity_tolerance" 	numeric(18,6) NULL,
	"po_price_tolerance"    	numeric(18,6) NULL,
	"so_release"    		varchar(25) NULL,
	"blanket_line"  		smallint NULL,
	PRIMARY KEY ("sales_order", "so_line")
)
go
CREATE TABLE dbo."so_notes"
(
	"sales_order"   		varchar(25) NOT NULL,
	"so_line"       		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"standard_clause"       	varchar(25) NULL,
	"so_note"       		text NULL,
	"quote_print"   		char(1) NULL,
	"order_print"   		char(1) NULL,
	"po_print"      		char(1) NULL,
	"ship_advice_print"     	char(1) NULL,
	"bill_of_lading_print"  	char(1) NULL,
	"invoice_print" 		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"markings"      		char(1) NULL,
	PRIMARY KEY ("sales_order", "so_line")
)
go
CREATE TABLE dbo."so_order_processors"
(
	"order_processor"       	varchar(25) NOT NULL,
	"order_processor_description"   varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("order_processor")
)
go
CREATE TABLE dbo."so_other_expenses"
(
	"sales_order"   		varchar(25) NOT NULL,
	"item"  			varchar(25) NULL,
	"item_description"      	varchar(50) NULL,
	"estimated_cost"        	numeric(18,6) NULL,
	"invoiced_amount"       	numeric(18,6) NULL,
	"po_ledger_account"     	varchar(50) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"po_vendor"     		varchar(25) NULL,
	"po_unit"       		varchar(25) NULL,
	"po_type"       		varchar(25) NULL,
	"po_date"       		datetime NULL,
	"po_location"   		varchar(25) NULL,
	"po_buyer"      		varchar(25) NULL,
	"po_required_date"      	datetime NULL,
	"tax_1" 			varchar(25) NULL,
	"tax_2" 			varchar(25) NULL,
	"po_cost_account"       	varchar(50) NULL,
	"so_line"       		smallint NOT NULL,
	"sort_line"     		numeric(8,2) NULL,
	"po_sales_terms"        	varchar(25) NULL,
	"po_sales_terms_location"       varchar(25) NULL,
	"po_freight_terms"      	varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"sales_agent_percent"   	numeric(18,6) NULL,
	"account_manager_percent"       numeric(18,6) NULL,
	"po_currency"   		varchar(25) NULL,
	"po_ship_date"  		datetime NULL,
	"po_eta_date"   		datetime NULL,
	"po_terms"      		varchar(25) NULL,
	"po_fiscal_year"        	varchar(5) NULL,
	"po_gl_date"    		datetime NULL,
	"po_document_class"     	varchar(25) NULL,
	"purchase_order"        	varchar(25) NULL,
	"po_line"       		smallint NULL,
	"po_tax_1"      		varchar(25) NULL,
	"po_tax_2"      		varchar(25) NULL,
	"shipped_amount"        	numeric(18,6) NULL,
	"cancelled_amount"      	numeric(18,6) NULL,
	"so_release"    		varchar(25) NULL,
	"blanket_line"  		smallint NULL,
	PRIMARY KEY ("sales_order", "so_line")
)
go
CREATE TABLE dbo."so_ports"
(
	"port"  			varchar(25) NOT NULL,
	"port_description"      	varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("port")
)
go
CREATE TABLE dbo."so_releases"
(
	"sales_order"   		varchar(25) NOT NULL,
	"so_release"    		varchar(25) NOT NULL,
	"so_release_id" 		varchar(40) NULL,
	"order_date"    		datetime NULL,
	"so_required_date"      	datetime NULL,
	"order_revision_date"   	datetime NULL,
	"order_revision_number" 	smallint NULL,
	"order_notification"    	varchar(6) NULL,
	"printed"       		char(1) NULL,
	"status"        		char(1) NULL,
	"batch" 			varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"edi_file_name" 		varchar(50) NULL,
	"edi_customer"  		varchar(25) NULL,
	"edi_vendor"    		varchar(25) NULL,
	"edi_dock"      		varchar(25) NULL,
	"edi_accum_start_date"  	datetime NULL,
	"edi_accum_end_date"    	datetime NULL,
	"hold_document" 		char(1) NULL,
	"hold_reason"   		varchar(25) NULL,
	PRIMARY KEY ("sales_order", "so_release")
)
go
CREATE TABLE dbo."so_scoreboard_notes"
(
	"sales_order"   		varchar(25) NOT NULL,
	"note_date"     		datetime NOT NULL,
	"sales_order_note"      	text NULL,
	"follow_up_date"        	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("sales_order", "note_date")
)
go
CREATE TABLE dbo."so_shippers"
(
	"shipper"       		varchar(25) NOT NULL,
	"ship_customer" 		varchar(25) NULL,
	"ship_via"      		varchar(25) NULL,
	"carrier"       		varchar(25) NULL,
	"transport_vessel"      	varchar(50) NULL,
	"scheduled_ship_date"   	datetime NULL,
	"actual_ship_date"      	datetime NULL,
	"location"      		varchar(25) NULL,
	"shipping_container"    	varchar(25) NULL,
	"shipper_status"        	varchar(25) NULL,
	"booking_number"        	varchar(25) NULL,
	"eta_date"      		datetime NULL,
	"port_loading"  		varchar(25) NULL,
	"port_discharge"        	varchar(25) NULL,
	"payment_terms" 		varchar(25) NULL,
	"lcd_number"    		varchar(50) NULL,
	"status_note"   		text NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"document_note" 		text NULL,
	"document_type" 		char(1) NULL,
	"document"      		varchar(25) NULL,
	"payment_method"        	varchar(25) NULL,
	"sales_terms"   		varchar(25) NULL,
	"sales_term_location"   	varchar(25) NULL,
	"freight_terms" 		varchar(25) NULL,
	"document_date" 		datetime NULL,
	"bill_customer" 		varchar(25) NULL,
	"bill_address_1"        	varchar(50) NULL,
	"bill_address_2"        	varchar(50) NULL,
	"bill_address_3"        	varchar(50) NULL,
	"bill_city"     		varchar(25) NULL,
	"bill_state"    		varchar(25) NULL,
	"bill_postal_code"      	varchar(10) NULL,
	"bill_country"  		varchar(50) NULL,
	"bill_contact"  		varchar(50) NULL,
	"bill_contact_email_address"    varchar(250) NULL,
	"bill_contact_fax_phone"        varchar(25) NULL,
	"bill_contact_phone"    	varchar(25) NULL,
	"ship_address_1"        	varchar(50) NULL,
	"ship_address_2"        	varchar(50) NULL,
	"ship_address_3"        	varchar(50) NULL,
	"ship_city"     		varchar(25) NULL,
	"ship_state"    		varchar(25) NULL,
	"ship_postal_code"      	varchar(10) NULL,
	"ship_country"  		varchar(50) NULL,
	"ship_contact"  		varchar(50) NULL,
	"ship_contact_email_address"    varchar(250) NULL,
	"ship_contact_fax_phone"        varchar(25) NULL,
	"ship_contact_phone"    	varchar(25) NULL,
	"ship_unit"     		varchar(25) NULL,
	"bill_unit"     		varchar(25) NULL,
	"bill_name"     		varchar(100) NULL,
	"ship_name"     		varchar(100) NULL,
	"due_date"      		datetime NULL,
	"gl_date"       		datetime NULL,
	"fiscal_year"   		varchar(5) NULL,
	"batch" 			varchar(25) NULL,
	"account_manager"       	varchar(25) NULL,
	"sales_agent"   		varchar(25) NULL,
	"document_class"        	varchar(25) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"currency"      		varchar(25) NULL,
	"printed"       		char(1) NULL,
	"intercompany"  		char(1) NULL,
	"send_invoice_to"       	varchar(25) NULL,
	"territory"     		varchar(25) NULL,
	"shipper_note"  		text NULL,
	"bol_note"      		text NULL,
	"lcd_issuing_bank_address"      text NULL,
	"lcd_advising_bank_address"     text NULL,
	"lcd_cover_description" 	text NULL,
	"lcd_amount"    		numeric(18,6) NULL,
	"lcd_currency"  		varchar(25) NULL,
	"lcd_applicant" 		text NULL,
	"lcd_beneficiary"       	text NULL,
	"lcd_expiration_date"   	datetime NULL,
	"ledger"        		varchar(40) NULL,
	"ship_to_location"      	varchar(25) NULL,
	"printed_bol"   		char(1) NULL,
	"gl_entry"      		varchar(25) NULL,
	"period"        		smallint NULL,
	"price_group"   		varchar(25) NULL,
	"contract_po"   		varchar(25) NULL,
	"tax_exempt_number"     	varchar(25) NULL,
	"printed_picklist"      	char(1) NULL,
	"shipper_rma_flag"      	char(1) NOT NULL,
	"update_inventory"      	char(1) NULL,
	"update_sales_order"    	char(1) NULL,
	"ship_time"     		datetime NULL,
	"document_source"       	varchar(25) NULL,
	"printed_customs_invoice"       char(1) NULL,
	PRIMARY KEY ("shipper", "shipper_rma_flag")
)
go
CREATE TABLE dbo."so_shipper_discounts"
(
	"shipper"       		varchar(25) NOT NULL,
	"sort_line"     		numeric(18,6) NULL,
	"shipper_line"  		smallint NOT NULL,
	"item"  			varchar(25) NULL,
	"item_description"      	text NULL,
	"discount_percent"      	numeric(18,6) NULL,
	"discount_basis"        	numeric(18,6) NULL,
	"discount_amount"       	numeric(18,6) NULL,
	"ledger_account"        	varchar(50) NULL,
	"contract_account_id"   	varchar(25) NULL,
	"sales_analysis"        	varchar(25) NULL,
	"tax_1" 			varchar(25) NULL,
	"tax_2" 			varchar(25) NULL,
	"sales_agent_percent"   	numeric(18,6) NULL,
	"account_manager_percent"       numeric(18,6) NULL,
	"sales_order"   		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"shipper_rma_flag"      	char(1) NOT NULL,
	PRIMARY KEY ("shipper", "shipper_line", "shipper_rma_flag")
)
go
CREATE TABLE dbo."so_shipper_freight_charges"
(
	"shipper"       		varchar(25) NOT NULL,
	"sort_line"     		numeric(18,6) NULL,
	"shipper_line"  		smallint NOT NULL,
	"invoiced_amount"       	numeric(18,6) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"sales_order"   		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"item"  			varchar(25) NULL,
	"item_description"      	text NULL,
	"estimated_cost"        	numeric(18,6) NULL,
	"so_line"       		smallint NULL,
	"freight_carrier"       	varchar(25) NULL,
	"purchase_order"        	varchar(25) NULL,
	"bill_of_lading"        	varchar(25) NULL,
	"shipper_rma_flag"      	char(1) NOT NULL,
	PRIMARY KEY ("shipper", "shipper_line", "shipper_rma_flag")
)
go
CREATE TABLE dbo."so_shipper_items"
(
	"shipper"       		varchar(25) NOT NULL,
	"sort_line"     		numeric(18,6) NULL,
	"shipper_line"  		smallint NOT NULL,
	"item"  			varchar(25) NULL,
	"location"      		varchar(25) NULL,
	"serial_number" 		varchar(25) NULL,
	"quantity_shipped"      	numeric(18,6) NULL,
	"selling_to_inventory_conv"     numeric(18,6) NULL,
	"cost"  			numeric(18,6) NULL,
	"extended_amount"       	numeric(18,6) NULL,
	"exchanged_amount"      	numeric(18,6) NULL,
	"sales_order"   		varchar(25) NULL,
	"so_line"       		smallint NULL,
	"invoice"       		varchar(25) NULL,
	"invoice_line"  		smallint NULL,
	"container_id"  		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"vessel_container"      	varchar(25) NULL,
	"country_of_origin"     	varchar(25) NULL,
	"account_manager_percent"       numeric(18,6) NULL,
	"sales_agent_percent"   	numeric(18,6) NULL,
	"package"       		varchar(25) NULL,
	"unit"  			varchar(25) NULL,
	"currency"      		varchar(25) NULL,
	"debit_ledger_account"  	varchar(50) NULL,
	"credit_ledger_account" 	varchar(50) NULL,
	"item_transaction_id"   	varchar(25) NULL,
	"package_uom"   		varchar(25) NULL,
	"package_gross_weight"  	numeric(18,6) NULL,
	"package_net_weight"    	numeric(18,6) NULL,
	"package_weight_uom"    	varchar(25) NULL,
	"package_gross_weight_kgs"      numeric(18,6) NULL,
	"package_net_weight_kgs"        numeric(18,6) NULL,
	"package_width" 		numeric(18,6) NULL,
	"package_length"        	numeric(18,6) NULL,
	"package_height"        	numeric(18,6) NULL,
	"package_dimensions_uom"        varchar(25) NULL,
	"number_of_packages"    	numeric(18,6) NULL,
	"rma_shipper"   		varchar(25) NULL,
	"rma_shipper_line"      	smallint NULL,
	"shipper_rma_flag"      	char(1) NOT NULL,
	PRIMARY KEY ("shipper", "shipper_line", "shipper_rma_flag")
)
go
CREATE TABLE dbo."so_shipper_other_charges"
(
	"shipper"       		varchar(25) NOT NULL,
	"sort_line"     		numeric(18,6) NULL,
	"shipper_line"  		smallint NOT NULL,
	"item"  			varchar(25) NOT NULL,
	"item_description"      	text NULL,
	"invoiced_amount"       	numeric(18,6) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"tax_1" 			varchar(25) NULL,
	"tax_2" 			varchar(25) NULL,
	"sales_order"   		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"estimated_cost"        	numeric(18,6) NULL,
	"account_manager_percent"       numeric(18,6) NULL,
	"sales_agent_percent"   	numeric(18,6) NULL,
	"so_line"       		smallint NULL,
	"purchase_order"        	varchar(25) NULL,
	"bill_of_lading"        	varchar(25) NULL,
	"shipper_rma_flag"      	char(1) NOT NULL,
	PRIMARY KEY ("shipper", "shipper_line", "shipper_rma_flag")
)
go
CREATE TABLE dbo."t4_definition_basis"
(
	"t4_box"        		varchar(10) NOT NULL,
	"document"      		varchar(5) NOT NULL,
	"document_type" 		varchar(25) NOT NULL,
	"database_column"       	varchar(10) NULL,
	"operator"      		char(1) NULL,
	"payer" 			char(1) NOT NULL,
	"rpp_registration_number"       varchar(10) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("t4_box", "document", "document_type", "payer")
)
go
CREATE TABLE dbo."t4a_footnote_codes"
(
	"footnote_code" 		varchar(2) NOT NULL,
	"footnote_code_description"     varchar(100) NULL,
	"t4a_text"      		varchar(100) NULL,
	PRIMARY KEY ("footnote_code")
)
go
CREATE TABLE dbo."tax_adjustments"
(
	"employee"      		varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"entry_datetime"        	datetime NOT NULL,
	"payroll_cycle" 		varchar(25) NULL,
	"tax_type"      		varchar(25) NULL,
	"amount"        		numeric(18,6) NULL,
	"basis" 			numeric(18,6) NULL,
	"unit"  			varchar(25) NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"check_sequence"        	smallint NULL,
	"voucher"       		varchar(25) NULL,
	"check_void"    		char(1) NULL,
	"status"        		char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"basis_hours"   		numeric(18,6) NULL,
	"adjustment_identity"   	integer NOT NULL IDENTITY(1, 1),
	"cr_ledger_account_code"        varchar(50) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"cost_account_code"     	varchar(25) NULL,
	PRIMARY KEY ("employee", "payroll_date", "entry_datetime", "adjustment_identity")
)
go
CREATE TABLE dbo."tax_rate_basis"
(
	"tax_type"      		varchar(25) NOT NULL,
	"basis_document"        	varchar(5) NOT NULL,
	"basis_document_type"   	varchar(25) NOT NULL,
	"basis_operator"        	char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("tax_type", "basis_document", "basis_document_type")
)
go
CREATE TABLE dbo."tax_rates_local"
(
	"tax_type"      		varchar(25) NOT NULL,
	"breakpoint"    		numeric(18,6) NOT NULL,
	"base"  			numeric(18,6) NULL,
	"tax_percent"   		numeric(12,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("tax_type", "breakpoint")
)
go
CREATE TABLE dbo."tax_types"
(
	"tax_type"      		varchar(25) NOT NULL,
	"tax_type_description"  	varchar(50) NULL,
	"check_stub_description"        varchar(50) NULL,
	"payer" 			char(1) NULL,
	"ledger"        		varchar(40) NULL,
	"cr_ledger_account_code"        varchar(50) NULL,
	"dr_ledger_account_code"        varchar(50) NULL,
	"tax_calculation_source"        char(1) NULL,
	"vendor"        		varchar(25) NULL,
	"item"  			varchar(25) NULL,
	"exemption_amount"      	numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"security_unit" 		varchar(25) NULL,
	"cost_account_code"     	varchar(25) NULL,
	"w2_local"      		char(1) NULL,
	"annualized_or_ytd"     	char(1) NULL,
	PRIMARY KEY ("tax_type")
)
go
CREATE TABLE dbo."termination_reasons"
(
	"termination_reason"    	varchar(25) NOT NULL,
	"description"   		varchar(250) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("termination_reason")
)
go
CREATE TABLE dbo."time_card_calendar_dates"
(
	"time_card_calendar"    	varchar(25) NOT NULL,
	"calendar_date" 		datetime NOT NULL,
	"calendar_year" 		varchar(4) NULL,
	"override_employee_defaults"    char(1) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("time_card_calendar", "calendar_date")
)
go
CREATE TABLE dbo."time_card_calendar_schedule"
(
	"time_card_calendar"    	varchar(25) NOT NULL,
	"calendar_date" 		datetime NOT NULL,
	"calendar_date_id"      	varchar(25) NOT NULL,
	"calendar_year" 		varchar(4) NULL,
	"scheduled_hours"       	numeric(18,6) NULL,
	"pay_type"      		varchar(25) NULL,
	"rate_event"    		varchar(25) NULL,
	"additional_hours_pay_type"     varchar(25) NULL,
	"additional_hours_rate_event"   varchar(25) NULL,
	"start_time"    		datetime NULL,
	"end_time"      		datetime NULL,
	"pieces_paid"   		numeric(18,6) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("time_card_calendar", "calendar_date", "calendar_date_id")
)
go
CREATE TABLE dbo."time_card_calendars"
(
	"time_card_calendar"    	varchar(25) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("time_card_calendar")
)
go
CREATE TABLE dbo."time_card_groups"
(
	"time_card_group"       	varchar(25) NOT NULL,
	"time_card_group_description"   text NULL,
	"entry_user_id" 		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"signature_list"        	varchar(25) NULL,
	"time_card_calendar"    	varchar(25) NULL,
	PRIMARY KEY ("time_card_group")
)
go
CREATE TABLE dbo."time_card_header_notes"
(
	"payroll_cycle" 		varchar(25) NOT NULL,
	"time_card_group"       	varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"time_card_type"        	varchar(25) NOT NULL,
	"note_date"     		datetime NOT NULL,
	"header_note"   		text NULL,
	"follow_up_date"        	datetime NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("payroll_cycle", "time_card_group", "payroll_date", "time_card_type", "note_date")
)
go
CREATE TABLE dbo."time_cards"
(
	"employee"      		varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"entry_date"    		datetime NOT NULL,
	"payroll_cycle" 		varchar(25) NULL,
	"pay_type"      		varchar(25) NULL,
	"position"      		varchar(25) NULL,
	"rate_id"       		varchar(25) NULL,
	"rate_event"    		varchar(25) NULL,
	"hours" 			numeric(18,6) NULL,
	"rate"  			numeric(18,6) NULL,
	"amount"        		numeric(18,6) NULL,
	"ledger_account_code"   	varchar(50) NULL,
	"cost_account_code"     	varchar(50) NULL,
	"date_worked"   		datetime NULL,
	"location"      		varchar(25) NULL,
	"unit"  			varchar(25) NULL,
	"payroll_calculation_id"        varchar(25) NULL,
	"check_sequence"        	smallint NULL,
	"pay_periods_taxed"     	smallint NULL,
	"voucher"       		varchar(25) NULL,
	"check_void"    		char(1) NULL,
	"status"        		char(1) NULL,
	"accrual_id"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"entitle_year"  		smallint NULL,
	"time_card_group"       	varchar(25) NULL,
	"hours_worked"  		numeric(18,6) NULL,
	"pieces_paid"   		numeric(18,6) NULL,
	"shift_worked"  		varchar(50) NULL,
	"amount_banked" 		numeric(18,6) NULL,
	"hours_banked"  		numeric(18,6) NULL,
	"division"      		varchar(25) NULL,
	"batch" 			varchar(25) NULL,
	"crew"  			varchar(25) NULL,
	"time_card_comment"     	text NULL,
	"time_card_identity"    	numeric(18,0) NOT NULL IDENTITY(1, 1),
	"fastudentaidid"        	integer NULL,
	"start_time"    		datetime NULL,
	"end_time"      		datetime NULL,
	PRIMARY KEY ("employee", "payroll_date", "entry_date", "time_card_identity")
)
go
CREATE TABLE dbo."time_cards_defaulted"
(
	"payroll_cycle" 		varchar(25) NOT NULL,
	"payroll_date"  		datetime NOT NULL,
	"time_card_group_crew"  	varchar(25) NOT NULL,
	"time_card_type"        	varchar(25) NOT NULL,
	"employee"      		varchar(25) NOT NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("payroll_cycle", "payroll_date", "time_card_group_crew", "time_card_type", "employee")
)
go
CREATE TABLE dbo."training_locations"
(
	"location"      		varchar(25) NOT NULL,
	"location_description"  	varchar(50) NULL,
	"address_id"    		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("location")
)
go
CREATE TABLE dbo."units_fixed_assets"
(
	"unit"  			varchar(25) NOT NULL,
	"name"  			varchar(40) NULL,
	"ledger"        		varchar(40) NULL,
	"status"        		char(1) NULL,
	"gl_entry_frequency"    	char(1) NULL,
	"company"       		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("unit")
)
go
CREATE TABLE dbo."units_payroll_hr"
(
	"unit"  			varchar(25) NOT NULL,
	"name"  			varchar(40) NULL,
	"ledger"        		varchar(40) NULL,
	"status"        		char(1) NULL,
	"gl_entry_frequency"    	char(1) NULL,
	"company"       		varchar(25) NULL,
	"accr_pay_ledger_account_code"  varchar(50) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"time_card_approval_freq"       varchar(25) NULL,
	"active_inactive"       	char(1) NULL,
	PRIMARY KEY ("unit")
)
go
CREATE TABLE dbo."w2_definition_basis"
(
	"w2_box"        		varchar(10) NOT NULL,
	"document"      		varchar(5) NOT NULL,
	"document_type" 		varchar(25) NOT NULL,
	"database_column"       	varchar(10) NULL,
	"operator"      		char(1) NULL,
	"box14_description"     	varchar(10) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	"payer" 			char(1) NOT NULL,
	PRIMARY KEY ("w2_box", "document", "document_type", "payer")
)
go
CREATE TABLE dbo."work_orders"
(
	"work_order"    		varchar(25) NOT NULL,
	"work_order_date"       	datetime NULL,
	"item"  			varchar(25) NULL,
	"location"      		varchar(25) NULL,
	"inventory_quantity"    	numeric(18,6) NULL,
	"sales_order"   		varchar(25) NULL,
	"customer"      		varchar(25) NULL,
	"team_leader"   		varchar(25) NULL,
	"shift_worked"  		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("work_order")
)
go
CREATE TABLE dbo."item_physical_inventory_result"
(
	"physical_inventory_id" 	varchar(25) NOT NULL,
	"item"  			varchar(50) NOT NULL,
	"location"      		varchar(25) NOT NULL,
	"serial_number" 		varchar(50) NOT NULL,
	"phy_inv_date"  		datetime NULL,
	"phy_inv_employee"      	varchar(50) NULL,
	"phy_inv_qty"   		numeric(18,6) NULL,
	"phy_inv_section"       	varchar(25) NULL,
	"phy_inv_aisle" 		varchar(25) NULL,
	"phy_inv_shelf" 		varchar(25) NULL,
	"changed_date"  		datetime NULL,
	"changed_user_id"       	varchar(25) NULL,
	PRIMARY KEY ("physical_inventory_id", "item", "location", "serial_number")
)
go

rollback
go

--commit work
--go


--------------------------------------------------------------------------------------------------
--    Reload data
--------------------------------------------------------------------------------------------------

--LOAD TABLE dbo."pbcatcol"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\161.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pbcatfmt"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\162.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."trans_mode"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\163.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pbcattbl"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\164.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."customer_additional"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\165.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_setups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\166.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."destination_shipping"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\167.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."defect_codes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\168.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."location"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\169.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."machine"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\170.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."order_header"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\171.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\172.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."quote"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\173.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."quote_detail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\174.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."object"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\175.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."down_pointer"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\176.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."downtime_codes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\177.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."mold"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\178.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_header"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\179.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_detail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\180.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."vendor"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\181.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pbcatvld"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\182.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pbcatedt"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\183.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."unit_measure"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\184.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."activity_codes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\185.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."activity_costs"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\186.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."activity_router"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\187.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."company_info"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\188.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."audit_trail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\189.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."unit_conversion"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\190.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_unit_conversion"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\191.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_vendor"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\192.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_inventory"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\193.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_characteristics"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\194.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."customer"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\195.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."contact"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\196.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."company"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\197.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."product_line"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\198.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."phone"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\199.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."process"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\200.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_online"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\201.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."parameters"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\202.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."shipper"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\203.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."destination"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\204.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."shipper_detail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\205.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."dw_inquiry_files"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\206.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_purchasing"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\207.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."commodity"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\208.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_standard"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\209.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_customer_price_matrix"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\210.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."workorder_detail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\211.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."effective_change_notice"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\212.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."group_technology"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\213.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."labor"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\214.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."machine_process"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\215.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_machine"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\216.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."department"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\217.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."salesrep"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\218.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."carrier"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\219.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_customer"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\220.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."package_materials"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\221.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_packaging"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\222.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."machine_policy"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\223.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."asn_overlay_structure"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\224.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."bill_of_lading"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\225.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."temp_order_cum"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\226.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."temp_pops"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\227.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."order_detail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\228.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."link"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\229.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."shipper_container"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\230.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."user_definable_module_labels"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\231.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."plant_part"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\232.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."user_definable_data"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\233.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_overlay_structure"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\234.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."workorder_detail_history"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\235.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."inventory_parameters"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\236.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."location_limits"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\237.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_detail_history"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\238.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."destination_package"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\239.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."user_defined_status"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\240.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."price_promotion"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\241.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."category"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\242.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."limit_parts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\243.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."interface_utilities"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\244.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."term"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\245.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."alternative_parts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\246.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."destination_conversion"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\247.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."destination_message_file"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\248.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."temp_completions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\249.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."temp_boms"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\250.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."temp_objs"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\251.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."gt_bom_info"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\252.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."bill_of_material_ec"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\253.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."contact_call_log"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\254.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."currency_conversion"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\255.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."customer_origin_code"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\256.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."customer_service_status"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\257.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."dim_relation"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\258.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."dimensions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\259.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_ff_layout"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\260.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_ff_loops"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\261.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."gl_tran_type"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\262.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."issues"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\263.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."issues_category"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\264.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."issues_status"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\265.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."machine_data_1050"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\266.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_class_definition"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\267.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_gl_account"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\268.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_location"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\269.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_machine_tool"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\270.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_tooling"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\271.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_machine_tool_list"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\272.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_type_definition"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\273.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."partlist"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\274.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."report_list"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\275.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."unit_sub"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\276.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."vendor_custom"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\277.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."issue_detail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\278.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."issues_sub_category"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\279.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."machine_serial_comm"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\280.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_class_type_cross_ref"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\281.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_revision"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\282.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."region_code"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\283.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."report_library"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\284.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sales_manager_code"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\285.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."addresses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\286.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."allocation_definitions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\287.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."bank_accounts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\288.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."bank_register"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\289.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."bank_statements"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\290.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."banks"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\291.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."companies"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\292.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."contacts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\293.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."freight"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\294.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."freight_terms"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\295.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."identifier_formats"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\296.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."identifier_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\297.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."navigation_group_options"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\298.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."navigation_groups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\299.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."navigation_options"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\300.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."navigation_tablet_options"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\301.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."navigation_tablets"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\302.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."preferences_site"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\303.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."preferences_standard"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\304.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."preferences_user"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\305.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."taxes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\306.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."terms"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\307.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."unit_identifier_formats"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\308.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."user_names"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\309.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."user_navigation_groups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\310.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."balance_definition"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\311.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."calendar_periods"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\312.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."chart_of_accounts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\313.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."currencies"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\314.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."exchange_rates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\315.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."gl_cost_transactions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\316.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."journal_entries"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\317.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."journal_entry_lines"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\318.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ledger_accounts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\319.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ledger_balances"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\320.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ledger_balances_temporary"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\321.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ledger_definition"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\322.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ledger_organization_levels"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\323.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ledger_organizations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\324.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."posting_relationships"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\325.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sje_names"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\326.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."spread_rules"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\327.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ap_applications"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\328.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ap_check_selection_identifiers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\329.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ap_check_sort_temporary"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\330.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ap_document_classes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\331.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ap_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\332.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ap_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\333.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."buyers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\334.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."expense_analyses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\335.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."locations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\336.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_document_classes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\337.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\338.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."t1099_detail_temporary"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\339.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."t1099_summary_temporary"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\340.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."t1099_totals_temporary"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\341.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."units_payables_purchasing"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\342.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."vendor_activity_temporary"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\343.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."vendor_classes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\344.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."vendors"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\345.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."account_managers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\346.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_applications"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\347.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_customers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\348.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_customer_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\349.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_document_classes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\350.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\351.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\352.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."collection_agents"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\353.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."customer_classes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\354.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_preferences"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\355.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_price_groups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\356.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."remit_to_identifiers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\357.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sales_analyses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\358.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."standard_clauses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\359.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."units_receivables"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\360.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."commodities"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\361.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\362.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\363.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\364.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_receivers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\365.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_receiver_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\366.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."vendor_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\367.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."approver_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\368.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cost_accounts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\369.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cash_flow_lines"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\370.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cash_flow_sections"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\371.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."req_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\372.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."req_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\373.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."signature_list_accounts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\374.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."signature_lists"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\375.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."backflush_log"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\376.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."log"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\377.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."delfor_cytd"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\378.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."delfor_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\379.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."deljit_oh"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\380.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."deljit_cytd"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\381.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."order_validation"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\382.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."gm_pilot_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\383.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."delfor_oh"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\384.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."deljit_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\385.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sat_deljit_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\386.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sat_deljit_oh"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\387.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sat_deljit_kanban"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\388.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sat_delfor_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\389.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."deljit_kanban"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\390.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."xreport_datasource"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\391.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."xreport_library"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\392.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."Generic_830_fab_raw"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\393.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."generic_schedule"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\394.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_Generic830_release_date"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\395.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_Generic830_po"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\396.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."Generic_830_last_ship"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\397.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."Generic_830_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\398.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."Generic_830_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\399.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."generic_862_linefeed"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\400.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_generic_cums"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\401.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_generic830_auth_cum"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\402.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_in_release_plan_ch"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\403.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."freight_type_definition"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\404.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ap_recurring_invoices"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\405.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."doc_approvers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\406.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."budget_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\407.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_delinquent_customers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\408.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fd5_830_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\409.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fd5_830_fab_raw"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\410.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fd5_830_oh_data"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\411.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ford862_container"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\412.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fd5_862_cytd"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\413.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_ford830_consignee"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\414.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fd5_830_cytd"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\415.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ford862_descrepency"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\416.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ford862_linefeed"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\417.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ford862_ship_schedule"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\418.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_ford862_release_date"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\419.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_ford830_release_date"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\420.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_in_forcast_plan"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\421.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."order_detail_inserted"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\422.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."order_header_inserted"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\423.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."monitor_inventory_accounts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\424.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_release_date"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\425.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_chrysler830_po"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\426.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."chrysler_830_fab_raw"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\427.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."chrysler_830_last_ship"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\428.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."chrysler_830_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\429.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."chrysler_830_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\430.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."chrysler_862_linefeed"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\431.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."chrysler_862_schedule"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\432.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_ch1862_cums"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\433.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_ch1830_cums"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\434.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_chrysler830_auth_cum"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\435.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."deljit_releases_jci"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\436.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cdipohistory"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\437.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cdi_ppdcr"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\438.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cdi_vprating"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\439.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."mdata"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\440.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."tdata"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\441.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."vendor_service_status"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\442.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."admin"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\443.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."custom_pbl_link"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\444.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."defects"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\445.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."downtime"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\446.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\447.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."exp_apdata_detail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\448.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."exp_apdata_header"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\449.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."gt_comp_list"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\450.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."inventory_accuracy_history"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\451.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."master_prod_sched"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\452.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ole_objects"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\453.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."production_shift"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\454.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."shop_floor_calendar"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\455.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."shop_floor_time_log"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\456.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."temp_bom_stack"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\457.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."temp_bomec_stack"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\458.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_log"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\459.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."kanban"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\460.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."part_vendor_price_matrix"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\461.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."work_order"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\462.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."workorder_header_history"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\463.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_in_release_plan"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\464.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_in_release_plan_exceptions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\465.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_in_customer_po"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\466.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_in_customer_po_exceptions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\467.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_in_ship_schedule"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\468.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."m_in_ship_schedule_exceptions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\469.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."serial_asn"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\470.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_security"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\471.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_header"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\472.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_detail"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\473.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\474.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_account_project"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\475.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_project_number"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\476.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."account_code"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\477.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_group"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\478.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_group_account"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\479.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."requisition_group_project"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\480.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."filters"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\481.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."approver_substitutes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\482.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_attribute_definition"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\483.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_locations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\484.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_transactions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\485.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sales_terms"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\486.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."secured_columns"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\487.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."units_inventory"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\488.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."user_secured_columns"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\489.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_customer_ship_locations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\490.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."sales_agents"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\491.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."territories"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\492.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."computed_values"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\493.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_attribute_validations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\494.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_ledger_account_groups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\495.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cost_identifier_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\496.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."allocation_rules"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\497.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_bill_of_material"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\498.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_reorder_rules"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\499.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."req_bids"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\500.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."body_parts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\501.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."companies_wcb"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\502.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_calendar_dates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\503.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_calendars"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\504.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_call_history"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\505.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_cycle_pay_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\506.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_cycles"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\507.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_position_dates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\508.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_positions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\509.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_schedule_by_employee"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\510.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crew_shifts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\511.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."crews"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\512.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_injuries"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\513.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."injury_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\514.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pyhr_divisions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\515.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."t4a_definition_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\516.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_card_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\517.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_scoreboard_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\518.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."expense_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\519.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."expenses_header"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\520.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."expenses_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\521.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_recurring_invoices"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\522.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_customer_attributes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\523.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."vendor_attributes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\524.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."PrintQueue_Object"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\525.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."FT_CycleCountHeaders"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\526.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."FT_CycleCountBeginInventory"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\527.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."FT_CycleCountFoundInventory"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\528.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."SyntaxFromSQL"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\529.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."temp_scanned_to_be_del"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\530.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."CountriesWorld"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\531.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."States"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\532.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\533.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."po_blanket_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\534.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."user_secured_columns_temp"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\535.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."preferences_site_backup"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\536.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."absence_schedule_by_employee"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\537.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."absence_schedule_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\538.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."account_mapping"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\539.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."allocations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\540.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."api_gl_cost_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\541.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."api_gl_cost_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\542.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_applied_positions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\543.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_attributes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\544.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_certificates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\545.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_decisions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\546.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_degrees"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\547.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_interviews"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\548.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_references"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\549.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_scoreboard_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\550.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_sources"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\551.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicant_work_history"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\552.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applicants"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\553.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."applications"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\554.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."application_answers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\555.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."application_forms"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\556.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."application_questions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\557.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_customer_programs"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\558.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_lease_documents"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\559.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_lease_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\560.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_lease_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\561.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_leases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\562.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_program_event_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\563.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_program_events"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\564.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ar_programs"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\565.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."arrear_transactions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\566.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."awards"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\567.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."bank_register_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\568.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."benefit_adjustments"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\569.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."benefit_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\570.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."benefit_rates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\571.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."benefits"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\572.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."budget_api_gl_cost"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\573.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."budget_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\574.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."budget_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\575.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."calculation_adjustments"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\576.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cert_training_enrollments"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\577.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cert_training_schedules"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\578.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."certificates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\579.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."coa_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\580.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."coa_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\581.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cobra_responses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\582.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."companies_eir"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\583.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."company_state_filings"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\584.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cost_coa"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\585.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cost_id_security"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\586.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cost_identifier_attributes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\587.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cost_identifier_classes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\588.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."cost_identifiers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\589.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."datawindow_formats"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\590.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."dd_foreign_banks"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\591.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."deduction_adjustments"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\592.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."deduction_rate_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\593.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."deduction_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\594.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."degrees"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\595.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_file_imports"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\596.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_planning_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\597.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_planning_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\598.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_ship_schedule_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\599.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."edi_ship_schedule_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\600.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."eeoc_classes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\601.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."eeoc_races"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\602.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_absences"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\603.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_attributes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\604.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_awards"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\605.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_benefits"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\606.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_certificates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\607.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_deduction_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\608.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_degrees"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\609.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_dependents"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\610.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_equipment"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\611.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_pay_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\612.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_positions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\613.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_retirement_plans"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\614.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_review_scoreboard_not"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\615.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_reviews"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\616.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_tax_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\617.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_terminations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\618.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_time_card_defaults"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\619.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employee_ytd_balances"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\620.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employees"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\621.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."employment_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\622.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."entitlement_balances"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\623.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."entitlement_los"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\624.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."entitlement_proration_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\625.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."entitlement_transactions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\626.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."entitlements"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\627.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."equipment_codes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\628.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_asset_attributes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\629.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_asset_books"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\630.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_asset_depreciation_audit"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\631.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_asset_dispositions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\632.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_asset_groups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\633.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_asset_history"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\634.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_asset_uop"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\635.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_assets"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\636.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_classes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\637.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_classes_account_preferences"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\638.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_classes_book_preferences"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\639.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_cost_index_percents"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\640.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_cost_indexes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\641.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_depn_calc_id"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\642.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_depreciation_books"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\643.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_depreciation_rates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\644.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_groups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\645.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_locations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\646.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_phy_inv_results"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\647.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."fa_property_tax_jurisdictions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\648.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."installed_modules"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\649.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ipeds_academic_ranks"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\650.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ipeds_primary_functions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\651.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_attributes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\652.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_containers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\653.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_container_packages"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\654.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_production"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\655.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_serial"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\656.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."iv_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\657.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."iv_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\658.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."journal_entry_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\659.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."journal_entry_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\660.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."label_objects"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\661.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."lease_buildings"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\662.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."lease_calendar_dates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\663.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."lease_document_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\664.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."lease_sites"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\665.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."lease_spaces"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\666.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ledger_period_applications"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\667.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."ledger_periods"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\668.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."nav_opt_changes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\669.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."nav_tab_opt_changes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\670.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pay_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\671.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_adjustments"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\672.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_cycles"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\673.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_documents"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\674.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_document_mapping"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\675.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_rate_dates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\676.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_rate_ids"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\677.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_rate_rates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\678.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_voucher_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\679.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."payroll_vouchers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\680.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pos_register_cashiers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\681.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pos_registers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\682.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pos_security_ids"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\683.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."position_budgets"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\684.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."position_categories"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\685.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."position_certificates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\686.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."position_families"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\687.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."position_requisitions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\688.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."positions"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\689.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."province_identifiers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\690.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."py_check_sort_temporary"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\691.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."pyhr_locations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\692.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."retirement_adjustments"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\693.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."retirement_plan_group_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\694.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."retirement_plans"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\695.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."retirement_plan_groups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\696.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."review_reasons"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\697.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."rl1_definition_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\698.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."salary_grades"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\699.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."selection_form_values"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\700.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."state_identifiers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\701.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_blanket_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\702.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_blanket_freight_expenses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\703.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_blanket_other_expenses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\704.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_consolidators"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\705.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_freight_expenses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\706.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_headers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\707.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\708.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\709.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_order_processors"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\710.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_other_expenses"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\711.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_ports"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\712.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_releases"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\713.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_scoreboard_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\714.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_shippers"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\715.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_shipper_discounts"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\716.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_shipper_freight_charges"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\717.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_shipper_items"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\718.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."so_shipper_other_charges"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\719.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."t4_definition_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\720.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."t4a_footnote_codes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\721.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."tax_adjustments"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\722.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."tax_rate_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\723.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."tax_rates_local"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\724.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."tax_types"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\725.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."termination_reasons"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\726.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_card_calendar_dates"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\727.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_card_calendar_schedule"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\728.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_card_calendars"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\729.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_card_groups"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\730.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_card_header_notes"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\731.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_cards"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\732.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."time_cards_defaulted"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\733.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."training_locations"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\734.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."units_fixed_assets"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\735.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."units_payroll_hr"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\736.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."w2_definition_basis"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\737.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."work_orders"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\738.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--LOAD TABLE dbo."item_physical_inventory_result"
--	FROM 'C:\\SYBTOOLS\\WIN32\\UNLOAD\\739.dat'
--	FORMAT 'ASCII'
--	QUOTES ON ESCAPES ON STRIP OFF
--	DELIMITED BY ','
--go
--commit work
--go


