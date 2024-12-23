﻿/*
 * This file contains the Filter Command class that will handle a filter that are happening
 */

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;

namespace BookInventory
{
    internal class AccessFilterCommand : IFilterBooksCommand
    {
        private readonly IDatabaseService _dbService;

        public AccessFilterCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main

        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            AccessLoadCommand cmd = new AccessLoadCommand(_dbService);
            foreach (IBook book in cmd.LoadAllBooks())
                if (predicate(book))
                    yield return book;
        }//FilterBooks
        public IEnumerable<IBook> FilterBooks(bool matchAllCriteria, string authorName = null, string authorSurname = null, string genre = null, string title = null)
        {
            //Create the author repository for retrieving the authors
            AccessAuthorRepository authorsRepository = new AccessAuthorRepository(_dbService);

            List<IBook> books = new List<IBook>();
            string _sql = BuildSql(matchAllCriteria,authorName,authorSurname ,genre, title);
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                OleDbCommand cmd = new OleDbCommand(_sql, (OleDbConnection)_dbService.GetConnection());
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
                    IEnumerable<IAuthor> authors = authorsRepository.GetAuthors(bookid);

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
        private string BuildSql(bool matchAllCriteria, string authorName, string authorSurname,string genre, string title)
        {
            string sql_ = " SELECT Book.Book_ID, Book.Book_Title, Book.Book_ISBN, Book.PublicationYear, Book.Genre, Book.Quantity" +
                          " FROM ( Book INNER JOIN BookAuthor ON Book.Book_ID =  BookAuthor.Book_ID)" +
                          " INNER JOIN Author ON BookAuthor.Author_ID = Author.Author_ID ";

            //A queue for the query commands
            Queue<string> qCriteria = new Queue<string>();

            //Check for the criteria for the SQL Query statement
            if (!String.IsNullOrEmpty(authorName))
                qCriteria.Enqueue(String.Format($" Author.Author_Name LIKE '*{authorName}*'"));
            if(!String.IsNullOrEmpty(authorSurname))
                qCriteria.Enqueue(String.Format($" Author.Author_Surname LIKE '*{authorSurname}*'"));
            if (!String.IsNullOrEmpty(genre))
                qCriteria.Enqueue(String.Format(" Book.Genre LIKE \'*{0}*\'", genre));
            if (!String.IsNullOrEmpty(title))
                qCriteria.Enqueue(String.Format(" Book.Book_Title LIKE \'*{0}*\'", title));

            bool isFirstCondition = true;
            while (qCriteria.Count > 0)
            {
                if (isFirstCondition)
                {
                    sql_ += " WHERE " + qCriteria.Dequeue();
                    isFirstCondition = false;
                }
                else
                    sql_ += (matchAllCriteria ? " AND " : " OR ") + qCriteria.Dequeue();
            }//end while
            return sql_;
        }//Build Sql method
    }//class
}//namespace
