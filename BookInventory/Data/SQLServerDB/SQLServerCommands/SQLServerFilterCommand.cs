/*
 *  This file contains the class that specifies the SQL Server Filter command
 */
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using BookInventory.Utilities;
namespace BookInventory
{
    internal class SQLServerFilterCommand : IFilterBooksCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerFilterCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            //We need to load all books
            ILoadingBooksCommand cmd = new SQLServerLoadingCommand(_dbService);
            IEnumerable<IBook> books = cmd.LoadAllBooks();

            //Enumerate the books
            foreach (IBook book in books)
                if (predicate(book))
                    yield return book;
        }//FilterBooks

        public IEnumerable<IBook> FilterBooks(bool matchAllCriteria, string authorName = null, string authorSurname = null, string genre = null, string title = null)
        {
            IList<IBook> books = new List<IBook>(); 
            try
            {
                //Check if the connections is open
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                //Create the command
                SqlCommand cmd = new SqlCommand("proc_FilterBook", (SqlConnection)_dbService.GetConnection());
                cmd.CommandType = CommandType.StoredProcedure;

                //Pass the parameters
                cmd.Parameters.AddWithValue("@Book_Title ", title);
                cmd.Parameters.AddWithValue("@Genre", genre);
                cmd.Parameters.AddWithValue("@AuthorName", authorName);
                cmd.Parameters.AddWithValue("@AuthorSurname", authorSurname);
                cmd.Parameters.AddWithValue("@MustContainValues", matchAllCriteria);

                //Execute command
                SqlDataReader rd = cmd.ExecuteReader();

                //Extract rows from the reader
                books = SQLServerUtility.ReadToListOfBooks(rd);
            }
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
                books = new List<IBook>();
            }
            finally
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Close();
            }
            return books;
        }//FilterBooks
    }//class
}//namespace
