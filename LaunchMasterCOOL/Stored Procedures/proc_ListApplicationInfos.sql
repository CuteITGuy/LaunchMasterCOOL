/*
 *	Stored Procedure proc_ListApplicationInfos
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_ListApplicationInfos', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_ListApplicationInfos
END
GO

CREATE PROC proc_ListApplicationInfos
AS
BEGIN
	SELECT	A.[Id], A.[Name], A.[Directory], A.[Description]
	FROM	[Application] A
END