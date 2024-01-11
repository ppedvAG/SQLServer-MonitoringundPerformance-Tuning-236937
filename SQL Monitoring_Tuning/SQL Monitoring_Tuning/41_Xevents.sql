  --DEADLOCKS


CREATE EVENT SESSION [Deadlocks] ON SERVER 
ADD EVENT sqlserver.database_xml_deadlock_report(
    ACTION(sqlserver.sql_text)),
ADD EVENT sqlserver.lock_deadlock(
    ACTION(sqlserver.sql_text)),
ADD EVENT sqlserver.lock_deadlock_chain(
    ACTION(sqlserver.sql_text)),
ADD EVENT sqlserver.xml_deadlock_report(
    ACTION(sqlserver.sql_text))
ADD TARGET package0.event_file(SET filename=N'D:\_BACKUP\deadlocks.xel')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


--WAITSTATS
--CREATE EVENT SESSION [Waits] ON SERVER 
ADD EVENT sqlos.wait_info(
    ACTION(sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_plan_hash,sqlserver.sql_text)
    WHERE ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[database_name],N'NwindBig'))),
ADD EVENT sqlserver.locks_lock_waits(
    ACTION(sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_plan_hash,sqlserver.sql_text)
    WHERE ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[database_name],N'NwindBig'))),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_plan_hash,sqlserver.sql_text)
    WHERE ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[database_name],N'Nwindbig'))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_plan_hash,sqlserver.sql_text)
    WHERE ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[database_name],N'NwindBig')))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO


