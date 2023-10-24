USE [OptimusPrime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE IF EXISTS dbo.lt_AttendanceIndicator
DROP TABLE IF EXISTS dbo.lt_Attendance_Indicator

CREATE TABLE [dbo].[lt_Attendance_Indicator](
PS_Group NUMERIC (2) NOT NULL,
AA_Type NVARCHAR (4) NOT NULL,
AA_Tpye_Text NVARCHAR (25) NULL,
AA_Indicator NVARCHAR (1) NOT NULL,
BeginDate DATE NOT NULL,
EndDate DATE NOT NULL,
LoadDate DATE NOT NULL
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

