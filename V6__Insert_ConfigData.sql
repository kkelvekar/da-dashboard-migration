-- 1) Declare variables for configuration IDs
DECLARE @BusinessEntityConfigId UNIQUEIDENTIFIER = NEWID();
DECLARE @BusinessEntityRAGConfigId UNIQUEIDENTIFIER    = NEWID();

-- 2) Insert 1 row into BusinessEntityConfig (with one-line JSON)
INSERT INTO dbo.BusinessEntityConfig
  (Id,Name,Metadata,CreatedDate,UpdatedDate)
VALUES
(
  @BusinessEntityConfigId,
  'Data Load Statistic Service',
  '{"environments":[{"name":"Local","baseUrl":"http://localhost:5050/data-load-statistics/"},{"name":"Dev","baseUrl":"https://platform.cedar-dev.azpriv-cloud.ubs.net/data-load-statistics/"},{"name":"Test","baseUrl":"https://platform.cedar-dev.azpriv-cloud.ubs.net/data-load-statistics/"},{"name":"PreProd","baseUrl":"https://platform.cedar-dev.azpriv-cloud.ubs.net/data-load-statistics/"},{"name":"Prod","baseUrl":"https://platform.cedar-dev.azpriv-cloud.ubs.net/data-load-statistics/"}]}',
  GETDATE(),
  GETDATE()
);

-- 3) Insert 1 row into BusinessEntityRAGConfig (single config for all entities)
INSERT INTO dbo.BusinessEntityRAGConfig
  (Id,RedExpression,AmberExpression,GreenExpression,Description,CreatedDate,UpdatedDate)
VALUES
(
  @BusinessEntityRAGConfigId,
  '!jobStats.Any() || jobStats.Count(j => j.JobStatus.ToLower() == "fail" && j.QualityStatus.ToLower() == "fail") >= 2 || (jobStats.Any(j => j.JobStatus.ToLower() == "fail" && j.QualityStatus.ToLower() == "fail") && !jobStats.Any(j => j.JobStatus.ToLower() == "success" && j.QualityStatus.ToLower() == "pass"))',
  'jobStats.Any(j => j.JobStatus.ToLower() == "success" && j.QualityStatus.ToLower() == "fail" && j.RecordFailed > 0)',
  'jobStats.All(j => j.JobStatus.ToLower() == "success" && j.QualityStatus.ToLower() == "pass") || (jobStats.OrderBy(j => j.JobStart).First().JobStatus.ToLower() == "fail" && jobStats.OrderBy(j => j.JobStart).First().QualityStatus.ToLower() == "fail" && jobStats.OrderBy(j => j.JobStart).Skip(1).All(j => j.JobStatus.ToLower() == "success" && j.QualityStatus.ToLower() == "pass"))',
  'Data Service: RAG Config',
  GETDATE(),
  GETDATE()
);


-- 4) Insert rows into BusinessEntity using the Excel-exported values.
--    Name = Entity Name, DisplayName = title-cased DomainName: EntityName (or entity alone if same),
--    DependentFunctionalities = as mapped (blanks left where none).
DECLARE
  @BusinessEntityConfigId UNIQUEIDENTIFIER = NEWID(),
  @BusinessEntityRAGConfigId UNIQUEIDENTIFIER    = NEWID();

INSERT INTO dbo.BusinessEntity
  (Id,ApplicationOwner,Name,DisplayName,DependentFunctionalities,BusinessEntityConfigId,BusinessEntityRAGConfigId,IsActive,CreatedDate,UpdatedDate)
VALUES
  -- BENCHMARKS
  (NEWID(),'Data Services','BENCHMARKS','Benchmarks','Strategy Manager',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','COMPOSITIONS','Benchmarks: Compositions','Strategy Manager',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','WEIGHTALLOCATIONS','Benchmarks: Weightallocations','Strategy Manager',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

  -- ACCOUNT STATIC
  (NEWID(),'Data Services','PORTFOLIO GIM SCD MAPPING','Account Static: Portfolio Gim Scd Mapping','Portal, Portfolio Services, Currency',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','STRATEGIC PORTFOLIOS STRATEGIES','Account Static: Strategic Portfolios Strategies','Portal, Portfolio Services, Currency',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','STRATEGIC PORTFOLIOS INTERNAL CONTACTS','Account Static: Strategic Portfolios Internal Contacts','Portal, Portfolio Services, Currency',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','STRATEGIC PORTFOLIOS','Account Static: Strategic Portfolios','Portal, Portfolio Services, Currency',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','STRATEGIC PORTFOLIOS BANK ACCOUNTS','Account Static: Strategic Portfolios Bank Accounts','Portal, Portfolio Services, Currency',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

  -- TRANSACTIONAL
  (NEWID(),'Data Services','TRANSACTIONS','Transactional: Transactions','Currency',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','PROJECTED CASH TRANSACTIONS','Transactional: Projected Cash Transactions','Currency',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

  -- PRICING
  (NEWID(),'Data Services','FXRATE','Pricing: Fxrate','Portal, Portfolio Services, Currency',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','SECURITY PRICES','Pricing: Security Prices','Portal, Portfolio Services',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

  -- ANALYTICS
  (NEWID(),'Data Services','PORTFOLIO HOLDING ANALYTICS','Analytics: Portfolio Holding Analytics','Optimizer',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','BENCHMARK HOLDING ANALYTICS','Analytics: Benchmark Holding Analytics','Optimizer',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','SECURITY ANALYTICS','Analytics: Security Analytics','Portal',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

  -- PRODUCT STATIC
  (NEWID(),'Data Services','FUNDS','Product Static: Funds','Strategy Manager',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','MANDATES','Product Static: Mandates','Strategy Manager',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','SHARE CLASSES','Product Static: Share Classes','Strategy Manager',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','STRATEGIES','Product Static: Strategies','Strategy Manager',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
  (NEWID(),'Data Services','PORTFOLIO REFERENCE','Product Static: Portfolio Reference','Strategy Manager',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

  -- SECURITIES
  (NEWID(),'Data Services','SECURITIES','Securities','Portal, Portfolio Services',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

  -- RISK DATA
(NEWID(),'Data Services','ASSETS','Risk Data: Assets',NULL,@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
(NEWID(),'Data Services','COVARIANCE','Risk Data: Covariance','Optimizer',@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
(NEWID(),'Data Services','FACTORS','Risk Data: Factors',NULL,@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
(NEWID(),'Data Services','LOADINGS','Risk Data: Loadings',NULL,@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

-- ACCOUNT SETTINGS
(NEWID(),'Data Services','SETTINGS','Account Settings: Settings',NULL,@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),

-- HOLIDAY CALENDAR
(NEWID(),'Data Services','COUNTRIES','Holiday Calendar: Countries',NULL,@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
(NEWID(),'Data Services','CURRENCIES','Holiday Calendar: Currencies',NULL,@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
(NEWID(),'Data Services','EXCHANGE','Holiday Calendar: Exchange',NULL,@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE()),
(NEWID(),'Data Services','TRADING HOURS','Holiday Calendar: Trading Hours',NULL,@BusinessEntityConfigId,@BusinessEntityRAGConfigId,1,GETDATE(),GETDATE());
