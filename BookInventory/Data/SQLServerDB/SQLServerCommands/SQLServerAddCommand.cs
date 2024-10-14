/*
 *  This file contains the class that specifies the SQL Server Add command
 */
using System;
using System.Data;
using System.Data.SqlClient;
using BookInventory.Utilities;
namespace BookInventory
{
    internal class SQLServerAddCommand : IAddBookCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerAddCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public bool AddBook(IBook book)
        {
            try
            {
                //First check if the connection is open or closed
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                //Create a command tha will use the stored procedure for adding a new book
                SqlCommand cmd = new SqlCommand("proc_AddBook", (SqlConnection)_dbService.GetConnection());
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
                cmd.Parameters.AddWithValue("@Authors", SQLServerAuthorsToString.ToAuthorsString(book.BookAuthors));//Pass the formatted author string

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
            catch (Exception ex) { ExceptionLogger.GetLogger().LogError(ex); return false; }
            finally
            {
                if (_dbService.GetConnection().State == ConnectionState.Open)
                    _dbService.GetConnection().Close();
            }//end finnally
        }//AddBook
    }//class
}//namespace
