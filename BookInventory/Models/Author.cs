/*
 *  This file contains the concrete implementation of the IAuthor interface
 */
using System;

namespace BookInventory
{
    public class Author : IAuthor
    {
        public int ID { get; internal set; } = default;

        public string Name { get; private set; }

        public string Surname { get; private set; }

        public int NumberOfPublishedBooks { get; internal set; }

        public DateTime DOB { get; private set; }

        public Author(string name, string surname, DateTime dob)
        {
            this.Name = name;
            this.Surname = surname;
            this.DOB = dob;
        }//ctor main
        internal Author(string name, string surname, int NumberOfPublishedBooks, DateTime dob)
            : this(name, surname, dob)
        {
            this.NumberOfPublishedBooks = NumberOfPublishedBooks;
        }//ctor 2
    }//class
}//namespace
