USE [bank]
GO

/****** Object:  UserDefinedFunction [dbo].[Customer1loan]    Script Date: 04-03-2022 11:30:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[Customer1loan](@loandate date)
RETURNS table
AS
return select l.type ,c.name from [bank].[dbo].[customer] as c inner join loan as l on c.loan_no=l.loan_no 
where date=@loandate;
GO


