ALTER PROCEDURE helper_proc_ExtractAuthorsToTable
                 @Authors               VARCHAR(MAX)
AS 
BEGIN
    --=====================================================================
    --Procedure Name: helper_proc_ExtractAuthorsToTable
    --Description: This helper procedure extracts author information from a 
    --             formatted string and inserts it into a temporary table. 
    --             It utilizes the SplitBookInfo function to parse the author 
    --             records into separate fields.
    --
    --Parameters:
    --    @Authors (VARCHAR(MAX)): A string containing author records formatted as:
    --             id1,''name1'', ''surname1'';id2,''name2'',''surname2'';...
    --             Each author record should be separated by a semicolon (;).
    -- 
    --Return Values: 
    --    Returns the records from the temporary table containing extracted 
    --    author details (ID, AuthorName, AuthorSurname).
    --
    --Example Call: 
    --    EXEC helper_proc_ExtractAuthorsToTable 
    --        @Authors = '0,''John'',''Doe'';0,''Jane'',''Smith''';
    --
    --Note: This procedure uses the STRING_SPLIT function available in SQL Server 
    --      for breaking the input string into records.
    --=====================================================================
    
    --Create a tempory author table for authors
    CREATE TABLE #TempAuthors 
    (
         [ID] INT,
         AuthorName         NVARCHAR(150),
         AuthorSurname      NVARCHAR(150)
    );

    DECLARE @AuthorRecord   VARCHAR(255),
            @AuthorID       INT,
            @AuthorName     NVARCHAR(100),
            @AuthorSurname  NVARCHAR(100);

    --Create a curso that will go through the author records
    DECLARE AuthorRecordCursor CURSOR FOR
    SELECT VALUE FROM STRING_SPLIT(@Authors, ';') WHERE VALUE <> '';  -- Break the string into records

    OPEN AuthorRecordCursor;
    FETCH NEXT FROM AuthorRecordCursor INTO @AuthorRecord;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        --Split the record and extract the output results using the function
        INSERT INTO #TempAuthors([ID], AuthorName, AuthorSurname)
        SELECT TOP 1 [ID], [Name], Surname
        FROM dbo.SplitBookInfo(@AuthorRecord);

        FETCH NEXT FROM AuthorRecordCursor INTO @AuthorRecord;
    END;

    SELECT * FROM #TempAuthors;

    DROP TABLE #TempAuthors;
END;