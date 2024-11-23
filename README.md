# Book-Inventory-System

## Table of Contents  
1. [Introduction](#introduction)  
2. [Features](#features)  
3. [System Architecture](#system-architecture)  
   - [Overview](#overview)  
   - [Key Components](#key-components)  
   - [Class Diagram](#class-diagram)  
   - [ERD Diagram](#erd-diagram)  
   - [Interaction Flow](#interaction-flow)  
   - [Design Principles](#design-principles)  
4. [Database Setup](#database-setup)  
   - [Microsoft Access](#microsoft-access)  
   - [SQL Server](#sql-server)  
5. [Integration Guidelines](#integration-guidelines)  
   - [Adding References](#adding-references)  
   - [Configuration](#configuration)
6. [Usage Instructions](#usage-instructions)  
   - [Adding Books](#adding-books)  
   - [Updating Books](#updating-books)  
   - [Removing Books](#removing-books)  
   - [Filtering Books](#filtering-books)  
   - [Finding Books by ISBN](#finding-books-by-isbn)  

## Introduction  

The **Book Inventory System** is designed to manage a collection of books using two database options: **Microsoft Access** and **SQL Server**. The system allows users to perform key operations such as adding, updating, removing, and filtering books. Throughout the development of this system, I applied several **software engineering principles** to ensure the architecture is both **maintainable** and **scalable**. The solution is built with **Object-Oriented Programming (OOP)** principles, utilizing design patterns like the **Repository Pattern** and **Command Pattern** to decouple business logic from database operations.

This project demonstrates my ability to work with different database technologies, handle backend logic, and implement a well-structured system that is easily extensible.

---

## Features

The Book Inventory System incorporates several core features that demonstrate advanced backend development techniques. For example, the **CRUD operations** for managing books are implemented using the **Repository Pattern**. This abstraction allows for a clean separation between the application logic and the database, making the code easier to maintain and extend. Additionally, **advanced filtering** options are provided for querying books based on multiple criteria such as title, genre, and author. This flexibility is a direct result of applying the **Specification Pattern**, which allows dynamic query building.

One of the critical elements of the system is its **multi-database support**. By providing the option to work with both **Microsoft Access** and **SQL Server**, I ensured that the system could operate in different environments, highlighting my ability to handle diverse database setups. This feature demonstrates an understanding of **database abstraction** and how to configure different connection strings based on the database in use.

---

## System Architecture  

The system is built around a **Repository Pattern**, which provides a clear separation between the business logic and the data access layer. The **Book Repository** acts as the central hub for interacting with the database, offering an API that abstracts away the complexities of database interactions. This ensures that any future changes to the underlying data store (such as switching to a different database engine) will not impact the rest of the system.

I used the **Command Pattern** to encapsulate the different database operations, such as adding, updating, or removing books. This approach allows the application to handle operations dynamically by selecting the appropriate command based on the database engine being used. By decoupling the commands from the client code, this pattern also promotes flexibility and extensibility. For instance, should additional databases need to be supported in the future, new command classes can be added without altering the core logic.

In addition, I leveraged the **Strategy Pattern** for database command selection, where a `DBCommandFactory` dynamically chooses the correct command strategy (such as `SQLServerCommandStrategy` or `AccessCommandStrategy`) based on the database being used. This ensures that the system can easily scale to support more database systems with minimal modifications.

### Overview  
The system is designed around a **Repository Pattern** for managing the interactions with the database. The **Command Pattern** is used to encapsulate database queries and operations. The system is divided into two primary layers:  
1. **Client Layer**: This represents the application layer that interacts with the user, gathers inputs, and uses the Book Repository to fetch or modify data.
2. **Backend Layer**: This includes the database, its queries, and the logic for interacting with it.

The **BookRepository** acts as the central hub for CRUD operations, with separate commands to handle different tasks. These tasks include adding books, updating books, filtering books based on various criteria, and removing books from the system. The commands are encapsulated in strategies that are determined by the database type (Access or SQL Server), making the system extendable.

The **Database Layer** consists of:
- **Stored Procedures**: For querying the database, ensuring that complex operations are executed efficiently at the database level.
- **Functions and Triggers**: Used for data integrity, such as updating the number of publications for authors when book-author relationships are changed.

### Key Components  
1. **Book Repository**: Handles the primary interactions with the data. It abstracts the complexity of database operations and provides a simple API for the client code.
2. **Commands**: Different commands (Add, Update, Remove/Delete, etc.) handle the actual database interaction, which are further split based on the database engine.
3. **Database Service**: Abstracts the connection to the database and handles opening and closing the connection.
4. **Factory Classes**: Provide a flexible and extendable mechanism to create instances of repositories, ensuring the correct command strategies are used based on the database type.

### Class Diagram  
The class diagram below illustrates the relationship between key classes and interfaces in the system.

![Class Diagram](./Achitecture/Class.png)

### ERD (Entity-Relationship Diagram)  
The ERD diagram below demonstrates the relationships between the entities in the Book Inventory System, including the primary tables like `Book`, `Author`, and `BookAuthor`, as well as the connections between them.

![ERD Diagram](./Achitecture/ERD.png)

### Interaction Flow  
1. The **client** requests a book operation (e.g., add, remove, filter).
2. The **Book Repository** processes the request by calling the appropriate **command** (e.g., AddBookCommand, RemoveBookCommand).
3. The **command** executes the corresponding **stored procedure** or **SQL query** using the **Database Service**.
4. The result is passed back to the client, which presents it to the user.

### Design Principles

The Book Inventory System is built with a strong focus on **maintainability**, **scalability**, and **flexibility**. The following design principles have been adhered to in order to create a robust architecture:

#### 1. **Separation of Concerns**
   - Each class and component in the system has a single responsibility. For example, the `BookRepository` is responsible for interacting with the data store (i.e., database) while the command classes (`AddBookCommand`, `FilterBooksCommand`, etc.) handle specific database operations. This promotes maintainability and easier debugging.
   
#### 2. **Dependency Injection**
   - The system uses dependency injection to decouple classes from their dependencies, such as database services and commands. This allows for better flexibility and testability. The `BookRepository` class, for instance, receives its dependencies (commands for adding, updating, and filtering books) through its constructor.
   
#### 3. **Command Pattern**
   - The **Command Pattern** is implemented to encapsulate each request as an object, thus allowing parameterization of clients with queues, requests, and operations. It also decouples the client from the system's internal workings, such as database interactions. 
     - For example, the command interface `IAddBookCommand` is used for adding books, and different implementations are provided based on the database type (`AccessAddCommand`, `SQLServerAddCommand`).

#### 4. **Strategy Pattern**
   - The **Strategy Pattern** is used in the `DBCommandFactory`, which selects the appropriate command strategy (`AccessCommandStrategy` or `SQLServerCommandStrategy`) based on the database type. This approach enhances flexibility by decoupling the logic for command creation, making it easy to extend the system to support additional databases in the future without modifying existing code.

#### 5. **Interface Segregation**
   - The system uses small, client-specific interfaces. For instance, the `IBookRepository` interface defines methods like `AddBook`, `RemoveBook`, and `FilterBooks`, which are implemented in the `BookRepository`. Each class only depends on the methods it needs, reducing unnecessary coupling.

#### 6. **Single Responsibility Principle (SRP)**
   - Each class in the system is designed to have one reason to change. For example, the `BookRepository` class handles the logic for interacting with books, but it delegates database-specific operations to the command classes. The database interaction logic is contained within these command classes, adhering to SRP.

#### 7. **Open/Closed Principle**
   - The system is open for extension but closed for modification. New features or database engines can be added without modifying existing code, thanks to the Strategy Pattern and dependency injection. Adding support for a new database type, for instance, only requires the addition of a new command strategy without altering the existing repository logic.

#### 8. **Data Consistency**
   - Data consistency is ensured by transactional database operations (e.g., in commands such as `AddBook` and `RemoveBook`). This ensures that if any part of the operation fails, changes to the data are rolled back, leaving the database in a consistent state.

#### 9. **Error Handling**
   - The system uses centralized error handling, especially in database interactions, where all exceptions are logged and rethrown as custom exceptions. This allows for better tracking of errors and keeps the database interaction layer clean and consistent.

---

Now that we've covered the system's design principles, the next step is setting up the database, which forms the backbone of the Book Inventory System. Depending on your preference or project requirements, you can choose either Microsoft Access or SQL Server as your database backend. Follow the instructions below to properly configure the system with your chosen database.

## Database Setup  

To use the **Book Inventory System** effectively, you can choose between two database options: **Microsoft Access** and **SQL Server**. Each database type requires specific setup steps and configurations. Below is a detailed guide on how to configure the system for either database.

This section will walk you through the necessary steps to set up both environments, including updating configuration files, testing database connections, and troubleshooting common issues. Follow the instructions for your chosen database to ensure the system functions as expected.

### Microsoft Access  
To use the system with a Microsoft Access database, follow these steps:

1. **Locate the Access Database File**  
   The `.accdb` file is provided and should be placed in the project directory.

2. **Set Connection String**  
   Update the connection string in the `App.config` file to point to the correct `.accdb` file.

3. **Testing the Connection**  
   The application will automatically connect to the database using the provided connection string and display the results.

### SQL Server  
For SQL Server, you have two setup options:

1. **Using SQL Scripts**  
   Execute the pre-written SQL scripts to create the necessary schema, including tables, functions, triggers, and stored procedures. The scripts can be found in the following folders, execute the schema first:
   ```plaintext
   /Book-Inventory-System/SQL Server Database Files/Schema
   /Book-Inventory-System/SQL Server Database Files/Functions
   /Book-Inventory-System/SQL Server Database Files/Stored Procedures Scripts
   /Book-Inventory-System/SQL Server Database Files/Triggers
   ```

3. **Using Pre-Script for Additional Setup**  
   The script handles extra configurations and stored procedures for maintaining the integrity of the system.

Once the SQL Server database is set up, update the connection string in `App.config` to point to the correct instance of SQL Server.

---

## Testing Connections

Once the database is set up, the system includes a built-in testing functionality to verify the database connection. This feature ensures that the application can connect to both **SQL Server** and **Microsoft Access**, and it helps troubleshoot any connection issues. The **error logging mechanism** captures connection failures and provides detailed logs, which aids in diagnosing and resolving connection problems efficiently.

By incorporating this testing feature, the system ensures that the database connection is robust, reliable, and user-friendly. This also demonstrates the importance of **error handling** and **system stability** in backend development.

## Integration Guidelines  

### Adding References  

1. Locate the compiled DLL in the `bin` folder of the project.  
2. In your application, add the DLL as a reference via **Project > Add Reference > Browse**.  
3. Ensure your project targets the same .NET framework version as the system.  

### Configuration  

1. **Database Connection String**:  
   Update your `App.config` or `Web.config` file with the appropriate connection string:  
   - **Access**:  
     ```xml
     <connectionStrings>
         <add name="AccessDB" connectionString="Provider=Microsoft.ACE.OLEDB.12.0;Data Source=PathToYourDatabase.accdb;" />
     </connectionStrings>
     ```
   - **SQL Server**:  
     ```xml
     <connectionStrings>
         <add name="SQLServerDB" connectionString="Server=YourServerName;Database=BookInventory;Integrated Security=True;" />
     </connectionStrings>
     ```  

2. **Dependency Injection**:  
   Use the `BookRepositoryFactory` to create the repository:  
   ```csharp
   var result = BookRepositoryFactory.CreateBookRepository(connectionString, DatabaseType.SQLServerDB);
   if (result.Success) var bookRepository = result.Item;
   ```  

Follow these steps to seamlessly integrate the system into your application.  

---

## Usage Instructions  

This section provides step-by-step instructions for using the system to manage your book inventory. Each operation is performed through the `BookRepository` interface, ensuring abstraction from the underlying database logic.

### Adding Books  

To add a book with associated authors, create a `Book` object and pass it to the `AddBook` method:

```csharp
var authors = new List<IAuthor>
{
    AuthorFactory.CreateAuthor("John", "Doe", 3, new DateTime(1985, 7, 12)).Item,
    AuthorFactory.CreateAuthor("Jane", "Smith", 5, new DateTime(1990, 4, 25)).Item
};

var book = BookFactory.CreateBook("The Great Adventure", "978-3-16-148410-0", "Fiction", 2023, authors, 10).Item;

bool success = bookRepository.AddBook(book);
if (success) 
    Console.WriteLine($"Book added successfully with ID: {book.ID}");
else 
    Console.WriteLine("Failed to add the book.");
```

### Updating Books  

To update a book, create a new book instance with the updated properties and use the original book's `Update` method to apply the changes. Then, call the `UpdateBook` method to save the changes in the database:

```csharp
// Create a new book instance with updated properties
IBook updatedBook = BookFactory.CreateBook("The Greater Adventure", book.ISBN, book.Genre, book.PublicationYear, book.BookAuthors, 15).Item;

// Apply updates to the original book
book.Update(updatedBook);

// Save changes in the database
bool updated = bookRepository.UpdateBook(book);
if (updated) 
    Console.WriteLine("Book updated successfully.");
else 
    Console.WriteLine("Failed to update the book.");
```

### Removing Books  

To remove a book, call the `RemoveBook` method with the book object:

```csharp
bool removed = bookRepository.RemoveBook(book);
if (removed) 
    Console.WriteLine("Book removed successfully.");
else 
    Console.WriteLine("Failed to remove the book.");
```

### Filtering Books  

To filter books based on criteria, use the `FilterBooks` method with optional parameters:

```csharp
var filteredBooks = bookRepository.FilterBooks(authorName: "John", genre: "Fiction");

foreach (var filteredBook in filteredBooks)
{
    Console.WriteLine($"Title: {filteredBook.Title}, Genre: {filteredBook.Genre}");
}
```

You can also filter using a predicate for custom logic:

```csharp
var customFilteredBooks = bookRepository.FilterBooks(book => book.PublicationYear > 2020);

foreach (var filteredBook in customFilteredBooks)
{
    Console.WriteLine($"Title: {filteredBook.Title}, Published: {filteredBook.PublicationYear}");
}
```

### Finding Books by ISBN  

To retrieve a book by its ISBN, call the `FindByISBN` method:

```csharp
var bookByISBN = bookRepository.FindByISBN("978-3-16-148410-0");

if (bookByISBN != null)
    Console.WriteLine($"Found Book: {bookByISBN.Title}, Author(s): {string.Join(", ", bookByISBN.BookAuthors.Select(a => a.Name))}");
else
    Console.WriteLine("No book found with the given ISBN.");
```

These instructions demonstrate how to interact with the system's core functionalities in a straightforward manner. For any errors or issues encountered, refer to the logs generated by the centralized error logging mechanism for debugging purposes.

---

## License  

This project is licensed under the [MIT License](LICENSE).  
You are free to use, modify, and distribute this software per the terms of the license.  

## Contact Information  

For any questions, feedback, or contributions, please reach out to:  

- **Name**: Phiwokwakhe Khathwane  
- **Email**: phiwokwakhe299@gmail.com  
- **GitHub**: [Phiwokwakhe Khathwane](https://github.com/shisui-pho)  
- **LinkedIn**: [Phiwokwakhe Khathwane](https://za.linkedin.com/in/phiwokwakhe-khathwane-887175245?trk=profile-badge)  

Feel free to open issues or pull requests on the GitHub repository for collaboration or improvements!  
