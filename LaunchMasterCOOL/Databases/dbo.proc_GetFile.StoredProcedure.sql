USE [Installation]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetFile]    Script Date: 3/17/2016 9:01:01 Chiều ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_GetFile]
(
	@Id INT
)
AS
BEGIN
	SELECT *
	FROM [File] F
	WHERE [F].Id = @Id
END
GO
