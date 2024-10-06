SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitBookInfo]
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
