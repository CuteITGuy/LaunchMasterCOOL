USE Tool
GO

IF OBJECT_ID('SaveFile', 'P') IS NOT NULL
	DROP PROCEDURE SaveFile
GO

CREATE PROCEDURE SaveFile
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