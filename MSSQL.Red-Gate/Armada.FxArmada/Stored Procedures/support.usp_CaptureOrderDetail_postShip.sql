SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [support].[usp_CaptureOrderDetail_postShip]
	@ShipperId int
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
						[@ShipperID] = @ShipperId
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

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. support.usp_Test
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
		/*	Write order detail to a pre-ship audit table. */
		set @TocMsg = 'Write order detail to a pre-ship audit table'
		begin
			insert
				support.order_detail_Audit
			(	ShipperID
			,	PreFlag
			,	id
			,	order_no
			,	sequence
			,	part_number
			,	type
			,	product_name
			,	quantity
			,	price
			,	notes
			,	assigned
			,	shipped
			,	invoiced
			,	status
			,	our_cum
			,	the_cum
			,	due_date
			,	destination
			,	unit
			,	committed_qty
			,	row_id
			,	group_no
			,	cost
			,	plant
			,	release_no
			,	flag
			,	week_no
			,	std_qty
			,	customer_part
			,	ship_type
			,	dropship_po
			,	dropship_po_row_id
			,	suffix
			,	packline_qty
			,	packaging_type
			,	weight
			,	custom01
			,	custom02
			,	custom03
			,	dimension_qty_string
			,	engineering_level
			,	box_label
			,	pallet_label
			,	alternate_price
			,	promise_date
			,	RowCreateDT
			,	RowCreateUser
			,	RowModifiedDT
			,	RowModifiedUser
			)
			select
				@ShipperId
			,	PreFlag = 0
			,	od.id
			,	od.order_no
			,	od.sequence
			,	od.part_number
			,	od.type
			,	od.product_name
			,	od.quantity
			,	od.price
			,	od.notes
			,	od.assigned
			,	od.shipped
			,	od.invoiced
			,	od.status
			,	od.our_cum
			,	od.the_cum
			,	od.due_date
			,	od.destination
			,	od.unit
			,	od.committed_qty
			,	od.row_id
			,	od.group_no
			,	od.cost
			,	od.plant
			,	od.release_no
			,	od.flag
			,	od.week_no
			,	od.std_qty
			,	od.customer_part
			,	od.ship_type
			,	od.dropship_po
			,	od.dropship_po_row_id
			,	od.suffix
			,	od.packline_qty
			,	od.packaging_type
			,	od.weight
			,	od.custom01
			,	od.custom02
			,	od.custom03
			,	od.dimension_qty_string
			,	od.engineering_level
			,	od.box_label
			,	od.pallet_label
			,	od.alternate_price
			,	od.promise_date
			,	od.RowCreateDT
			,	od.RowCreateUser
			,	od.RowModifiedDT
			,	od.RowModifiedUser
			from
				dbo.order_detail od
			where
				exists
					(	select
							*
						from
							dbo.shipper_detail sd
						where
							sd.shipper = @ShipperId
							and sd.order_no = od.order_no
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
select
	*
from
	dbo.shipper s
where
	s.status = 'S'
}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@ShipperId int = 386263

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = support.usp_CaptureOrderDetail_postShip
	@ShipperId = @ShipperId
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

select
	*
from
	support.order_detail_postShipAudit odpsa

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
