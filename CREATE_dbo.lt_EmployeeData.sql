USE [OptimusPrime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE IF EXISTS dbo.lt_EmployeeData
DROP TABLE IF EXISTS dbo.lt_Employee_Data

CREATE TABLE [dbo].[lt_Employee_Data](
PersonnelNumber NUMERIC (8) NOT NULL,
Superv_Area NVARCHAR (8) NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
EmpName NVARCHAR (40) NULL,
SName NVARCHAR (30) NULL,
ChangedOn DATE NULL,
Uname NVARCHAR (12) NULL,
CompanyCode NVARCHAR (4) NULL,
ControllingArea NVARCHAR (4) NULL,
PersonnelSubArea NVARCHAR (4) NULL,
PersonnelArea NVARCHAR (4) NULL,
CostCenter NVARCHAR (10) NULL,
EmployeeGroup NVARCHAR (1) NULL,
EmployeeSubGroup NVARCHAR (2) NULL,
Org_Key NVARCHAR (14) NULL,
BusinessArea NVARCHAR (4) NULL,
LoadDate DATE NOT NULL,
CONSTRAINT [PK_lt_Employee_Data] PRIMARY KEY CLUSTERED 
(
	[PersonnelNumber] ASC,
	[StartDate] ASC,
	[EndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


