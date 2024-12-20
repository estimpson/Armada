CREATE TABLE [dbo].[fa_assets]
(
[asset_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[unit] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[asset_description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[manufacturer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[model] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[serial] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[asset_bitmap] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[personal_real] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[own_lease] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vendor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[purchase_document] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[count_cycle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[personal_use_pct] [decimal] (4, 2) NULL,
[personal_use_name] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[replacement_cost_index] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[insurance_carrier] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[asset_location] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[property_tax_jurisdiction] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[itc_years] [decimal] (5, 2) NULL,
[itc_percent] [decimal] (5, 2) NULL,
[itc_amount] [decimal] (18, 6) NULL,
[itc_basis_reduction] [decimal] (18, 6) NULL,
[itr_percent] [decimal] (5, 2) NULL,
[itr_amount] [decimal] (18, 6) NULL,
[itr_basis_increase] [decimal] (18, 6) NULL,
[mintax_life] [decimal] (5, 2) NULL,
[mintax_method] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ace_life] [decimal] (5, 2) NULL,
[status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acquisition_date] [datetime] NULL,
[location_date] [datetime] NULL,
[itr_date] [datetime] NULL,
[disposition_date] [datetime] NULL,
[disposition_proceeds_amount] [decimal] (18, 6) NULL,
[replacement_cost_year] [int] NULL,
[replacement_cost_amount] [decimal] (18, 6) NULL,
[asset_short_description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[physical_inventory_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[asset_class] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acquisition_asset] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acquisition_liability] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[depreciation_accumulated] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[depreciation_expense] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[disposition_gain_loss] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[disposition_proceeds] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gl_date] [datetime] NULL,
[last_date_counted] [datetime] NULL,
[last_employee_counted] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acq_asset_cost_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acq_liability_cost_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[active_inactive] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[asset_image_file_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[import_batch] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[fa_assets] ADD CONSTRAINT [pk_fa_assets] PRIMARY KEY CLUSTERED  ([asset_id]) ON [PRIMARY]
GO
