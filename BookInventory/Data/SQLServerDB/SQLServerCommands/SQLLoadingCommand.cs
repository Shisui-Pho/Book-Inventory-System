/*
 *  This file contains the class that specifies the SQL Server Loading command
 */
using System;
using System.Collections.Generic;

namespace BookInventory
{
    internal class SQLLoadingCommand : ILoadingBooksCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLLoadingCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public IBook FindBookByISBN(string isbn)
        {
            throw new NotImplementedException();
        }//FindBookByISBN

        public IEnumerable<IBook> LoadAllBooks()
        {
            throw new NotImplementedException();
        }//LoadAllBooks
    }//class
}//namespace
