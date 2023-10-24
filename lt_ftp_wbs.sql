USE [OptimusPrime]
GO

/****** Object:  Table [dbo].[lt_FTP_WBS]    Script Date: 2/22/2023 11:13:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lt_FTP_WBS](
	[WBS_Element] [nvarchar](8) NOT NULL,
	[WorkBreakdownStructure] [nvarchar](24) NULL,
	[PS_Desc] [nvarchar](40) NULL,
	[PROJ_Type] [nvarchar](2) NULL,
	[CC_WBS] [nvarchar](4) NULL,
	[CA_WBS] [nvarchar](4) NULL,
	[ProfitCenter] [nvarchar](10) NULL,
	[ObjectNumber] [nvarchar](22) NULL,
	[CreatedDate] [date] NULL,
	[CreatedUser] [nvarchar](12) NULL,
	[UpdatedDate] [date] NULL,
	[UpdatedName] [nvarchar](12) NULL,
	[PROJMGR_Number] [nvarchar](8) NULL,
	[PROJMGR_Name] [nvarchar](25) NULL,
	[ApplicantNumber] [nvarchar](8) NULL,
	[Applicant] [nvarchar](25) NULL,
	[UserDefinedID] [nvarchar](7) NULL,
	[UserWBSElemet] [nvarchar](20) NULL,
	[ObjectClass] [nvarchar](2) NULL,
	[ZZPRODUCT] [nvarchar](25) NULL,
	[ZZSTAGE] [nvarchar](25) NULL,
	[ZZSFDC] [nvarchar](25) NULL,
	[ZZDXCMH] [nvarchar](25) NULL,
	[ZZIWO_NO] [nvarchar](25) NULL,
	[Regulatory_Ind] [nvarchar](4) NULL,
	[Combination_Status] [nvarchar](3) NULL,
	[LoadDate] [date] NOT NULL,
 CONSTRAINT [PK_lt_FTP_WBS] PRIMARY KEY CLUSTERED 
(
	[WBS_Element] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


