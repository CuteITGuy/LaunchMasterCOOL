USE [master]
GO
/****** Object:  Database [AppSynchronizer]    Script Date: 3/8/2016 2:01:32 PM ******/
CREATE DATABASE [AppSynchronizer]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AppSynchronizer', FILENAME = N'AppSynchronizer.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'AppSynchronizer_log', FILENAME = N'AppSynchronizer_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [AppSynchronizer] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AppSynchronizer].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AppSynchronizer] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AppSynchronizer] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AppSynchronizer] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AppSynchronizer] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AppSynchronizer] SET ARITHABORT OFF 
GO
ALTER DATABASE [AppSynchronizer] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AppSynchronizer] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [AppSynchronizer] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AppSynchronizer] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AppSynchronizer] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AppSynchronizer] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AppSynchronizer] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AppSynchronizer] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AppSynchronizer] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AppSynchronizer] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AppSynchronizer] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AppSynchronizer] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AppSynchronizer] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AppSynchronizer] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AppSynchronizer] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AppSynchronizer] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AppSynchronizer] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AppSynchronizer] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AppSynchronizer] SET RECOVERY FULL 
GO
ALTER DATABASE [AppSynchronizer] SET  MULTI_USER 
GO
ALTER DATABASE [AppSynchronizer] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AppSynchronizer] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AppSynchronizer] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AppSynchronizer] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'AppSynchronizer', N'ON'
GO
USE [AppSynchronizer]
GO
/****** Object:  StoredProcedure [dbo].[GetFileData]    Script Date: 3/8/2016 2:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetFileData]
	(
		@FileId		INT
	)
AS
BEGIN
	SELECT	F.FileName, F.Data, F.Hash, F.FolderPath
	FROM	dbo.[File] F
	WHERE	F.FileId = @FileId
END
GO
/****** Object:  StoredProcedure [dbo].[GetFileVersions]    Script Date: 3/8/2016 2:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetFileVersions]
	(
		@ApplicationId		INT
	)
AS
BEGIN
	SELECT	F.FileId, F.FileName, F.Version, F.FolderPath, AF.IsStartupFile
	FROM	dbo.ApplicationsFiles AF JOIN dbo.[File] F ON AF.ApplicationId = @ApplicationId AND AF.FileId = F.FileId
END
GO
/****** Object:  StoredProcedure [dbo].[SaveApplication]    Script Date: 3/8/2016 2:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SaveApplication]
	(
		@ApplicationId		INT = NULL,
		@ApplicationName	NVARCHAR(512)
	)
AS
BEGIN
	DECLARE	@existed	BIT

	SELECT	@existed = 1
	FROM	dbo.Application
	WHERE	ApplicationId = @ApplicationId

	IF @existed = 1
	BEGIN
		UPDATE	dbo.Application
		SET		ApplicationName = @ApplicationName,
				ModifiedOn = GETDATE()
		WHERE	ApplicationId = @ApplicationId
		SELECT	@ApplicationId
	END
	ELSE
	BEGIN
		INSERT	INTO dbo.Application
		        ( ApplicationName ,
		          CreatedOn ,
		          ModifiedOn
		        )
		VALUES  ( @ApplicationName , -- ApplicationName - nvarchar(512)
		          GETDATE() , -- CreatedOn - datetime
		          GETDATE()  -- ModifiedOn - datetime
		        )
		SELECT	SCOPE_IDENTITY()
	END  
END
GO
/****** Object:  StoredProcedure [dbo].[SaveApplicationFile]    Script Date: 3/8/2016 2:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SaveApplicationFile]
	(
		@ApplicationId		INT = NULL,
		@ApplicationName	NVARCHAR(512),
		@FileId				INT = NULL,
		@FileName			NVARCHAR(256),
		@Extension			NVARCHAR(32) = NULL,
		@Data				VARBINARY(MAX),
		@Hash				VARBINARY(16),
		@Version			VARCHAR(64) = NULL,
		@Size				BIGINT,
		@Description		NVARCHAR(512) = NULL,
		@FolderPath			NVARCHAR(1024),
		@UploadPath			NVARCHAR(1024) = NULL,
		@IsStartupFile		BIT = 0
	)
AS
BEGIN
	EXECUTE	@ApplicationId = dbo.SaveApplication
		@ApplicationId = @ApplicationId, -- int
	    @ApplicationName = @ApplicationName -- nvarchar(512)
	
	EXECUTE @FileId = dbo.SaveFile
		@FileId = @FileId, -- int
	    @FileName = @FileName, -- nvarchar(256)
	    @Extension = @Extension, -- nvarchar(32)
	    @Data = @Data, -- varbinary(max)
	    @Hash = @Hash, -- varbinary(16)
	    @Version = @Version, -- varchar(64)
	    @Size = @Size, -- bigint
	    @Description = @Description, -- nvarchar(512)
	    @FolderPath = @FolderPath, -- nvarchar(1024)
	    @UploadPath = @UploadPath -- nvarchar(1024)
	
	DECLARE	@existed	BIT
  
	SELECT	@existed = 1
	FROM	dbo.ApplicationsFiles
	WHERE	ApplicationId = @ApplicationId AND
			FileId = @FileId
			
	IF @existed = 1
	BEGIN
		UPDATE	dbo.ApplicationsFiles
		SET		IsStartupFile = @IsStartupFile
		WHERE	ApplicationId = @ApplicationId AND
				FileId = @FileId      
	END
	ELSE
	BEGIN
		INSERT	INTO dbo.ApplicationsFiles
		        ( ApplicationId ,
		          FileId ,
		          IsStartupFile
		        )
		VALUES  ( @ApplicationId , -- ApplicationId - int
		          @FileId , -- FileId - int
		          @IsStartupFile  -- IsStartupFile - bit
		        )
	END
  
	SELECT	@ApplicationId, @FileId  
END
GO
/****** Object:  StoredProcedure [dbo].[SaveFile]    Script Date: 3/8/2016 2:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SaveFile]
	(
		@FileId				INT = NULL,
		@FileName			NVARCHAR(256),
		@Extension			NVARCHAR(32) = NULL,
		@Data				VARBINARY(MAX),
		@Hash				VARBINARY(16),
		@Version			VARCHAR(64) = NULL,
		@Size				BIGINT,
		@Description		NVARCHAR(512) = NULL,
		@FolderPath			NVARCHAR(1024),
		@UploadPath			NVARCHAR(1024) = NULL
	)
AS
BEGIN
	DECLARE	@existed	BIT
	SELECT	@existed = 1
	FROM	dbo.[File]
	WHERE	FileId = @FileId

	IF @existed = 1
	BEGIN
		UPDATE	dbo.[File]
		SET		FileName = @FileName,
				Extension = @Extension,
				Data = @Data,
				Hash = @Hash,
				Version = @Version,
				Size = @Size,
				Description = @Description,
				FolderPath = @FolderPath,
				UploadPath = @UploadPath,
				ModifiedOn = GETDATE()
		WHERE	FileId = @FileId
		SELECT	@FileId
	END
	ELSE
	BEGIN
		INSERT	INTO dbo.[File]
		        ( FileName ,
		          Extension ,
		          Data ,
		          Hash ,
		          Version ,
		          Size ,
		          Description ,
		          FolderPath ,
		          UploadPath ,
		          CreatedOn ,
		          ModifiedOn
		        )
		VALUES  ( @FileName , -- FileName - nvarchar(256)
		          @Extension , -- Extension - nvarchar(32)
		          @Data , -- Data - varbinary(max)
		          @Hash , -- Hash - varbinary(16)
		          @Version , -- Version - varchar(64)
		          @Size , -- Size - bigint
		          @Description , -- Description - nvarchar(512)
		          @FolderPath , -- FolderPath - nvarchar(1024)
		          @UploadPath , -- UploadPath - nvarchar(1024)
		          GETDATE() , -- CreatedOn - datetime
		          GETDATE()  -- ModifiedOn - datetime
		        )
		SELECT	SCOPE_IDENTITY()
	END  
END
GO
/****** Object:  Table [dbo].[Application]    Script Date: 3/8/2016 2:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Application](
	[ApplicationId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationName] [nvarchar](512) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationsFiles]    Script Date: 3/8/2016 2:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationsFiles](
	[ApplicationId] [int] NOT NULL,
	[FileId] [int] NOT NULL,
	[IsStartupFile] [bit] NOT NULL,
 CONSTRAINT [PK_ApplicationsFiles] PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC,
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[File]    Script Date: 3/8/2016 2:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[File](
	[FileId] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [nvarchar](256) NOT NULL,
	[Extension] [nvarchar](32) NULL,
	[Data] [varbinary](max) NOT NULL,
	[Hash] [varbinary](16) NOT NULL,
	[Version] [varchar](64) NULL,
	[Size] [bigint] NOT NULL,
	[Description] [nvarchar](512) NULL,
	[FolderPath] [nvarchar](1024) NOT NULL,
	[UploadPath] [nvarchar](1024) NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_File] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ApplicationsFiles]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationsFiles_Application] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Application] ([ApplicationId])
GO
ALTER TABLE [dbo].[ApplicationsFiles] CHECK CONSTRAINT [FK_ApplicationsFiles_Application]
GO
ALTER TABLE [dbo].[ApplicationsFiles]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationsFiles_File] FOREIGN KEY([FileId])
REFERENCES [dbo].[File] ([FileId])
GO
ALTER TABLE [dbo].[ApplicationsFiles] CHECK CONSTRAINT [FK_ApplicationsFiles_File]
GO
USE [master]
GO
ALTER DATABASE [AppSynchronizer] SET  READ_WRITE 
GO
