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
/****** Object:  Table [dbo].[IN_ZVART]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_ZVART](
	[ZTYPO1] [nvarchar](4) NOT NULL,
	[ZTYPO2] [nvarchar](4) NOT NULL,
	[season] [nvarchar](7) NOT NULL,
	[ZTYPO3] [nvarchar](4) NULL,
	[VTYPO1] [nvarchar](10) NULL,
	[VTYPO2] [nvarchar](10) NULL,
	[VTYPO3] [nvarchar](10) NULL,
	[ATYPO0] [nvarchar](30) NULL,
	[ATYPO1] [nvarchar](30) NOT NULL,
	[ATYPO2] [nvarchar](30) NOT NULL,
	[flag] [nvarchar](3) NULL,
	[ATYPO3] [nvarchar](30) NULL,
	[KZ_DISPO] [nvarchar](1) NOT NULL,
	[KZ_PROGNOSE_ART] [nvarchar](1) NOT NULL,
	[KZ_ASTATUS] [nvarchar](1) NOT NULL,
	[KZ_RANGED_CMS] [nvarchar](1) NULL,
	[NO_PROZENT] [int] NULL,
	[ZVINFO1] [nvarchar](15) NULL,
	[ZVINFO2] [nvarchar](15) NULL,
	[ZVINFO3] [nvarchar](15) NULL,
	[ZVINFO4] [nvarchar](15) NULL,
	[ZVINFO5] [nvarchar](15) NULL,
	[ZVINFO6] [nvarchar](15) NULL,
	[ZVINFO7] [nvarchar](15) NULL,
	[ZVINFO8] [nvarchar](15) NULL,
	[ZVINFO9] [nvarchar](15) NULL,
 CONSTRAINT [PK_IN_ZVART] PRIMARY KEY CLUSTERED 
(
	[ZTYPO1] ASC,
	[ZTYPO2] ASC,
	[ATYPO1] ASC,
	[ATYPO2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
