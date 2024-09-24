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
        /// <summary>
        /// Creates a new book instance with the provided details, ensuring validation on the ISBN, title, and other parameters.
        /// </summary>
        /// <param name="title">The title of the book. Cannot be null or whitespace.</param>
        /// <param name="isbn">The ISBN of the book. Must be a valid 13-character string containing only digits.</param>
        /// <param name="genre">The genre of the book. Cannot be null or empty.</param>
        /// <param name="publishYear">The year the book was published. Must be a valid year within a reasonable range (e.g., 1450 to current year).</param>
        /// <param name="authors">The primary authors of the book. Cannot be null.</param>
        /// <param name="quantity">The number of copies available. Must be a positive integer, default is 1.</param>
        /// <returns>Returns an ICreationResult containing either the successfully created IBook or validation failure details.</returns>

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
