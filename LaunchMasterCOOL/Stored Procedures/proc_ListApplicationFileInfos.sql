/*
 *	Stored Procedure proc_ListApplicationFileInfos
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_ListApplicationFileInfos', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_ListApplicationFileInfos
END
GO

CREATE PROC proc_ListApplicationFileInfos
(
	@ApplicationId INT
)
AS
BEGIN
	SELECT F.Id, F.Name, F.Directory, F.Extension, F.Version, F.Description, AF.IsInitFile
	FROM ApplicationFiles AF
		 JOIN [File] F ON AF.ApplicationId = @ApplicationId
						  AND F.Id = AF.FileId
END