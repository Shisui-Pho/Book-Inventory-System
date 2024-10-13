ALTER PROCEDURE proc_AddUpdateAuthor
    @AuthorName         NVARCHAR(100), 
    @AuthorSurname      NVARCHAR(100),
    @DOB                DATE,
    @AuthorID           INT OUTPUT
AS 
BEGIN
    -- =====================================================================
    -- Procedure Name: proc_AddUpdateAuthor
    -- Description: This procedure checks if an author exists in the database. 
    --              If the author exists, it updates their details; if not, 
    --              it creates a new author record. The AuthorID is returned 
    --              as an output parameter.
    --
    -- Parameters:
    --     @AuthorName (NVARCHAR(100)): The name of the author.
    --     @AuthorSurname (NVARCHAR(100)): The surname of the author.
    --     @AuthorID (INT OUTPUT): The ID of the author. If the author exists, 
    --                              it remains the same; otherwise, it is 
    --                              set to the new author's ID.
    --     @DOB (DATE) : The date of birth of the author. The format should be 'dd/mm/yyyy'
    --
    -- Return Values:
    -- Return -1 for any caught errors
    --     1: Operation completed successfully.
    --
    -- Example Call: 
    --     DECLARE @AuthorID INT;
    --     EXEC proc_AddUpdateAuthor @AuthorName = N'John', 
    --                                @AuthorSurname = N'Doe', 
    --                                @AuthorID = @AuthorID OUTPUT,
    --                                @DOB      = '22/03/202454'          (This is in the format : dd/mm/yyyy)
    -- =====================================================================
    BEGIN TRY
        -- Check if the author exists
        IF EXISTS (SELECT * FROM Author WHERE Author_ID = @AuthorID)
        BEGIN
            -- Author exists, update the author's details
            UPDATE Author
            SET Author_Name = @AuthorName,
                Author_Surname = @AuthorSurname, 
                DOB = @DOB
            WHERE Author_ID = @AuthorID;

            -- Check if the update was successful
            IF @@ROWCOUNT = 0 
            BEGIN
                RETURN -1;  -- Return -1 for update failure
            END
        END
        ELSE
        BEGIN
            -- Author does not exist, insert a new author
            INSERT INTO Author(Author_Name, Author_Surname, DOB)
            VALUES(@AuthorName, @AuthorSurname, @DOB);

            -- Retrieve the new AuthorID
            SET @AuthorID = SCOPE_IDENTITY();  
        END;

        -- Return 1 for successful operation
        RETURN 1;
    END TRY
    BEGIN CATCH
        -- Handle errors that occur during the execution of SQL statements.
        -- Note: Some errors, such as syntax errors or permission issues, 
        -- may not be caught by TRY...CATCH.

        RETURN -1;  -- Return -1 for any caught errors
    END CATCH
END;
