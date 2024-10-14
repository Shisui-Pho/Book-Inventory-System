/*
    -- =====================================================================
    -- TEST 03: Loading All Books and Finding Books by ISBN
    -- 
    -- Description:
    --     This test retrieves all books in the database using 
    --     'proc_LoadAllBook'. It also tests finding books based on 
    --     ISBN using 'proc_FindBookByISBN'. Both existing and non-existing 
    --     ISBNs are used in this test to verify behavior in different cases.
    -- 
    -- Steps:
    --     1. Load all books in the database.
    --     2. Find books using valid ISBNs.
    --     3. Try to find a book using a non-existing ISBN and confirm the 
    --        appropriate handling of that case.
    -- 
    -- Test Data:
    --     - Existing ISBNs:
    --         - '0-060-91406-8'
    --         - '978-1-408-34814-7'
    --     - Non-existing ISBN:
    --         - '5564564564564654'
    -- 
    -- Expected Result:
    --     - All books in the database are loaded and displayed.
    --     - Books with valid ISBNs are found and loaded.
    --     - When searching for a non-existing ISBN, no results should be returned.
    -- 
    -- Example Execution:
    --     EXEC proc_LoadAllBook;
    --     EXEC proc_FindBookByISBN '0-060-91406-8';
    --     EXEC proc_FindBookByISBN '978-1-408-34814-7';
    --     EXEC proc_FindBookByISBN '5564564564564654'; -- Non-existing ISBN
    -- =====================================================================
*/

-- Load all books in the database
EXEC proc_LoadAllBook;

-- Find books with valid ISBNs
EXEC proc_FindBookByISBN '0-060-91406-8';
EXEC proc_FindBookByISBN '978-1-408-34814-7';

-- Try to find a book with a non-existing ISBN
EXEC proc_FindBookByISBN '5564564564564654';
