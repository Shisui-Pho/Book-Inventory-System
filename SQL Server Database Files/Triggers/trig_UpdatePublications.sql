CREATE TRIGGER trig_UpdatePublications
ON BookAuthor
AFTER DELETE, INSERT
AS 
BEGIN 
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