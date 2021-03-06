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
/****** Object:  Table [dbo].[IN_LIEFVARTGR]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_LIEFVARTGR](
	[LIEFNR] [nvarchar](30) NOT NULL,
	[lfd] [int] NULL,
	[PRIO] [nvarchar](1) NOT NULL,
	[min_article] [int] NULL,
	[min_article_colour] [int] NULL,
	[ATYPO0] [nvarchar](30) NULL,
	[ATYPO1] [nvarchar](30) NOT NULL,
	[ATYPO2] [nvarchar](30) NOT NULL,
	[flag] [nvarchar](3) NULL,
	[ATYPO3] [nvarchar](30) NULL,
	[TECH_INDEX] [nvarchar](30) NULL,
	[gr] [nvarchar](8) NOT NULL,
	[ggnr] [int] NOT NULL,
	[VTYPO1] [nvarchar](10) NULL,
	[VTYPO2] [nvarchar](10) NULL,
	[VTYPO3] [nvarchar](10) NULL,
	[TYP] [nvarchar](2) NOT NULL,
	[EINSTANDS_PREIS] [decimal](10, 2) NOT NULL,
	[BEST_EINHEIT] [nvarchar](10) NULL,
	[WBM_MAN] [int] NULL,
	[KZ_OPT] [nvarchar](1) NULL,
	[OPT_ERHOEH_MENGE] [int] NULL,
	[WBM_LANG] [int] NOT NULL,
	[WBM_KURZ] [int] NOT NULL,
	[ARTIKEL_NUMMMER] [nvarchar](40) NULL,
	[ARTIKEL_BEZ] [nvarchar](60) NULL,
	[INFO01] [nvarchar](35) NULL,
	[INFO02] [nvarchar](35) NULL,
	[INFO03] [nvarchar](35) NULL,
	[INFO04] [nvarchar](35) NULL,
	[INFO05] [nvarchar](35) NULL,
	[STATUS] [int] NULL,
	[SPLITKRITERIUM] [nvarchar](20) NULL,
	[BEST_FREQUENZ] [nvarchar](2) NULL,
	[ODL_1] [nvarchar](8) NULL,
	[ODL_2] [nvarchar](8) NULL,
	[ODL_3] [nvarchar](8) NULL,
 CONSTRAINT [PK_IN_LIEFVARTGR] PRIMARY KEY CLUSTERED 
(
	[LIEFNR] ASC,
	[ATYPO1] ASC,
	[ATYPO2] ASC,
	[gr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
