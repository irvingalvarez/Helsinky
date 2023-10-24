with cte_ftp_Time_Transactions as (
SELECT DISTINCT --TOP 100
ProcessingStatus       = CATSDB.ProcStatus 
,PersonelID             = CATSDB.PersonnelNumber 
,AAType                 = CATSDB.AA_Type 
,ActivityType           = CATSDB.ActivityType 
,ReceivingWBS           = CATSDB.Rec_WBSElement 
,ReceivingCostCenter    = CATSDB.Rec_CostCenter 
,SenderCostObject       = CATSDB.SenderCostCenter 
,ControllingArea        = CATSDB.ControllingArea 
,ReceivingServiceOrder  = CATSDB.Rec_SalesOrder 
,ReceivingCostObject    = CATSDB.Rec_CostObject 
,CreatedOn              = CATSDB.CreatedOn 
,Unit                   = CATSDB.UnitofMeasure 
,Hours                  = CATSDB.Hours 
,GSAPProjectKey         = CATSDB.Bill_Indicator 
,ProfitSegment1			= IIF(vbap.ProfitSegment IS NOT NULL,Concat('PR',Right(Concat('00000000',LTRIM(RTRIM(vbap.ProfitSegment))),8)),NULL)
,ValueRecPostObj = CASE WHEN LEN(CATSDB.Rec_WBSElement) > 0  THEN CATSDB.Rec_WBSElement
							ELSE
								CASE WHEN LEN(CATSDB.Rec_SalesOrder) > 0 THEN CATSDB.Rec_SalesOrder
								ELSE 
									-- CASE WHEN LEN(CATSDB.Rec_CostCenter) > 0 THEN CATSDB.Rec_CostCenter
									-- ELSE 
										CASE WHEN LEN(ed2.CostCenter) > 0 THEN ed2.CostCenter
										END
									END
								END 
							END
,ActivityMonth          = CATSDB.Workdate
,FiscalPeriod           = CATSDB.CreatedOn
,ActivityWeek           = CATSDB.Workdate   --Monthly Week
FROM dbo.lt_ftp_Time_Transactions CATSDB
LEFT JOIN (SELECT ed.CostCenter, ed.PersonnelNumber
		FROM dbo.lt_ftp_Employee_Data ed
		INNER JOIN dbo.lt_ftp_Time_Transactions tt ON tt.PersonnelNumber = ed.PersonnelNumber
		WHERE TT.WorkDate between ed.StartDate AND ed.EndDate) ed2 ON CATSDB.PersonnelNumber = ed2.PersonnelNumber
LEFT JOIN dbo.lt_ftp_Sales_Order_WBS vbap ON vbap.SalesDocument = CATSDB.Rec_SalesOrder
)        

SELECT DISTINCT
tt.ProcessingStatus        
,tt.PersonelID             
,tt.AAType                 
,tt.ActivityType           
,tt.ReceivingWBS           
,tt.ReceivingCostCenter    
,tt.SenderCostObject       
,tt.ControllingArea        
,tt.ReceivingServiceOrder  
,tt.ReceivingCostObject    
,tt.CreatedOn              
,tt.Unit                   
,tt.Hours                  
,tt.GSAPProjectKey
,Scenario               = 'Actual'
,Source                 = 'FTP'
,FiscalYearVariant      = 'NC'
,MasterData             = 'FTP'
,Available_Hours        = 'Null'
,PersonelID_GA          = 'Null'
,CompanyCode            = PA0001.CompanyCode
,EEComp                 = lee.EEcomp
,EmployeeID             = PA0050.TimeRecIdNo
,EmpStatus              = lee.Status
,EmpManagerID           = lee.ManagerID
,ManagerComp            = lee.ManagarEEComp
,OrgID                  = lee.OrgID
,PSGrouping             = T001P.PS_Group
,AATypeIndicator        = lba.AATypeIndicator
--,tt.ValueRecPostObj
--,ReceivPostObj      = tep2.PostingObjectID
,ReceivingPostingObjectID = CASE WHEN LEN(tt.ReceivingCostCenter) > 0 
                                THEN prps.WorkBreakdownStructure
                            ELSE 
                                tep2.PostingObjectID 
                            END
,SenderPostingObjectID  = tep.PostingObjectID
,AATypeSummaryCode      = lba.AATypeSummaryCode
,BillableCode           = tep.BillabilityCode
,tt.ActivityMonth          
,tt.FiscalPeriod           
,tt.ActivityWeek           
,CrossTag               = NULL--WIP
,DTagDescription        = NULL --WIP
,LoadingTime            = getdate()
,ActivityMonth_Reporting = NULL --FORMULA
,CrossSysWBS            = NULL --WIP
FROM cte_ftp_Time_Transactions  tt
LEFT JOIN dbo.lt_ftp_Employee_Data PA0001 ON PA0001.PersonnelNumber = tt.PersonelID
LEFT JOIN dbo.lt_ftp_Employee_Personnel_Workday PA0050 ON tt.PersonelID = PA0050.PersonnelNumber
LEFT JOIN dbo.lt_esbw_emp LEE ON PA0050.TimeRecIdNo = lee.EmployeeID 
LEFT JOIN dbo.lt_ftp_Personnel_Group_Data T001P ON (PA0001.PersonnelSubArea = T001P.PersonnelSubArea) AND (PA0001.PersonnelArea = T001P.PersonnelArea)
LEFT JOIN lt_bmt_aatype lba on lba.AATypeCode = tt.AAType 
LEFT JOIN dbo.esbw_PostingObject tep ON tep.FinalCostObject = tt.SenderCostObject
LEFT JOIN dbo.esbw_PostingObject tep2 ON tep2.FinalCostObject = tt.ValueRecPostObj
LEFT JOIN dbo.lt_FTP_WBS prps ON prps.ObjectNumber = tt.ProfitSegment1

