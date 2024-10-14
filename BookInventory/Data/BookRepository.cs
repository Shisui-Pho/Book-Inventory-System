/*
 *  This file contains the Book repository class that performs all the CRUD operation using the different commands
 */

using System;
using System.Collections.Generic;
namespace BookInventory.Data
{
    internal class BookRepository : IBookRepository
    {
        //This are the commands that are going to be used
        //-This commands are lightweight as they only have the database service object only in them
        private readonly IAddBookCommand cmdAddBook;
        private readonly ILoadingBooks cmdBookLoading;
        private readonly IFilterBooks cmdFiltering;
        private readonly IRemoveBook cmdRemoveBook;
        private readonly IUpdateBook cmdUpdatedBook;

        //Inject all the dependencies in the contructor
        public BookRepository(IAddBookCommand cmAdd, ILoadingBooks cmLoad, IFilterBooks cmFilt, 
                              IRemoveBook cmRem, IUpdateBook cmUpd)
        {
            this.cmdAddBook = cmAdd;
            this.cmdBookLoading = cmLoad;
            this.cmdFiltering = cmFilt;
            this.cmdRemoveBook = cmRem;
            this.cmdUpdatedBook = cmUpd;
        }//ctor main
        public bool AddBook(IBook book)
        {
            //Execute the command for adding the book
            return this.cmdAddBook.AddBook(book);
        }//AddBook

        public IEnumerable<IBook> FilterBooks(string authorName = null, string genre = null, string title = null, int? release = null)
        {
            return this.cmdFiltering.FilterBooks(authorName, genre, title, release);
        }//FilterBooks

        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            return this.cmdFiltering.FilterBooks(predicate);
        }//FilterBooks

        public IBook FindByISBN(string isbn)
        {
            return this.cmdBookLoading.FindBookByISBN(isbn);
        }//FindByISBN

        public IEnumerable<IBook> LoadAllBooks()
        {
            return this.cmdBookLoading.LoadAllBooks();
        }//LoadAllBooks

        public bool RemoveBook(IBook book)
        {
            return this.cmdRemoveBook.RemoveBook(book);
        }//RemoveBook

        public bool UpdateBook(IBook book)
        {
            return this.cmdUpdatedBook.UpdateBook(book);
        }//UpdateBook
    }//class
}//namespace