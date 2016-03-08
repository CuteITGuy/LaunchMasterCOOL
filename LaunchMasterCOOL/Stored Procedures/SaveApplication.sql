USE Tool
GO

IF OBJECT_ID('SaveApplication', 'P') IS NOT NULL
	DROP PROCEDURE SaveApplication
GO

CREATE PROCEDURE SaveApplication
	(
		@ApplicationId		INT = NULL,
		@ApplicationName	NVARCHAR(512)
	)
AS
BEGIN
	DECLARE	@existed	BIT

	SELECT	@existed = 1
	FROM	dbo.Application
	WHERE	ApplicationId = @ApplicationId

	IF @existed = 1
	BEGIN
		UPDATE	dbo.Application
		SET		ApplicationName = @ApplicationName,
				ModifiedOn = GETDATE()
		WHERE	ApplicationId = @ApplicationId
		SELECT	@ApplicationId
	END
	ELSE
	BEGIN
		INSERT	INTO dbo.Application
		        ( ApplicationName ,
		          CreatedOn ,
		          ModifiedOn
		        )
		VALUES  ( @ApplicationName , -- ApplicationName - nvarchar(512)
		          GETDATE() , -- CreatedOn - datetime
		          GETDATE()  -- ModifiedOn - datetime
		        )
		SELECT	SCOPE_IDENTITY()
	END  
END