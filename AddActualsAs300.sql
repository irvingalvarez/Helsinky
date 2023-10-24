SELECT 
PL.Source, 
'300' AS Version, 
(SELECT VersionName FROM bmt_Version WHERE ReportingVersion = '300') AS Scenario,
PL.FiscalPeriod, 
PL.CompanyCode, 
PL.ProfitCenter, 
PL.BusinessArea,
PL.CustomerCode,
PL.CustomerName,
PO.MH_ParentNode, 
PL.ControllingArea,
PL.FunctionalArea, 
PL.PostingObjectID,
PL.CostObject, 
PL.WBS_Element, 
PL.BusinessType, 
PL.GroupAccount, 
PL.DocumentCurrency, 
PL.DocumentAmount,
PL.LocalCurrency, 
PL.LocalAmount, 
PL.GroupAmountUSD, 
PL.HeadcountType, 
PL.Headcount	
FROM rpt_ProfitLossSummary PL
INNER JOIN Fiscal_Periods FP 
    ON PL.FiscalPeriod = FP.FiscalPeriod
LEFT JOIN bmt_PostingObject PO
	ON PL.PostingObjectID = PO.PostingObjectID
WHERE Version = '100' AND FP.RelativeYearOffset = 0 AND FP.RelativeMonthOffset <= 0