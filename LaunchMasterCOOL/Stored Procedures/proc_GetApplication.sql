/*
 *	Stored Procedure proc_GetApplication
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_GetApplication', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_GetApplication
END
GO

CREATE PROC proc_GetApplication
(
	@Id INT
)
AS
BEGIN
	SELECT *
	FROM [Application] A
	WHERE [A].Id = @Id
END