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
            //We need to load all books
            return default;
        }//FilterBooks

        public IEnumerable<IBook> FilterBooks(bool matchAllCriteria, string authorName = null, string authorSurname = null, string genre = null, string title = null)
        {
            throw new NotImplementedException();
        }//FilterBooks
    }//class
}//namespace
