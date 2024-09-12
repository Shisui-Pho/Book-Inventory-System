/*
 * This file contains a concrete implementation of the ÏDatabaseService" interface that uses the oldb conection
 */
using System.Data.OleDb;

namespace BookInventory
{
    public class DatabaseService : IDatabaseService
    {
        private readonly OleDbConnection _con;
        public DatabaseService(string _connectionString)
        {
            _con = new OleDbConnection(_connectionString);
        }
        public OleDbConnection GetConnection()
        {
            return _con;
        }//GetConnection
    }//class
}//namespace
