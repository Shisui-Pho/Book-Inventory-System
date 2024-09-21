/*
 * This file containes the interface for the database service model
 */
using System.Data.OleDb;
namespace BookInventory
{
    public interface IDatabaseService
    {
        /// <summary>
        /// Gets the database connection.
        /// </summary>
        /// <returns>Returns the database connection</returns>
        OleDbConnection GetConnection();
    }//interface
}//namespace
