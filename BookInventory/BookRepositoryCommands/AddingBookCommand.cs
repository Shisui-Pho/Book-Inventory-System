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
        public AddingBookCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
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
        private bool AddAuthors(IBook book, IDbTransaction transaction)
        {
            try
            {
                foreach (IAuthor author in book.BookAuthors)
                {
                    int _status = default;
                    OleDbCommand cmd = new OleDbCommand();
                    cmd.Connection = _dbService.GetConnection();
                    cmd.Transaction = (OleDbTransaction)transaction;

                    //Author does not exist in the database
                    if (author.ID == default)
                    {
                        //Configure command for addiing a new author
                        cmd.CommandText = "qAddAuthor";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@name", author.Name);
                        cmd.Parameters.AddWithValue("@surname", author.Surname);
                        cmd.CommandType = CommandType.StoredProcedure;
                        _status = cmd.ExecuteNonQuery(); //Add author

                        if (_status == 0)
                            return false; //If nothing was added it means that something wrong has happened

                        //Configure command for getting the author id
                        cmd.CommandText = "SELECT LAST(Author_ID) FROM Author";
                        cmd.CommandType = CommandType.Text;
                        int authid = (int)cmd.ExecuteScalar();

                        ((Author)author).ID = authid;//Set the author id
                    }
                    //Checking if the combination already exists in the database

                    string _sql = String.Format("SELECT COUNT(*) FROM BookAuthor WHERE Author_ID = {0} AND Book_ID = {1}", author.ID, book.ID);

                    //Configure command for checking if book has already been linked
                    cmd.CommandText = _sql;
                    cmd.CommandType = CommandType.Text;

                    bool exists = (int)cmd.ExecuteScalar() > 0;

                    if (exists)
                        continue; //Move to the next author if they are already linked

                    //Here we have to link the author and the book

                    //Configureing the commmand for linking the book and the author
                    cmd.CommandText = String.Format("INSERT INTO BookAuthor(Author_ID, Book_ID)VALUES({0},{1})", author.ID, book.ID); //"qLinkBookAuthor";
                    cmd.CommandType = CommandType.Text;

                    _status = cmd.ExecuteNonQuery();

                    if (_status == 0)//If nothing was added
                        return false;
                }//and foreach
                return true;
            }//end try
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
                return false;
            }//end catch
        }//AddAuthors
    }//class
}//namespace
