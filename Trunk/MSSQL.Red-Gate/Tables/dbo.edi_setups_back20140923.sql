CREATE TABLE [dbo].[edi_setups_back20140923]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[supplier_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[trading_partner_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[release_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[auto_create_asn] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[asn_overlay_group] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equipment_description] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pool_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[pool_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material_issuer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_code_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_model_year] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_po] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_cum_in_asn] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIShipToID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessEDI] [bit] NULL,
[TransitDays] [int] NULL,
[EDIOffsetDays] [int] NULL,
[PlanningReleasesFlag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceAccum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdjustmentAccum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckCustomerPOFirm] [bit] NULL,
[PlanningReleaseHorizonDaysBack] [int] NULL,
[ShipScheduleHorizonDaysBack] [int] NULL,
[ProcessShipSchedule] [bit] NULL,
[ProcessPlanningRelease] [bit] NULL
) ON [PRIMARY]
GO