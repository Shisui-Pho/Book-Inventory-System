/*
    -- =====================================================================
    -- TEST 1: Test Adding and Removing a Book
    -- 
    -- Description:
    --     This test adds a new book along with its associated authors to 
    --     the database using 'proc_AddBook'. After verifying the addition, 
    --     it removes the book using 'proc_RemoveBook'. Note that authors 
    --     remain in the database even after the book is removed.
    -- 
    -- Notes:
    --     - This test covers books with completely new authors, which is 
    --       why the author IDs are set to 0.
    --     - The `proc_RemoveBook` only removes the book and its associations 
    --       with the authors but does not delete the authors themselves.
    -- 
    -- Test Data:
    --     Title       : "AMD Moview"
    --     ISBN        : '1234567891'
    --     Quantity    : 10
    --     Publication : 2025
    --     Genre       : 'Horror'
    -- 
    -- Authors:
    --     Name            : Surname

    --     Phiwo           : Bruts   (new)
    --     Hayser          : Hedrulto (new)
    --     Bysannds        : Basic   (new)
    -- 
    -- Steps:
    --     1. Execute proc_AddBook to add the book and authors.
    --     2. Inspect the newly inserted records in Book, Author, and BookAuthor tables.
    --     3. Cleanup: Remove the newly added book for re-testing.
    -- 
    -- Example Call:
    --     EXEC proc_AddBook 
    --         @Book_ISBN = '1234567891',
    --         @Book_Title = 'AMD Moview',
    --         @Quantity   = 10,
    --         @Publication = 2025,
    --         @Genre       = 'Horror',
    --         @Book_ID = @BookID OUTPUT,
    --         @Authors = '0,''Phiwo'',''Bruts'';0,''Hayser'',''Hedrulto'';0,''Bysannds'',''Basic''';
    -- 
    -- Example Remove:
    --     EXEC proc_RemoveBook @BookID;
    -- 
    -- Expected Result:
    --     - The book and its authors should be successfully added to the 
    --       database.
    --     - After running `proc_RemoveBook`, the book and the relationships 
    --       in `BookAuthor` should be deleted, but the authors should 
    --       still remain in the `Author` table.
    -- =====================================================================
*/

DECLARE @BookID INT;

-- Add a new book with new authors
EXEC proc_AddBook @Book_ISBN = '1234567891',
                  @Book_Title = 'AMD Moview',
                  @Quantity   = 10,
                  @Publication = 2025,
                  @Genre       = 'Horror',
                  @Book_ID = @BookID OUTPUT,
                  @Authors = '0,''Phiwo'',''Bruts'',''2024/03/10'';0,''Hayser'',''Hedrulto'',''2022/12/12'';0,''Bysannds'',''Basic'', ''1918/01/10''';
-- Inspect the inserted book and relationships

-- Check the last inserted book
SELECT * FROM Book 
INNER JOIN BookAuthor
    ON Book.Book_ID = (SELECT MAX(Book_ID) FROM Book)
    AND BookAuthor.Book_ID = Book.Book_ID
INNER JOIN Author
    ON BookAuthor.Author_ID = Author.Author_ID;

-- Check the Author table to ensure authors were added
SELECT * FROM Author;

-- Check the BookAuthor relationship
SELECT * FROM BookAuthor;

-- Remove the newly added book and its book-author relationships
-- The Book_ID is used from the @BookID output above
EXEC proc_RemoveBook  @BookID;

-- Verify the removal from the Book and BookAuthor tables
SELECT * FROM Book WHERE Book_ID = @BookID;
SELECT * FROM BookAuthor WHERE Book_ID = @BookID;

-- The authors should still remain in the Author table
SELECT * FROM Author;

-- Clean-up: Remove the newly added authors if needed (IDs greater than 77)
DELETE FROM Author WHERE Author_ID > 77;
