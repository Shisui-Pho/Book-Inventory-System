/*
 *  This file contains the class that specifies the SQL Server Remove command
 */
using System;

namespace BookInventory
{
    internal class SQLServerRemoveCommand : IRemoveBookCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerRemoveCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public bool RemoveBook(IBook book)
        {
            throw new NotImplementedException();
        }//RemoveBook
    }//class
}//namespace
