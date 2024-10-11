CREATE TRIGGER trig_UpdatePublications
ON BookAuthor
AFTER DELETE, INSERT
AS 
BEGIN 
-- =====================================================================
-- Trigger Name: trig_UpdatePublications
-- Description: Automatically updates the `Publications` count in the 
--              `Author` table when a record is inserted or deleted in 
--              the `BookAuthor` table.
--
-- Trigger Event: AFTER DELETE, INSERT on `BookAuthor`
-- 
-- Logic:
--     - On INSERT: Increments the `Publications` count for the affected 
--                  authors in the `Author` table.
--     - On DELETE: Decrements the `Publications` count for the affected 
--                  authors in the `Author` table.
--
-- Behaviour:
--     - When a new book-author relationship is inserted into `BookAuthor`, 
--       the author's `Publications` count increases by 1.
--     - When a book-author relationship is deleted from `BookAuthor`, 
--       the author's `Publications` count decreases by 1.
--
-- Example Use Case:
--     When a new book is linked to an author, the `Publications` count 
--     reflects that additional publication. Similarly, if a book is unlinked 
--     or deleted, the `Publications` count decreases accordingly.
-- =====================================================================

    --Check if it was an insert
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        --This was an insert

        --UPDATE THE Author Publication
        UPDATE Author
        SET Publications = Publications + 1
        FROM (SELECT Author_ID FROM inserted) AS authrs
        WHERE Author.Author_ID = authrs.Author_ID;
    END
    ELSE
    BEGIN
        --This was a delete
                --UPDATE THE Author Publication
        UPDATE Author
        SET Publications = Publications - 1
        FROM (SELECT Author_ID FROM deleted) AS authrs
        WHERE Author.Author_ID = authrs.Author_ID;
    END
END