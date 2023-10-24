USE [OptimusPrime]
GO

/****** Object:  Table [dbo].[lt_ftp_Personnel_Group_Data]    Script Date: 2/22/2023 11:12:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lt_ftp_Personnel_Group_Data](
	[PersonnelArea] [nvarchar](4) NULL,
	[PersonnelSubArea] [nvarchar](4) NULL,
	[PS_Group] [nvarchar](2) NULL,
	[LoadDate] [date] NOT NULL
) ON [PRIMARY]
GO


