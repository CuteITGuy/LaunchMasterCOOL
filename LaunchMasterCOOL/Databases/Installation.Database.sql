USE [master]
GO
/****** Object:  Database [Installation]    Script Date: 3/17/2016 9:01:01 Chiều ******/
CREATE DATABASE [Installation]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Installation', FILENAME = N'J:\Program Files\Microsoft SQL Server\MSSQL12.CONNOR\MSSQL\DATA\Installation.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Installation_log', FILENAME = N'J:\Program Files\Microsoft SQL Server\MSSQL12.CONNOR\MSSQL\DATA\Installation_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Installation] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Installation].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Installation] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Installation] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Installation] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Installation] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Installation] SET ARITHABORT OFF 
GO
ALTER DATABASE [Installation] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Installation] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Installation] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Installation] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Installation] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Installation] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Installation] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Installation] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Installation] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Installation] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Installation] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Installation] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Installation] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Installation] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Installation] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Installation] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Installation] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Installation] SET RECOVERY FULL 
GO
ALTER DATABASE [Installation] SET  MULTI_USER 
GO
ALTER DATABASE [Installation] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Installation] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Installation] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Installation] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Installation] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Installation', N'ON'
GO
ALTER DATABASE [Installation] SET  READ_WRITE 
GO
