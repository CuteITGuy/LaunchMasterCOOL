/*
 *	Stored Procedure proc_SaveApplicationFile
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_SaveApplicationFile', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_SaveApplicationFile
END
GO

CREATE PROC proc_SaveApplicationFile
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