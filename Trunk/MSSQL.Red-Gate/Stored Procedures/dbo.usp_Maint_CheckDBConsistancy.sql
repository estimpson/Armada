SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[usp_Maint_CheckDBConsistancy]
as
execute
	master..sp_foreachdb 
	@command = 'dbcc checkdb(?) with no_infomsgs, all_errormsgs, data_purity'
GO
