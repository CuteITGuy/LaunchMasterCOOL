USE [Installation]
GO
/****** Object:  StoredProcedure [dbo].[proc_ListApplicationFiles]    Script Date: 3/17/2016 9:01:01 Chiều ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_ListApplicationFiles](
	@ApplicationId INT)
AS
BEGIN
	SELECT [F].*, AF.[IsInitFile]
	FROM ApplicationFiles AF
		 JOIN [File] F ON AF.ApplicationId = @ApplicationId
						  AND [F].Id = AF.FileId
END
GO
