USE [OptimusPrime]
GO

/****** Object:  View [dbo].[vw_lt_ftp_esbw_data]    Script Date: 4/24/2023 7:40:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_lt_ftp_esbw_data] AS 
SELECT --top 100
	 CATSDB.ProcStatus						AS ProcessingStatus
	,CATSDB.PersonnelNumber					AS PersonelID
	,CATSDB.AA_Type							AS AAType
	,LEFT(lba.AATypeIndicator,1)			AS AATypeIndicator
	,CATSDB.ActivityType					AS ActivityType
	,CATSDB.Rec_WBSElement					AS ReceivingWBS
	,CATSDB.Rec_CostCenter					AS ReceivingCostCenter
	,IIF(LEN(CATSDB.SenderCostCenter) > 0, CATSDB.SenderCostCenter, ed2.CostCenter)  AS SenderCostObject  ------ Using ed2.CostCenter if SenderCostCenter is null
	,CATSDB.ControllingArea					AS ControllingArea
	,CATSDB.Rec_SalesOrder					AS ReceivingServiceOrder
	,CASE WHEN LEN(CATSDB.Rec_WBSElement) = 0 AND LEN(CATSDB.Rec_CostCenter) = 0 AND LEN(CATSDB.Rec_SalesOrder) = 0 THEN 
		IIF(LEN(CATSDB.SenderCostCenter) > 0, CATSDB.SenderCostCenter, ed2.CostCenter) --- Line added
	 WHEN LEN(CATSDB.Rec_SalesOrder) > 0 THEN 
		ISNULL(tep4.FinalCostObject,' ') 
	 ELSE ISNULL(tep2.FinalCostObject,' ') END AS ReceivingCostObject
	--,CATSDB.Rec_CostObject  AS ReceivingCostObject ----- value used to determine the Receiving posting object ID ???
	,CATSDB.CreatedOn						AS CreatedOn
	,CATSDB.UnitofMeasure					AS Unit
	,ISNULL(T001P.PS_Group, 0)				AS PSGrouping
	,CATSDB.Hours							AS Hours
	,CATSDB.Bill_Indicator					AS GSAPProjectKey
	,CASE WHEN lee.EmployeeID IS NULL THEN '00000001' ELSE ISNULL(PA0050.TimeRecIdNo,CATSDB.PersonnelNumber) END AS EmployeeID  -- if lee.employeid is null then '00000001'
	,IIF(vbap.ProfitSegment IS NOT NULL,Concat('PR',Right(Concat('00000000',vbap.ProfitSegment),8)),NULL) AS ProfitSegment1
	,CASE WHEN LEN(CATSDB.Rec_WBSElement) > 0  THEN CATSDB.Rec_WBSElement
		ELSE
			CASE WHEN LEN(CATSDB.Rec_SalesOrder) > 0 THEN CATSDB.Rec_SalesOrder
			ELSE 
				CASE WHEN LEN(CATSDB.Rec_CostCenter) > 0 THEN CATSDB.Rec_CostCenter
				ELSE 
					CASE WHEN LEN(ed2.CostCenter) > 0 THEN ed2.CostCenter
					END
				END
			END 
		END AS ValueRecPostObj
	,CASE WHEN LEN(CATSDB.Rec_SalesOrder) > 0 THEN 
		ISNULL(tep4.PostingObjectID,' ') 
	WHEN LEN(CATSDB.Rec_WBSElement) = 0 AND LEN(CATSDB.Rec_CostCenter) = 0 AND LEN(CATSDB.Rec_SalesOrder) = 0 THEN 
		ISNULL(ISNULL(tep.PostingObjectID,tep3.PostingObjectID),'1')  --- Line added
	ELSE ISNULL(LEFT(tep2.PostingObjectID,18),'1') END AS ReceivingPostingObjectID		
	,format (CATSDB.Workdate, 'yyyy-MM-01') AS ActivityMonth
	,fp.FiscalPeriod						AS FiscalPeriod
	,(DATEPART(week, CATSDB.Workdate) - DATEPART(week, DATEADD(day, 1, EOMONTH(CATSDB.Workdate, -1)))) + 1 AS ActivityWeek
	,lee.EEcomp								AS EEComp
	,lee.Status								AS EmpStatus
	,ISNULL(lee.ManagerID,' ')				AS EmpManagerID
	,ISNULL(lee.ManagarEEComp,' ')			AS ManagerComp
	,ISNULL(lee.OrgID,'00000000')			AS OrgID
	,ISNULL(lba.AATypeSummaryCode,' ')		AS AATypeSummaryCode
	,ISNULL(ccm.LegalCompanyCode,' ')		AS CompanyCode
	,CASE WHEN LEN(CATSDB.Rec_SalesOrder) > 0 THEN ISNULL(tep4.BillabilityCode,' ') 
		ELSE ISNULL(tep2.BillabilityCode,' ') END AS BillableCode
--	,tep.BillabilityCode AS BillableCode --- It needs to follow the same rule as ReceivingPostingObjectId 
	,ISNULL(ISNULL(tep.PostingObjectID,tep3.PostingObjectID),'1') AS SenderPostingObjectID
	,CONCAT(FORMAT(CATSDB.Workdate,'yyyy') , '-' , FORMAT(CATSDB.Workdate,'MM')) AS ActivityMonth_Reporting
	FROM dbo.lt_ftp_Time_Transactions CATSDB
	LEFT JOIN dbo.lt_ftp_Employee_Data ed2 ON CATSDB.PersonnelNumber = ed2.PersonnelNumber and catsdb.WorkDate between ed2.StartDate AND ed2.EndDate
	LEFT JOIN dbo.lt_ftp_Sales_Order_WBS vbap ON vbap.SalesDocument = CATSDB.Rec_SalesOrder
	LEFT JOIN dbo.bmt_FiscalPeriod fp ON fp.MonthName = FORMAT (CATSDB.CreatedOn,'MMM yyyy')
	left JOIN dbo.lt_ftp_Employee_Personnel_Workday PA0050 ON CATSDB.PersonnelNumber = PA0050.PersonnelNumber and catsdb.WorkDate between PA0050.BeginDate AND PA0050.EndDate
	LEFT JOIN dbo.lt_ftp_Personnel_Group_Data T001P ON (ed2.PersonnelSubArea = T001P.PersonnelSubArea) AND (ed2.PersonnelArea = T001P.PersonnelArea)
	left JOIN dbo.lt_esbw_emp LEE ON ISNULL(PA0050.TimeRecIdNo,CATSDB.PersonnelNumber) = CAST(lee.EmployeeID AS INT)
	LEFT JOIN (SELECT DISTINCT AATypeCode, AATypeIndicator, AATypeSummaryCode, FileSource FROM bmt_lt_ftp_aatype where FileSource = 'FTP') lba on lba.AATypeCode = CATSDB.AA_Type 
	LEFT JOIN dbo.esbw_CompanyCodeMD ccm ON ccm.CompanyCode = ed2.CompanyCode
	LEFT JOIN dbo.esbw_PostingObject tep ON tep.FinalCostObject = IIF(LEN(CATSDB.SenderCostCenter) > 0, CATSDB.SenderCostCenter, ed2.CostCenter) --CATSDB.SenderCostCenter
	LEFT JOIN dbo.bs_bmt_CC_FTP2C1 ccf ON IIF(LEN(CATSDB.SenderCostCenter) > 0, CATSDB.SenderCostCenter, ed2.CostCenter) = ccf.FTP_CostCenter ------ TO GET THE C1_CostCenter
	LEFT JOIN dbo.esbw_PostingObject tep3 ON tep3.FinalCostObject = ccf.C1_CostCenter -- to Get SenderPostingObjectId using C1_CostCenter
	LEFT JOIN lt_FTP_WBS prps ON prps.ObjectNumber = IIF(vbap.ProfitSegment IS NOT NULL,Concat('PR',Right(Concat('00000000',vbap.ProfitSegment),8)),NULL)
	LEFT JOIN dbo.esbw_PostingObject tep2 ON tep2.ReportingType IN ('G','H') 
    AND tep2.FinalCostObject = CASE WHEN LEN(CATSDB.Rec_WBSElement) > 0  THEN CATSDB.Rec_WBSElement
                                ELSE
                                    CASE WHEN LEN(CATSDB.Rec_SalesOrder) > 0 THEN CATSDB.Rec_SalesOrder
                                    ELSE 
                                        CASE WHEN LEN(CATSDB.Rec_CostCenter) > 0 THEN CATSDB.Rec_CostCenter
                                        ELSE 
                                            CASE WHEN LEN(ed2.CostCenter) > 0 THEN ed2.CostCenter
                                            END
                                        END
                                    END 
                                END  --DUPLICATED FINALCOSTOBJECTS
   LEFT JOIN dbo.esbw_PostingObject tep4 ON prps.WBS_Element = tep4.WBS_Element
GO


