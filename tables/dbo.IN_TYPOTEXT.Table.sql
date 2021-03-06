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
/****** Object:  Table [dbo].[IN_TYPOTEXT]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_TYPOTEXT](
	[VTYPO1] [nvarchar](10) NULL,
	[VTYPO2] [nvarchar](10) NULL,
	[VTYPO3] [nvarchar](10) NULL,
	[GTYPO1] [nvarchar](10) NULL,
	[GTYPO2] [nvarchar](10) NULL,
	[GTYPO3] [nvarchar](10) NULL,
	[GTYPO4] [nvarchar](10) NULL,
	[GTYPO5] [nvarchar](10) NULL,
	[GTYPO6] [nvarchar](10) NULL,
	[GTYPO7] [nvarchar](10) NULL,
	[GTYPO8] [nvarchar](10) NULL,
	[GTYPO9] [nvarchar](10) NULL,
	[BEZEICHNUNG] [nvarchar](30) NOT NULL,
	[SPRACHE] [nvarchar](1) NOT NULL
) ON [PRIMARY]
GO
