/*
 *  This file contains all the different commnds that are used for the database CRUD operationss
 */
using System;
using System.Collections.Generic;

namespace BookInventory
{
    internal interface IAddBookCommand
    {
        bool AddBook(IBook book);
    }//IAddBookCommand
    internal interface IRemoveBookCommand
    {
        bool RemoveBook(IBook book);
    }//IRemoveBook
    internal interface IUpdateBookCommand
    {
        bool UpdateBook(IBook book);
    }//IUpdateBook
    internal interface ILoadingBooksCommand
    {
        IEnumerable<IBook> LoadAllBooks();
        IBook FindBookByISBN(string isbn);
    }//ILoadingBook
    internal interface IFilterBooksCommand
    {
        IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate);
        IEnumerable<IBook> FilterBooks(bool matchAllCriteria, string authorName = null, string authorSurname = null, string genre = null, string title = null);
    }//IFilterBooks
}//namespace
