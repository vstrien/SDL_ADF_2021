# Doel
Doel van de opdracht is om met een simple data flow een dimentie table Customer te maken.

# Opdracht

Create een table in database dwh
``` sql 
CREATE TABLE [dm].[Dim_Customer](
	[ID_Dim_Customer] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[NameStyle] [bit] NULL,
	[Title] [nvarchar](8) NULL,
	[FullName] [nvarchar](400) NULL,
	[FirstName] [nvarchar](200) NOT NULL,
	[MiddleName] [nvarchar](200) NULL,
	[LastName] [nvarchar](200) NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[CompanyName] [nvarchar](128) NULL,
	[SalesPerson] [nvarchar](256) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[Phone] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Dim_Customer] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
```

1. voeg een sourc opject toe en haal de op het stg table stg.saleslt_customer
2. voeg een select de volgende columns.
    - ID_Dim_Customer
    - CustomerID
    - NameStyle
    - Title
    - FullName
    - FirstName
    - MiddleName
    - LastName
    - Suffix
    - CompanyName
    - SalesPerson
    - EmailAddress
    - Phone
3. voeg een derivedColumen toe.
    Maak daan een extra column ```FullName``` en maak deze op basis van een concatienatie van FirstName MiddleName LastName
4. Voer een Sink toe aan het canvas
    Vul de table [dm].[Dim_Customer] in de database dwh