/*
 * This file containes the interface for the database service model
 */
using System.Data;
namespace BookInventory
{
    public interface IDatabaseService
    {
        /// <summary>
        /// Gets the database connection.
        /// </summary>
        /// <returns>Returns the database connection</returns>
        IDbConnection GetConnection();
    }//interface
}//namespace
