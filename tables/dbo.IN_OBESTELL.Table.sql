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
/****** Object:  Table [dbo].[IN_OBESTELL]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_OBESTELL](
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
	[ABLIEFERUNG] [nvarchar](8) NOT NULL,
	[SATZART] [nvarchar](6) NOT NULL,
	[LIEFERANT] [nvarchar](30) NOT NULL,
	[BESTELLMENGE] [int] NOT NULL,
	[BESTELLVORSCHLAG] [int] NOT NULL,
	[INFO_AD01] [nvarchar](10) NULL,
	[bezInfo1] [nvarchar](90) NULL,
	[INFO_AD02] [nvarchar](10) NULL,
	[bezInfo2] [nvarchar](90) NULL,
	[INFO_AD03] [nvarchar](10) NULL,
	[bezInfo3] [nvarchar](90) NULL,
	[INFO_AD04] [nvarchar](10) NULL,
	[bezInfo4] [nvarchar](90) NULL,
	[INFO_AD05] [nvarchar](10) NULL,
	[bezInfo5] [nvarchar](90) NULL,
	[INFO_AD06] [nvarchar](10) NULL,
	[bezInfo6] [nvarchar](90) NULL,
	[INFO_ADTEXT] [nvarchar](250) NULL,
	[AUFTRAGS_NR] [nvarchar](30) NULL,
	[season] [nvarchar](7) NULL,
	[POS_NUMMER] [nvarchar](30) NULL,
	[BESTELL_WERT] [decimal](12, 2) NULL,
	[BESTELL_VORSCHLAG] [decimal](12, 2) NULL
) ON [PRIMARY]
GO
