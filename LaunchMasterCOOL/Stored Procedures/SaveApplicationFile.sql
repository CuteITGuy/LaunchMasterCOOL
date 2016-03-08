USE	Tool
GO

IF OBJECT_ID('SaveApplicationFile', 'P') IS NOT NULL
	DROP PROCEDURE SaveApplicationFile
GO

CREATE PROCEDURE SaveApplicationFile
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