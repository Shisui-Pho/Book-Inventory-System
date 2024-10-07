CREATE PROCEDURE proc_UpdateBook
                 --For the book table
                @Book_ISBN          VARCHAR(20),
                @Book_Title         NVARCHAR(500),
                @Quantity           SMALLINT,
                @Publication        SMALLINT,
                @Genre              VARCHAR(200),
                @Book_ID            INT OUTPUT, -- ID Of the book will be needed on the client side
                --For the authors
                --The authors details are passed here, each record must be seperated by a semicolon (;) and each
                --      and each field must be seperated by a coma with a " acting as a text qualifier
                --The format should be as follows
                -->     id1,''name1'', ''surname1'';id2,''name2'',''surname2'';id3,''name3'',''surname3'';.......
                -- NOTE : the string lateral is enclosed with DOUBLE SINGLE quotes (') and not double quote (")

                -- The default "id" should be 0, which indicates that the author should be added to the Author table
                -- After the insertion, the authors and book will be linked in the BookAuthor table 

                --All authors of the previous book will be removed and replaced with this new authors
                @Authors            VARCHAR(MAX)
AS
BEGIN 
    BEGIN TRANSACTION tras1

    --Create a tempory author table for authors
    CREATE TABLE #TempAuthorsDet 
    (
        [ID] INT,
        AuthorName         NVARCHAR(150),
        AuthorSurname      NVARCHAR(150)
    );

    --First update the book table
    UPDATE Book
    SET Book_ISBN = @Book_ISBN,
        Book_Title = @Book_Title,
        Quantity = @Quantity,
        PublicationYear = @Publication,
        Genre = @Genre
    WHERE Book_ID = @Book_ID;

    --Check if there wan an update or an error 
    --If there was no change an error, we need to abort
    IF @@ERROR <> 0 OR @@ROWCOUNT < 1
    BEGIN
        ROLLBACK TRANSACTION trans1;
        SELECT 0 AS ERROR;
        RETURN;
    END

    --Here the book update was a success 
    --Remove all the authors linked to the book, they will be relinked again
    DELETE FROM BookAuthor
    WHERE Book_ID = @Book_ID;

    IF @@ERROR <> 0
    BEGIN 
        ROLLBACK TRANSACTION trans1;
        RETURN -1;
    END

    --Extract the authors string and add them to the temporary table
    INSERT INTO #TempAuthorsDet(ID, AuthorName, AuthorSurname)
    EXEC dbo.helper_proc_ExtractAuthorsToTable @Authors;

    IF @@ERROR <> 0
    BEGIN 
        ROLLBACK TRANSACTION trans1;
        RETURN -1;
    END

    --Re-link the authors and books
    --We assume that the authors have already been added to the database
    INSERT INTO BookAuthor(Book_ID, Author_ID)
    SELECT @Book_ID, [ID]
    FROM #TempAuthorsDet;

        IF @@ERROR <> 0
    BEGIN 
        ROLLBACK TRANSACTION trans1;
        RETURN -1;
    END

    DROP TABLE #TempAuthorsDet;
    COMMIT TRANSACTION trans1;

    RETURN 1;
END;