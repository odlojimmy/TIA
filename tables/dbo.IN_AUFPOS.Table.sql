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
/****** Object:  Table [dbo].[IN_AUFPOS]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_AUFPOS](
	[AUFTRAGS_NR] [nvarchar](15) NOT NULL,
	[bezugAufkNr] [int] NULL,
	[bezugKdNr] [nvarchar](15) NULL,
	[art] [nvarchar](8) NULL,
	[aufkkey] [char](7) NULL,
	[POSITIONS_NR] [nvarchar](15) NOT NULL,
	[EINTEIL_NR] [nvarchar](15) NOT NULL,
	[AENDERUNGS_NR] [nvarchar](15) NULL,
	[ATYPO0] [nvarchar](30) NULL,
	[ATYPO1] [nvarchar](30) NOT NULL,
	[ATYPO2] [nvarchar](30) NULL,
	[ATYPO3] [nvarchar](30) NULL,
	[TECH_INDEX] [nvarchar](20) NULL,
	[gr] [nvarchar](8) NOT NULL,
	[ggnr] [int] NOT NULL,
	[KZ_FILTER1] [nvarchar](2) NULL,
	[KZ_FILTER2] [nvarchar](2) NULL,
	[KZ_FILTER3] [nvarchar](2) NULL,
	[STORNO_GRUND] [nvarchar](2) NULL,
	[PER_DATUM] [nvarchar](8) NOT NULL,
	[ZUG_DATUM] [nvarchar](8) NOT NULL,
	[DATUM] [nvarchar](8) NOT NULL,
	[MENGE] [int] NOT NULL,
	[offene_menge] [int] NOT NULL,
	[reservierte_menge] [int] NOT NULL,
	[ZTYPO1] [nvarchar](4) NOT NULL,
	[ZTYPO2] [nvarchar](4) NULL,
	[ZTYPO3] [nvarchar](4) NULL,
	[WERT] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_IN_AUFPOS] PRIMARY KEY CLUSTERED 
(
	[AUFTRAGS_NR] ASC,
	[POSITIONS_NR] ASC,
	[EINTEIL_NR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
