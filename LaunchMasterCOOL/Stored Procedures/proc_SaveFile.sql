/*
 *	Stored Procedure proc_SaveFile
 *	Version: 1.0.0.0
 */

IF OBJECT_ID('proc_SaveFile', 'P') IS NOT NULL
BEGIN
	DROP PROC proc_SaveFile
END
GO

CREATE PROC proc_SaveFile
(
	@Id          INT            = NULL,
	@Name        VARCHAR(128),
	@Directory   VARCHAR(512),
	@Extension   VARCHAR(8),
	@Data        VARBINARY(MAX),
	@Hash        BINARY(16),
	@Size        INT,
	@Description NVARCHAR(1024) = NULL
)
AS
BEGIN
	DECLARE @exists BIT

	SELECT @exists = 1
	FROM [File] F
	WHERE F.Id = @Id

	-- Has not existed: Insert new row
	IF @exists = 0
	BEGIN
		INSERT INTO [File] (Name, Directory, Extension, Data, Hash, Size, Description, Createdon,
		Modifiedon)
		VALUES
		(
			@Name, -- Name - varchar
			@Directory, -- Directory - varchar
			@Extension, -- Extension - varchar
			@Data, -- Data - varbinary
			@Hash, -- Hash - binary
			@Size, -- Size - int
			@Description, -- Description - nvarchar
			Getdate(), -- CreatedOn - datetime
			Getdate() -- ModifiedOn - datetime
		)
		SELECT @Id = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE [File]
		SET
			Name = @Name, -- varchar
			Directory = @Directory, -- varchar
			Extension = @Extension, -- varchar
			Data = @Data, -- varbinary
			Hash = @Hash, -- binary
			Size = @Size, -- int
			Description = @Description, -- nvarchar
			Modifiedon = GETDATE() -- datetime
		WHERE [File].Id = @Id
	END

	SELECT @Id
END