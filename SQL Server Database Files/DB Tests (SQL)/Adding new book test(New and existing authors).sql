/*
    -- =====================================================================
    -- TEST 2.

    -- Description:
    --     This test adds a new book along with its associated authors to 
    --     the database using 'proc_AddBook'. After verifying the addition, 
    --     it removes the book using 'proc_RemoveBook'. Note that authors 
    --     remain in the database even after the book is removed.

    --  Notes:
    --     This test covers books with a mix of new and existing authors. 
    --     New authors are added with IDs set to 0, while existing authors
    --     retain their current IDs.
    --     The `proc_RemoveBook` only removes the book and its associations 
    --     with the authors but does not delete the authors themselves.

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
    --     Mark P. O.      : Morford  (existing with id 5) 
    --     Richard Bruce   : Wright   (existing with id 6)
    --
    -- Steps:
    --     1. Execute proc_AddBook to add the book and authors.
    --     2. Inspect the newly inserted records in Book, Author, and BookAuthor tables.
    --     3. Cleanup: Remove the newly added book for re-testing.
    --
    -- Example Execution:
    --     This test adds a new book with a mix of new and existing authors.
    --     After inserting, verify the data and ensure everything was added as expected.
    --     Finally, clean up the test data by removing the book. The authors will 
    --     remain in the database.
    -- =====================================================================
*/

DECLARE @BookID INT;


-- Add the new book and its authors using proc_AddBook
EXEC proc_AddBook @Book_ISBN = '1234567891',
                  @Book_Title = 'AMD Moview',
                  @Quantity   = 10,
                  @Publication = 2025,
                  @Genre       = 'Horror',
                  @Book_ID = @BookID OUTPUT,
                  @Authors = '0,''Phiwo'',''Bruts'',''2024/03/21'';0,''Hayser'',''Hedrulto'',''2022/12/12'';0,''Bysannds'',''Basic'', ''1918/01/25'';0,''Mark P. O.'',''Morford'',''1950/05/15'';6,''Richard Bruce'',''Wright'', ''1945/03/01''';

-- Inspect the newly inserted records
-- Retrieve the last inserted book along with its associated authors
SELECT * FROM Book 
INNER JOIN BookAuthor
    ON Book.Book_ID = (SELECT MAX(Book_ID) FROM Book)
    AND BookAuthor.Book_ID = Book.Book_ID
INNER JOIN Author
    ON BookAuthor.Author_ID = Author.Author_ID;

-- View the Author table to check the new authors
SELECT * FROM Author;

-- Check the BookAuthor relationship table
SELECT * FROM BookAuthor;

-- Cleanup: Remove the newly added book
EXEC proc_RemoveBook 117;

-- The authors will remain in the database after the book is removed
DELETE FROM Author WHERE Author_ID > 77