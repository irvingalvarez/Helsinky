USE [OptimusPrime]
GO

/****** Object:  Table [dbo].[lt_ftp_Employee_Personnel_Workday]    Script Date: 2/22/2023 11:12:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lt_ftp_Employee_Personnel_Workday](
	[PersonnelNumber] [nvarchar](8) NOT NULL,
	[BeginDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[TimeRecIdNo] [varchar](8) NULL,
	[LoadDate] [date] NOT NULL,
 CONSTRAINT [PK_lt_Employee_Personnel_Workday] PRIMARY KEY CLUSTERED 
(
	[PersonnelNumber] ASC,
	[BeginDate] ASC,
	[EndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


