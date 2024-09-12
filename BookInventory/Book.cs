/*
 * This file contains the concrete implementation of the IBook interface
 */
namespace BookInventory
{
    public class Book : IBook
    {
        public int ID { get; internal set; }

        public string ISBN { get; private set; }
        public string Title { get; private set; }
        public IAuthor BookAuthor { get; private set; }

        public string Genre { get; private set; }

        public int Quantity { get; private set; }

        public int PublicationYear { get; private set; }

        public Book(string isbn, string title, string genre, IAuthor author, int publicationYear,int quantity = 1)
        {
            this.ISBN = isbn;
            this.Title = title;
            this.BookAuthor = author;
            this.Genre = genre;
            this.Quantity = quantity;
            this.PublicationYear = publicationYear;
        }//ctor 
        public IBook UpdateBook(IBook book)
        {
            this.Title = book.Title;
            this.ISBN = book.ISBN;
            this.BookAuthor = book.BookAuthor;
            this.Genre = book.Genre;
            this.Quantity = book.Quantity;
            return this;
        }//UpdateBook
    }//class
}//namepace
