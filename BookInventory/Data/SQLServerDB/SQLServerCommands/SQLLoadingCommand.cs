/*
 *  This file contains the class that specifies the SQL Server Loading command
 */
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace BookInventory
{
    internal class SQLLoadingCommand : ILoadingBooksCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLLoadingCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public IBook FindBookByISBN(string isbn)
        {
            IBook book = null;
            try
            {
                //First check if the connection is open or closed
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                //Create a command tha will use the stored procedure for loading a new book
                SqlCommand cmd = new SqlCommand("proc_FindBookByISBN", (SqlConnection)_dbService.GetConnection());
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@@BookISBN", isbn);

                //Execute the command
                SqlDataReader rd = cmd.ExecuteReader();

                //Book properties
                string title = "";
                string genre = "";
                int publication = 0;
                int quantity = 0;
                int Book_Id = 0;
                List<IAuthor> authors = new List<IAuthor>();
                //Load the book

                //NOTE:
                //- The procedure will return n rows where n is the number of authors,
                //      the book information will remain the same for all the authors
                while (rd.Read())
                {
                    //Read the values
                    //-The book values will remain the same for the book columns, 
                    if (Book_Id == 0)
                    {
                        Book_Id = int.Parse(rd["Book_ID"].ToString());
                        title = rd["Book_Title"].ToString();
                        genre = rd["Genre"].ToString();
                        quantity = int.Parse(rd["Quantity"].ToString());
                        publication = int.Parse(rd["PublicationYear"].ToString());
                    }//end if

                    //Author details
                    int auth_id = int.Parse(rd["Author_ID"].ToString());
                    string auth_name = rd["Author_Name"].ToString();
                    string auth_Surname = rd["Author_Surname"].ToString();
                    int noPub = int.Parse(rd["AuthorPublications"].ToString());
                    DateTime dob = DateTime.ParseExact(rd["DOB"].ToString(), "yyyy/MM/dd", null);
                    ICreationResult<IAuthor> resultAuthor = AuthorFactory.CreateAuthor(auth_name, auth_Surname, noPub, dob);

                    //Asume the data is correct
                    IAuthor auth = resultAuthor.Item;

                    ((Author)auth).ID = auth_id;

                    //Add to the list of authors
                    authors.Add(auth);
                }//end while

                //Add the author 
                ICreationResult<IBook> result = BookFactory.CreateBook(title, isbn, genre, publication, authors, quantity);

                if (result.CreationSuccessful)
                {
                    ((Book)result.Item).ID = Book_Id;
                    book = result.Item;
                }
            }//namespace
            catch (Exception ex) { ExceptionLogger.GetLogger().LogError(ex); }
            finally { if (_dbService.GetConnection().State == ConnectionState.Open) _dbService.GetConnection().Close(); }
            return book;
        }//FindBookByISBN

        public IEnumerable<IBook> LoadAllBooks()
        {
            throw new NotImplementedException();
        }//LoadAllBooks
    }//class
}//namespace
