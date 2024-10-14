/*
 *  This file contains all the different commnds that are used for the database CRUD operationss
 */
using System;
using System.Collections.Generic;

namespace BookInventory.Data
{
    public interface IAddBookCommand
    {
        bool AddBook(IBook book);
    }//IAddBookCommand
    public interface IRemoveBook
    {
        bool RemoveBook(IBook book);
    }//IRemoveBook
    public interface IUpdateBook
    {
        bool UpdateBook(IBook book);
    }//IUpdateBook
    public interface ILoadingBooks
    {
        IEnumerable<IBook> LoadAllBooks();
        IBook FindBookByISBN(string isbn);
    }//ILoadingBook
    public interface IFilterBooks
    {
        IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate);
        IEnumerable<IBook> FilterBooks(string authorName, string genre, string title, int? release);
    }//IFilterBooks
}//namespace
