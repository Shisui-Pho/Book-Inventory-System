/*
 *  This file contains all the different commnds that are used for the database CRUD operationss
 */
using System;
using System.Collections.Generic;

namespace BookInventory
{
    public interface IAddBookCommand
    {
        bool AddBook(IBook book);
    }//IAddBookCommand
    public interface IRemoveBookCommand
    {
        bool RemoveBook(IBook book);
    }//IRemoveBook
    public interface IUpdateBookCommand
    {
        bool UpdateBook(IBook book);
    }//IUpdateBook
    public interface ILoadingBooksCommand
    {
        IEnumerable<IBook> LoadAllBooks();
        IBook FindBookByISBN(string isbn);
    }//ILoadingBook
    public interface IFilterBooksCommand
    {
        IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate);
        IEnumerable<IBook> FilterBooks(string authorName, string genre, string title, int? release);
    }//IFilterBooks
}//namespace
