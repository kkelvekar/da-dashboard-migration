-- V2__Drop_DomainSourceTypeGraphQL.sql
-- This migration drops the DomainSourceTypeGraphQL table if it exists.
IF OBJECT_ID('dbo.DomainSourceTypeGraphQL', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.DomainSourceTypeGraphQL;
END;
