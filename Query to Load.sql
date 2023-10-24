SELECT 
	Scenario               = 'Actual'
	,Source                 = 'FTP'
	,ActivityMonth       
	,tt.FiscalPeriod           
	,FiscalYearVariant      = 'NC'
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
	,MasterData             = 'FTP'
	,tt.ReceivingServiceOrder  
	,tt.ReceivingCostObject    
	,tt.ReceivingPostingObjectID 
	,tt.ActivityWeek
	,tt.SenderPostingObjectID  
	,CrossTag               = ' ' --NULL--WIP
	,DTagDescription        = NULL --WIP
	,tt.AATypeSummaryCode      
	,CreatedOn              = left(FORMAT (GETDATE(), 'yyyyMMdd'),8)
	,tt.Unit                   
	,SUM(tt.Hours) AS Hours
	,LoadingTime            = getdate()
	,tt.BillableCode           
	,Available_Hours        = Null
	,LEFT(ActivityMonth_Reporting ,7) AS ActivityMonth_Reporting
	,PersonelID_GA          = ' ' --Null
	,tt.GSAPProjectKey
	,CrossSysWBS            = NULL --WIP
FROM vw_ftp_esbw_data tt
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