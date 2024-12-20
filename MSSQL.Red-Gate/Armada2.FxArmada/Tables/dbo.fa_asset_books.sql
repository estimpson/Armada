CREATE TABLE [dbo].[fa_asset_books]
(
[asset_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[depreciation_book] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[asset_life] [decimal] (12, 5) NULL,
[in_service_date] [datetime] NULL,
[depreciation_date] [datetime] NULL,
[depreciation_method] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_cost] [decimal] (18, 6) NULL,
[salvage_value] [decimal] (18, 6) NULL,
[amount_expensed] [decimal] (18, 6) NULL,
[depreciable_basis] [decimal] (18, 6) NULL,
[fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fiscal_period] [int] NULL,
[current_period_depreciation] [decimal] (18, 6) NULL,
[ytd_depreciation] [decimal] (18, 6) NULL,
[ltd_depreciation] [decimal] (18, 6) NULL,
[net_value] [decimal] (18, 6) NULL,
[prior_year_depreciation] [decimal] (18, 6) NULL,
[life_unit_of_measure] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[units_ltd] [decimal] (18, 6) NULL,
[new_used] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[processing_mode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currency] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[historical_exchange_rate] [decimal] (18, 6) NULL,
[depreciation_basis_adj] [decimal] (18, 6) NULL,
[ltd_depreciation_adj] [decimal] (18, 6) NULL,
[gain_loss] [decimal] (18, 6) NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rsl_cost] [decimal] (18, 6) NULL,
[rsl_life] [decimal] (12, 5) NULL,
[rsl_life_unit_of_measure] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rsl_fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rsl_fiscal_period] [smallint] NULL,
[bonus_depreciation] [decimal] (18, 6) NULL,
[import_batch] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[fa_asset_books] ADD CONSTRAINT [pk_fa_asset_books] PRIMARY KEY CLUSTERED  ([asset_id], [depreciation_book]) ON [PRIMARY]
GO
