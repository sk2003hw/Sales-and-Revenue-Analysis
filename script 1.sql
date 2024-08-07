USE sales;

-- Drop tables if they exist
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS StoreLocations;
DROP TABLE IF EXISTS SalesTeam;
DROP TABLE IF EXISTS Regions;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);

-- Create Regions table
CREATE TABLE Regions (
    StateCode CHAR(2) PRIMARY KEY,
    State VARCHAR(50),
    Region VARCHAR(50)
);

-- Create SalesTeam table
CREATE TABLE SalesTeam (
    SalesTeamID INT PRIMARY KEY,
    SalesTeamName VARCHAR(100),
    Region VARCHAR(50)
);

-- Create StoreLocations table
CREATE TABLE StoreLocations (
    StoreID INT PRIMARY KEY,
    CityName VARCHAR(100),
    County VARCHAR(100),
    StateCode CHAR(2),
    State VARCHAR(50),
    Type VARCHAR(50),
    Latitude DECIMAL(10, 5),
    Longitude DECIMAL(10, 5),
    AreaCode INT,
    Population INT,
    HouseholdIncome INT,
    MedianIncome INT,
    LandArea BIGINT,
    WaterArea BIGINT,
    TimeZone VARCHAR(50),
    FOREIGN KEY (StateCode) REFERENCES Regions(StateCode)
        ON DELETE CASCADE
);

-- Create Orders table
CREATE TABLE Orders (
    OrderNumber VARCHAR(50) PRIMARY KEY,
    SalesChannel VARCHAR(50),
    WarehouseCode VARCHAR(50),
    ProcuredDate DATE,
    OrderDate DATE,
    ShipDate DATE,
    DeliveryDate DATE,
    SalesTeamID INT,
    CustomerID INT,
    StoreID INT,
    ProductID INT,
    OrderQuantity INT,
    DiscountApplied DECIMAL(5, 3),
    UnitPrice DECIMAL(10, 2),
    UnitCost DECIMAL(10, 2),
    FOREIGN KEY (SalesTeamID) REFERENCES SalesTeam(SalesTeamID)
        ON DELETE SET NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON DELETE CASCADE,
    FOREIGN KEY (StoreID) REFERENCES StoreLocations(StoreID)
        ON DELETE SET NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON DELETE SET NULL
);

