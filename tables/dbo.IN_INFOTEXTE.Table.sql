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
/****** Object:  Table [dbo].[IN_INFOTEXTE]    Script Date: 04.09.2017 17:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IN_INFOTEXTE](
	[PT_NUMMER] [nvarchar](6) NOT NULL,
	[KURZBEZ] [nvarchar](30) NOT NULL,
	[LAENDERCODE] [nvarchar](3) NOT NULL,
	[BEZEICHNUNG] [nvarchar](90) NOT NULL
) ON [PRIMARY]
GO
