SELECT PostObjDescription   = wb.Parent_DESC
      ,ReportingType        = 'A'  
      ,ControllingArea      = NULL   
      ,ProfitCenter         = wb.WBS_PRCTR
      ,CompanyCode          = wb.COMPANY_CODE
      ,CompanyCodeDescription = wb.COMPANY_CODE
      ,CountryCode           = pc.Country
      ,CountryCodeDescription = pc.CountryDescription 
      ,FunctionalArea       = pc.LineOfBusiness
      ,CustomerCode         = wb.WBS_CustomerCode
      ,CustomerName         = wb.WBS_CustomerName
      ,ClientGroup          = pc.ClientGroup
      ,[ClientGroupDescription] = pc.ClientGroupDescription
      ,[Industry]           = pc.IndustrySectorL1
      ,[IndustryDescription] = pc.IndustrySectorL1Description
      ,[ServiceOffering]    = pc.IndustrySectorL2
      ,[ServiceOfferingDescription] = pc.IndustrySectorL2Description
      ,[OfferingPortfolio]  = pc.OfferingPortfolio
      ,[OfferingPortfolioDescription] = pc.OfferingPortfolioDescription
      ,[WBS_Element]        = [wBS_Code]
      ,[CostObject]         = NULL
      ,FinalCostObject      = LEFT(wb.wBS_Code,10)
      ,MH_NodeParent        = 'Unattached WBS Elements'
      ,ChangedOn            = format(getdate(), 'yyyyMMdd') 
  FROM [Helsinki].[dbo].[gsap_WBS] wb
  LEFT JOIN gsap_ProfitCenters pc
        ON wb.WBS_PRCTR = pc.ProfitCenter
  LEFT JOIN bmt_PostingObject POMD 
        ON wb.Parent_WBS = POMD.WBS_Element


