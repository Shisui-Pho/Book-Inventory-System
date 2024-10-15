/*
 *  This file contains the static class that will convert the list of author into a single author's string
 */
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

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
        public static IList<IBook> ReadToListOfBooks(SqlDataReader rd)
        {
            //NOTE:
            //-The following is the example of the expected outcome of the rows of the DataReader Object:
            /*
                Book_ID | Book_ISBN        | Book_Title              | Genre         | PublicationYear | Quantity | Author_ID | Author_Name    | Author_Surname | DOB        | AuthorPublications
                --------------------------------------------------------------------------------------------------------
                1       | 978-3-16-148410-0| The Great Gatsby        | Fiction       | 1925            | 3        | 101       | F. Scott       | Fitzgerald    | 1896-09-24 | 5
                2       | 978-1-56619-909-4| To Kill a Mockingbird   | Fiction       | 1960            | 2        | 102       | Harper         | Lee           | 1926-04-28 | 4
                3       | 978-0-7432-7356-5| 1984                    | Dystopian     | 1949            | 5        | 103       | George         | Orwell        | 1903-06-25 | 6
                4       | 978-0-452-28423-4| The Catcher in the Rye  | Fiction       | 1951            | 4        | 104       | J.D.           | Salinger      | 1919-01-01 | 1
                5       | 978-0-06-112008-4| Good Omens              | Fantasy       | 1990            | 6        | 105       | Neil           | Gaiman        | 1960-11-10 | 8
                5       | 978-0-06-112008-4| Good Omens              | Fantasy       | 1990            | 6        | 106       | Terry          | Pratchett     | 1948-04-28 | 10
                6       | 978-0-670-81302-4| The Tenth Insight       | Non-fiction   | 1996            | 2        | 107       | James          | Redfield      | 1950-10-19 | 3
                6       | 978-0-670-81302-4| The Tenth Insight       | Non-fiction   | 1996            | 2        | 108       | William        | Arntz         | 1943-05-29 | 2
            */

            //This will keep track on the book we're reading from the database 
            int BookID_Track = int.MinValue;

            List<IBook> books = new List<IBook>();
            //Book properties
            string title = "";
            string genre = "";
            int publication = 0;
            int quantity = 0;
            int Book_Id = 0;
            string isbn = "";
            List<IAuthor> authors = new List<IAuthor>();
            try
            {
                while (rd.Read())
                {
                    if (BookID_Track == int.MinValue)//FirstTimeLoop
                    {
                        Book_Id = int.Parse(rd["Book_ID"].ToString());
                        title = rd["Book_Title"].ToString();
                        genre = rd["Genre"].ToString();
                        quantity = int.Parse(rd["Quantity"].ToString());
                        publication = int.Parse(rd["PublicationYear"].ToString());
                        isbn = rd["Book_ISBN"].ToString();

                        BookID_Track = Book_Id;
                    }//end if
                    else//Read the current value of the id in the record
                        BookID_Track = int.Parse(rd["Book_ID"].ToString());

                    //Author details
                    int auth_id = int.Parse(rd["Author_ID"].ToString());
                    string auth_name = rd["Author_Name"].ToString();
                    string auth_Surname = rd["Author_Surname"].ToString();
                    int noPub = int.Parse(rd["AuthorPublications"].ToString());
                    DateTime dob = DateTime.ParseExact(rd["DOB"].ToString(), "yyyy/MM/dd", null);

                    //Create the author
                    ICreationResult<IAuthor> resultAuthor = AuthorFactory.CreateAuthor(auth_name, auth_Surname, noPub, dob);
                    //Asume the data is correct(since it comes from the database)
                    IAuthor auth = resultAuthor.Item;
                    ((Author)auth).ID = auth_id;

                    //Check if were still on the same book
                    if (BookID_Track != Book_Id)
                    {
                        //This means we are on anoher book
                        //-Add the previous book and it's authors to the list of books with it's authors
                        ICreationResult<IBook> bookResult = BookFactory.CreateBook(title, isbn, genre, publication, authors, quantity);

                        //Assume the data is correct(since it comes from the database)
                        ((Book)bookResult.Item).ID = Book_Id;
                        books.Add(bookResult.Item);//Add the book

                        //Refresh the athors list
                        authors = new List<IAuthor>();

                        //Add the current author
                        authors.Add(auth);

                        //Set the Current Book Track to the min value
                        BookID_Track = int.MinValue;
                    }//end if different book
                    else
                        authors.Add(auth);//Still the same book
                }//end while
            }//end try
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
                books = new List<IBook>();//Refresh the list of books
            }//end catch

            return books;
        }//ToBookList
    }//class
}//namespace1
