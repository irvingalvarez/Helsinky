USE Helsinki
GO
-- SELECT * FROM dbo.bmt_PostingObject WHERE PostObjDescription IN  ('Missing WBS','Missing ProfitCenters','Missing CostCenters','Missing ROPOs')

--*********************************************
-- Insert Records to dbo.bmt_PostingObject 
--*********************************************

SET Identity_Insert dbo.bmt_PostingObject ON

IF NOT EXISTS (SELECT * FROM dbo.bmt_PostingObject WHERE PostObjDescription IN ('Missing WBS','Missing ProfitCenters','Missing CostCenters','Missing ROPOs'))
BEGIN
INSERT INTO dbo.bmt_PostingObject (PostingObjectID, PostObjDescription, ReportingType, MH_ParentNode)
	SELECT
		PostingObjectID                 = 2000005
		,PostObjDescription				= 'Missing WBS'
        ,ReportingType                  = 'A'
		,MH_ParentNode					= 'Missing WBS PostObj'
    UNION ALL
	SELECT
		PostingObjectID                 = 2000006
		,PostObjDescription				= 'Missing ProfitCenters'
        ,ReportingType                  = 'E'
		,MH_ParentNode					= 'Missing ProfitCtr PostObj'
    UNION ALL
	SELECT
		PostingObjectID                 = 2000007
		,PostObjDescription				= 'Missing ROPOs'
        ,ReportingType                  = 'R'
		,MH_ParentNode					= 'Missing ROPO PostObj'
    UNION ALL         
	SELECT
		PostingObjectID                 = 2000008
		,PostObjDescription				= 'Missing CostObjects'
        ,ReportingType                  = 'B'
		,MH_ParentNode					= 'Missing CostObj PosObj'
END

SET Identity_Insert dbo.bmt_PostingObject OFF
