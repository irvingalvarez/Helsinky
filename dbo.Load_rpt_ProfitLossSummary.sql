IF EXISTS (SELECT * FROM bmt_PlanStaging) 
BEGIN
  /* =============================================================================================================================================
    rpt_ProfitLossSummary Load
    ================================================================================================================================================*/

    SELECT ps.PostingObjectID
        ,ps.Version
        ,ps.FiscalPeriod
        ,fp.RelativeMonthOffset
        ,fy.RelativeYearOffset
        ,po.CompanyCode
        ,ProfitCenter = ISNULL(po.ProfitCenter,'#')
        ,BusinessArea = NULL
        ,CustomerCode = NULL
        ,CustomerName = NULL
        ,po.MH_ParentNode
        ,po.ControllingArea
        ,po.FunctionalArea
        ,po.CostObject
        ,po.WBS_Element
        ,ps.BusinessType
        ,ps.GroupAccount
        ,ISNULL(ps.LocalCurrency,0) AS DocumentCurrency -- CHECK
        ,ISNULL(ps.LocalAmount,0) AS DocumentAmount     -- CHECK
        ,ISNULL(ps.LocalCurrency,0) AS LocalCurrency
        ,ISNULL(ps.LocalAmount,0) AS LocalAmount
        ,ps.GroupAmount AS GroupAmountUSD-- GROUP AMOUNT USD 
        ,ps.HeadcountType
        ,ISNULL(ps.Headcount,0) as Headcount
    INTO #tmpPlan
    FROM [dbo].[bmt_Plan] ps
    INNER JOIN [bmt_PostingObject] po
    ON po.FinalCostObject = ps.FinalCostObject
    LEFT JOIN bmt_FiscalPeriod fp
    ON ps.FiscalPeriod = fp.FiscalPeriod
    LEFT JOIN bmt_FiscalYear fy
    ON LEFT(ps.FiscalPeriod,6) = fy.FiscalYear

/* =============================================================================================================================================
Reload Version 300 to rpt_ProfitLossSummary
================================================================================================================================================*/
IF EXISTS (SELECT * FROM bmt_PlanStaging WHERE Version = 300 )
BEGIN
    DELETE FROM rpt_ProfitLossSummary 
    WHERE Version = 300 AND FiscalPeriod 
    IN (SELECT pl.FiscalPeriod 
        FROM rpt_ProfitLossSummary pl
        LEFT JOIN #tmpPlan ps
        ON pl.FiscalPeriod = ps.FiscalPeriod
        WHERE RelativeMonthOffset >= 1
        )

    INSERT INTO rpt_ProfitLossSummary
    SELECT
    'FDP' AS Source
    ,[Version]
    ,Scenario = (SELECT VersionName FROM bmt_Version WHERE ReportingVersion = '300')
    ,[FiscalPeriod]
    ,[CompanyCode]
    ,[ProfitCenter]
    ,BusinessArea 
    ,CustomerCode 
    ,CustomerName
    ,MH_ParentNode 
    ,[ControllingArea]
    ,[FunctionalArea]
    ,[PostingObjectID]
    ,[CostObject]
    ,[WBS_Element]
    ,[BusinessType]
    ,[GroupAccount]
    ,[DocumentCurrency]
    ,[DocumentAmount]
    ,[LocalCurrency]
    ,[LocalAmount]
    ,0 AS GroupAmountUSD -- GROUP AMOUNT IS NULL IN bmt_Plan
    ,[HeadcountType]
    ,[Headcount]
    --SELECT * 
    FROM #tmpPlan
    WHERE Version = 300
    AND RelativeMonthOffset >= 1
END

/* =============================================================================================================================================
Reload Version 730 to rpt_ProfitLossSummary
================================================================================================================================================*/
IF EXISTS (SELECT * FROM bmt_PlanStaging WHERE Version = 730)
BEGIN
    DELETE FROM rpt_ProfitLossSummary WHERE Version = 730
    INSERT INTO rpt_ProfitLossSummary
    SELECT
    'FDP' AS Source
    ,[Version]
    ,Scenario = (SELECT VersionName FROM bmt_Version WHERE ReportingVersion = '730')
    ,[FiscalPeriod]
    ,[CompanyCode]
    ,[ProfitCenter]
    ,[BusinessArea]
    ,CustomerCode 
    ,CustomerName
    ,MH_ParentNode 
    ,[ControllingArea]
    ,[FunctionalArea]
    ,[PostingObjectID]
    ,[CostObject]
    ,[WBS_Element]
    ,[BusinessType]
    ,[GroupAccount]
    ,[DocumentCurrency]
    ,[DocumentAmount]
    ,[LocalCurrency]
    ,[LocalAmount]
    ,0 AS GroupAmountUSD
    ,[HeadcountType]
    ,[Headcount]
    FROM #tmpPlan
    WHERE Version = 730
END

END