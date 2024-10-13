ALTER PROCEDURE proc_UpdateBook
                 --For the book table
                @Book_ISBN          VARCHAR(20),
                @Book_Title         NVARCHAR(500),
                @Quantity           SMALLINT,
                @Publication        SMALLINT,
                @Genre              VARCHAR(200),
                @Book_ID            INT OUTPUT, -- ID Of the book will be needed on the client side

                @Authors            VARCHAR(MAX)
AS
BEGIN 
    -- =====================================================================
    -- Procedure Name: proc_UpdateBook
    -- Description: Updates an existing book's details in the Book table 
    --              and replaces its associated authors with new entries 
    --              provided in the format specified. All previous authors 
    --              will be removed before linking the new authors.
    --
    -- Parameters:
    --     @Book_ISBN (VARCHAR(20)): ISBN of the book.
    --     @Book_Title (NVARCHAR(500)): Title of the book.
    --     @Quantity (SMALLINT): Quantity of the book.
    --     @Publication (SMALLINT): Publication year of the book.
    --     @Genre (VARCHAR(200)): Genre of the book.
    --     @Book_ID (INT OUTPUT): Output parameter to return the ID of the 
    --                            updated book.
    --     @Authors (VARCHAR(MAX)): Author details formatted as:
    --         id1,''name1'', ''surname1'';id2,''name2'',''surname2'';...
    --         where id is 0 to add a new author, and each field is 
    --         separated by a comma, with double single quotes as text qualifiers.
    --
    -- Return Values:
    --     0: An error occurred during the update process.
    --     -1: An error occurred during deletion or author insertion.
    --     1: Update and author replacement completed successfully.
    --
    -- Example Call: EXEC proc_UpdateBook 
    --                @Book_ISBN = '1234567890123', 
    --                @Book_Title = N'Updated Book Title', 
    --                @Quantity = 5, 
    --                @Publication = 2024, 
    --                @Genre = 'Non-Fiction', 
    --                @Book_ID = @OutputBookID OUTPUT, 
    --                @Authors = '2,''Alice'',''Smith'';3,''Bob'',''Johnson''';
    -- =====================================================================

    BEGIN TRANSACTION tras1

    --Create a tempory author table for authors
    CREATE TABLE #TempAuthorsDet 
    (
        [ID] INT,
        AuthorName         NVARCHAR(150),
        AuthorSurname      NVARCHAR(150), 
        DOB                DATE
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
        RETURN 0;
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
    INSERT INTO #TempAuthorsDet(ID, AuthorName, AuthorSurname, DOB)
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