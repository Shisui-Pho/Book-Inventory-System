ALTER PROCEDURE proc_AddBook
                --For the book table
                @Book_ISBN          VARCHAR(20),
                @Book_Title         NVARCHAR(500),
                @Quantity           SMALLINT,
                @Publication        SMALLINT,
                @Genre              VARCHAR(200),
                @Book_ID            INT OUTPUT, -- ID of the book needed on the client side

                @Authors            VARCHAR(MAX)  -- Author details formatted as described below
AS
BEGIN
/*
    -- =====================================================================
    -- Procedure Name: proc_AddBook
    -- Description: Inserts a new book into the Book table and associates it 
    --              with its authors. Author details must be passed in a specific 
    --              format to be processed and inserted into the Author table.
    --
    -- Parameters:
    --     @Book_ISBN (VARCHAR(20)): ISBN of the book.
    --     @Book_Title (NVARCHAR(500)): Title of the book.
    --     @Quantity (SMALLINT): Quantity of the book.
    --     @Publication (SMALLINT): Publication year of the book.
    --     @Genre (VARCHAR(200)): Genre of the book.
    --     @Book_ID (INT OUTPUT): Output parameter to return the ID of the newly 
    --                            inserted book.
    --     @Authors (VARCHAR(MAX)): Author details formatted as:
    --         id1,''name1'', ''surname1'','dob1';id2,''name2'',''surname2'',''dob2'';...
    --         where id is 0 to add a new author, and each field is 
    --         separated by a comma, with double single quotes as text qualifiers.
               --Note: The date is formatted as follows: yyyy/mm/dd

    
    -- Error Handling: The procedure rolls back the transaction if any error 
    --                 occurs during the insertion of the book or authors.
    --
    -- Example Call: EXEC proc_AddBook 
    --                @Book_ISBN = '1234567890123', 
    --                @Book_Title = N'Example Book', 
    --                @Quantity = 10, 
    --                @Publication = 2023, 
    --                @Genre = 'Fiction', 
    --                @Book_ID = @OutputBookID OUTPUT, 
    --                @Authors = '0,''John'',''Doe'',''1986/01/03'';0,''Jane'',''Smith'',''1667/03/01''';

    -- Example Output:
    --     Book_ID         | Author_ID
    --     ----------------------------
    --          5          | 1
    --          5          | 2
    --
    -- This output returns the Book_ID and Author_ID(s) of the inserted or associated authors.
    -- The order of the author Id's is the sme as in the @Authors string
    -- =====================================================================
*/

    BEGIN TRANSACTION trans1

        --Add the book to the book-table
        INSERT INTO Book(Book_ISBN, Book_Title, Quantity, PublicationYear, Genre)
        VALUES(@Book_ISBN,@Book_Title,@Quantity,@Publication,@Genre);

        --Check if the insertion was susccessful
        IF @@ERROR <> 0
        BEGIN
            --Rollback the changes
            ROLLBACK TRANSACTION trans1
            SET @Book_ID = NULL;
            RETURN;
        END

        --SET THE BOOK ID
        SET @Book_ID = SCOPE_IDENTITY();

        --Create a tempory author table for authors
        CREATE TABLE #TempAuthorsDet 
        (
            [ID] INT,
            AuthorName         NVARCHAR(150),
            AuthorSurname      NVARCHAR(150),
            DOB                DATE
        );

        --Temporary variable for the author details for the cursor
        DECLARE @AuthorID       INT,
                @AuthorName     NVARCHAR(100),
                @AuthorSurname  NVARCHAR(100),
                @DOB            DATE, 
                @AuthorID_test  INT; --This will be used to check if an author with the same name exists

        
        INSERT INTO #TempAuthorsDet(ID, AuthorName, AuthorSurname, DOB)
        EXEC helper_proc_ExtractAuthorsToTable @Authors; --Insert the data of the other procedure to the temporary table

        --Create a cursor to loop through all the authors in the table
        DECLARE Author_Cursor CURSOR FOR 
        SELECT * FROM #TempAuthorsDet; 

        OPEN Author_Cursor;
        FETCH NEXT FROM Author_Cursor INTO @AuthorID, @AuthorName, @AuthorSurname, @DOB;

        WHILE @@FETCH_STATUS = 0
        BEGIN

            --Here we might need to also check if we are not duplicating authors(autho)
            --Check if an author with the same names exists
            SET @AuthorID_test = (SELECT Top 1 Author_ID FROM Author WHERE Author_Name = @AuthorName AND Author_Surname = @AuthorSurname AND DOB = @DOB);

            IF @AuthorID_test IS NOT NULL
            BEGIN
                --UPDATE THE TEMPORARY TABLE
                UPDATE #TempAuthorsDet 
                SET [ID] = @AuthorID_test
                WHERE AuthorName = @AuthorName
                AND   AuthorSurname = @AuthorSurname
                AND DOB = @DOB;

                --Update the authorID 
                SET @AuthorID = @AuthorID_test;
            END
            --Check if the author exists(by id)
            ELSE IF NOT EXISTS (SELECT Author_Name FROM Author WHERE Author_ID = @AuthorID)
            BEGIN
                --Create a new author record
                INSERT INTO Author(Author_Name, Author_Surname, Publications, DOB)
                VALUES(@AuthorName, @AuthorSurname, 0, @DOB);

                --Check if we had an error
                IF @@ERROR <> 0
                BEGIN
                    -- Cleanup before returning
                    CLOSE Author_Cursor;
                    DEALLOCATE Author_Cursor;
                
                    -- Rollback and return
                    ROLLBACK TRANSACTION trans1;
                    SET @Book_ID = NULL;
                    RETURN;
                END

                
                --Update the id in the temp_table
                UPDATE #TempAuthorsDet
                SET ID = SCOPE_IDENTITY()
                WHERE ID = @AuthorID 
                AND   AuthorName = @AuthorName
                AND   AuthorSurname = @AuthorSurname
                AND   DOB = @DOB;
                
                --Set the ID to the last generates ID
                SET @AuthorID = SCOPE_IDENTITY()
                
            END

            --Here the Author Exists in our database
            --Link the bookl and the author
            INSERT INTO BookAuthor(Book_ID, Author_ID)
            VALUES(@Book_ID, @AuthorID);

             --Check if we had an error
            IF @@ERROR <> 0
            BEGIN
                -- Cleanup before returning
                CLOSE Author_Cursor;
                DEALLOCATE Author_Cursor;
            
                -- Rollback and return
                ROLLBACK TRANSACTION trans1;
                SET @Book_ID = NULL;
                RETURN;
            END

            --Fetch the next record
            FETCH NEXT FROM Author_Cursor INTO @AuthorID, @AuthorName, @AuthorSurname, @DOB;
        END
    --Commit changes
    COMMIT TRANSACTION trans1

    --Return the results to the calling application
    SELECT @Book_ID AS Book_ID, #TempAuthorsDet.ID AS Author_ID
    FROM #TempAuthorsDet;
    
    --Clean-up
    CLOSE Author_Cursor;
    DEALLOCATE Author_Cursor;

    DROP TABLE #TempAuthorsDet;
END;