/*
*	Stored Procedure: proc_SaveApplication
*	Version: 1.0.0.0
*/

USE [Installation]
GO

IF OBJECT_ID('proc_SaveApplication', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_SaveApplication
END
GO

CREATE PROC proc_SaveApplication
(
	@Id          INT            = NULL,
	@Name        VARCHAR(128),
	@Directory   VARCHAR(512),
	@Description NVARCHAR(1024) = NULL
)
AS
BEGIN
	DECLARE @exists BIT

	SELECT @exists = 1
	FROM Application A
	WHERE A.Id = @Id

	IF @exists = 0
	BEGIN
		INSERT INTO Application (Name, Directory, Description, Createdon, Modifiedon)
	VALUES
		(
			@Name, -- Name - varchar
			@Directory, -- Directory - varchar
			@Description, -- Description - nvarchar
			Getdate(), -- CreatedOn - datetime
			Getdate() -- ModifiedOn - datetime
		)
		SELECT @Id = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE Application
		SET
			Name = @Name, -- varchar
			Directory = @Directory, -- varchar
			Description = @Description, -- nvarchar
			Modifiedon = GETDATE() -- datetime
		WHERE Application.Id = @Id
	END
	SELECT @Id
END