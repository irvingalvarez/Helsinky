USE [Helsinki]
GO
/****** Object:  StoredProcedure [dbo].[sp_AutoAttachPostingObject]    Script Date: 12/8/2020 5:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC sp_AutoAttachPostingObject
IF OBJECT_ID('dbo.sp_AutoAttachPostingObject') IS NULL
EXEC('CREATE PROCEDURE dbo.sp_AutoAttachPostingObject AS SET NOCOUNT ON;')
GO

ALTER PROCEDURE [dbo].[sp_AutoAttachPostingObject]
AS
BEGIN

	SET NOCOUNT ON;

    UPDATE po
    SET po.MH_ParentNode = 
    CASE WHEN ReportingType IN ('B')  THEN po2.MH_ParentNode
        WHEN ReportingType IN ('A')  THEN po2.MH_ParentNode
    END
	--SELECT * 
    FROM bmt_PostingObject po
    LEFT JOIN (SELECT ProfitCenter, ControllingArea, MH_ParentNode FROM bmt_PostingObject WHERE ReportingType = 'E' and MH_ParentNode like 'MH-%') po2
        ON po.ProfitCenter = po2.ProfitCenter AND po.ControllingArea = po2.ControllingArea
    WHERE ReportingType in ('A','B') AND po.MH_ParentNode LIKE 'Unattached%'


END

