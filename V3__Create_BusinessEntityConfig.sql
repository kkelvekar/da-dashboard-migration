-- V3__Create_BusinessEntityConfig.sql
-- This migration creates the BusinessEntityConfig table.
CREATE TABLE dbo.BusinessEntityConfig (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Metadata NVARCHAR(MAX) NULL,  -- JSON formatted metadata
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedDate DATETIME2 NOT NULL DEFAULT GETDATE()
);
