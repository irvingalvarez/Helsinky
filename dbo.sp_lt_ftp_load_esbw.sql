USE [OptimusPrime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Irving Alvarez
-- Create date: 03/09/2023
-- Description:	Load ftp tables to lt_esbw_data 

-- exec dbo.lt_ftp_load_esbw
-- =============================================
IF OBJECT_ID('dbo.lt_ftp_load_esbw') IS NULL
EXEC('CREATE PROCEDURE dbo.lt_ftp_load_esbw AS SET NOCOUNT ON;')
GO

ALTER PROCEDURE [dbo].[lt_ftp_load_esbw]
AS
BEGIN
SET NOCOUNT ON;


DELETE FROM lt_esbw_data 
WHERE ActivityMonth IN (SELECT DISTINCT ActivityMonth FROM vw_lt_ftp_esbw_data)
AND Source = 'FTP'


INSERT INTO  [dbo].[lt_esbw_data]
           ([Scenario]
           ,[Source]
           ,[ActivityMonth]
           ,[FiscalPeriod]
           ,[FiscalYearVariant] 
           ,[CompanyCode]
           ,[ProcessingStatus]
           ,[PersonelID]
           ,[EEComp]
           ,[EmployeeID]
           ,[EmpStatus]
           ,[EmpManagerID]
           ,[ManagerComp]
           ,[OrgID]
           ,[PSGrouping]
           ,[AAType]
           ,[AATypeIndicator]
           ,[ActivityType]
           ,[ReceivingWBS]
           ,[ReceivingCostCenter]
           ,[SenderCostObject]
           ,[ControllingArea]
           ,[MasterData]
           ,[ReceivingServiceOrder]
           ,[ReceivingCostObject]
           ,[ReceivingPostingObjectID]
           ,[ActivityWeek]
           ,[SenderPostingObjectID]
           ,[CrossTag]
           ,[DTagDescription]
           ,[AATypeSummaryCode]
           ,[CreatedOn]
           ,[Unit]
           ,[Hours]
           ,[LoadingTime]
           ,[BillableCode]
           ,[Available_Hours]
           ,[ActivityMonth_Reporting]
           ,[PersonelID_GA]
           ,[GSAPProjectKey]
           ,[CrossSysWBS])


SELECT 
	'Actual' AS Scenario               
	,'FTP' AS Source                 
	,ActivityMonth       
	,tt.FiscalPeriod           
	,'NC' AS FiscalYearVariant       
	,tt.CompanyCode            
	,tt.ProcessingStatus        
	,tt.PersonelID             
	,tt.EEComp                 
	,tt.EmployeeID
	,tt.EmpStatus              
	,tt.EmpManagerID           
	,tt.ManagerComp            
	,tt.OrgID                  
	,tt.PSGrouping             
	,tt.AAType                 
	,tt.AATypeIndicator        
	,tt.ActivityType           
	,tt.ReceivingWBS           
	,tt.ReceivingCostCenter    
	,tt.SenderCostObject       
	,tt.ControllingArea        
	,'FTP' AS MasterData             
	,tt.ReceivingServiceOrder  
	,tt.ReceivingCostObject    
	,tt.ReceivingPostingObjectID 
	,tt.ActivityWeek
	,tt.SenderPostingObjectID  
	,' ' AS CrossTag                --NULL--WIP
	,NULL AS DTagDescription         --WIP
	,tt.AATypeSummaryCode      
	,left(FORMAT (GETDATE(), 'yyyyMMdd'),8) AS CreatedOn              
	,tt.Unit                   
	,SUM(tt.Hours) AS Hours
	,getdate() AS LoadingTime            
	,tt.BillableCode           
	,Null AS Available_Hours        
	,LEFT(ActivityMonth_Reporting ,7) AS ActivityMonth_Reporting
	,' ' AS PersonelID_GA           --Null
	,tt.GSAPProjectKey
	,NULL AS CrossSysWBS             --WIP
FROM vw_lt_ftp_esbw_data tt
GROUP BY 
	ActivityMonth       
	,tt.FiscalPeriod           
	,tt.CompanyCode            
	,tt.ProcessingStatus        
	,tt.PersonelID             
	,tt.EEComp                 
	,tt.EmployeeID
	,tt.EmpStatus              
	,tt.EmpManagerID           
	,tt.ManagerComp            
	,tt.OrgID                  
	,tt.PSGrouping             
	,tt.AAType                 
	,tt.AATypeIndicator        
	,tt.ActivityType           
	,tt.ReceivingWBS           
	,tt.ReceivingCostCenter    
	,tt.SenderCostObject       
	,tt.ControllingArea        
	,tt.ReceivingServiceOrder  
	,tt.ReceivingCostObject    
	,tt.ReceivingPostingObjectID 
	,tt.ActivityWeek
	,tt.SenderPostingObjectID  
	,tt.AATypeSummaryCode      
	,tt.Unit                   
	,tt.BillableCode           
	,ActivityMonth_Reporting
	,tt.GSAPProjectKey
END