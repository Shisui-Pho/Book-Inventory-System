/*
 *  This file contains the Book repository class that performs all the CRUD operation using the different commands
 */

using System;
using System.Collections.Generic;
using BookInventory.Utilities;
using System.Linq;
namespace BookInventory
{
    internal class BookRepository : IBookRepository
    {
        //This are the commands that are going to be used
        //-The dbFactory will create the required commands when needed
        private readonly IDBCommandFactory _dbCommandFactory;

        //Inject all the dependencies in the contructor
        public BookRepository(IDBCommandFactory commandFactory)
        {
            _dbCommandFactory = commandFactory;
        }//ctor main
        public bool AddBook(IBook book)
        {
            //Execute the command for adding the book
            IAddBookCommand add = this._dbCommandFactory.GetAddBookCommand();
            return add?.AddBook(book) ?? false;
        }//AddBook

        public IEnumerable<IBook> FilterBooks(bool matchAllCriteria, string authorName = null, string authorSurname = null, string genre = null, string title = null)
        {
            IFilterBooksCommand filter = this._dbCommandFactory.GetFilterBooksCommand();

            return filter?.FilterBooks(matchAllCriteria, authorName, authorSurname, genre, title) ?? Enumerable.Empty<IBook>();
        }//FilterBooks

        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            IFilterBooksCommand filter = this._dbCommandFactory.GetFilterBooksCommand();
            return filter?.FilterBooks(predicate) ?? Enumerable.Empty<IBook>();
        }//FilterBooks

        public IBook FindByISBN(string isbn)
        {
            //First format the isbn string
            isbn = ISBNFormatterService.ToISBNFormat(isbn);
            ILoadingBooksCommand load = this._dbCommandFactory.GetLoadingBooksCommand();

            return load?.FindBookByISBN(isbn) ?? null;
        }//FindByISBN

        public IEnumerable<IBook> LoadAllBooks()
        {
            ILoadingBooksCommand load = this._dbCommandFactory.GetLoadingBooksCommand();
            return load?.LoadAllBooks() ?? Enumerable.Empty<IBook>();
        }//LoadAllBooks

        public bool RemoveBook(IBook book)
        {
            IRemoveBookCommand remove = this._dbCommandFactory.GetRemoveBookCommand();
            return remove?.RemoveBook(book) ?? false;
        }//RemoveBook

        public bool UpdateBook(IBook book)
        {
            IUpdateBookCommand update = _dbCommandFactory.GetUpdateBookCommand();
            return update?.UpdateBook(book) ?? false;
        }//UpdateBook
    }//class
}//namespace