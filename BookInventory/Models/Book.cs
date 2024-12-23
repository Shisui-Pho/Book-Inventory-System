﻿/*
 * This file contains the concrete implementation of the IBook interface
 * 
 * Last Updated  : 18 Septermber 2024
 */
using System.Collections.Generic;

namespace BookInventory
{
    internal class Book : IBook
    {
        public int ID { get; internal set; }

        public string ISBN { get; private set; }
        public string Title { get; private set; }

        public string Genre { get; private set; }

        public int Quantity { get; private set; }

        public int PublicationYear { get; private set; }

        public IEnumerable<IAuthor> BookAuthors { get; internal set; }
        public Book(string isbn, string title, string genre, IEnumerable<IAuthor> authors, int publicationYear, int quantity = 1)
        {
            this.ISBN = isbn;
            this.Title = title;
            this.BookAuthors = authors;
            this.Genre = genre;
            this.Quantity = quantity;
            this.PublicationYear = publicationYear;
        }//ctor main
        public IBook UpdateBook(IBook book)
        {
            if (book is null)
                return default(IBook);

            //Updating the book properties
            //-Note that we do not change the Book_ID since the 
            this.Title = book.Title;
            this.ISBN = book.ISBN;
            this.BookAuthors = book.BookAuthors;
            this.Genre = book.Genre;
            this.Quantity = book.Quantity;

            //Return the current instance
            return this;
        }//UpdateBook
    }//class
}//namepace
