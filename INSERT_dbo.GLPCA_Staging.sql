DECLARE @nMissingWBS int, @nMissingCost int, @nMissingPC int
SET @nMissingWBS = (SELECT PostingObjectID FROM bmt_PostingObject WHERE PostObjDescription = 'Missing WBS')
SET @nMissingCost = (SELECT PostingObjectID FROM bmt_PostingObject WHERE PostObjDescription = 'Missing CostObjects')
SET @nMissingPC = (SELECT PostingObjectID FROM bmt_PostingObject WHERE PostObjDescription = 'Missing ProfitCenters')

SELECT 
      Source        = 'GSAP'
      ,Version      = '100'
      ,Scenario     = 'Actuals'       
      ,fp.FiscalPeriod
      ,glp.CompanyCode
      ,glp.ProfitCenter
      ,glp.BusinessArea
      ,CustomerCode     = wbs.CustomerCode
      ,CustomerName     = wbs.CustomerName
    ,CASE WHEN glp.WBS_ELEMENT IS NOT NULL OR glp.WBS_ELEMENT <> '#' 
        THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
            THEN WBS.MH_ParentNode
			ELSE 'Missing WBS' END 
        WHEN glp.CostObject IS NOT NULL OR glp.CostObject <> '#'
            THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
            THEN LH.MH_ParentNode 
			ELSE 'Missing CostObjects' END
        WHEN glp.ProfitCenter IS NOT NULL OR glp.ProfitCenter <> '' 
            THEN CASE WHEN PC.PostingObjectID IS NOT NULL
            THEN pc.MH_ParentNode 
            ELSE 'Missing ProfitCenters' END
      END AS MH_ParentNode
      ,ControllingArea  = glp.ControllingNumber
      ,CASE WHEN glp.WBS_ELEMENT IS NOT NULL OR glp.WBS_ELEMENT <> '#' 
        THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
            THEN WBS.FunctionalArea 
           END 
        WHEN glp.CostObject IS NOT NULL OR glp.CostObject <> '#'
            THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
            THEN LH.FunctionalArea 
          END
        WHEN glp.ProfitCenter IS NOT NULL OR glp.ProfitCenter <> '' 
          THEN pc.FunctionalArea 
      END AS FunctionalArea
     ,CASE WHEN glp.WBS_ELEMENT IS NOT NULL OR glp.WBS_ELEMENT <> '#' 
        THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
            THEN WBS.PostingObjectID 
            ELSE @nMissingWBS END 
        WHEN glp.CostObject IS NOT NULL OR glp.CostObject <> '#'
            THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
            THEN LH.PostingObjectID 
            ELSE @nMissingCost END
        WHEN glp.ProfitCenter IS NOT NULL OR glp.ProfitCenter <> '' 
            THEN CASE WHEN PC.PostingObjectID IS NOT NULL
            THEN pc.PostingObjectID 
            ELSE @nMissingPC END
      END AS PostingObjectID  
      ,glp.CostObject
      ,glp.WBS_Element
      ,BusinessType     = 'O'  
      ,GroupAccount     = glp.AccountNumber
      ,DocumentCurrency = glp.[CurrencyKey]
      ,DocumentAmount    = SUM(CONVERT(DECIMAL(12,2),glp.TransAmount)) 
      ,LocalCurrency    = glp.[CurrencyKey]
      ,LocalAmount      = SUM(CONVERT(DECIMAL(12,2),glp.LocalAmount))
      ,GroupAmountUSD   = SUM(CONVERT(DECIMAL(12,2),glp.ProfitCenterAmount))
      ,HeadcountType    = '0'
      ,Headcount        = 0
  FROM [Helsinki].[dbo].[gsap_GLPCA] glp
  INNER JOIN tmp_PeriodsPosted FP 
    ON 'FY' + glp.FiscalYear + '-' + RIGHT('0' + glp.PostingPeriod, 2) = FP.FiscalPeriod
LEFT OUTER JOIN bmt_PostingObject WBS 
    ON glp.WBS_Element = WBS.WBS_Element AND glp.ControllingNumber = wbs.ControllingArea and wbs.ReportingType = 'A'
LEFT OUTER JOIN bmt_PostingObject LH 
    ON glp.CostObject = LH.CostObject AND glp.ControllingNumber = lh.ControllingArea and lh.ReportingType = 'B'   
LEFT OUTER JOIN bmt_PostingObject PC 
    ON glp.ProfitCenter = PC.ProfitCenter  AND glp.ControllingNumber = pc.ControllingArea and pc.ReportingType = 'E' 
--WHERE pc.PostingObjectID IS NOT NULL 

GROUP BY 
    glp.CompanyCode
    ,glp.ProfitCenter
    ,glp.BusinessArea
    ,CASE WHEN glp.WBS_ELEMENT IS NOT NULL OR glp.WBS_ELEMENT <> '#' 
        THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
            THEN WBS.FunctionalArea 
           END 
        WHEN glp.CostObject IS NOT NULL OR glp.CostObject <> '#' 
            THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
            THEN LH.FunctionalArea 
          END
        WHEN glp.ProfitCenter IS NOT NULL OR glp.ProfitCenter <> '' 
            THEN pc.FunctionalArea 
      END
    ,glp.ControllingNumber      
    ,glp.AccountNumber
    ,CASE WHEN glp.WBS_ELEMENT IS NOT NULL OR glp.WBS_ELEMENT <> '#' 
        THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
            THEN WBS.PostingObjectID 
            ELSE @nMissingWBS END 
        WHEN glp.CostObject IS NOT NULL OR glp.CostObject <> '#' 
            THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
            THEN LH.PostingObjectID 
            ELSE @nMissingCost END
        WHEN glp.ProfitCenter IS NOT NULL OR glp.ProfitCenter <> '' 
            THEN CASE WHEN PC.PostingObjectID IS NOT NULL
            THEN pc.PostingObjectID 
            ELSE @nMissingPC END
      END
    ,wbs.CustomerCode
    ,wbs.CustomerName
,CASE WHEN glp.WBS_ELEMENT IS NOT NULL OR glp.WBS_ELEMENT <> '#' 
        THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
            THEN WBS.MH_ParentNode
			ELSE 'Missing WBS' END 
        WHEN glp.CostObject IS NOT NULL OR glp.CostObject <> '#' 
            THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
            THEN LH.MH_ParentNode 
			ELSE 'Missing CostObjects' END
        WHEN glp.ProfitCenter IS NOT NULL OR glp.ProfitCenter <> '' 
            THEN CASE WHEN PC.PostingObjectID IS NOT NULL
            THEN pc.MH_ParentNode 
            ELSE 'Missing ProfitCenters' END
      END
     ,fp.FiscalPeriod
     ,glp.CostObject
     ,glp.WBS_Element
     ,glp.LocalAmount
     ,glp.CurrencyKey