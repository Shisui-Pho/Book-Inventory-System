﻿/*
 * This file contains the UpdateCommand for handling the loading of books in the database
 */
using System;
using System.Data;
using System.Data.OleDb;

namespace BookInventory
{
    internal class AccessUpdateCommand : IUpdateBookCommand
    {
        private readonly IDatabaseService _dbService;

        public AccessUpdateCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//CTOR 
        public bool UpdateBook(IBook book)
        {
            //Create the author's repository for updating authors
            AccessAuthorRepository authorsRepository = new AccessAuthorRepository(_dbService);

            IDbTransaction trans = null;
            bool isTransactionComplete = false;
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                trans = _dbService.GetConnection().BeginTransaction();

                //Update book details first
                string sql = "qUpdateBook";

                OleDbCommand cmd = new OleDbCommand(sql, (OleDbConnection)_dbService.GetConnection(), (OleDbTransaction)trans);
                cmd.Parameters.AddWithValue("@title", book.Title);
                cmd.Parameters.AddWithValue("@genre", book.Genre);
                cmd.Parameters.AddWithValue("@isbn", book.ISBN);
                cmd.Parameters.AddWithValue("@quantity", book.Quantity);
                cmd.Parameters.AddWithValue("@publication", book.PublicationYear);
                cmd.Parameters.AddWithValue("@bookid", book.ID);
                cmd.CommandType = CommandType.StoredProcedure;
                int status = cmd.ExecuteNonQuery();

                if (status == 0)
                    return isTransactionComplete;
                //Also check the authors
                isTransactionComplete = authorsRepository.AddAuthors(book, trans);

                if (isTransactionComplete)
                    trans.Commit();
            }
            catch
            (Exception ex)
            {
                _ = ExceptionLogger.GetLogger().LogError(ex);
                return false;
            }
            finally
            {
                if (trans != null)
                {
                    if (!isTransactionComplete)
                        trans.Rollback();

                    trans.Dispose();
                }//end if

                _dbService.GetConnection().Close();
            }//end finally

            return isTransactionComplete;
        }//UpdateBook
    }//class
}//namespace