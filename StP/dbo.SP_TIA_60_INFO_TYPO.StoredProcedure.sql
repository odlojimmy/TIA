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
/****** Object:  StoredProcedure [dbo].[SP_TIA_60_INFO_TYPO]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_TIA_60_INFO_TYPO]
AS
BEGIN

	SET NOCOUNT ON;
	
	TRUNCATE TABLE IN_TYPOTEXT
	TRUNCATE TABLE IN_INFOTEXTE


	/* VTYPO1 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT VTYPO1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, bezVtypo01, 'E'
	FROM IN_AUFKOPF
	
	/* TYPO9 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, TYPO2, TYPO3, TYPO4, TYPO5, TYPO6, TYPO7, TYPO8, TYPO9, bezTypo09, 'E'
	FROM IN_ARTIKEL
	
	/* TYPO8 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, TYPO2, TYPO3, TYPO4, TYPO5, TYPO6, TYPO7, TYPO8, '', bezTypo08, 'E'
	FROM IN_ARTIKEL

	/* TYPO7 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, TYPO2, TYPO3, TYPO4, TYPO5, TYPO6, TYPO7, '', '', bezTypo07, 'E'
	FROM IN_ARTIKEL

	/* TYPO6 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, TYPO2, TYPO3, TYPO4, TYPO5, TYPO6, '', '', '', bezTypo06, 'E'
	FROM IN_ARTIKEL

	/* TYPO5 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, TYPO2, TYPO3, TYPO4, TYPO5, '', '', '', '', bezTypo05, 'E'
	FROM IN_ARTIKEL where bezTypo05 IS NULL

	/* TYPO4 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, TYPO2, TYPO3, TYPO4, '', '', '', '', '', bezTypo04, 'E'
	FROM IN_ARTIKEL

	/* TYPO3 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, TYPO2, TYPO3, '', '', '', '', '', '', bezTypo03, 'E'
	FROM IN_ARTIKEL

	/* TYPO2 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, TYPO2, '', '', '', '', '', '', '', bezTypo02, 'E'
	FROM IN_ARTIKEL

	/* TYPO1 */
	INSERT INTO IN_TYPOTEXT (VTYPO1, VTYPO2, VTYPO3, GTYPO1, GTYPO2, GTYPO3, GTYPO4, GTYPO5, GTYPO6, GTYPO7, GTYPO8, GTYPO9, BEZEICHNUNG, SPRACHE)
	SELECT DISTINCT NULL, NULL, NULL, TYPO1, '', '', '', '', '', '', '', '', bezTypo01, 'E'
	FROM IN_ARTIKEL


	/* UPDATE IN_INFOTEXTE from IN_ARTIKEL */
	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0001', INFO1, 'E', bezInfo1
	FROM IN_ARTIKEL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0002', INFO2, 'E', bezInfo2
	FROM IN_ARTIKEL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0003', INFO3, 'E', bezInfo3
	FROM IN_ARTIKEL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0004', INFO4, 'E', bezInfo4
	FROM IN_ARTIKEL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0005', INFO5, 'E', bezInfo5
	FROM IN_ARTIKEL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0006', INFO6, 'E', bezInfo6
	FROM IN_ARTIKEL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0007', INFO7, 'E', bezInfo7
	FROM IN_ARTIKEL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0008', INFO8, 'E', bezInfo8
	FROM IN_ARTIKEL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0009', INFO9, 'E', bezInfo9
	FROM IN_ARTIKEL


	/* UPDATE IN_INFOTEXTE from IN_OBESTELL */
	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0040', INFO_AD01, 'E', bezInfo1
	FROM IN_OBESTELL
	
	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0041', INFO_AD02, 'E', bezInfo2
	FROM IN_OBESTELL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0042', INFO_AD03, 'E', bezInfo3
	FROM IN_OBESTELL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0043', INFO_AD04, 'E', bezInfo4
	FROM IN_OBESTELL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0044', INFO_AD05, 'E', bezInfo5
	FROM IN_OBESTELL
	WHERE INFO_AD05 IS NOT NULL

	INSERT INTO IN_INFOTEXTE (PT_NUMMER, KURZBEZ, LAENDERCODE, BEZEICHNUNG)
	SELECT DISTINCT 'PT0045', INFO_AD06, 'E', bezInfo6
	FROM IN_OBESTELL

END

GO
