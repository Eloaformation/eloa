
----- =============================================           
-- Projet			: Information Sch�ma
-- Author          	: Alain MARGOSSIAN
-- Create date  	: 01/10/2010
-- Description  	: Comment r�indexer une base
-- History         	: 
-- Version         	: 
-- =============================================  

  --La gestion des index par SQL Server peut entra�ner la fragmentation de ceux-ci et une d�gradation des performances. Si le volume d'informations de votre base �volue beaucoup, il est n�cessaire de r�indexer votre base. Plus votre base change, plus les index perdent en efficacit�, il faut donc les recr�er. On peut reconstruire les index avec la commande DBCC REINDEX.


CREATE PROCEDURE REINDEXATION AS
DECLARE @table_name sysname
DECLARE @TSQL nvarchar(4000)
DECLARE @Err int
DECLARE @Mess varchar(400)
SET @Mess = 'D�but r�indexation'
RAISERROR(@Mess, 10, 1) WITH LOG
DECLARE table_list CURSOR FAST_FORWARD FOR SELECT name FROM sysobjects WHERE type = 'u'
OPEN table_list
FETCH NEXT FROM table_list INTO @table_name
WHILE @@fetch_status = 0
 BEGIN
 SET @TSQL = N'DBCC DBREINDEX(' + @table_name + N')' 
 
 EXECUTE sp_executesql @TSQL
 SET @Err = @@error
 IF (@Err != 0)
  BEGIN
  SET @Mess = 'Echec r�indexation table ' + @table_name + ' suite erreur ' + CONVERT(varchar, @Err) 
  RAISERROR(@Mess, 16, 1) WITH LOG
  END
 FETCH NEXT FROM table_list INTO @table_name
 END
CLOSE table_list
DEALLOCATE table_list
SET @Mess = 'Fin r�indexation'
RAISERROR(@Mess, 10, 1) WITH LOG
GO
