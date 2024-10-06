CREATE PROCEDURE proc_AddBook
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
                @Authors            VARCHAR(MAX)
AS
BEGIN
    BEGIN TRANSACTION trans1

        --Add the book to the book-table
        INSERT INTO Book(Book_ISBN, Book_Title, Quantity, PublicationYear, Genre)
        VALUES(@Book_ISBN,@Book_Title,@Quantity,@Publication,@Genre);

        --Check if the insertion was susccessful
        IF @@ERROR <> 0
        BEGIN
            --Rollback the changes
            ROLLBACK TRANSACTION trans1
            SELECT 0 AS ERROR;
            RETURN;
        END

        --SET THE BOOK ID
        SET @Book_ID = SCOPE_IDENTITY();

     --Create a tempory author table for authors
        CREATE TABLE #TempAuthorsDet 
        (
            [ID] INT,
            AuthorName         NVARCHAR(150),
            AuthorSurname      NVARCHAR(150)
        );

        --Temporary variable for the author details for the cursor
        DECLARE @AuthorID       INT,
                @AuthorName     NVARCHAR(100),
                @AuthorSurname  NVARCHAR(100);

        
        INSERT INTO #TempAuthorsDet(ID, AuthorName, AuthorSurname)
        EXEC helper_proc_ExtractAuthorsToTable @Authors; --Insert the data of the other procedure to the temporary table

        --Create a cursor to loop through all the authors in the table
        DECLARE Author_Cursor CURSOR FOR 
        SELECT * FROM #TempAuthorsDet; 

        OPEN Author_Cursor;
        FETCH NEXT FROM Author_Cursor INTO @AuthorID, @AuthorName, @AuthorSurname;

        WHILE @@FETCH_STATUS = 0
        BEGIN

            --Check if the author exists
            IF NOT EXISTS (SELECT Author_Name FROM Author WHERE Author_ID = @AuthorID)
            BEGIN
                --Create a new author record
                --Here we might need to also check if we are not duplicating authors
                INSERT INTO Author(Author_Name, Author_Surname)
                VALUES(@AuthorName, @AuthorSurname);

                --Check if we had an error
                IF @@ERROR <> 0
                BEGIN
                    -- Cleanup before returning
                    CLOSE Author_Cursor;
                    DEALLOCATE Author_Cursor;
                
                    -- Rollback and return
                    ROLLBACK TRANSACTION trans1;
                    SELECT 0 AS ERROR;
                    RETURN;
                END

                
                --Update the id in the temp_table
                UPDATE #TempAuthorsDet
                SET ID = SCOPE_IDENTITY()
                WHERE ID = @AuthorID 
                AND   AuthorName = @AuthorName
                AND   AuthorSurname = @AuthorSurname;
                
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
                SELECT 0 AS ERROR;
                RETURN;
            END

            --Fetch the next record
            FETCH NEXT FROM Author_Cursor INTO @AuthorID, @AuthorName, @AuthorSurname;
        END
    --Commit changes
    COMMIT TRANSACTION trans1

    --Return the results to the calling application
    SELECT @Book_ISBN AS Book_ISBN, #TempAuthorsDet.ID AS Author_ID
    FROM #TempAuthorsDet;
    
    --Clean-up
    CLOSE Author_Cursor;
    DEALLOCATE Author_Cursor;

    DROP TABLE #TempAuthorsDet;
END;