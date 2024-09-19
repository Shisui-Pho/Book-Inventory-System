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

                    string _sql = String.Format("SELECT COUNT(*) FROM BookAuthor WHERE Author_ID = \"{0}\" AND Book_ID = \"{1}\"", author.ID, book.ID);

                    //Configure command for checking if book has already been linked
                    cmd.CommandText = _sql;
                    cmd.CommandType = CommandType.Text;

                    bool exists = (int)cmd.ExecuteScalar() >= 0;

                    if (exists)
                        continue; //Move to the next author if they are already linked

                    //Here we have to link the author and the book

                    //Configureing the commmand for linking the book and the author
                    cmd.CommandText = "qLinkBookAuthor";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@bookid", book.ID);
                    cmd.Parameters.AddWithValue("@authorid", author.ID);

                    _status = cmd.ExecuteNonQuery();

                    if (_status == 0)//If nothing was added
                        return false;
                }//and foreach
                return true;
            }//end try
            catch
            {
                return false;
            }//end catch
        }//AddAuthors
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
                    string name = rd["Äuthor_Name"].ToString();
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
                string sql = "qFindBookByISBN";
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

                if(isTransactionComplete)
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
    }//class
}//namespace