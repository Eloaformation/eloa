select distinct '['+DB_NAME(database_id)+']' as DatabaseName,
    '['+DB_NAME(database_id)+'].['+sch.name+'].['
    + OBJECT_NAME(ips.object_id)+']' as TableName,
    i.name as IndexName,
    ips.index_type_desc as IndexType,
    avg_fragmentation_in_percent as avg_fragmentation,
    SUM(row_count) as Rows
FROM
    sys.indexes i INNER JOIN
    select * from sys.dm_db_index_physical_stats(DB_ID('siav1_rec110'),NULL,NULL,NULL,'LIMITED') ips ON
        i.object_id = ips.object_id INNER JOIN
    sys.tables tbl ON tbl.object_id  = ips.object_id INNER JOIN
    sys.schemas sch ON sch.schema_id = tbl.schema_id INNER JOIN
    sys.dm_db_partition_stats ps ON ps.object_id = ips.object_id
WHERE
    avg_fragmentation_in_percent <> 0.0 
    AND OBJECT_NAME(ips.object_id) not like '%sys%'
GROUP BY database_id, sch.name, ips.object_id, avg_fragmentation_in_percent,
    i.name, ips.index_type_desc
ORDER BY avg_fragmentation_in_percent desc