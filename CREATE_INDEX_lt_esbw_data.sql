ALTER TABLE [dbo].[lt_esbw_data]
DROP CONSTRAINT [pk_lt_esbw_data]

CREATE CLUSTERED INDEX [pk_lt_esbw_data] ON [dbo].[lt_esbw_data] (

[ActivityMonth_Reporting] ASC,
	[ActivityMonth] ASC,
	[Scenario] ASC,
	[ReceivingCostObject] ASC,
	[ReceivingPostingObjectID] ASC,
	[SenderCostObject] ASC,
	[SenderPostingObjectID] ASC,
	[EmployeeID] ASC,
	[PersonelID] ASC,
	[EmpManagerID] ASC,
	[OrgID] ASC,
	[Source] ASC,
	[CompanyCode] ASC,
	[ActivityWeek] ASC,
	[ProcessingStatus] ASC,
	[AAType] ASC,
	[ActivityType] ASC,
	[ReceivingWBS] ASC,
	[ReceivingCostCenter] ASC,
	[ReceivingServiceOrder] ASC,
	[PSGrouping] ASC,
	[AATypeSummaryCode] ASC,
	[CrossTag] ASC,
	[FiscalPeriod] ASC,
	[ManagerComp] ASC,
	[CreatedOn] ASC,
	[PersonelID_GA] ASC,
	[GSAPProjectKey] ASC
	)