SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [FT].[fn_GetThreeDigitDate]
(
	@Date datetime
)
returns char(3)
as
begin
	--- <Body>
	declare
		@baseThirtySixDate varchar(3)
	,	@dayDiff int
	,	@allDigits varchar(36)
	,	@threeDigitDate char(3)

	set @baseThirtySixDate = ''
	set @dayDiff = datediff(day, '20170101', @Date) -- start date provided by Tesla in their Tesla 3dig date spreadsheet
	set @allDigits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

	while (@dayDiff > 0) begin
		set @baseThirtySixDate = substring(@allDigits, @dayDiff % 36 + 1, 1) + @baseThirtySixDate
		set @dayDiff = @dayDiff / 36
	end
  
	set @threeDigitDate = right(('000' + @baseThirtySixDate), 3)



/*
	declare 
		@DayNumber int
	,	@MonthNumber int
	,	@YearNumber int

	set @DayNumber = datepart(day, @Date)
	set @MonthNumber = datepart(month, @Date)
	set	@YearNumber = datepart(year, @Date)


	-- Set the day character
	declare
		@DayChar char(1)
	,	@MonthChar char(1)
	,	@YearChar char(1)

	if (@DayNumber < 10) begin

		set @DayChar = @DayNumber
	
	end
	else begin

		select
			@DayChar = case
				when @DayNumber = 10 then 'A'
				when @DayNumber = 11 then 'B'
				when @DayNumber = 12 then 'C'
				when @DayNumber = 13 then 'D'
				when @DayNumber = 14 then 'E'
				when @DayNumber = 15 then 'F'
				when @DayNumber = 16 then 'G'
				when @DayNumber = 17 then 'H'
				when @DayNumber = 18 then 'I'
				when @DayNumber = 19 then 'J'
				when @DayNumber = 20 then 'K'
				when @DayNumber = 21 then 'L'
				when @DayNumber = 22 then 'M'
				when @DayNumber = 23 then 'N'
				when @DayNumber = 24 then 'O'
				when @DayNumber = 25 then 'P'
				when @DayNumber = 26 then 'Q'
				when @DayNumber = 27 then 'R'
				when @DayNumber = 28 then 'S'
				when @DayNumber = 29 then 'T'
				when @DayNumber = 30 then 'U'
				when @DayNumber = 31 then 'V'
			end

	end

	-- Set the month character
	select
		@MonthChar = case
			when @MonthNumber = 1 then 'A'
			when @MonthNumber = 2 then 'B'
			when @MonthNumber = 3 then 'C'
			when @MonthNumber = 4 then 'D'
			when @MonthNumber = 5 then 'E'
			when @MonthNumber = 6 then 'F'
			when @MonthNumber = 7 then 'G'
			when @MonthNumber = 8 then 'H'
			when @MonthNumber = 9 then 'I'
			when @MonthNumber = 10 then 'J'
			when @MonthNumber = 11 then 'K'
			when @MonthNumber = 12 then 'L'
		end

	-- Set the year character
	select
		@YearChar = case
			when @YearNumber = 2017 then 'A'
			when @YearNumber = 2018 then 'B'
			when @YearNumber = 2019 then 'C'
			when @YearNumber = 2020 then 'D'
			when @YearNumber = 2021 then 'E'
			when @YearNumber = 2022 then 'F'
			when @YearNumber = 2023 then 'G'
			when @YearNumber = 2024 then 'H'
			when @YearNumber = 2025 then 'I'
			when @YearNumber = 2026 then 'J'
			when @YearNumber = 2027 then 'K'
			when @YearNumber = 2028 then 'L'
			when @YearNumber = 2029 then 'M'
			when @YearNumber = 2030 then 'N'
			when @YearNumber = 2031 then 'O'
			when @YearNumber = 2032 then 'P'
			when @YearNumber = 2033 then 'Q'
			when @YearNumber = 2034 then 'R'
			when @YearNumber = 2035 then 'S'
			when @YearNumber = 2036 then 'T'

			when @YearNumber = 2037 then 'A'
			when @YearNumber = 2038 then 'B'
			when @YearNumber = 2039 then 'C'
			when @YearNumber = 2040 then 'D'
			when @YearNumber = 2041 then 'E'
			when @YearNumber = 2042 then 'F'
			when @YearNumber = 2043 then 'G'
			when @YearNumber = 2044 then 'H'
			when @YearNumber = 2045 then 'I'
			when @YearNumber = 2046 then 'J'
			when @YearNumber = 2047 then 'K'
			when @YearNumber = 2048 then 'L'
			when @YearNumber = 2049 then 'M'
			when @YearNumber = 2050 then 'N'
			when @YearNumber = 2051 then 'O'
			when @YearNumber = 2052 then 'P'
			when @YearNumber = 2053 then 'Q'
			when @YearNumber = 2054 then 'R'
			when @YearNumber = 2055 then 'S'
			when @YearNumber = 2056 then 'T'

			when @YearNumber = 2057 then 'A'
			when @YearNumber = 2058 then 'B'
			when @YearNumber = 2059 then 'C'
			when @YearNumber = 2060 then 'D'
			when @YearNumber = 2061 then 'E'
			when @YearNumber = 2062 then 'F'
			when @YearNumber = 2063 then 'G'
			when @YearNumber = 2064 then 'H'
			when @YearNumber = 2065 then 'I'
			when @YearNumber = 2066 then 'J'
			when @YearNumber = 2067 then 'K'
			when @YearNumber = 2068 then 'L'
			when @YearNumber = 2069 then 'M'
			when @YearNumber = 2070 then 'N'
			when @YearNumber = 2071 then 'O'
			when @YearNumber = 2072 then 'P'
			when @YearNumber = 2073 then 'Q'
			when @YearNumber = 2074 then 'R'
			when @YearNumber = 2075 then 'S'
			when @YearNumber = 2076 then 'T'
		end

		-- Complete the three digit date
		declare
			@ThreeDigitDate char(3)

		set @ThreeDigitDate = @YearChar + @MonthChar + @DayChar 
*/
--- </Body>


---	<Return>
	return
		@threeDigitDate
end
--- </Return>



GO
