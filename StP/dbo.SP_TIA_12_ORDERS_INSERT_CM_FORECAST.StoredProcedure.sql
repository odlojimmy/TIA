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
/****** Object:  StoredProcedure [dbo].[SP_TIA_12_ORDERS_INSERT_CM_FORECAST]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_TIA_12_ORDERS_INSERT_CM_FORECAST]
AS
BEGIN

	SET NOCOUNT ON;

	/*
	 * Add CM Forecast to IN_AUFKOPF
	 */
	INSERT INTO IN_AUFKOPF (AUFTRAGS_NR, KD_NUMMER, AUFTRAGS_ART, KZ_NO, VTYPO1, bezVtypo01, VTYPO2, bezVtypo02, VTYPO3, bezVtypo03, IM_DATUM)
	SELECT DISTINCT 
		ltrim(RTRIM(aknummer)) AS AUFTRAGS_NR
		,'600000' AS KD_NUMMER -- OCH Estimation Kunde fix
		,'PM' AS AUFTRAGS_ART -- Auftragsart PM fix
		,'1' AS KZ_NO -- PM Forecast ist immer '1' preorder
		,'OI' AS VTYPO1
		,'Odlo int.' AS bezVtypo01
		,NULL, NULL, NULL, NULL
		,akdatum AS IM_DATUM
	FROM (
		SELECT DISTINCT 'PM' + i_season_id AS aknummer
			,CASE 
				WHEN SUBSTRING(season_id, 3, 1) = '1'
					THEN '20' + CAST(CAST(SUBSTRING(season_id, 1, 2) AS INT) - 2 AS NVARCHAR) + '0201'
				ELSE '20' + CAST(CAST(SUBSTRING(season_id, 1, 2) AS INT) - 2 AS NVARCHAR) + '0801'
				END AS akdatum
		FROM 
			PDM_INTERFACE.dbo.V_ADM_ARTICLE a
		WHERE 
			a.season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')
		) AS tm


	
	/*
	 * Add CM Forecast to IN_AUFPOS
	 */
	INSERT INTO IN_AUFPOS ( AUFTRAGS_NR, art, aufkkey, POSITIONS_NR, EINTEIL_NR, AENDERUNGS_NR, ATYPO0, ATYPO1, ATYPO2, ATYPO3, TECH_INDEX, gr, ggnr, KZ_FILTER1, KZ_FILTER2, KZ_FILTER3, STORNO_GRUND, PER_DATUM, ZUG_DATUM, DATUM, MENGE, offene_menge, reservierte_menge, ZTYPO1, ZTYPO2, ZTYPO3, WERT )
	SELECT 
		'PM' + a.i_season_id AS AUFTRAGS_NR
		,'PM' AS art
		,a.i_season_id
		,ROW_NUMBER() OVER (PARTITION BY a.season_id ORDER BY a.season_id DESC) AS POSITIONS_NR
		,[Base Size] AS EINTEIL_NR
		,NULL
		,NULL
		,a.Number AS ATYPO1
		,cw.[CW Number] AS ATYPO2
		,NULL
		,NULL AS TECH_INDEX
		,a.[Base Size]
		,a.[Size Range Number]
		,NULL, NULL, NULL, NULL
		,CASE 
			WHEN SUBSTRING(a.season_id, 3, 1) = '1'
				THEN '20' + SUBSTRING(a.season_id, 1, 2) + '0630'
			ELSE '20' + SUBSTRING(a.season_id, 1, 2) + '1230'
		END AS PER_DATUM
		,CASE 
			WHEN SUBSTRING(a.season_id, 3, 1) = '1'
				THEN '20' + SUBSTRING(a.season_id, 1, 2) + '0630'
			ELSE '20' + SUBSTRING(a.season_id, 1, 2) + '1230'
		END AS ZUG_DATUM
		,CASE 
			WHEN SUBSTRING(a.season_id, 3, 1) = '1'
				THEN '20' + CAST(CAST(SUBSTRING(a.season_id, 1, 2) AS INT) - 2 AS NVARCHAR) + '0201'
			ELSE '20' + CAST(CAST(SUBSTRING(a.season_id, 1, 2) AS INT) - 2 AS NVARCHAR) + '0801'
		END AS DATUM
		,a.[CM Forecast] AS MENGE
		,0
		,0
		,SUBSTRING(ltrim(rtrim(a.season_id)), 1, 2) + 2000 AS ZTYPO1 --Year
		,CASE 
			WHEN SUBSTRING(ltrim(rtrim(a.season_id)), 3, 1) = '1' THEN 'SS'
			WHEN SUBSTRING(ltrim(rtrim(a.season_id)), 3, 1) = '2' THEN 'FW'
			ELSE 'undefined'
		END AS ZTYPO2 -- SS/FW
		,NULL
		,cast(cast(a.[CM Forecast] AS INT) * (cast(a.[RP €] AS DECIMAL(10, 2)) * 1.43 / (2.2 * 2.5)) AS DECIMAL(10, 2)) AS [v_EUR_gross_original]
	FROM 
		PDM_INTERFACE.dbo.V_ADM_ARTICLE a
		JOIN PDM_INTERFACE.dbo.V_ADM_COLOURWAY cw ON a.article_id = cw.article_id AND colour_sequence = (SELECT MIN(colour_sequence) FROM PDM_INTERFACE.dbo.V_ADM_COLOURWAY WHERE article_id = a.article_id AND [Cancelled CW] = 0) -- only select one active colour
	WHERE
		a.season_id IN (SELECT DSEA_NUMBER FROM GENERAL_CHECK_Reports.dbo.SYSTEM_SEASON_RANGES WHERE JOB = 'INTERFACE_TIA')
		AND [CM Forecast] > 0
		AND [Base Size] IS NOT NULL

END
GO
