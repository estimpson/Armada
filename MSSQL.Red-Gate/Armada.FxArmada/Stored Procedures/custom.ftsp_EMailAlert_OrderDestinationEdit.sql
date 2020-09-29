SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [custom].[ftsp_EMailAlert_OrderDestinationEdit] 


(		 @OrderNo INT
		,@PriorDestination VARCHAR(25)
		,@CurrentDestination VARCHAR(25)
		,@TranDT DATETIME OUT
		,@Result INTEGER OUT

)
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET	@Result = 999999
SET	ANSI_WARNINGS ON

--- <Error Handling>
DECLARE
	@CallProcName sysname,
	@TableName sysname  = N'#OrderDestinationEdit',
	@ProcName sysname,
	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error INTEGER,
	@RowCount INTEGER

SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. <schema_name, sysname, dbo>.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
DECLARE
	@TranCount SMALLINT

SET	@TranCount = @@TranCount
IF	@TranCount = 0 BEGIN
	BEGIN TRAN @ProcName
END
ELSE BEGIN
	SAVE TRAN @ProcName
END
SET	@TranDT = COALESCE(@TranDT, GETDATE())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>

-- Get ShipperDetail and Current Inventory for Short Shipment
	

	DECLARE		@EmailAddress VARCHAR(MAX) 
	
	SELECT @EmailAddress = 'czurawski@armadarubber.com;patti@armadarubber.com'
						
	SELECT 
		 OrderNumber = @OrderNo,
		 PriorDestination = @PriorDestination,
		 CurrentDestination = @CurrentDestination,
		 UserID = SUSER_NAME()
INTO
		#OrderDestinationEdit
FROM 
		order_header oh
WHERE
		oh.order_no = @OrderNo
		
	
		-- Create HTML and E-Mail
IF EXISTS ( SELECT 1 FROM #OrderDestinationEdit )	



BEGIN	
		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#OrderDestinationEdit'


			EXEC [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Order Destination Change(Sent Based on Update Trigger on order_header) ' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail 
           	@profile_name = 'FxArmadaMail1'-- sysname
	,		@recipients = @EmailAddress -- varchar(max)
--	,		@recipients = 'aboulanger@fore-thought.com' -- varchar(max)
	,		@copy_recipients = 'aboulanger@fore-thought.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'High'  -- varchar(6)	




		
		
END					

--- </Body>

---	<Return>
SET	@Result = 0
RETURN
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go


begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
		@ProcReturn = ft.ftsp_EMailAlert_ShipperQtyRequiredEdit 
		@shipper  = 74751
	,	@order_number = 19922
	,	@part_original  = 'PET0051-HD08'
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	commit
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/















GO
