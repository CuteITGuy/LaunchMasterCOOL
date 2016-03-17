/*
 *	Stored Procedure proc_ListApplicationFiles
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_ListApplicationFiles', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_ListApplicationFiles
END
GO

CREATE PROC proc_ListApplicationFiles
(
	@ApplicationId INT
)
AS
BEGIN
	SELECT [F].*, AF.IsInitFile
	FROM ApplicationFiles AF
		 JOIN [File] F ON AF.ApplicationId = @ApplicationId
						  AND [F].Id = AF.FileId
END