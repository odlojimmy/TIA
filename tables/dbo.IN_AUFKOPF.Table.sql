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
/****** Object:  Table [dbo].[IN_AUFKOPF]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_AUFKOPF](
	[AUFTRAGS_NR] [nvarchar](15) NOT NULL,
	[KD_NUMMER] [nvarchar](15) NOT NULL,
	[AUFTRAGS_ART] [nvarchar](8) NOT NULL,
	[KZ_NO] [nvarchar](1) NULL,
	[VTYPO1] [nvarchar](10) NOT NULL,
	[bezVtypo01] [nvarchar](30) NULL,
	[VTYPO2] [nvarchar](10) NULL,
	[bezVtypo02] [nvarchar](30) NULL,
	[VTYPO3] [nvarchar](10) NULL,
	[bezVtypo03] [nvarchar](30) NULL,
	[IM_DATUM] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_IN_AUFKOPF] PRIMARY KEY CLUSTERED 
(
	[AUFTRAGS_NR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
