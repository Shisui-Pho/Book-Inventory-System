/*
 *  This file contains the class that specifies the SQL Server Update command
 */
using System;

namespace BookInventory
{
    internal class SQLServerUpdateCommand : IUpdateBookCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerUpdateCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public bool UpdateBook(IBook book)
        {
            throw new NotImplementedException();
        }//UpdateBook
    }//class
}//namespace
