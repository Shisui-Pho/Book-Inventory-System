CREATE PROCEDURE Proc_AddNewBook 
                --Book Properties
                 @Book_Title        NVARCHAR(200),
                 @Book_ISBN         VARCHAR(20),
                 @Publication       SMALLINT,
                 @Quantity          TINYINT,
                 @Genre             NVARCHAR(50),
                 @BookID            INT OUTPUT, --Return the ID number of the Book as output
                -- The Author Information will come as one parameter with fields seperated by commas and the records by semi-colons
                @AuthorsDetails     VARCHAR(MAX)
AS 
BEGIN
    SELECT * FROM Book;

END;