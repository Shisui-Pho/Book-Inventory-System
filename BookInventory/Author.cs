/*
 *  This file contains the concrete implementation of the IAuthor interface
 */
namespace BookInventory
{
    public class Author : IAuthor
    {
        public int ID { get; internal set; } = default;

        public string Name { get; private set; }

        public string Surname { get; private set; }

        public int NumberOfPublishedBooks { get; internal set; }
        public Author(string name, string surname)
        {
            this.Name = name;
            this.Surname = surname;
        }//ctor main
        internal Author(string name, string surname, int NumberOfPublishedBooks)
            : this(name, surname)
        {
            this.NumberOfPublishedBooks = NumberOfPublishedBooks;
        }//ctor 2
    }//class
}//namespace
