/*
 *	Stored Procedure proc_GetFile
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_GetFile', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_GetFile
END
GO

CREATE PROC proc_GetFile
(
	@Id INT
)
AS
BEGIN
	SELECT *
	FROM [File] F
	WHERE [F].Id = @Id
END