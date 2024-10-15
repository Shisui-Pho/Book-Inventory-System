/*
 * This file contains a general interface of the book repository
 */
using System;
using System.Collections.Generic;
namespace BookInventory
{
    public interface IBookRepository
    {
        /// <summary>
        /// This method adds a book to the database
        /// </summary>
        /// <param name="book">The book to be added.</param>
        /// <returns>True if the book was successfully Added</returns>
        bool AddBook(IBook book);
        /// <summary>
        /// This method Removes a book from the database
        /// </summary>
        /// <param name="book">The book to be removed</param>
        /// <returns>True if the book was successfully removed</returns>
        bool RemoveBook(IBook book);
        /// <summary>
        /// Updates the book details on the database. If the ISBN of the book was not found, a new book will be created on the database.
        /// </summary>
        /// <param name="book">The book to be updated.</param>
        /// <returns>True if the book was successfully added</returns>
        bool UpdateBook(IBook book);
        /// <summary>
        /// Finds a book based on the ISBN. If the book was not found, null will be returned
        /// </summary>
        /// <param name="isbn">The isbn number of the book.</param>
        /// <returns>The book that was found.</returns>
        IBook FindByISBN(string isbn);
        /// <summary>
        /// Loads all the books in the database
        /// </summary>
        /// <returns>The collection of books.</returns>
        IEnumerable<IBook> LoadAllBooks();
        /// <summary>
        /// Filter books based on the given information. The filtering happens on the database side, the sql query is sent to the database engine
        /// </summary>
        /// <param name="authorName">The name of the author if filter requires.</param>
        /// <param name="genre">The genre of the book if filter requires.</param>
        /// <returns>The filtered books</returns>
        IEnumerable<IBook> FilterBooks(bool matchAllCriteria, string authorName = null, string authorSurname = null, string genre = null, string title = null);
        /// <summary>
        /// Filter books based on the given information. The filtering will take place inside the application, all books will be loaded from 
        ///     the database and filtered on the application.
        /// </summary>
        /// <param name="predicate">The method of filtering</param>
        /// <returns>The filtered books</returns>
        IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate);
    }//IBook
}//namespace
