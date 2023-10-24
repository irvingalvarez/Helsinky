DECLARE @nMissingWBS int, @nMissingCost int, @nMissingPC int, @nMissingROPO int
SET @nMissingWBS = (SELECT PostingObjectID FROM bmt_PostingObject WHERE PostObjDescription = 'Missing WBS')
SET @nMissingCost = (SELECT PostingObjectID FROM bmt_PostingObject WHERE PostObjDescription = 'Missing CostObjects')
SET @nMissingPC = (SELECT PostingObjectID FROM bmt_PostingObject WHERE PostObjDescription = 'Missing ProfitCenters')
SET @nMissingROPO = (SELECT PostingObjectID FROM bmt_PostingObject WHERE PostObjDescription = 'Missing ROPO')

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
    ,CASE WHEN glp.WBS_ELEMENT <> '#'  
    THEN  CASE WHEN WBS.PostingObjectID IS NOT NULL 
        THEN WBS.MH_ParentNode 
        ELSE 'Missing WBS PostObj' END
	WHEN glp.CostObject <> '#'  
        THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
        THEN LH.MH_ParentNode  
        ELSE 'Missing CostObj PostObj' END 
	WHEN glp.ProfitCenter <> '#'   
        THEN CASE WHEN PC.PostingObjectID IS NOT NULL 
        THEN pc.MH_ParentNode 
        ELSE 'Missing ProfitCtr PostObj' END
	WHEN rop1.ROPO_ID IS NOT NULL
        THEN rop.MH_ParentNode 
        ELSE 'Missing ROPO PostObj' 
    END AS MH_ParentNode
      ,ControllingArea  = glp.ControllingNumber
      ,CASE WHEN glp.WBS_ELEMENT <> '#'  
        THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
            THEN WBS.FunctionalArea 
           END 
        WHEN glp.CostObject <> '#'  
            THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
            THEN LH.FunctionalArea 
          END
        WHEN glp.ProfitCenter <> '#'   
          THEN pc.FunctionalArea 
      END AS FunctionalArea
     ,CASE WHEN glp.WBS_ELEMENT <> '#' 
			THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
				THEN WBS.PostingObjectID 
				ELSE @nMissingWBS END 
			WHEN glp.CostObject <> '#' 
				THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
				THEN LH.PostingObjectID 
				ELSE @nMissingCost END
			WHEN glp.ProfitCenter <> '#'  
				THEN CASE WHEN PC.PostingObjectID IS NOT NULL
				THEN pc.PostingObjectID 
				ELSE @nMissingPC END
			WHEN rop1.ROPO_ID IS NOT NULL
				THEN rop.PostingObjectID 
				ELSE @nMissingROPO 
		  END AS PostingObjectID  
      ,glp.CostObject
      ,glp.WBS_Element
      ,BusinessType     = 'O'  
      ,GroupAccount     = glp.AccountNumber
      ,DocumentCurrency = glp.[CurrencyKey]
      ,DocumentAmount    = SUM(CONVERT(DECIMAL(12,2),glp.TransAmount)) 
      ,LocalCurrency    = coc.Currency
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
LEFT OUTER JOIN bmt_ROPO rop1
    ON glp.CompanyCode = rop1.CompanyCode AND glp.FunctionalArea = rop1.FunctionalArea
LEFT OUTER JOIN bmt_PostingObject ROP
    ON rop1.ROPO_ID = rop.FinalCostObject
LEFT OUTER JOIN bmt_CompanyCodes coc
	ON glp.CompanyCode = coc.CompanyCode

GROUP BY 
    glp.CompanyCode
    ,glp.ProfitCenter
    ,glp.BusinessArea
    ,CASE WHEN glp.WBS_ELEMENT <> '#'  
        THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
            THEN WBS.FunctionalArea 
           END 
        WHEN glp.CostObject <> '#'  
            THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
            THEN LH.FunctionalArea 
          END
        WHEN glp.ProfitCenter <> '#'  
          THEN pc.FunctionalArea 
      END
    ,glp.ControllingNumber      
    ,glp.AccountNumber
    ,CASE WHEN glp.WBS_ELEMENT <> '#' 
			THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
				THEN WBS.PostingObjectID 
				ELSE @nMissingWBS END 
			WHEN glp.CostObject <> '#' 
				THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
				THEN LH.PostingObjectID 
				ELSE @nMissingCost END
			WHEN glp.ProfitCenter <> '#'  
				THEN CASE WHEN PC.PostingObjectID IS NOT NULL
				THEN pc.PostingObjectID 
				ELSE @nMissingPC END
			WHEN rop1.ROPO_ID IS NOT NULL
				THEN rop.PostingObjectID 
				ELSE @nMissingROPO 
		  END   
    ,wbs.CustomerCode
    ,wbs.CustomerName
,CASE WHEN glp.WBS_ELEMENT <> '#'  
    THEN  CASE WHEN WBS.PostingObjectID IS NOT NULL 
        THEN WBS.MH_ParentNode 
        ELSE 'Missing WBS PostObj' END
	WHEN glp.CostObject <> '#'  
        THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
        THEN LH.MH_ParentNode  
        ELSE 'Missing CostObj PostObj' END 
	WHEN glp.ProfitCenter <> '#'   
        THEN CASE WHEN PC.PostingObjectID IS NOT NULL 
        THEN pc.MH_ParentNode 
        ELSE 'Missing ProfitCtr PostObj' END
	WHEN rop1.ROPO_ID IS NOT NULL
        THEN rop.MH_ParentNode 
        ELSE 'Missing ROPO PostObj' 
    END
     ,fp.FiscalPeriod
     ,glp.CostObject
     ,glp.WBS_Element
     ,glp.LocalAmount
     ,glp.CurrencyKey
     ,coc.Currency