USE [Installation]
GO
/****** Object:  Table [dbo].[ApplicationFiles]    Script Date: 3/17/2016 9:01:01 Chiều ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationFiles](
	[ApplicationId] [int] NOT NULL,
	[FileId] [int] NOT NULL,
	[IsInitFile] [bit] NOT NULL,
 CONSTRAINT [PK_ApplicationFiles] PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC,
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ApplicationFiles]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationFiles_Application] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Application] ([Id])
GO
ALTER TABLE [dbo].[ApplicationFiles] CHECK CONSTRAINT [FK_ApplicationFiles_Application]
GO
ALTER TABLE [dbo].[ApplicationFiles]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationFiles_Files] FOREIGN KEY([FileId])
REFERENCES [dbo].[File] ([Id])
GO
ALTER TABLE [dbo].[ApplicationFiles] CHECK CONSTRAINT [FK_ApplicationFiles_Files]
GO
