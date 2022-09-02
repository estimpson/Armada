SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_UpdateShipperOrders]
	@Shipper int
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
						[@Shipper] = @Shipper
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

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
		/*	Take order pre-snapshot. */
		set @TocMsg = 'Take order pre-snapshot'
		begin
			
			insert
				dbo.OrderDetailShipHistory
			(	ShipperID
			,	OrderNo
			,	OH_OrderAccum
			,	SnapShotType
			,	OD_OrderID
			,	OD_Sequence
			,	OD_RowID
			,	OD_PartNumber
			,	OD_Quantity
			,	OD_StdQuantity
			,	OD_DueDate
			,	OD_ForecastType
			,	OD_Unit
			,	OD_PriorAccum
			,	OD_PostAccum
			,	OD_ReleaseNo
			,	OD_RowCreateDT
			,	OD_RowCreateUser
			,	OD_RowModifiedDT
			,	OD_RowModifiedUser
			,	OD_XML
			,	RowCreateDT
			,	RowCreateUser
			,	RowModifiedDT
			,	RowModifiedUser
			)
			select
				ShipperID = s.id
			,	OrderNo = sd.order_no
			,	OH_OrderAccum = oh.our_cum
			,	SnapShotType = '0'
			,	OD_OrderID = od.id
			,	OD_Sequence = od.sequence
			,	OD_RowID = od.row_id
			,	OD_PartNumber = od.part_number
			,	OD_Quantity = od.quantity
			,	OD_StdQuantity = od.std_qty
			,	OD_DueDate = od.due_date
			,	OD_ForecastType = od.type
			,	OD_Unit = od.unit
			,	OD_PriorAccum = od.our_cum
			,	OD_PostAccum = od.the_cum
			,	OD_ReleaseNo = od.release_no
			,	OD_RowCreateDT = od.RowCreateDT
			,	OD_RowCreateUser = od.RowCreateUser
			,	OD_RowModifiedDT = od.RowModifiedDT
			,	OD_RowModifiedUser = od.RowModifiedUser
			,	OD_XML =
				(	select
						*
					from
						dbo.order_detail od2
					where
						od2.id = od.id
					for xml raw
				)
			,	RowCreateDT
			,	RowCreateUser
			,	RowModifiedDT
			,	RowModifiedUser
			from
				dbo.shipper s
				join dbo.shipper_detail sd
					on sd.shipper = s.id
				join dbo.order_header oh
					on oh.order_no = sd.order_no
				join dbo.order_detail od
					on od.order_no = sd.order_no
			where
				s.id = @Shipper

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

		/*	Adjust accums. */
		set @TocMsg = 'Adjust accums'
		begin
			
			--- <Update rows="*">
			set	@TableName = 'shipper_detail'
			
			update
				sd
			set
				sd.accum_shipped = coalesce
					(	(	select
								sd.alternative_qty + max(oh.our_cum)
							from
								dbo.order_header oh
							where
								oh.order_no = sd.order_no
								and oh.order_type = 'B'
						)
					,	sd.accum_shipped
					)
			from
				dbo.shipper_detail sd
			where
				sd.shipper = @Shipper
				and exists
					(	select
							*
						from
							dbo.order_header oh
						where
							oh.order_no = sd.order_no
							and oh.order_type = 'B'
					)
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			--- </Update>
			
			--- <Update rows="*">
			set	@TableName = 'dbo.order_header'
			
			update
				oh
			set
				oh.our_cum = coalesce
					(	(	select
								oh.our_cum + max(sd.alternative_qty)
							from
								dbo.shipper_detail sd
							where
								sd.order_no = oh.order_no
								and sd.shipper = @Shipper
						)
					,	0
					)
			from
				dbo.order_header oh
			where
				exists
					(	select
							*
						from
							dbo.shipper_detail sd
						where
							sd.order_no = oh.order_no
							and sd.shipper = @Shipper
					)
				and oh.order_type = 'B'
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
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

		/*	Adjust blanket order releases. */
		set @TocMsg = 'Adjust blanket order releases'
		begin
			--- <Delete rows="*">
			set	@TableName = 'dbo.order_detail'
			
			delete
				od
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
					and oh.order_type = 'B'
			where
				exists
					(	select
							*
						from
							dbo.shipper_detail sd
						where
							sd.shipper = @Shipper
							and sd.order_no = oh.order_no
					)
				and od.the_cum <= oh.our_cum
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			--- </Delete>

			update
				od
			set	od.our_cum = oh.our_cum
			,	od.quantity = od.the_cum - oh.our_cum
			,	od.std_qty = dbo.udf_GetStdQtyFromQty(od.part_number, od.the_cum - oh.our_cum, oh.unit)
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
					and oh.order_type = 'B'
			where
				exists
					(	select
							*
						from
							dbo.shipper_detail sd
						where
							sd.shipper = @Shipper
							and sd.order_no = oh.order_no
					)
				and od.sequence =
					(	select
							min(od2.sequence)
						from
							dbo.order_detail od2
						where
							od2.order_no = od.order_no
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
		
		/*	Adjust normal order releases. */
		set @TocMsg = 'Adjust normal order releases'
		if	exists
			(	select
					*
				from
					dbo.shipper_detail sd
				where
					sd.shipper = @Shipper
					and exists
						(	select
								*
							from
								dbo.order_header oh
							where
								oh.order_no = sd.order_no
								and oh.order_type = 'N'
						)
			)
		begin
			declare
				@releases table
			(	OrderNo int
			,	PartNumber varchar(25)
			,	Suffix int
			,	RowID int
			,	PriorAccum numeric(20,6)
			,	PostAccum numeric(20,6)
			,	QtyShipped numeric(20,6)
			)

			insert
				@releases
			(	OrderNo
			,	PartNumber
			,	Suffix
			,	RowID
			,	PriorAccum
			,	PostAccum
			,	QtyShipped
			)
			select
				OrderNo = od.order_no
			,	PartNumber = od.part_number
			,	Suffix = od.suffix
			,	RowID = od.id
			,	PriorAccum = -od.quantity + sum(od.quantity) over (partition by od.order_no, od.part_number, od.suffix order by od.sequence, od.id)
			,	PostAccum = sum(od.quantity) over (partition by od.order_no, od.part_number, od.suffix order by od.sequence, od.id)
			,	QtyShipped = sd.qty_packed
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
					and oh.order_type ='N'
				join  dbo.shipper_detail sd
					on sd.shipper = @Shipper
					and sd.part_original = od.part_number
					and coalesce(sd.suffix, -1) = coalesce(od.suffix, -1)
			order by
				od.order_no, od.part_number, od.sequence, od.id

			--- <Delete rows="*">
			set	@TableName = 'dbo.order_detail'
			
			delete
				od
			from
				dbo.order_detail od
				join @releases r on
					r.RowID = od.id
					and r.OrderNo = r.OrderNo
			where
				r.PostAccum <= r.QtyShipped
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			--- </Delete>

			--- <Update rows="*">
			set	@TableName = 'order_detail'
			
			update
				od
			set	od.quantity = r.PostAccum - r.QtyShipped
			,	od.std_qty = dbo.udf_GetStdQtyFromQty(od.part_number, r.PostAccum - r.QtyShipped, oh.unit)
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join @releases r on
					r.RowID = od.id
					and r.OrderNo = r.OrderNo
			where
				r.PostAccum > r.QtyShipped
				and r.PriorAccum < r.QtyShipped
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
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

		/*	Take order pre-snapshot. */
		set @TocMsg = 'Take order post-snapshot'
		begin
			
			insert
				dbo.OrderDetailShipHistory
			(	ShipperID
			,	OrderNo
			,	OH_OrderAccum
			,	SnapShotType
			,	OD_OrderID
			,	OD_Sequence
			,	OD_RowID
			,	OD_PartNumber
			,	OD_Quantity
			,	OD_StdQuantity
			,	OD_DueDate
			,	OD_ForecastType
			,	OD_Unit
			,	OD_PriorAccum
			,	OD_PostAccum
			,	OD_ReleaseNo
			,	OD_RowCreateDT
			,	OD_RowCreateUser
			,	OD_RowModifiedDT
			,	OD_RowModifiedUser
			,	OD_XML
			,	RowCreateDT
			,	RowCreateUser
			,	RowModifiedDT
			,	RowModifiedUser
			)
			select
				ShipperID = s.id
			,	OrderNo = sd.order_no
			,	OH_OrderAccum = oh.our_cum
			,	SnapShotType = '1'
			,	OD_OrderID = od.id
			,	OD_Sequence = od.sequence
			,	OD_RowID = od.row_id
			,	OD_PartNumber = od.part_number
			,	OD_Quantity = od.quantity
			,	OD_StdQuantity = od.std_qty
			,	OD_DueDate = od.due_date
			,	OD_ForecastType = od.type
			,	OD_Unit = od.unit
			,	OD_PriorAccum = od.our_cum
			,	OD_PostAccum = od.the_cum
			,	OD_ReleaseNo = od.release_no
			,	OD_RowCreateDT = od.RowCreateDT
			,	OD_RowCreateUser = od.RowCreateUser
			,	OD_RowModifiedDT = od.RowModifiedDT
			,	OD_RowModifiedUser = od.RowModifiedUser
			,	OD_XML =
				(	select
						*
					from
						dbo.order_detail od2
					where
						od2.id = od.id
					for xml raw
				)
			,	RowCreateDT
			,	RowCreateUser
			,	RowModifiedDT
			,	RowModifiedUser
			from
				dbo.shipper s
				join dbo.shipper_detail sd
					on sd.shipper = s.id
				join dbo.order_header oh
					on oh.order_no = sd.order_no
				join dbo.order_detail od
					on od.order_no = sd.order_no
			where
				s.id = @Shipper

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

declare
	@FinishedPart varchar(25) = 'ALC0598-HC02'
,	@ParentHeirarchID hierarchyid

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_UpdateShipperOrders
	@FinishedPart = @FinishedPart
,	@ParentHeirarchID = @ParentHeirarchID
,	@TranDT = @TranDT out
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
