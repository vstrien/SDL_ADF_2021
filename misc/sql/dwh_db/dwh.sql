DROP TABLE IF EXISTS [dm].[Dim_Customer];
DROP SCHEMA IF EXISTS [DM];
GO
CREATE SCHEMA [dm];
GO

CREATE TABLE [dm].[Dim_Customer](
	[ID_Dim_Customer] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,   
	[CustomerID]	[int] NOT NULL,   
	[NameStyle]		[bit]  NULL,
	[Title]			[nvarchar](8) NULL,
	[FullName]		[nvarchar](400)	NOT NULL,
	[FirstName]		[nvarchar](200) NOT NULL,
	[MiddleName]	[nvarchar](200) NULL,
	[LastName]		[nvarchar](200) NOT NULL,
	[Suffix]		[nvarchar](10) NULL,
	[CompanyName]	[nvarchar](128) NULL,
	[SalesPerson]	[nvarchar](256) NULL,
	[EmailAddress]	[nvarchar](50) NULL,
	[Phone]			[nvarchar](100) NULL
);
go
SET IDENTITY_INSERT [dm].[Dim_Customer] ON 