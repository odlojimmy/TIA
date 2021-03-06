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
/****** Object:  Table [dbo].[IN_LIEFERANT]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_LIEFERANT](
	[LIEFNR] [nvarchar](30) NOT NULL,
	[LIEFNAME1] [nvarchar](40) NOT NULL,
	[LIEFNAME2] [nvarchar](40) NULL,
	[LIEFTYP] [nvarchar](1) NOT NULL,
	[VTYPO1] [nvarchar](10) NULL,
	[VTYPO2] [nvarchar](10) NULL,
	[VTYPO3] [nvarchar](10) NULL,
	[ANSPRECHPARTNER] [nvarchar](40) NULL,
	[LANDKZ] [nvarchar](10) NULL,
	[ZIP] [nvarchar](10) NULL,
	[ORT] [nvarchar](40) NULL,
	[STRASSE] [nvarchar](40) NULL,
	[EMAIL] [nvarchar](40) NULL,
	[BESTELLTAG] [nvarchar](1) NULL,
	[ANLIEFERTAG] [nvarchar](1) NULL,
	[MINDESTBESTELL_MENGE] [decimal](10, 2) NULL,
	[MINDESTBESTELL_EINHEIT] [nvarchar](20) NULL,
	[REFERENZ_NR] [nvarchar](20) NULL,
	[STATUS] [int] NULL,
 CONSTRAINT [PK_IN_LIEFERANT] PRIMARY KEY CLUSTERED 
(
	[LIEFNR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
