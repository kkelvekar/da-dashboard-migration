/* =====================================================
   Declare variables for BusinessEntityConfig and RAG Config IDs
   ===================================================== */
DECLARE @BusinessEntityConfigID1 UNIQUEIDENTIFIER = NEWID();

DECLARE @BusinessEntityRAGConfigID1 UNIQUEIDENTIFIER = NEWID();
DECLARE @BusinessEntityRAGConfigID2 UNIQUEIDENTIFIER = NEWID();


/* =====================================================
   Insert sample data into BusinessEntityConfig using only one config (BusinessEntityConfigID1)
   ===================================================== */
INSERT INTO dbo.BusinessEntityConfig 
    (Id, Name, Metadata, CreatedDate, UpdatedDate)
VALUES 
    (
      @BusinessEntityConfigID1, 
      'Data Services REST Config', 
      '{ "services": [ { "name": "DataLoadStatisticService", "common": { "timeout": 5000, "retryPolicy": 3 }, "environments": [ { "name": "Dev", "baseUrl": "https://localhost:7080/" }, { "name": "QA", "baseUrl": "https://localhost:7080/" }, { "name": "PreProd", "baseUrl": "https://localhost:7080/" }, { "name": "Prod", "baseUrl": "https://localhost:7080/" } ] } ] }', 
      GETDATE(), 
      GETDATE()
    );


/* =====================================================
   Insert sample data into BusinessEntityRAGConfig
   ===================================================== */
INSERT INTO dbo.BusinessEntityRAGConfig
    (Id, RedExpression, AmberExpression, GreenExpression, Description, CreatedDate, UpdatedDate)
VALUES
    (
      @BusinessEntityRAGConfigID1,
      'jobStats.Any(j => j.JobStatus.ToLower() == "failed")',
      'jobStats.All(j => j.JobStatus.ToLower() == "success") && jobStats.Any(j => j.QualityStatus.ToLower() == "failed")',
      'jobStats.All(j => j.JobStatus.ToLower() == "success") && jobStats.All(j => j.QualityStatus.ToLower() == "success")',
      'Basic configuration: Red if any job fails; Amber if all jobs succeed but a quality check fails; Green if every job and quality check succeeds',
      GETDATE(),
      GETDATE()
    );

INSERT INTO dbo.BusinessEntityRAGConfig
    (Id, RedExpression, AmberExpression, GreenExpression, Description, CreatedDate, UpdatedDate)
VALUES
    (
      @BusinessEntityRAGConfigID2,
      'jobStats.Any(j => j.JobStatus.ToLower() == "failed") || !jobStats.Any(j => j.JobStart >= currentDate.AddHours(9))',
      'jobStats.All(j => j.JobStatus.ToLower() == "success") && jobStats.Any(j => j.QualityStatus.ToLower() == "failed")',
      'jobStats.All(j => j.JobStatus.ToLower() == "success") && jobStats.All(j => j.QualityStatus.ToLower() == "success")',
      'Extended configuration: Red if any job fails or if no job starts after 9 AM; Amber if all jobs succeed but at least one quality check fails; Green if all pass.',
      GETDATE(),
      GETDATE()
    );


/* =====================================================
   Insert sample data into BusinessEntity
   ===================================================== */
-- Business Entity: Account Static: Portfolios
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, DataDomainSourceConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
    (
      NEWID(), 
      'Data Services', 
      'Account Static: Portfolios', 
      'Portfolios', 
      'Portal, Portfolio Services, Currency', 
      @BusinessEntityConfigID1, 
      @BusinessEntityRAGConfigID1, 
      1, 
      GETDATE(), 
      GETDATE()
    );

-- Business Entity: Account Static: GIM SCD Mapping
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, DataDomainSourceConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
    (
      NEWID(), 
      'Data Services', 
      'Account Static: GIM SCD Mapping', 
      'GIM SCD Mapping', 
      'Portal, Currency, Optimizer', 
      @BusinessEntityConfigID1, 
      @BusinessEntityRAGConfigID2, 
      1, 
      GETDATE(), 
      GETDATE()
    );

-- Business Entity: Account Static: Strategies
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, DataDomainSourceConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
    (
      NEWID(), 
      'Data Services', 
      'Account Static: Strategies', 
      'Strategies', 
      'Strategy Manager, Portfolio Services', 
      @BusinessEntityConfigID1, 
      @BusinessEntityRAGConfigID1, 
      1, 
      GETDATE(), 
      GETDATE()
    );

-- Business Entity: Account Static: Internal Contracts
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, DataDomainSourceConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
    (
      NEWID(), 
      'Data Services', 
      'Account Static: Internal Contracts', 
      'Internal Contracts', 
      'Portal, Optimizer, Currency', 
      @BusinessEntityConfigID1, 
      @BusinessEntityRAGConfigID2, 
      1, 
      GETDATE(), 
      GETDATE()
    );
