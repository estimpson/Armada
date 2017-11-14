SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[sp_AddForeignKeys]
as
declare	ForeignKeys cursor read_only local for
select distinct
	CONSTRAINT_NAME
,	TABLE_SCHEMA
,	TABLE_NAME
,	UNIQUE_TABLE_SCHEMA
,	UNIQUE_TABLE_NAME
from
	FT.REFERENTIAL_CONSTRAINT_DEFS

open
	ForeignKeys

while
	1 = 1 begin
	declare
		@ForeignKeyName sysname
	,	@TableSchema sysname
	,	@TableName sysname
	,	@ColumnName sysname
	,	@UniqueTableSchema sysname
	,	@UniqueTableName sysname
	,	@UniqueColumnName sysname
	,	@CreateForeignKeySyntax nvarchar(max)
	,	@UniqueColumnList nvarchar(max)
	
	fetch
		ForeignKeys
	into
		@ForeignKeyName
	,	@TableSchema
	,	@TableName
	,	@UniqueTableSchema
	,	@UniqueTableName

	if	@@FETCH_STATUS != 0 begin
		break
    end

	set	@CreateForeignKeySyntax = N'alter table [' + @TableSchema + '].[' + @TableName + '] add constraint ' + @ForeignKeyName + ' foreign key ('
	
	declare	ForeignKeyColumns cursor local for
	select
		COLUMN_NAME
	,	UNIQUE_COLUMN_NAME
	from
		FT.REFERENTIAL_CONSTRAINT_DEFS
	where
		CONSTRAINT_NAME = @ForeignKeyName and
		TABLE_NAME = @TableName
	order by
		ORDINAL_POSITION
	
	open
		ForeignKeyColumns
	
	fetch
		ForeignKeyColumns
	into
		@ColumnName
	,	@UniqueColumnName
		
	set	@CreateForeignKeySyntax = @CreateForeignKeySyntax + @ColumnName
	set	@UniqueColumnList = @UniqueColumnName
	
	fetch
		ForeignKeyColumns
	into
		@ColumnName
	,	@UniqueColumnName
		
	while	@@FETCH_STATUS = 0 begin
		set	@CreateForeignKeySyntax = @CreateForeignKeySyntax + ',' + @ColumnName
		set	@UniqueColumnList = @UniqueColumnList + ',' + @UniqueColumnName
		
		fetch
			ForeignKeyColumns
		into
			@ColumnName
		,	@UniqueColumnName
	end
	
	close
		ForeignKeyColumns
	
	deallocate
		ForeignKeyColumns
	
	set	@CreateForeignKeySyntax = @CreateForeignKeySyntax + ') references [' + @UniqueTableSchema + '].[' + @UniqueTableName + '] (' + @UniqueColumnList + ')'
	print @CreateForeignKeySyntax
	begin transaction
		
	execute	sp_executesql @CreateForeignKeySyntax
	
	if	@@ERROR = 0 begin
		delete
			rcd
		from
			FT.REFERENTIAL_CONSTRAINT_DEFS rcd
		where
			rcd.CONSTRAINT_NAME = @ForeignKeyName

		commit transaction
	end
    else begin
		rollback transaction
	end

	set	@CreateForeignKeySyntax = ''
	set	@UniqueColumnList = ''
end

close
	ForeignKeys

deallocate
	ForeignKeys
GO
