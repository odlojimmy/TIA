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
/****** Object:  StoredProcedure [dbo].[SP_TIA_31_CUSTOMERS_UPDATE]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_TIA_31_CUSTOMERS_UPDATE]
AS
BEGIN

	SET NOCOUNT ON;

	/*
	 * special case Odlo China @IN_KUNDEN
	 */

	DELETE FROM IN_KUNDEN WHERE KUNDENTYPO1 = 'Odlo CN' AND KD_NAME <> 'ESTIMATION'
	
	UPDATE IN_KUNDEN -- reassign intercompany customer to Odlo China
	SET KUNDENTYPO1 = 'Odlo CN', infor_channel_key = 'OCN_China', KUNDENTYPO3 = 'China', ic_code = 'TP'
	WHERE KD_NUMMER = '350831'



	/*
	 * UPDATE KUNDENTYPO2 @IN_KUNDEN
	 */
	UPDATE IN_KUNDEN SET KUNDENTYPO2 = INFOR_TIAGroup
	FROM IN_KUNDEN k JOIN SPOT_SRC.dbo.SHLP_INFOR_CHANNEL_GROUP ic ON k.infor_channel_key = ic.INFOR_CHANNEL_KEY



	/*  UPDATE SHOP INFORMATIONEN @IN_KUNDEN  */
	BEGIN TRANSACTION

	IF OBJECT_ID('#ttSHOP') IS NOT NULL DROP TABLE #ttSHOP

  
	SELECT DISTINCT CustomerNumber
		,CASE 
			WHEN CompanyType = 'OAT' THEN 'Odlo AT'
			WHEN CompanyType = 'OCH' THEN 'Odlo CH'
			WHEN CompanyType = 'ON' THEN 'Odlo NO'
			WHEN CompanyType = 'OF' THEN 'Odlo FR'
			WHEN CompanyType = 'ODST' THEN 'Odlo DE'
			ELSE CompanyType
			END AS [CompanyType]
		,[Channel]
		,[INFOR_Channel]
	INTO #ttSHOP
	FROM [DWHLIGHT].[dbo].[CORE_CustomerData_Shop]
	WHERE ExportYear = YEAR(getDate())
		AND ExportMonth = MONTH(getDATE()) 
	/*  JRU, 30.08.2017 START
	Temporary Fix for the stores, which opened after INFOR's shutdown */
		UNION 
	SELECT '350108', 'Odlo CH', 'ODLO-Store', 'Luzern' UNION
	SELECT '350109', 'Odlo DE', 'Outlet', 'Brenner' 
	/*  JRU, 30.08.2017 END */

	UPDATE IN_KUNDEN
	SET KUNDENTYPO1 = [CompanyType], KUNDENTYPO2 = [Channel], KUNDENTYPO3 = [INFOR_Channel]
	FROM IN_KUNDEN
	JOIN #ttSHOP ON KD_NUMMER = CustomerNumber

	IF OBJECT_ID('#ttSHOP') IS NOT NULL DROP TABLE #ttSHOP

	COMMIT TRANSACTION


	/*  UPDATE ESTIMATION KUNDEN @IN_KUNDEN  */
	UPDATE IN_KUNDEN SET KUNDENTYPO2 = 'Estimation', KUNDENTYPO3 = 'Estimation' WHERE KD_NAME = 'ESTIMATION'


	/* REPORT BAD DATA FROM IN_KUNDEN */

	INSERT INTO IN_KUNDEN_verification (KD_NUMMER, KD_NAME, activeYN, KD_LAND, STRASSE, PLZ, ORT, KD_TYP, VERTRETERKENNUNG, VERTRETERNAME, VERTRETERGEBIET, KUNDENTYPO1, KUNDENTYPO2,infor_channel_key, KUNDENTYPO3, KEYACCOUNTMANAGER, ic_code) 
	SELECT [KD_NUMMER]
		,[KD_NAME]
		,[activeYN]
		,[KD_LAND]
		,[STRASSE]
		,[PLZ]
		,[ORT]
		,[KD_TYP]
		,[VERTRETERKENNUNG]
		,[VERTRETERNAME]
		,[VERTRETERGEBIET]
		,KUNDENTYPO1
		,KUNDENTYPO2
		,[infor_channel_key]
		,[KUNDENTYPO3]
		,[KEYACCOUNTMANAGER]
		,[ic_code]
	FROM IN_KUNDEN
	WHERE KUNDENTYPO2 IN ( 'undefinedCGroup','undefinedINFOR_GROUP'	)
		OR KUNDENTYPO3 = 'undefined'
		OR ic_code IN ('Frei')



	/*  BEREINIGEN / UPDATE / ZUSAMMENFASSEN KUNDENTYPO3 @IN_KUNDEN (a/b)  */

	UPDATE IN_KUNDEN SET KUNDENTYPO2 = 'Franchise' WHERE KUNDENTYPO2 LIKE ('Franchise%')

	UPDATE IN_KUNDEN SET KUNDENTYPO2 = 'IC' WHERE KUNDENTYPO2 IN ('Intercompany')

	UPDATE IN_KUNDEN SET KUNDENTYPO2 = 'Key Account' WHERE KUNDENTYPO2 LIKE ('Key Account%')

	UPDATE IN_KUNDEN SET KUNDENTYPO2 = 'Wholesale' WHERE KUNDENTYPO2 LIKE ('Retail%') OR KUNDENTYPO2 LIKE ('Sales Area%') OR KUNDENTYPO2 LIKE ('Third%')



	/*  BEREINIGEN / UPDATE / ZUSAMMENFASSEN KUNDENTYPO3 @IN_KUNDEN (b/b)  */
	UPDATE IN_KUNDEN SET KUNDENTYPO3 = KUNDENTYPO2 WHERE KUNDENTYPO2 IN ( 'IC', 'Franchise', 'Wholesale' )
	UPDATE IN_KUNDEN SET KUNDENTYPO3 = 'undefined', KUNDENTYPO2 = 'undefined' WHERE KUNDENTYPO2 IN ( 'undefinedCGroup', 'undefinedINFOR_GROUP' )

	

	/* Zuordnung von KD_TYP @ IN_KUNDEN  */

	UPDATE IN_KUNDEN
	SET KD_TYP = CASE
					WHEN KUNDENTYPO2 = 'Wholesale' THEN '01'
					WHEN KUNDENTYPO2 = 'Importers' THEN '02'
					WHEN KUNDENTYPO2 = 'ODLO-Store' THEN '03'
					WHEN KUNDENTYPO2 = 'Franchise' THEN '04'
					WHEN KUNDENTYPO2 = 'E-Commerce' THEN '05'
					WHEN KUNDENTYPO2 = 'Key Account' THEN '06'
					WHEN KUNDENTYPO2 = 'Outlet' THEN '07'
					WHEN KUNDENTYPO2 = 'OCH_Sponsoring' THEN '08'
					WHEN KUNDENTYPO2 = 'IC' THEN '09'
					WHEN KUNDENTYPO2 = 'Estimation' THEN '10'
				ELSE '11' END


	/* KD_TYP wird in KUNDENTYPO2 kopiert @ IN_KUNDEN  */
	UPDATE IN_KUNDEN SET KUNDENTYPO2 = KD_TYP


END
GO
