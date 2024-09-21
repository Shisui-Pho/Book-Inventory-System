using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
namespace BookInventory
{
    internal delegate IEnumerable<IAuthor> delLoadAuthors(int bookid);
    internal delegate bool delAddAuthors(IBook book, IDbTransaction trans);
    public class BookRepository : IBookRepository
    {
        private readonly IDatabaseService _dbService;

        public BookRepository(IDatabaseService service)
        {
            this._dbService = service;
        }
        public bool AddBook(IBook book)
        {
            AddingBookCommand cmd = new AddingBookCommand(_dbService, AddAuthors);//Create the command
            return cmd.AddBook(book);//Add the book
        }//AddBook
        
        public IEnumerable<IBook> FilterBooks(string authorName = null, string genre = null, string title = null, int? release = null)
        {
            FilterBooksCommand cmd = new FilterBooksCommand(_dbService, GetAuthors);//Create the command
            return cmd.FilterBooks(authorName, genre, title, release);
        }//FilterBooks
        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            FilterBooksCommand cmd = new FilterBooksCommand(_dbService, GetAuthors);//Create the command
            return cmd.FilterBooks(predicate);
        }//FilterBooks
        public IBook FindByISBN(string isbn)
        {
            LoadingBooksCommand cmd = new LoadingBooksCommand(_dbService, GetAuthors);
            return cmd.FindByISBN(isbn);
        }//FindByISBN
        public IEnumerable<IBook> LoadAllBooks()
        {
            LoadingBooksCommand cmd = new LoadingBooksCommand(_dbService, GetAuthors);
            return cmd.LoadAllBooks();
        }//LoadAllBooks
        public bool UpdateBook(IBook book)
        {
            UpdateBookCommand cmd = new UpdateBookCommand(_dbService, AddAuthors);
            return cmd.UpdateBook(book);
        }//UpdateBook
        public bool RemoveBook(IBook book)
        {
            RemoveBookCommand cmd = new RemoveBookCommand(_dbService);
            return cmd.RemoveBook(book);
        }//RemoveBook

        #region Delegate helper methods
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

        #endregion Delegate helper methods
    }//class
}//namespace