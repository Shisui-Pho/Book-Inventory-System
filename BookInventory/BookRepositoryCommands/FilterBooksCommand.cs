/*
 * This file contains the Filter Command class that will handle a filter that are happening
 */

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;

namespace BookInventory
{
    internal class FilterBooksCommand
    {
        private readonly IDatabaseService _dbService;

        //-The GetAuthors Method sits in the BookRepository class
        private readonly delLoadAuthors GetAuthors;
        public FilterBooksCommand(IDatabaseService dbService, delLoadAuthors getAuthors)
        {
            this._dbService = dbService;
            this.GetAuthors = getAuthors;
        }//ctor main

        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            LoadingBooksCommand cmd = new LoadingBooksCommand(_dbService, GetAuthors);
            foreach (IBook book in cmd.LoadAllBooks())
                if (predicate(book))
                    yield return book;
        }//FilterBooks
        public IEnumerable<IBook> FilterBooks(string authorName, string genre, string title , int? release)
        {
            List<IBook> books = new List<IBook>();
            string _sql = BuildSql(authorName, genre, title, release);
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                OleDbCommand cmd = new OleDbCommand(_sql, _dbService.GetConnection());
                OleDbDataReader rd = cmd.ExecuteReader();//Read the filtered data

                while (rd.Read())
                {
                    int bookid = int.Parse(rd["Book_ID"].ToString());
                    string isbn = rd["Book_ISBN"].ToString();
                    genre = rd["Genre"].ToString();
                    title = rd["Book_Title"].ToString();
                    int quantity = int.Parse(rd["Quantity"].ToString());
                    int publication = int.Parse(rd["PublicationYear"].ToString());

                    //Get the book authors
                    IEnumerable<IAuthor> authors = GetAuthors(bookid);

                    #warning Still need to deal with invalid input/data
                    //For now we assume that the data retrieved from the database is valid
                    //-Of course this may not be always the case
                    //-For instance, an "Database Admin" may manually change the data from the database itself

                    ICreationResult<IBook> result = BookFactory.CreateBook(title, isbn, genre, publication, authors, quantity);
                    Book book = (Book)result.Item;

                    book.ID = bookid;

                    books.Add(book);
                }
            }//end try
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
            }
            finally
            {
                _dbService.GetConnection().Close();
            }
            return books;
        }//FilterBooks
        private string BuildSql(string authorName, string genre, string title, int? release)
        {
            string sql_ = " SELECT Book.Book_ID, Book.Book_Title, Book.Book_ISBN, Book.PublicationYear, Book.Genre, Book.Quantity" +
                          " FROM ( Book INNER JOIN BookAuthor ON Book.Book_ID =  BookAuthor.Book_ID)" +
                          " INNER JOIN Author ON BookAuthor.Author_ID = Author.Author_ID ";

            //A queue for the query commands
            Queue<string> qCriteria = new Queue<string>();
            if (!String.IsNullOrEmpty(authorName))
                qCriteria.Enqueue(String.Format(" (Author.Author_Name LIKE '*{0}*' OR Author.Author_Surname LIKE '*{0}*')", authorName));
            if (!String.IsNullOrEmpty(genre))
                qCriteria.Enqueue(String.Format(" Book.Genre LIKE \'*{0}*\'", genre));
            if (!String.IsNullOrEmpty(title))
                qCriteria.Enqueue(String.Format(" Book.Book_Title LIKE \'*{0}*\'", title));
            if (release.HasValue)
                qCriteria.Enqueue(String.Format(" Book.PublicationYear = {0} ", release));

            bool isFirstCondition = true;
            while (qCriteria.Count > 0)
            {
                if (isFirstCondition)
                {
                    sql_ += " WHERE " + qCriteria.Dequeue();
                    isFirstCondition = false;
                }
                else
                    sql_ += " AND " + qCriteria.Dequeue();
            }//end while
            return sql_;
        }//Build Sql method
    }//class
}//namespace
