-- V1__Drop_DataDomainConfig.sql
-- This migration drops the DataDomainConfig table if it exists.
IF OBJECT_ID('dbo.DataDomainConfig', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.DataDomainConfig;
END;
