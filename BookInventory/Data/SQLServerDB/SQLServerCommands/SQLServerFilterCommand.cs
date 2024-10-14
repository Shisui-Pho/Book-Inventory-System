/*
 *  This file contains the class that specifies the SQL Server Filter command
 */
using System;
using System.Collections.Generic;

namespace BookInventory
{
    internal class SQLServerFilterCommand : IFilterBooksCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerFilterCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            throw new NotImplementedException();
        }//FilterBooks

        public IEnumerable<IBook> FilterBooks(string authorName, string genre, string title, int? release)
        {
            throw new NotImplementedException();
        }//FilterBooks
    }//class
}//namespace
