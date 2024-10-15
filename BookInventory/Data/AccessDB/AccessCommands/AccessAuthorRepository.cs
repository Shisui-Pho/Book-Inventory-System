/*
 *  This class contains the class for adding authors in a database which will form part of some transaction
 */
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;

namespace BookInventory
{
    internal class AccessAuthorRepository
    {
        private readonly IDatabaseService _dbService;
        public AccessAuthorRepository(IDatabaseService ser)
        {
            this._dbService = ser;
        }//ctor 
        public bool AddAuthors(IBook book, IDbTransaction transaction)
        {
            try
            {
                foreach (IAuthor author in book.BookAuthors)
                {
                    int _status = default;
                    OleDbCommand cmd = new OleDbCommand();
                    cmd.Connection = (OleDbConnection)_dbService.GetConnection();
                    cmd.Transaction = (OleDbTransaction)transaction;

                    //Author does not exist in the database
                    if (author.ID == default)
                    {
                        //First we need to check if the author exists in the database
                        //-This of course can be simplified by creating a script file and exercuting it to wrap all the multipl database calls
                        cmd.CommandText = String.Format("SELECT * FROM Author WHERE Author.Author_Name = \"{0}\" AND Author.Author_Surname = \"{1}\"", author.Name, author.Surname);
                        cmd.CommandType = CommandType.Text;

                        OleDbDataReader rd = cmd.ExecuteReader();

                        //Here we will know if that particular author exists or not
                        while (rd.Read())
                        {
                            //Only grab the first one if it exists
                            //-Assign the ID to that Author
                            ((Author)author).ID = int.Parse(rd["Author_ID"].ToString());
                            break;
                        }
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
                        }//end if author was not found
                    }//End if author is null


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
                }//end foreach
                return true;
            }//end try
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
                return false;
            }//end catch
        }//AddAuthors
        public IEnumerable<IAuthor> GetAuthors(int bookid)
        {
            IList<IAuthor> authors = new List<IAuthor>();

            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();
                //The connection is already open here
                string sql = "qAuthorsInformationPerBook";

                OleDbCommand cmd = new OleDbCommand(sql, (OleDbConnection)_dbService.GetConnection());
                cmd.Parameters.AddWithValue("@bookid", bookid);
                cmd.CommandType = CommandType.StoredProcedure;
                OleDbDataReader rd = cmd.ExecuteReader();
                while (rd.Read())
                {
                    string name = rd["Author_Name"].ToString();
                    string surname = rd["Author_Surname"].ToString();
                    int publication = int.Parse(rd["Publications"].ToString());
                    int authID = int.Parse(rd["Author_ID"].ToString());


                    #warning Still need to deal with invalid input/data
                    //For now we assume that the data retrieved from the database is valid
                    //-Of course this may not be always the case
                    //-For instance, an "Database Admin" may manually change the data from the database itself

                    ICreationResult<IAuthor> result = AuthorFactory.CreateAuthor(name, surname, publication);
                    Author auth = (Author)result.Item;
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
    }//class
}//namespace
