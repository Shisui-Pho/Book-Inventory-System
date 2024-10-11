CREATE PROCEDURE pro_RemoveBook
                 @BookID        INT
AS
BEGIN
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
