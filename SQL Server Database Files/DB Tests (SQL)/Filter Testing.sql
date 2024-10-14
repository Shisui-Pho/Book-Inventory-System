-- =====================================================================
-- EXECUTING PROCEDURE: proc_FilterBook
-- 
-- Description:
--     The following calls demonstrate how to use the `proc_FilterBook`
--     stored procedure to filter books based on various criteria. The
--     `MustContainValues` parameter determines whether all criteria must
--     be met (1) or if any can be met (0).
-- =====================================================================

-- Call the stored procedure for MustContainValues = 0
-- This call filters books with the title 'Some random book' in the 
-- 'Action' genre. No filters are applied for author name and surname.
EXEC proc_FilterBook 
    @Book_Title = 'Some random book',
    @Genre = 'Action',
    @AuthorName = NULL,      -- No filter on author name
    @AuthorSurname = NULL,   -- No filter on author surname
    @MustContainValues = 0;

-- Call the stored procedure for MustContainValues = 1
-- This call filters books with the exact title 'Beast Quest: Koldo - 
-- The arctic warrior', genre 'Fiction', author name 'Adam', and 
-- author surname 'Blade'. All criteria must be met.
EXEC proc_FilterBook 
    @Book_Title = 'Beast Quest: Koldo - The arctic warrior',
    @Genre = 'Fiction',
    @AuthorName = 'Adam',
    @AuthorSurname = 'Blade',
    @MustContainValues = 1;

-- Additional calls demonstrating different filtering conditions:

-- Call for MustContainValues = 0, no filters on genre or author.
EXEC proc_FilterBook 
    @Book_Title = 'Some random book',
    @Genre = NULL,
    @AuthorName = NULL,
    @AuthorSurname = NULL,
    @MustContainValues = 0;

-- Call for MustContainValues = 0, filtering only by genre 'Action'.
EXEC proc_FilterBook 
    @Book_Title = NULL,
    @Genre = 'Action',
    @AuthorName = NULL,
    @AuthorSurname = NULL,
    @MustContainValues = 0;

-- Call for MustContainValues = 0, filtering only by author name 'Adam'.
EXEC proc_FilterBook 
    @Book_Title = NULL,
    @Genre = NULL,
    @AuthorName = 'Adam',
    @AuthorSurname = NULL,
    @MustContainValues = 0;

-- Call for MustContainValues = 0, filtering only by author surname 'Blade'.
EXEC proc_FilterBook 
    @Book_Title = NULL,
    @Genre = NULL,
    @AuthorName = NULL,
    @AuthorSurname = 'Blade',
    @MustContainValues = 0;

-- Call for MustContainValues = 1, filtering by title, genre, author name, 
-- and surname, all criteria must be met.
EXEC proc_FilterBook 
    @Book_Title = 'Beast Quest: Koldo - The arctic warrior',
    @Genre = 'Fiction',
    @AuthorName = 'Adam',
    @AuthorSurname = 'Blade',
    @MustContainValues = 1;

-- Call for MustContainValues = 1, filtering by title 'An Atmosphere of 
-- Eternity: Stories of India' and genre 'Fiction', all criteria must be met.
EXEC proc_FilterBook 
    @Book_Title = 'An Atmosphere of Eternity: Stories of India',
    @Genre = 'Fiction',
    @AuthorName = NULL,
    @AuthorSurname = NULL,
    @MustContainValues = 1;

-- Call for MustContainValues = 1, filtering by title 'Some random book' 
-- and author name 'Mark P. O.', all criteria must be met.
EXEC proc_FilterBook 
    @Book_Title = 'Some random book',
    @Genre = NULL,
    @AuthorName = 'Mark P. O.',
    @AuthorSurname = NULL,
    @MustContainValues = 1;

-- Call for MustContainValues = 1, filtering by genre 'Fiction' and 
-- author surname 'Tan', all criteria must be met.
EXEC proc_FilterBook 
    @Book_Title = NULL,
    @Genre = 'Fiction',
    @AuthorName = NULL,
    @AuthorSurname = 'Tan',
    @MustContainValues = 1;

-- Call for MustContainValues = 1, filtering by title 'Beast Quest: 
-- Vermok the Spiteful Scavenger' and author surname 'Blade', all 
-- criteria must be met.
EXEC proc_FilterBook 
    @Book_Title = 'Beast Quest: Vermok the Spiteful Scavenger',
    @Genre = NULL,
    @AuthorName = NULL,
    @AuthorSurname = 'Blade',
    @MustContainValues = 1;

-- Final call for MustContainValues = 0, no filters applied; 
-- this should return all records.
EXEC proc_FilterBook 
    @Book_Title = NULL,
    @Genre = NULL,
    @AuthorName = NULL,
    @AuthorSurname = NULL,
    @MustContainValues = 0;
