/*
 *  This file contains the class that specifies the SQL Server Update command
 */
using System;
using System.Data.SqlClient;
using System.Data;
using BookInventory.Utilities;

namespace BookInventory
{
    internal class SQLServerUpdateCommand : IUpdateBookCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerUpdateCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public bool UpdateBook(IBook book)
        {
            try
            {
                //Check the connection
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                //ALTER PROCEDURE proc_UpdateBook
                // --For the book table
                //@Book_ISBN VARCHAR(20),
                //@Book_Title NVARCHAR(500),
                //@Quantity SMALLINT,
                //@Publication        SMALLINT,
                //@Genre VARCHAR(200),
                //@Book_ID INT 
                //@Authors VARCHAR(MAX)

                //Create the command object
                SqlCommand cmd = new SqlCommand("proc_UpdateBook", (SqlConnection)_dbService.GetConnection());
                cmd.CommandType = CommandType.StoredProcedure;

                //Convert List of authors to the athors string
                string authors = SQLServerUtility.ToAuthorsString(book.BookAuthors);

                //Add parameters
                cmd.Parameters.AddWithValue("@Book_ISBN", book.ISBN);
                cmd.Parameters.AddWithValue("@Book_Title", book.Title);
                cmd.Parameters.AddWithValue("@Quantity", book.Quantity);
                cmd.Parameters.AddWithValue("@Publication", book.PublicationYear);
                cmd.Parameters.AddWithValue("@Genre", book.Genre);
                cmd.Parameters.AddWithValue("@Book_ID", book.ID);
                cmd.Parameters.AddWithValue("@Authors", authors);

                //Execute command
                SqlDataReader rd = cmd.ExecuteReader();
                // Here the book and the respective authors were added to the database
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
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
                return false;
            }
        }//UpdateBook
    }//class
}//namespace
