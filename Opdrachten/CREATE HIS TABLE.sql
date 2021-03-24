/****** Object:  Table [stg].[SalesLT_Customer]    Script Date: 16-03-21 08:28:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE TABLE [his].[SalesLT_Customer](
	[CustomerID] [int] NULL,
	[NameStyle] [bit] NULL,
	[Title] [nvarchar](max) NULL,
	[FirstName] [nvarchar](max) NULL,
	[MiddleName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[Suffix] [nvarchar](max) NULL,
	[CompanyName] [nvarchar](max) NULL,
	[SalesPerson] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[PasswordSalt] [nvarchar](max) NULL,
	[rowguid] [nvarchar](max) NULL,
	[ModifiedDate] [datetime2](7) NULL,
	[Hash_Key] [nvarchar](100) NOT NULL
) 
GO


