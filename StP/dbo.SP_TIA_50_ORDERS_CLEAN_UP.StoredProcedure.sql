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
/****** Object:  StoredProcedure [dbo].[SP_TIA_50_ORDERS_CLEAN_UP]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_TIA_50_ORDERS_CLEAN_UP]
AS
BEGIN

	SET NOCOUNT ON;

	/*
	 * Clean up IN_AUFPOS and IN_OBESTELL
	 */

	BEGIN TRANSACTION 

	-- IN_AUFKOPF: Remove IC-ORDERS
	-- JZU, 2017-07-07, has no effect?!?
	--DELETE FROM IN_AUFKOPF WHERE VTYPO2 NOT IN ( 'OAT', 'ODE', 'OCH', 'Oec', 'OUK' , 'ONO', 'OBN', 'Oim', 'Osh', 'OFR', 'OCN' )

	-- IN_AUFPOS: Delete positions without IN_AUFKOPF
	DELETE FROM IN_AUFPOS WHERE AUFTRAGS_NR NOT IN ( SELECT DISTINCT AUFTRAGS_NR FROM IN_AUFKOPF )

	-- IN_AUFPOS / IN_OBESTELL: Remove retail material
	DELETE FROM IN_AUFPOS WHERE ATYPO1 NOT IN ( SELECT DISTINCT ATYPO1 FROM IN_ARTIKEL )
	DELETE FROM IN_OBESTELL WHERE ATYPO1 NOT IN ( SELECT DISTINCT ATYPO1 FROM IN_ARTIKEL )

	-- IN_AUFPOS: UPDATE DELIVERY DATE FOR ESTIMATION
	UPDATE IN_AUFPOS
	SET PER_DATUM = CONCAT(ZTYPO1, CASE WHEN ZTYPO2 = 'SS' THEN '0630' ELSE '1230' END),
		ZUG_DATUM = CONCAT(ZTYPO1, CASE WHEN ZTYPO2 = 'SS' THEN '0630' ELSE '1230' END)
	FROM IN_AUFPOS
	WHERE art = 'ES'

	COMMIT TRANSACTION



	/* 
	 * IN_AUFPOS: Remove cancelled Colourways from Estimation orders
	 */
	DELETE aufpos 
	FROM IN_AUFPOS aufpos
	JOIN IN_ZVART ON IN_ZVART.ATYPO1 = aufpos.ATYPO1 AND IN_ZVART.ATYPO2 = aufpos.ATYPO2 
					AND IN_ZVART.ZTYPO1 = aufpos.ZTYPO1 AND IN_ZVART.ZTYPO2 = aufpos.ZTYPO2 
					AND IN_ZVART.KZ_ASTATUS = '9'
	WHERE aufpos.art = 'ES'


	/*  IN_AUFKOPF: Delete header without positions  */
	DELETE FROM IN_AUFKOPF WHERE AUFTRAGS_NR NOT IN ( SELECT DISTINCT AUFTRAGS_NR FROM IN_AUFPOS )



	/*
	 * IN_AUFKOPF, IN_AUFPOSI: REBUILD BLOCKABRUFE MIT BLOCK-KUNDENNUMMERN (bezug auf block in aufposi)
	 */
	BEGIN TRANSACTION 
	SELECT DISTINCT AUFTRAGS_NR, KD_NUMMER INTO #ttako FROM IN_AUFKOPF
	
	UPDATE IN_AUFPOS
	SET bezugKdNr = KD_NUMMER
	FROM IN_AUFPOS
	JOIN #ttako ON CAST(bezugAufkNr as nvarchar(15)) = #ttako.AUFTRAGS_NR
	WHERE art IN ('07', '17', '27')

	DROP TABLE #ttako
	COMMIT TRANSACTION


	BEGIN TRANSACTION

	SELECT AUFTRAGS_NR, bezugAufkNr, bezugKdNr, art, aufkkey, POSITIONS_NR, EINTEIL_NR, AENDERUNGS_NR, ATYPO0, ATYPO1, ATYPO2, ATYPO3, TECH_INDEX, gr, ggnr, KZ_FILTER1, KZ_FILTER2, KZ_FILTER3, STORNO_GRUND, PER_DATUM, ZUG_DATUM, DATUM, MENGE, offene_menge, reservierte_menge, ZTYPO1, ZTYPO2, ZTYPO3, WERT
	INTO #ttapos
	FROM IN_AUFPOS
	WHERE art IN ('07', '17', '27') 

	DELETE FROM IN_AUFPOS WHERE art IN ('07', '17', '27') 

	-- re-insert neue Blockabruf Auftragsköpfe
	SELECT AUFTRAGS_NR, KD_NUMMER, AUFTRAGS_ART, KZ_NO, VTYPO1, bezVtypo01, VTYPO2, bezVtypo02, VTYPO3, bezVtypo03, IM_DATUM
	INTO #ttakos
	FROM IN_AUFKOPF
	WHERE AUFTRAGS_ART IN ('07', '17', '27')


	DELETE FROM IN_AUFKOPF WHERE AUFTRAGS_ART IN ('07', '17', '27')

	COMMIT TRANSACTION

	BEGIN TRANSACTION
	-- re-insert Blockabrufe mit neuer Auftragsnummer
	INSERT INTO IN_AUFPOS (AUFTRAGS_NR, bezugAufkNr, bezugKdNr, art, aufkkey, POSITIONS_NR, EINTEIL_NR, AENDERUNGS_NR, ATYPO0, ATYPO1, ATYPO2, ATYPO3, TECH_INDEX, gr, ggnr, KZ_FILTER1, KZ_FILTER2, KZ_FILTER3, STORNO_GRUND, PER_DATUM, ZUG_DATUM, DATUM, MENGE, offene_menge, reservierte_menge, ZTYPO1, ZTYPO2, ZTYPO3, WERT)
	SELECT 
		CAST(([AUFTRAGS_NR]+'_'+CAST([bezugAufkNr] as nvarchar(7))) as nvarchar(15)),
		bezugAufkNr, bezugKdNr, art, aufkkey, POSITIONS_NR, EINTEIL_NR, AENDERUNGS_NR, ATYPO0, ATYPO1, ATYPO2, ATYPO3, TECH_INDEX, gr, ggnr, KZ_FILTER1, KZ_FILTER2, KZ_FILTER3, STORNO_GRUND, PER_DATUM, ZUG_DATUM, DATUM, MENGE, offene_menge, reservierte_menge, ZTYPO1, ZTYPO2, ZTYPO3, WERT
	FROM #ttapos

	SELECT DISTINCT AUFTRAGS_NR, bezugAufkNr, bezugKdNr INTO #ttanko FROM #ttapos

	-- re-insert neue Aufköpfe für Blockabrufe
	INSERT INTO IN_AUFKOPF (AUFTRAGS_NR, KD_NUMMER, AUFTRAGS_ART, KZ_NO, VTYPO1, bezVtypo01, VTYPO2, bezVtypo02, VTYPO3, bezVtypo03, IM_DATUM)
	SELECT 
		CAST((#ttakos.AUFTRAGS_NR + '_' + CAST(bezugAufkNr as nvarchar(7))) as nvarchar(15))
		,bezugKdNr -- mit Kundennummer aus original Blockauftrag
		,AUFTRAGS_ART, KZ_NO, VTYPO1, bezVtypo01, VTYPO2, bezVtypo02, VTYPO3, bezVtypo03, IM_DATUM
	FROM #ttakos
	JOIN #ttanko ON #ttakos.AUFTRAGS_NR = #ttanko.AUFTRAGS_NR

	DROP TABLE #ttapos
	DROP TABLE #ttakos
	DROP TABLE #ttanko

	COMMIT TRANSACTION

	
	/* SYNC AUFTRAGS_NR BTWN IN_AUFPOS AND IN_AUFKOPF (AUFTRÄGE OHNE POSITIONEN - zB "leere" Blockaufträge (komplett abgerufen)) */
	DELETE FROM IN_AUFPOS WHERE MENGE = 0
	-- fehlende KD-Nummer bei Country-Blöcken >> deren Abrufe werden gelöscht
	DELETE FROM IN_AUFKOPF WHERE KD_NUMMER = ''
	
	-- kein Kopf ohne Position
	DELETE FROM IN_AUFKOPF WHERE AUFTRAGS_NR NOT IN ( SELECT DISTINCT AUFTRAGS_NR FROM IN_AUFPOS )
	
	-- keine Position ohne Kopf
	DELETE FROM IN_AUFPOS WHERE AUFTRAGS_NR NOT IN ( SELECT DISTINCT AUFTRAGS_NR FROM IN_AUFKOPF )

	

	/* 
	 * IN_OBESTELL: Add transport/handling to delivery date (=ABLIEFERUNG)
	 */
	UPDATE IN_OBESTELL
	SET ABLIEFERUNG = CONVERT(VARCHAR(8), (CONVERT(DATETIME, ABLIEFERUNG, 104) + [Transport / Handling [d]]]), 112)
	FROM IN_OBESTELL
	JOIN PDM_INTERFACE.dbo.V_ADM_SUPPLIER s ON s.intex_id = LIEFERANT

	-- Update data with OSCA export from oca_export.xlsx (Location: https://intranet.odlo.com/site/sop/docs/02%20TIA_shared_data)
	BEGIN TRANSACTION
	SELECT CAST([ORDER NO] AS [nvarchar](30)) AS OrderNumber
		,CAST([STYLE NO#] AS [nvarchar](30)) AS ArticleNumber
		,CAST([COLOUR NO#] AS [nvarchar](30)) AS ColourNumber
		,CAST([DEL# DATE] AS [nvarchar](30)) AS DelDate
		,CONVERT(VARCHAR(8), DATEADD(day, 14,convert(DATETIME, [DEL# DATE], 104)), 112) DelivDatePOS  -- plus 14 Tage handling bis POS
	INTO #ttEDate
	FROM OPENDATASOURCE ('Microsoft.ACE.OLEDB.12.0', 'Data Source=D:\TIA\SaOP_import_files\osca_export.xlsx;Extended Properties=Excel 12.0')...['OSCA Export$']

	DELETE FROM #ttEDate WHERE DelivDatePOS < getDate()
	DELETE FROM #ttEDate WHERE ( DelDate IS NULL OR OrderNumber IS NULL OR ArticleNumber IS NULL OR ColourNumber IS NULL )

	SELECT OrderNumber  -- bei split eines PO wird erster termin als "komplett" angenommen. Der split sollte so angelegt sein, dass erste liefertermine erfüllt werden.
		,ArticleNumber
		,ColourNumber
		,min(DelivDatePOS) AS minDelivDatePOS
	INTO #ttLiefD
	FROM #ttEDate
	GROUP BY OrderNumber, ArticleNumber, ColourNumber

	UPDATE IN_OBESTELL
	SET ABLIEFERUNG = minDelivDatePOS
	FROM IN_OBESTELL
	JOIN #ttLiefD ON AUFTRAGS_NR = OrderNumber AND ATYPO1 = ArticleNumber AND ATYPO2 = ColourNumber

	DROP TABLE #ttLiefD, #ttEDate

	COMMIT TRANSACTION


	/* 
	 * IN_AUFKOPF: Clean up VTYPO2
	 */
	-- JZU, 2017-07-07, VTYPO2 not used anymore
	--UPDATE IN_AUFKOPF SET VTYPO2 = NULL, bezVtypo02 = NULL



	/*
	 * IN_AUFPOS: Alte, nicht stornierte aufträge bereinigen (menge und offene_menge korrigieren)
	 */
	BEGIN TRANSACTION  
	UPDATE IN_AUFPOS SET MENGE = CASE WHEN (MENGE - offene_menge) < 0 THEN 0 ELSE MENGE - offene_menge END
	WHERE aufkkey < (SELECT DSEA_KEY FROM SPOT_DWH.dbo.DSEA_SEASON WHERE DSEA_ACTUAL = 'Y') AND art NOT IN ('PM', 'ES')

	UPDATE IN_AUFPOS SET offene_menge = 0 
	WHERE aufkkey < (SELECT DSEA_KEY FROM SPOT_DWH.dbo.DSEA_SEASON WHERE DSEA_ACTUAL = 'Y') AND art NOT IN ('PM', 'ES')
	COMMIT TRANSACTION



	/* 
	 * IN_VARTGR: UPDATE RUECKSTAND (offene_menge aus IN_AUFPOS)
	 */

	BEGIN TRANSACTION 
	SELECT ATYPO1, ATYPO2, TECH_INDEX, SUM(offene_menge) AS offeneMenge
	INTO #ttoq
	FROM IN_AUFPOS
	WHERE ZUG_DATUM < (YEAR(getDate())*100+MONTH(getDate()))*100
		AND offene_menge > 0 -- offene_menge < 0 wird ignoriert (problem-aufträge Luxemburg)
		AND art NOT IN ( 'PM', 'ES' )
	GROUP BY ATYPO1, ATYPO2, TECH_INDEX

	UPDATE IN_VARTGR
	SET RUECKSTAND = offeneMenge
	FROM IN_VARTGR v, #ttoq q
	WHERE v.ATYPO1 = q.ATYPO1
	AND v.ATYPO2 = q.ATYPO2
	AND v.TECH_INDEX = q.TECH_INDEX

	DROP TABLE #ttoq
	COMMIT TRANSACTION


	/* 
	 * IN_LIEFERUNG: Update reservierte_menge aus IN_AUFPOS
	 */
	BEGIN TRANSACTION 
	SELECT ATYPO1, ATYPO2, TECH_INDEX, ZUG_DATUM, SUM(reservierte_menge) AS reservierteMenge
	INTO #ttrq
	FROM IN_AUFPOS
	WHERE ZUG_DATUM > (YEAR(getDate())*100+MONTH(getDate()))*100
		AND [reservierte_menge] > 0
		AND art NOT IN ( 'PM', 'ES' )
		AND TECH_INDEX IS NOT NULL -- TODO: abklären, warum es nohc positionen gibt, die tech_index = null haben
	GROUP BY ATYPO1, ATYPO2, TECH_INDEX, ZUG_DATUM

	TRUNCATE TABLE IN_LIEFERUNG

	INSERT INTO IN_LIEFERUNG ( VTYPO1, VTYPO2, VTYPO3, ATYPO0, ATYPO1, ATYPO2, ATYPO3, TECH_INDEX, LIEFERDATUM, LIEFERMENGE )
	SELECT 'OI', NULL, NULL, NULL, ATYPO1, ATYPO2, NULL, TECH_INDEX, ZUG_DATUM AS [LIEFERDATUM], reservierteMenge AS [LIEFERMENGE]
	FROM #ttrq

	DROP TABLE #ttrq
	COMMIT TRANSACTION

END
GO
