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
/****** Object:  StoredProcedure [dbo].[SP_TIA_00_INDEX_CREATE]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_TIA_00_INDEX_CREATE]
AS
BEGIN
SET NOCOUNT ON;

-- Create primary keys and indexes

IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='PK_SIXH_AUFKOPF') IS NULL			ALTER TABLE SPOT_SRC.dbo.SIXH_AUFKOPF ADD CONSTRAINT PK_SIXH_AUFKOPF PRIMARY KEY NONCLUSTERED (AufkNr, AufkKey);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_AUFKOPF_Art') IS NULL		CREATE INDEX IX_SIXH_AUFKOPF_Art ON SPOT_SRC.dbo.SIXH_AUFKOPF (Art);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_AUFKOPF_KusNr') IS NULL		CREATE INDEX IX_SIXH_AUFKOPF_KusNr ON SPOT_SRC.dbo.SIXH_AUFKOPF (KusNr);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_AUFKOPF_TapKey_Art') IS NULL CREATE INDEX IX_SIXH_AUFKOPF_TapKey_Art ON SPOT_SRC.dbo.SIXH_AUFKOPF (TapKey_Art);

IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='PK_SIXH_AUFPOSI') IS NULL					ALTER TABLE SPOT_SRC.dbo.SIXH_AUFPOSI ADD CONSTRAINT PK_SIXH_AUFPOSI PRIMARY KEY NONCLUSTERED (AufkNr, AufkKey, OrderBlatt, AufPNr);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_AUFPOSI_Lagerort') IS NULL			CREATE INDEX IX_SIXH_AUFPOSI_Lagerort ON SPOT_SRC.dbo.SIXH_AUFPOSI (Lagerort);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_AUFPOSI_LiefTerm') IS NULL			CREATE INDEX IX_SIXH_AUFPOSI_LiefTerm ON SPOT_SRC.dbo.SIXH_AUFPOSI (LiefTerm);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_AUFPOSI_TapKey_LiefTerm') IS NULL	CREATE INDEX IX_SIXH_AUFPOSI_TapKey_LiefTerm ON SPOT_SRC.dbo.SIXH_AUFPOSI (TapKey_LiefTerm);

IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='PK_SIXH_AUFGROESSE') IS NULL		ALTER TABLE SPOT_SRC.dbo.SIXH_AUFGROESSE ADD CONSTRAINT PK_SIXH_AUFGROESSE PRIMARY KEY NONCLUSTERED (AufkNr, AufkKey, OrderBlatt, AufPNr, GGanKey, GGNr, Gr);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_AUFGROESSE_Om') IS NULL		CREATE INDEX IX_SIXH_AUFGROESSE_Om ON SPOT_SRC.dbo.SIXH_AUFGROESSE (Om);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_AUFGROESSE_Sm') IS NULL		CREATE INDEX IX_SIXH_AUFGROESSE_Sm ON SPOT_SRC.dbo.SIXH_AUFGROESSE (Sm);

IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='PK_SIXH_PAKOPF') IS NULL			ALTER TABLE SPOT_SRC.dbo.SIXH_PAKOPF ADD CONSTRAINT PK_SIXH_PAKOPF PRIMARY KEY NONCLUSTERED (PakNr, PakKey);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='PK_SIXH_PAPOSI') IS NULL			ALTER TABLE SPOT_SRC.dbo.SIXH_PAPOSI ADD CONSTRAINT PK_SIXH_PAPOSI PRIMARY KEY NONCLUSTERED (PakNr, PakKey, PaPNr);
--IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='PK_SIXH_PAGROESSE') IS NULL		ALTER TABLE SPOT_SRC.dbo.SIXH_PAGROESSE ADD CONSTRAINT PK_SIXH_PAGROESSE PRIMARY KEY NONCLUSTERED (PakNr, PakKey, PaPNr, GGanKey, GGNr, Gr);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='PK_SIXH_PASTAT') IS NULL			ALTER TABLE SPOT_SRC.dbo.SIXH_PASTAT ADD CONSTRAINT PK_SIXH_PASTAT PRIMARY KEY NONCLUSTERED (PakNr, PakKey, PaPNr, Lfd);

IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='PK_SIXH_FELAGER') IS NULL		ALTER TABLE SPOT_SRC.dbo.SIXH_FELAGER ADD CONSTRAINT PK_SIXH_FELAGER PRIMARY KEY NONCLUSTERED (LagKey, ArtsNr1, ArtsNr2, ArtsKey, VerkFarbe, Etikett, Aufmachung, GGanKey, GGNr, Gr, LagerOrt, LagerFach);

IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPSTEU_lfd') IS NULL		CREATE INDEX IX_SIXH_TPSTEU_lfd ON SPOT_SRC.dbo.SIXH_TPSTEU (lfd);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPSTEU_stwert') IS NULL	CREATE INDEX IX_SIXH_TPSTEU_stwert ON SPOT_SRC.dbo.SIXH_TPSTEU (stwert);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPSTEU_tanr') IS NULL	CREATE INDEX IX_SIXH_TPSTEU_tanr ON SPOT_SRC.dbo.SIXH_TPSTEU (tanr);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPSTEU_tapkey') IS NULL	CREATE INDEX IX_SIXH_TPSTEU_tapkey ON SPOT_SRC.dbo.SIXH_TPSTEU (tapkey);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPSTEU_tpwert') IS NULL	CREATE INDEX IX_SIXH_TPSTEU_tpwert ON SPOT_SRC.dbo.SIXH_TPSTEU (tpwert);

IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPTEXT_lfd') IS NULL		CREATE INDEX IX_SIXH_TPTEXT_lfd ON SPOT_SRC.dbo.SIXH_TPTEXT (lfd);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPTEXT_sprache') IS NULL CREATE INDEX IX_SIXH_TPTEXT_sprache ON SPOT_SRC.dbo.SIXH_TPTEXT (sprache);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPTEXT_tanr') IS NULL	CREATE INDEX IX_SIXH_TPTEXT_tanr ON SPOT_SRC.dbo.SIXH_TPTEXT (tanr);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPTEXT_tapkey') IS NULL	CREATE INDEX IX_SIXH_TPTEXT_tapkey ON SPOT_SRC.dbo.SIXH_TPTEXT (tapkey);
IF (SELECT object_id FROM SPOT_SRC.sys.indexes WHERE name='IX_SIXH_TPTEXT_tpwert') IS NULL	CREATE INDEX IX_SIXH_TPTEXT_tpwert ON SPOT_SRC.dbo.SIXH_TPTEXT (tpwert);



END
GO
