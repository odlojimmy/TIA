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
/****** Object:  Table [dbo].[IN_ARTIKEL]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_ARTIKEL](
	[ATYPO0] [nvarchar](30) NULL,
	[ATYPO1] [nvarchar](30) NOT NULL,
	[ATYPO2] [nvarchar](30) NOT NULL,
	[ATYPO3] [nvarchar](30) NULL,
	[TYPO1] [nvarchar](10) NOT NULL,
	[bezTypo01] [nvarchar](30) NULL,
	[TYPO2] [nvarchar](10) NULL,
	[bezTypo02] [nvarchar](30) NULL,
	[TYPO3] [nvarchar](10) NULL,
	[bezTypo03] [nvarchar](30) NULL,
	[TYPO4] [nvarchar](10) NULL,
	[bezTypo04] [nvarchar](30) NULL,
	[TYPO5] [nvarchar](10) NULL,
	[bezTypo05] [nvarchar](30) NULL,
	[TYPO6] [nvarchar](10) NULL,
	[bezTypo06] [nvarchar](30) NULL,
	[TYPO7] [nvarchar](10) NULL,
	[bezTypo07] [nvarchar](30) NULL,
	[TYPO8] [nvarchar](10) NULL,
	[bezTypo08] [nvarchar](30) NULL,
	[TYPO9] [nvarchar](10) NULL,
	[bezTypo09] [nvarchar](30) NULL,
	[ATYPO_BEZEICHNUNG1] [nvarchar](30) NOT NULL,
	[ATYPO_BEZEICHNUNG2] [nvarchar](30) NULL,
	[ATYPO_BEZEICHNUNG3] [nvarchar](30) NULL,
	[MODELL_BEZEICHNUNG1] [nvarchar](30) NOT NULL,
	[MODELL_BEZEICHNUNG2] [nvarchar](30) NULL,
	[MODELL_BEZEICHNUNG3] [nvarchar](30) NULL,
	[NACHFOLGER_ATYPO0] [nvarchar](30) NULL,
	[NACHFOLGER_ATYPO1] [nvarchar](30) NULL,
	[NACHFOLGER_ATYPO2] [nvarchar](30) NULL,
	[NACHFOLGER_ATYPO3] [nvarchar](30) NULL,
	[INFO1] [nvarchar](15) NULL,
	[bezInfo1] [nvarchar](90) NULL,
	[INFO2] [nvarchar](15) NULL,
	[bezInfo2] [nvarchar](90) NULL,
	[INFO3] [nvarchar](15) NULL,
	[bezInfo3] [nvarchar](90) NULL,
	[INFO4] [nvarchar](15) NULL,
	[bezInfo4] [nvarchar](90) NULL,
	[INFO5] [nvarchar](15) NULL,
	[bezInfo5] [nvarchar](90) NULL,
	[INFO6] [nvarchar](15) NULL,
	[bezInfo6] [nvarchar](90) NULL,
	[INFO7] [nvarchar](15) NULL,
	[bezInfo7] [nvarchar](90) NULL,
	[INFO8] [nvarchar](15) NULL,
	[bezInfo8] [nvarchar](90) NULL,
	[INFO9] [nvarchar](15) NULL,
	[bezInfo9] [nvarchar](90) NULL,
	[ARTIKELART] [nvarchar](1) NULL,
	[MODELL_NR] [nvarchar](20) NULL,
	[STAT_EINHEIT] [decimal](10, 4) NOT NULL,
	[VERKAUFS_EINHEIT] [nvarchar](30) NULL,
	[VERKAUFS_MENGE] [decimal](10, 3) NULL,
	[VOLUMEN] [decimal](10, 3) NULL,
 CONSTRAINT [PK_IN_ARTIKEL_1] PRIMARY KEY CLUSTERED 
(
	[ATYPO1] ASC,
	[ATYPO2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
