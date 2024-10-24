﻿/*
 *  This file contains the Book repository class that performs all the CRUD operation using the different commands
 */

using System;
using System.Collections.Generic;
using BookInventory.Utilities;

namespace BookInventory
{
    internal class BookRepository : IBookRepository
    {
        //This are the commands that are going to be used
        //-This commands are lightweight as they only have the database service object only in them
        private readonly IAddBookCommand cmdAddBook;
        private readonly ILoadingBooksCommand cmdBookLoading;
        private readonly IFilterBooksCommand cmdFiltering;
        private readonly IRemoveBookCommand cmdRemoveBook;
        private readonly IUpdateBookCommand cmdUpdatedBook;

        //Inject all the dependencies in the contructor
        public BookRepository(IAddBookCommand cmAdd, ILoadingBooksCommand cmLoad, IFilterBooksCommand cmFilt, 
                              IRemoveBookCommand cmRem, IUpdateBookCommand cmUpd)
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

        public IEnumerable<IBook> FilterBooks(bool matchAllCriteria, string authorName = null, string authorSurname = null, string genre = null, string title = null)
        {
            return this.cmdFiltering.FilterBooks(matchAllCriteria, authorName, authorSurname, genre, title);
        }//FilterBooks

        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            return this.cmdFiltering.FilterBooks(predicate);
        }//FilterBooks

        public IBook FindByISBN(string isbn)
        {
            //First format the isbn string
            isbn = ISBNFormatterService.ToISBNFormat(isbn);

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