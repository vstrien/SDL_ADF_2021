SELECT p.[ProductID],
    p.[Name],
    p.[ProductNumber],
    p.[Color],
    p.[StandardCost],
    p.[ListPrice],
    p.[Size],
    p.[Weight],
    pm.[Name] as ProductModelName,
    pc.[Name] as [ProductSubCategory],
    pch.[name] as [ProductCategory]
FROM [SalesLT].[Product] p
    inner join [SalesLT].[ProductModel] pm on pm.[ProductModelID] = p.[ProductModelID]
    inner join [SalesLT].[ProductCategory] pc on pc.ProductCategoryID = p.[ProductCategoryID]
    inner join [SalesLT].[ProductCategory] pch on pch.ProductCategoryID = pc.[ParentProductCategoryID]