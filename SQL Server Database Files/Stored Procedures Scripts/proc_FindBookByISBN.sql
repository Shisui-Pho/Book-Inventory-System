CREATE PROCEDURE proc_FindBookByISBN
                @BookISBN       VARCHAR(20)
AS
BEGIN
    -- =====================================================================
    -- Procedure Name: proc_FindBookByISBN
    -- Description: Retrieves book details based on the provided ISBN and 
    --              returns the associated authors and their publication counts.
    --
    -- Parameters:
    --     @BookISBN (VARCHAR(20)): The ISBN of the book to search for.
    --
    -- Output:
    --     Book_ID (INT): ID of the book.
    --     Book_ISBN (VARCHAR(20)): ISBN of the book.
    --     Book_Title (NVARCHAR(500)): Title of the book.
    --     Genre (VARCHAR(200)): Genre of the book.
    --     PublicationYear (SMALLINT): Year the book was published.
    --     Quantity (SMALLINT): Number of copies available.
    --     Author_ID (INT): ID of the author.
    --     Author_Name (NVARCHAR(150)): Name of the author.
    --     Author_Surname (NVARCHAR(150)): Surname of the author.
    --     AuthorPublications (INT): Number of publications by the author.
    --
    -- Example Call: EXEC proc_FindBookByISBN @BookISBN = '1234567890123';
    -- =====================================================================

    SELECT Book.Book_ID,
           Book.Book_ISBN,
           Book.Book_Title,
           Book.Genre,
           Book.PublicationYear,
           Book.Quantity,
           Author.Author_ID,
           Author.Author_Name,
           Author.Author_Surname,
           Author.Publications AS AuthorPublications
    FROM Book
    INNER JOIN BookAuthor
        ON Book.Book_ISBN = @BookISBN --Filter the books before joining
        AND Book.Book_ID = BookAuthor.Book_ID
    INNER JOIN Author
        ON BookAuthor.Author_ID = Author.Author_ID;
END