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
/****** Object:  StoredProcedure [dbo].[SP_TIA_30_CUSTOMERS_INSERT]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_TIA_30_CUSTOMERS_INSERT]
AS
BEGIN

	SET NOCOUNT ON;

	TRUNCATE TABLE IN_KUNDEN
	TRUNCATE TABLE IN_KUNDEN_verification


	/*
	 * IN_KUNDEN
	 */
	INSERT INTO IN_KUNDEN (KD_NUMMER, activeYN, KD_NAME, KD_LAND, STRASSE, PLZ, ORT, KD_TYP, VERTRETERKENNUNG, VERTRETERNAME, VERTRETERGEBIET, KUNDENTYPO1, KUNDENTYPO2, infor_channel_key, KUNDENTYPO3, KEYACCOUNTMANAGER, ic_code)
	SELECT DISTINCT
		k.KusNr
		,k.[AktivJN]
		,replace(ltrim(RTRIM(SUBSTRING(k.[Name1],1,30))), ';', ',')  -- bis 09.07.2015 replace(ltrim(RTRIM(k.Match)), ';', ',')
		,replace(ltrim(RTRIM(k.Land)), ';', ',')
		,replace(ltrim(rtrim(k.[Str])), ';', ',') AS STRASSE
		,replace(ltrim(RTRIM(k.Plz)), ';', ',')
		,replace(ltrim(RTRIM(k.Ort)), ';', ',')
		,'1' AS KD_TYP
		,k.VersNr
		,replace(ltrim(RTRIM(v.Name1)), ';', ',')
		,'OI' AS VERTRETERGEBIET
		,ltrim(rtrim(tpfirmentyp.zeile)) AS KUNDENTYPO1 -- Odlo DE, Odlo CH...
		,'undefinedINFOR_GROUP' AS KUNDENTYPO2 --eg INFO_Channel_Group => update in second step
		,CASE WHEN k.FachGrp = '05' THEN 'OCH_OI' ELSE k.INFORChannel END  --Mitarbeiter bekommen "künstlich" einen intercompany INFORChannel (eg OCH_OI)
		,ltrim(rtrim(tpinfor.zeile)) AS KUNDENTYPO3 --eg INFO_Channel
		,'OI' AS KEYACCOUNTMANAGER
		,ltrim(rtrim(tpic.zeile)) AS ic_code -- TP, IC22, IC37, PCBE...
	FROM 
		INTEXSALES.OdloDE.dbo.VerStamm v
		,INTEXSALES.OdloDE.dbo.TpText tpfirmentyp
		,INTEXSALES.OdloDE.dbo.KuStamm k
		LEFT OUTER JOIN INTEXSALES.OdloDE.dbo.TpText tpic ON (
			k.SelKrit6 = tpic.tpwert
			AND k.TabKey_SelKrit6 = tpic.tapkey
			AND tpic.tanr = 305
			AND tpic.sprache = '01'
			AND tpic.lfd = 1
			)
		,INTEXSALES.OdloDE.dbo.TpText tpinfor
	WHERE 
		k.VersKey = v.VersKey
		AND k.VersNr = v.VersNr
		AND k.TapKey_FirmenTyp = tpfirmentyp.tapkey
		AND k.FirmenTyp = tpfirmentyp.tpwert
		AND tpfirmentyp.tanr = 95
		AND tpfirmentyp.sprache = '01'
		AND tpfirmentyp.lfd = 1
		AND tpinfor.tanr = 96
		AND tpinfor.sprache = '01'
		AND tpinfor.lfd = 1
		AND k.INFORChannel = tpinfor.tpwert
		AND k.FirmenTyp < 80 -- Exclude Didrikson (Firmentyp 80) and others... // mz: 27.05.2016
END
GO
