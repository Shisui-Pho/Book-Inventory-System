using System;
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
        public bool AddBook(IBook book)
        {
            IDbTransaction trans = null;
            bool isTransactionComplete = false;
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Open)
                    _dbService.GetConnection().Close();
                //Begin a transaction
                trans = _dbService.GetConnection().BeginTransaction();
                //_dbService.GetConnection().Open();

                #region Adding the book
                string _sql = "qAddBook";
                OleDbCommand cmdAddBook = new OleDbCommand(_sql, _dbService.GetConnection());

                //Pass all book data as parameters
                cmdAddBook.Parameters.AddWithValue("@title", book.Title);
                cmdAddBook.Parameters.AddWithValue("@isbn", book.ISBN);
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
                cmdAddBook = new OleDbCommand(_sql, _dbService.GetConnection());
                int bookid = (int)cmdAddBook.ExecuteScalar();

                //Update the book id
                ((Book)book).ID = bookid;

                //Now for the author
                //First check if the author already exists
                if(book.BookAuthor.ID == default)
                {
                    //Author does not exist in the database
                    OleDbCommand cmdAddAuthor = new OleDbCommand("qAddBook", _dbService.GetConnection());
                    cmdAddAuthor.Parameters.AddWithValue("@name", book.BookAuthor.Name);
                    cmdAddAuthor.Parameters.AddWithValue("@surname", book.BookAuthor.Surname);
                    cmdAddAuthor.CommandType = CommandType.StoredProcedure;
                    _status = cmdAddAuthor.ExecuteNonQuery();

                    if(_status == 0)
                        return isTransactionComplete;//Transaction not complete

                    cmdAddAuthor = new OleDbCommand("SELECT LAST(Author_ID) FROM Author");
                    int authid = (int)cmdAddAuthor.ExecuteScalar();

                    ((Author)book.BookAuthor).ID = authid;

                    cmdAddAuthor.Dispose();
                }//end if author does not exists
                _sql = String.Format("qLinkBookAuthor", book.ID, book.BookAuthor.ID);
                OleDbCommand cmdLinkBookAuthor = new OleDbCommand(_sql, _dbService.GetConnection());
                cmdLinkBookAuthor.Parameters.AddWithValue("@bookid", book.ID);
                cmdLinkBookAuthor.Parameters.AddWithValue("@authorid", book.BookAuthor.ID);
                cmdLinkBookAuthor.CommandType = CommandType.StoredProcedure;

                _status = cmdLinkBookAuthor.ExecuteNonQuery();

                if (_status == 0)
                    return isTransactionComplete;

                //Commit changes
                trans.Commit();
                isTransactionComplete = true;

                //increase the number of books of the author
                ((Author)book.BookAuthor).NumberOfPublishedBooks += 1;

                //Dispose cotrols
                cmdAddBook.Dispose();
                cmdLinkBookAuthor.Dispose();
                return isTransactionComplete;
            }
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

        public IEnumerable<IBook> FilterBooks(string authorName = null, string genre = null, int? quantity = null)
        {
            throw new NotImplementedException();
        }//FilterBooks

        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            foreach (IBook book in LoadAllBooks())
                if (predicate(book))
                    yield return book;
        }//FilterBooks
        private List<KeyValuePair<int, int>> GetAuthorPublicationsCount(int authid = default)
        {
            List<KeyValuePair<int, int>> data = new List<KeyValuePair<int, int>>();
            try 
            { 
                string sql = "qAuthorsPublications";
                if (authid != default)
                    sql = "qAuthorPublications";
                OleDbCommand cmd = new OleDbCommand(sql, _dbService.GetConnection());
                if (authid != default)
                    cmd.Parameters.AddWithValue("@id", authid);
                cmd.CommandType = CommandType.StoredProcedure;
                OleDbDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    int id = int.Parse(rd["Author_ID"].ToString());
                    int count = int.Parse(rd["Published"].ToString());
                    data.Add((new KeyValuePair<int, int>(id, count)));
                }
            }
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
            }
            return data;
        }//GetAuthorPublicationsCount
        public IBook FindByISBN(string isbn)
        {
            IBook book = null;
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();
                //_dbService.GetConnection().Open();
                string sql = "qFindBookByISBN";
                OleDbCommand cmd = new OleDbCommand(sql, _dbService.GetConnection());
                cmd.Parameters.AddWithValue("@isbn", isbn);
                cmd.CommandType = CommandType.StoredProcedure;
                OleDbDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    Author auth = new Author(rd["Author.Author_Name"].ToString(), rd["Author.Author_Surname"].ToString());
                    auth.ID = int.Parse(rd["Author.Author_ID"].ToString());
                    auth.NumberOfPublishedBooks = GetAuthorPublicationsCount(auth.ID)[0].Value;

                    string genre = rd["Book.Genre"].ToString();
                    string title = rd["Book.Book_Title"].ToString();
                    int quantity = int.Parse(rd["Book.Quantity"].ToString());
                    int publication = int.Parse(rd["Book.PublicationYear"].ToString());
                    int bookid = int.Parse(rd["Book.Book_ID"].ToString());

                    book = new Book(isbn, title, genre, auth, publication, quantity);
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

                //First get the number of books per author
                List<KeyValuePair<int, int>> authorBooksCount = GetAuthorPublicationsCount();

                if (authorBooksCount.Count <= 0)
                    return books;

                OleDbDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {

                    Author auth = new Author(rd["Author.Author_Name"].ToString(), rd["Author.Author_Surname"].ToString());
                    auth.ID = int.Parse(rd["Author.Author_ID"].ToString());
                    auth.NumberOfPublishedBooks = authorBooksCount.Find(b => b.Key == auth.ID).Value;

                    string isbn = rd["Book.Book_ISBN"].ToString();
                    string genre = rd["Book.Genre"].ToString();
                    string title = rd["Book.Book_Title"].ToString();
                    int quantity = int.Parse(rd["Book.Quantity"].ToString());
                    int publication = int.Parse(rd["Book.PublicationYear"].ToString());

                    Book book = new Book(isbn, title, genre, auth, publication, quantity);
                    book.ID = int.Parse(rd["Book.Book_ID"].ToString());

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

        public bool RemoveBook(IBook book)
        {
            throw new NotImplementedException();
        }//RemoveBook

        public bool UpdateBook(IBook book)
        {
            IDbTransaction trans = null;
            bool isTransactionComplete = false;
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Open)
                    _dbService.GetConnection().Close();

                trans = _dbService.GetConnection().BeginTransaction();
                //_dbService.GetConnection().Open();
                //Update book details first
                string sql = "qUpdateBook";

                OleDbCommand cmd = new OleDbCommand(sql, _dbService.GetConnection());
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
                //Here check if the aurthor has been changed
                //-Need to think about this one
                trans.Commit();
            }
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex); 
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
    }//class
}//namespace