USE [OptimusPrime]
GO

/****** Object:  Table [dbo].[lt_ftp_Attendance_Indicator]    Script Date: 2/22/2023 11:11:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lt_ftp_Attendance_Indicator](
	[PS_Group] [nvarchar](2) NOT NULL,
	[AA_Type] [nvarchar](4) NOT NULL,
	[AA_Tpye_Text] [nvarchar](25) NULL,
	[AA_Indicator] [nvarchar](1) NOT NULL,
	[BeginDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[LoadDate] [date] NOT NULL,
 CONSTRAINT [PK_lt_Attendance_Indicator] PRIMARY KEY CLUSTERED 
(
	[PS_Group] ASC,
	[AA_Type] ASC,
	[AA_Indicator] ASC,
	[BeginDate] ASC,
	[EndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO