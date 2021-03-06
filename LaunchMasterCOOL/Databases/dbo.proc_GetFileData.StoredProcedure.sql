USE [Installation]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetFileData]    Script Date: 3/17/2016 9:01:01 Chiều ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_GetFileData]
(
	@FileId int
)
AS
BEGIN
	SELECT	F.[Id], F.[Name], F.[Directory], F.[Data], F.[Hash], F.[Size]
	FROM	[File] F
	WHERE	[F].[Id] = @FileId
END
GO
