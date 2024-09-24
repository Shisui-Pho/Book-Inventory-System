/*
 * This file contains the class that will handle the book creation and handle the validation
 */
using System;
using System.Collections.Generic;
using System.Linq;

namespace BookInventory
{
    public class BookFactory
    {
        public static ICreationResult<IBook> CreateBook(string title, string isbn, string genre, int publishYear, IEnumerable<IAuthor> authors, int quantity = 1)
        {
            // Validate title
            if (string.IsNullOrWhiteSpace(title))
                return new CreationResult<IBook>("Title cannot be empty or whitespace.", null, false);

            // Validate ISBN, we will consider all isbn format
            //-We remove all posisible valid characters that are not numbers
            isbn = isbn.Replace("-", "").Replace(" ", "");

            if (isbn.Length != 13 || !isbn.All(char.IsDigit))
                return new CreationResult<IBook>("Invalid ISBN. Must be 13 digits.", null, false);

            // Validate genre
            if (string.IsNullOrWhiteSpace(genre))
                return new CreationResult<IBook>("Genre cannot be empty or whitespace.", null, false);

            // Validate publishYear, we cannot have a published book from teh future
            int currentYear = DateTime.Now.Year;
            if (publishYear > currentYear)
                return new CreationResult<IBook>($"Publish year cannot be in the future. Current year: {currentYear}.", null, false);

            // Validate author
            if (authors == null)
                return new CreationResult<IBook>("Author is required.", null, false);

            // Validate quantity (should not be less than 1)
            if (quantity < 1)
            return new CreationResult<IBook>("Quantity must be at least 1.", null, false);

            // If all validations pass, create the book
            IBook newBook = new Book(isbn,title, genre, authors,publishYear, quantity);
            return new CreationResult<IBook>("Book created successfully.", newBook, true);
        }//CreateBook
    }//class
}//namespace
