-- V5__Create_BusinessEntity.sql
-- This migration creates the main BusinessEntity table with foreign key references.
CREATE TABLE dbo.BusinessEntity (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    ApplicationOwner NVARCHAR(100) NOT NULL,  -- Owner of the data (e.g., Data Services)
    Name NVARCHAR(100) NOT NULL,               -- Business Entity identifier
    DisplayName NVARCHAR(100) NOT NULL,        -- Display name for the Business Entity
    DependentFunctionalities NVARCHAR(MAX) NULL, -- List (or JSON array) of functionalities impacted
    BusinessEntityConfigId UNIQUEIDENTIFIER NOT NULL, -- FK referencing BusinessEntityConfig
    BusinessEntityRAGConfigId UNIQUEIDENTIFIER NOT NULL, -- FK referencing BusinessEntityRAGConfig
    IsActive BIT NOT NULL DEFAULT 1,           -- Indicates if the entity is active
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_BusinessEntity_BusinessEntityConfig
        FOREIGN KEY (BusinessEntityConfigId) REFERENCES dbo.BusinessEntityConfig(Id),
    CONSTRAINT FK_BusinessEntity_BusinessEntityRAGConfig
        FOREIGN KEY (BusinessEntityRAGConfigId) REFERENCES dbo.BusinessEntityRAGConfig(Id)
);
