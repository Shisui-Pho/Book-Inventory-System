/*
 * This file contains a concrete implementation of the ÏDatabaseService" interface that uses the oldb conection
 */
using System.Data.OleDb;

namespace BookInventory
{
    public class AccessDatabaseService : IDatabaseService
    {
        private readonly OleDbConnection _con;
        public AccessDatabaseService(string _connectionString)
        {
            _con = new OleDbConnection(_connectionString);
        }
        public OleDbConnection GetConnection()
        {
            return _con;
        }//GetConnection
    }//class
}//namespace
