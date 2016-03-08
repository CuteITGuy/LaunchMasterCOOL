USE Tool
GO

IF OBJECT_ID('GetFileVersions', 'P') IS NOT NULL
	DROP PROCEDURE GetFileVersions
GO

CREATE PROCEDURE GetFileVersions
	(
		@ApplicationId		INT
	)
AS
BEGIN
	SELECT	F.FileId, F.FileName, F.Version, F.FolderPath, AF.IsStartupFile
	FROM	dbo.ApplicationsFiles AF JOIN dbo.[File] F ON AF.ApplicationId = @ApplicationId AND AF.FileId = F.FileId
END