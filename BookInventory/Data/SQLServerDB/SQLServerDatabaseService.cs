/*
 *  This file contains the Sql server database service class
 */
using System.Data;
using System.Data.SqlClient;
namespace BookInventory
{
    class SQLServerDatabaseService : IDatabaseService
    {
        private readonly SqlConnection _connection;
        public SQLServerDatabaseService(string connectionstring)
        {
            this._connection = new SqlConnection(connectionstring);
        }
        public IDbConnection GetConnection()
        {
            return _connection;
        }//GetConnection
    }//class
}//namespace
