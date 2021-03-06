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
/****** Object:  StoredProcedure [dbo].[SP_TIA_11_ORDERS_UPDATE]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_TIA_11_ORDERS_UPDATE]
AS
BEGIN

	SET NOCOUNT ON;
	
	/*
	 * VTYPO2 wird nicht mehr benutzt 19.03.2015 // temp: VTYPO2 um IC Aufträge zu eliminieren // UPDATE VTYPO2 @IN_AUFKOPF round 1 
	 */
	 /*
	IF OBJECT_ID('#ttks') IS NOT NULL DROP TABLE #ttks
	
	SELECT distinct KD_NUMMER, KUNDENTYPO1, ic_code as IC_Code
	INTO #ttks
	FROM IN_KUNDEN

	UPDATE IN_AUFKOPF 
	SET VTYPO2 = CASE 
			WHEN KUNDENTYPO1 = 'Odlo DE' THEN 'ODE'
			WHEN KUNDENTYPO1 = 'Odlo AT' THEN 'OAT'
			WHEN KUNDENTYPO1 = 'Odlo CH' THEN 'OCH'
			WHEN KUNDENTYPO1 = 'Odlo BE' THEN 'OBN'
			WHEN KUNDENTYPO1 = 'Odlo NL' THEN 'OBN'
			WHEN KUNDENTYPO1 = 'Odlo CN' THEN 'OCN'
			WHEN KUNDENTYPO1 = 'Odlo FR' THEN 'OFR'
			WHEN KUNDENTYPO1 = 'Odlo NO' THEN 'ONO'
			WHEN KUNDENTYPO1 = 'Odlo UK' THEN 'OUK'
			WHEN KUNDENTYPO1 = 'Odlo TR' THEN 'Oec'
			WHEN KUNDENTYPO1 = 'Odlo OI' THEN 'Oim'
			ELSE '_' + ks.IC_Code
			END
		,bezVtypo02 = CASE 
			WHEN KUNDENTYPO1 = 'Odlo DE' THEN KUNDENTYPO1
			WHEN KUNDENTYPO1 = 'Odlo AT' THEN KUNDENTYPO1
			WHEN KUNDENTYPO1 = 'Odlo CH' THEN KUNDENTYPO1
			WHEN KUNDENTYPO1 = 'Odlo BE' THEN 'Odlo BE/NL'
			WHEN KUNDENTYPO1 = 'Odlo NL' THEN 'Odlo BE/NL'
			WHEN KUNDENTYPO1 = 'Odlo CN' THEN KUNDENTYPO1
			WHEN KUNDENTYPO1 = 'Odlo FR' THEN KUNDENTYPO1
			WHEN KUNDENTYPO1 = 'Odlo NO' THEN KUNDENTYPO1
			WHEN KUNDENTYPO1 = 'Odlo UK' THEN KUNDENTYPO1
			WHEN KUNDENTYPO1 = 'Odlo TR' THEN 'Odlo eCommerce'
			WHEN KUNDENTYPO1 = 'Odlo OI' THEN 'Odlo Importers'
			ELSE KUNDENTYPO1 + '>>' + IC_Code
			END
	FROM IN_AUFKOPF ak
	JOIN #ttks ks ON ak.KD_NUMMER = ks.KD_NUMMER


	IF OBJECT_ID('#ttks') IS NOT NULL DROP TABLE #ttks


	/*
	 * VTYPO2 nur temporär um IC Aufträge zu löschen // UPDATE VTYPO2 @IN_AUFKOPF round 2
	 */

	IF OBJECT_ID('#ttrt') IS NOT NULL DROP TABLE #ttrt

	SELECT DISTINCT CustomerNumber
	INTO #ttrt
	FROM [DWHLIGHT].[dbo].[CORE_CustomerData_Shop]

	UPDATE IN_AUFKOPF
	SET VTYPO2 = 'Osh', bezVtypo02 = 'Odlo Shop'
	FROM IN_AUFKOPF
	JOIN #ttrt ON KD_NUMMER = CustomerNumber
	

	IF OBJECT_ID('#ttrt') IS NOT NULL DROP TABLE #ttrt
	*/

END


GO
