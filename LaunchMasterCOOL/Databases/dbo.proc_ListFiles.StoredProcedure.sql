USE [Installation]
GO
/****** Object:  StoredProcedure [dbo].[proc_ListFiles]    Script Date: 3/17/2016 9:01:01 Chiều ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_ListFiles]
AS
BEGIN
	SELECT *
	FROM [File]
END
GO
