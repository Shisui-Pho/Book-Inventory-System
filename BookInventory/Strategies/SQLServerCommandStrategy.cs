/*
 *  This file contains the class that will be responsible for the creation of database objects when needed
 */
namespace BookInventory
{
    internal class SQLServerCommandStrategy : ICommandStrategy
    {
        public IAddBookCommand CreateAddBookCommand(IDatabaseService dbService)
        {
            return new SQLServerAddCommand(dbService);
        }//CreateAddBookCommand

        public IFilterBooksCommand CreateFilterBooksCommand(IDatabaseService dbService)
        {
            return new SQLServerFilterCommand(dbService);
        }//CreateFilterBooksCommand

        public ILoadingBooksCommand CreateLoadingBooksCommand(IDatabaseService dbService)
        {
            return new SQLServerLoadingCommand(dbService);
        }//CreateLoadingBooksCommand

        public IRemoveBookCommand CreateRemoveBookCommand(IDatabaseService dbService)
        {
            return new SQLServerRemoveCommand(dbService);
        }//CreateRemoveBookCommand

        public IUpdateBookCommand CreateUpdateBookCommand(IDatabaseService dbService)
        {
            return new SQLServerUpdateCommand(dbService);
        }//CreateUpdateBookCommand
    }//class
}//namespace
