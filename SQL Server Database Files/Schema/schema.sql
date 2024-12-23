USE [BookInventory]
GO
/****** Object:  Table [dbo].[Author]    Script Date: 2024/11/23 16:34:25 ******/
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
/****** Object:  Table [dbo].[Book]    Script Date: 2024/11/23 16:34:25 ******/
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
/****** Object:  Table [dbo].[BookAuthor]    Script Date: 2024/11/23 16:34:25 ******/
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
