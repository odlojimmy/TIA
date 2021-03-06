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
/****** Object:  Table [dbo].[IN_LIEFERUNG]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_LIEFERUNG](
	[VTYPO1] [nvarchar](10) NOT NULL,
	[VTYPO2] [nvarchar](10) NULL,
	[VTYPO3] [nvarchar](10) NULL,
	[ATYPO0] [nvarchar](30) NULL,
	[ATYPO1] [nvarchar](30) NOT NULL,
	[ATYPO2] [nvarchar](30) NOT NULL,
	[ATYPO3] [nvarchar](30) NULL,
	[TECH_INDEX] [nvarchar](20) NOT NULL,
	[gr] [nvarchar](7) NULL,
	[ggnr] [int] NULL,
	[LIEFERDATUM] [nvarchar](8) NOT NULL,
	[LIEFERMENGE] [int] NOT NULL
) ON [PRIMARY]
GO
