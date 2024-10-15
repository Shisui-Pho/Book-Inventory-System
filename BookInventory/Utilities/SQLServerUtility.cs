/*
 *  This file contains the static class that will convert the list of author into a single author's string
 */
using System.Collections.Generic;

namespace BookInventory.Utilities
{
    internal static class SQLServerUtility
    {
        public static string ToAuthorsString(IEnumerable<IAuthor> authors)
        {
            string _sAuthors = "";

            //-Format the ID string the way that it is needed in the SQL Server database engine
            foreach (IAuthor item in authors)
                _sAuthors += item.ID + ",'" + item.Name + "','" + item.Surname + "','" + item.DOB.ToString("yyyy/MM/dd") + "';";

            return _sAuthors;
        }//ToAuthorsString
    }//class
}//namespace1
