SET NOCOUNT ON
select
	j.name,
	h.run_status,
	h.run_date,
	STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(h.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') run_time ,
	CASE
		WHEN h.run_duration > 235959 THEN
			CAST((CAST(LEFT(CAST(h.run_duration AS VARCHAR), LEN(CAST(h.run_duration AS VARCHAR)) - 4) AS INT) / 24) AS VARCHAR)
			+ '.' + RIGHT('00' + CAST(CAST(LEFT(CAST(h.run_duration AS VARCHAR), LEN(CAST(h.run_duration AS VARCHAR)) - 4) AS INT) % 24 AS VARCHAR), 2)
			+ ':' + STUFF(CAST(RIGHT(CAST(h.run_duration AS VARCHAR), 4) AS VARCHAR(6)), 3, 0, ':')
		ELSE
			STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(h.run_duration AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
		END AS run_duration,
	j.date_modified,
	description,
	h.message
From
	msdb.dbo.sysjobs j INNER JOIN msdb.dbo.sysjobhistory h ON
	j.job_id = h.job_id
where
	j.enabled = 1 and
	--j.name like 'IMP-CC%' and
	h.run_date = FORMAT(getdate(),'yyyyMMdd') and
	#h.run_date =  replace(convert(varchar(255), getdate(), 102),'.','') and 2008
	step_id = 0
order by h.run_time, j.name desc
