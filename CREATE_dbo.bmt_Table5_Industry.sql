USE [Helsinki]
GO

/****** Object:  Table [dbo].[bs_staging]    Script Date: 12/15/2020 11:47:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[bmt_Table5_Industry](
	[HZ_Industry] [nvarchar](10) NULL,
	[HZ_IndustryName] [nvarchar](100) NULL,
	[GSAP_Industry] [nvarchar](10) NULL,
	[GSAP_IndustryDESC] [nvarchar](100) NULL
) ON [PRIMARY]
GO
