SELECT PostObjDescription   = LEFT(pc.ProfitCenterName,40)
      ,ReportingType        = 'E'  
      ,ControllingArea      = NULL
      ,ProfitCenter         = PC.ProfitCenter
      ,CompanyCode          = NULL
      ,CompanyCodeDescription = NULL
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
      ,[CostObject]         = NULL
      ,ChangedOn            = format(getdate(), 'yyyyMMdd') 
      ,FinalCostObject      = LEFT(pc.ProfitCenter,10)
      ,MH_NodeParent        = 'Unattached Profit Centers'
  FROM gsap_ProfitCenters pc
  LEFT JOIN bmt_PostingObject POMD 
        ON PC.ProfitCenter = POMD.ProfitCenter
   WHERE POMD.PostingObjectID IS NULL