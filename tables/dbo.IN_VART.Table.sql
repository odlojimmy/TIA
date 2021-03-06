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
/****** Object:  Table [dbo].[IN_VART]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_VART](
	[VTYPO1] [nvarchar](10) NOT NULL,
	[VTYPO2] [nvarchar](10) NULL,
	[VTYPO3] [nvarchar](10) NULL,
	[ATYPO0] [nvarchar](30) NULL,
	[ATYPO1] [nvarchar](30) NOT NULL,
	[ATYPO2] [nvarchar](30) NOT NULL,
	[flag] [nvarchar](3) NULL,
	[ATYPO3] [nvarchar](30) NULL,
	[ERST_ANGEBOTSTERMIN] [nvarchar](8) NULL,
	[ERSTLIEFER_TERMIN] [nvarchar](8) NULL,
	[AKTUELLIEFER_TERMIN] [nvarchar](8) NULL,
	[AUSLAUF_TERMIN] [nvarchar](8) NULL,
	[REFAR_VTYPO1] [nvarchar](10) NULL,
	[REFAR_VTYPO2] [nvarchar](10) NULL,
	[REFAR_VTYPO3] [nvarchar](10) NULL,
	[REFAR_ATYPO0] [nvarchar](30) NULL,
	[REFAR_ATYPO1] [nvarchar](30) NULL,
	[REFAR_ATYPO2] [nvarchar](30) NULL,
	[REFAR_ATYPO3] [nvarchar](30) NULL,
	[AE_PROZENT] [int] NULL,
	[KZ_ABC] [nvarchar](2) NULL,
	[KZ_AD_DISPO] [nvarchar](1) NOT NULL,
	[FILLER1] [nvarchar](20) NULL,
	[FILLER2] [nvarchar](20) NULL,
	[PREIS1] [decimal](10, 2) NULL,
	[PREIS2] [decimal](10, 2) NULL,
	[PREIS3] [decimal](10, 2) NULL,
	[KZ_DISPONENT] [nvarchar](8) NULL,
	[KZ_PLANER] [nvarchar](8) NULL,
	[GRGANG] [nvarchar](15) NULL,
	[KZ_PSEUDO] [nvarchar](1) NULL,
	[K_EINKAUFER] [nvarchar](15) NULL,
	[MINDEST_BESTELL_MENGE] [int] NULL,
	[MIN_BESTELL_MENGE_MODEL] [int] NULL,
 CONSTRAINT [PK_IN_VART] PRIMARY KEY CLUSTERED 
(
	[ATYPO1] ASC,
	[ATYPO2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
