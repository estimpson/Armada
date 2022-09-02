SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[usp_Maint_UpdateStats]
as
execute
	master..sp_foreachdb
	@command = 'use ?;exec sp_updatestats'
GO
