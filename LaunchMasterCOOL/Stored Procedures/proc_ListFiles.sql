/*
 *	Stored Procedure proc_ListFiles
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_ListFiles', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_ListFiles
END
GO

CREATE PROC proc_ListFiles
AS
BEGIN
	SELECT *
	FROM [File]
END