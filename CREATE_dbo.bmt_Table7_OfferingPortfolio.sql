USE [Helsinki]
GO

/****** Object:  Table [dbo].[bs_staging]    Script Date: 12/15/2020 11:47:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[bmt_Table7_OfferingPortfolio](
	[HZ_MajorOffering] [nvarchar](10) NULL,
	[GSAP_OfferingPortfolio] [nvarchar](10) NULL,
	[GSAP_OffringPortfolioDesc] [nvarchar](100) NULL,
) ON [PRIMARY]
GO
