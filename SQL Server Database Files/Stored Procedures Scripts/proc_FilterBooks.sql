ALTER PROCEDURE proc_FilterBook 
                @Book_Title             NVARCHAR(300),
                @Genre                  VARCHAR(100),
                @AuthorName             NVARCHAR(100),
                @AuthorSurname          NVARCHAR(100),
                @MustContainValues      BIT
AS
BEGIN
    /*
    -- =====================================================================
    -- PROCEDURE: proc_FilterBook
    --
    -- Description:
    --     This procedure dynamically filters books based on the provided
    --     parameters, such as book title, genre, author name, and author 
    --     surname. It also has a flag, `MustContainValues`, to specify 
    --     whether all provided criteria must be matched or whether any 
    --     of them can be matched.
    --
    -- Parameters:
    --     @Book_Title        NVARCHAR(300)   -- Filter by book title
    --     @Genre             VARCHAR(100)    -- Filter by genre
    --     @AuthorName        NVARCHAR(100)   -- Filter by author name
    --     @AuthorSurname     NVARCHAR(100)   -- Filter by author surname
    --     @MustContainValues BIT             -- 1 = Must match all criteria, 0 = Match any criteria
    --
    -- Notes:
    --     - The procedure constructs a dynamic SQL query to filter books
    --       based on the provided criteria.
    --     - The `MustContainValues` parameter determines whether the filter 
    --       conditions should all be met (`AND`) or if any of the conditions 
    --       can be met (`OR`).
    --     - The procedure filters books using a JOIN between the `Book`,
    --       `BookAuthor`, and `Author` tables.
    --
    -- Example Usage:
    --     - Find books with title containing 'Harry' and genre 'Fantasy':
    --       EXEC proc_FilterBook @Book_Title = 'Harry', @Genre = 'Fantasy', @MustContainValues = 1;
    --
    --     - Find books by author name 'J.K.' or surname 'Rowling':
    --       EXEC proc_FilterBook @AuthorName = 'J.K.', @AuthorSurname = 'owling', @MustContainValues = 0;
    -- =====================================================================
*/
    --The default values should all be null
    DECLARE @Sql          VARCHAR(MAX),
            @BracketAdded BIT;

    SET @BracketAdded = 0;

    SET @Sql = 'SELECT Book.Book_ID, 
                    Book.Book_ISBN, 
                    Book.Book_Title, 
                    Book.Genre, 
                    Book.PublicationYear, 
                    Book.Quantity, 
                    Author.Author_ID, 
                    Author.Author_Name, 
                    Author.Author_Surname, 
                    Author.DOB, 
                    Author.Publications AS AuthorPublications 
                FROM Book   
                INNER JOIN BookAuthor ON BookAuthor.Book_ID = Book.Book_ID 
                INNER JOIN Author ON BookAuthor.Author_ID = Author.Author_ID 
                WHERE 1 =1 ';--Add a default statement for the filter criteria, this will allow for filtering before joining other tables
                                                 --    and also for future extension of the ceode(adding new filtering conditions)
-- Initialize a flag to determine if any filters have been added
    DECLARE @FilterAdded BIT = 0;

    IF(@Book_Title IS NOT NULL)
    BEGIN
        IF @MustContainValues = 1
            SET @Sql = @Sql + ' AND Book.Book_Title LIKE ''%' + @Book_Title + '%''';
        ELSE
        BEGIN
            SET @Sql = @Sql + ' AND (Book.Book_Title LIKE ''' + @Book_Title + '%''';
            SET @FilterAdded = 1;
        END
    END

    IF(@Genre IS NOT NULL)
    BEGIN
        IF @MustContainValues = 1
            SET @Sql = @Sql + ' AND Genre LIKE ''%' + @Genre + '%''';
        ELSE
        BEGIN
            IF @FilterAdded = 1
                SET @Sql = @Sql + ' OR Genre LIKE ''' + @Genre + '%''';
            ELSE
            BEGIN
                SET @Sql = @Sql + ' AND ( Genre LIKE ''' + @Genre + '%''';
                SET @FilterAdded = 1;
            END
        END
    END

    IF(@AuthorName IS NOT NULL)
    BEGIN
        IF @MustContainValues = 1
            SET @Sql = @Sql + ' AND Author.Author_Name LIKE ''%' + @AuthorName + '%''';
        ELSE
        BEGIN
            IF @FilterAdded = 1
                SET @Sql = @Sql + ' OR Author.Author_Name LIKE ''' + @AuthorName + '%''';
            ELSE
            BEGIN
                SET @Sql = @Sql + ' AND ( Author.Author_Name LIKE ''' + @AuthorName + '%''';
                SET @FilterAdded = 1;
            END
        END
    END

    IF(@AuthorSurname IS NOT NULL)
    BEGIN
        IF @MustContainValues = 1
            SET @Sql = @Sql + ' AND Author.Author_Surname LIKE ''%' + @AuthorSurname + '%''';
        ELSE
        BEGIN
            IF @FilterAdded = 1
                SET @Sql = @Sql + ' OR Author.Author_Surname LIKE ''' + @AuthorSurname + '%''';
            ELSE
            BEGIN
                SET @Sql = @Sql + ' AND ( Author.Author_Surname LIKE ''' + @AuthorSurname + '%''';
                SET @FilterAdded = 1;
            END
        END
    END

    -- Close the grouping if any OR conditions were added
    IF @FilterAdded = 1
        SET @Sql = @Sql + ' )'; 

    EXEC(@Sql);
END;
