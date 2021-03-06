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
/****** Object:  Table [dbo].[IN_GRTEXTE]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_GRTEXTE](
	[GR_GANG] [nvarchar](15) NOT NULL,
	[TECH_INDEX] [nvarchar](20) NOT NULL,
	[TECH_BEZ] [nvarchar](20) NOT NULL,
	[aktiv] [char](1) NULL,
 CONSTRAINT [PK_IN_GRTEXTE] PRIMARY KEY CLUSTERED 
(
	[GR_GANG] ASC,
	[TECH_INDEX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
