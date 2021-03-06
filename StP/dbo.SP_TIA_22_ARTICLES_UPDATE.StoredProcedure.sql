/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2012 (11.0.3128)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [TIA]
GO
/****** Object:  StoredProcedure [dbo].[SP_TIA_22_ARTICLES_UPDATE]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_TIA_22_ARTICLES_UPDATE]
AS
BEGIN

	SET NOCOUNT ON;
	
	/*
	 * Prepare temporary table to store first style and colourway
	 * This table will be used several times to get the first record of a style/colourway.
	 */
	IF OBJECT_ID('TEMP_FIRST') IS NOT NULL DROP TABLE TEMP_FIRST; 
	CREATE TABLE TEMP_FIRST ( Number VARCHAR(6), first_season_id VARCHAR(3) );
	INSERT INTO TEMP_FIRST
	SELECT Number, MIN(season_id) AS 'first_season_id'
	FROM (SELECT Number, season_id FROM PDM_INTERFACE.dbo.V_ADM_ARTICLE WHERE season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')) temp
	GROUP BY Number

	IF OBJECT_ID('TEMP_FIRST_CW') IS NOT NULL DROP TABLE TEMP_FIRST_CW; 
	CREATE TABLE TEMP_FIRST_CW ( Number VARCHAR(6), [CW Number] VARCHAR(5), first_season_id VARCHAR(3) );
	INSERT INTO TEMP_FIRST_CW
	SELECT DISTINCT Number, [CW Number], MIN(season_id) AS 'first_season_id'
	FROM (SELECT Number, [CW Number], season_id FROM PDM_INTERFACE.dbo.V_ADM_COLOURWAY WHERE season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')) temp
	GROUP BY Number, [CW Number]


	/* JZU, 13.07.2017, WORKAROUND, deaktivate wrong sizes */
	/*
	UPDATE IN_VARTGR
	SET GR_STATUS = 9
	-- SELECT DISTINCT *
	FROM IN_VARTGR
	JOIN PDM_INTERFACE.dbo.V_ADM_SKU sku ON sku.Number = IN_VARTGR.ATYPO1 AND sku.[CW Number] = IN_VARTGR.ATYPO2 AND sku.Size = IN_VARTGR.gr
	WHERE sku.Active = 0 --and atypo1 = '550102'
	--order by IN_VARTGR.ATYPO1, IN_VARTGR.ATYPO2
	*/

	/* 
	 * Set ERSTLIEFER_TERMIN according to first delivery window attribute in WP Model
	 * precondition: first season CW must be filled	
	 */
 
 	BEGIN TRANSACTION
	UPDATE IN_VART
	SET ERSTLIEFER_TERMIN = 
	-- SELECT a.Season, a.Number, a.[Type], a.Name, cw.[CW Number], cw.[CW Name], a.[First Delivery Window], cw.[First Delivery Window CW], cw.[First Season CW],
	'20' + 
	CASE
		WHEN cw.[First Delivery Window CW] IS NOT NULL THEN -- use first season of CW
			CASE -- determine correct year
				WHEN [First Season CW] LIKE 'SS%' THEN
					CASE
						WHEN SUBSTRING([First Delivery Window CW], 4, 2) > 9 THEN CONVERT ( CHAR(2), SUBSTRING([First Season CW], 3, 2) - 1)
						ELSE SUBSTRING([First Season CW], 3, 2) 
					END
				ELSE
					CASE 
						WHEN SUBSTRING([First Delivery Window CW], 4, 2) > 5 THEN SUBSTRING([First Season CW], 3, 2) 
						ELSE CONVERT ( CHAR(2) , SUBSTRING([First Season CW], 3, 2) + 1) 
					END
			END
			+ SUBSTRING([First Delivery Window CW], 4, 2) + SUBSTRING([First Delivery Window CW], 1, 2)
		ELSE -- [First Delivery Window CW] is empty, therefore use delivery window from style
			CASE 
				WHEN [First Season CW] LIKE 'SS%' THEN
					CASE
						WHEN SUBSTRING([First Delivery Window], 4, 2) > 9 THEN CONVERT ( CHAR(2) , SUBSTRING([First Season CW], 3, 2) - 1)
						ELSE SUBSTRING([First Season CW], 3, 2) 
					END
				ELSE
					CASE
						WHEN SUBSTRING([First Delivery Window], 4, 2) > 5 THEN SUBSTRING([First Season CW], 3, 2) 
						ELSE CONVERT ( CHAR(2) , SUBSTRING([First Season CW], 3, 2) + 1) 
					END
			END
			+ SUBSTRING([First Delivery Window], 4, 2) + SUBSTRING([First Delivery Window], 1, 2)
	END
	
	FROM 
		IN_VART
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY cw ON cw.Number = IN_VART.ATYPO1 AND cw.[CW Number] = IN_VART.ATYPO2
		JOIN PDM_INTERFACE.dbo.V_ADM_ARTICLE a ON a.Number = cw.Number -- do not join with article_id, in order to not miss any colours from other seasons
		JOIN TEMP_FIRST first ON a.Number = first.Number AND a.season_id = first.first_season_id
		JOIN TEMP_FIRST_CW firstCW ON cw.Number = firstCW.Number AND cw.[CW Number] = firstCW.[CW Number] AND cw.season_id = firstCW.first_season_id
	WHERE 
		cw.[First Season CW] IS NOT NULL 
		AND ([First Delivery Window] IS NOT NULL OR [First Delivery Window CW] IS NOT NULL)
	COMMIT TRANSACTION

	-- Update dates in IN_VARTGR based on colourways
	BEGIN TRANSACTION
	UPDATE IN_VARTGR
	SET START_TERMIN_GR = ERSTLIEFER_TERMIN, AUSLAUF_TERMIN_GR = AUSLAUF_TERMIN
	FROM IN_VARTGR JOIN IN_VART ON IN_VART.ATYPO1 = IN_VARTGR.ATYPO1 AND IN_VART.ATYPO2 = IN_VARTGR.ATYPO2
	
	-- Cancel sizes with past delivery date
	UPDATE IN_VARTGR SET GR_STATUS = '9' WHERE AUSLAUF_TERMIN_GR <= CONVERT(VARCHAR(8), getDate(), 112)	

	-- Set seasonal status inactive if LDD < today
	UPDATE IN_ZVART 
	SET KZ_ASTATUS = '9' 
	FROM IN_ZVART 
	JOIN IN_VART ON IN_VART.ATYPO1 = IN_ZVART.ATYPO1 AND IN_VART.ATYPO2 = IN_ZVART.ATYPO2
	WHERE AUSLAUF_TERMIN <= CONVERT(VARCHAR(8), getDate(), 112)	

	-- Cancel sizes of cancelled colourways which only exist in one season
	UPDATE IN_VARTGR SET GR_STATUS = '9'
	FROM IN_VARTGR T1 JOIN IN_ZVART T2 ON T2.ATYPO1 = T1.ATYPO1 AND T2.ATYPO2 = T1.ATYPO2
	WHERE T1.GR_STATUS = '1' AND T2.KZ_ASTATUS = '9' AND (SELECT COUNT(ATYPO2) FROM IN_ZVART WHERE ATYPO1 = T2.ATYPO1 AND ATYPO2 = T2.ATYPO2) = 1 

	COMMIT TRANSACTION


	/*
	 * IN_VARTGR, IN_LIEFARTGR, IN_AUFPOS, IN_OBESTELL: Update TECH_INDEX
	 * We need to set the TECH_INDEX at the end because the size range number may change between seasons
	 */

	BEGIN TRANSACTION 

	/*
	 * IN_GRTEXTE: Initial load of size range master data
	 */
	TRUNCATE TABLE IN_GRTEXTE
	INSERT INTO IN_GRTEXTE ( GR_GANG, TECH_INDEX, TECH_BEZ )
	SELECT GRRTBL.GRSLFD, GRRRFG, GGRGRO
	FROM 
	[CHHUNSVPDM6\PDM].[prod].[dbo].GRRTBL
	JOIN [CHHUNSVPDM6\PDM].[prod].[dbo].GRSTBL ON GRSTBL.GRSLFD = GRRTBL.GRSLFD

	
	-- update size range number in IN_AUFPOS and IN_OBESTELL with the one from article master data
	UPDATE IN_AUFPOS
	SET ggnr = IN_VART.GRGANG 
	FROM IN_AUFPOS JOIN IN_VART ON IN_VART.ATYPO1 = IN_AUFPOS.ATYPO1 AND IN_VART.ATYPO2 = IN_AUFPOS.ATYPO2
	WHERE IN_VART.GRGANG IS NOT NULL
	
	UPDATE IN_OBESTELL
	SET ggnr = IN_VART.GRGANG 
	FROM IN_OBESTELL JOIN IN_VART ON IN_VART.ATYPO1 = IN_OBESTELL.ATYPO1 AND IN_VART.ATYPO2 = IN_OBESTELL.ATYPO2
	WHERE IN_VART.GRGANG IS NOT NULL


	-- Update TECH_INDEX
	UPDATE IN_VARTGR 
	SET TECH_INDEX = IN_GRTEXTE.TECH_INDEX 
	FROM IN_VARTGR JOIN IN_GRTEXTE ON IN_VARTGR.ggnr = IN_GRTEXTE.GR_GANG AND IN_VARTGR.gr = IN_GRTEXTE.TECH_BEZ

	UPDATE IN_LIEFVARTGR
	SET TECH_INDEX = IN_GRTEXTE.TECH_INDEX 
	FROM IN_LIEFVARTGR JOIN IN_GRTEXTE ON IN_LIEFVARTGR.ggnr = IN_GRTEXTE.GR_GANG AND IN_LIEFVARTGR.gr = IN_GRTEXTE.TECH_BEZ

	UPDATE IN_AUFPOS
	SET TECH_INDEX = IN_GRTEXTE.TECH_INDEX 
	FROM IN_AUFPOS JOIN IN_GRTEXTE ON IN_AUFPOS.ggnr = IN_GRTEXTE.GR_GANG AND IN_AUFPOS.gr = IN_GRTEXTE.TECH_BEZ
	
	UPDATE IN_OBESTELL
	SET TECH_INDEX = IN_GRTEXTE.TECH_INDEX 
	FROM IN_OBESTELL JOIN IN_GRTEXTE ON IN_OBESTELL.ggnr = IN_GRTEXTE.GR_GANG AND IN_OBESTELL.gr = IN_GRTEXTE.TECH_BEZ

	COMMIT TRANSACTION



	/*
	 * IN_VART: Add RP from Intex price list 000
	 */
	UPDATE IN_VART
	SET PREIS1 = pl.VkPreis
	--select distinct ATYPO1, VkPreis
	FROM IN_VART
	JOIN INTEXSALES.OdloDE.dbo.ArPreisLst pl ON pl.ArtsNr1 = IN_VART.ATYPO1 COLLATE SQL_Latin1_General_CP1_CS_AS
	JOIN (
		SELECT ArtsNr1, MAX(ArtsKey) maxArtsKey
		FROM INTEXSALES.OdloDE.dbo.ArPreisLst -- TODO: In DWH source laden
		WHERE VkPreis <> '0.00' AND RTRIM(PreisListe) IN ('000') AND ArtsKey LIKE ('011%') 
		GROUP BY ArtsNr1
		) latest_price ON latest_price.ArtsNr1 = pl.ArtsNr1 AND latest_price.maxArtsKey = pl.ArtsKey
	

	
	 /*
	  * IN_VART: Update MINDEST_BESTELL_MENGE and MINDEST_BESTELL_MENGE_MODEL from Excel "TIA_ISO_and_exceptions.xslx"
	  */
	BEGIN TRANSACTION
	IF OBJECT_ID('EXCEL_MIN_QTY') IS NOT NULL DROP TABLE EXCEL_MIN_QTY; 
	SELECT 
		CAST(ArticleNumber as [nvarchar](30)) as ArticleNumber
		,CAST(ColourNumber as [nvarchar](30)) as ColourNumber
		,CAST(GarmentmakerNumber as [nvarchar](30)) as GarmentmakerNumber
		,CAST(MIN_QTY_ARTICLE as int) as MIN_Q_ARTICLE
		,CAST(MIN_QTY_ARTICLE_COLOUR as int) as MIN_Q_ARTICLE_COLOUR
	INTO EXCEL_MIN_QTY
	FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0', 'Data Source=D:\TIA\SaOP_import_files\TIA_ISO_and_exceptions.xlsx;Extended Properties=Excel 12.0')...[TIA_MIN_PO_QTY$]

	UPDATE IN_VART SET MIN_BESTELL_MENGE_MODEL = CASE WHEN MIN_Q_ARTICLE IS NULL THEN 0 ELSE MIN_Q_ARTICLE END 
	FROM IN_VART v JOIN EXCEL_MIN_QTY ON v.ATYPO1  = ArticleNumber 

	UPDATE IN_VART SET MINDEST_BESTELL_MENGE =CASE WHEN  MIN_Q_ARTICLE_COLOUR IS NULL THEN 0 ELSE MIN_Q_ARTICLE_COLOUR END 
	FROM IN_VART v JOIN EXCEL_MIN_QTY ON v.ATYPO1 = ArticleNumber AND v.ATYPO2 = ColourNumber

	IF OBJECT_ID('EXCEL_MIN_QTY') IS NOT NULL DROP TABLE EXCEL_MIN_QTY; 
	COMMIT TRANSACTION



	/*  
	 * IN_VARTGR: Update LB_FREI (free stock) 
	 */
	BEGIN TRANSACTION 
	IF OBJECT_ID('IX_STOCK') IS NOT NULL DROP TABLE IX_STOCK; 

	CREATE TABLE IX_STOCK ( ATYPO1 VARCHAR(6), ATYPO2 VARCHAR(5), gr VARCHAR(10), LB_FREI_IX int );
	INSERT INTO IX_STOCK
	SELECT ltrim(rtrim(ArtsNr1)) AS ArtsNr1, ltrim(rtrim(VerkFarbe)) AS VerkFarbe, ltrim(rtrim(Gr)) AS gr, sum(Bestand) AS LB_FREI_IX
	FROM SPOT_SRC.dbo.SIXH_FELAGER
	WHERE ArtsKey >= '011131H' AND ArtsKey LIKE ('011%') AND ArtsKey NOT LIKE ('0119%') AND LagerOrt IN ( '800', 'TWN', 'KOR', 'JPN', 'HKG' )
	GROUP BY ArtsNr1, VerkFarbe, Gr

	UPDATE IN_VARTGR
	SET LB_FREI = LB_FREI_IX
	FROM IN_VARTGR sku
	JOIN IX_STOCK ON sku.ATYPO1 = IX_STOCK.ATYPO1 COLLATE SQL_Latin1_General_CP1_CS_AS 
				AND sku.ATYPO2 = IX_STOCK.ATYPO2 COLLATE SQL_Latin1_General_CP1_CS_AS
				AND sku.gr = IX_STOCK.gr COLLATE SQL_Latin1_General_CP1_CS_AS

	IF OBJECT_ID('IX_STOCK') IS NOT NULL DROP TABLE IX_STOCK; 
	COMMIT TRANSACTION



	/* 
	 * IN_LIEFVARTGR: Update leadtime (WBM_LANG, WBM_KURZ) from Excel "TIA_ISO_and_exceptions.xslx"
	 */
	BEGIN TRANSACTION  
	IF OBJECT_ID('EXCEL_ISO') IS NOT NULL DROP TABLE EXCEL_ISO; 
	SELECT 
		CAST(ArticleNumber as [nvarchar](30)) as ArticleNumber
		,CAST(ColourNumber as [nvarchar](30)) as ColourNumber
		,CAST(GarmentmakerNumber as [nvarchar](30)) as GarmentmakerNumber
		,CAST(leadtime as int) as leadtime
	INTO EXCEL_ISO
	FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0', 'Data Source=D:\TIA\SaOP_import_files\TIA_ISO_and_exceptions.xlsx;Extended Properties=Excel 12.0')...[TIA_ISO_LEADTIME$]
	
	UPDATE IN_LIEFVARTGR
	SET WBM_LANG = leadtime, WBM_KURZ = leadtime, BEST_FREQUENZ = '1' --default ist 6 nur bei ISO ist es 1
	FROM IN_LIEFVARTGR
	JOIN EXCEL_ISO ON LIEFNR = GarmentmakerNumber AND ATYPO1 = ArticleNumber AND ATYPO2 = ColourNumber

	IF OBJECT_ID('EXCEL_ISO') IS NOT NULL DROP TABLE EXCEL_ISO; 
	COMMIT TRANSACTION



	/*  
	 * IN_LIEFVARTGR: Update upcomming next three buy dates
	 */

	BEGIN TRANSACTION 
	
	SELECT CAST(ArticleNumber as [nvarchar](30)) as ArticleNumber, CAST(ColourNumber as [nvarchar](30)) as ColourNumber, CAST(BuyDate as int) as BuyDate
	INTO #ttBuy
	FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0', 'Data Source=D:\TIA\SaOP_import_files\TIA_ISO_and_exceptions.xlsx;Extended Properties=Excel 12.0')...[TIA_BUY_DATE$]
	
	-- delete vergangene buy dates
	DELETE FROM #ttBuy WHERE BuyDate < CONVERT(VARCHAR(8), convert(DATETIME, getDate(), 104), 112)
	
	SELECT ArticleNumber, ColourNumber, BuyDate, Rank() OVER (PARTITION BY ArticleNumber, ColourNumber ORDER BY ArticleNumber, ColourNumber, BuyDate) as BuyW
	INTO #ttBuy2
	FROM #ttBuy

	UPDATE IN_LIEFVARTGR SET ODL_1 = BuyDate FROM IN_LIEFVARTGR JOIN #ttBuy2 ON ATYPO1 = ArticleNumber AND ATYPO2 = ColourNumber AND BuyW = '1'
	UPDATE IN_LIEFVARTGR SET ODL_2 = BuyDate FROM IN_LIEFVARTGR JOIN #ttBuy2 ON ATYPO1 = ArticleNumber AND ATYPO2 = ColourNumber AND BuyW = '2'
	UPDATE IN_LIEFVARTGR SET ODL_3 = BuyDate FROM IN_LIEFVARTGR JOIN #ttBuy2 ON ATYPO1 = ArticleNumber AND ATYPO2 = ColourNumber AND BuyW = '3'

	DROP TABLE #ttBuy
	DROP TABLE #ttBuy2

	COMMIT TRANSACTION

	IF OBJECT_ID('TEMP_FIRST') IS NOT NULL DROP TABLE TEMP_FIRST; 
	IF OBJECT_ID('TEMP_FIRST_CW') IS NOT NULL DROP TABLE TEMP_FIRST_CW; 

END
GO
