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
/****** Object:  StoredProcedure [dbo].[SP_TIA_10_ORDERS_INSERT]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_TIA_10_ORDERS_INSERT]
AS
BEGIN

SET NOCOUNT ON;


/*
 * TRUNCATE INTERFACE TABLES
 */
TRUNCATE TABLE IN_AUFKOPF
TRUNCATE TABLE IN_AUFPOS
TRUNCATE TABLE IN_OBESTELL


/*
 * Prepare temp table with erroneous positions to exclude from orders later
 * (caused by GGNr mixup within Intex)
 */
IF OBJECT_ID('ERR_AUFPOS') IS NOT NULL DROP TABLE ERR_AUFPOS; 
CREATE TABLE ERR_AUFPOS ( AufkKey char(7), AufkNr int, AufPNr smallint, Gr char(7) );
INSERT INTO ERR_AUFPOS
SELECT AufkKey, AufkNr, AufPNr, Gr
FROM SPOT_SRC.dbo.SIXH_AUFGROESSE
GROUP BY AufkKey, AufkNr, AufPNr, Gr
HAVING count(Gr) > 1 AND AufkKey LIKE ('011%') and AufkKey not LIKE ('0119%') and AufkKey >= '011131H'

	
/*
 * IN_AUFKOPF
 */
INSERT INTO IN_AUFKOPF (AUFTRAGS_NR, KD_NUMMER, AUFTRAGS_ART, KZ_NO, VTYPO1, bezVtypo01, VTYPO2, bezVtypo02, VTYPO3, bezVtypo03, IM_DATUM)
SELECT DISTINCT 
	LTRIM(RTRIM(ak.AufkNr)) AS AUFTRAGS_NR
	,LTRIM(RTRIM(ak.KusNr)) AS KD_NUMMER
	,LTRIM(RTRIM(ak.Art)) AS AUFTRAGS_ART
	,CASE WHEN LTRIM(RTRIM(ak.Art)) IN ('01', '12', '14', '22', '32', '41', '42', '98', 'ES', '07', '17', '27') THEN '1' ELSE '2' END AS KZ_NO -- VORORDER (1) / NACHORDER (2)
	,'OI' AS VTYPO1
	,'Odlo int.' AS bezVtypo01
	,NULL, NULL, NULL, NULL
	,CONVERT(VARCHAR(8), ak.KuADatum, 112) AS IM_DATUM
FROM
	SPOT_SRC.dbo.SIXH_AUFKOPF ak
WHERE 
	ak.AufkKey >= '011131H'
	AND ak.AufkKey LIKE ('011%')
	AND ak.AufkKey NOT LIKE ('0119%')
	AND ak.Art IN ( '01' ,'04' ,'06' ,'12' ,'14' ,'21' ,'22' ,'32', '41', '42', '98', '99', 'ES', '07', '17', '27')
	AND LTRIM(RTRIM(ak.KusNr)) NOT IN (99,990,991,992,993,994,995,996,997,998,999,9995,9996,9997,9998,9999)-- TEST Kunden INTEX
	AND ak.AufkNr <> -1 -- wrong order in Intex



/*
 * IN_AUFPOS
 */
INSERT INTO IN_AUFPOS (AUFTRAGS_NR, bezugAufkNr, bezugKdNr, art, aufkkey, POSITIONS_NR, EINTEIL_NR, AENDERUNGS_NR, ATYPO0, ATYPO1, ATYPO2, ATYPO3, TECH_INDEX, gr, ggnr, KZ_FILTER1, KZ_FILTER2, KZ_FILTER3, STORNO_GRUND, PER_DATUM, ZUG_DATUM, DATUM, MENGE, offene_menge, reservierte_menge, ZTYPO1, ZTYPO2, ZTYPO3, WERT)
SELECT DISTINCT 
	ap.AufkNr AS AUFTRAGS_NR
	,CASE WHEN ak.Art IN ('07', '17', '27') THEN ap.BezugAufkNr ELSE NULL END as bezugAufkNr
	,'' as bezugKdNr  -- wird in 2tem Schritt ergänzt
	,LTRIM(RTRIM(ak.Art))
	,ak.AufkKey
	,ap.AufPNr AS POSITIONS_NR
	,LTRIM(RTRIM(ag.Gr)) AS EINTEIL_NR
	,NULL, NULL
	,LTRIM(RTRIM(ap.ArtsNr1)) AS ATYPO1
	,LTRIM(RTRIM(ap.VerkFarbe)) AS ATYPO2
	,NULL
	,NULL AS TECH_INDEX -- will be added later in SP_TIA_22_ARTICLES_UPDATE
	,CASE WHEN LTRIM(RTRIM(ag.Gr)) = '-' THEN 'One Size' ELSE LTRIM(RTRIM(ag.Gr)) END AS gr
	,CASE -- transform old size range numbers to current
		WHEN ag.GGNr = 82 OR ag.GGNr = 83 OR ag.GGNr = 311 OR ag.GGNr = 323 THEN 501 -- Kids--Conf:80-176
		WHEN ag.GGNr = 406 THEN 503 -- Ladies--Conf:34-50
		WHEN ag.GGNr = 405 OR ag.GGNr = 407 THEN 502 -- Ladies--Conf short:17-25
		WHEN ag.GGNr = 14 THEN 513 -- Men--Conf:46-58
		WHEN ag.GGNr = 76 THEN 512 -- Men--Conf short:23-29
		WHEN ag.GGNr = 25 OR ag.GGNr = 308 OR ag.GGNr = 309 OR ag.GGNr = 322 THEN 511 -- Ladies - Sport: XXS-4XL
		WHEN ag.GGNr = 314 THEN 510 -- Ladies--Sport short:XS-XXL
		WHEN ag.GGNr = 327 THEN 509 -- Ladies--Sport long:XS-XXL
		WHEN ag.GGNr = 20 OR ag.GGNr = 24 OR ag.GGNr = 31 OR ag.GGNr = 41 THEN 516 -- Men--Sport:XXS-4XL
		WHEN ag.GGNr = 301 THEN 515 -- Men--Sport short:XS-XXL
		WHEN ag.GGNr = 328 THEN 514 -- Men--Sport long:XS-XXL
		WHEN ag.GGNr = 18 OR ag.GGNr = 97 OR ag.GGNr = 207 THEN 519 -- Unisex--Sport Acc:4XS-3XL
		WHEN ag.GGNr = 201 THEN 517 -- Unisex--One Size:---
		WHEN ag.GGNr = 202 THEN 518 -- Unisex--Socks:36-38-45-47
		WHEN LTRIM(RTRIM(ap.ArtsNr1)) = '776790' THEN 518
		ELSE ag.GGNr
	END AS ggnr
	,NULL, NULL, NULL, NULL
	,CASE 
		WHEN ap.LiefTerm IN ( '21', '22' ) THEN CONVERT(VARCHAR(8), CONVERT(DATETIME, ap.Neu, 104), 112)
		--ELSE CONVERT(VARCHAR(8), convert(DATETIME, stplan.stwert, 104), 112)
		ELSE CONVERT(VARCHAR(8), ap.AgreedChangeDate, 112)
	END AS PER_DATUM
	,CASE 
		WHEN ap.LiefTerm IN ( '21', '22' ) THEN CONVERT(VARCHAR(8), CONVERT(DATETIME, ap.Neu, 104), 112)
		--ELSE CONVERT(VARCHAR(8), convert(DATETIME, stplan.stwert, 104), 112)
		ELSE CONVERT(VARCHAR(8), ap.AgreedChangeDate, 112)
	END AS ZUG_DATUM
	,CONVERT(VARCHAR(8), ak.KuADatum, 112) AS DATUM
	,CASE 
		WHEN CAST((ag.Om - ag.Sm - ag.Em) * CONVERT(INT, tpste.stwert) AS INT) IS NULL THEN 0
		ELSE CAST((ag.Om - ag.Sm - ag.Em) * CONVERT(INT, tpste.stwert) AS INT) 
	END AS Qty_Original
	,CASE 
		WHEN ak.Art IN ('ES') THEN 0 -- 0 bei estimations
		WHEN CAST((ag.Om - ag.Sm - ag.Km - ag.Em) * CONVERT(INT, tpste.stwert) AS INT) IS NULL THEN 0
		ELSE CAST((ag.Om - ag.Sm - ag.Km - ag.Em) * CONVERT(INT, tpste.stwert) AS INT) 
	END AS offene_menge --offener rest
	,CASE 
		WHEN ak.Art IN ('ES') THEN 0 -- 0 bei estimations
		WHEN CAST(ag.Km  AS INT) IS NULL THEN 0
		ELSE CAST(ag.Km  AS INT) 
	END AS reservierte_menge --reservierter rest
	,SUBSTRING(LTRIM(RTRIM(ak.AufkKey)), 4, 2) + 2000 AS ZTYPO1 -- Year
	,CASE 
		WHEN SUBSTRING(LTRIM(RTRIM(ak.AufkKey)), 6, 1) = '1' THEN 'SS'
		WHEN SUBSTRING(LTRIM(RTRIM(ak.AufkKey)), 6, 1) = '2' THEN 'FW'
		ELSE 'undefined'
		END AS ZTYPO2 -- SS/FW
	,NULL
	,CASE 
		WHEN ak.Art IN ('12', '32', '42') THEN CAST(((ag.Om - ag.Sm - ag.Em) * convert(INT, tpste.stwert) * ap.EPrDM) AS DECIMAL(10, 2))
		ELSE CAST(((ag.Om - ag.Sm) * convert(INT, tpste.stwert) * ap.EPrDM) AS DECIMAL(10, 2)) 
	END AS WERT -- v_EUR_gross_original
FROM
	SPOT_SRC.dbo.SIXH_AUFKOPF ak
	JOIN SPOT_SRC.dbo.SIXH_AUFPOSI ap ON ak.AufkKey = ap.AufkKey AND ak.AufkNr = ap.AufkNr
	JOIN SPOT_SRC.dbo.SIXH_AUFGROESSE ag ON ap.AufkNr = ag.AufkNr AND ap.AufkKey = ag.AufkKey AND ap.OrderBlatt = ag.OrderBlatt AND ap.AufPNr = ag.AufPNr
	LEFT JOIN SPOT_SRC.dbo.SIXH_TPSTEU tpste ON ak.Art = tpste.tpwert AND ak.TapKey_Art = tpste.tapkey AND tpste.tanr = 41 AND tpste.lfd = 4
	--LEFT JOIN SPOT_SRC.dbo.SIXH_TPSTEU stplan ON ap.LiefTerm = stplan.tpwert AND ap.TapKey_LiefTerm = stplan.tapkey AND stplan.tanr = 30 AND stplan.lfd = 8
WHERE
	ak.AufkKey >= '011131H'
	AND ak.AufkKey LIKE ('011%')
	AND ak.AufkKey NOT LIKE ('0119%')
	AND ap.Lagerort IN ('800', 'TWN', 'KOR', 'JPN', 'HKG')
	AND ak.Art IN ( '01' ,'04' ,'06' ,'12' ,'14' ,'21' ,'22' ,'32', '41', '42', '98', '99', 'ES', '07', '17', '27')
	AND CAST((ag.Om - ag.Sm) as int) <> 0 -- KEINE STORNIERTEN POSITIONEN (häufig ohne Liefertermin)
	AND LTRIM(RTRIM(ak.KusNr)) NOT IN ( 99,990,991,992,993,994,995,996,997,998,999,9995,9996,9997,9998,9999 ) -- TEST Kunden INTEX
	--AND stplan.stwert IS NOT NULL
	AND ag.Om IS NOT NULL
	AND ak.AufkNr <> -1 -- exclude wrong order in Intex
	AND ag.GGNr <> 99 -- exclude articles with completely wrong sizes
	AND NOT EXISTS (SELECT * FROM ERR_AUFPOS WHERE AufkKey = ak.AufkKey AND AufkNr = ag.AufkNr AND AufPNr = ag.AufPNr AND Gr = ag.Gr)


/*
 * IN_OBESTELL = Purchase Orders
 */
INSERT INTO IN_OBESTELL (VTYPO1, VTYPO2, VTYPO3, ATYPO0, ATYPO1, ATYPO2, flag, ATYPO3, TECH_INDEX, gr, ggnr, ABLIEFERUNG, SATZART, LIEFERANT, BESTELLMENGE, BESTELLVORSCHLAG, INFO_AD01, bezInfo1, INFO_AD02, bezInfo2, INFO_AD03, bezInfo3, INFO_AD04, bezInfo4, INFO_AD05, bezInfo5, INFO_AD06, bezInfo6, INFO_ADTEXT, AUFTRAGS_NR, season, POS_NUMMER, BESTELL_WERT, BESTELL_VORSCHLAG)
SELECT DISTINCT
	'OI', NULL, NULL, NULL
	,LTRIM(RTRIM(pap.ArtsNr1))
	,LTRIM(RTRIM(pap.VerkFarbe))
	,'del'
	,NULL
	,NULL AS TECH_INDEX
	,CASE WHEN LTRIM(RTRIM(pag.Gr)) = '-' THEN 'One Size' ELSE LTRIM(RTRIM(pag.Gr)) END AS gr
	,CASE 
		WHEN pag.GGNr = 82 OR pag.GGNr = 83 OR pag.GGNr = 311 OR pag.GGNr = 323 THEN 501 -- Kids--Conf:80-176
		WHEN pag.GGNr = 406 THEN 503 -- Ladies--Conf:34-50
		WHEN pag.GGNr = 405 OR pag.GGNr = 407 THEN 502 -- Ladies--Conf short:17-25
		WHEN pag.GGNr = 14 THEN 513 -- Men--Conf:46-58
		WHEN pag.GGNr = 76 THEN 512 -- Men--Conf short:23-29
		WHEN pag.GGNr = 25 OR pag.GGNr = 308 OR pag.GGNr = 309 OR pag.GGNr = 322 THEN 511 -- Ladies - Sport: XXS-4XL
		WHEN pag.GGNr = 314 THEN 510 -- Ladies--Sport short:XS-XXL
		WHEN pag.GGNr = 327 THEN 509 -- Ladies--Sport long:XS-XXL
		WHEN pag.GGNr = 20 OR pag.GGNr = 24 OR pag.GGNr = 31 OR pag.GGNr = 41 THEN 516 -- Men--Sport:XXS-4XL
		WHEN pag.GGNr = 301 THEN 515 -- Men--Sport short:XS-XXL
		WHEN pag.GGNr = 328 THEN 514 -- Men--Sport long:XS-XXL
		WHEN pag.GGNr = 18 OR pag.GGNr = 97 OR pag.GGNr = 207 THEN 519 -- Unisex--Sport Acc:4XS-3XL
		WHEN pag.GGNr = 201 THEN 517 -- Unisex--One Size:---
		WHEN pag.GGNr = 202 OR pag.GGNr = 530 THEN 518 -- Unisex--Socks:36-38-45-47
		WHEN LTRIM(RTRIM(pap.ArtsNr1)) = '776790' THEN 518
		ELSE pag.GGNr
	END AS ggnr
	,CONVERT(VARCHAR(8), convert(DATETIME, pap.WTermin1, 104), 112) AS ABLIEFERUNG
	,'B' AS SATZART
	,RTRIM(pak.LiefNr) AS LIEFERANT
	,sum(pag.Ip - pag.Sm) AS BESTELLMENGE
	,sum(pag.Ip - pag.Sm) AS BESTELLVORSCHLAG
	,CASE WHEN LTRIM(RTRIM(pak.Art)) = '07' THEN 'PT96' ELSE 'PT'+LTRIM(RTRIM(pak.Art)) END AS INFO_AD01
	,LTRIM(RTRIM(tpa.zeile))
	,'ET'+LTRIM(RTRIM(pak.EinArt)) AS INFO_AD02
	,LTRIM(RTRIM(tae.zeile))
	,'DT'+LTRIM(RTRIM(pak.LiefBed)) AS INFO_AD03
	,LTRIM(RTRIM(tdt.zeile))
	,'SP'+LTRIM(RTRIM(pak.Versandart)) AS INFO_AD04
	,LTRIM(RTRIM(tsp.zeile))
	,'ST'+LTRIM(RTRIM(pst.Status)) AS INFO_AD05 -- PROBLEM
	,LTRIM(RTRIM(tst.zeile)) -- PROBLEM
	,'CR'+LTRIM(RTRIM(pap.Waehrung)) AS INFO_AD06
	,LTRIM(RTRIM(pap.Waehrung))
	,CASE WHEN RTRIM(pak.Bemerkung) = '' THEN NULL ELSE RTRIM(pak.Bemerkung) END AS INFO_ADTEXT
	,LTRIM(RTRIM(pap.PakNr))
	,RTRIM(pak.PakKey)
	,RTRIM(pap.PaPNr)
	,sum((pag.Ip - pag.Sm) * pap.EkFW) AS wert
	,NULL
FROM
	SPOT_SRC.dbo.SIXH_PAPOSI pap
	JOIN SPOT_SRC.dbo.SIXH_PAKOPF pak ON pak.PakNr = pap.PakNr AND pak.PakKey = pap.PakKey
	JOIN SPOT_SRC.dbo.SIXH_PAGROESSE pag ON pap.PakNr = pag.PakNr AND pap.PakKey = pag.PakKey AND pap.PaPNr = pag.PaPNr  
	LEFT JOIN ( -- one position may have several status entries => only select latest
		SELECT PakNr, PakKey, MAX(PAPNr) PAPNr, TapKey_Status, [Status]
		FROM SPOT_SRC.dbo.SIXH_PASTAT
		GROUP BY PakNr, PakKey, TapKey_Status, [Status]
	) pst ON pst.PakNr = pap.PakNr AND pst.PakKey = pap.PakKey AND pst.PaPNr = pap.PaPNr  
	LEFT JOIN SPOT_SRC.dbo.SIXH_TPTEXT tpa ON ( pak.TapKey_Art = tpa.tapkey AND pak.Art = tpa.tpwert AND tpa.tanr = 31 AND tpa.sprache = '01' AND tpa.lfd = 1  )
	LEFT JOIN SPOT_SRC.dbo.SIXH_TPTEXT tae ON ( pak.TapKey_EinArt=tae.tapkey AND pak.EinArt = tae.tpwert AND tae.tanr = 58 AND tae.sprache = '01' AND tae.lfd = 1 )
	LEFT JOIN SPOT_SRC.dbo.SIXH_TPTEXT tdt ON ( pak.TapKey_LiefBed= tdt.tapkey AND pak.LiefBed = tdt.tpwert AND tdt.tanr = 25 AND tdt.sprache = '01' AND tdt.lfd = 1 )
	LEFT JOIN SPOT_SRC.dbo.SIXH_TPTEXT tsp ON ( pak.TapKey_Versandart = tsp.tapkey AND pak.Versandart = tsp.tpwert AND tsp.tanr = 23 AND tsp.sprache = '01' AND tsp.lfd = 1 )
	LEFT JOIN SPOT_SRC.dbo.SIXH_TPTEXT tst ON ( tst.tapkey = pst.TapKey_Status AND tst.tpwert = pst.Status AND tst.tanr = 32 AND tst.sprache = '01' AND tst.lfd = 1 )
WHERE
	RTRIM(pak.PakKey) >= '011131H'
	AND RTRIM(pak.PakKey) LIKE ('011%') -- Firma: Odlo (01) // Vertriebsprogramm: Sportswear (1) [<> Didrikson!] // mz: 27.05.2016
	AND RTRIM(pak.Art) NOT IN ('07', '99') -- Do not include samples and dummy orders
	AND RTRIM(pak.LiefNr) <> '71304'
	AND pap.LagerOrt <> '025' -- Stock location for retail material
	AND RTRIM(pap.PakNr) <> '3600'
	AND pap.Ip - pap.Sm > '0'
	AND pag.Ip - pag.Sm > '0'
	AND pag.Pr = 0 -- nur offene bestellungen
GROUP BY 
	LTRIM(RTRIM(pap.PakNr))
	,RTRIM(pak.PakKey)
	,RTRIM(pap.PaPNr)
	,pag.Gr
	,pag.GGNr
	,LTRIM(RTRIM(pap.ArtsNr1))
	,LTRIM(RTRIM(pap.VerkFarbe))
	,RTRIM(pak.LiefNr)
	,CONVERT(VARCHAR(8), convert(DATETIME, pap.WTermin1, 104), 112)
	,pak.Art
	,tpa.zeile
	,RTRIM(pak.EinArt)
	,tae.zeile
	,RTRIM(pak.LiefBed)
	,tdt.zeile
	,RTRIM(pak.Versandart)
	,tsp.zeile
	,pst.Status
	,tst.zeile
	,RTRIM(pap.Waehrung)
	,pak.Bemerkung


	IF OBJECT_ID('ERR_AUFPOS') IS NOT NULL DROP TABLE ERR_AUFPOS; 
	
END
GO
