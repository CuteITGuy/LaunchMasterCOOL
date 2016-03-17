USE [Installation]
GO
/****** Object:  StoredProcedure [dbo].[proc_ListApplicationInfos]    Script Date: 3/17/2016 9:01:01 Chiều ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_ListApplicationInfos]
AS
BEGIN
	SELECT	A.[Id], A.[Name], A.[Directory], A.[Description]
	FROM	[Application] A
END
GO
