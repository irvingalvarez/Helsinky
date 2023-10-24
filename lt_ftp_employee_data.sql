USE [OptimusPrime]
GO

/****** Object:  Table [dbo].[lt_ftp_Employee_Data]    Script Date: 2/22/2023 11:11:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lt_ftp_Employee_Data](
	[PersonnelNumber] [nvarchar](8) NOT NULL,
	[Superv_Area] [nvarchar](8) NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[EmpName] [nvarchar](40) NULL,
	[SName] [nvarchar](30) NULL,
	[ChangedOn] [date] NULL,
	[Uname] [nvarchar](12) NULL,
	[CompanyCode] [nvarchar](4) NULL,
	[ControllingArea] [nvarchar](4) NULL,
	[PersonnelSubArea] [nvarchar](4) NULL,
	[PersonnelArea] [nvarchar](4) NULL,
	[CostCenter] [nvarchar](10) NULL,
	[EmployeeGroup] [nvarchar](1) NULL,
	[EmployeeSubGroup] [nvarchar](2) NULL,
	[Org_Key] [nvarchar](14) NULL,
	[BusinessArea] [nvarchar](4) NULL,
	[LoadDate] [date] NOT NULL,
 CONSTRAINT [PK_lt_Employee_Data] PRIMARY KEY CLUSTERED 
(
	[PersonnelNumber] ASC,
	[StartDate] ASC,
	[EndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


