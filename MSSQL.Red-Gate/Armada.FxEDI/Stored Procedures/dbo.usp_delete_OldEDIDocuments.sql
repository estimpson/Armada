SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_delete_OldEDIDocuments] 

AS 
begin
DELETE FROM dbo.RawEDIData WHERE is_directory = 0 AND last_access_time < GETDATE() - 60
delete FROM EDI.RawEDIDocuments WHERE RowCreateDT < GETDATE() - 60
end
GO
