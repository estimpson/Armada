SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetNextIdentifier] @as_identifiertype varchar(25),
                                   @as_identifierformat varchar(40),
                                   @as_nextnumber varchar(25) OUTPUT
AS

-- 22-Oct-2013 Modified for Addresses and Contacts to loop until an
--             ID that isn't already in use is found because Empire
--             was getting duplicate key errors when our triggers
--             inserted from Monitor.

-- 29-Apr-2006 Changed columns that were char to varchar.

-- 13-Sep-2000 Modified to update identifier_formats before selecting
--             from it. An update is the only way to get an exclusive
--             lock on the table. We need an exclusive lock so that
--             no other user can select the next number that we just
--             selected.

 BEGIN
   DECLARE @s_prefix varchar(15),
           @s_suffix varchar(15),
           @i_startnumber integer,
           @i_increment smallint,
           @i_maxnumber integer,
           @i_nextnumber integer,
           @i_count integer

  WHILE 1 = 1

    BEGIN

    -- Update first to put a lock on the row.
      UPDATE identifier_formats
         SET next_number=next_number + increment_by, changed_date=GETDATE()
       WHERE identifier_type=@as_identifiertype
        AND identifier_format=@as_identifierformat

      SELECT @s_prefix = IsNull(prefix,''),
             @i_startnumber = starting_number, @i_increment = increment_by,
	     @i_maxnumber = maximum_number, @i_nextnumber = next_number,
             @s_suffix = IsNull(suffix,'')
        FROM identifier_formats
       WHERE identifier_type=@as_identifiertype AND identifier_format=@as_identifierformat

      -- Because the update has already incremented the next number, we must
      -- decrement it before using it in the string.
      SELECT @i_nextnumber = @i_nextnumber - @i_increment

      SELECT @as_nextnumber=RTRIM(@s_prefix) +
        SUBSTRING('0000000000',1,(DATALENGTH(LTRIM(STR(@i_maxnumber)))
           - DATALENGTH(LTRIM(STR(@i_nextnumber))))) +
	LTRIM(STR(@i_nextnumber)) + RTRIM(@s_suffix)

      IF @i_nextnumber + @i_increment > @i_maxnumber
        BEGIN
          UPDATE identifier_formats
             SET next_number=@i_startnumber, changed_date=GETDATE()
           WHERE identifier_type=@as_identifiertype
             AND identifier_format=@as_identifierformat
        END

      -- Verify that the ID isn't already in use.
      SELECT @i_count = 0
      IF @as_identifiertype = 'ADDRESS'
          SELECT @i_count = Count(*)
            FROM addresses
           WHERE address_id = @as_nextnumber
      ELSE
        IF @as_identifiertype = 'CONTACT'
          SELECT @i_count = Count(*)
            FROM contacts
           WHERE contact_id = @as_nextnumber

      IF @i_count = 0 BREAK
    END
  END
GO
