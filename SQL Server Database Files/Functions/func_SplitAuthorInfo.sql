SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_SplitAuthorInfo]
(
    @InputString VARCHAR(100)  -- The input string containing the ID, name, surname, and DOB
)
RETURNS @Result TABLE  -- Returns a table with the split values
(
    ID INT,                   -- ID of the author or record
    [Name] NVARCHAR(100),      -- Name of the author, without single quotes
    Surname NVARCHAR(100),     -- Surname of the author, without single quotes
    DOB DATE                   -- Date of Birth in 'yyyy/mm/dd' format
)
AS
BEGIN
    -- =====================================================================
    -- Description: This function takes a formatted input string containing 
    --              an author's ID, name, surname, and DOB, splits the string, 
    --              and returns the values in a table format. The DOB is formatted
    --              as 'yyyy/mm/dd'.
    --
    -- Parameters:
    --     @InputString (VARCHAR(100)): A string formatted as:
    --                 id,''name'',''surname'',''yyyy/mm/dd''.
    --                 The ID should be an integer, while name, surname, and DOB
    --                 should be enclosed in double single quotes.
    --
    -- Returns:
    --     A table with the following columns:
    --         - ID (INT): The ID of the author.
    --         - Name (NVARCHAR(100)): The author's name without single quotes.
    --         - Surname (NVARCHAR(100)): The author's surname without single quotes.
    --         - DOB (NVARCHAR(10)): The author's date of birth in 'yyyy/mm/dd' format.
    --
    -- Example Call: 
    --     SELECT * FROM dbo.SplitBookInfo('1,''John'',''Doe'',''2024/03/21''');
    --
    -- Note: This function uses STRING_SPLIT to separate the input string 
    --       by commas and ROW_NUMBER to handle the sequence of values.
    -- =====================================================================

    -- Split the input string and store values in a temporary table
    WITH SplitValues AS (
        SELECT 
            value, 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum  -- Assign row numbers to each split value
        FROM STRING_SPLIT(@InputString, ',')  -- Split by comma
    )
    
    INSERT INTO @Result (ID, Name, Surname, DOB)  -- Insert into the result table
    SELECT 
        CAST(MAX(CASE WHEN RowNum = 1 THEN value END) AS INT),  -- Cast first value to ID
        LTRIM(RTRIM(REPLACE(MAX(CASE WHEN RowNum = 2 THEN value END), '''', ''))),  -- Clean and trim name
        LTRIM(RTRIM(REPLACE(MAX(CASE WHEN RowNum = 3 THEN value END), '''', ''))),  -- Clean and trim surname
        -- Extract DOB directly since it's already in 'yyyy/mm/dd' format
        LTRIM(RTRIM(REPLACE(MAX(CASE WHEN RowNum = 4 THEN value END), '''', '')))
    FROM SplitValues;

    RETURN;  -- Return the result table
END;
GO
