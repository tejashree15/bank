USE [bank]
GO

/****** Object:  View [dbo].[STOCK_PRODUCTS]    Script Date: 04-03-2022 11:29:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 CREATE VIEW [dbo].[STOCK_PRODUCTS]
 AS
 select  quantity, vendor_name , invert_no , invertdate  from 
 product
 INNER JOIN stock
 on product.product_name=stock.product_name;
GO


