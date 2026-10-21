-- Run in the target Helios database before deploying the Inventory module.
-- New application-owned tables only. No standard Helios objects are changed.
SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF OBJECT_ID(N'dbo.TabInvHead', N'U') IS NULL OR OBJECT_ID(N'dbo.TabInvItem', N'U') IS NULL
    THROW 50000, N'Nejprve vyberte databázi Heliosu obsahující TabInvHead a TabInvItem.', 1;

IF OBJECT_ID(N'dbo.eTab_IntranetInvCheck', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.eTab_IntranetInvCheck (
        ID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_eTab_IntranetInvCheck PRIMARY KEY,
        InventoryId int NOT NULL,
        ItemId int NOT NULL,
        CheckedAt datetime2(3) NOT NULL CONSTRAINT DF_IntranetInvCheck_Time DEFAULT SYSDATETIME(),
        CheckedBy nvarchar(128) NOT NULL,
        InventoryQuantity numeric(19,6) NOT NULL,
        UnitQuantity numeric(19,6) NOT NULL,
        StockQuantity numeric(19,6) NOT NULL,
        Conversion float NOT NULL,
        Unit nvarchar(10) NULL,
        PreviousInventoryQuantity numeric(19,6) NOT NULL,
        PreviousUnitQuantity numeric(19,6) NOT NULL
    );
    CREATE INDEX IX_IntranetInvCheck_Item ON dbo.eTab_IntranetInvCheck(ItemId, ID DESC);
    CREATE INDEX IX_IntranetInvCheck_Inventory ON dbo.eTab_IntranetInvCheck(InventoryId, ID);
END;

IF OBJECT_ID(N'dbo.eTab_IntranetInvDiscrepancy', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.eTab_IntranetInvDiscrepancy (
        ID bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_eTab_IntranetInvDiscrepancy PRIMARY KEY,
        InventoryId int NOT NULL,
        SerialNumber nvarchar(100) NOT NULL,
        Note nvarchar(1000) NOT NULL,
        ReportedAt datetime2(3) NOT NULL CONSTRAINT DF_IntranetInvDiscrepancy_Time DEFAULT SYSDATETIME(),
        ReportedBy nvarchar(128) NOT NULL,
        CONSTRAINT UQ_IntranetInvDiscrepancy UNIQUE(InventoryId, SerialNumber)
    );
END;
-- Deliberately no FK to Helios tables: deleting a test inventory must not be
-- blocked by the application's audit history, nor cascade-delete that history.
COMMIT TRANSACTION;
