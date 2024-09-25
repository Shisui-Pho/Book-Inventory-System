/*
 * This file contains an interface that defines the basic structure of the Book model
 * 
 * Last Updated  : 18 Septermber 2024
 * 
 */
using System.Collections.Generic;
namespace BookInventory
{
    public interface IBook
    {
        int ID { get; }
        string Title { get; }
        string ISBN { get; }
        IEnumerable<IAuthor> BookAuthors { get; }
        string Genre { get; }
        int PublicationYear { get; }
        int Quantity { get; }
        IBook UpdateBook(IBook book);
    }//class
}//namespace
