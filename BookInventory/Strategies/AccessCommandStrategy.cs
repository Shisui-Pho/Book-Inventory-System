/*
 *  This file contains the class that will be responsible for the creation of database objects when needed
 */
namespace BookInventory
{
    internal class AccessCommandStrategy : ICommandStrategy
    {
        public IAddBookCommand CreateAddBookCommand(IDatabaseService dbService)
        {
            return new AccessAddCommand(dbService);
        }//CreateAddBookCommand

        public IFilterBooksCommand CreateFilterBooksCommand(IDatabaseService dbService)
        {
            return new AccessFilterCommand(dbService);
        }//CreateFilterBooksCommand

        public ILoadingBooksCommand CreateLoadingBooksCommand(IDatabaseService dbService)
        {
            return new AccessLoadCommand(dbService);
        }//CreateLoadingBooksCommand

        public IRemoveBookCommand CreateRemoveBookCommand(IDatabaseService dbService)
        {
            return new AccessRemoveCommand(dbService);
        }//CreateRemoveBookCommand

        public IUpdateBookCommand CreateUpdateBookCommand(IDatabaseService dbService)
        {
            return new AccessUpdateCommand(dbService);
        }//CreateUpdateBookCommand
    }//class
}//namespace
