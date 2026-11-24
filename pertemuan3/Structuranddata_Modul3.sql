---------------------------------------------------------------------
-- Script Database Praktikum Pemrograman Basis Data
-- Modul III - RETRIVAL DATA (SELECT) [Skema AdventureWorks]
--
-- Database : AdventureWorks_Latihan
-- Schemas  : Production, Sales, HumanResources
-- Tables   : Production.Product, Sales.SalesOrderDetail,
--            HumanResources.Employee
-- Supported: SQL Server 2012+ (SSMS / DataGrip / Docker SQL Server)
---------------------------------------------------------------------

USE master;
GO

IF DB_ID(N'AdventureWorks_Latihan') IS NOT NULL
BEGIN
    ALTER DATABASE AdventureWorks_Latihan SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AdventureWorks_Latihan;
END
GO

CREATE DATABASE AdventureWorks_Latihan;
GO

USE AdventureWorks_Latihan;
GO

---------------------------------------------------------------------
-- Create Schemas
---------------------------------------------------------------------
CREATE SCHEMA Production AUTHORIZATION dbo;
GO
CREATE SCHEMA Sales AUTHORIZATION dbo;
GO
CREATE SCHEMA HumanResources AUTHORIZATION dbo;
GO

---------------------------------------------------------------------
-- Create Tables
---------------------------------------------------------------------

-- 1. Production.Product
CREATE TABLE Production.Product
(
    ProductID         INT           NOT NULL IDENTITY(1, 1),
    Name              NVARCHAR(50)  NOT NULL,
    ProductNumber     NVARCHAR(25)  NOT NULL,
    Color             NVARCHAR(15)  NULL,
    StandardCost      MONEY         NOT NULL CONSTRAINT DF_Product_StandardCost DEFAULT (0.00),
    ListPrice         MONEY         NOT NULL CONSTRAINT DF_Product_ListPrice DEFAULT (0.00),
    Size              NVARCHAR(5)   NULL,
    SafetyStockLevel  SMALLINT      NOT NULL CONSTRAINT DF_Product_SafetyStockLevel DEFAULT (500),
    ReorderPoint      SMALLINT      NOT NULL CONSTRAINT DF_Product_ReorderPoint DEFAULT (375),
    DaysToManufacture INT           NOT NULL CONSTRAINT DF_Product_DaysToManufacture DEFAULT (0),
    SellStartDate     DATETIME      NOT NULL CONSTRAINT DF_Product_SellStartDate DEFAULT (GETDATE()),
    ModifiedDate      DATETIME      NOT NULL CONSTRAINT DF_Product_ModifiedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_Product_ProductID PRIMARY KEY CLUSTERED (ProductID),
    CONSTRAINT AK_Product_ProductNumber UNIQUE NONCLUSTERED (ProductNumber),
    CONSTRAINT CK_Product_StandardCost CHECK (StandardCost >= 0.00),
    CONSTRAINT CK_Product_ListPrice CHECK (ListPrice >= 0.00)
);

CREATE NONCLUSTERED INDEX IX_Product_Name ON Production.Product(Name);
CREATE NONCLUSTERED INDEX IX_Product_Color ON Production.Product(Color);

-- 2. Sales.SalesOrderDetail
CREATE TABLE Sales.SalesOrderDetail
(
    SalesOrderID       INT           NOT NULL,
    SalesOrderDetailID INT           NOT NULL IDENTITY(1, 1),
    OrderQty           SMALLINT      NOT NULL,
    ProductID          INT           NOT NULL,
    SpecialOfferID     INT           NOT NULL CONSTRAINT DF_SalesOrderDetail_SpecialOfferID DEFAULT (1),
    UnitPrice          MONEY         NOT NULL,
    UnitPriceDiscount  MONEY         NOT NULL CONSTRAINT DF_SalesOrderDetail_UnitPriceDiscount DEFAULT (0.00),
    LineTotal          AS (ISNULL((UnitPrice * ((1.0) - UnitPriceDiscount)) * OrderQty, (0.0))),
    ModifiedDate       DATETIME      NOT NULL CONSTRAINT DF_SalesOrderDetail_ModifiedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID PRIMARY KEY CLUSTERED (SalesOrderID, SalesOrderDetailID),
    CONSTRAINT FK_SalesOrderDetail_Product_ProductID FOREIGN KEY (ProductID) REFERENCES Production.Product(ProductID),
    CONSTRAINT CK_SalesOrderDetail_OrderQty CHECK (OrderQty > 0),
    CONSTRAINT CK_SalesOrderDetail_UnitPrice CHECK (UnitPrice >= 0.00),
    CONSTRAINT CK_SalesOrderDetail_UnitPriceDiscount CHECK (UnitPriceDiscount >= 0.00 AND UnitPriceDiscount <= 1.00)
);

CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_ProductID ON Sales.SalesOrderDetail(ProductID);
CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_SpecialOfferID ON Sales.SalesOrderDetail(SpecialOfferID);

-- 3. HumanResources.Employee
CREATE TABLE HumanResources.Employee
(
    BusinessEntityID INT           NOT NULL IDENTITY(1, 1),
    NationalIDNumber NVARCHAR(15)  NOT NULL,
    LoginID          NVARCHAR(256) NOT NULL,
    JobTitle         NVARCHAR(50)  NOT NULL,
    BirthDate        DATE          NOT NULL,
    MaritalStatus    NCHAR(1)      NOT NULL,
    Gender           NCHAR(1)      NOT NULL,
    HireDate         DATE          NOT NULL,
    SalariedFlag     BIT           NOT NULL CONSTRAINT DF_Employee_SalariedFlag DEFAULT (1),
    ModifiedDate     DATETIME      NOT NULL CONSTRAINT DF_Employee_ModifiedDate DEFAULT (GETDATE()),
    CONSTRAINT PK_Employee_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID),
    CONSTRAINT AK_Employee_NationalIDNumber UNIQUE NONCLUSTERED (NationalIDNumber),
    CONSTRAINT AK_Employee_LoginID UNIQUE NONCLUSTERED (LoginID),
    CONSTRAINT CK_Employee_MaritalStatus CHECK (UPPER(MaritalStatus) IN ('M', 'S')),
    CONSTRAINT CK_Employee_Gender CHECK (UPPER(Gender) IN ('M', 'F'))
);
GO

---------------------------------------------------------------------
-- Populate Tables
---------------------------------------------------------------------
SET NOCOUNT ON;

-- Populate Production.Product
SET IDENTITY_INSERT Production.Product ON;
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (1, N'Road-150 Black, 44', N'BK-R93B-44', N'Black', 2171.29, 3578.27, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (2, N'Road-150 Black, 48', N'BK-R93B-48', N'Black', 2171.29, 3578.27, N'48', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (3, N'Road-150 Black, 52', N'BK-R93B-52', N'Black', 2171.29, 3578.27, N'52', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (4, N'Road-150 Black, 56', N'BK-R93B-56', N'Black', 2171.29, 3578.27, N'56', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (5, N'Mountain-100 Black, 38', N'BK-M82B-38', N'Black', 1898.09, 3374.99, N'38', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (6, N'Mountain-100 Black, 42', N'BK-M82B-42', N'Black', 1898.09, 3374.99, N'42', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (7, N'Mountain-100 Black, 44', N'BK-M82B-44', N'Black', 1898.09, 3374.99, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (8, N'Mountain-100 Black, 48', N'BK-M82B-48', N'Black', 1898.09, 3374.99, N'48', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (9, N'Road-250 Black, 44', N'BK-R89B-44', N'Black', 1554.95, 2443.35, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (10, N'Road-250 Black, 48', N'BK-R89B-48', N'Black', 1554.95, 2443.35, N'48', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (11, N'Road-250 Black, 52', N'BK-R89B-52', N'Black', 1554.95, 2443.35, N'52', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (12, N'Road-250 Black, 58', N'BK-R89B-58', N'Black', 1554.95, 2443.35, N'58', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (13, N'Mountain-200 Black, 38', N'BK-M68B-38', N'Black', 1251.98, 2294.99, N'38', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (14, N'Mountain-200 Black, 42', N'BK-M68B-42', N'Black', 1251.98, 2294.99, N'42', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (15, N'Mountain-200 Black, 46', N'BK-M68B-46', N'Black', 1251.98, 2294.99, N'46', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (16, N'HL Road Frame - Black, 58', N'FR-R92B-58', N'Black', 1059.31, 1431.50, N'58', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (17, N'HL Road Frame - Black, 62', N'FR-R92B-62', N'Black', 1059.31, 1431.50, N'62', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (18, N'HL Mountain Frame - Black, 42', N'FR-M94B-42', N'Black', 739.04, 1349.60, N'42', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (19, N'Road-550-W Black, 44', N'BK-R64B-44', N'Black', 713.08, 1120.49, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (20, N'Road-750 Black, 48', N'BK-R19B-48', N'Black', 343.65, 539.99, N'48', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (21, N'Road-750 Black, 52', N'BK-R19B-52', N'Black', 343.65, 539.99, N'52', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (22, N'LL Road Frame - Black, 52', N'FR-R38B-52', N'Black', 204.63, 337.22, N'52', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (23, N'LL Road Frame - Black, 58', N'FR-R38B-58', N'Black', 204.63, 337.22, N'58', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (24, N'Men''s Bib-Shorts, S', N'SB-M891-S', N'Black', 37.12, 89.99, N'S', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (25, N'Men''s Bib-Shorts, M', N'SB-M891-M', N'Black', 37.12, 89.99, N'M', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (26, N'Men''s Bib-Shorts, L', N'SB-M891-L', N'Black', 37.12, 89.99, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (27, N'Half-Finger Gloves, S', N'GL-H102-S', N'Black', 9.16, 24.49, N'S', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (28, N'Half-Finger Gloves, M', N'GL-H102-M', N'Black', 9.16, 24.49, N'M', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (29, N'Half-Finger Gloves, L', N'GL-H102-L', N'Black', 9.16, 24.49, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (30, N'Sport-100 Helmet, Black', N'HL-U509', N'Black', 13.09, 34.99, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (31, N'Road-150 Red, 62', N'BK-R93R-62', N'Red', 2171.29, 3578.27, N'62', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (32, N'Road-150 Red, 44', N'BK-R93R-44', N'Red', 2171.29, 3578.27, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (33, N'Road-150 Red, 48', N'BK-R93R-48', N'Red', 2171.29, 3578.27, N'48', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (34, N'Road-150 Red, 52', N'BK-R93R-52', N'Red', 2171.29, 3578.27, N'52', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (35, N'Road-150 Red, 56', N'BK-R93R-56', N'Red', 2171.29, 3578.27, N'56', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (36, N'Road-250 Red, 44', N'BK-R89R-44', N'Red', 1518.79, 2443.35, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (37, N'Road-250 Red, 48', N'BK-R89R-48', N'Red', 1518.79, 2443.35, N'48', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (38, N'Road-250 Red, 52', N'BK-R89R-52', N'Red', 1518.79, 2443.35, N'52', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (39, N'Road-250 Red, 58', N'BK-R89R-58', N'Red', 1554.95, 2443.35, N'58', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (40, N'Road-450 Red, 58', N'BK-R68R-58', N'Red', 884.71, 1457.99, N'58', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (41, N'Road-450 Red, 60', N'BK-R68R-60', N'Red', 884.71, 1457.99, N'60', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (42, N'Road-450 Red, 44', N'BK-R68R-44', N'Red', 884.71, 1457.99, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (43, N'Road-450 Red, 48', N'BK-R68R-48', N'Red', 884.71, 1457.99, N'48', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (44, N'HL Road Frame - Red, 58', N'FR-R92R-58', N'Red', 1059.31, 1431.50, N'58', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (45, N'HL Road Frame - Red, 62', N'FR-R92R-62', N'Red', 1059.31, 1431.50, N'62', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (46, N'Road-650 Red, 58', N'BK-R50R-58', N'Red', 486.71, 782.99, N'58', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (47, N'Road-650 Red, 60', N'BK-R50R-60', N'Red', 486.71, 782.99, N'60', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (48, N'ML Road Frame - Red, 44', N'FR-R72R-44', N'Red', 352.14, 594.83, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (49, N'LL Road Frame - Red, 44', N'FR-R38R-44', N'Red', 187.16, 337.22, N'44', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (50, N'LL Road Frame - Red, 52', N'FR-R38R-52', N'Red', 187.16, 337.22, N'52', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (51, N'Sport-100 Helmet, Red', N'HL-U509-R', N'Red', 13.09, 34.99, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (52, N'Long-Sleeve Logo Jersey, S', N'LJ-0192-S', N'Red', 38.49, 49.99, N'S', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (53, N'Long-Sleeve Logo Jersey, M', N'LJ-0192-M', N'Red', 38.49, 49.99, N'M', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (54, N'Long-Sleeve Logo Jersey, L', N'LJ-0192-L', N'Red', 38.49, 49.99, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (55, N'Long-Sleeve Logo Jersey, XL', N'LJ-0192-X', N'Red', 38.49, 49.99, N'XL', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (56, N'Road Bottle Cage - Red', N'BC-R205-R', N'Red', 3.37, 8.99, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (57, N'Mountain-100 Silver, 38', N'BK-M82S-38', N'Silver', 1912.15, 3399.99, N'38', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (58, N'Mountain-100 Silver, 42', N'BK-M82S-42', N'Silver', 1912.15, 3399.99, N'42', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (59, N'Mountain-100 Silver, 44', N'BK-M82S-44', N'Silver', 1912.15, 3399.99, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (60, N'Mountain-100 Silver, 48', N'BK-M82S-48', N'Silver', 1912.15, 3399.99, N'48', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (61, N'Mountain-200 Silver, 38', N'BK-M68S-38', N'Silver', 1265.62, 2319.99, N'38', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (62, N'Mountain-200 Silver, 42', N'BK-M68S-42', N'Silver', 1265.62, 2319.99, N'42', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (63, N'Mountain-200 Silver, 46', N'BK-M68S-46', N'Silver', 1265.62, 2319.99, N'46', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (64, N'HL Mountain Frame - Silver, 42', N'FR-M94S-42', N'Silver', 747.20, 1364.50, N'42', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (65, N'HL Mountain Frame - Silver, 46', N'FR-M94S-46', N'Silver', 747.20, 1364.50, N'46', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (66, N'Mountain-400-W Silver, 38', N'BK-M38S-38', N'Silver', 419.78, 769.49, N'38', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (67, N'Mountain-400-W Silver, 40', N'BK-M38S-40', N'Silver', 419.78, 769.49, N'40', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (68, N'Mountain-400-W Silver, 42', N'BK-M38S-42', N'Silver', 419.78, 769.49, N'42', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (69, N'Mountain-500 Silver, 40', N'BK-M18S-40', N'Silver', 308.22, 564.99, N'40', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (70, N'Mountain-500 Silver, 44', N'BK-M18S-44', N'Silver', 308.22, 564.99, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (71, N'ML Mountain Frame - Silver, 38', N'FR-M63S-38', N'Silver', 199.38, 364.09, N'38', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (72, N'ML Mountain Frame - Silver, 42', N'FR-M63S-42', N'Silver', 199.38, 364.09, N'42', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (73, N'LL Mountain Frame - Silver, 40', N'FR-M21S-40', N'Silver', 144.59, 264.05, N'40', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (74, N'LL Mountain Frame - Silver, 44', N'FR-M21S-44', N'Silver', 144.59, 264.05, N'44', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (75, N'HL Crankset', N'CS-9183', N'Silver', 179.82, 404.99, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (76, N'ML Crankset', N'CS-6583', N'Silver', 113.88, 256.49, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (77, N'LL Crankset', N'CS-4759', N'Silver', 77.92, 175.49, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (78, N'Chain', N'CH-0234', N'Silver', 8.99, 20.24, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (79, N'Rear Derailleur', N'RD-2308', N'Silver', 53.93, 121.46, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (80, N'Front Derailleur', N'FD-2342', N'Silver', 40.62, 91.49, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (81, N'Touring-1000 Blue, 46', N'BK-T79U-46', N'Blue', 1481.94, 2384.07, N'46', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (82, N'Touring-1000 Blue, 50', N'BK-T79U-50', N'Blue', 1481.94, 2384.07, N'50', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (83, N'Touring-1000 Blue, 54', N'BK-T79U-54', N'Blue', 1481.94, 2384.07, N'54', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (84, N'Touring-1000 Blue, 60', N'BK-T79U-60', N'Blue', 1481.94, 2384.07, N'60', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (85, N'Touring-2000 Blue, 46', N'BK-T44U-46', N'Blue', 755.15, 1214.85, N'46', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (86, N'Touring-2000 Blue, 50', N'BK-T44U-50', N'Blue', 755.15, 1214.85, N'50', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (87, N'Touring-2000 Blue, 54', N'BK-T44U-54', N'Blue', 755.15, 1214.85, N'54', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (88, N'HL Touring Frame - Blue, 46', N'FR-T98U-46', N'Blue', 601.74, 1003.91, N'46', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (89, N'Touring-3000 Blue, 54', N'BK-T18U-54', N'Blue', 461.44, 742.35, N'54', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (90, N'LL Touring Frame - Blue, 50', N'FR-T67U-50', N'Blue', 199.85, 333.42, N'50', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (91, N'LL Touring Frame - Blue, 54', N'FR-T67U-54', N'Blue', 199.85, 333.42, N'54', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (92, N'Sport-100 Helmet, Blue', N'HL-U509-B', N'Blue', 13.09, 34.99, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (93, N'Classic Vest, S', N'VE-C304-S', N'Blue', 23.75, 63.50, N'S', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (94, N'Classic Vest, M', N'VE-C304-M', N'Blue', 23.75, 63.50, N'M', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (95, N'Classic Vest, L', N'VE-C304-L', N'Blue', 23.75, 63.50, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (96, N'Water Bottle - Blue', N'WB-H098-B', N'Blue', 1.87, 4.99, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (97, N'Touring-1000 Yellow, 46', N'BK-T79Y-46', N'Yellow', 1481.94, 2384.07, N'46', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (98, N'Touring-1000 Yellow, 50', N'BK-T79Y-50', N'Yellow', 1481.94, 2384.07, N'50', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (99, N'Touring-1000 Yellow, 54', N'BK-T79Y-54', N'Yellow', 1481.94, 2384.07, N'54', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (100, N'Road-350-W Yellow, 40', N'BK-R79Y-40', N'Yellow', 1082.51, 1700.99, N'40', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (101, N'Road-350-W Yellow, 44', N'BK-R79Y-44', N'Yellow', 1082.51, 1700.99, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (102, N'Road-550-W Yellow, 38', N'BK-R64Y-38', N'Yellow', 713.08, 1120.49, N'38', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (103, N'Road-550-W Yellow, 42', N'BK-R64Y-42', N'Yellow', 713.08, 1120.49, N'42', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (104, N'Touring-3000 Yellow, 44', N'BK-T18Y-44', N'Yellow', 461.44, 742.35, N'44', 500, 375, 4, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (105, N'Short-Sleeve Classic Jersey, S', N'SJ-0194-S', N'Yellow', 41.57, 53.99, N'S', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (106, N'Short-Sleeve Classic Jersey, M', N'SJ-0194-M', N'Yellow', 41.57, 53.99, N'M', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (107, N'Short-Sleeve Classic Jersey, L', N'SJ-0194-L', N'Yellow', 41.57, 53.99, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (108, N'Short-Sleeve Classic Jersey, XL', N'SJ-0194-X', N'Yellow', 41.57, 53.99, N'XL', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (109, N'Mountain Bike Socks, M', N'SO-B909-M', N'White', 3.40, 9.50, N'M', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (110, N'Mountain Bike Socks, L', N'SO-B909-L', N'White', 3.40, 9.50, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (111, N'Racing Socks, M', N'SO-R809-M', N'White', 3.36, 8.99, N'M', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (112, N'Racing Socks, L', N'SO-R809-L', N'White', 3.36, 8.99, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (113, N'AWC Logo Cap', N'CA-1098', N'Multi', 6.92, 8.99, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (114, N'Women''s Tights, S', N'TG-W091-S', N'Multi', 30.93, 74.99, N'S', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (115, N'Women''s Tights, M', N'TG-W091-M', N'Multi', 30.93, 74.99, N'M', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (116, N'Women''s Tights, L', N'TG-W091-L', N'Multi', 30.93, 74.99, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (117, N'Touring-Panniers, Large', N'PA-T100', N'Grey', 51.56, 125.00, N'L', 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (118, N'All-Purpose Bike Stand', N'ST-1401', N'Grey', 59.47, 159.00, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (119, N'Hitch Rack - 4-Bike', N'RA-H123', N'Grey', 44.88, 120.00, NULL, 500, 375, 1, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (120, N'Adjustable Race', N'AR-5381', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (121, N'Bearing Ball', N'BA-8327', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (122, N'BB Ball Bearing', N'BE-2349', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (123, N'Headset Ball Bearings', N'BE-2908', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (124, N'Blade', N'BL-2036', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (125, N'Chainring Bolts', N'CB-2903', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (126, N'Chainring Nut', N'CN-6137', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (127, N'Decal 1', N'DC-8732', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (128, N'Decal 2', N'DC-9824', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (129, N'Flat Washer 1', N'FW-1000', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (130, N'Hex Nut 5', N'HN-5161', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (131, N'Lock Ring', N'LR-2398', NULL, 0.00, 0.00, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (132, N'HL Road Tire', N'TT-R982', NULL, 12.19, 32.60, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (133, N'ML Road Tire', N'TT-R981', NULL, 9.35, 24.99, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (134, N'LL Road Tire', N'TT-R980', NULL, 8.04, 21.49, NULL, 500, 375, 0, '2023-01-01');
INSERT INTO Production.Product (ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, SafetyStockLevel, ReorderPoint, DaysToManufacture, SellStartDate) VALUES (135, N'Bike Wash - Dissolver', N'CL-9009', NULL, 2.97, 7.95, NULL, 500, 375, 0, '2023-01-01');
SET IDENTITY_INSERT Production.Product OFF;
GO

-- Populate Sales.SalesOrderDetail
SET IDENTITY_INSERT Sales.SalesOrderDetail ON;
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43660, 1, 120, 1, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43661, 2, 133, 1, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43662, 3, 98, 1, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43663, 4, 103, 1, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43664, 5, 134, 1, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43665, 6, 102, 1, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43666, 7, 128, 1, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43667, 8, 100, 1, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43668, 9, 125, 1, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43669, 10, 90, 1, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43670, 11, 132, 1, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43671, 12, 120, 1, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43672, 13, 103, 2, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43673, 14, 99, 2, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43674, 15, 117, 2, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43675, 16, 98, 2, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43676, 17, 114, 2, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43677, 18, 106, 2, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43678, 19, 91, 2, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43679, 20, 118, 2, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43680, 21, 102, 2, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43681, 22, 100, 2, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43682, 23, 127, 2, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43683, 24, 115, 2, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43684, 25, 104, 3, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43685, 26, 93, 3, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43686, 27, 124, 3, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43687, 28, 137, 3, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43688, 29, 138, 3, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43689, 30, 138, 3, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43690, 31, 95, 3, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43691, 32, 108, 3, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43692, 33, 121, 3, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43693, 34, 93, 3, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43694, 35, 137, 3, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43695, 36, 126, 3, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43696, 37, 116, 4, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43697, 38, 96, 4, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43698, 39, 118, 4, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43699, 40, 112, 4, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43700, 41, 107, 4, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43701, 42, 106, 4, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43702, 43, 105, 4, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43703, 44, 132, 4, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43704, 45, 140, 4, 6, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43705, 46, 112, 4, 5, 3578.27, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43706, 47, 105, 4, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43707, 48, 125, 4, 4, 3578.27, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43708, 49, 130, 5, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43709, 50, 94, 5, 5, 3374.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43710, 51, 131, 5, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43711, 52, 139, 5, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43712, 53, 126, 5, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43713, 54, 101, 5, 5, 3374.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43714, 55, 98, 5, 5, 3374.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43715, 56, 107, 5, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43716, 57, 122, 5, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43717, 58, 106, 5, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43718, 59, 110, 5, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43719, 60, 134, 5, 5, 3374.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43720, 61, 90, 6, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43721, 62, 122, 6, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43722, 63, 136, 6, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43723, 64, 120, 6, 5, 3374.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43724, 65, 99, 6, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43725, 66, 125, 6, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43726, 67, 104, 6, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43727, 68, 107, 6, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43728, 69, 101, 6, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43729, 70, 119, 6, 6, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43730, 71, 98, 6, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43731, 72, 118, 6, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43732, 73, 8, 7, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43733, 74, 9, 7, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43734, 75, 8, 7, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43735, 76, 14, 7, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43736, 77, 9, 7, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43737, 78, 10, 7, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43738, 79, 6, 7, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43739, 80, 7, 7, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43740, 81, 12, 8, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43741, 82, 6, 8, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43742, 83, 7, 8, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43743, 84, 7, 8, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43744, 85, 10, 8, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43745, 86, 9, 8, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43746, 87, 12, 8, 4, 3374.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43747, 88, 13, 8, 3, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43748, 89, 5, 9, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43749, 90, 10, 9, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43750, 91, 14, 9, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43751, 92, 5, 9, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43752, 93, 13, 9, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43753, 94, 8, 9, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43754, 95, 15, 9, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43755, 96, 14, 9, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43756, 97, 12, 10, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43757, 98, 4, 10, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43758, 99, 10, 10, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43759, 100, 13, 10, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43760, 101, 13, 10, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43761, 102, 14, 10, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43762, 103, 11, 10, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43763, 104, 9, 10, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43764, 105, 12, 11, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43765, 106, 15, 11, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43766, 107, 7, 11, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43767, 108, 5, 11, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43768, 109, 4, 11, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43769, 110, 11, 11, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43770, 111, 15, 11, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43771, 112, 9, 11, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43772, 113, 5, 12, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43773, 114, 5, 12, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43774, 115, 7, 12, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43775, 116, 10, 12, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43776, 117, 13, 12, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43777, 118, 6, 12, 4, 2443.35, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43778, 119, 10, 12, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43779, 120, 9, 12, 3, 2443.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43780, 121, 9, 13, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43781, 122, 7, 13, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43782, 123, 10, 13, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43783, 124, 10, 13, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43784, 125, 11, 13, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43785, 126, 5, 13, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43786, 127, 5, 13, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43787, 128, 4, 13, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43788, 129, 9, 14, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43789, 130, 5, 14, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43790, 131, 4, 14, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43791, 132, 6, 14, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43792, 133, 10, 14, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43793, 134, 15, 14, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43794, 135, 11, 14, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43795, 136, 10, 14, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43796, 137, 10, 15, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43797, 138, 4, 15, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43798, 139, 4, 15, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43799, 140, 12, 15, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43800, 141, 10, 15, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43801, 142, 4, 15, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43802, 143, 8, 15, 3, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43803, 144, 13, 15, 4, 2294.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43804, 145, 6, 16, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43805, 146, 15, 16, 3, 1431.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43806, 147, 10, 16, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43807, 148, 15, 16, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43808, 149, 10, 16, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43809, 150, 7, 16, 3, 1431.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43810, 151, 13, 16, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43811, 152, 12, 16, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43812, 153, 10, 17, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43813, 154, 15, 17, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43814, 155, 7, 17, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43815, 156, 12, 17, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43816, 157, 8, 17, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43817, 158, 7, 17, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43818, 159, 8, 17, 3, 1431.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43819, 160, 10, 17, 4, 1431.50, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43820, 161, 11, 18, 4, 1349.60, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43821, 162, 12, 18, 3, 1349.60, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43822, 163, 7, 18, 4, 1349.60, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43823, 164, 9, 18, 3, 1349.60, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43824, 165, 11, 18, 4, 1349.60, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43825, 166, 12, 18, 4, 1349.60, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43826, 167, 6, 18, 4, 1349.60, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43827, 168, 14, 18, 4, 1349.60, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43828, 169, 134, 24, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43829, 170, 135, 24, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43830, 171, 144, 24, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43831, 172, 132, 24, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43832, 173, 146, 24, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43833, 174, 112, 24, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43834, 175, 114, 24, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43835, 176, 129, 24, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43836, 177, 152, 24, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43837, 178, 114, 24, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43838, 179, 123, 25, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43839, 180, 123, 25, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43840, 181, 141, 25, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43841, 182, 155, 25, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43842, 183, 115, 25, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43843, 184, 122, 25, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43844, 185, 124, 25, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43845, 186, 146, 25, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43846, 187, 134, 25, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43847, 188, 115, 25, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43848, 189, 145, 26, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43849, 190, 115, 26, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43850, 191, 111, 26, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43851, 192, 122, 26, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43852, 193, 160, 26, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43853, 194, 152, 26, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43854, 195, 143, 26, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43855, 196, 147, 26, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43856, 197, 129, 26, 5, 89.99, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43857, 198, 150, 26, 6, 89.99, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43858, 199, 117, 27, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43859, 200, 149, 27, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43860, 201, 154, 27, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43861, 202, 135, 27, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43862, 203, 118, 27, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43863, 204, 138, 27, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43864, 205, 120, 27, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43865, 206, 122, 27, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43866, 207, 143, 27, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43867, 208, 138, 27, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43868, 209, 157, 28, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43869, 210, 148, 28, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43870, 211, 158, 28, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43871, 212, 124, 28, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43872, 213, 126, 28, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43873, 214, 148, 28, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43874, 215, 154, 28, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43875, 216, 119, 28, 6, 24.49, 0.05);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43876, 217, 135, 28, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43877, 218, 153, 28, 5, 24.49, 0.10);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43878, 219, 2, 17, 1, 1431.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43879, 220, 1, 135, 1, 7.95, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43880, 221, 1, 27, 1, 24.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43881, 222, 1, 59, 1, 3399.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43882, 223, 1, 63, 1, 2319.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43883, 224, 2, 77, 1, 175.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43884, 225, 1, 60, 1, 3399.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43885, 226, 1, 83, 1, 2384.07, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43886, 227, 1, 20, 1, 539.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43887, 228, 1, 133, 1, 24.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43888, 229, 2, 102, 1, 1120.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43889, 230, 1, 43, 1, 1457.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43890, 231, 1, 26, 1, 89.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43891, 232, 1, 64, 1, 1364.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43892, 233, 1, 94, 1, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43893, 234, 2, 55, 1, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43894, 235, 1, 60, 1, 3399.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43895, 236, 1, 32, 1, 3578.27, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43896, 237, 1, 62, 1, 2319.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43897, 238, 1, 5, 1, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43898, 239, 2, 106, 1, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43899, 240, 1, 45, 1, 1431.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43900, 241, 1, 53, 1, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43901, 242, 1, 31, 1, 3578.27, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43902, 243, 1, 62, 1, 2319.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43903, 244, 2, 6, 1, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43904, 245, 1, 82, 1, 2384.07, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43905, 246, 1, 8, 1, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43906, 247, 1, 111, 1, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43907, 248, 1, 94, 1, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43908, 249, 2, 81, 1, 2384.07, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43909, 250, 1, 100, 1, 1700.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43910, 251, 1, 7, 1, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43911, 252, 1, 73, 1, 264.05, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43912, 253, 1, 68, 1, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43913, 254, 2, 60, 1, 3399.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43914, 255, 1, 64, 1, 1364.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43915, 256, 1, 59, 1, 3399.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43916, 257, 1, 56, 1, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43917, 258, 1, 71, 1, 364.09, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43918, 259, 2, 3, 1, 3578.27, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43919, 260, 1, 88, 1, 1003.91, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43920, 261, 1, 1, 1, 3578.27, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43921, 262, 1, 86, 1, 1214.85, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43922, 263, 1, 23, 1, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43923, 264, 2, 46, 1, 782.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43924, 265, 1, 90, 1, 333.42, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43925, 266, 1, 115, 1, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43926, 267, 1, 35, 1, 3578.27, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43927, 268, 1, 77, 1, 175.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43928, 269, 2, 112, 1, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43929, 270, 1, 57, 1, 3399.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43930, 271, 1, 6, 1, 3374.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43931, 272, 1, 70, 1, 564.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43932, 273, 1, 61, 1, 2319.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43933, 274, 2, 55, 1, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43934, 275, 1, 58, 1, 3399.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43935, 276, 1, 93, 1, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43936, 277, 1, 15, 1, 2294.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43937, 278, 1, 88, 1, 1003.91, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43938, 279, 2, 74, 2, 264.05, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43939, 280, 1, 117, 2, 125.00, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43940, 281, 1, 103, 2, 1120.49, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43941, 282, 1, 59, 2, 3399.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43942, 283, 1, 2, 2, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43943, 284, 2, 112, 2, 8.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43944, 285, 1, 8, 2, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43945, 286, 1, 64, 2, 1364.50, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43946, 287, 1, 60, 2, 3399.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43947, 288, 1, 84, 2, 2384.07, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43948, 289, 2, 69, 2, 564.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43949, 290, 1, 76, 2, 256.49, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43950, 291, 1, 105, 2, 53.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43951, 292, 1, 82, 2, 2384.07, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43952, 293, 1, 134, 2, 21.49, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43953, 294, 2, 133, 2, 24.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43954, 295, 1, 119, 2, 120.00, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43955, 296, 1, 100, 2, 1700.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43956, 297, 1, 118, 2, 159.00, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43957, 298, 1, 100, 2, 1700.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43958, 299, 2, 20, 2, 539.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43959, 300, 1, 11, 2, 2443.35, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43960, 301, 1, 135, 2, 7.95, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43961, 302, 1, 5, 2, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43962, 303, 1, 61, 2, 2319.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43963, 304, 2, 108, 2, 53.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43964, 305, 1, 84, 2, 2384.07, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43965, 306, 1, 96, 2, 4.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43966, 307, 1, 41, 2, 1457.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43967, 308, 1, 104, 2, 742.35, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43968, 309, 2, 56, 2, 8.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43969, 310, 1, 114, 2, 74.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43970, 311, 1, 81, 2, 2384.07, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43971, 312, 1, 31, 2, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43972, 313, 1, 20, 2, 539.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43973, 314, 2, 47, 2, 782.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43974, 315, 1, 90, 2, 333.42, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43975, 316, 1, 7, 2, 3374.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43976, 317, 1, 17, 2, 1431.50, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43977, 318, 1, 30, 2, 34.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43978, 319, 2, 77, 2, 175.49, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43979, 320, 1, 47, 2, 782.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43980, 321, 1, 79, 2, 121.46, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43981, 322, 1, 132, 2, 32.60, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43982, 323, 1, 51, 2, 34.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43983, 324, 2, 98, 2, 2384.07, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43984, 325, 1, 91, 2, 333.42, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43985, 326, 1, 2, 2, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43986, 327, 1, 85, 2, 1214.85, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43987, 328, 1, 108, 2, 53.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43988, 329, 2, 32, 2, 3578.27, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43989, 330, 1, 73, 2, 264.05, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43990, 331, 1, 111, 2, 8.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43991, 332, 1, 58, 2, 3399.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43992, 333, 1, 47, 2, 782.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43993, 334, 2, 104, 2, 742.35, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43994, 335, 1, 78, 2, 20.24, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43995, 336, 1, 39, 2, 2443.35, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43996, 337, 1, 58, 2, 3399.99, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43997, 338, 1, 66, 2, 769.49, 0.02);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43998, 339, 6, 20, 3, 539.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (43999, 340, 2, 20, 3, 539.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44000, 341, 4, 20, 3, 539.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44001, 342, 2, 21, 3, 539.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44002, 343, 5, 21, 3, 539.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44003, 344, 5, 21, 3, 539.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44004, 345, 4, 22, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44005, 346, 4, 22, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44006, 347, 6, 22, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44007, 348, 3, 23, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44008, 349, 4, 23, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44009, 350, 2, 23, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44010, 351, 6, 46, 3, 782.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44011, 352, 2, 46, 3, 782.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44012, 353, 5, 46, 3, 782.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44013, 354, 5, 47, 3, 782.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44014, 355, 4, 47, 3, 782.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44015, 356, 4, 47, 3, 782.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44016, 357, 5, 48, 3, 594.83, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44017, 358, 6, 48, 3, 594.83, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44018, 359, 5, 48, 3, 594.83, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44019, 360, 2, 49, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44020, 361, 2, 49, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44021, 362, 2, 49, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44022, 363, 6, 50, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44023, 364, 2, 50, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44024, 365, 2, 50, 3, 337.22, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44025, 366, 4, 66, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44026, 367, 2, 66, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44027, 368, 5, 66, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44028, 369, 5, 67, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44029, 370, 2, 67, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44030, 371, 4, 67, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44031, 372, 6, 68, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44032, 373, 3, 68, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44033, 374, 2, 68, 3, 769.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44034, 375, 5, 69, 3, 564.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44035, 376, 5, 69, 3, 564.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44036, 377, 2, 69, 3, 564.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44037, 378, 5, 70, 3, 564.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44038, 379, 4, 70, 3, 564.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44039, 380, 6, 70, 3, 564.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44040, 381, 4, 71, 3, 364.09, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44041, 382, 4, 71, 3, 364.09, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44042, 383, 4, 71, 3, 364.09, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44043, 384, 4, 72, 3, 364.09, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44044, 385, 4, 72, 3, 364.09, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44045, 386, 2, 72, 3, 364.09, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44046, 387, 2, 73, 3, 264.05, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44047, 388, 5, 73, 3, 264.05, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44048, 389, 5, 73, 3, 264.05, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44049, 390, 3, 74, 3, 264.05, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44050, 391, 6, 74, 3, 264.05, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44051, 392, 6, 74, 3, 264.05, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44052, 393, 4, 75, 3, 404.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44053, 394, 4, 75, 3, 404.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44054, 395, 3, 75, 3, 404.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44055, 396, 5, 76, 3, 256.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44056, 397, 6, 76, 3, 256.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44057, 398, 6, 76, 3, 256.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44058, 399, 5, 88, 3, 1003.91, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44059, 400, 3, 88, 3, 1003.91, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44060, 401, 6, 88, 3, 1003.91, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44061, 402, 4, 89, 3, 742.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44062, 403, 6, 89, 3, 742.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44063, 404, 3, 89, 3, 742.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44064, 405, 2, 90, 3, 333.42, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44065, 406, 3, 90, 3, 333.42, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44066, 407, 6, 90, 3, 333.42, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44067, 408, 4, 91, 3, 333.42, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44068, 409, 6, 91, 3, 333.42, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44069, 410, 2, 91, 3, 333.42, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44070, 411, 5, 104, 3, 742.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44071, 412, 5, 104, 3, 742.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44072, 413, 6, 104, 3, 742.35, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44073, 414, 3, 29, 3, 24.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44074, 415, 6, 29, 3, 24.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44075, 416, 3, 29, 3, 24.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44076, 417, 6, 30, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44077, 418, 3, 30, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44078, 419, 4, 30, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44079, 420, 3, 51, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44080, 421, 3, 51, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44081, 422, 3, 51, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44082, 423, 6, 52, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44083, 424, 5, 52, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44084, 425, 3, 52, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44085, 426, 4, 53, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44086, 427, 3, 53, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44087, 428, 4, 53, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44088, 429, 2, 54, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44089, 430, 4, 54, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44090, 431, 6, 54, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44091, 432, 5, 55, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44092, 433, 4, 55, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44093, 434, 6, 55, 3, 49.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44094, 435, 4, 56, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44095, 436, 6, 56, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44096, 437, 4, 56, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44097, 438, 5, 77, 3, 175.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44098, 439, 4, 77, 3, 175.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44099, 440, 4, 77, 3, 175.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44100, 441, 5, 78, 3, 20.24, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44101, 442, 5, 78, 3, 20.24, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44102, 443, 4, 78, 3, 20.24, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44103, 444, 2, 79, 3, 121.46, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44104, 445, 2, 79, 3, 121.46, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44105, 446, 5, 79, 3, 121.46, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44106, 447, 3, 80, 3, 91.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44107, 448, 3, 80, 3, 91.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44108, 449, 2, 80, 3, 91.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44109, 450, 2, 92, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44110, 451, 5, 92, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44111, 452, 3, 92, 3, 34.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44112, 453, 2, 93, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44113, 454, 4, 93, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44114, 455, 5, 93, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44115, 456, 2, 94, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44116, 457, 5, 94, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44117, 458, 3, 94, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44118, 459, 3, 95, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44119, 460, 5, 95, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44120, 461, 3, 95, 3, 63.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44121, 462, 3, 96, 3, 4.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44122, 463, 5, 96, 3, 4.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44123, 464, 4, 96, 3, 4.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44124, 465, 6, 105, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44125, 466, 2, 105, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44126, 467, 2, 105, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44127, 468, 3, 106, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44128, 469, 6, 106, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44129, 470, 6, 106, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44130, 471, 6, 107, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44131, 472, 4, 107, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44132, 473, 2, 107, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44133, 474, 5, 108, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44134, 475, 5, 108, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44135, 476, 5, 108, 3, 53.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44136, 477, 6, 109, 3, 9.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44137, 478, 4, 109, 3, 9.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44138, 479, 3, 109, 3, 9.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44139, 480, 2, 110, 3, 9.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44140, 481, 6, 110, 3, 9.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44141, 482, 4, 110, 3, 9.50, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44142, 483, 2, 111, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44143, 484, 2, 111, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44144, 485, 6, 111, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44145, 486, 2, 112, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44146, 487, 4, 112, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44147, 488, 4, 112, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44148, 489, 4, 113, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44149, 490, 6, 113, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44150, 491, 4, 113, 3, 8.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44151, 492, 5, 114, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44152, 493, 4, 114, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44153, 494, 6, 114, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44154, 495, 6, 115, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44155, 496, 2, 115, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44156, 497, 3, 115, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44157, 498, 6, 116, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44158, 499, 3, 116, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44159, 500, 5, 116, 3, 74.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44160, 501, 4, 117, 3, 125.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44161, 502, 4, 117, 3, 125.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44162, 503, 3, 117, 3, 125.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44163, 504, 3, 118, 3, 159.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44164, 505, 3, 118, 3, 159.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44165, 506, 5, 118, 3, 159.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44166, 507, 6, 119, 3, 120.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44167, 508, 6, 119, 3, 120.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44168, 509, 3, 119, 3, 120.00, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44169, 510, 4, 132, 3, 32.60, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44170, 511, 4, 132, 3, 32.60, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44171, 512, 4, 132, 3, 32.60, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44172, 513, 5, 133, 3, 24.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44173, 514, 4, 133, 3, 24.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44174, 515, 4, 133, 3, 24.99, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44175, 516, 6, 134, 3, 21.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44176, 517, 3, 134, 3, 21.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44177, 518, 4, 134, 3, 21.49, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44178, 519, 2, 135, 3, 7.95, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44179, 520, 2, 135, 3, 7.95, 0.00);
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount) VALUES (44180, 521, 2, 135, 3, 7.95, 0.00);
SET IDENTITY_INSERT Sales.SalesOrderDetail OFF;
GO

-- Populate HumanResources.Employee
SET IDENTITY_INSERT HumanResources.Employee ON;
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (1, N'100013791', N'adventure-works\emp001', N'Chief Executive Officer', '1972-12-26', N'M', N'F', '2018-08-07', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (2, N'100027582', N'adventure-works\emp002', N'Vice President of Engineering', '1981-02-15', N'M', N'F', '2018-11-27', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (3, N'100041373', N'adventure-works\emp003', N'Engineering Manager', '1980-10-22', N'M', N'M', '2018-09-03', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (4, N'100055164', N'adventure-works\emp004', N'Engineering Manager', '1984-05-25', N'S', N'F', '2018-01-09', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (5, N'100068955', N'adventure-works\emp005', N'Senior Tool Designer', '1979-04-25', N'M', N'M', '2016-11-26', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (6, N'100082746', N'adventure-works\emp006', N'Senior Tool Designer', '1988-07-16', N'S', N'F', '2020-05-29', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (7, N'100096537', N'adventure-works\emp007', N'Design Engineer', '1991-08-04', N'M', N'M', '2017-06-15', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (8, N'100110328', N'adventure-works\emp008', N'Design Engineer', '1993-12-15', N'S', N'M', '2019-06-17', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (9, N'100124119', N'adventure-works\emp009', N'Design Engineer', '1979-09-24', N'S', N'M', '2016-05-27', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (10, N'100137910', N'adventure-works\emp010', N'Design Engineer', '1979-11-15', N'M', N'F', '2016-02-15', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (11, N'100151701', N'adventure-works\emp011', N'Research and Development Manager', '1975-08-30', N'S', N'F', '2016-12-14', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (12, N'100165492', N'adventure-works\emp012', N'Research and Development Engineer', '1989-07-16', N'M', N'F', '2023-06-26', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (13, N'100179283', N'adventure-works\emp013', N'Research and Development Engineer', '1976-01-23', N'M', N'F', '2021-06-01', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (14, N'100193074', N'adventure-works\emp014', N'Research and Development Engineer', '1975-03-17', N'M', N'F', '2016-01-05', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (15, N'100206865', N'adventure-works\emp015', N'Production Control Manager', '1992-12-19', N'S', N'M', '2017-09-26', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (16, N'100220656', N'adventure-works\emp016', N'Production Supervisor - WC60', '1993-07-05', N'M', N'M', '2021-02-24', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (17, N'100234447', N'adventure-works\emp017', N'Production Supervisor - WC60', '1985-08-24', N'M', N'M', '2021-04-11', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (18, N'100248238', N'adventure-works\emp018', N'Production Supervisor - WC60', '1990-11-19', N'M', N'M', '2017-09-25', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (19, N'100262029', N'adventure-works\emp019', N'Production Technician - WC60', '1971-12-02', N'M', N'F', '2018-02-07', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (20, N'100275820', N'adventure-works\emp020', N'Production Technician - WC60', '1983-09-21', N'S', N'F', '2017-07-29', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (21, N'100289611', N'adventure-works\emp021', N'Production Technician - WC60', '1970-12-23', N'S', N'F', '2023-02-07', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (22, N'100303402', N'adventure-works\emp022', N'Production Technician - WC60', '1993-05-26', N'S', N'M', '2021-11-22', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (23, N'100317193', N'adventure-works\emp023', N'Production Technician - WC60', '1976-12-16', N'M', N'F', '2016-07-12', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (24, N'100330984', N'adventure-works\emp024', N'Production Technician - WC60', '1984-10-16', N'M', N'M', '2021-01-17', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (25, N'100344775', N'adventure-works\emp025', N'Production Technician - WC60', '1991-10-01', N'M', N'M', '2021-04-01', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (26, N'100358566', N'adventure-works\emp026', N'Production Technician - WC60', '1989-12-01', N'S', N'M', '2017-09-20', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (27, N'100372357', N'adventure-works\emp027', N'Production Technician - WC50', '1993-02-18', N'S', N'F', '2017-07-11', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (28, N'100386148', N'adventure-works\emp028', N'Production Technician - WC50', '1985-01-02', N'S', N'M', '2020-04-13', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (29, N'100399939', N'adventure-works\emp029', N'Production Technician - WC50', '1978-09-05', N'M', N'M', '2019-04-16', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (30, N'100413730', N'adventure-works\emp030', N'Production Technician - WC50', '1985-05-04', N'M', N'F', '2020-12-24', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (31, N'100427521', N'adventure-works\emp031', N'Production Technician - WC50', '1991-01-23', N'M', N'M', '2019-09-22', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (32, N'100441312', N'adventure-works\emp032', N'Production Technician - WC50', '1981-04-24', N'S', N'M', '2021-01-03', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (33, N'100455103', N'adventure-works\emp033', N'Purchasing Manager', '1994-02-15', N'S', N'F', '2023-01-26', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (34, N'100468894', N'adventure-works\emp034', N'Buyer', '1992-04-27', N'S', N'F', '2016-09-28', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (35, N'100482685', N'adventure-works\emp035', N'Buyer', '1976-09-04', N'M', N'M', '2019-10-13', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (36, N'100496476', N'adventure-works\emp036', N'Buyer', '1987-11-02', N'M', N'M', '2018-09-22', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (37, N'100510267', N'adventure-works\emp037', N'Buyer', '1993-05-19', N'S', N'M', '2021-09-06', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (38, N'100524058', N'adventure-works\emp038', N'Marketing Manager', '1976-08-07', N'S', N'M', '2018-10-28', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (39, N'100537849', N'adventure-works\emp039', N'Marketing Specialist', '1970-09-24', N'S', N'M', '2021-06-09', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (40, N'100551640', N'adventure-works\emp040', N'Marketing Specialist', '1970-12-11', N'S', N'F', '2022-02-11', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (41, N'100565431', N'adventure-works\emp041', N'Marketing Specialist', '1983-07-18', N'S', N'F', '2019-06-22', 0);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (42, N'100579222', N'adventure-works\emp042', N'Sales Manager', '1984-07-27', N'M', N'F', '2018-04-22', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (43, N'100593013', N'adventure-works\emp043', N'Sales Manager', '1988-03-25', N'S', N'M', '2021-02-08', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (44, N'100606804', N'adventure-works\emp044', N'Sales Representative', '1984-09-29', N'S', N'M', '2023-07-13', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (45, N'100620595', N'adventure-works\emp045', N'Sales Representative', '1980-02-18', N'M', N'M', '2018-03-29', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (46, N'100634386', N'adventure-works\emp046', N'Sales Representative', '1974-09-04', N'M', N'F', '2020-12-10', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (47, N'100648177', N'adventure-works\emp047', N'Sales Representative', '1994-05-12', N'M', N'F', '2022-09-03', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (48, N'100661968', N'adventure-works\emp048', N'Sales Representative', '1982-07-13', N'M', N'M', '2018-12-24', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (49, N'100675759', N'adventure-works\emp049', N'Sales Representative', '1971-06-29', N'S', N'M', '2020-08-24', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (50, N'100689550', N'adventure-works\emp050', N'Database Administrator', '1987-12-01', N'S', N'M', '2017-04-16', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (51, N'100703341', N'adventure-works\emp051', N'Database Administrator', '1979-06-11', N'S', N'F', '2023-06-07', 1);
INSERT INTO HumanResources.Employee (BusinessEntityID, NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, Gender, HireDate, SalariedFlag) VALUES (52, N'100717132', N'adventure-works\emp052', N'Database Administrator', '1991-02-24', N'S', N'F', '2022-03-20', 1);
SET IDENTITY_INSERT HumanResources.Employee OFF;
GO

PRINT 'Database AdventureWorks_Latihan berhasil dibuat dan diisi data sampel Modul III.';
GO
