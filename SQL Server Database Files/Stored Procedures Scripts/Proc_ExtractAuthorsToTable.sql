/*
    This is a helper procedure to extract the string of authors into a table of authors
    This procedure uses the SplitBookInfo function which is defined in the database
*/
CREATE PROCEDURE helper_proc_ExtractAuthorsToTable
                 @Authors               VARCHAR(MAX)
AS 
BEGIN
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
    END;

    SELECT * FROM #TempAuthors;

    DROP TABLE #TempAuthors;
END;