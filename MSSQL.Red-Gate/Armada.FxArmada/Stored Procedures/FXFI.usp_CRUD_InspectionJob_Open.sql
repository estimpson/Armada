SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FXFI].[usp_CRUD_InspectionJob_Open]
	@User varchar(5)
,	@PackingJobNumber varchar(50)
,	@InspectionJobNumber varchar(50) = null out
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

		set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + schema_name(objectproperty(@@procid, 'SchemaId')) + '.' + object_name(@@procid)
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
		USP_Name = schema_name(objectproperty(@@procid, 'SchemaId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments = convert
			(	varchar(max)
			,	(	select
						[@User] = @User
					,	[@PackingJobNumber] = @PackingJobNumber
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

	set	@ProcName = schema_name(objectproperty(@@procid, 'SchemaId')) + '.' + object_name(@@procid)  -- e.g. FXPL.usp_Test
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
		/*	Create Inspection Job Header. */
		set @TocMsg = 'Create Inspection Job Header'
		if	not exists
			(	select
					*
				from
					FXFI.InspectionJobHeaders ijh
				where
					ijh.PackingJobNumber = @PackingJobNumber
					and ijh.Status >= 0
			)
		begin
			--- <Insert rows="1">
			declare
				@Inserted table
			(	RowID int
			)

			set	@TableName = 'FXPL.PackingJobHeaders'
			
			insert
				FXFI.InspectionJobHeaders
			(	InspectionJobNumber
			,	PackingJobNumber
			,	InspectionStatus
			,	InspectionOperator
			)
			output
				Inserted.RowID
			into
				@Inserted
			select
				InspectionJobNumber = @PackingJobNumber
			,	PackingJobNumber = @PackingJobNumber
			,	InspectionStatus = 'NEW'
			,	InspectionOperator = @User
			
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

			set	@InspectionJobNumber =
				(	select top(1)
						ijh.InspectionJobNumber
					from
						@Inserted i
						join FXFI.InspectionJobHeaders ijh on
							ijh.RowID = i.RowID
					order by
						i.RowID
				)
			--- </Insert>

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
		else begin
			set @InspectionJobNumber =
				(	select top(1)
						ijh.InspectionJobNumber
					from
						FXFI.InspectionJobHeaders ijh
					where
						ijh.PackingJobNumber = @PackingJobNumber
						and ijh.Status >= 0
					order by
						ijh.RowID desc
				)
		end

		/*	Create inspection job objects. */
		set @TocMsg = 'Create inspection job objects'
		begin
			--- <Insert rows="*">
			set	@TableName = 'FXFI.InspectionJobObjects'
			
			insert
				FXFI.InspectionJobObjects
			(	InspectionJobNumber
			,	Serial
			,	InspectionStatus
			)
			select
				InspectionJobNumber = @InspectionJobNumber
			,	Serial = pjo.Serial
			,	InspectionStatus = ''
			from
				FXPL.PackingJobObjects pjo
			where
				pjo.PackingJobNumber = @PackingJobNumber
				and pjo.Status >= 0
				and not exists
					(	select
							*
						from
							FXFI.InspectionJobObjects ijo
						where
							ijo.InspectionJobNumber = @InspectionJobNumber
							and ijo.Serial = pjo.Serial
							and ijo.Status >= 0
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
			--- </Insert>
			
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


		/*	Set the inspection job status. */
		set @TocMsg = 'Set the inspection job status'
		begin
			--- <Update rows="1">
			set	@TableName = 'FXFI.InspectionJobHeaders'
			
			update
				ijh
			set
				ijh.InspectionStatus =
					case
						when not exists
							(	select
									*
								from
									FXFI.InspectionJobObjects ijo
								where
									ijo.InspectionJobNumber = @InspectionJobNumber
									and ijo.Status >= 0
									and ijo.InspectionStatus = 'NEW'
							) then 'SCANNING COMPLETE'
						else 'SCANNNG BEGUN'
					end
			,	ijh.Status = 0
			from
				FXFI.InspectionJobHeaders ijh
			where
				ijh.InspectionJobNumber = @InspectionJobNumber
				and ijh.Status >= 0
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Update>
				
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
				result = coalesce
					(	FXFI.udf_Q_InspectionJob(@InspectionJobNumber)
					,	convert(xml, '<InspectionJob />')
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
							[@InspectionJobNumber] = @InspectionJobNumber
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
,	@PackingJobNumber varchar(50) = 'PJ_000000060'
,	@InspectionJobNumber varchar(50) = null

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FXFI.usp_CRUD_InspectionJob_Open
	@User = @User
,	@PackingJobNumber = @PackingJobNumber
,	@InspectionJobNumber = @InspectionJobNumber out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@InspectionJobNumber, @Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	FXFI.InspectionJobHeaders ijh
where
	ijh.PackingJobNumber = @PackingJobNumber

select
	*
from
	FXFI.InspectionJobObjects ijo
where
	ijo.InspectionJobNumber = @InspectionJobNumber

select
	*
from
	FXPL.PackingJobHeaders pjh
where
	pjh.PackingJobNumber = @PackingJobNumber

select
	*
from
	FXPL.PackingJobObjects pjo
where
	pjo.PackingJobNumber = @PackingJobNumber
go

--commit
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
