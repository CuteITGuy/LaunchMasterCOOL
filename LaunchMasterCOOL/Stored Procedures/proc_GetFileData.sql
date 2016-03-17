/*
 *	Stored Procedure proc_GetFileData
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_GetFileData', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_GetFileData
END
GO

CREATE PROC proc_GetFileData
(
	@FileId int
)
AS
BEGIN
	SELECT	F.[Id], F.[Name], F.[Directory], F.[Data], F.[Hash], F.[Size]
	FROM	[File] F
	WHERE	[F].[Id] = @FileId
END