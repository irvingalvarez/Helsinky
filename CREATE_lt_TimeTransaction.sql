USE [OptimusPrime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE IF EXISTS dbo.lt_TimeTransaction
DROP TABLE IF EXISTS dbo.lt_Time_Transaction

CREATE TABLE [dbo].[lt_Time_Transaction](
CountRecs nvarchar  (12) NOT NULL,
RefCountRecs nvarchar  (12) NULL,
Doc_Number nvarchar  (10) NULL,
CreatedOn nvarchar (8) NULL,
TimeofEntry nvarchar (6) NULL,
CreatedUser nvarchar  (12) NULL,
ProcStatus nvarchar (2) NULL,
WorkDate nvarchar(8) NULL,
Replicon_ID NUMERIC (20) NULL,
PersonnelNumber NUMERIC(8) NULL,
ActivityType nvarchar (6) NULL,
AA_Type nvarchar (4) NULL,
ControllingArea nvarchar (4) NULL,
SenderCostCenter nvarchar (10) NULL,
Rec_WBSElement NUMERIC (8) NULL,
Rec_CostCenter nvarchar(10) NULL,
Rec_SalesOrder nvarchar(10) NULL,
ItemNumber NUMERIC(6) NULL,
Rec_CostObject nvarchar  (12) NULL,
Hours NUMERIC(4) NULL,
UnitofMeasure NUMERIC(3) NULL,
LogicalSys nvarchar (10) NULL,
ExternalApp nvarchar (5) NULL,
Ext_Doc_Number nvarchar (20) NULL,
LogicalSys_SourceDoc nvarchar (10) NULL,
Bill_Indicator nvarchar (1) NULL,
EntrySheetNum nvarchar (10) NULL,
LoadDate DATE NOT NULL,
CONSTRAINT [PK_lt_Time_Transaction] PRIMARY KEY CLUSTERED 
(
	[CountRecs] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


