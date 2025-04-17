/* =====================================================
   1) Declare variables for configuration IDs
      - 1 BusinessEntityConfig (using @BusinessEntityConfigId1)
      - 2 BusinessEntityRAGConfig (using @BusinessEntityRAGConfigID1 and @BusinessEntityRAGConfigID2)
   ===================================================== */
DECLARE @BusinessEntityConfigId1 UNIQUEIDENTIFIER = NEWID();

DECLARE @BusinessEntityRAGConfigID1 UNIQUEIDENTIFIER = NEWID();
DECLARE @BusinessEntityRAGConfigID2 UNIQUEIDENTIFIER = NEWID();


/* =====================================================
   2) Insert 1 row into BusinessEntityConfig (referenced by all entities)
   ===================================================== */
INSERT INTO dbo.BusinessEntityConfig
    (Id, Name, Metadata, CreatedDate, UpdatedDate)
VALUES
(
  @BusinessEntityConfigId1,
  'Data Load Statistic Service',
  '{ "environments": [ { "name": "Dev", "baseUrl": "https://localhost:7080/" }, { "name": "QA", "baseUrl": "https://localhost:7080/" }, { "name": "PreProd", "baseUrl": "https://localhost:7080/" }, { "name": "Prod", "baseUrl": "https://localhost:7080/" } ] }',
  GETDATE(),
  GETDATE()
);


/* =====================================================
   3) Insert 2 rows into BusinessEntityRAGConfig
   ===================================================== */
-- Basic RAG Configuration
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

-- Extended RAG Configuration
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
   4) Insert 14 rows into BusinessEntity with the updated list
   ===================================================== */

/* --- First 7 entities (using RAGConfigID1) --- */

-- 1) Account Static: Bank Accounts
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Account Static: Bank Accounts',
  'Bank Accounts',
  'Portal, Portfolio Services',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID1,
  1,
  GETDATE(),
  GETDATE()
);

-- 2) Account Static: GIN SOO Mapping
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Account Static: GIN SOO Mapping',
  'GIN SOO Mapping',
  'Portal, Currency, Optimizer',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID1,
  1,
  GETDATE(),
  GETDATE()
);

-- 3) Account Static: Internal Contacts
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Account Static: Internal Contacts',
  'Internal Contacts',
  'Portal, Optimizer, Currency',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID1,
  1,
  GETDATE(),
  GETDATE()
);

-- 4) Account Static: Portfolios
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Account Static: Portfolios',
  'Portfolios',
  'Portal, Portfolio Services, Currency',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID1,
  1,
  GETDATE(),
  GETDATE()
);

-- 5) Account Static: Strategies
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Account Static: Strategies',
  'Strategies',
  'Strategy Manager, Portfolio Services',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID1,
  1,
  GETDATE(),
  GETDATE()
);

-- 6) Benchmark
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Benchmark',
  'Benchmark',
  'Strategy Manager, Optimizer',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID1,
  1,
  GETDATE(),
  GETDATE()
);

-- 7) Benchmarks: Composition
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Benchmarks: Composition',
  'Benchmarks: Composition',
  'Strategy Manager, Currency',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID1,
  1,
  GETDATE(),
  GETDATE()
);


/* --- Last 7 entities (using RAGConfigID2) --- */

-- 8) Benchmarks: Weight Allocation
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Benchmarks: Weight Allocation',
  'Benchmarks: Weight Allocation',
  'Optimizer, Portfolio Services',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID2,
  1,
  GETDATE(),
  GETDATE()
);

-- 9) FI Analytics: Benchmark Holding
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'FI Analytics: Benchmark Holding',
  'FI Analytics: Benchmark Holding',
  'Optimizer, Currency',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID2,
  1,
  GETDATE(),
  GETDATE()
);

-- 10) FI Analytics: Portfolio Holding
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'FI Analytics: Portfolio Holding',
  'FI Analytics: Portfolio Holding',
  'Optimizer, Currency, Portfolio Services',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID2,
  1,
  GETDATE(),
  GETDATE()
);

-- 11) FX Rate
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'FX Rate',
  'FX Rate',
  'Portal, Currency',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID2,
  1,
  GETDATE(),
  GETDATE()
);

-- 12) Securities
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Securities',
  'Securities',
  'Portal, Portfolio Services, Strategy Manager',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID2,
  1,
  GETDATE(),
  GETDATE()
);

-- 13) Security Pricing
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Security Pricing',
  'Security Pricing',
  'Portal, Portfolio Services, Currency',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID2,
  1,
  GETDATE(),
  GETDATE()
);

-- 14) Transactions
INSERT INTO dbo.BusinessEntity
    (Id, ApplicationOwner, Name, DisplayName, DependentFunctionalities, BusinessEntityConfigId, BusinessEntityRAGConfigId, IsActive, CreatedDate, UpdatedDate)
VALUES
(
  NEWID(),
  'Data Services',
  'Transactions',
  'Transactions',
  'Portal, Portfolio Services, Currency',
  @BusinessEntityConfigId1,
  @BusinessEntityRAGConfigID2,
  1,
  GETDATE(),
  GETDATE()
);
