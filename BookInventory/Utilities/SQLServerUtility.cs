/*
 *  This file contains the static class that will convert the list of author into a single author's string
 */
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;

namespace BookInventory.Utilities
{
    internal class SQLServerUtility
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
            //A key value pair of the book id and the list of authors
            //-We use this approach since the Book model has an IEnumerable<IAuthor> which means we cannot add new authors after book creation
            List<KeyValuePair<IBook, List<IAuthor>>> author_bookPair = new List<KeyValuePair<IBook, List<IAuthor>>>();
           
            //Book properties
            string title;
            string genre;
            int publication;
            int quantity;
            int Book_Id;
            string isbn;
            try
            {
                while (rd.Read())
                {
                    //The book details will not change for different authors of the same book
                    Book_Id = int.Parse(rd["Book_ID"].ToString());
                    title = rd["Book_Title"].ToString();
                    genre = rd["Genre"].ToString();
                    quantity = int.Parse(rd["Quantity"].ToString());
                    publication = int.Parse(rd["PublicationYear"].ToString());
                    isbn = rd["Book_ISBN"].ToString();

                    //Check if the pair exist in the keyValuePairs
                    if (author_bookPair.FirstOrDefault(b => b.Key.ID == Book_Id).Key == default)
                    {
                        IBook book = BookFactory.CreateBook(title, isbn, genre, publication, new List<IAuthor>(), quantity).Item;
                        ((Book)book).ID = Book_Id;
                        author_bookPair.Add(new KeyValuePair<IBook, List<IAuthor>>(book, new List<IAuthor>()));
                    }//end if book not existing yet


                    //Author details
                    int auth_id = int.Parse(rd["Author_ID"].ToString());
                    string auth_name = rd["Author_Name"].ToString();
                    string auth_Surname = rd["Author_Surname"].ToString();
                    int noPub = int.Parse(rd["AuthorPublications"].ToString());

                    DateTime dob = DateTime.ParseExact(rd["DOB"].ToString(), "yyyy/MM/dd HH:mm:ss", new CultureInfo("en-ZA"), DateTimeStyles.None);
                    //Create the author
                    //-Asume the data is correct(since it comes from the database)
                    IAuthor auth = AuthorFactory.CreateAuthor(auth_name, auth_Surname, noPub, dob).Item;
                    ((Author)auth).ID = auth_id;

                    //Add the author to the specified book
                    author_bookPair.Find(b => b.Key.ID == Book_Id).Value.Add(auth);
                }
            }//end try
            catch
            (Exception ex)
            {
                ExceptionLogger.GetLogger().LogError(ex);
            }//end catch

            //Do some crazy linq statement
            return author_bookPair.Select(pair => Select(pair)).ToList();
        }//ToBookList
        private static IBook Select(KeyValuePair<IBook, List<IAuthor>> pair)
        {
            ((Book)pair.Key).BookAuthors = pair.Value;
            return pair.Key;
        }
    }//class
}//namespace1
