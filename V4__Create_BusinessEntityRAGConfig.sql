-- V4__Create_BusinessEntityRAGConfig.sql
-- This migration creates the BusinessEntityRAGConfig table.
CREATE TABLE dbo.BusinessEntityRAGConfig (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    RedExpression NVARCHAR(MAX) NOT NULL,   -- Logical expression for RED status
    AmberExpression NVARCHAR(MAX) NOT NULL, -- Logical expression for AMBER status
    GreenExpression NVARCHAR(MAX) NOT NULL, -- Logical expression for GREEN status
    Description NVARCHAR(200) NOT NULL,       -- RAG rule description
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedDate DATETIME2 NOT NULL DEFAULT GETDATE()
);
