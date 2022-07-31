SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO
WITH SQLProcessCPU
AS(
    SELECT TOP(30) SQLProcessUtilization AS 'CPU_Usage', ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS 'row_number'
    FROM (
        SELECT
            record.value('(./Record/@id)[1]', 'int') AS record_id,
            record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS [SystemIdle],
            record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS [SQLProcessUtilization],
            [timestamp]
        FROM (
            SELECT [timestamp], CONVERT(xml, record) AS [record]
            FROM sys.dm_os_ring_buffers
            WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
            AND record LIKE '%<SystemHealth>%'
            ) AS x
        ) AS y
)
SELECT
    (SELECT value_in_use FROM sys.configurations WHERE name like '%max server memory%') AS 'Max Server Memory',
    (SELECT physical_memory_in_use_kb/1024 FROM sys.dm_os_process_memory) AS 'SQL Server Memory Usage (MB)',
    (SELECT total_physical_memory_kb/1024 FROM sys.dm_os_sys_memory) AS 'Physical Memory (MB)',
    (SELECT available_physical_memory_kb/1024 FROM sys.dm_os_sys_memory) AS 'Available Memory (MB)',
    (SELECT system_memory_state_desc FROM sys.dm_os_sys_memory) AS 'System Memory State',
    (SELECT [cntr_value] FROM sys.dm_os_performance_counters WHERE [object_name] LIKE '%Manager%' AND [counter_name] = 'Page life expectancy') AS 'Page Life Expectancy',
    --(SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 60 AND 120) AS 'SQLProcessUtilization120',
    --(SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 30 AND 60) AS 'SQLProcessUtilization60',
    (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 1 AND 30) AS 'SQLProcessUtilization30',
    (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 1 AND 15) AS 'SQLProcessUtilization15',
    (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 1 AND 10) AS 'SQLProcessUtilization10',
    (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number BETWEEN 1 AND 5)  AS 'SQLProcessUtilization5',
    (SELECT AVG(CPU_Usage) FROM SQLProcessCPU WHERE row_number = 1 )  AS 'SQLProcessUtilization',
    (
    SELECT
    cpu_total =
        CASE WHEN cpu_sql > cpu_total AND cpu_sql <= 99.
            THEN cpu_sql
            ELSE cpu_total
        END/*,
    cpu_sql*/
FROM (
    SELECT cpu_total = 100 - x.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle/text())[1]', 'TINYINT')
    FROM (
        SELECT TOP(1) [timestamp], x = CONVERT(XML, record)
        FROM sys.dm_os_ring_buffers
        WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
            AND record LIKE '%<SystemHealth>%'
    ) t
) x
CROSS JOIN (
    SELECT
        cpu_sql = (
                MAX(CASE WHEN counter_name = 'CPU usage %' THEN t.cntr_value * 1. END) /
                MAX(CASE WHEN counter_name = 'CPU usage % base' THEN t.cntr_value END)
            ) * 100
    FROM (
        SELECT TOP(2) cntr_value, counter_name
        FROM sys.dm_os_performance_counters
        WHERE counter_name IN ('CPU usage %', 'CPU usage % base')
            AND instance_name = 'default'
    ) t
) t) as cpu_total,
(
    SELECT
    /*cpu_total =
        CASE WHEN cpu_sql > cpu_total AND cpu_sql <= 99.
            THEN cpu_sql
            ELSE cpu_total
        END,*/
    cpu_sql
FROM (
    SELECT cpu_total = 100 - x.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle/text())[1]', 'TINYINT')
    FROM (
        SELECT TOP(1) [timestamp], x = CONVERT(XML, record)
        FROM sys.dm_os_ring_buffers
        WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
            AND record LIKE '%<SystemHealth>%'
    ) t
) x
CROSS JOIN (
    SELECT
        cpu_sql = (
                MAX(CASE WHEN counter_name = 'CPU usage %' THEN t.cntr_value * 1. END) /
                MAX(CASE WHEN counter_name = 'CPU usage % base' THEN t.cntr_value END)
            ) * 100
    FROM (
        SELECT cntr_value, counter_name
        FROM sys.dm_os_performance_counters
        WHERE counter_name IN ('CPU usage %', 'CPU usage % base')
            AND instance_name = 'default'
    ) t
) t) as cpu_sql,
GETDATE() AS 'Data Sample Timestamp'