/*
 * This file contains the factory class that will handle the creation of BookRepositories for different kind of databases
 */
using System;
namespace BookInventory
{
    public static class BookRepositoryFactory
    {
        /// <summary>
        /// This method creates a BookRepository that establishes the connection between the database and the application
        /// </summary>
        /// <param name="connectionString">The connection string of the database</param>
        /// <param name="dbType">The type of datbase that need to be used</param>
        /// <returns>An creatoin result object that contains the repository and additional information about the operation.</returns>
        public static ICreationResult<IBookRepository> CreateBookRepository(string connectionString, DatabaseType dbType)
        {
            //Declarations
            ICreationResult<IBookRepository> result;
            IDatabaseService dbService = null;
            IBookRepository repository = null;

            //-Commands
            IAddBookCommand cmdAddBook = null;
            IRemoveBookCommand cmdRemoveBook = null;
            IUpdateBookCommand cmdUpdateBook = null;
            IFilterBooksCommand cmdFilterBooks = null;
            ILoadingBooksCommand cmdLoading = null;

            //Create the dbService
            try
            {
                switch (dbType)
                {
                    case DatabaseType.AccessDB:
                        //Create the access objects
                        dbService = new AccessDatabaseService(connectionString);

                        //Create th seperate commands for the access database engine
                        cmdAddBook = new AccessAddCommand(dbService);
                        cmdRemoveBook = new AccessRemoveCommand(dbService);
                        cmdUpdateBook = new AccessUpdateCommand(dbService);
                        cmdFilterBooks = new AccessFilterCommand(dbService);
                        cmdLoading = new AccessLoadCommand(dbService);

                        break;
                    case DatabaseType.SQLServerDB:
                        //Create the SQL Server Objects
                        dbService = new SQLServerDatabaseService(connectionString);

                        //Create t he seperate commands for the sqlserver engine
                        cmdAddBook = new SQLServerAddCommand(dbService);
                        cmdRemoveBook = new SQLServerRemoveCommand(dbService);
                        cmdUpdateBook = new SQLServerUpdateCommand(dbService);
                        cmdFilterBooks = new SQLServerFilterCommand(dbService);
                        cmdLoading = new SQLServerLoadingCommand(dbService);
                        break;
                    default:
                        break;
                }//enbd switch

                //Test database connection
                //-IF the dbService was not created
                if (dbService == null)
                    result = new CreationResult<IBookRepository>("The specified database service cannot be created, please try another one", null, false);
                else
                {
                    //Check the connection
                    dbService.GetConnection().Open();//Open the connection for testing
                    dbService.GetConnection().Close();//Close the connection for testing

                    //If the connection was successful
                    //-Create a new book repository and pass the commands
                    repository = new BookRepository(cmdAddBook, cmdLoading, cmdFilterBooks, cmdRemoveBook, cmdUpdateBook);
                    result = new CreationResult<IBookRepository>("Repository created successfully.", repository, true);
                }
            }
            catch
            (Exception ex)
            {
                //Here it means either the connection has failed or something has happened
                result = new CreationResult<IBookRepository>(ex.Message, null, false);
                //Log the error to the database since it may be something that may be conbcerning
                ExceptionLogger.GetLogger().LogError(ex);
            }

            return result;
        }//CreateBookRepository
    }//class
}//namespace