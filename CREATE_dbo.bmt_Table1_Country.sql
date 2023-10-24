USE [Helsinki]
GO

/****** Object:  Table [dbo].[bs_staging]    Script Date: 12/15/2020 11:47:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[bmt_Table1_Country](
	[HZ_PC_Code] [nvarchar](5) NULL,
	[HZ_PC_Desc] [nvarchar](100) NULL,
	[CountryCode] [nvarchar](5) NULL,
	[CountryName] [nvarchar](100) NULL,
) ON [PRIMARY]
GO
