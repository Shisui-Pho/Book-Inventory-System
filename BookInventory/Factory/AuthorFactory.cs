/*
 * This file contains the class that will handle the author creation and handle the validation
 */
using System;

namespace BookInventory
{
    public class AuthorFactory
    {
        /// <summary>
        /// Creates an instance of ICreationResult<IAuthor> with validation for name and surname.
        /// </summary>
        /// <param name="name">The first name of the author.</param>
        /// <param name="surname">The surname of the author.</param>
        /// <returns>ICreationResult containing either the created author or an error message.</returns>
        public static ICreationResult<IAuthor> CreateAuthor(string name, string surname, DateTime dob = default)
        {
            // Validate name
            if (string.IsNullOrWhiteSpace(name))
                return new CreationResult<IAuthor>("Author's name cannot be empty or whitespace.", null, false);

            // Validate surname
            if (string.IsNullOrWhiteSpace(surname))
                return new CreationResult<IAuthor>("Author's surname cannot be empty or whitespace.", null, false);

            // Create the author
            IAuthor author = new Author(name, surname, dob);
            
            return new CreationResult<IAuthor>("Author created successfully.", author, true);
        }//namespace
        /// <summary>
        /// Creates an instance of ICreationResult&lt;IAuthor&gt; with validation for name, surname, and number of published books.
        /// </summary>
        /// <param name="name">The first name of the author. Cannot be null or whitespace.</param>
        /// <param name="surname">The surname of the author. Cannot be null or whitespace.</param>
        /// <param name="numberOfPublication">The number of books published by the author. Must be a non-negative integer.</param>
        /// <returns>
        /// An ICreationResult containing either the created author or an error message.
        /// </returns>
        internal static ICreationResult<IAuthor> CreateAuthor(string name, string surname, int numberOfPublication, DateTime dob = default)
        {
            ICreationResult<IAuthor> result = CreateAuthor(name, surname, dob);
            if (result.CreationSuccessful)
                ((Author)result.Item).NumberOfPublishedBooks = numberOfPublication;

            return result;
        }//CreateAuthor
    }//class
}//namespace