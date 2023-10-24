IF EXISTS (SELECT * FROM bmt_PlanStaging) 
BEGIN

    /* =============================================================================================================================================
    Forecast Delta Process
    ================================================================================================================================================*/

    SELECT ps.PostingObjectID
        ,ps.Version
        ,ps.FiscalPeriod
        ,ps.BusinessType
        ,GroupAccount = Replace(Ltrim(Replace(ps.GroupAccount, '0', ' ')), ' ', '0')
        ,ps.CompanyCode
        ,ps.ControllingArea
        ,ps.ReportingType
        ,ps.LocalCurrency 
        ,ps.LocalAmount 
        ,ps.GroupAmount 
        ,ps.FinalCostObject
        ,ps.HeadcountType
        ,ps.Headcount
    INTO #tmpPlanStaging 
    FROM [dbo].[bmt_PlanStaging] ps
    INNER JOIN [bmt_PostingObject] po
    ON po.FinalCostObject = ps.FinalCostObject
	AND po.ReportingType = ps.ReportingType
	AND po.ControllingArea = ps.ControllingArea

    /* =============================================================================================================================================
    If bmt_PlanStaging row count > 0 and PostingObject is found load bmt_Plan 
    ================================================================================================================================================*/
    MERGE bmt_Plan AS Dtl
    USING #tmpPlanStaging AS Stg
    ON dtl.FinalCostObject = Stg.FinalCostObject
        AND dtl.version = stg.version
        AND Dtl.ReportingType = Stg.ReportingType 
        AND Dtl.ControllingArea = Stg.ControllingArea
        AND Dtl.FiscalPeriod = Stg.FiscalPeriod 
        AND Dtl.GroupAccount = Stg.GroupAccount
        AND Dtl.BusinessType = Stg.BusinessType
    WHEN MATCHED 
    THEN UPDATE SET 
    Dtl.LocalCurrency = Stg.LocalCurrency,
    Dtl.LocalAmount = Stg.LocalAmount,
    Dtl.GroupAmount = Stg.GroupAmount
    WHEN NOT MATCHED BY TARGET
    THEN INSERT
    VALUES
        (PostingObjectID
        ,Version
        ,FiscalPeriod
        ,BusinessType
        ,GroupAccount
        ,CompanyCode
        ,ControllingArea
        ,ReportingType
        ,LocalCurrency
        ,LocalAmount
        ,GroupAmount
        ,FinalCostObject
        ,HeadcountType
        ,Headcount
    )  
    ;

  

END