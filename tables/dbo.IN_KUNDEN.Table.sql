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
/****** Object:  Table [dbo].[IN_KUNDEN]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_KUNDEN](
	[KD_NUMMER] [nvarchar](15) NOT NULL,
	[KD_NAME] [nvarchar](30) NOT NULL,
	[activeYN] [nvarchar](1) NULL,
	[KD_LAND] [nvarchar](3) NOT NULL,
	[STRASSE] [nvarchar](40) NULL,
	[PLZ] [nvarchar](10) NULL,
	[ORT] [nvarchar](30) NULL,
	[KD_TYP] [nvarchar](2) NOT NULL,
	[VERTRETERKENNUNG] [nvarchar](8) NOT NULL,
	[VERTRETERNAME] [nvarchar](30) NOT NULL,
	[VERTRETERGEBIET] [nvarchar](30) NOT NULL,
	[KUNDENTYPO1] [nvarchar](30) NOT NULL,
	[KUNDENTYPO2] [nvarchar](30) NULL,
	[infor_channel_key] [nvarchar](30) NULL,
	[KUNDENTYPO3] [nvarchar](30) NULL,
	[KEYACCOUNTMANAGER] [nvarchar](10) NOT NULL,
	[ic_code] [nvarchar](30) NULL
) ON [PRIMARY]
GO
