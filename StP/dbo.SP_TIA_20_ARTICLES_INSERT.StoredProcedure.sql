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
/****** Object:  StoredProcedure [dbo].[SP_TIA_20_ARTICLES_INSERT]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_TIA_20_ARTICLES_INSERT]
AS
BEGIN

	SET NOCOUNT ON;


	/*
	 * Prepare temporary tables to store latest style and colourway
	 * These tables will be used several times to get the latest record of a style/colourway.
	 */
	IF OBJECT_ID('TEMP_LAST') IS NOT NULL DROP TABLE TEMP_LAST; 
	CREATE TABLE TEMP_LAST ( Number VARCHAR(6), last_season_id VARCHAR(3) );
	INSERT INTO TEMP_LAST
	SELECT Number, MAX(season_id) AS 'last_season_id'
	FROM (SELECT Number, season_id FROM PDM_INTERFACE.dbo.V_ADM_ARTICLE WHERE season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA') ) temp
	GROUP BY Number

	IF OBJECT_ID('TEMP_LAST_CW') IS NOT NULL DROP TABLE TEMP_LAST_CW; 
	CREATE TABLE TEMP_LAST_CW ( Number VARCHAR(6), [CW Number] VARCHAR(5), last_season_id VARCHAR(3) );
	INSERT INTO TEMP_LAST_CW
	SELECT DISTINCT Number, [CW Number], MAX(season_id) AS 'last_season_id'
	FROM (SELECT Number, [CW Number], season_id FROM PDM_INTERFACE.dbo.V_ADM_COLOURWAY WHERE season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA') ) temp
	GROUP BY Number, [CW Number]


	/*
	 * TRUNCATE INTERFACE TABLES
	 */

	TRUNCATE TABLE IN_ARTIKEL
	TRUNCATE TABLE IN_VART
	TRUNCATE TABLE IN_VARTGR
	TRUNCATE TABLE IN_ZVART
	TRUNCATE TABLE IN_LIEFERANT
	TRUNCATE TABLE IN_LIEFVARTGR
	TRUNCATE TABLE IN_BILDER

	
	/*
	 * IN_ARTIKEL
	 * Master data for styles/colourways. Only one record for all seasons allowed.
	 */

	INSERT INTO IN_ARTIKEL ( ATYPO0, ATYPO1, ATYPO2, ATYPO3, TYPO1, bezTypo01, TYPO2, bezTypo02, TYPO3, bezTypo03, TYPO4, bezTypo04, TYPO5, bezTypo05, TYPO6, bezTypo06, TYPO7, bezTypo07, TYPO8, bezTypo08, TYPO9, bezTypo09, ATYPO_BEZEICHNUNG1, ATYPO_BEZEICHNUNG2, ATYPO_BEZEICHNUNG3, MODELL_BEZEICHNUNG1, MODELL_BEZEICHNUNG2, MODELL_BEZEICHNUNG3, NACHFOLGER_ATYPO0, NACHFOLGER_ATYPO1, NACHFOLGER_ATYPO2, NACHFOLGER_ATYPO3, INFO1, bezInfo1, INFO2, bezInfo2, INFO3, bezInfo3, INFO4, bezInfo4, INFO5, bezInfo5, INFO6, bezInfo6, INFO7, bezInfo7, INFO8, bezInfo8, INFO9, bezInfo9, ARTIKELART, MODELL_NR, STAT_EINHEIT, VERKAUFS_EINHEIT, VERKAUFS_MENGE, VOLUMEN )
	SELECT
		NULL AS ATYPO0
		,a.Number AS ATYPO1
		,cw.[CW Number] AS ATYPO2
		,NULL AS ATYPO3

		-- TYPO1 / COLLECTION
		,'CO' + 
			CASE 
				WHEN a.[Collection] = 'Inline' THEN '1'
				WHEN a.[Collection] LIKE '(%' THEN '3' -- old values
				ELSE '2' -- rest of values
			END, 
		CASE 
			WHEN a.[Collection] = 'Inline' THEN 'Inline'
			WHEN a.[Collection] LIKE '(%' THEN 'Old'
			ELSE 'Rest'
		END

		-- TYPO2 - CATEGORY
		--,'CA' + TEITBL.PBRPBR,
		-- workaround:
		,'CA' + CASE TEITBL.PBRPBR
			WHEN 'accessories' THEN '1'
			WHEN 'bike' THEN '2'
			WHEN 'crossCountry' THEN '3'
			WHEN 'heritage' THEN '4'
			WHEN 'measurements' THEN '5'
			WHEN 'mountainPerformance' THEN '6'
			WHEN 'offCourse' THEN '7'
			WHEN 'outdoor' THEN '8'
			WHEN 'running' THEN '9'
			WHEN 'tecShirts' THEN '10'
			WHEN 'trainingStudio' THEN '11'
			WHEN 'underwear' THEN '12'
		END
		,a.Category

		-- TYPO3 / AGE GROUP
		--,'AG' + TEITBL.TEIZGR, 
		-- workaround:
		,'AG' + CASE TEITBL.TEIZGR
			WHEN 'adults' THEN '1'
			WHEN 'kids' THEN '2'
		END
		,a.[Age Group]

		 -- TYPO4 / PRODUCT GROUP
		-- change here also when ID gets numeric:
		,'PG' + CASE WHEN TEITBL.PBRPBR = 'underwear' THEN '00' ELSE TEITBL.AGTAGT END, 
		CASE WHEN TEITBL.PBRPBR = 'underwear' THEN 'none' ELSE a.[Group] END

		 -- TYPO5, subconcept is new. when subconcept is empty fall back to concept. but we need to make sure, that for the same values the key is the same
		, 
		CASE 
			WHEN TEITBL.TEISUB = '' THEN -- no subconcept defined, fallback to concept
				CASE -- check if we find a subconcept key for the concept, otherwise just take the concept key => key may be already used by subconcept
					WHEN (SELECT ASTAST FROM [CHHUNSVPDM6\PDM].[prod].[dbo].ASTTBL WHERE (ASAASA = 610) AND (ASTBEZ = a.Concept)) IS NULL THEN 'CN' + TEITBL.KNZKNZ
					ELSE 'SC' + (SELECT ASTAST FROM [CHHUNSVPDM6\PDM].[prod].[dbo].ASTTBL WHERE (ASAASA = 610) AND (ASTBEZ = a.Concept))
				END
			ELSE 'SC' + TEITBL.TEISUB
		END
		,CASE WHEN TEITBL.TEISUB = '' THEN a.Concept ELSE a.Subconcept END

		-- TYPO6 / TCS
		--,'TC' + TEITBL.TEITCS, 
		-- workaround:
		,'TC' + CASE TEITBL.TEITCS
			WHEN 'xLight' THEN '1'
			WHEN 'light' THEN '2'
			WHEN 'warm' THEN '3'
			WHEN 'xWarm' THEN '4'
			WHEN 'none' THEN '5'
		END
		,a.TCS

		,'', '' -- TYPO7
		,'', '' -- TYPO8
		,'', '' -- TYPO9
		,SUBSTRING(CONCAT(a.[Type], ' ', a.Name), 1, 30) -- ATYPO_BEZEICHNUNG1
		,SUBSTRING(cw.[CW Name], 1, 30) AS [COLOUR_NAME] -- ATYPO_BEZEICHNUNG2
		,NULL -- ATYPO_BEZEICHNUNG3
		,'OI', NULL, NULL,  -- MODELL_BEZEICHNUNG 1 - 3
		NULL, NULL, NULL, NULL -- NACHFOLGER_ATYPO 0 - 3

		-- INFO1
		--,'LY' + TEITBL.TEILAY, 
		-- workaround:
		,'LY' + CASE TEITBL.TEILAY
			WHEN 'first' THEN '1'
			WHEN 'middle' THEN '2'
			WHEN 'outer' THEN '3'
			WHEN 'none' THEN '4'
		END
		,a.Layer 
			
		,'CN' + TEITBL.KNZKNZ, a.Concept -- INFO2

		,'PT' + TEITBL.AGTAGT, a.[Type] -- INFO3
		
		-- INFO4
		--,'GN' + TEITBL.TEIGES, 
		,'GN' + CASE TEITBL.TEIGES
			WHEN 'female' THEN '1'
			WHEN 'male' THEN '2'
			WHEN 'unisex' THEN '3'
		END
		,a.Gender

		,'', '' -- INFO5
		,'', '' -- INFO6
		,'', '' -- INFO7
		,'', '' -- INFO8
		,'', '' -- INFO9
		,'N' -- ARTIKELART
		,NULL -- MODELL_NR
		,'1' -- STAT_EINHEIT
		,'STCK' -- VERKAUFS_EINHEIT
		,'1' -- VERKAUFS_MENGE
		,'1' --VOLUMEN
	FROM 
		PDM_INTERFACE.dbo.V_ADM_ARTICLE a
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY cw ON a.Number = cw.Number -- do not join with article_id, in order to not miss any colours from other seasons
		JOIN TEMP_LAST latest ON a.Number = latest.Number AND a.season_id = latest.last_season_id
		JOIN TEMP_LAST_CW latestCW ON cw.Number = latestCW.Number AND cw.[CW Number] = latestCW.[CW Number] AND cw.season_id = latestCW.last_season_id
		JOIN [CHHUNSVPDM6\PDM].[prod].[dbo].TEITBL ON TEITBL.ATLATL = a.article_id

	WHERE 
		a.season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')

	
	/*
	 * IN_VART
	 * Additional article/colourway information
	 */
	
	INSERT INTO IN_VART ( VTYPO1, VTYPO2, VTYPO3, ATYPO0, ATYPO1, ATYPO2, ATYPO3, ERST_ANGEBOTSTERMIN, ERSTLIEFER_TERMIN, AKTUELLIEFER_TERMIN, AUSLAUF_TERMIN, REFAR_VTYPO1, REFAR_VTYPO2, REFAR_VTYPO3, REFAR_ATYPO0, REFAR_ATYPO1, REFAR_ATYPO2, REFAR_ATYPO3, AE_PROZENT, KZ_ABC, KZ_AD_DISPO, FILLER1, FILLER2, PREIS1, PREIS2, PREIS3, KZ_DISPONENT, KZ_PLANER, GRGANG, KZ_PSEUDO, K_EINKAUFER, MINDEST_BESTELL_MENGE, MIN_BESTELL_MENGE_MODEL )
	SELECT
		'OI', NULL, NULL, NULL
		,a.Number -- ATYPO1
		,cw.[CW Number] -- ATYPO2
		,NULL, NULL
		,CASE
			WHEN SUBSTRING(cw.first_season_id, 3, 1) = '1' THEN '20' + SUBSTRING(cw.first_season_id, 1, 2) + '0115' -- SS
			ELSE '20' + SUBSTRING(cw.first_season_id, 1, 2) + '0615' -- FW
		END AS ERSTLIEFER_TERMIN -- Default value of first delivery window, may be updated during SP_TIA_1_2_ARTICLES_UPDATE
		,NULL -- AKTUELLIEFER_TERMIN
		,CASE 
			WHEN SUBSTRING(latestCW.last_season_id, 3, 1) = '1' THEN '20' + SUBSTRING(latestCW.last_season_id, 1, 2) + '0901' -- SS
			ELSE '20' + CAST(CAST(SUBSTRING(latestCW.last_season_id, 1, 2) as int) + 1 as varchar(2)) + '0301' -- FW
		END AS AUSLAUF_TERMIN, -- Default value of last delivery window, may be updated during SP_TIA_1_2_ARTICLES_UPDATE
		CASE 
			WHEN a.[Estimation Reference] IS NOT NULL AND (SELECT TOP 1 [CW Number] FROM PDM_INTERFACE.dbo.V_ADM_COLOURWAY WHERE Number = a.[Estimation Reference] AND [CW Number]= cw.[CW Number]) IS NOT NULL
			THEN 'OI'
		END AS REFAR_VTYPO1, 
		NULL, NULL, NULL, 
		CASE 
			WHEN a.[Estimation Reference] IS NOT NULL AND (SELECT TOP 1 [CW Number] FROM PDM_INTERFACE.dbo.V_ADM_COLOURWAY WHERE Number = a.[Estimation Reference] AND [CW Number]= cw.[CW Number]) IS NOT NULL
			THEN a.[Estimation Reference]
		END AS REFAR_ATYPO1,
		CASE 
			WHEN a.[Estimation Reference] IS NOT NULL AND (SELECT TOP 1 [CW Number] FROM PDM_INTERFACE.dbo.V_ADM_COLOURWAY WHERE Number = a.[Estimation Reference] AND [CW Number]= cw.[CW Number]) IS NOT NULL
			THEN cw.[CW Number]
		END AS REFAR_ATYPO2,
		NULL, 100, NULL, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
		a.[Size Range Number] AS GRGANG,
		NULL, NULL,
		CASE WHEN s.[Min qty CW] IS NULL THEN 0 ELSE s.[Min qty CW] END AS MINDEST_BESTELL_MENGE,
		CASE WHEN s.[Min qty article] IS NULL THEN 0 ELSE s.[Min qty article] END AS MIN_BESTELL_MENGE_MODEL
	FROM
		PDM_INTERFACE.dbo.V_ADM_ARTICLE a
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY cw ON a.Number = cw.Number -- do not join with article_id, in order to not miss any colours from other seasons
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY_SUPPLIER cwgm ON cwgm.article_id = cw.article_id AND cwgm.colour_sequence = cw.colour_sequence
		JOIN PDM_INTERFACE.dbo.V_ADM_ARTICLE_SUPPLIER gm ON gm.article_id = cwgm.article_id AND gm.[Main Supplier] = 1
		JOIN PDM_INTERFACE.dbo.V_ADM_SUPPLIER s ON s.supplier_id = cwgm.supplier_id AND s.supplier_id = gm.supplier_id
		JOIN TEMP_LAST latest ON a.Number = latest.Number AND a.season_id = latest.last_season_id
		JOIN TEMP_LAST_CW latestCW ON cw.Number = latestCW.Number AND cw.[CW Number] = latestCW.[CW Number] AND cw.season_id = latestCW.last_season_id
	WHERE
		a.season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')

	
	/*
	 * IN_ZVART
	 * Additional seasonal article/colourway information
	 */
	
	INSERT INTO IN_ZVART ( ZTYPO1, ZTYPO2, season, ZTYPO3, VTYPO1, VTYPO2, VTYPO3, ATYPO0, ATYPO1, ATYPO2, ATYPO3, KZ_DISPO, KZ_PROGNOSE_ART, KZ_ASTATUS, KZ_RANGED_CMS, NO_PROZENT, ZVINFO1, ZVINFO2, ZVINFO3, ZVINFO4, ZVINFO5, ZVINFO6, ZVINFO7, ZVINFO8, ZVINFO9 )
	SELECT
		SUBSTRING(a.season_id, 1, 2) + 2000 AS ZTYPO1 --Year
		,SUBSTRING(a.Season, 1, 2) AS ZTYPO2 -- FW/SS
		,a.i_season_id -- needed in ODERS_CLEAN_UP to join with IN_AUFPOS
		,NULL, 'OI', NULL, NULL, NULL
		,a.Number AS ATYPO1
		,cw.[CW Number] AS ATYPO2
		,NULL
		,CASE 
			WHEN cw.NOS = 1 THEN 'C' -- even a new CW will be classified as c/o here
			WHEN cw.[Carry Over CW] = 1 THEN 'C'
			ELSE 'N' -- TODO: ==> left over?!?!
		END AS KZ_DISPO -- carry over, new oder leftover >> Info from WPM => TODO: direkt hier setzen?
		,'B' AS KZ_PROGNOSE_ART -- default value
		,CASE WHEN cw.[Cancelled CW] = 0 THEN '1' ELSE '9' END AS KZ_ASTATUS
		,'Y' AS KZ_RANGED_CMS -- default value
		,NULL AS NO_PROZENT
		,CASE WHEN cw.[Carry Over CW] = 1 THEN 'Y' ELSE 'N' END AS ZVINFO1
		,CASE WHEN ix.StandardJN = '15' THEN 'Y' ELSE 'N' END AS ZVINFO2 -- Stock Item	
		,CASE WHEN ix.StandardJN = '05' THEN 'Y' ELSE 'N' END AS ZVINFO3 -- NOS
		,CASE WHEN cwgm.ISO = 1 THEN 'Y' ELSE 'N' END AS ZVINFO4
		,CASE WHEN ix.StandardJN = '20' THEN 'Y' ELSE 'N' END AS ZVINFO5 -- Essential 
		, NULL, NULL, NULL, NULL
	FROM 
		PDM_INTERFACE.dbo.V_ADM_ARTICLE a
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY cw ON a.article_id = cw.article_id
		JOIN PDM_INTERFACE.dbo.V_ADM_ARTICLE_SUPPLIER gm ON gm.article_id = a.article_id AND gm.[Main Supplier] = 1
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY_SUPPLIER cwgm ON cwgm.article_id = a.article_id AND cwgm.colour_sequence = cw.colour_sequence AND cwgm.supplier_id = gm.supplier_id
		LEFT JOIN SPOT_SRC.dbo.SIXH_ARTFARBEN ix ON ix.ArtsNr1 = a.Number AND ix.ArtsKey = a.i_season_id AND ix.VerkFarbe = cw.[CW Number]

	WHERE 
		a.season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')


	/*
	 * IN_VARTGR
	 * Sizes
	 */

	INSERT INTO IN_VARTGR (	VTYPO1, VTYPO2, VTYPO3, ATYPO0, ATYPO1, ATYPO2, ATYPO3, TECH_INDEX, gr, ggnr, START_TERMIN_GR, AUSLAUF_TERMIN_GR, GR_STATUS, GRSL_MAN, LB_FREI, RESERVIERUNGEN, RUECKSTAND, MINDESTBESTAND, MAXIMALBESTAND, FILLER1, FILLER2, FILLER3, ZIEL_RW, WBZ, DF_FAKTOR_MAN, INFO1, INFO2, INFO3, INFO4, INFO5, SPERR_BESTAND, ABGEBENDE_NL, GEWICHT, VOLUMEN )
	SELECT DISTINCT
		'OI', NULL, NULL, NULL
		,a.Number AS ATYPO1
		,cw.[CW Number] AS ATYPO2
		,NULL
		,NULL AS TECH_INDEX -- will be updated in SP_TIA_22_ARTICLES_UPDATE
		,sku.Size
		,a.[Size Range Number] AS ggnr
		,NULL AS START_TERMIN_GR -- will be updated in SP_TIA_22_ARTICLES_UPDATE
		,NULL AS AUSLAUF_TERMIN_GR -- will be updated in SP_TIA_22_ARTICLES_UPDATE
		,1 AS GR_STATUS -- will be updated in SP_TIA_22_ARTICLES_UPDATE
		,0
		,0 AS LB_FREI -- will be updated in SP_TIA_22_ARTICLES_UPDATE
		,0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0
	FROM 
		PDM_INTERFACE.dbo.V_ADM_ARTICLE a
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY cw ON a.Number = cw.Number -- do not join with article_id, in order to not miss any colours from other seasons
		left JOIN PDM_INTERFACE.dbo.V_ADM_SKU sku ON a.Number = sku.Number AND sku.[CW Number] = cw.[CW Number] -- do not join with article_id, in order to not miss any sizes from other seasons
		JOIN TEMP_LAST latest ON a.Number = latest.Number AND a.season_id = latest.last_season_id 
		JOIN TEMP_LAST_CW latestCW ON cw.Number = latestCW.Number AND cw.[CW Number] = latestCW.[CW Number] AND cw.season_id = latestCW.last_season_id
	WHERE 
		a.season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')

	
	

	/*
	 * IN_LIEFERANT
	 */

	INSERT INTO IN_LIEFERANT (LIEFNR, LIEFNAME1, LIEFNAME2, LIEFTYP, VTYPO1, VTYPO2, VTYPO3, ANSPRECHPARTNER, LANDKZ, ZIP, ORT, STRASSE, EMAIL, BESTELLTAG, ANLIEFERTAG, MINDESTBESTELL_MENGE, MINDESTBESTELL_EINHEIT, REFERENZ_NR, STATUS)
	SELECT DISTINCT 
		rtrim(LiefNr) AS [LIEFNR]
		,replace(ltrim(rtrim(Match)), ';', ',') AS [LIEFNAME1]
		,replace(ltrim(rtrim(Name1)), ';', ',') AS [LIEFNAME2]
		,'L' AS [LIEFTYP]
		,NULL, NULL, NULL
		,replace(ltrim(rtrim(Ansprech1)), ';', ',') AS [ANSPRECHPARTNER]
		,replace(ltrim(rtrim(Land)), ';', ',') AS [LANDKZ]
		,replace(ltrim(rtrim(Plz)), ';', ',') AS [ZIP]
		,replace(ltrim(rtrim(Ort)), ';', ',') AS [ORT]
		,replace(ltrim(rtrim(Strasse)), ';', ',') AS [STRASSE]
		,NULL AS [EMAIL]
		,NULL AS [BESTELLTAG]
		,NULL AS [ANLIEFERTAG]
		,s.[Min qty CW] AS [MINDESTBESTELL_MENGE]
		,'Stck' AS [MINDESTBESTELL_EINHEIT]
		,replace(ltrim(rtrim(UnsereKundenNr)), ';', ',') AS [REFERENZ_NR]
		,CASE WHEN s.Active = 1 THEN 1 ELSE 9 END AS [STATUS]
	FROM 
		SPOT_SRC.dbo.SIXH_LIEFERANT
		JOIN PDM_INTERFACE.dbo.V_ADM_SUPPLIER s ON s.intex_id = RTRIM(SIXH_LIEFERANT.LiefNr) 


	
	INSERT INTO IN_LIEFVARTGR ( LIEFNR, PRIO, ATYPO0, ATYPO1, ATYPO2, ATYPO3, TECH_INDEX, gr, ggnr, VTYPO1, VTYPO2, VTYPO3, TYP, EINSTANDS_PREIS, BEST_EINHEIT, WBM_MAN, KZ_OPT, OPT_ERHOEH_MENGE, WBM_LANG, WBM_KURZ, ARTIKEL_NUMMMER, ARTIKEL_BEZ, INFO01, INFO02, INFO03, INFO04, INFO05, [STATUS], SPLITKRITERIUM, BEST_FREQUENZ, ODL_1, ODL_2, ODL_3 )
	SELECT DISTINCT 
		s.intex_id
		,CASE WHEN gm.[Main Supplier] = 1 THEN '1' ELSE '2' END AS PRIO
		,NULL
		,a.Number AS ATYPO1
		,cw.[CW Number] AS ATYPO2
		,NULL
		,NULL AS TECH_INDEX -- will be updated in SP_TIA_22_ARTICLES_UPDATE
		,sku.Size
		,a.[Size Range Number] AS ggnr
		,'OI', NULL, NULL, 'L' AS TYP, 0 AS EINSTANDS_PREIS, 'STCK', 1, 'Y', NULL, 
		gm.[Lead time] AS WBM_LANG, gm.[Lead time] AS WBM_KURZ, 
		NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, 
		CASE WHEN cwgm.ISO = 0 THEN '6' ELSE '1' END AS BEST_FREQUENZ, 
		NULL, NULL, NULL
	FROM 
		PDM_INTERFACE.dbo.V_ADM_ARTICLE a
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY cw ON a.Number = cw.Number -- do not join with article_id, in order to not miss any colours from other seasons
		--JOIN PDM_INTERFACE.dbo.V_ADM_SKU sku ON sku.article_id = cw.article_id AND sku.[CW Number] = cw.[CW Number]
		JOIN PDM_INTERFACE.dbo.V_ADM_SKU sku ON a.Number = sku.Number AND sku.[CW Number] = cw.[CW Number] -- do not join with article_id, in order to not miss any sizes from other seasons
		JOIN PDM_INTERFACE.dbo.V_ADM_ARTICLE_SUPPLIER gm ON gm.article_id = cw.article_id
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY_SUPPLIER cwgm ON cwgm.article_id = cw.article_id AND cwgm.colour_sequence = cw.colour_sequence AND cwgm.supplier_id = gm.supplier_id
		JOIN PDM_INTERFACE.dbo.V_ADM_SUPPLIER s ON s.supplier_id = gm.supplier_id
		JOIN TEMP_LAST latest ON a.Number = latest.Number AND a.season_id = latest.last_season_id
		JOIN TEMP_LAST_CW latestCW ON cw.Number = latestCW.Number AND cw.[CW Number] = latestCW.[CW Number] AND cw.season_id = latestCW.last_season_id
	WHERE 
		a.season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')

	/* IN_BILDER */
	INSERT INTO IN_BILDER (ATYPO0, ATYPO1, ATYPO2, ATYPO3, BILDREFERENZ)
	SELECT DISTINCT 
		NULL, 
		a.Number AS ATYPO1,
		cw.[CW Number] AS ATYPO2, 
		NULL, 
		a.Number + '_A_' + cw.[CW Number] + '.jpg'
	FROM 
		PDM_INTERFACE.dbo.V_ADM_ARTICLE a
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY cw ON a.article_id = cw.article_id
	WHERE
		a.Cancelled = 0
		AND cw.[Cancelled CW] = 0
		AND a.season_id >= 161
		AND a.season_id <= (SELECT MAX(DSEA_NUMBER) FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')

	
	IF OBJECT_ID('TEMP_LAST') IS NOT NULL DROP TABLE TEMP_LAST; 
	IF OBJECT_ID('TEMP_LAST_CW') IS NOT NULL DROP TABLE TEMP_LAST_CW; 

END
GO
