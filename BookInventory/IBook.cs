﻿/*
 * This file contains an interface that defines the basic structure of the Book model
 */
namespace BookInventory
{
    public interface IBook
    {
        int ID { get; }
        string Tittle { get; }
        string ISBN { get; }
        IAuthor BookAuthor { get; }
        string Genre { get; }
    }//class
}//namespace
