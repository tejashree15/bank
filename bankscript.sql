USE [bank]
GO
/****** Object:  Table [dbo].[customer]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customer](
	[customer_id] [int] NULL,
	[name] [varchar](20) NULL,
	[mobile_no] [varchar](20) NULL,
	[gender] [varchar](20) NULL,
	[bloodgroup] [varchar](15) NULL,
	[working_profile] [varchar](20) NULL,
	[address] [varchar](20) NULL,
	[city] [varchar](20) NULL,
	[state] [varchar](20) NULL,
	[loan_no] [int] NULL,
	[pincode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[loan]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan](
	[loan_no] [int] NOT NULL,
	[amount] [int] NULL,
	[type] [varchar](20) NULL,
	[date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[loan_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Customerloan]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Customerloan](@loandate date)
RETURNS TABLE
AS
return(select loan.type ,customer.name from loan,customer where loan.loan_no in
(select loan_no from [bank].[dbo].[loan] where date=@loandate )and customer.customer_id in 
(select customer_id from [bank].[dbo].[loan] where date =@loandate)
);
GO
/****** Object:  UserDefinedFunction [dbo].[Customersloan]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Customersloan](@loandate date)
RETURNS TABLE
AS
return(select loan.type ,customer.name from customer, loan where customer.customer_id in(select customer_id from customer where date=@loandate) and 
loan.loan_no in(select loan_no from loan where date=@loandate)
);
GO
/****** Object:  UserDefinedFunction [dbo].[Customer1loan]    Script Date: 04-03-2022 11:25:06 ******/
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
/****** Object:  Table [dbo].[product]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product](
	[product_id] [int] NOT NULL,
	[product_name] [varchar](30) NOT NULL,
	[quantity] [varchar](20) NOT NULL,
	[amount] [int] NOT NULL,
	[tax] [varchar](35) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stock]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stock](
	[stock_id] [int] NOT NULL,
	[product_name] [varchar](35) NOT NULL,
	[vendor_name] [varchar](35) NOT NULL,
	[invertdate] [date] NOT NULL,
	[invert_no] [varchar](30) NOT NULL,
	[amount] [int] NOT NULL,
	[product_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[stock_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[STOCK_PRODUCTS]    Script Date: 04-03-2022 11:25:06 ******/
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
/****** Object:  UserDefinedFunction [dbo].[stock_date]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[stock_date] (@date date)
RETURNS TABLE
AS
return(select customer.name, product.product_name from customer,product where product.product_id in
(select product_id from [bank].[dbo].[stock] where invertdate=@date )and customer.customer_id in
(select customer_id from [bank].[dbo].[stock] where invertdate=@date ));
GO
/****** Object:  UserDefinedFunction [dbo].[stocks_date]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[stocks_date] (@date date)
RETURNS TABLE
AS
return(select product_name from product where product.product_id in
(select product_id from [bank].[dbo].[stock] where invertdate=@date ));
GO
/****** Object:  UserDefinedFunction [dbo].[stock_dates]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[stock_dates] (@date date)
RETURNS TABLE
AS
return(select product.product_name ,customer.name from product,customer where product.product_id in
(select product_id from [bank].[dbo].[stock] where invertdate=@date )and customer.customer_id in 
(select customer_id from [bank].[dbo].[stock] where invertdate=@date )
);
GO
/****** Object:  UserDefinedFunction [dbo].[stocking_date]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[stocking_date] (@date date)
RETURNS TABLE
AS
return(select product.product_name ,customer.name from product,customer where product.product_id in
(select product_id from [bank].[dbo].[stock] where invertdate=@date )and customer.customer_id in 
(select customer_id from [bank].[dbo].[stock] where invertdate=@date )
);
GO
/****** Object:  UserDefinedFunction [dbo].[product_date]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[product_date] (@date date)
RETURNS TABLE
AS
return(select stock.invertdate, product.product_name from stock, product where product.product_id in
(select product_id from [bank].[dbo].[stock] where invertdate=@date )and stock.stock_id in
(select stock_id from [bank].[dbo].[stock] where invertdate=@date ));
GO
/****** Object:  Table [dbo].[account]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account](
	[account_no] [int] NOT NULL,
	[Balance] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[account_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[banks]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[banks](
	[bank_id] [int] NOT NULL,
	[bank_name] [varchar](20) NULL,
	[bank_code] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[bank_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[AccountOpening]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[AccountOpening] (@OpeningDate date)
returns table
as
return(select customer.name,banks.bank_name from customer,banks where banks.bank_id in 
(select banks.bank_id from [bank].[dbo].[account] where date = @OpeningDate) and customer.customer_id in
(select customer.customer_id from [bank].[dbo].[account] where date = @OpeningDate));

GO
/****** Object:  Table [dbo].[branch]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[branch](
	[branch_id] [int] NOT NULL,
	[name] [varchar](20) NULL,
	[branch_code] [varchar](20) NULL,
	[city] [varchar](20) NULL,
	[bank_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[credit]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[credit](
	[credit_id] [int] NOT NULL,
	[credit_type] [varchar](20) NULL,
	[credit_amount] [varchar](20) NULL,
	[credit_total] [varchar](20) NULL,
	[account_no] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[credit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[debits]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[debits](
	[debit_id] [int] NOT NULL,
	[debit_type] [varchar](20) NULL,
	[debit_amount] [varchar](20) NULL,
	[account_no] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[debit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[login]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[login](
	[login_id] [int] NOT NULL,
	[username] [varchar](20) NULL,
	[password] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[login_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] NOT NULL,
	[user_name] [varchar](30) NULL,
	[user_mobile] [varchar](20) NULL,
	[user_email] [varchar](30) NULL,
	[user_aadhar] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vendor]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vendor](
	[id] [int] NOT NULL,
	[full_name] [varchar](40) NULL,
	[address] [varchar](40) NULL,
	[state] [varchar](20) NULL,
	[gender] [varchar](10) NULL,
	[mobile_no] [varchar](30) NULL,
	[e_mail] [varchar](30) NULL,
	[dob] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (23789909, N'4000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (23876544, N'7000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (23890079, N'85000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (28976543, N'2000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (38976590, N'35000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (56876546, N'4000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (65432567, N'15000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (65789876, N'2000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (78906654, N'35000')
INSERT [dbo].[account] ([account_no], [Balance]) VALUES (89076543, N'15000')
GO
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (232289, N'State Bank Of India', N'890076')
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (456789, N'Bank of India', N'006005')
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (546789, N'BAnk of Baroda', N'908876')
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (560098, N'JDCC Bank Of India', N'903213')
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (564367, N'State Bank Of India', N'900347')
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (678004, N'JDCC Bank Of India', N'450067')
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (789099, N'ICICI  Bank ', N'905099')
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (800097, N'JDCC Bank Of India', N'200670')
INSERT [dbo].[banks] ([bank_id], [bank_name], [bank_code]) VALUES (890765, N'JDCC Bank Of India', N'789006')
GO
INSERT [dbo].[branch] ([branch_id], [name], [branch_code], [city], [bank_id]) VALUES (23, N'Rakund', N'78907', N'Nagpur', 560098)
INSERT [dbo].[branch] ([branch_id], [name], [branch_code], [city], [bank_id]) VALUES (45, N'Mahal', N'20035', N'Pune', 456789)
INSERT [dbo].[branch] ([branch_id], [name], [branch_code], [city], [bank_id]) VALUES (54, N'Nilanjali', N'67890', N'Pune', 232289)
INSERT [dbo].[branch] ([branch_id], [name], [branch_code], [city], [bank_id]) VALUES (67, N'Nandanvan', N'43256', N'Pune', 678004)
INSERT [dbo].[branch] ([branch_id], [name], [branch_code], [city], [bank_id]) VALUES (88, N'Nilanjali', N'56789', N'Nashik', 890765)
INSERT [dbo].[branch] ([branch_id], [name], [branch_code], [city], [bank_id]) VALUES (90, N'Niramal', N'89005', N'Mumbai', 789099)
GO
INSERT [dbo].[credit] ([credit_id], [credit_type], [credit_amount], [credit_total], [account_no]) VALUES (22, N'Mutual Credit', N'300', N'6000', 65432567)
INSERT [dbo].[credit] ([credit_id], [credit_type], [credit_amount], [credit_total], [account_no]) VALUES (23, N'Open Credit', N'35000', N'55000', 28976543)
INSERT [dbo].[credit] ([credit_id], [credit_type], [credit_amount], [credit_total], [account_no]) VALUES (33, N'Installment Credit', N'200', N'5000', 65789876)
INSERT [dbo].[credit] ([credit_id], [credit_type], [credit_amount], [credit_total], [account_no]) VALUES (45, N'Installment Credit', N'200', N'7000', 23789909)
INSERT [dbo].[credit] ([credit_id], [credit_type], [credit_amount], [credit_total], [account_no]) VALUES (88, N'Mutual Credit', N'5000', N'10000', 23890079)
GO
INSERT [dbo].[customer] ([customer_id], [name], [mobile_no], [gender], [bloodgroup], [working_profile], [address], [city], [state], [loan_no], [pincode]) VALUES (12, N'Mahesh', N'9087654432', N'Male', N'B+', N'Teacher', N'Nilanjali Socity', N'Pune', N'Maharashtra', 234623009, 424107)
INSERT [dbo].[customer] ([customer_id], [name], [mobile_no], [gender], [bloodgroup], [working_profile], [address], [city], [state], [loan_no], [pincode]) VALUES (22, N'Rashi', N'9088765567', N'Female', N'O-', N'Client', N'Viman nagar', N'Pune', N'Maharashtra', 900087655, 543229)
INSERT [dbo].[customer] ([customer_id], [name], [mobile_no], [gender], [bloodgroup], [working_profile], [address], [city], [state], [loan_no], [pincode]) VALUES (90, N'Maya', N'6549008765', N'Female', N'B+', N'Teacher', N'Prathmesh Socity', N'Nashik', N'Maharashtra', 509987654, 789066)
INSERT [dbo].[customer] ([customer_id], [name], [mobile_no], [gender], [bloodgroup], [working_profile], [address], [city], [state], [loan_no], [pincode]) VALUES (23, N'Riya', N'6543890076', N'Female', N'O', N'Doctor', N'Nilam road', N'Shirpur', N'Maharshtra', 901123456, 908876)
INSERT [dbo].[customer] ([customer_id], [name], [mobile_no], [gender], [bloodgroup], [working_profile], [address], [city], [state], [loan_no], [pincode]) VALUES (25, N'Payal', N'6543900087', N'Female', N'B+', N'Doctor', N'Viman nagar', N'Pune', N'Maharashtra', 890054320, 667809)
INSERT [dbo].[customer] ([customer_id], [name], [mobile_no], [gender], [bloodgroup], [working_profile], [address], [city], [state], [loan_no], [pincode]) VALUES (4, N'Nayan', N'9667867886', N'Female', N'A+', N'client', N'Mahal', N'Nagpur', N'Maharashtra', 789009870, 440034)
GO
INSERT [dbo].[debits] ([debit_id], [debit_type], [debit_amount], [account_no]) VALUES (12, N'Master Debit Card', N'200', 23890079)
INSERT [dbo].[debits] ([debit_id], [debit_type], [debit_amount], [account_no]) VALUES (23, N'ATM Card', N'400', 65789876)
INSERT [dbo].[debits] ([debit_id], [debit_type], [debit_amount], [account_no]) VALUES (29, N'Master Debit Card', N'2000', 65432567)
INSERT [dbo].[debits] ([debit_id], [debit_type], [debit_amount], [account_no]) VALUES (66, N'visa Debit Card', N'5000', 28976543)
INSERT [dbo].[debits] ([debit_id], [debit_type], [debit_amount], [account_no]) VALUES (90, N'ATM Card', N'25000', 89076543)
GO
INSERT [dbo].[loan] ([loan_no], [amount], [type], [date]) VALUES (230087234, 670086, N'Personal Loan', CAST(N'2009-04-06' AS Date))
INSERT [dbo].[loan] ([loan_no], [amount], [type], [date]) VALUES (234623009, 66000, N'Home Loan', CAST(N'2001-05-01' AS Date))
INSERT [dbo].[loan] ([loan_no], [amount], [type], [date]) VALUES (509987654, 500000, N'Gold Loan', CAST(N'2021-01-08' AS Date))
INSERT [dbo].[loan] ([loan_no], [amount], [type], [date]) VALUES (789009870, 55000, N'Personal Loan', CAST(N'2008-12-03' AS Date))
INSERT [dbo].[loan] ([loan_no], [amount], [type], [date]) VALUES (890054320, 678901, N'Home Loan', CAST(N'2021-01-08' AS Date))
INSERT [dbo].[loan] ([loan_no], [amount], [type], [date]) VALUES (900065432, 900764, N'Personal Loan', CAST(N'2015-02-07' AS Date))
INSERT [dbo].[loan] ([loan_no], [amount], [type], [date]) VALUES (900087655, 120000, N'Home Loan', CAST(N'2010-11-08' AS Date))
INSERT [dbo].[loan] ([loan_no], [amount], [type], [date]) VALUES (901123456, 409976, N'Home Loan', CAST(N'2021-01-08' AS Date))
GO
INSERT [dbo].[product] ([product_id], [product_name], [quantity], [amount], [tax]) VALUES (1, N'Chair', N'20', 500, N'20')
INSERT [dbo].[product] ([product_id], [product_name], [quantity], [amount], [tax]) VALUES (2, N'Fan', N'30', 100, N'33')
INSERT [dbo].[product] ([product_id], [product_name], [quantity], [amount], [tax]) VALUES (3, N'Light', N'20', 2000, N'44')
INSERT [dbo].[product] ([product_id], [product_name], [quantity], [amount], [tax]) VALUES (4, N'AC', N'2', 20000, N'50')
INSERT [dbo].[product] ([product_id], [product_name], [quantity], [amount], [tax]) VALUES (5, N'Computer', N'15', 45000, N'60')
GO
INSERT [dbo].[stock] ([stock_id], [product_name], [vendor_name], [invertdate], [invert_no], [amount], [product_id]) VALUES (12, N'Fan', N'Rahul', CAST(N'2020-12-05' AS Date), N'4567', 5000, 2)
INSERT [dbo].[stock] ([stock_id], [product_name], [vendor_name], [invertdate], [invert_no], [amount], [product_id]) VALUES (34, N'AC', N'Piyush', CAST(N'2022-12-01' AS Date), N'4555', 8900, 1)
INSERT [dbo].[stock] ([stock_id], [product_name], [vendor_name], [invertdate], [invert_no], [amount], [product_id]) VALUES (48, N'Fan', N'Kiyara', CAST(N'2022-05-05' AS Date), N'2345', 7000, 3)
INSERT [dbo].[stock] ([stock_id], [product_name], [vendor_name], [invertdate], [invert_no], [amount], [product_id]) VALUES (56, N'AC', N'Taimur', CAST(N'2020-12-05' AS Date), N'5678', 20000, 4)
INSERT [dbo].[stock] ([stock_id], [product_name], [vendor_name], [invertdate], [invert_no], [amount], [product_id]) VALUES (90, N'Light', N'Riya', CAST(N'2022-03-09' AS Date), N'2234', 1200, 5)
GO
INSERT [dbo].[users] ([user_id], [user_name], [user_mobile], [user_email], [user_aadhar]) VALUES (1, N'Nayan', N'9789786867', N'nayan@gmail.com', N'889967564589')
INSERT [dbo].[users] ([user_id], [user_name], [user_mobile], [user_email], [user_aadhar]) VALUES (2, N'Riya', N'8780890890', N'riya2@gmail.com', N'897856789087')
INSERT [dbo].[users] ([user_id], [user_name], [user_mobile], [user_email], [user_aadhar]) VALUES (3, N'Akshay', N'9088762345', N'akshay@gmail.com', N'567890009876')
INSERT [dbo].[users] ([user_id], [user_name], [user_mobile], [user_email], [user_aadhar]) VALUES (4, N'Niraj', N'9000871222', N'niraj@gmail.com', N'786654321908')
INSERT [dbo].[users] ([user_id], [user_name], [user_mobile], [user_email], [user_aadhar]) VALUES (5, N'Tejashree', N'7900876555', N'teju@gmail.com', N'908876543209')
GO
INSERT [dbo].[vendor] ([id], [full_name], [address], [state], [gender], [mobile_no], [e_mail], [dob]) VALUES (1, N'Sakshi Patil', N'Mahal', N'Maharashtra', N'Female', N'9688087912', N'sakshi9@gmail.com', CAST(N'2001-05-22' AS Date))
INSERT [dbo].[vendor] ([id], [full_name], [address], [state], [gender], [mobile_no], [e_mail], [dob]) VALUES (2, N'Akshya Patel', N'Nandanvan', N'Maharashtra', N'Male', N'8676987680', N'akshya@gmail.com', CAST(N'2006-04-03' AS Date))
INSERT [dbo].[vendor] ([id], [full_name], [address], [state], [gender], [mobile_no], [e_mail], [dob]) VALUES (3, N'Harsh Baisware', N'Viman Nagar', N'Maharashtra', N'Male', N'9678758787', N'harsh@gmail.com', CAST(N'2010-05-01' AS Date))
INSERT [dbo].[vendor] ([id], [full_name], [address], [state], [gender], [mobile_no], [e_mail], [dob]) VALUES (4, N'Sneha Ramteke', N'Nilanjali Society', N'Maharashtra', N'Female', N'8976787677', N'siya2@gmail.com', CAST(N'2019-06-05' AS Date))
INSERT [dbo].[vendor] ([id], [full_name], [address], [state], [gender], [mobile_no], [e_mail], [dob]) VALUES (5, N'Gayatri Satpute', N'Prathmesh Society', N'Maharashtra', N'Female', N'9767858788', N'gayu8@gmail.com', CAST(N'2017-01-15' AS Date))
INSERT [dbo].[vendor] ([id], [full_name], [address], [state], [gender], [mobile_no], [e_mail], [dob]) VALUES (6, N'Sajal Singh', N'Wadi', N'Maharashtra', N'Male', N'9888788906', N'sajal2@gmail.com', CAST(N'2019-02-20' AS Date))
GO
ALTER TABLE [dbo].[branch]  WITH CHECK ADD FOREIGN KEY([bank_id])
REFERENCES [dbo].[banks] ([bank_id])
GO
ALTER TABLE [dbo].[credit]  WITH CHECK ADD FOREIGN KEY([account_no])
REFERENCES [dbo].[account] ([account_no])
GO
ALTER TABLE [dbo].[customer]  WITH CHECK ADD FOREIGN KEY([loan_no])
REFERENCES [dbo].[loan] ([loan_no])
GO
ALTER TABLE [dbo].[debits]  WITH CHECK ADD FOREIGN KEY([account_no])
REFERENCES [dbo].[account] ([account_no])
GO
ALTER TABLE [dbo].[stock]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([product_id])
GO
/****** Object:  StoredProcedure [dbo].[cust]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[cust] @postalcode int, @city varchar(20)
AS
SELECT * from customer where pincode=@postalcode OR city=@city;
GO
/****** Object:  StoredProcedure [dbo].[getCustomer]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[getCustomer] @postalcode int, @city varchar(20)
AS
SELECT * from customer where pincode=@postalcode and city=@city;
GO
/****** Object:  StoredProcedure [dbo].[getCustomerByPincode]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[getCustomerByPincode] @postalcode int
AS
SELECT * from customer where pincode=@postalcode;
GO
/****** Object:  StoredProcedure [dbo].[selectAllCustomers]    Script Date: 04-03-2022 11:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[selectAllCustomers]
AS
SELECT * from customer;
GO
