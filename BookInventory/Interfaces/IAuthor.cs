/*
 * This file contains an interface that defines the basic structure of the Author model
 */
using System;
namespace BookInventory
{
    public interface IAuthor
    {
        int ID { get; }
        string Name { get; }
        string Surname { get; }
        DateTime DOB { get; }
        int NumberOfPublishedBooks { get; }
    }//class
}//namespace