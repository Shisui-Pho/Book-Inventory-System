/*
 * This file contains the DeleteCommand for handling the loading of books in the database
 */
using System;
using System.Data;
using System.Data.OleDb;

namespace BookInventory
{
    internal class RemoveBookCommand
    {
        private readonly IDatabaseService _dbService;
        public RemoveBookCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }
        public bool RemoveBook(IBook book)
        {
            OleDbTransaction trans = null;
            if (book == null || book.ID == default)
                return false;
            bool isTransactionComplete = false;
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                trans = _dbService.GetConnection().BeginTransaction();

                OleDbCommand cmd = new OleDbCommand();
                cmd.Connection = _dbService.GetConnection();
                cmd.Transaction = trans;
                cmd.CommandText = "qDeleteBookAuthor";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@bookid", book.ID);

                //Remove the link between book and author
                _ = cmd.ExecuteNonQuery();

                cmd.CommandText = "qDeleteBook";

                //Remove the book
                _ = cmd.ExecuteNonQuery();

                //Commit the chages
                trans.Commit();
                isTransactionComplete = true;
            }
            catch
            (Exception ex)
            {
                //Log error
                ExceptionLogger.GetLogger().LogError(ex);
            }
            finally
            {
                if (trans != null)
                {
                    if (isTransactionComplete)
                        trans.Commit();
                    else
                        trans.Rollback();
                    trans.Dispose();
                }//end 
                _dbService.GetConnection().Close();
            }//end finally

            return isTransactionComplete;
        }//RemoveBook

    }//class
}//namespace
