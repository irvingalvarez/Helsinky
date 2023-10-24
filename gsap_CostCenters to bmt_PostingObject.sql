SELECT PostObjDescription   = LEFT(cc.CostCenterDescription,40)
      ,ReportingType        = 'B'  
      ,ControllingArea      = cc.ControllingArea
      ,ProfitCenter         = cc.ProfitCenter
      ,CompanyCode          = cc.CompanyCode
      ,CompanyCodeDescription = cc.CompanyCode
      ,CountryCode           = pc.Country
      ,CountryCodeDescription = pc.CountryDescription 
      ,FunctionalArea       = pc.LineOfBusiness
      ,CustomerCode         = NULL
      ,CustomerName         = NULL
      ,ClientGroup          = pc.ClientGroup
      ,[ClientGroupDescription] = pc.ClientGroupDescription
      ,[Industry]           = pc.IndustrySectorL1
      ,[IndustryDescription] = pc.IndustrySectorL1Description
      ,[ServiceOffering]    = pc.IndustrySectorL2
      ,[ServiceOfferingDescription] = pc.IndustrySectorL2Description
      ,[OfferingPortfolio]  = pc.OfferingPortfolio
      ,[OfferingPortfolioDescription] = pc.OfferingPortfolioDescription
      ,[WBS_Element]        = NULL
      ,[CostObject]         = cc.CostCenter
      ,MH_NodeParent        = 'Unattached Cost Centers'
      ,FinalCostObject      = LEFT(cc.CostCenter,10)
    ,ChangedOn            = format(getdate(), 'yyyyMMdd') 
  FROM gsap_CostCenters cc
  LEFT JOIN gsap_ProfitCenters pc
        ON cc.ProfitCenter = pc.ProfitCenter
  LEFT JOIN bmt_PostingObject POMD 
        ON cc.CostCenter = POMD.CostObject
   WHERE POMD.PostingObjectID IS NULL