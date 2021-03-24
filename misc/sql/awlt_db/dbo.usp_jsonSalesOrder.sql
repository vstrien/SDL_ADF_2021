/****** Object:  StoredProcedure [dbo].[usp_jsonSalesOrder]    Script Date: 13-03-21 16:09:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Paul Pronk
-- Create Date: 2021-03-13
-- Description: Convert Relationals SalesOrder data to Json Hiarchie format 
-- =============================================
CREATE PROCEDURE [dbo].[usp_jsonSalesOrder] AS

BEGIN
    SET NOCOUNT ON

	SELECT 
		soh.[SalesOrderID]				AS 'Order.SalesOrderID'
	,	soh.[RevisionNumber]			AS 'Order.RevisionNumber'
	,	soh.[OrderDate]					AS 'Order.OrderDate'
	,	soh.[DueDate]					AS 'Order.DueDate'
	,	soh.[ShipDate]					AS 'Order.ShipDate'
	,	soh.[Status]					AS 'Order.Status'
	,	soh.[OnlineOrderFlag]			AS 'Order.OnlineOrderFlag'
	,	soh.[SalesOrderNumber]			AS 'Order.SalesOrderNumber'
	,	soh.[PurchaseOrderNumber]		AS 'Order.PurchaseOrderNumber'
	,	soh.[AccountNumber]				AS 'Order.AccountNumber'
	,	soh.[CustomerID]				AS 'Order.CustomerID'
	,	soh.[ShipToAddressID]			AS 'Order.ShipToAddressID'
	,	soh.[BillToAddressID]			AS 'Order.BillToAddressID'
	,	soh.[ShipMethod]				AS 'Order.ShipMethod'
	,	soh.[CreditCardApprovalCode]	AS 'Order.CreditCardApprovalCode'
	,	soh.[SubTotal]					AS 'Order.SubTotal'
	,	soh.[TaxAmt]					AS 'Order.TaxAmt'
	,	soh.[Freight]					AS 'Order.Freight'
	,	soh.[TotalDue]					AS 'Order.TotalDue'
	,	soh.[Comment]					AS 'Order.Comment'
	,	soh.[rowguid]					AS 'Order.rowguid'
	,	soh.[ModifiedDate]				AS 'Order.ModifiedDate'
	,	(
	SELECT 
	--	sod.[SalesOrderDetailID]
		sod.[OrderQty]			
	,	sod.[ProductID]			
	,	sod.[UnitPrice]			
	,	sod.[UnitPriceDiscount]	
	,	sod.[LineTotal]			
	,	sod.[rowguid]			
	,	sod.[ModifiedDate]		
	FROM 
		[SalesLT].[SalesOrderDetail] sod
	WHERE 1=1
	AND sod.[SalesOrderID] = soh.[SalesOrderID]
	FOR JSON AUTO
	) as 'Order.OrderDetails'
	FROM 
		[SalesLT].[SalesOrderHeader] soh
	
	FOR JSON PATH, ROOT('orders')
END
GO


