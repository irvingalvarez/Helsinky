USE [OptimusPrime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--DROP TABLE IF EXISTS dbo.lt_PersonnelDatabyPSGroup
DROP TABLE IF EXISTS dbo.lt_Personnel_Group_Data

CREATE TABLE [dbo].[lt_Personnel_Group_Data](
PersonnelArea NVARCHAR (4) NULL,
PersonnelSubArea NVARCHAR (4) NULL,
PS_Group NUMERIC (2) NULL,
LoadDate DATE NOT NULL
) ON [PRIMARY]
GO


