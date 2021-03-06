USE [Installation]
GO
/****** Object:  StoredProcedure [dbo].[proc_SaveApplicationFile]    Script Date: 3/17/2016 9:01:01 Chiều ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_SaveApplicationFile]
(
	@ApplicationId INT,
	@FileId        INT,
	@IsInitFile    BIT
)
AS
BEGIN
	DECLARE @exists BIT

	SELECT @exists = 1
	FROM ApplicationFiles AF
	WHERE AF.ApplicationId = @ApplicationId
		  AND AF.FileId = @FileId

	IF @exists = 0
	BEGIN
		INSERT INTO ApplicationFiles (ApplicationId, FileId, IsInitFile)
	VALUES
		(
			@ApplicationId, -- ApplicationId - int
			@FileId, -- FileId - int
			@IsInitFile -- IsInitFile - bit
		)
	END
	ELSE
	BEGIN
		UPDATE ApplicationFiles
		SET
			IsInitFile = @IsInitFile -- bit
		WHERE ApplicationFiles.ApplicationId = @ApplicationId
			  AND ApplicationFiles.FileId = @FileId
	END
END
GO
