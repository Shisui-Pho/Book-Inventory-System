/*
 *  This file containes the book repository class used for the SQL Server database engine to perform CRUD Operation
 */
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
namespace BookInventory
{
    internal class SQLServerBookRepository : IBookRepository
    {
        private readonly IDatabaseService _service;
        public SQLServerBookRepository(IDatabaseService service)
        {
            this._service = service;
        }
        public bool AddBook(IBook book)
        {
            try
            {
                //First check if the connection is open or closed
                if (_service.GetConnection().State == ConnectionState.Closed)
                    _service.GetConnection().Open();

                //Create a command tha will use the stored procedure for adding a new book
                SqlCommand cmd = new SqlCommand("proc_AddBook", (SqlConnection)_service.GetConnection());
                cmd.CommandType = CommandType.StoredProcedure;
                //sql out parameter for the book id
                SqlParameter BookIDOutParameter = new SqlParameter("@Book_ID", SqlDbType.Int);
                BookIDOutParameter.Direction = ParameterDirection.Output;
                //Add parameters with the values
                cmd.Parameters.AddWithValue("@Book_ISBN", book.ISBN);
                cmd.Parameters.AddWithValue("@Book_Title", book.Title);
                cmd.Parameters.AddWithValue("@Quantity", book.Quantity);
                cmd.Parameters.AddWithValue("@Publication", book.PublicationYear);
                cmd.Parameters.AddWithValue("@Genre", book.Genre);
                cmd.Parameters.Add(BookIDOutParameter);
                cmd.Parameters.AddWithValue("@Authors", ToAuthorsString(book.BookAuthors));//Pass the formatted author string

                //Execute the command
                SqlDataReader rd = cmd.ExecuteReader();

                //Check if the transaction was complete by checking the value of the Book_ID in the output parameter
                //-If Book_ID = NULL --> Then the transaction was not complete
                //      - Otherwise it was complete

                if (cmd.Parameters["@Book_ID"].Value is null)
                    return false;

                //Update the Book_ID
                ((Book)book).ID = int.Parse(cmd.Parameters["@Book_ID"].Value.ToString());

                //Here the book and the respective authors were added to the database
                //-The returned table will be of the form:
                //-  Book_ID    | Author_ID

                //NOTE:
                //- The order in which the author string was created is the order in which the ID's are created
                //- The number of records return is equal to the number of authors in the "book.BookAuthors" properties

                foreach (IAuthor author in book.BookAuthors)
                {
                    if (rd.Read())
                    {
                        //Update the author ID
                        ((Author)author).ID = int.Parse(rd["Author_ID"].ToString());
                    }//end if
                }//end foreach
                return true;
            }
            catch(Exception ex){ExceptionLogger.GetLogger().LogError(ex); return false; }
            finally
            {
                if(_service.GetConnection().State == ConnectionState.Open)
                    _service.GetConnection().Close();
            }//end finnally
        }//AddBook
        public IEnumerable<IBook> FilterBooks(string authorName = null, string genre = null, string title = null, int? release = null)
        {
            throw new NotImplementedException();
        }//FilterBooks

        public IEnumerable<IBook> FilterBooks(Predicate<IBook> predicate)
        {
            throw new NotImplementedException();
        }//FilterBooks

        public IBook FindByISBN(string isbn)
        {
            throw new NotImplementedException();
        }//FindByISBN

        public IEnumerable<IBook> LoadAllBooks()
        {
            throw new NotImplementedException();
        }//LoadAllBooks

        public bool RemoveBook(IBook book)
        {
            throw new NotImplementedException();
        }//RemoveBook

        public bool UpdateBook(IBook book)
        {
            throw new NotImplementedException();
        }//UpdateBook

        #region Helper methods
        private string ToAuthorsString(IEnumerable<IAuthor> authors)
        {
            string _sAuthors = "";

            //-Format the ID string the way that it is needed in the SQL Server database engine
            foreach (IAuthor item in authors)
                _sAuthors += item.ID + ",'" + item.Name + "','" + item.Surname + "','" + item.DOB.ToString("yyyy/MM/dd") + "';";

            return _sAuthors;
        }//ToAuthorsString

        #endregion Helper methods
    }//class
}//namespace
