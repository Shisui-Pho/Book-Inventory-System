ALTER PROCEDURE pro_RemoveBook
                 @BookID        INT
AS
BEGIN
    -- =====================================================================
    -- Procedure Name: pro_RemoveBook
    -- Description: Removes a book from the `Book` table based on the 
    --              provided `BookID`. It also removes the associated 
    --              book-author relationships from the `BookAuthor` table.
    -- 
    -- Logic:
    --    - Check if the book exists in the `Book` table using the provided 
    --      `BookID`. If it exists, proceed with deletion.
    --    - First, delete the corresponding entries from the `BookAuthor` 
    --      table to maintain referential integrity.
    --    - Then, delete the book itself from the `Book` table.
    --    - The procedure uses a transaction to ensure atomicity. If any 
    --      error occurs, the transaction is rolled back and the procedure 
    --      returns `-1`.
    --    - If the deletions are successful, the transaction is committed 
    --      and the procedure returns `1`.
    --
    -- Parameters:
    --    @BookID (INT): The ID of the book to be removed.
    --
    -- Return Values:
    --    - Returns 1 if the operation is successful.
    --    - Returns -1 if an error occurs during the operation.
    --
    -- Example Call:
    --    DECLARE @Result INT;
    --    EXEC @Result = pro_RemoveBook @BookID = 123;
    --
    --    IF @Result = 1
    --        PRINT 'Book successfully removed.';
    --    ELSE
    --        PRINT 'Failed to remove the book.';
    -- =====================================================================

    -- Start a database transaction
    BEGIN TRANSACTION 

    -- First, check if the book exists in the Book table using the provided BookID
    IF EXISTS (SELECT Book_ID FROM Book WHERE Book.Book_ID = @BookID)
    BEGIN
        -- If the book exists, delete its relationships in the BookAuthor table
        DELETE FROM BookAuthor
        WHERE Book_ID = @BookID;

        -- Check if an error occurred during the deletion in the BookAuthor table
        IF @@ERROR <> 0
        BEGIN
            -- If an error occurred, roll back the transaction and return -1 to indicate failure
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- After successfully removing the relationships, delete the book itself from the Book table
        DELETE FROM Book
        WHERE Book_ID = @BookID;

        -- Check if an error occurred during the deletion in the Book table
        IF @@ERROR <> 0
        BEGIN
            -- If an error occurred, roll back the transaction and return -1 to indicate failure
            ROLLBACK TRANSACTION;
            RETURN -1;
        END
    END

    -- Commit the transaction if everything executed successfully
    COMMIT TRANSACTION

    -- Return 1 to indicate that the removal operation was successful
    RETURN 1;
END
