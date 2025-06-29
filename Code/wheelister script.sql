USE [master]
GO
/****** Object:  Database [WHEELISTER]    Script Date: 03/05/2025 5:11:16 pm ******/
CREATE DATABASE [WHEELISTER]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WHEELISTER', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS1\MSSQL\DATA\WHEELISTER.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'WHEELISTER_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS1\MSSQL\DATA\WHEELISTER_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [WHEELISTER] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WHEELISTER].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WHEELISTER] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WHEELISTER] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WHEELISTER] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WHEELISTER] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WHEELISTER] SET ARITHABORT OFF 
GO
ALTER DATABASE [WHEELISTER] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [WHEELISTER] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WHEELISTER] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WHEELISTER] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WHEELISTER] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WHEELISTER] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WHEELISTER] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WHEELISTER] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WHEELISTER] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WHEELISTER] SET  ENABLE_BROKER 
GO
ALTER DATABASE [WHEELISTER] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WHEELISTER] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WHEELISTER] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WHEELISTER] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WHEELISTER] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WHEELISTER] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WHEELISTER] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WHEELISTER] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [WHEELISTER] SET  MULTI_USER 
GO
ALTER DATABASE [WHEELISTER] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WHEELISTER] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WHEELISTER] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WHEELISTER] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [WHEELISTER] SET DELAYED_DURABILITY = DISABLED 
GO
USE [WHEELISTER]
GO
/****** Object:  Table [dbo].[admins]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[admins](
	[adminID] [int] IDENTITY(1,1) NOT NULL,
	[admin_name] [varchar](20) NULL,
	[warehouse_no] [int] NULL,
	[phone_number] [varchar](14) NULL,
	[email_address] [varchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[adminID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bookings]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bookings](
	[userID] [int] NULL,
	[warehouse_no] [int] NULL,
	[bookingID] [int] IDENTITY(1,1) NOT NULL,
	[pickup_date] [date] NOT NULL,
	[return_date] [date] NOT NULL,
	[rental_period] [varchar](50) NOT NULL,
	[pickup_location] [varchar](255) NOT NULL,
	[booking_price] [decimal](10, 2) NOT NULL,
	[booking_timestamp] [datetime] NULL,
	[booking_status] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[bookingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[car_bookings]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[car_bookings](
	[booking_id] [int] IDENTITY(1,1) NOT NULL,
	[car_name] [nvarchar](100) NOT NULL,
	[pickup_date] [date] NULL,
	[return_date] [date] NULL,
	[rental_period] [nvarchar](50) NOT NULL,
	[pickup_location] [nvarchar](100) NOT NULL,
	[total_price] [nvarchar](50) NOT NULL,
	[booking_date] [datetime] NOT NULL,
	[userID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[booking_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cars]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cars](
	[car_no] [int] NOT NULL,
	[warehouse_no] [int] NULL,
	[car_name] [varchar](20) NULL,
	[car_miles] [int] NULL,
	[car_booking_price] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[car_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[users]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[users](
	[userID] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](40) NULL,
	[email] [varchar](30) NULL,
	[mobilenumber] [varchar](20) NULL,
	[location] [varchar](50) NULL,
	[loyaltypoints] [int] NULL CONSTRAINT [DF_ColumnName_DefaultZero]  DEFAULT ((0)),
	[password] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[userID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[warehouse]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[warehouse](
	[warehouse_no] [int] IDENTITY(1,1) NOT NULL,
	[warehouse_name] [varchar](20) NULL,
	[address] [varchar](max) NULL,
	[phonenumber] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[warehouse_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[bookings] ADD  DEFAULT (getdate()) FOR [booking_timestamp]
GO
ALTER TABLE [dbo].[bookings] ADD  DEFAULT ('Pending') FOR [booking_status]
GO
ALTER TABLE [dbo].[admins]  WITH CHECK ADD FOREIGN KEY([warehouse_no])
REFERENCES [dbo].[warehouse] ([warehouse_no])
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD FOREIGN KEY([userID])
REFERENCES [dbo].[users] ([userID])
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD FOREIGN KEY([warehouse_no])
REFERENCES [dbo].[warehouse] ([warehouse_no])
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD  CONSTRAINT [fk_userID] FOREIGN KEY([userID])
REFERENCES [dbo].[users] ([userID])
GO
ALTER TABLE [dbo].[bookings] CHECK CONSTRAINT [fk_userID]
GO
ALTER TABLE [dbo].[car_bookings]  WITH CHECK ADD  CONSTRAINT [fk_userID_new] FOREIGN KEY([userID])
REFERENCES [dbo].[users] ([userID])
GO
ALTER TABLE [dbo].[car_bookings] CHECK CONSTRAINT [fk_userID_new]
GO
ALTER TABLE [dbo].[cars]  WITH CHECK ADD FOREIGN KEY([warehouse_no])
REFERENCES [dbo].[warehouse] ([warehouse_no])
GO
/****** Object:  StoredProcedure [dbo].[CheckUserLogin]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CheckUserLogin]
    @Username NVARCHAR(100),
    @Password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the user exists and matches the password
    SELECT * FROM Users WHERE Username = @Username AND Password = @Password;
END;

GO
/****** Object:  StoredProcedure [dbo].[InsertBooking]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertBooking]
    @CarName NVARCHAR(100),
    @PickupDate DATETIME,
    @ReturnDate DATETIME,
    @RentalPeriod NVARCHAR(50),
    @PickupLocation NVARCHAR(100)
AS
BEGIN
    -- Insert the booking into the bookings table
    INSERT INTO car_booking (CarName, PickupDate, ReturnDate, RentalPeriod, PickupLocation)
    VALUES (@CarName, @PickupDate, @ReturnDate, @RentalPeriod, @PickupLocation);
    
    -- Optionally return the inserted BookingID
    SELECT SCOPE_IDENTITY() AS BookingID;
END

GO
/****** Object:  StoredProcedure [dbo].[RegisterUser]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegisterUser]
    @Username NVARCHAR(50),
    @Password NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert user into the database
    INSERT INTO dbo.users (username, password)
    VALUES (@Username, @Password);
END;

GO
/****** Object:  StoredProcedure [dbo].[UpdateUserInfo]    Script Date: 03/05/2025 5:11:16 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUserInfo]
    @username NVARCHAR(100),
    @email NVARCHAR(100),
    @mobilenumber NVARCHAR(20),
    @location NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE users 
    SET 
        email = @email,
        mobilenumber = @mobilenumber,
        location = @location
    WHERE username = @username;

    -- Optional: Return the number of rows affected
    SELECT @@ROWCOUNT AS RowsAffected;
END

GO
USE [master]
GO
ALTER DATABASE [WHEELISTER] SET  READ_WRITE 
GO
