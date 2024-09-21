/*
 * This file contains the AddBook Command class that will handle a add a new book to the database
 */
using System;
using System.Data;
using System.Data.OleDb;

namespace BookInventory
{
    internal class AddingBookCommand
    {
        private readonly IDatabaseService _dbService;
        private readonly delAddAuthors AddAuthors;
        public AddingBookCommand(IDatabaseService dbService, delAddAuthors addAuthors)
        {
            this._dbService = dbService;
            this.AddAuthors = addAuthors;
        }
        public bool AddBook(IBook book)
        {
            IDbTransaction trans = null;
            bool isTransactionComplete = false;
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();
                //Begin a transaction
                trans = _dbService.GetConnection().BeginTransaction();

                #region Adding the book
                string _sql = "qAddBook";
                OleDbCommand cmdAddBook = new OleDbCommand(_sql, _dbService.GetConnection(), (OleDbTransaction)trans);

                //Pass all book data as parameters
                cmdAddBook.Parameters.AddWithValue("@isbn", book.ISBN);
                cmdAddBook.Parameters.AddWithValue("@title", book.Title);
                cmdAddBook.Parameters.AddWithValue("@publicationYear", book.PublicationYear);
                cmdAddBook.Parameters.AddWithValue("@quantity", book.Quantity);
                cmdAddBook.Parameters.AddWithValue("@genre", book.Genre);

                //Configure the command to execute a stored procedure
                cmdAddBook.CommandType = CommandType.StoredProcedure;

                //Insert data
                int _status = cmdAddBook.ExecuteNonQuery();

                #endregion Adding the book

                //-Check if there was a change or not
                if (_status == 0)
                    return isTransactionComplete;

                //Successfuly inserted
                //-Get the ID of the book
                _sql = "SELECT LAST(Book_ID) FROM Book";
                cmdAddBook = new OleDbCommand(_sql, _dbService.GetConnection(), (OleDbTransaction)trans);
                int bookid = (int)cmdAddBook.ExecuteScalar();

                //Update the book id
                ((Book)book).ID = bookid;

                isTransactionComplete = AddAuthors(book, trans);
                if (isTransactionComplete)
                    trans.Commit();//Save the changes

                return isTransactionComplete;
            }//end try
            catch
            (Exception ex)
            {
                //Log error
                ExceptionLogger.GetLogger().LogError(ex);
                return false;
            }
            finally
            {
                if (!isTransactionComplete && trans != null)
                    trans.Rollback();

                if (trans != null)
                    trans.Dispose();
                trans?.Dispose();
                _dbService.GetConnection().Close();
            }//end finally
        }//AddBook
    }//class
}//namespace
