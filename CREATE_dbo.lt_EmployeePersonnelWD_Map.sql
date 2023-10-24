USE [OptimusPrime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE IF EXISTS dbo.lt_EmployeePersonnelWD_Map
DROP TABLE IF EXISTS dbo.lt_Employee_Personnel_Workday

CREATE TABLE [dbo].[lt_Employee_Personnel_Workday](
PersonnelNumber NUMERIC (8) NOT NULL,
BeginDate DATE NOT NULL,
EndDate DATE NOT NULL,
TimeRecIdNo VARCHAR (8) NULL,
LoadDate DATE NOT NULL
CONSTRAINT [PK_lt_Employee_Personnel_Workday] PRIMARY KEY CLUSTERED 
(
	[PersonnelNumber] ASC,
	[BeginDate] ASC,
	[EndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

