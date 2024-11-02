/*
 *  This file contains the class that will be responsible for the creation of database objects when needed
 */
namespace BookInventory
{
    internal interface IDBCommandFactory
    {
        IAddBookCommand GetAddBookCommand();
        IRemoveBookCommand GetRemoveBookCommand();
        IUpdateBookCommand GetUpdateBookCommand();
        ILoadingBooksCommand GetLoadingBooksCommand();
        IFilterBooksCommand GetFilterBooksCommand();
    }//IDBCommandFactory
}//namespace
