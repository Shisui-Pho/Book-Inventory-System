/*
 *  This file contains the class that will be responsible for the creation of database objects when needed
 */
namespace BookInventory
{
    internal interface ICommandStrategy
    {
        IAddBookCommand CreateAddBookCommand(IDatabaseService dbService);
        IFilterBooksCommand CreateFilterBooksCommand(IDatabaseService dbService);
        ILoadingBooksCommand CreateLoadingBooksCommand(IDatabaseService dbService);
        IRemoveBookCommand CreateRemoveBookCommand(IDatabaseService dbService);
        IUpdateBookCommand CreateUpdateBookCommand(IDatabaseService dbService);
    }//ICommandStrategy
}//namespace
