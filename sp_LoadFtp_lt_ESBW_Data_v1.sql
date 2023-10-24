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

-- exec dbo.sp_LoadFtp_lt_ESBW_Data
-- =============================================
IF OBJECT_ID('dbo.sp_LoadFtp_lt_ESBW_Data') IS NULL
EXEC('CREATE PROCEDURE dbo.sp_LoadFtp_lt_ESBW_Data AS SET NOCOUNT ON;')
GO

ALTER PROCEDURE [dbo].[sp_LoadFtp_lt_ESBW_Data]
AS
BEGIN
SET NOCOUNT ON;

	SELECT 
		Scenario               = 'Actual'
		,Source                 = 'FTP'
		,ActivityMonth       = tt.ActivityMonth
		,tt.FiscalPeriod           
		,FiscalYearVariant      = 'NC'
		,CompanyCode            = ISNULL(ccm.LegalCompanyCode,' ')
		,tt.ProcessingStatus        
		,tt.PersonelID             
		,EEComp                 = lee.EEcomp
		,tt.EmployeeID
		,EmpStatus              = lee.Status
		,EmpManagerID           = ISNULL(lee.ManagerID,' ')
		,ManagerComp            = ISNULL(lee.ManagarEEComp,' ')
		,OrgID                  = ISNULL(lee.OrgID,' ')
		,PSGrouping             = ISNULL(T001P.PS_Group, 0)
		,tt.AAType                 
		,AATypeIndicator        = LEFT(lba.AATypeIndicator,1)
		,tt.ActivityType           
		,tt.ReceivingWBS           
		,tt.ReceivingCostCenter    
		,tt.SenderCostObject       
		,tt.ControllingArea        
		,MasterData             = 'FTP'
		,tt.ReceivingServiceOrder  
		,tt.ReceivingCostObject    
		,ReceivingPostingObjectID = CASE WHEN LEN(tt.ReceivingCostCenter) > 0 THEN ISNULL(LEFT(prps.WorkBreakdownStructure,18),' ')
									ELSE ISNULL(LEFT(tep2.PostingObjectID,18),' ') END
		,ActivityWeek			= tt.ActivityWeek 
		,SenderPostingObjectID  = ISNULL(ISNULL(tep.PostingObjectID,tep3.PostingObjectID),'')
		,CrossTag               = ' ' --NULL--WIP
		,DTagDescription        = NULL --WIP
		,AATypeSummaryCode      = lba.AATypeSummaryCode
		,CreatedOn              = left(FORMAT (GETDATE(), 'yyyyMMdd'),8)
		,Unit                   = tt.Unit
		,Hours                  = tt.Hours
		,LoadingTime            = getdate()
		,BillableCode           = tep.BillabilityCode
		,Available_Hours        = Null
		,ActivityMonth_Reporting = ' ' --NULL --FORMULA
		,PersonelID_GA          = ' ' --Null
		,tt.GSAPProjectKey
		,CrossSysWBS            = NULL --WIP
	INTO #ftp_esbw
    FROM 
	(SELECT DISTINCT 
		ProcessingStatus       = CATSDB.ProcStatus 
		,PersonelID             = LTRIM(RTRIM(CATSDB.PersonnelNumber))
		,AAType                 = CATSDB.AA_Type 
		,ActivityType           = CATSDB.ActivityType 
		,ReceivingWBS           = LTRIM(RTRIM(CATSDB.Rec_WBSElement))
		,ReceivingCostCenter    = CATSDB.Rec_CostCenter 
		,SenderCostObject       = CATSDB.SenderCostCenter 
		,ControllingArea        = CATSDB.ControllingArea 
		,ReceivingServiceOrder  = CATSDB.Rec_SalesOrder 
		,ReceivingCostObject    = CATSDB.Rec_CostObject 
		,CreatedOn              = CATSDB.CreatedOn 
		,Unit                   = CATSDB.UnitofMeasure 
		,Hours                  = sum(CATSDB.Hours)
		,GSAPProjectKey         = CATSDB.Bill_Indicator 
		,EmployeeID             = ISNULL(PA0050.TimeRecIdNo,LTRIM(RTRIM(CATSDB.PersonnelNumber)))
		,ProfitSegment1			= IIF(vbap.ProfitSegment IS NOT NULL,Concat('PR',Right(Concat('00000000',LTRIM(RTRIM(vbap.ProfitSegment))),8)),NULL)
		,ValueRecPostObj = CASE WHEN LEN(CATSDB.Rec_WBSElement) > 0  THEN LTRIM(RTRIM(CATSDB.Rec_WBSElement))
									ELSE
										CASE WHEN LEN(CATSDB.Rec_SalesOrder) > 0 THEN CATSDB.Rec_SalesOrder
										ELSE 
											CASE WHEN LEN(CATSDB.Rec_CostCenter) > 0 THEN CATSDB.Rec_CostCenter
											ELSE 
												CASE WHEN LEN(ed2.CostCenter) > 0 THEN ed2.CostCenter
												END
											END
										END 
									END
		,ActivityMonth          = format (CATSDB.Workdate, 'yyyy-MM-01')
		,FiscalPeriod           = fp.FiscalPeriod
		,ActivityWeek           =   (DATEPART(week, CATSDB.Workdate) - DATEPART(week, DATEADD(day, 1, EOMONTH(CATSDB.Workdate, -1)))) + 1
		FROM dbo.lt_ftp_Time_Transactions CATSDB
		LEFT JOIN (SELECT DISTINCT ed.CostCenter, ed.PersonnelNumber
				FROM dbo.lt_ftp_Employee_Data ed
				INNER JOIN dbo.lt_ftp_Time_Transactions tt ON tt.PersonnelNumber = ed.PersonnelNumber
				WHERE TT.WorkDate between ed.StartDate AND ed.EndDate) ed2 ON LTRIM(RTRIM(CATSDB.PersonnelNumber)) = ed2.PersonnelNumber
		LEFT JOIN dbo.lt_ftp_Sales_Order_WBS vbap ON vbap.SalesDocument = CATSDB.Rec_SalesOrder
		LEFT JOIN dbo.bmt_FiscalPeriod fp ON fp.MonthName = FORMAT (CATSDB.CreatedOn,'MMM yyyy')
		left JOIN dbo.lt_ftp_Employee_Personnel_Workday PA0050 ON CATSDB.PersonnelNumber = PA0050.PersonnelNumber
		GROUP BY 
		CATSDB.ProcStatus 
		,CATSDB.PersonnelNumber 
		,CATSDB.AA_Type 
		,CATSDB.ActivityType 
		,CATSDB.Rec_WBSElement 
		,CATSDB.Rec_CostCenter 
		,CATSDB.SenderCostCenter 
		,CATSDB.ControllingArea 
		,CATSDB.Rec_SalesOrder 
		,CATSDB.Rec_CostObject 
		,CATSDB.CreatedOn 
		,CATSDB.UnitofMeasure 
		,CATSDB.Bill_Indicator 
		,ISNULL(PA0050.TimeRecIdNo,LTRIM(RTRIM(CATSDB.PersonnelNumber)))
		,IIF(vbap.ProfitSegment IS NOT NULL,Concat('PR',Right(Concat('00000000',LTRIM(RTRIM(vbap.ProfitSegment))),8)),NULL)
		,CASE WHEN LEN(CATSDB.Rec_WBSElement) > 0  THEN LTRIM(RTRIM(CATSDB.Rec_WBSElement))
									ELSE
										CASE WHEN LEN(CATSDB.Rec_SalesOrder) > 0 THEN CATSDB.Rec_SalesOrder
										ELSE 
											CASE WHEN LEN(CATSDB.Rec_CostCenter) > 0 THEN CATSDB.Rec_CostCenter
											ELSE 
												CASE WHEN LEN(ed2.CostCenter) > 0 THEN ed2.CostCenter
												END
											END
										END 
									END
		,format (CATSDB.Workdate, 'yyyy-MM-01')
		,fp.FiscalPeriod
		,(DATEPART(week, CATSDB.Workdate) - DATEPART(week, DATEADD(day, 1, EOMONTH(CATSDB.Workdate, -1)))) + 1
		)  tt
	
	--vw_ftp_Time_Transactions  tt
	left JOIN (SELECT DISTINCT PersonnelNumber, CompanyCode, StartDate, EndDate, PersonnelSubArea, PersonnelArea  FROM dbo.lt_ftp_Employee_Data) PA0001 ON PA0001.PersonnelNumber = tt.PersonelID and tt.ActivityMonth between pa0001.StartDate and PA0001.EndDate
	left JOIN dbo.lt_ftp_Employee_Personnel_Workday PA0050 ON tt.PersonelID = PA0050.PersonnelNumber
	left JOIN dbo.lt_esbw_emp LEE ON tt.EmployeeID = lee.EmployeeID 
	LEFT JOIN dbo.lt_ftp_Personnel_Group_Data T001P ON (PA0001.PersonnelSubArea = T001P.PersonnelSubArea) AND (PA0001.PersonnelArea = T001P.PersonnelArea)
	LEFT JOIN lt_bmt_aatype lba on lba.AATypeCode = tt.AAType 
	LEFT JOIN dbo.esbw_PostingObject tep ON tep.FinalCostObject = tt.SenderCostObject
	LEFT JOIN dbo.esbw_PostingObject tep2 ON tep2.FinalCostObject = tt.ValueRecPostObj
	LEFT JOIN dbo.bs_bmt_CC_FTP2C1 ccf ON tt.SenderCostObject = ccf.FTP_CostCenter ------ TO GET THE C1_CostCenter
	LEFT JOIN dbo.esbw_PostingObject tep3 ON tep3.FinalCostObject = ccf.C1_CostCenter -- to Get SenderPostingObjectId using C1_CostCenter
	LEFT JOIN dbo.lt_FTP_WBS prps ON prps.ObjectNumber = tt.ProfitSegment1
	LEFT JOIN dbo.esbw_CompanyCodeMD ccm ON ccm.CompanyCode = PA0001.CompanyCode
	Where lba.Filesource = 'FTP' --and tt.PersonelID = 778
		-- AND FiscalPeriod = 'FY2023-10'
		-- AND AAType = 'SICK'
		-- AND PersonelID = '2197'
		-- AND ActivityWeek = 1
	GROUP BY 
		tt.FiscalPeriod           
		,tt.ActivityMonth
		,ISNULL(ccm.LegalCompanyCode,' ')
		,tt.ProcessingStatus        
		,tt.PersonelID             
		,lee.EEcomp
		,tt.EmployeeID
		,lee.Status
		,ISNULL(lee.ManagerID,' ')
		,ISNULL(lee.ManagarEEComp,' ')
		,ISNULL(lee.OrgID,' ')
		,T001P.PS_Group
		,tt.AAType                 
		,lba.AATypeIndicator
		,tt.ActivityType           
		,tt.Hours
		,tt.ReceivingWBS           
		,tt.ReceivingCostCenter    
		,tt.SenderCostObject       
		,tt.ControllingArea        
		,tt.ReceivingServiceOrder  
		,tt.ReceivingCostObject    
		,CASE WHEN LEN(tt.ReceivingCostCenter) > 0 THEN ISNULL(LEFT(prps.WorkBreakdownStructure,18),' ')
				ELSE ISNULL(LEFT(tep2.PostingObjectID,18),' ') END
		,tt.ActivityWeek
		,ISNULL(ISNULL(tep.PostingObjectID,tep3.PostingObjectID),'')
		,lba.AATypeSummaryCode
		,tt.Unit                   
		,tep.BillabilityCode
		,tt.GSAPProjectKey



SELECT 
	Scenario               
	,Source                
	,MAX(ActivityMonth) AS ActivityMonth
	,FiscalPeriod           
	,FiscalYearVariant      
	,CompanyCode           
	,ProcessingStatus        
	,PersonelID             
	,EEComp                
	,EmployeeID
	,EmpStatus              
	,EmpManagerID           
	,ManagerComp            
	,OrgID                  
	,PSGrouping             
	,AAType                 
	,AATypeIndicator        
	,ActivityType           
	,ReceivingWBS           
	,ReceivingCostCenter    
	,SenderCostObject       
	,ControllingArea        
	,MasterData             
	,ReceivingServiceOrder  
	,ReceivingCostObject    
	,ReceivingPostingObjectID 
	,ActivityWeek			
	,SenderPostingObjectID  
	,CrossTag               
	,DTagDescription        
	,AATypeSummaryCode      
	,CreatedOn              
	,Unit                   
	,SUM(Hours) AS Hours
	,LoadingTime
	,BillableCode       
	,Available_Hours    
	,ActivityMonth_Reporting 
	,PersonelID_GA          
	,GSAPProjectKey
	,CrossSysWBS            
FROM #ftp_esbw
GROUP BY 
	Scenario               
	,Source                
	,FiscalPeriod           
	,FiscalYearVariant      
	,CompanyCode           
	,ProcessingStatus        
	,PersonelID             
	,EEComp                
	,EmployeeID
	,EmpStatus              
	,EmpManagerID           
	,ManagerComp            
	,OrgID                  
	,PSGrouping             
	,AAType                 
	,AATypeIndicator        
	,ActivityType           
	,ReceivingWBS           
	,ReceivingCostCenter    
	,SenderCostObject       
	,ControllingArea        
	,MasterData             
	,ReceivingServiceOrder  
	,ReceivingCostObject    
	,ReceivingPostingObjectID 
	,ActivityWeek			
	,SenderPostingObjectID  
	,CrossTag               
	,DTagDescription        
	,AATypeSummaryCode      
	,CreatedOn              
	,Unit                   
	,LoadingTime
	,BillableCode       
	,Available_Hours    
	,ActivityMonth_Reporting 
	,PersonelID_GA          
	,GSAPProjectKey
	,CrossSysWBS

END