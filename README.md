# Book-Inventory-System
## Table of Contents  
1. [Introduction](#introduction)  
2. [Features](#features)  
3. [System Architecture](#system-architecture)  
   - [High-Level Architecture Overview](#overview)  
   - [Class Diagram](#class-diagram)  
   - [Design Patterns and Principles](#design-patterns-and-principles)  
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
7. [Development Practices](#development-practices)  
   - [Design Principles Followed](#design-principles-followed)  
   - [Data Structures Used](#data-structures-used)  
   - [OOP Pillars and Implementation](#oop-pillars-and-implementation)  
8. [Testing and Debugging](#testing-and-debugging)  
9. [Contributing](#contributing)  
10. [License](#license)  
11. [Contact Information](#contact-information)  

## Introduction  
The Book Inventory System is a robust backend library designed to manage book records in a database environment. It supports two database engines: Microsoft Access and SQL Server, providing seamless integration and flexibility for different user setups. This system handles core operations such as adding, updating, removing, and filtering books, while maintaining a clean separation of concerns through the use of design patterns like the Repository Pattern and Strategy Pattern.  

With a focus on maintainability, scalability, and performance, this system is ideal for developers seeking a well-architected solution for book inventory management in both small-scale and enterprise-level applications.  

---

## Features  
1. **Multi-Database Support**:  
   - Fully supports Microsoft Access and SQL Server databases.  

2. **CRUD Operations**:  
   - Add new books with associated authors.  
   - Update book details and authors.  
   - Remove books while maintaining author data integrity.  
   - Retrieve books using flexible filtering criteria.  

3. **Advanced Filtering**:  
   - Filter books based on title, genre, author name, author surname, or a combination of these attributes.  
   - Support for "match any" or "match all" criteria using a simple parameter toggle.  

4. **ISBN Management**:  
   - Automatically formats ISBN strings to ensure consistency and correctness.  

5. **Extensible Architecture**:  
   - Easily add support for additional database engines by extending the command strategy interface.  

6. **Optimized Database Commands**:  
   - Implements stored procedures, triggers, and functions for efficient database operations in SQL Server.  

7. **Error Logging**:  
   - Centralized error logging mechanism to capture and debug runtime issues effectively.  

8. **Test Data Ready**:  
   - Includes preloaded database scripts with test data to get started quickly.  

9. **OOP and Design Principles**:  
   - Encapsulation, abstraction, inheritance, and polymorphism are utilized throughout the system.  
   - Adherence to SOLID principles for maintainable and scalable code.  

10. **Modular Design**:  
    - Clean separation of client-side and database-side logic.  
    - Repository and command layers abstract database details from the client application.  

---

## System Architecture  

The Book Inventory System is designed with a clear separation of concerns, using Object-Oriented Programming (OOP) principles and common design patterns. The architecture is built to be scalable, maintainable, and flexible to support different database engines (Access and SQL Server). Below is a breakdown of the components and the interaction between them.

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
2. **Commands**: Different commands (Add, Update, Delete, etc.) handle the actual database interaction, which are further split based on the database engine.
3. **Database Service**: Abstracts the connection to the database and handles opening and closing the connection.
4. **Factory Classes**: Provide a flexible and extendable mechanism to create instances of repositories, ensuring the correct command strategies are used based on the database type.

### Class Diagram  
The class diagram below illustrates the relationship between key classes and interfaces in the system.

![Class Diagram](./path-to-your-class-diagram.png)  <!-- Ensure to replace this with the actual link to your class diagram file -->

### ERD (Entity-Relationship Diagram)  
The ERD diagram below demonstrates the relationships between the entities in the Book Inventory System, including the primary tables like `Book`, `Author`, and `BookAuthor`, as well as the connections between them.

![ERD Diagram](./path-to-your-erd-diagram.png)  <!-- Ensure to replace this with the actual link to your ERD diagram file -->

### Interaction Flow  
1. The **client** requests a book operation (e.g., add, remove, filter).
2. The **Book Repository** processes the request by calling the appropriate **command** (e.g., AddBookCommand, RemoveBookCommand).
3. The **command** executes the corresponding **stored procedure** or **SQL query** using the **Database Service**.
4. The result is passed back to the client, which presents it to the user.

---

This architecture ensures that the system remains modular and easy to extend. Future database engines can be added by creating new command strategies without changing the core logic. Similarly, changes in the database operations can be encapsulated within the command layer, keeping the repository layer unaffected.
