USE [OptimusPrime]
GO

/****** Object:  Table [dbo].[lt_ftp_Sales_Order_WBS]    Script Date: 2/22/2023 11:13:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lt_ftp_Sales_Order_WBS](
	[SalesDocument] [nvarchar](10) NOT NULL,
	[Item] [nvarchar](6) NULL,
	[ProfitSegment] [nvarchar](10) NULL,
	[LoadDate] [date] NOT NULL,
 CONSTRAINT [PK_lt_Sales_Order_WBS] PRIMARY KEY CLUSTERED 
(
	[SalesDocument] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


