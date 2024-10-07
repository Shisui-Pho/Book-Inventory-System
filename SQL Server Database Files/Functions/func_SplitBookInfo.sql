SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[SplitBookInfo]
(
    @InputString VARCHAR(100)  -- The input string containing the ID, name, and surname
)
RETURNS @Result TABLE  -- Returns a table with the split values
(
    ID INT,                  -- ID of the author or record
    [Name] NVARCHAR(100),      -- Name of the author, without single quotes
    Surname NVARCHAR(100)    -- Surname of the author, without single quotes
)
AS
BEGIN
    -- =====================================================================
    -- Description: This function takes a formatted input string containing 
    --              an author's ID, name, and surname, splits the string, 
    --              and returns the values in a table format.
    --
    -- Parameters:
    --     @InputString (VARCHAR(100)): A string formatted as:
    --                 id,''name'',''surname''.
    --                 The ID should be an integer, while name and surname
    --                 should be enclosed in double single quotes.
    --
    -- Returns:
    --     A table with the following columns:
    --         - ID (INT): The ID of the author.
    --         - Name (NVARCHAR(100)): The author's name without single quotes.
    --         - Surname (NVARCHAR(100)): The author's surname without single quotes.
    --
    -- Example Call: 
    --     SELECT * FROM dbo.SplitBookInfo('1,''John'',''Doe''');
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
    
    INSERT INTO @Result (ID, Name, Surname)  -- Insert into the result table
    SELECT 
        CAST(MAX(CASE WHEN RowNum = 1 THEN value END) AS INT),  -- Cast first value to ID
        LTRIM(RTRIM(REPLACE(MAX(CASE WHEN RowNum = 2 THEN value END), '''', ''))),  -- Clean and trim name
        LTRIM(RTRIM(REPLACE(MAX(CASE WHEN RowNum = 3 THEN value END), '''', '')))   -- Clean and trim surname
    FROM SplitValues;

    RETURN;  -- Return the result table
END;
GO
