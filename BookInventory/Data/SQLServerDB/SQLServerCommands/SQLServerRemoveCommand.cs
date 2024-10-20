/*
 *  This file contains the class that specifies the SQL Server Remove command
 */
using System;
using System.Data;
using System.Data.SqlClient;
namespace BookInventory
{
    internal class SQLServerRemoveCommand : IRemoveBookCommand
    {
        private readonly IDatabaseService _dbService;
        public SQLServerRemoveCommand(IDatabaseService dbService)
        {
            this._dbService = dbService;
        }//ctor main
        public bool RemoveBook(IBook book)
        {
            try
            {
                if (_dbService.GetConnection().State == ConnectionState.Closed)
                    _dbService.GetConnection().Open();

                //Create the sql command
                SqlCommand cmd = new SqlCommand("proc_RemoveBook", (SqlConnection)_dbService.GetConnection());
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@BookID", book.ID);

                int result = cmd.ExecuteNonQuery();

                //If result is "1" then it was a successful transaction otherwise it failed
                return result >= 1;
            }
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
                return false;
            }
            finally
            {
                //Close the connection
                if (_dbService.GetConnection().State == ConnectionState.Open)
                    _dbService.GetConnection().Close();
            }
        }//RemoveBook
    }//class
}//namespace
