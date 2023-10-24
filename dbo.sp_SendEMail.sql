-- CREATE TABLE #Temp 
-- ( 
--   [Rank]  [int],
--   [Player Name]  [varchar](128),
--   [Ranking Points] [int],
--   [Country]  [varchar](128)
-- )

-- [dbo].[helpuser_Irving_a]
-- [UserName]
-- ,[RoleName]
-- ,[LoginName]
-- ,[DefDBName]
-- ,[DefSchemaName]
-- ,[UserID]
-- ,[SID]


-- INSERT INTO #Temp
-- SELECT 1,'Rafael Nadal',12390,'Spain'
-- UNION ALL
-- SELECT 2,'Roger Federer',7965,'Switzerland'
-- UNION ALL
-- SELECT 3,'Novak Djokovic',7880,'Serbia'

DECLARE @xml NVARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)

SET @xml = CAST(( SELECT [UserName] AS 'td','',[RoleName] AS 'td','', [LoginName] AS 'td','', DefDBName AS 'td' ,'', DefSchemaName AS 'td' ,'', UserID AS 'td' ,'', SID AS 'td'
FROM [dbo].[helpuser_Irving_a]
ORDER BY UserName 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

SET @body ='<html><body><H3>Users Info</H3>
<table border = 1> 
<tr>
<th> UserName </th> <th> RoleName </th> <th> LoginName </th> <th> DefDBName </th> <th> DefSchemaName </th> <th> UserID </th> <th> SID </th></tr>'    

SET @body = @body + @xml +'</table></body></html>'

EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SQL ALERTING', -- replace with your SQL Database Mail Profile 
@body = @body,
@body_format ='HTML',
@recipients = 'bruhaspathy@hotmail.com', -- replace with your email address
@subject = 'E-mail in Tabular Format' ;

DROP TABLE #Temp


