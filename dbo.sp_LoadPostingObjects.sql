USE [Helsinki]
GO
/****** Object:  StoredProcedure [dbo].[sp_LoadPostingObjects]    Script Date: 3/9/2021 6:36:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC dbo.sp_LoadPostingObjects @ObjectType = 'ProfitCenters'
-- EXEC dbo.sp_LoadPostingObjects @ObjectType = 'CostCenters'
-- EXEC dbo.sp_LoadPostingObjects @ObjectType = 'WBS'


ALTER PROCEDURE [dbo].[sp_LoadPostingObjects]  @ObjectType varchar(20)
AS
BEGIN
SET NOCOUNT ON;

--DECLARE @ObjectType varchar(20)

IF @ObjectType = 'ProfitCenters' BEGIN

     /* =============================================================================================================================================
    Insert Values from ProfitCenters
    ================================================================================================================================================*/
    SELECT PostObjDescription   = LEFT(pc.ProfitCenterName,40)
        ,ReportingType        = 'E'  
        ,ControllingArea      = pc.ControllingArea
        ,ProfitCenter         = PC.ProfitCenter
        ,CompanyCode          = cod.CompanyCode --Taking only valid Company Codes
        ,CompanyCodeDescription = cod.CompanyCodeDescription
        ,CountryCode           = pc.Country
        ,CountryCodeDescription = pc.CountryDescription 
        ,FunctionalArea       = pc.LineOfBusiness
        ,CustomerCode         = NULL
        ,CustomerName         = NULL
        ,ClientGroup          = pc.ClientGroup
        ,ClientGroupDescription = pc.ClientGroupDescription
        ,Industry           = pc.IndustrySectorL1
        ,IndustryDescription = pc.IndustrySectorL1Description
        ,ServiceOffering    = pc.IndustrySectorL2
        ,ServiceOfferingDescription = pc.IndustrySectorL2Description
        ,OfferingPortfolio  = pc.OfferingPortfolio
        ,OfferingPortfolioDescription = pc.OfferingPortfolioDescription
        ,WBS_Element        = '#'
        ,CostObject         = '#'
        ,ChangedOn            = format(getdate(), 'yyyyMMdd') 
        ,FinalCostObject      = LEFT(pc.ProfitCenter,10)
        ,MH_NodeParent        = ISNULL(mh.NodeParent,'Unattached Profit Centers')
    INTO #tmpProfitCenters      
    FROM gsap_ProfitCenters pc
	LEFT JOIN bmt_MgtHierarchy mh
		ON pc.ProfitCenter = mh.NodeCode
    INNER JOIN bmt_CompanyCodes cod
        ON pc.VerticalMgmtL2 = cod.CompanyCode

    MERGE bmt_PostingObject AS po
    USING #tmpProfitCenters AS pc
    ON po.FinalCostObject = pc.FinalCostObject 
        AND po.ReportingType = pc.ReportingType 
        AND po.ControllingArea = pc.ControllingArea
    WHEN MATCHED 
    THEN UPDATE SET 
    po.PostObjDescription   = pc.PostObjDescription
    ,po.CompanyCode         = pc.CompanyCode
    ,po.CompanyCodeDescription = pc.CompanyCodeDescription
    ,po.CountryCode           = pc.CountryCode
    ,po.CountryCodeDescription = pc.CountryCodeDescription 
    ,po.FunctionalArea       = pc.FunctionalArea
    ,po.CustomerCode         = pc.CustomerCode
    ,po.CustomerName         = pc.CustomerName
    ,po.ClientGroup          = pc.ClientGroup
    ,po.ClientGroupDescription = pc.ClientGroupDescription
    ,po.Industry            = pc.Industry
    ,po.IndustryDescription = pc.IndustryDescription
    ,po.ServiceOffering     = pc.ServiceOffering
    ,po.ServiceOfferingDescription = pc.ServiceOfferingDescription
    ,po.OfferingPortfolio   = pc.OfferingPortfolio
    ,po.OfferingPortfolioDescription = pc.OfferingPortfolioDescription
    ,po.WBS_Element         = pc.WBS_Element
    ,po.CostObject          = pc.CostObject
    ,po.ChangedOn            = pc.ChangedOn
    WHEN NOT MATCHED BY TARGET
    THEN INSERT
    VALUES
        (pc.PostObjDescription   
        ,pc.ReportingType        
        ,pc.ControllingArea      
        ,pc.ProfitCenter         
        ,pc.CompanyCode          
        ,pc.CompanyCodeDescription 
        ,pc.CountryCode           
        ,pc.CountryCodeDescription 
        ,pc.FunctionalArea       
        ,pc.CustomerCode         
        ,pc.CustomerName         
        ,pc.ClientGroup          
        ,pc.ClientGroupDescription 
        ,pc.Industry           
        ,pc.IndustryDescription 
        ,pc.ServiceOffering    
        ,pc.ServiceOfferingDescription 
        ,pc.OfferingPortfolio  
        ,pc.OfferingPortfolioDescription 
        ,pc.WBS_Element        
        ,pc.CostObject         
        ,pc.ChangedOn            
        ,pc.FinalCostObject      
        ,pc.MH_NodeParent        

        )
    ;
END
ELSE IF @ObjectType = 'CostCenters'
BEGIN        

    /* =============================================================================================================================================
    Insert Values from CostCenters
    ================================================================================================================================================*/
    SELECT PostObjDescription   = LEFT(cc.CostCenterDescription,40)
        ,ReportingType        = 'B'  
        ,ControllingArea      = cc.ControllingArea
        ,ProfitCenter         = cc.ProfitCenter
        ,CompanyCode          = cc.CompanyCode
        ,CompanyCodeDescription = cod.CompanyCodeDescription
        ,CountryCode           = pc.Country
        ,CountryCodeDescription = pc.CountryDescription 
        ,FunctionalArea       = pc.LineOfBusiness
        ,CustomerCode         = NULL
        ,CustomerName         = NULL
        ,ClientGroup          = pc.ClientGroup
        ,ClientGroupDescription = pc.ClientGroupDescription
        ,Industry               = pc.IndustrySectorL1
        ,IndustryDescription    = pc.IndustrySectorL1Description
        ,ServiceOffering    = pc.IndustrySectorL2
        ,ServiceOfferingDescription = pc.IndustrySectorL2Description
        ,OfferingPortfolio  = pc.OfferingPortfolio
        ,OfferingPortfolioDescription = pc.OfferingPortfolioDescription
        ,WBS_Element        = '#'
        ,CostObject         = cc.CostCenter
        ,MH_NodeParent        = ISNULL(mh.NodeParent,'Unattached Cost Centers')
        ,FinalCostObject      = LEFT(cc.CostCenter,10)
        ,ChangedOn            = format(getdate(), 'yyyyMMdd')
    INTO #tmpCostCenters         
    FROM gsap_CostCenters cc
    LEFT JOIN gsap_ProfitCenters pc
            ON cc.ProfitCenter = pc.ProfitCenter
	LEFT JOIN bmt_MgtHierarchy mh
		ON cc.ProfitCenter = mh.NodeCode
    LEFT JOIN bmt_CompanyCodes cod
        ON cc.CompanyCode = cod.CompanyCode

    MERGE bmt_PostingObject AS po
    USING #tmpCostCenters AS cc
    ON po.FinalCostObject = cc.FinalCostObject 
        AND po.ReportingType = cc.ReportingType 
        AND po.ControllingArea = cc.ControllingArea
    WHEN MATCHED 
    THEN UPDATE SET 
    po.PostObjDescription   = cc.PostObjDescription
    ,po.CompanyCode         = cc.CompanyCode
    ,po.CompanyCodeDescription = cc.CompanyCodeDescription
    ,po.CountryCode           = cc.CountryCode
    ,po.CountryCodeDescription = cc.CountryCodeDescription 
    ,po.FunctionalArea       = cc.FunctionalArea
    ,po.CustomerCode         = cc.CustomerCode
    ,po.CustomerName         = cc.CustomerName
    ,po.ClientGroup          = cc.ClientGroup
    ,po.ClientGroupDescription = cc.ClientGroupDescription
    ,po.Industry            = cc.Industry
    ,po.IndustryDescription = cc.IndustryDescription
    ,po.ServiceOffering     = cc.ServiceOffering
    ,po.ServiceOfferingDescription = cc.ServiceOfferingDescription
    ,po.OfferingPortfolio   = cc.OfferingPortfolio
    ,po.OfferingPortfolioDescription = cc.OfferingPortfolioDescription
    ,po.WBS_Element         = cc.WBS_Element
    ,po.CostObject          = cc.CostObject
    ,po.ChangedOn            = cc.ChangedOn
    WHEN NOT MATCHED BY TARGET
    THEN INSERT
    VALUES
        (cc.PostObjDescription   
        ,cc.ReportingType        
        ,cc.ControllingArea      
        ,cc.ProfitCenter         
        ,cc.CompanyCode          
        ,cc.CompanyCodeDescription 
        ,cc.CountryCode           
        ,cc.CountryCodeDescription 
        ,cc.FunctionalArea       
        ,cc.CustomerCode         
        ,cc.CustomerName         
        ,cc.ClientGroup          
        ,cc.ClientGroupDescription 
        ,cc.Industry           
        ,cc.IndustryDescription 
        ,cc.ServiceOffering    
        ,cc.ServiceOfferingDescription 
        ,cc.OfferingPortfolio  
        ,cc.OfferingPortfolioDescription 
        ,cc.WBS_Element        
        ,cc.CostObject         
        ,cc.ChangedOn            
        ,cc.FinalCostObject      
        ,cc.MH_NodeParent        

        )
    ;
END
ELSE IF @ObjectType = 'WBS'
BEGIN    

    /* =============================================================================================================================================
    Insert Values from WBS
    ================================================================================================================================================*/
    SELECT PostObjDescription   = wb.Parent_DESC
        ,ReportingType        = 'A'  
        ,ControllingArea      = wb.ControllingArea   
        ,ProfitCenter         = wb.WBS_PRCTR
        ,CompanyCode          = wb.COMPANY_CODE
        ,CompanyCodeDescription = cod.CompanyCodeDescription
        ,CountryCode           = pc.Country
        ,CountryCodeDescription = pc.CountryDescription 
        ,FunctionalArea       = pc.LineOfBusiness
        ,CustomerCode         = LTRIM(Replace(Ltrim(Replace(wb.WBS_CustomerCode, '0', ' ')), ' ', '0'))
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
        ,[CostObject]         = '#'
        ,FinalCostObject      = wb.wBS_Code
        ,MH_NodeParent        = ISNULL(mh.NodeParent,'Unattached WBS Elements')
        ,ChangedOn            = format(getdate(), 'yyyyMMdd') 
    INTO #tmpWBS    
    FROM [Helsinki].[dbo].[gsap_WBS] wb
    LEFT JOIN gsap_ProfitCenters pc
            ON wb.WBS_PRCTR = pc.ProfitCenter
	LEFT JOIN bmt_MgtHierarchy mh
		ON wb.WBS_PRCTR = mh.NodeCode
    LEFT JOIN bmt_CompanyCodes cod
        ON wb.COMPANY_CODE = cod.CompanyCode
--select * from #tmpWBS

    MERGE bmt_PostingObject AS po
    USING #tmpWBS AS wb
    ON po.FinalCostObject = wb.FinalCostObject 
        AND po.ReportingType = wb.ReportingType 
        AND po.ControllingArea = wb.ControllingArea
    WHEN MATCHED 
    THEN UPDATE SET 
    po.PostObjDescription   = wb.PostObjDescription
    ,po.CompanyCode         = wb.CompanyCode
    ,po.CompanyCodeDescription = wb.CompanyCodeDescription
    ,po.CountryCode           = wb.CountryCode
    ,po.CountryCodeDescription = wb.CountryCodeDescription 
    ,po.FunctionalArea       = wb.FunctionalArea
    ,po.CustomerCode         = wb.CustomerCode
    ,po.CustomerName         = wb.CustomerName
    ,po.ClientGroup          = wb.ClientGroup
    ,po.ClientGroupDescription = wb.ClientGroupDescription
    ,po.Industry            = wb.Industry
    ,po.IndustryDescription = wb.IndustryDescription
    ,po.ServiceOffering     = wb.ServiceOffering
    ,po.ServiceOfferingDescription = wb.ServiceOfferingDescription
    ,po.OfferingPortfolio   = wb.OfferingPortfolio
    ,po.OfferingPortfolioDescription = wb.OfferingPortfolioDescription
    ,po.WBS_Element         = wb.WBS_Element
    ,po.CostObject          = wb.CostObject
    ,po.ChangedOn            = wb.ChangedOn
    WHEN NOT MATCHED BY TARGET
    THEN INSERT
    VALUES
        (wb.PostObjDescription   
        ,wb.ReportingType        
        ,wb.ControllingArea      
        ,wb.ProfitCenter         
        ,wb.CompanyCode          
        ,wb.CompanyCodeDescription 
        ,wb.CountryCode           
        ,wb.CountryCodeDescription 
        ,wb.FunctionalArea       
        ,wb.CustomerCode         
        ,wb.CustomerName         
        ,wb.ClientGroup          
        ,wb.ClientGroupDescription 
        ,wb.Industry           
        ,wb.IndustryDescription 
        ,wb.ServiceOffering    
        ,wb.ServiceOfferingDescription 
        ,wb.OfferingPortfolio  
        ,wb.OfferingPortfolioDescription 
        ,wb.WBS_Element        
        ,wb.CostObject         
        ,wb.ChangedOn            
        ,wb.FinalCostObject      
        ,wb.MH_NodeParent        

        )
    ;

END    
      
END