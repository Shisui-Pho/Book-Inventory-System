﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
namespace BookInventory
{
    public class BookRepository : IBookRepository
    {
        private readonly IDatabaseService _dbService;

        public BookRepository(IDatabaseService service)
        {
            this._dbService = service;
        }
        #region Completed Methods
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
        public IEnumerable<IBook> FilterBooks(string authorName = null, string genre = null, string title = null, int? release = null)
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

                    Book book = new Book(isbn, title, genre, authors, publication, quantity);
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
            while(qCriteria.Count > 0)
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
        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            foreach (IBook book in LoadAllBooks())
                if (predicate(book))
                    yield return book;
        }//FilterBooks
        private IEnumerable<IAuthor> GetAuthors(int bookid)
        {
            IList<IAuthor> authors = new List<IAuthor>();

            try
            {
                //The connection is already open here
                string sql = "qAuthorsInformationPerBook";

                OleDbCommand cmd = new OleDbCommand(sql, _dbService.GetConnection());
                cmd.Parameters.AddWithValue("@bookid", bookid);
                cmd.CommandType = CommandType.StoredProcedure;
                OleDbDataReader rd = cmd.ExecuteReader();
                while (rd.Read())
                {
                    string name = rd["Author_Name"].ToString();
                    string surname = rd["Author_Surname"].ToString();
                    int publication = int.Parse(rd["Publications"].ToString());
                    int authID = int.Parse(rd["Author_ID"].ToString());

                    Author auth = new Author(name, surname, publication);
                    auth.ID = authID;

                    authors.Add(auth);
                }//end while
            }//end try
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
            }
            return authors;
        }
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
        public bool UpdateBook(IBook book)
        {
            IDbTransaction trans = null;
            bool isTransactionComplete = false;
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                trans = _dbService.GetConnection().BeginTransaction();

                //Update book details first
                string sql = "qUpdateBook";

                OleDbCommand cmd = new OleDbCommand(sql, _dbService.GetConnection(), (OleDbTransaction)trans);
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
                isTransactionComplete = AddAuthors(book, trans);

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
                    if (isTransactionComplete)
                        trans.Commit();
                    else
                        trans.Rollback();

                    trans.Dispose();
                }//end if

                _dbService.GetConnection().Close();
            }//end finally

            return isTransactionComplete;
        }//UpdateBook
        #endregion Completed Methods
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
                if(trans != null)
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