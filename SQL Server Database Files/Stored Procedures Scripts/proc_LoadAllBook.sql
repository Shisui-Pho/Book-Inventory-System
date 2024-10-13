ALTER PROCEDURE proc_LoadAllBook
AS
BEGIN
-- =====================================================================
-- Procedure Name: proc_LoadAllBook
-- Description: Retrieves all books from the database along with their 
--              associated authors' details. This procedure joins the 
--              Book, BookAuthor, and Author tables to return book 
--              information and the corresponding authors for each book.
--
-- Parameters:
--     None
--
-- Return Values:
--     The procedure returns the following columns for each book:
--         - Book_ID (INT): Unique identifier of the book.
--         - Book_ISBN (VARCHAR(20)): ISBN of the book.
--         - Book_Title (NVARCHAR(500)): Title of the book.
--         - Genre (VARCHAR(200)): Genre of the book.
--         - PublicationYear (SMALLINT): Year the book was published.
--         - Quantity (SMALLINT): Quantity of the book available.
--         - Author_ID (INT): Unique identifier of the author.
--         - Author_Name (NVARCHAR(150)): First name of the author.
--         - Author_Surname (NVARCHAR(150)): Last name of the author.
--         - AuthorPublications (INT): Number of publications by the author.
--
-- Example Call: EXEC proc_LoadAllBook;
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
       Author.DOB,
       Author.Publications AS AuthorPublications
    FROM Book
    INNER JOIN BookAuthor
        ON Book.Book_ID = BookAuthor.Book_ID
    INNER JOIN Author
        ON BookAuthor.Author_ID = Author.Author_ID;
END;