ALTER VIEW vw_ftp_Time_Transactions AS 

SELECT DISTINCT 
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
