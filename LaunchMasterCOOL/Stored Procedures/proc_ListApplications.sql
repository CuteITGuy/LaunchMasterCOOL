/*
 *	Stored Procedure proc_ListApplications
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_ListApplications', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_ListApplications
END
GO

CREATE PROC proc_ListApplications
AS
BEGIN
	SELECT *
	FROM [Application]
END