SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FXPL].[usp_Q_PacklineParts]
	@TranDT datetime = null out
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
						[@TranDT] = @TranDT
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
		/*	Return parts. */
		set @TocMsg = 'Return parts'
		begin
			select
				result =
					coalesce
					(	(	select
								PartCode = p.part
							,	PartDescription = p.name + coalesce(' [' + p.cross_ref + ']', '') + coalesce(' - ' + p.description_long, '')
							,	UnitWeight = pInv.unit_weight
							,	WeightTolerance = 0.03
							,	DefaultPackaging = defaultPack.code
							,	RequiresFinalInspection = 1
							,	DeflashMethod = 'MACHINE'
							,	PackagingList = 
								(	select
										PackageCode	= pm.code
									,	PackageDescription = pm.name
									,	StandardPack = pp.quantity
									,	SpecialInstructions = pp.SpecialInstructions
									from
										dbo.part_packaging pp
										join dbo.package_materials pm
											on pm.code = pp.code
									where
										p.part = pp.part
									for xml raw('Packaging'), type
								)
							from
								dbo.part p
								join dbo.part_inventory pInv
									on pInv.part = p.part
								cross apply
									(	select	top (1)
												pp.quantity
										,		pm.code
										from
											dbo.part_packaging pp
											join dbo.package_materials pm
												on pm.code = pp.code
										where
											pp.part = p.part
										order by
											case
												when pm.type = 'B' then
													1
												else
													2
											end
										,	pp.quantity desc
									) defaultPack
								left join dbo.part_characteristics pc
									on pc.part = p.part
								outer apply
									(	select	top (1)
												*
										from
											dbo.part_machine pm2
										where
											pm2.part = p.part
										order by
											pm2.sequence
									) pmach
								outer	apply
									(	select	top (1)
												ar.code
										,		ar.notes
										from
											dbo.activity_router ar
										where
											ar.parent_part = p.part
										order by
											ar.sequence
									) ar
								outer apply
									(	select	top (1)
												childActivity = ar2.code
										,		childPart = ar2.part
										,		childGT = ar2.group_location
										,		childLevel = xr.BOMLevel
										from
											FT.XRt xr
											join dbo.activity_router ar2
												on ar2.part = xr.ChildPart
										where
											xr.TopPart = p.part
									) childar
							where
								p.class = 'M'
								and p.type = 'F'
							for xml raw('Part'), type
						)
					,	convert(xml, '')
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
							[@TranDT] = @TranDT
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

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FXPL.usp_Q_PacklineParts
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
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
