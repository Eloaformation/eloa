SELECT [alloc_unit_type_desc] AS [Data Structure]
	, [page_count] AS [Pages]
	, [record_count] AS [Rows]
	, [min_record_size_in_bytes] AS [Min Row]
	, [max_record_size_in_bytes] AS [Max Row]
	, [forwarded_record_count] AS [Fwded Rows]
FROM sys.dm_db_index_physical_stats
	(DB_ID ()
		, OBJECT_ID (N'DemoTableHeap')
		, NULL
		, NULL
		, N'DETAILED'); 
GO

Il y a que des forwarded_record_count pour les tables HEAP
cela veut dire que la ligne est trop longuqe et va etre deplacer sur une autre page
donc un IO supplementaire

