/*
 *  This file contains the class that specifies the SQL Server Add command
 */
using System;

namespace BookInventory
{
    internal class SQLServerAddCommand : IAddBookCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerAddCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public bool AddBook(IBook book)
        {
            throw new NotImplementedException();
        }//AddBook
    }//class
}//namespace
