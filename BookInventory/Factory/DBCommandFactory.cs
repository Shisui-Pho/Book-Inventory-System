/*
 *  This file contains the class that will be responsible for the creation of database objects when needed
 */
using System;
namespace BookInventory
{
    internal class DBCommandFactory : IDBCommandFactory
    {
        private readonly ICommandStrategy _commandStrategy;
        private readonly IDatabaseService _dbService;

        public DBCommandFactory(DatabaseType dbType, IDatabaseService dbService)
        {
            _dbService = dbService;
            switch(dbType)
            {
                case DatabaseType.AccessDB: _commandStrategy = new AccessCommandStrategy(); break;
                case DatabaseType.SQLServerDB:  new SQLServerCommandStrategy(); break;
                default:  throw new NotSupportedException("Database type not supported");
            };
        }//ctor main

        public IAddBookCommand GetAddBookCommand()
        {
            return _commandStrategy.CreateAddBookCommand(_dbService);
        }//GetAddBookCommand

        public IFilterBooksCommand GetFilterBooksCommand()
        {
            return _commandStrategy.CreateFilterBooksCommand(_dbService);
        }//GetFilterBooksCommand

        public ILoadingBooksCommand GetLoadingBooksCommand()
        {
            return _commandStrategy.CreateLoadingBooksCommand(_dbService);
        }//GetLoadingBooksCommand

        public IRemoveBookCommand GetRemoveBookCommand() 
        {
            return _commandStrategy.CreateRemoveBookCommand(_dbService);
        }//GetRemoveBookCommand
        public IUpdateBookCommand GetUpdateBookCommand() 
        {
            return _commandStrategy.CreateUpdateBookCommand(_dbService);
        }//GetUpdateBookCommand
    }//class
}//namespace
