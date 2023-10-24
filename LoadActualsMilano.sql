SELECT        
Hdr.OriginSource AS Source
,'100' AS Version
, 'Actuals' AS Scenario
, FP.FiscalPeriod
, Hdr.CompanyCode
, Dtl.ProfitCenter
, Dtl.BusinessArea
, CASE WHEN Dtl.FunctionalArea IS NULL 
    THEN '#' ELSE Dtl.FunctionalArea END AS FunctionalArea
, CASE WHEN Dtl.WBS_ELEMENT IS NOT NULL 
    THEN CASE WHEN WBS.PostingObjectID IS NOT NULL 
      THEN WBS.PostingObjectID 
        ELSE 'Missing WBS PostObj' END 
      WHEN Dtl.CostObject IS NOT NULL 
        THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
        THEN LH.PostingObjectID 
        ELSE 'Missing CostObj PostObj' END 
      WHEN ROPO.ROPO_ID IS NOT NULL 
        THEN ROPO.ROPO_ID 
        ELSE 'Missing ROPO PostObj' END AS PostingObjectID
, Dtl.CostObject
,Dtl.WBS_Element
, 'O' AS BusinessType
, SUBSTRING(Dtl.GL_Account, 3, 4) AS GroupAccount
, Hdr.DocumentCurrency
, SUM(Dtl.DocumentAmount) AS DocumentAmount
, Hdr.LocalCurrency
, SUM(Dtl.LocalAmount) AS LocalAmount
, SUM(Dtl.GroupAmount) AS GroupAmount
, '0' AS HeadcountType
, 0 AS Headcount
FROM            lh_GL_Header AS Hdr INNER JOIN
                         lh_GL_Detail AS Dtl ON Hdr.CompanyCode = Dtl.CompanyCode AND Hdr.FiscalYear = Dtl.FiscalYear AND Hdr.DocumentNumber = Dtl.DocumentNumber INNER JOIN
                         bmt_FiscalPeriod AS FP ON 'FY' + Hdr.FiscalYear + '-' + RIGHT('0' + Hdr.PostingPeriod, 2) = FP.FiscalPeriod LEFT OUTER JOIN
                         bmt_PostingObject AS WBS ON Dtl.WBS_Element = WBS.PostingObjectID LEFT OUTER JOIN
                         bmt_PostingObject AS LH ON Dtl.CostObject = LH.PostingObjectID LEFT OUTER JOIN
                         pol_BusinessArea AS BA ON Dtl.BusinessArea = BA.NodeCode LEFT OUTER JOIN
                         pol_ProfitCenter AS PC ON Dtl.ProfitCenter = PC.NodeCode LEFT OUTER JOIN
                         pol_FunctionalArea AS FA ON Dtl.FunctionalArea = FA.NodeCode LEFT OUTER JOIN
                         bmt_ROPO AS ROPO ON ISNULL(BA.L04_Node,'#') = ROPO.BusAreaL04 AND ISNULL(PC.L01_Node,'#') = ROPO.ProfitCtrL01 AND ISNULL(FA.L06_Node,'#') = ROPO.FuncAreaL06

WHERE        (FP.FiscalPeriod >= 'FY2021-03') AND (FP.FiscalPeriod IN
                             (SELECT        FiscalPeriod
                               FROM            tmp_PeriodsPosted)) AND (Dtl.GL_Account >= '003000000')
            AND Dtl.LedgerGroup <> 'Z2'
GROUP BY Hdr.OriginSource, FP.FiscalPeriod, Hdr.CompanyCode, Dtl.ProfitCenter, Dtl.BusinessArea, Dtl.FunctionalArea, CASE WHEN Dtl.WBS_ELEMENT IS NOT NULL THEN CASE WHEN WBS.PostingObjectID IS NOT NULL
                          THEN WBS.PostingObjectID ELSE 'Missing WBS PostObj' END WHEN Dtl.CostObject IS NOT NULL THEN CASE WHEN LH.PostingObjectID IS NOT NULL 
                         THEN LH.PostingObjectID ELSE 'Missing CostObj PostObj' END WHEN ROPO.ROPO_ID IS NOT NULL THEN ROPO.ROPO_ID ELSE 'Missing ROPO PostObj' END, Dtl.CostObject, Dtl.WBS_Element, 
                         SUBSTRING(Dtl.GL_Account, 3, 4), Hdr.DocumentCurrency, Hdr.LocalCurrency