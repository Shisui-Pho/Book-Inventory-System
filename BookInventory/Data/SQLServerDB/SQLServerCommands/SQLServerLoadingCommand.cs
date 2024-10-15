/*
 *  This file contains the class that specifies the SQL Server Loading command
 */
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using BookInventory.Utilities;
namespace BookInventory
{
    internal class SQLServerLoadingCommand : ILoadingBooksCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerLoadingCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public IBook FindBookByISBN(string isbn)
        {
            IBook book = null;
            try
            {
                //First check if the connection is open or closed
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                //Create a command tha will use the stored procedure for loading a new book
                SqlCommand cmd = new SqlCommand("proc_FindBookByISBN", (SqlConnection)_dbService.GetConnection());
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@@BookISBN", isbn);

                //Execute the command
                SqlDataReader rd = cmd.ExecuteReader();

                //NOTE:
                //- The procedure will return n rows where n is the number of authors,
                //      the book information will remain the same for all the authors

                IList<IBook> books = SQLServerUtility.ReadToListOfBooks(rd);
                if (books.Count > 0)
                    book = books[0];//Return the first book(though there should be only one book);
            }//namespace
            catch (Exception ex) { ExceptionLogger.GetLogger().LogError(ex); }
            finally { if (_dbService.GetConnection().State == ConnectionState.Open) _dbService.GetConnection().Close(); }
            return book;
        }//FindBookByISBN

        public IEnumerable<IBook> LoadAllBooks()
        {
            IList<IBook> books = new List<IBook>();
            try
            {
                //First check if the connection is open or closed
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                //Create the command object
                SqlCommand cmd = new SqlCommand("proc_LoadAllBooks", (SqlConnection)_dbService.GetConnection());
                cmd.CommandType = CommandType.StoredProcedure;

                //Execute the command
                SqlDataReader rd = cmd.ExecuteReader();

                //Read the values
                books = SQLServerUtility.ReadToListOfBooks(rd);
            }//end try
            catch(Exception ex) { ExceptionLogger.GetLogger().LogError(ex); books = new List<IBook>(); }
            finally { if (_dbService.GetConnection().State == ConnectionState.Open) _dbService.GetConnection().Close(); }

            return books;
        }//LoadAllBooks
    }//class
}//namespace
