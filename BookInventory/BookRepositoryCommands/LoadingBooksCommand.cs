/*
 * This file contains the LoadingCommand for handling the loading of books in the database
 */
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;

namespace BookInventory
{
    internal class LoadingBooksCommand
    {
        private readonly IDatabaseService _dbService;
        private readonly delLoadAuthors GetAuthors;
        public LoadingBooksCommand(IDatabaseService databaseService, delLoadAuthors getAuthors)
        {
            this._dbService = databaseService;
            this.GetAuthors = getAuthors;
        }//ctor main

        public IEnumerable<IBook> LoadAllBooks()
        {
            List<IBook> books = new List<IBook>();
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                string sql = "qBookDetails";
                OleDbCommand cmd = new OleDbCommand(sql, _dbService.GetConnection());
                cmd.CommandType = CommandType.StoredProcedure;

                OleDbDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    int bookid = int.Parse(rd["Book_ID"].ToString());
                    string isbn = rd["Book_ISBN"].ToString();
                    string genre = rd["Genre"].ToString();
                    string title = rd["Book_Title"].ToString();
                    int quantity = int.Parse(rd["Quantity"].ToString());
                    int publication = int.Parse(rd["PublicationYear"].ToString());

                    //Get the book authors
                    IEnumerable<IAuthor> authors = GetAuthors(bookid);

                    Book book = new Book(isbn, title, genre, authors, publication, quantity);
                    book.ID = bookid;

                    books.Add(book);
                }//end while
            }
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
                return new List<IBook>();
            }
            finally
            {
                _dbService.GetConnection().Close();
            }
            return books;
        }//LoadAllBooks
        public IBook FindByISBN(string isbn)
        {
            IBook book = null;
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();
                //_dbService.GetConnection().Open();
                string sql = "qGetBookByISBN";
                OleDbCommand cmd = new OleDbCommand(sql, _dbService.GetConnection());
                cmd.Parameters.AddWithValue("@isbn", isbn);
                cmd.CommandType = CommandType.StoredProcedure;
                OleDbDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    string genre = rd["Genre"].ToString();
                    string title = rd["Book_Title"].ToString();
                    int quantity = int.Parse(rd["Quantity"].ToString());
                    int publication = int.Parse(rd["PublicationYear"].ToString());
                    int bookid = int.Parse(rd["Book_ID"].ToString());

                    //Get the book authors and their information
                    IEnumerable<IAuthor> authors = GetAuthors(bookid);

                    book = new Book(isbn, title, genre, authors, publication, quantity);
                    ((Book)book).ID = bookid;
                    break;//Only return the first instance of the book
                }
            }
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
            }
            finally
            {
                _dbService.GetConnection().Close();
            }

            return book;
        }//FindByISBN
    }//class
}//namespace
