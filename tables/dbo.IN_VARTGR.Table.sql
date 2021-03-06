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
/****** Object:  Table [dbo].[IN_VARTGR]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_VARTGR](
	[VTYPO1] [nvarchar](10) NOT NULL,
	[VTYPO2] [nvarchar](10) NULL,
	[VTYPO3] [nvarchar](10) NULL,
	[ATYPO0] [nvarchar](30) NULL,
	[ATYPO1] [nvarchar](30) NOT NULL,
	[ATYPO2] [nvarchar](30) NOT NULL,
	[flag] [nvarchar](3) NULL,
	[ATYPO3] [nvarchar](30) NULL,
	[TECH_INDEX] [nvarchar](20) NULL,
	[gr] [nvarchar](8) NOT NULL,
	[ggnr] [int] NOT NULL,
	[START_TERMIN_GR] [nvarchar](8) NULL,
	[AUSLAUF_TERMIN_GR] [nvarchar](8) NULL,
	[GR_STATUS] [nvarchar](1) NOT NULL,
	[GRSL_MAN] [decimal](8, 2) NULL,
	[LB_FREI] [int] NOT NULL,
	[RESERVIERUNGEN] [int] NULL,
	[RUECKSTAND] [int] NULL,
	[MINDESTBESTAND] [int] NULL,
	[MAXIMALBESTAND] [int] NULL,
	[FILLER1] [int] NULL,
	[FILLER2] [nvarchar](1) NULL,
	[FILLER3] [int] NULL,
	[ZIEL_RW] [int] NOT NULL,
	[WBZ] [int] NOT NULL,
	[DF_FAKTOR_MAN] [decimal](8, 2) NULL,
	[INFO1] [nvarchar](35) NULL,
	[INFO2] [nvarchar](35) NULL,
	[INFO3] [nvarchar](35) NULL,
	[INFO4] [nvarchar](35) NULL,
	[INFO5] [nvarchar](35) NULL,
	[SPERR_BESTAND] [decimal](10, 2) NULL,
	[ABGEBENDE_NL] [nvarchar](30) NULL,
	[GEWICHT] [decimal](10, 4) NULL,
	[VOLUMEN] [decimal](10, 3) NULL,
 CONSTRAINT [PK_IN_VARTGR] PRIMARY KEY CLUSTERED 
(
	[ATYPO1] ASC,
	[ATYPO2] ASC,
	[gr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
