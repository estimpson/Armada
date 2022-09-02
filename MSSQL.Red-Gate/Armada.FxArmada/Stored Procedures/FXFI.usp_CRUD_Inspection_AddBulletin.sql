SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FXFI].[usp_CRUD_Inspection_AddBulletin]
	@User varchar(5)
,	@PartCode varchar(25)
,	@Base64Image varchar(max)
,	@PictureFileName varchar(255)
,	@Note varchar(max)
,	@PictureFileGUID uniqueidentifier = null out
,	@BulletinID int = null out
,	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug int = 0
,	@DebugMsg varchar(max) = null out
as
begin

	--set xact_abort on
	set nocount on

	--- <TIC>
	declare
		@cDebug int = @Debug + 2 -- Proc level

	if	@Debug & 0x01 = 0x01 begin
		declare
			@TicDT datetime = getdate()
		,	@TocDT datetime
		,	@TimeDiff varchar(max)
		,	@TocMsg varchar(max)
		,	@cDebugMsg varchar(max)

		set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	end
	--- </TIC>

	--- <SP Begin Logging>
	declare
		@LogID int

	insert
		FXSYS.USP_Calls
	(	USP_Name
	,	BeginDT
	,	InArguments
	)
	select
		USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments = convert
			(	varchar(max)
			,	(	select
						[@User] = @User
					,	[@PartCode] = @PartCode
					,	[@Base64Data] = left(@Base64Image, 255)
					,	[@PictureFileName] = @PictureFileName
					,	[@Note] = @Note
					,	[@TranDT] = @TranDT
					,	[@Result] = @Result
					,	[@Debug] = @Debug
					,	[@DebugMsg] = @DebugMsg
					for xml raw			
				)
			)

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

	set	@Result = 999999

	--- <Error Handling>
	declare
		@CallProcName sysname
	,	@TableName sysname
	,	@ProcName sysname
	,	@ProcReturn integer
	,	@ProcResult integer
	,	@Error integer
	,	@RowCount integer

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FXPL.usp_Test
	--- </Error Handling>

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try

		---	<ArgumentValidation>

		---	</ArgumentValidation>

		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
		if	@TranCount = 0 begin
			begin tran @ProcName
		end
		else begin
			save tran @ProcName
		end
		set	@TranDT = coalesce(@TranDT, GetDate())
		--- </Tran>

		--- <Body>
		
		/*	Insert bulletin. */
		set @TocMsg = 'Insert bulletin'
		begin
			if	@Base64Image is not null begin
				--- <Insert rows="1">
				declare
					@newPictureGuid table
				(	pictureFileGuid uniqueidentifier
				)
			
				set	@TableName = 'FXFI.InspectionPictures'
			
				insert
					FXFI.InspectionPictures
				(	Base64Image
				)
				output
				(	inserted.PictureFileGuid
				)
				into
					@newPictureGuid
				values
				(	@Base64Image
				)
			
				select
					@Error = @@Error,
					@RowCount = @@Rowcount
			
				if	@Error != 0 begin
					set	@Result = 999999
					RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
					rollback tran @ProcName
					return
				end
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
					rollback tran @ProcName
					return
				end

				set @PictureFileGUID =
					(	select top(1)
							npg.pictureFileGuid
						from
							@newPictureGuid npg
						order by
							1
					)
				--- </Insert>
			end

			--- <Insert rows="1">
			declare
				@newBulletin table
			(	rowId int not null
			)
			set	@TableName = 'FXFI.InspectionBulletins'
			
			insert
				FXFI.InspectionBulletins
			(	PartCode
			,	PictureFileGUID
			,	PictureFileName
			,	Note
			,	CreatedByOperator
			)
			output
			(	inserted.RowID
			)
			into
				@newBulletin
			select
				PartCode = @PartCode
			,	PictureFileGUID = @PictureFileGUID
			,	PictureFileName = @PictureFileName
			,	Note = @Note
			,	CreatedByOperator = @User
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Insert>
			set	@BulletinID =
					(	select
							max(nn.rowId)
						from
							@newBulletin nn
					)
				
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Return inspection job. */
		set @TocMsg = 'Return inspection job'
		begin
			select
				result = convert(xml, '<Success />')
					
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end
		--- </Body>

		---	<CloseTran AutoCommit=Yes>
		if	@TranCount = 0 begin
			commit tran @ProcName
		end
		---	</CloseTran AutoCommit=Yes>

		--- <SP End Logging>
		update
			uc
		set	EndDT = getdate()
		,	OutArguments = convert
				(	varchar(max)
				,	(	select
							[@PictureFileGUID] = @PictureFileGUID
						,	[BulletinID] = @BulletinID
						,	[@TranDT] = @TranDT
						,	[@Result] = @Result
						,	[@DebugMsg] = @DebugMsg
						for xml raw			
					)
				)
		from
			FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>

		--- <TIC/TOC END>
		if	@Debug & 0x3F = 0x01 begin
			set @DebugMsg = @DebugMsg + char(13) + char(10)
			print @DebugMsg
		end
		--- </TIC/TOC END>

		---	<Return>
		set	@Result = 0
		return
			@Result
		--- </Return>
	end try
	begin catch
		declare
			@errorSeverity int
		,	@errorState int
		,	@errorMessage nvarchar(2048)
		,	@xact_state int
	
		select
			@errorSeverity = error_severity()
		,	@errorState = error_state ()
		,	@errorMessage = error_message()
		,	@xact_state = xact_state()

		execute FXSYS.usp_PrintError

		if	@xact_state = -1 begin 
			rollback
			execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount = 0 begin
			rollback
			execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount > 0 begin
			rollback transaction @ProcName
			execute FXSYS.usp_LogError
		end

		raiserror(@errorMessage, @errorSeverity, @errorState)
	end catch
end

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

declare
	@User varchar(5) = 'EES'
,	@InspectionJobNumber varchar(50) = 'PJ_000000060'
,	@Base64Image varchar(max) = ';'
,	@PictureFileName varchar(255) = 'X:\Fx\Pictures\10515.1\PJ_000000060_0.jpg'
,	@Note varchar(max) = 'TEST'
,	@PictureFileGUID uniqueidentifier
,	@PictureID int

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FXFI.usp_CRUD_Inspection_AddBulletin
	@User = @User
,	@InspectionJobNumber = @InspectionJobNumber
,	@Base64Image = @Base64Image
,	@PictureFileName = @PictureFileName
,	@Note = @Note
,	@PictureFileGUID = @PictureFileGUID out
,	@PictureID = @PictureID out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@InspectionJobNumber, @PictureFileGUID, @PictureID, @Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	FXFI.InspectionJobHeaderPictures ijhn
where
	ijhn.InspectionJobNumber = @InspectionJobNumber
go

if	@@trancount > 0 begin
	rollback
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
