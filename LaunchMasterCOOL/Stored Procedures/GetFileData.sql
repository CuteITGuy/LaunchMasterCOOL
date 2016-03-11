USE AppSynchronizer
GO

IF OBJECT_ID('GetFileData', 'P') IS NOT NULL
	DROP PROCEDURE GetFileData
GO

CREATE PROCEDURE GetFileData
	(
		@FileId		INT
	)
AS
BEGIN
	SELECT	F.Data, F.Hash
	FROM	dbo.[File] F
	WHERE	F.FileId = @FileId
END