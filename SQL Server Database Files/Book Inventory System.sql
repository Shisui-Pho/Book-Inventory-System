USE [master]
GO
/****** Object:  Database [BookInventory]    Script Date: 2024/11/23 22:38:15 ******/
CREATE DATABASE [BookInventory]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BookInventory', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BookInventory.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BookInventory_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BookInventory_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BookInventory] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BookInventory].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BookInventory] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BookInventory] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BookInventory] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BookInventory] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BookInventory] SET ARITHABORT OFF 
GO
ALTER DATABASE [BookInventory] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BookInventory] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BookInventory] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BookInventory] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BookInventory] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BookInventory] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BookInventory] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BookInventory] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BookInventory] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BookInventory] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BookInventory] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BookInventory] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BookInventory] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BookInventory] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BookInventory] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BookInventory] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BookInventory] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BookInventory] SET RECOVERY FULL 
GO
ALTER DATABASE [BookInventory] SET  MULTI_USER 
GO
ALTER DATABASE [BookInventory] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BookInventory] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BookInventory] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BookInventory] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BookInventory] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BookInventory] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BookInventory', N'ON'
GO
ALTER DATABASE [BookInventory] SET QUERY_STORE = ON
GO
ALTER DATABASE [BookInventory] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BookInventory]
GO
/****** Object:  UserDefinedFunction [dbo].[func_SplitAuthorInfo]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_SplitAuthorInfo]
(
    @InputString VARCHAR(100)  -- The input string containing the ID, name, surname, and DOB
)
RETURNS @Result TABLE  -- Returns a table with the split values
(
    ID INT,                   -- ID of the author or record
    [Name] NVARCHAR(100),      -- Name of the author, without single quotes
    Surname NVARCHAR(100),     -- Surname of the author, without single quotes
    DOB DATE                   -- Date of Birth in 'yyyy/mm/dd' format
)
AS
BEGIN
    -- =====================================================================
    -- Description: This function takes a formatted input string containing 
    --              an author's ID, name, surname, and DOB, splits the string, 
    --              and returns the values in a table format. The DOB is formatted
    --              as 'yyyy/mm/dd'.
    --
    -- Parameters:
    --     @InputString (VARCHAR(100)): A string formatted as:
    --                 id,''name'',''surname'',''yyyy/mm/dd''.
    --                 The ID should be an integer, while name, surname, and DOB
    --                 should be enclosed in double single quotes.
    --
    -- Returns:
    --     A table with the following columns:
    --         - ID (INT): The ID of the author.
    --         - Name (NVARCHAR(100)): The author's name without single quotes.
    --         - Surname (NVARCHAR(100)): The author's surname without single quotes.
    --         - DOB (NVARCHAR(10)): The author's date of birth in 'yyyy/mm/dd' format.
    --
    -- Example Call: 
    --     SELECT * FROM dbo.SplitBookInfo('1,''John'',''Doe'',''2024/03/21''');
    --
    -- Note: This function uses STRING_SPLIT to separate the input string 
    --       by commas and ROW_NUMBER to handle the sequence of values.
    -- =====================================================================

    -- Split the input string and store values in a temporary table
    WITH SplitValues AS (
        SELECT 
            value, 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum  -- Assign row numbers to each split value
        FROM STRING_SPLIT(@InputString, ',')  -- Split by comma
    )
    
    INSERT INTO @Result (ID, Name, Surname, DOB)  -- Insert into the result table
    SELECT 
        CAST(MAX(CASE WHEN RowNum = 1 THEN value END) AS INT),  -- Cast first value to ID
        LTRIM(RTRIM(REPLACE(MAX(CASE WHEN RowNum = 2 THEN value END), '''', ''))),  -- Clean and trim name
        LTRIM(RTRIM(REPLACE(MAX(CASE WHEN RowNum = 3 THEN value END), '''', ''))),  -- Clean and trim surname
        -- Extract DOB directly since it's already in 'yyyy/mm/dd' format
        LTRIM(RTRIM(REPLACE(MAX(CASE WHEN RowNum = 4 THEN value END), '''', '')))
    FROM SplitValues;

    RETURN;  -- Return the result table
END;
GO
/****** Object:  UserDefinedFunction [dbo].[Publications]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Publications]
(
    @Author_ID  INT
)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM BookAuthor WHERE BookAuthor.Author_ID = @Author_ID); 
END;
GO
/****** Object:  Table [dbo].[Author]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Author](
	[Author_ID] [int] IDENTITY(1,1) NOT NULL,
	[Author_Name] [nvarchar](100) NOT NULL,
	[Author_Surname] [nvarchar](100) NOT NULL,
	[Publications] [int] NULL,
	[DOB] [date] NULL,
 CONSTRAINT [PK_Author] PRIMARY KEY CLUSTERED 
(
	[Author_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[Book_ID] [int] IDENTITY(1,1) NOT NULL,
	[Book_ISBN] [varchar](20) NOT NULL,
	[Book_Title] [nvarchar](255) NOT NULL,
	[PublicationYear] [smallint] NOT NULL,
	[Quantity] [tinyint] NOT NULL,
	[Genre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[Book_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookAuthor]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookAuthor](
	[Book_ID] [int] NOT NULL,
	[Author_ID] [int] NOT NULL,
 CONSTRAINT [PK_BookAuthor] PRIMARY KEY CLUSTERED 
(
	[Book_ID] ASC,
	[Author_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Author] ON 

INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (5, N'Mark P. O. ', N'Morford', 3, CAST(N'1950-05-15' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (6, N'Richard Bruce ', N'Wright', 2, CAST(N'1945-03-01' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (7, N'Carlo ', N'D''Este', 1, CAST(N'1943-07-10' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (8, N'Gina Bari ', N'Kolata', 1, CAST(N'1945-02-24' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (9, N'E. J. W. ', N'Barber', 1, CAST(N'1960-03-20' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (10, N'Amy ', N'Tan', 2, CAST(N'1952-02-19' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (11, N'Robert ', N'Cowley', 4, CAST(N'1948-06-01' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (12, N'Scott ', N'Turow', 1, CAST(N'1949-04-12' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (13, N'David ', N'Cordingly', 1, CAST(N'1952-11-01' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (14, N'Ann ', N'Beattie', 1, CAST(N'1947-09-17' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (15, N'David Adams ', N'Richards', 1, CAST(N'1960-06-25' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (16, N'Adam ', N'Lebor', 1, CAST(N'1965-09-25' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (17, N'Sheila ', N'Heti', 1, CAST(N'1976-06-25' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (18, N'R. J. ', N'Kaiser', 1, CAST(N'1970-04-30' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (19, N'Jack ', N'Canfield', 1, CAST(N'1944-08-19' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (20, N'Loren D. ', N'Estleman', 2, CAST(N'1952-01-22' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (21, N'Robert ', N'Hendrickson', 2, CAST(N'1940-12-14' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (22, N'Julia ', N'Oliver', 1, CAST(N'1975-11-05' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (23, N'John ', N'Grisham', 1, CAST(N'1955-02-08' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (24, N'Toni ', N'Morrison', 1, CAST(N'1931-02-18' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (25, N'The ', N'Onion', 2, CAST(N'1988-04-01' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (26, N'Celia Brooks ', N'Brown', 1, CAST(N'1950-06-12' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (27, N'J. R. ', N'Parrish', 1, CAST(N'1962-03-28' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (28, N'Mary-Kate &amp; Ashley ', N'Olsen', 1, CAST(N'1986-06-13' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (29, N'Robynn ', N'Clairday', 1, CAST(N'1980-05-17' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (30, N'Kathleen ', N'Duey', 1, CAST(N'1955-07-11' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (31, N'Rich ', N'Shapero', 1, CAST(N'1960-09-09' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (32, N'Michael ', N'Crichton', 1, CAST(N'1942-10-23' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (33, N'MICHAEL ', N'CRICHTON', 1, CAST(N'1942-10-23' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (34, N'C.S. ', N'Lewis', 1, CAST(N'1898-11-29' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (35, N'ARTHUR ', N'PHILLIPS', 1, CAST(N'1970-06-02' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (36, N'Stephan ', N'Jaramillo', 1, CAST(N'1980-08-15' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (37, N'Mordecai ', N'Richler', 1, CAST(N'1931-02-27' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (38, N'Eleanor ', N'Cooney', 1, CAST(N'1940-12-11' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (39, N'Charlotte ', N'Link', 1, CAST(N'1960-04-26' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (40, N'Richard North ', N'Patterson', 1, CAST(N'1947-02-22' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (41, N'Mark ', N'Salzman', 1, CAST(N'1963-01-15' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (42, N'Harper ', N'Lee', 1, CAST(N'1926-04-28' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (43, N'LAURA ', N'HILLENBRAND', 1, CAST(N'1967-05-15' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (44, N'Barbara ', N'Kingsolver', 1, CAST(N'1955-04-08' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (45, N'Jo ', N'Dereske', 1, CAST(N'1955-09-22' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (46, N'Jane ', N'Austen', 1, CAST(N'1775-12-16' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (47, N'Dolores ', N'Krieger', 1, CAST(N'1920-10-05' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (48, N'Anne Rivers ', N'Siddons', 1, CAST(N'1936-01-09' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (49, N'Dean R. ', N'Koontz', 1, CAST(N'1945-07-09' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (50, N'Mary Higgins ', N'Clark', 1, CAST(N'1927-12-24' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (51, N'Dean ', N'Koontz', 1, CAST(N'1961-07-09' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (52, N'Patricia ', N'Cornwell', 1, CAST(N'1956-06-09' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (53, N'J.D. ', N'Robb', 1, CAST(N'1950-10-02' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (54, N'Maeve ', N'Binchy', 1, CAST(N'1940-05-28' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (55, N'Laura J. ', N'Mixon', 1, CAST(N'1970-03-18' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (56, N'Tim ', N'Lahaye', 1, CAST(N'1926-04-27' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (57, N'JOHN ', N'GRISHAM', 1, CAST(N'1955-02-08' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (58, N'M.D. Bernie S. ', N'Siegel', 1, CAST(N'1932-10-14' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (59, N'Robert Penn ', N'Warren', 1, CAST(N'1905-04-24' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (60, N'Hans Johannes ', N'Hoefer', 1, CAST(N'1950-11-30' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (61, N'Mark ', N'Helprin', 1, CAST(N'1947-06-28' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (62, N'O. Carol Simonton ', N'Md', 1, CAST(N'1960-02-17' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (63, N'Chuck ', N'Hill', 1, CAST(N'1975-06-21' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (64, N'David ', N'Iglehart', 1, CAST(N'1945-09-04' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (65, N'Phiwokwakhe', N'Khathwane', 0, CAST(N'1980-01-01' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (77, N'Adam', N'Blade', 5, CAST(N'1985-03-15' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (131, N'Bottle', N'Neck', 0, CAST(N'2022-01-01' AS Date))
INSERT [dbo].[Author] ([Author_ID], [Author_Name], [Author_Surname], [Publications], [DOB]) VALUES (132, N'Yellow', N'Hog', 0, CAST(N'2022-01-01' AS Date))
SET IDENTITY_INSERT [dbo].[Author] OFF
GO
SET IDENTITY_INSERT [dbo].[Book] ON 

INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (5, N'0-195-15344-8', N'Classical Mythology', 2002, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (6, N'0-002-00501-8', N'Clara Callan', 2001, 1, N'Comedy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (7, N'0-060-97312-9', N'Decision in Normandy', 1991, 1, N'Drama')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (8, N'0-374-15706-5', N'Flu: The Story of the Great Influenza Pandemic of 1918 and the Search for the Virus That Caused It', 1999, 1, N'Documentary')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (9, N'0-393-04521-8', N'The Mummies of Urumchi', 1999, 1, N'Horror')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (10, N'0-399-13578-2', N'The Kitchen God''s Wife', 1991, 1, N'Thriller')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (11, N'0-425-17642-8', N'What If?: The World''s Foremost Military Historians Imagine What Might Have Been', 2000, 1, N'Drama')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (12, N'0-671-87043-2', N'PLEADING GUILTY', 1993, 1, N'Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (13, N'0-679-42560-8', N'Under the Black Flag: The Romance and the Reality of Life Among the Pirates', 1996, 1, N'Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (14, N'0-743-22678-3', N'Where You''ll Find Me: And Other Stories', 2002, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (15, N'0-771-07467-0', N'Nights Below Station Street', 1988, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (16, N'0-806-52121-2', N'Hitler''s Secret Bankers: The Myth of Swiss Neutrality During the Holocaust', 2000, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (17, N'0-887-84174-0', N'The Middle Stories', 2004, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (18, N'1-552-04177-8', N'Jane Doe', 1999, 1, N'Philisophy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (19, N'1-558-74621-8', N'A Second Chicken Soup for the Woman''s Soul (Chicken Soup for the Soul Series)', 1998, 1, N'Musical')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (20, N'1-567-40778-1', N'The Witchfinder (Amos Walker Mystery Series)', 1998, 1, N'Horror')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (21, N'1-575-66393-7', N'More Cunning Than Man: A Social History of Rats and Man', 1999, 1, N'Drama')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (22, N'1-881-32018-9', N'Goodbye to the Buttermilk Sky', 1994, 1, N'Horror')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (23, N'0-440-23474-3', N'The Testament', 1999, 1, N'Horror')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (24, N'0-452-26446-4', N'Beloved (Plume Contemporary Fiction)', 1994, 1, N'Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (25, N'0-609-80461-8', N'Our Dumb Century: The Onion Presents 100 Years of Headlines from America''s Finest News Source', 1999, 1, N'Drama')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (26, N'1-841-72152-2', N'New Vegetarian: Bold and Beautiful Recipes for Every Occasion', 2001, 1, N'Non-Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (27, N'1-879-38449-3', N'If I''d Known Then What I Know Now: Why Not Learn from the Mistakes of Others? : You Can''t Afford to Make Them All Yourself', 2003, 1, N'Philisophy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (28, N'0-061-07603-1', N'Mary-Kate &amp; Ashley Switching Goals (Mary-Kate and Ashley Starring in)', 2000, 1, N'Musical')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (29, N'0-439-09502-6', N'Tell Me This Isn''t Happening', 1999, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (30, N'0-689-82116-6', N'Flood : Mississippi 1927', 1998, 1, N'Fantasy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (31, N'0-971-88010-7', N'Wild Animus', 2004, 1, N'Philisophy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (32, N'0-345-40287-1', N'Airframe', 1997, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (33, N'0-345-41762-3', N'Timeline', 2000, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (34, N'0-684-82380-2', N'OUT OF THE SILENT PLANET', 1996, 1, N'Philisophy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (35, N'0-375-75977-8', N'Prague : A Novel', 2003, 1, N'Thriller')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (36, N'0-425-16309-1', N'Chocolate Jesus', 1998, 1, N'Action')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (37, N'3-404-92103-8', N'Wie Barney es sieht.', 2002, 1, N'Musical')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (38, N'3-442-35386-6', N'Der Fluch der Kaiserin. Ein Richter- Di- Roman.', 2001, 1, N'Action')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (39, N'3-442-41066-5', N'Sturmzeit. Roman.', 1991, 1, N'Fantasy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (40, N'3-442-44693-7', N'Tage der Unschuld.', 2000, 1, N'Thriller')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (41, N'0-375-40632-8', N'Lying Awake', 2000, 1, N'Drama')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (42, N'0-446-31078-6', N'To Kill a Mockingbird', 1988, 1, N'Drama')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (43, N'0-449-00561-5', N'Seabiscuit: An American Legend', 2002, 1, N'Musical')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (44, N'0-060-16801-3', N'Pigs in Heaven', 1993, 1, N'Action')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (45, N'0-380-78243-8', N'Miss Zukas and the Raven''s Dance', 1996, 1, N'Action')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (46, N'0-553-21215-7', N'Pride and Prejudice', 1983, 1, N'Drama')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (47, N'0-671-76537-3', N'The Therapeutic Touch: How to Use Your Hands to Help or to Heal', 1979, 1, N'Fantasy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (48, N'0-061-09968-6', N'Downtown', 1995, 1, N'Non-Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (49, N'0-553-58290-9', N'Icebound', 2000, 1, N'Non-Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (50, N'0-671-88858-7', N'I''ll Be Seeing You', 1994, 1, N'Horror')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (51, N'0-553-58274-7', N'From the Corner of His Eye', 2001, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (52, N'0-425-18290-8', N'Isle of Dogs', 2002, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (53, N'0-425-18630-9', N'Purity in Death', 2002, 1, N'Fantasy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (54, N'0-440-22357-1', N'This Year It Will Be Different: And Other Stories', 1997, 1, N'Non-Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (55, N'0-812-52387-3', N'Proxies', 1999, 1, N'Mystery')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (56, N'0-842-34270-2', N'Left Behind: A Novel of the Earth''s Last Days (Left Behind #1)', 2000, 1, N'Fantasy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (57, N'0-440-22570-1', N'The Street Lawyer', 1999, 1, N'Horror')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (58, N'0-060-91406-8', N'Love, Medicine and Miracles', 1988, 1, N'Romance')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (59, N'0-156-04762-4', N'All the King''s Men', 1982, 1, N'Romance')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (60, N'0-245-54295-7', N'Pacific Northwest', 1985, 1, N'Thriller')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (61, N'0-380-71589-9', N'A Soldier of the Great War', 1992, 1, N'Action')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (62, N'0-553-28033-3', N'Getting Well Again', 1992, 1, N'Musical')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (63, N'0-961-76994-7', N'Northwest Wines and Wineries', 1993, 1, N'Fantasy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (64, N'0-964-77831-9', N'An Atmosphere of Eternity: Stories of India', 2002, 1, N'Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (65, N'5-569-85456-8', N'The Storm', 2000, 10, N'Fantasy')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (69, N'0-399-13579-2', N'Some random book', 2024, 6, N'Action')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (85, N'545-6-314-52354-6', N'Beast Quest: Stealth - The ghoust panther', 2010, 5, N'Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (86, N'978-1-408-34814-7', N'Beast Quest: Koldo - The arctic warrior', 2010, 5, N'Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (87, N'978-1-408-32401-1', N'Beast Quest: Silver - The Wild Terror', 2010, 5, N'Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (88, N'978-1-408-32401-1', N'Beast Quest: Kama - The faceless beast', 2015, 5, N'Fiction')
INSERT [dbo].[Book] ([Book_ID], [Book_ISBN], [Book_Title], [PublicationYear], [Quantity], [Genre]) VALUES (89, N'978-1-408-32401-1', N'Beast Quest: Vermok the Spiteful Scavenger', 2010, 5, N'Fiction')
SET IDENTITY_INSERT [dbo].[Book] OFF
GO
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (5, 5)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (5, 6)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (6, 6)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (7, 7)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (8, 8)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (9, 9)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (10, 10)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (11, 11)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (12, 12)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (13, 13)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (14, 14)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (15, 15)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (16, 16)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (17, 17)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (18, 18)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (19, 19)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (20, 20)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (20, 21)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (21, 21)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (22, 22)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (23, 23)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (24, 24)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (25, 20)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (25, 25)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (26, 11)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (26, 26)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (27, 27)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (28, 28)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (29, 29)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (30, 30)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (31, 31)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (32, 32)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (33, 33)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (34, 34)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (35, 25)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (35, 35)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (36, 36)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (37, 37)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (38, 38)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (39, 39)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (40, 40)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (41, 41)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (42, 42)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (43, 43)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (44, 44)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (45, 45)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (46, 46)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (47, 47)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (48, 48)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (49, 49)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (50, 50)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (51, 51)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (52, 52)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (53, 53)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (54, 54)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (55, 55)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (56, 56)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (57, 57)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (58, 5)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (58, 11)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (58, 58)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (59, 59)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (60, 60)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (61, 61)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (62, 62)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (63, 63)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (64, 64)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (69, 5)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (69, 10)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (69, 11)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (85, 77)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (86, 77)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (87, 77)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (88, 77)
INSERT [dbo].[BookAuthor] ([Book_ID], [Author_ID]) VALUES (89, 77)
GO
ALTER TABLE [dbo].[BookAuthor]  WITH CHECK ADD  CONSTRAINT [FK_BookAuthor_Author] FOREIGN KEY([Author_ID])
REFERENCES [dbo].[Author] ([Author_ID])
GO
ALTER TABLE [dbo].[BookAuthor] CHECK CONSTRAINT [FK_BookAuthor_Author]
GO
ALTER TABLE [dbo].[BookAuthor]  WITH CHECK ADD  CONSTRAINT [FK_BookAuthor_Book] FOREIGN KEY([Book_ID])
REFERENCES [dbo].[Book] ([Book_ID])
GO
ALTER TABLE [dbo].[BookAuthor] CHECK CONSTRAINT [FK_BookAuthor_Book]
GO
/****** Object:  StoredProcedure [dbo].[helper_proc_ExtractAuthorsToTable]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[helper_proc_ExtractAuthorsToTable]
                 @Authors               VARCHAR(MAX)
AS 
BEGIN
    --=====================================================================
    --Procedure Name: helper_proc_ExtractAuthorsToTable
    --Description: This helper procedure extracts author information from a 
    --             formatted string and inserts it into a temporary table. 
    --             It utilizes the SplitBookInfo function to parse the author 
    --             records into separate fields.
    --
    --Parameters:
    --    @Authors (VARCHAR(MAX)): A string containing author records formatted as:
    --             id1,''name1'', ''surname1'',''yyyy/mm/dd'';id2,''name2'',''surname2'',''yyyy/mm/dd';...
    --             Each author record should be separated by a semicolon (;).
    -- 
    --Return Values: 
    --    Returns the records from the temporary table containing extracted 
    --    author details (ID, AuthorName, AuthorSurname, DOB).
    --
    --Example Call: 
    --    EXEC helper_proc_ExtractAuthorsToTable 
    --        @Authors = '0,''John'',''Doe'',''1986/12/15'';0,''Jane'',''Smith'',''1761/12/25''';
    --
    --Note: This procedure uses the STRING_SPLIT function available in SQL Server 
    --      for breaking the input string into records.
    --=====================================================================
    
    --Create a tempory author table for authors
    CREATE TABLE #TempAuthors 
    (
         [ID] INT,
         AuthorName         NVARCHAR(150),
         AuthorSurname      NVARCHAR(150),
         DateOfBirth                DATE
    );
    DECLARE @AuthorRecord   NVARCHAR(300);
    --Create a curso that will go through the author records
    DECLARE AuthorRecordCursor CURSOR FOR
    SELECT VALUE FROM STRING_SPLIT(@Authors, ';') WHERE VALUE <> '';  -- Break the string into records

    OPEN AuthorRecordCursor;
    FETCH NEXT FROM AuthorRecordCursor INTO @AuthorRecord;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        --Split the record and extract the output results using the function
        INSERT INTO #TempAuthors([ID], AuthorName, AuthorSurname, DateOfBirth)
        SELECT TOP 1 [ID], [Name], Surname, DOB
        FROM dbo.func_SplitAuthorInfo(@AuthorRecord);

        FETCH NEXT FROM AuthorRecordCursor INTO @AuthorRecord;
    END;

    SELECT * FROM #TempAuthors;

    --Clean- up
    CLOSE AuthorRecordCursor;
    DEALLOCATE AuthorRecordCursor;
    DROP TABLE #TempAuthors;
END;
GO
/****** Object:  StoredProcedure [dbo].[proc_AddBook]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_AddBook]
                --For the book table
                @Book_ISBN          VARCHAR(20),
                @Book_Title         NVARCHAR(500),
                @Quantity           SMALLINT,
                @Publication        SMALLINT,
                @Genre              VARCHAR(200),
                @Book_ID            INT OUTPUT, -- ID of the book needed on the client side

                @Authors            VARCHAR(MAX)  -- Author details formatted as described below
AS
BEGIN
/*
    -- =====================================================================
    -- Procedure Name: proc_AddBook
    -- Description: Inserts a new book into the Book table and associates it 
    --              with its authors. Author details must be passed in a specific 
    --              format to be processed and inserted into the Author table.
    --
    -- Parameters:
    --     @Book_ISBN (VARCHAR(20)): ISBN of the book.
    --     @Book_Title (NVARCHAR(500)): Title of the book.
    --     @Quantity (SMALLINT): Quantity of the book.
    --     @Publication (SMALLINT): Publication year of the book.
    --     @Genre (VARCHAR(200)): Genre of the book.
    --     @Book_ID (INT OUTPUT): Output parameter to return the ID of the newly 
    --                            inserted book.
    --     @Authors (VARCHAR(MAX)): Author details formatted as:
    --         id1,''name1'', ''surname1'','dob1';id2,''name2'',''surname2'',''dob2'';...
    --         where id is 0 to add a new author, and each field is 
    --         separated by a comma, with double single quotes as text qualifiers.
               --Note: The date is formatted as follows: yyyy/mm/dd

    
    -- Error Handling: The procedure rolls back the transaction if any error 
    --                 occurs during the insertion of the book or authors.
    --
    -- Example Call: EXEC proc_AddBook 
    --                @Book_ISBN = '1234567890123', 
    --                @Book_Title = N'Example Book', 
    --                @Quantity = 10, 
    --                @Publication = 2023, 
    --                @Genre = 'Fiction', 
    --                @Book_ID = @OutputBookID OUTPUT, 
    --                @Authors = '0,''John'',''Doe'',''1986/01/03'';0,''Jane'',''Smith'',''1667/03/01''';

    -- Example Output:
    --     Book_ID         | Author_ID
    --     ----------------------------
    --          5          | 1
    --          5          | 2
    --
    -- This output returns the Book_ID and Author_ID(s) of the inserted or associated authors.
    -- The order of the author Id's is the sme as in the @Authors string
    -- =====================================================================
*/

    BEGIN TRANSACTION trans1

        --Add the book to the book-table
        INSERT INTO Book(Book_ISBN, Book_Title, Quantity, PublicationYear, Genre)
        VALUES(@Book_ISBN,@Book_Title,@Quantity,@Publication,@Genre);

        --Check if the insertion was susccessful
        IF @@ERROR <> 0
        BEGIN
            --Rollback the changes
            ROLLBACK TRANSACTION trans1
            SET @Book_ID = NULL;
            RETURN;
        END

        --SET THE BOOK ID
        SET @Book_ID = SCOPE_IDENTITY();

        --Create a tempory author table for authors
        CREATE TABLE #TempAuthorsDet 
        (
            [ID] INT,
            AuthorName         NVARCHAR(150),
            AuthorSurname      NVARCHAR(150),
            DOB                DATE
        );

        --Temporary variable for the author details for the cursor
        DECLARE @AuthorID       INT,
                @AuthorName     NVARCHAR(100),
                @AuthorSurname  NVARCHAR(100),
                @DOB            DATE, 
                @AuthorID_test  INT; --This will be used to check if an author with the same name exists

        
        INSERT INTO #TempAuthorsDet(ID, AuthorName, AuthorSurname, DOB)
        EXEC helper_proc_ExtractAuthorsToTable @Authors; --Insert the data of the other procedure to the temporary table

        --Create a cursor to loop through all the authors in the table
        DECLARE Author_Cursor CURSOR FOR 
        SELECT * FROM #TempAuthorsDet; 

        OPEN Author_Cursor;
        FETCH NEXT FROM Author_Cursor INTO @AuthorID, @AuthorName, @AuthorSurname, @DOB;

        WHILE @@FETCH_STATUS = 0
        BEGIN

            --Here we might need to also check if we are not duplicating authors(autho)
            --Check if an author with the same names exists
            SET @AuthorID_test = (SELECT Top 1 Author_ID FROM Author WHERE Author_Name = @AuthorName AND Author_Surname = @AuthorSurname AND DOB = @DOB);

            IF @AuthorID_test IS NOT NULL
            BEGIN
                --UPDATE THE TEMPORARY TABLE
                UPDATE #TempAuthorsDet 
                SET [ID] = @AuthorID_test
                WHERE AuthorName = @AuthorName
                AND   AuthorSurname = @AuthorSurname
                AND DOB = @DOB;

                --Update the authorID 
                SET @AuthorID = @AuthorID_test;
            END
            --Check if the author exists(by id)
            ELSE IF NOT EXISTS (SELECT Author_Name FROM Author WHERE Author_ID = @AuthorID)
            BEGIN
                --Create a new author record
                INSERT INTO Author(Author_Name, Author_Surname, Publications, DOB)
                VALUES(@AuthorName, @AuthorSurname, 0, @DOB);

                --Check if we had an error
                IF @@ERROR <> 0
                BEGIN
                    -- Cleanup before returning
                    CLOSE Author_Cursor;
                    DEALLOCATE Author_Cursor;
                
                    -- Rollback and return
                    ROLLBACK TRANSACTION trans1;
                    SET @Book_ID = NULL;
                    RETURN;
                END

                
                --Update the id in the temp_table
                UPDATE #TempAuthorsDet
                SET ID = SCOPE_IDENTITY()
                WHERE ID = @AuthorID 
                AND   AuthorName = @AuthorName
                AND   AuthorSurname = @AuthorSurname
                AND   DOB = @DOB;
                
                --Set the ID to the last generates ID
                SET @AuthorID = SCOPE_IDENTITY()
                
            END

            --Here the Author Exists in our database
            --Link the bookl and the author
            INSERT INTO BookAuthor(Book_ID, Author_ID)
            VALUES(@Book_ID, @AuthorID);

             --Check if we had an error
            IF @@ERROR <> 0
            BEGIN
                -- Cleanup before returning
                CLOSE Author_Cursor;
                DEALLOCATE Author_Cursor;
            
                -- Rollback and return
                ROLLBACK TRANSACTION trans1;
                SET @Book_ID = NULL;
                RETURN;
            END

            --Fetch the next record
            FETCH NEXT FROM Author_Cursor INTO @AuthorID, @AuthorName, @AuthorSurname, @DOB;
        END
    --Commit changes
    COMMIT TRANSACTION trans1

    --Return the results to the calling application
    SELECT @Book_ID AS Book_ID, #TempAuthorsDet.ID AS Author_ID
    FROM #TempAuthorsDet;
    
    --Clean-up
    CLOSE Author_Cursor;
    DEALLOCATE Author_Cursor;

    DROP TABLE #TempAuthorsDet;
END;
GO
/****** Object:  StoredProcedure [dbo].[proc_AddUpdateAuthor]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_AddUpdateAuthor]
    @AuthorName         NVARCHAR(100), 
    @AuthorSurname      NVARCHAR(100),
    @DOB                DATE,
    @AuthorID           INT OUTPUT
AS 
BEGIN
    -- =====================================================================
    -- Procedure Name: proc_AddUpdateAuthor
    -- Description: This procedure checks if an author exists in the database. 
    --              If the author exists, it updates their details; if not, 
    --              it creates a new author record. The AuthorID is returned 
    --              as an output parameter.
    --
    -- Parameters:
    --     @AuthorName (NVARCHAR(100)): The name of the author.
    --     @AuthorSurname (NVARCHAR(100)): The surname of the author.
    --     @AuthorID (INT OUTPUT): The ID of the author. If the author exists, 
    --                              it remains the same; otherwise, it is 
    --                              set to the new author's ID.
    --
    -- Return Values:
    -- Return -1 for any caught errors
    --     1: Operation completed successfully.
    --
    -- Example Call: 
    --     DECLARE @AuthorID INT;
    --     EXEC proc_AddUpdateAuthor @AuthorName = N'John', 
    --                                @AuthorSurname = N'Doe', 
    --                                @AuthorID = @AuthorID OUTPUT,
    --                                @DOB      = '22/03/202454'          (This is in the format : dd/mm/yyyy)
    -- =====================================================================
    BEGIN TRY
        -- Check if the author exists
        IF EXISTS (SELECT * FROM Author WHERE Author_ID = @AuthorID)
        BEGIN
            -- Author exists, update the author's details
            UPDATE Author
            SET Author_Name = @AuthorName,
                Author_Surname = @AuthorSurname, 
                DOB = @DOB
            WHERE Author_ID = @AuthorID;

            -- Check if the update was successful
            IF @@ROWCOUNT = 0 
            BEGIN
                RETURN -1;  -- Return -1 for update failure
            END
        END
        ELSE
        BEGIN
            -- Author does not exist, insert a new author
            INSERT INTO Author(Author_Name, Author_Surname, DOB)
            VALUES(@AuthorName, @AuthorSurname, @DOB);

            -- Retrieve the new AuthorID
            SET @AuthorID = SCOPE_IDENTITY();  
        END;

        -- Return 1 for successful operation
        RETURN 1;
    END TRY
    BEGIN CATCH
        -- Handle errors that occur during the execution of SQL statements.
        -- Note: Some errors, such as syntax errors or permission issues, 
        -- may not be caught by TRY...CATCH.

        RETURN -1;  -- Return -1 for any caught errors
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[proc_FilterBook]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_FilterBook] 
                @Book_Title             NVARCHAR(300),
                @Genre                  VARCHAR(100),
                @AuthorName             NVARCHAR(100),
                @AuthorSurname          NVARCHAR(100),
                @MustContainValues      BIT
AS
BEGIN
    /*
    -- =====================================================================
    -- PROCEDURE: proc_FilterBook
    --
    -- Description:
    --     This procedure dynamically filters books based on the provided
    --     parameters, such as book title, genre, author name, and author 
    --     surname. It also has a flag, `MustContainValues`, to specify 
    --     whether all provided criteria must be matched or whether any 
    --     of them can be matched.
    --
    -- Parameters:
    --     @Book_Title        NVARCHAR(300)   -- Filter by book title
    --     @Genre             VARCHAR(100)    -- Filter by genre
    --     @AuthorName        NVARCHAR(100)   -- Filter by author name
    --     @AuthorSurname     NVARCHAR(100)   -- Filter by author surname
    --     @MustContainValues BIT             -- 1 = Must match all criteria, 0 = Match any criteria
    --
    -- Notes:
    --     - The procedure constructs a dynamic SQL query to filter books
    --       based on the provided criteria.
    --     - The `MustContainValues` parameter determines whether the filter 
    --       conditions should all be met (`AND`) or if any of the conditions 
    --       can be met (`OR`).
    --     - The procedure filters books using a JOIN between the `Book`,
    --       `BookAuthor`, and `Author` tables.
    --
    -- Example Usage:
    --     - Find books with title containing 'Harry' and genre 'Fantasy':
    --       EXEC proc_FilterBook @Book_Title = 'Harry', @Genre = 'Fantasy', @MustContainValues = 1;
    --
    --     - Find books by author name 'J.K.' or surname 'Rowling':
    --       EXEC proc_FilterBook @AuthorName = 'J.K.', @AuthorSurname = 'owling', @MustContainValues = 0;
    -- =====================================================================
    */
    
    DECLARE @Sql          VARCHAR(MAX),
            @BracketAdded BIT;

    SET @BracketAdded = 0;

    SET @Sql = 'SELECT Book.Book_ID, 
                    Book.Book_ISBN, 
                    Book.Book_Title, 
                    Book.Genre, 
                    Book.PublicationYear, 
                    Book.Quantity, 
                    Author.Author_ID, 
                    Author.Author_Name, 
                    Author.Author_Surname, 
                    Author.DOB, 
                    Author.Publications AS AuthorPublications 
                FROM Book   
                INNER JOIN BookAuthor ON BookAuthor.Book_ID = Book.Book_ID 
                INNER JOIN Author ON BookAuthor.Author_ID = Author.Author_ID 
                WHERE 1 =1 '; 

    DECLARE @FilterAdded BIT = 0;

    IF(@Book_Title IS NOT NULL AND @Book_Title <> '')
    BEGIN
        IF @MustContainValues = 1
            SET @Sql = @Sql + ' AND Book.Book_Title LIKE ''%' + @Book_Title + '%''';
        ELSE
        BEGIN
            SET @Sql = @Sql + ' AND (Book.Book_Title LIKE ''' + @Book_Title + '%''';
            SET @FilterAdded = 1;
        END
    END

    IF(@Genre IS NOT NULL AND @Genre <> '')
    BEGIN
        IF @MustContainValues = 1
            SET @Sql = @Sql + ' AND Genre LIKE ''%' + @Genre + '%''';
        ELSE
        BEGIN
            IF @FilterAdded = 1
                SET @Sql = @Sql + ' OR Genre LIKE ''' + @Genre + '%''';
            ELSE
            BEGIN
                SET @Sql = @Sql + ' AND ( Genre LIKE ''' + @Genre + '%''';
                SET @FilterAdded = 1;
            END
        END
    END

    IF(@AuthorName IS NOT NULL AND @AuthorName <> '')
    BEGIN
        IF @MustContainValues = 1
            SET @Sql = @Sql + ' AND Author.Author_Name LIKE ''%' + @AuthorName + '%''';
        ELSE
        BEGIN
            IF @FilterAdded = 1
                SET @Sql = @Sql + ' OR Author.Author_Name LIKE ''' + @AuthorName + '%''';
            ELSE
            BEGIN
                SET @Sql = @Sql + ' AND ( Author.Author_Name LIKE ''' + @AuthorName + '%''';
                SET @FilterAdded = 1;
            END
        END
    END

    IF(@AuthorSurname IS NOT NULL AND @AuthorSurname <> '')
    BEGIN
        IF @MustContainValues = 1
            SET @Sql = @Sql + ' AND Author.Author_Surname LIKE ''%' + @AuthorSurname + '%''';
        ELSE
        BEGIN
            IF @FilterAdded = 1
                SET @Sql = @Sql + ' OR Author.Author_Surname LIKE ''' + @AuthorSurname + '%''';
            ELSE
            BEGIN
                SET @Sql = @Sql + ' AND ( Author.Author_Surname LIKE ''' + @AuthorSurname + '%''';
                SET @FilterAdded = 1;
            END
        END
    END

    IF @FilterAdded = 1
        SET @Sql = @Sql + ' )'; 

    EXEC(@Sql);
END;
GO
/****** Object:  StoredProcedure [dbo].[proc_FindBookByISBN]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_FindBookByISBN]
                @BookISBN       VARCHAR(20)
AS
BEGIN
    -- =====================================================================
    -- Procedure Name: proc_FindBookByISBN
    -- Description: Retrieves book details based on the provided ISBN and 
    --              returns the associated authors and their publication counts.
    --
    -- Parameters:
    --     @BookISBN (VARCHAR(20)): The ISBN of the book to search for.
    --
    -- Output:
    --     Book_ID (INT): ID of the book.
    --     Book_ISBN (VARCHAR(20)): ISBN of the book.
    --     Book_Title (NVARCHAR(500)): Title of the book.
    --     Genre (VARCHAR(200)): Genre of the book.
    --     PublicationYear (SMALLINT): Year the book was published.
    --     Quantity (SMALLINT): Number of copies available.
    --     Author_ID (INT): ID of the author.
    --     Author_Name (NVARCHAR(150)): Name of the author.
    --     Author_Surname (NVARCHAR(150)): Surname of the author.
    --     AuthorPublications (INT): Number of publications by the author.
    --
    -- Example Call: EXEC proc_FindBookByISBN @BookISBN = '1234567890123';
    -- =====================================================================

    SELECT Book.Book_ID,
           Book.Book_ISBN,
           Book.Book_Title,
           Book.Genre,
           Book.PublicationYear,
           Book.Quantity,
           Author.Author_ID,
           Author.Author_Name,
           Author.Author_Surname,
           Author.DOB,
           Author.Publications AS AuthorPublications
    FROM Book
    INNER JOIN BookAuthor
        ON Book.Book_ISBN = @BookISBN --Filter the books before joining
        AND Book.Book_ID = BookAuthor.Book_ID
    INNER JOIN Author
        ON BookAuthor.Author_ID = Author.Author_ID;
END
GO
/****** Object:  StoredProcedure [dbo].[proc_LoadAllBooks]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_LoadAllBooks]
AS
BEGIN
-- =====================================================================
-- Procedure Name: proc_LoadAllBook
-- Description: Retrieves all books from the database along with their 
--              associated authors' details. This procedure joins the 
--              Book, BookAuthor, and Author tables to return book 
--              information and the corresponding authors for each book.
--
-- Parameters:
--     None
--
-- Return Values:
--     The procedure returns the following columns for each book:
--         - Book_ID (INT): Unique identifier of the book.
--         - Book_ISBN (VARCHAR(20)): ISBN of the book.
--         - Book_Title (NVARCHAR(500)): Title of the book.
--         - Genre (VARCHAR(200)): Genre of the book.
--         - PublicationYear (SMALLINT): Year the book was published.
--         - Quantity (SMALLINT): Quantity of the book available.
--         - Author_ID (INT): Unique identifier of the author.
--         - Author_Name (NVARCHAR(150)): First name of the author.
--         - Author_Surname (NVARCHAR(150)): Last name of the author.
--         - AuthorPublications (INT): Number of publications by the author.
--
-- Example Call: EXEC proc_LoadAllBook;
-- =====================================================================

    SELECT Book.Book_ID,
       Book.Book_ISBN,
       Book.Book_Title,
       Book.Genre,
       Book.PublicationYear,
       Book.Quantity,
       Author.Author_ID,
       Author.Author_Name,
       Author.Author_Surname,
       Author.DOB,
       Author.Publications AS AuthorPublications
    FROM Book
    INNER JOIN BookAuthor
        ON Book.Book_ID = BookAuthor.Book_ID
    INNER JOIN Author
        ON BookAuthor.Author_ID = Author.Author_ID;
END;
GO
/****** Object:  StoredProcedure [dbo].[proc_RemoveBook]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_RemoveBook]
                 @BookID        INT
AS
BEGIN
    -- Start a database transaction
    BEGIN TRANSACTION 

    -- First, check if the book exists in the Book table using the provided BookID
    IF EXISTS (SELECT Book_ID FROM Book WHERE Book.Book_ID = @BookID)
    BEGIN
        -- If the book exists, delete its relationships in the BookAuthor table
        DELETE FROM BookAuthor
        WHERE Book_ID = @BookID;

        -- Check if an error occurred during the deletion in the BookAuthor table
        IF @@ERROR <> 0
        BEGIN
            -- If an error occurred, roll back the transaction and return -1 to indicate failure
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- After successfully removing the relationships, delete the book itself from the Book table
        DELETE FROM Book
        WHERE Book_ID = @BookID;

        -- Check if an error occurred during the deletion in the Book table
        IF @@ERROR <> 0
        BEGIN
            -- If an error occurred, roll back the transaction and return -1 to indicate failure
            ROLLBACK TRANSACTION;
            RETURN -1;
        END
    END

    -- Commit the transaction if everything executed successfully
    COMMIT TRANSACTION

    -- Return 1 to indicate that the removal operation was successful
    RETURN 1;
END
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateBook]    Script Date: 2024/11/23 22:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_UpdateBook]
                 --For the book table
                @Book_ISBN          VARCHAR(20),
                @Book_Title         NVARCHAR(500),
                @Quantity           SMALLINT,
                @Publication        SMALLINT,
                @Genre              VARCHAR(200),
                @Book_ID            INT,

                @Authors            VARCHAR(MAX)
AS
BEGIN 
    -- =====================================================================
    -- Procedure Name: proc_UpdateBook
    -- Description: Updates an existing book's details in the Book table 
    --              and replaces its associated authors with new entries 
    --              provided in the format specified. All previous authors 
    --              will be removed before linking the new authors.
    --
    -- Parameters:
    --     @Book_ISBN (VARCHAR(20)): ISBN of the book.
    --     @Book_Title (NVARCHAR(500)): Title of the book.
    --     @Quantity (SMALLINT): Quantity of the book.
    --     @Publication (SMALLINT): Publication year of the book.
    --     @Genre (VARCHAR(200)): Genre of the book.
    --     @Book_ID (INT ): ID of the updated book.
    --     @Authors (VARCHAR(MAX)): Author details formatted as:
    --         id1,''name1'', ''surname1'';id2,''name2'',''surname2'';...
    --         where id is 0 to add a new author, and each field is 
    --         separated by a comma, with double single quotes as text qualifiers.
    --
    -- Return Values:
    --     0: An error occurred during the update process.
    --     -1: An error occurred during deletion or author insertion.
    --     1: Update and author replacement completed successfully.
    --
    -- Example Call: EXEC proc_UpdateBook 
    --                @Book_ISBN = '1234567890123', 
    --                @Book_Title = N'Updated Book Title', 
    --                @Quantity = 5, 
    --                @Publication = 2024, 
    --                @Genre = 'Non-Fiction', 
    --                @Book_ID = @OutputBookID OUTPUT, 
    --                @Authors = '2,''Alice'',''Smith'';3,''Bob'',''Johnson''';
    -- =====================================================================

    BEGIN TRANSACTION tras1

    --Create a tempory author table for authors
    CREATE TABLE #TempAuthorsDet 
    (
        [ID] INT,
        AuthorName         NVARCHAR(150),
        AuthorSurname      NVARCHAR(150), 
        DOB                DATE
    );

    --First update the book table
    UPDATE Book
    SET Book_ISBN = @Book_ISBN,
        Book_Title = @Book_Title,
        Quantity = @Quantity,
        PublicationYear = @Publication,
        Genre = @Genre
    WHERE Book_ID = @Book_ID;

    --Check if there wan an update or an error 
    --If there was no change an error, we need to abort
    IF @@ERROR <> 0 OR @@ROWCOUNT < 1
    BEGIN
        ROLLBACK TRANSACTION trans1;
        RETURN 0;
    END

    --Here the book update was a success 
    --Remove all the authors linked to the book, they will be relinked again
    DELETE FROM BookAuthor
    WHERE Book_ID = @Book_ID;

    IF @@ERROR <> 0
    BEGIN 
        ROLLBACK TRANSACTION trans1;
        RETURN -1;
    END

    --Extract the authors string and add them to the temporary table
    INSERT INTO #TempAuthorsDet(ID, AuthorName, AuthorSurname, DOB)
    EXEC dbo.helper_proc_ExtractAuthorsToTable @Authors;

    IF @@ERROR <> 0
    BEGIN 
        ROLLBACK TRANSACTION trans1;
        RETURN -1;
    END

    --Re-link the authors and books
    --We assume that the authors have already been added to the database
    INSERT INTO BookAuthor(Book_ID, Author_ID)
    SELECT @Book_ID AS Book_ID, [ID] AS Author_ID
    FROM #TempAuthorsDet;

        IF @@ERROR <> 0
    BEGIN 
        ROLLBACK TRANSACTION trans1;
        RETURN -1;
    END

    DROP TABLE #TempAuthorsDet;
    COMMIT TRANSACTION trans1;

    RETURN 1;
END;
GO
USE [master]
GO
ALTER DATABASE [BookInventory] SET  READ_WRITE 
GO
