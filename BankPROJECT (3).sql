CREATE DATABASE BankProject;
GO

USE BankProject;
GO

--30 table creations

--1--CUSTOMERS
CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(255),
    NationalID VARCHAR(20) UNIQUE,
    TaxID VARCHAR(20) UNIQUE,
    EmploymentStatus VARCHAR(50),
    AnnualIncome DECIMAL(18,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Customers
(
    FullName,
    DOB,
    Email,
    PhoneNumber,
    Address,
    NationalID,
    TaxID,
    EmploymentStatus,
    AnnualIncome,
    CreatedAt,
    UpdatedAt
)
SELECT
    CONCAT('Customer ', N),
    DATEADD(DAY, -(N % 18000), GETDATE()),
    CONCAT('customer', N, '@gmail.com'),
    CONCAT('+99890', RIGHT('0000000' + CAST(N AS VARCHAR(10)), 7)),
    CONCAT('Address ', N),
    CONCAT('NID', FORMAT(N, '0000000000')),
    CONCAT('TAX', FORMAT(N, '0000000000')),
    CASE N % 4
        WHEN 0 THEN 'Employed'
        WHEN 1 THEN 'Self-Employed'
        WHEN 2 THEN 'Student'
        ELSE 'Retired'
    END,
    CAST(1000 + (N * 10) AS DECIMAL(18,2)),
    GETDATE(),
    GETDATE()
FROM Numbers;
GO


--2-- Employees (BranchID vaqtincha NULL)
CREATE TABLE Employees
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT NULL,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(18,2),
    HireDate DATE,
    Status VARCHAR(20)
);
GO
--3-. Branches
CREATE TABLE Branches
(
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    ManagerID INT,
    ContactNumber VARCHAR(20),

    CONSTRAINT FK_Branches_Employees
        FOREIGN KEY (ManagerID)
        REFERENCES Employees(EmployeeID)
);
GO
--4--. Employees ga BranchID FK qo‘shamiz
ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Branches
FOREIGN KEY (BranchID)
REFERENCES Branches(BranchID);
GO
--5. Accounts
CREATE TABLE Accounts
(
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountType VARCHAR(30) NOT NULL,
    Balance DECIMAL(18,2) NOT NULL,
    Currency VARCHAR(10) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    BranchID INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Accounts_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    CONSTRAINT FK_Accounts_Branches
        FOREIGN KEY (BranchID)
        REFERENCES Branches(BranchID)
);
GO
--6-. Transactions (Country qo‘shilgan)
CREATE TABLE Transactions
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL,

    TransactionType VARCHAR(20) NOT NULL
        CHECK (TransactionType IN
        ('Deposit','Withdrawal','Transfer','Payment')),

    Amount DECIMAL(18,2) NOT NULL,
    Currency VARCHAR(10) NOT NULL,
    [Date] DATETIME NOT NULL,
    Status VARCHAR(20) NOT NULL,
    ReferenceNo VARCHAR(50) UNIQUE,
    Country VARCHAR(50) NOT NULL,

    CONSTRAINT FK_Transactions_Accounts
        FOREIGN KEY (AccountID)
        REFERENCES Accounts(AccountID)
);
GO



--++++++++++++++++++++++++++++++++++++++++++++++++++++++
INSERT INTO Transactions
(
    AccountID,
    TransactionType,
    Amount,
    Currency,
    [Date],
    Status,
    ReferenceNo,
    Country
)
VALUES
(
    1,
    'Transfer',
    20000,
    'USD',
    '2025-06-01 10:30:00',
    'Completed',
    'TEST001',
    'USA'
);

--++++++++++++++++++++++++++++++++++++++++++++++

INSERT INTO Transactions
(
    AccountID,
    TransactionType,
    Amount,
    Currency,
    [Date],
    Status,
    ReferenceNo,
    Country
)
VALUES
(11,'Transfer',15000,'USD','2025-06-01 10:00:00','Completed','TEST1','USA'),
(22,'Transfer',16000,'USD','2025-06-01 10:10:00','Completed','TEST2','USA'),
(33,'Transfer',17000,'USD','2025-06-01 10:20:00','Completed','TEST3','USA'),
(45,'Transfer',18000,'USD','2025-06-01 10:30:00','Completed','TEST4','USA'),
(51,'Transfer',19000,'USD','2025-06-01 10:40:00','Completed','TEST5','USA'),
(62,'Transfer',20000,'USD','2025-06-01 10:50:00','Completed','TEST6','USA'),
(78,'Transfer',21000,'USD','2025-06-01 11:00:00','Completed','TEST7','USA'),
(84,'Transfer',22000,'USD','2025-06-01 11:10:00','Completed','TEST8','USA'),
(90,'Transfer',23000,'USD','2025-06-01 11:20:00','Completed','TEST9','USA'),
(105,'Transfer',24000,'USD','2025-06-01 11:30:00','Completed','TEST10','USA');

--1. Employees — 10000 row
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Employees
(
    BranchID,
    FullName,
    Position,
    Department,
    Salary,
    HireDate,
    Status
)
SELECT
    NULL,
    CONCAT('Employee ', N),
    CASE N % 5
        WHEN 0 THEN 'Manager'
        WHEN 1 THEN 'Analyst'
        WHEN 2 THEN 'Officer'
        WHEN 3 THEN 'Cashier'
        ELSE 'Supervisor'
    END,
    CASE N % 4
        WHEN 0 THEN 'HR'
        WHEN 1 THEN 'IT'
        WHEN 2 THEN 'Operations'
        ELSE 'Finance'
    END,
    3000 + (N * 2),
    DATEADD(DAY,-(N%3000),GETDATE()),
    CASE N % 2
        WHEN 0 THEN 'Active'
        ELSE 'Inactive'
    END
FROM Numbers;
GO

--Tekshiring:

--SELECT COUNT(*) FROM Employees;

--Natija: 10000

--2. Branches — 10000 row
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Branches
(
    BranchName,
    Address,
    City,
    State,
    Country,
    ManagerID,
    ContactNumber
)
SELECT
    CONCAT('Branch ',N),
    CONCAT('Address ',N),
    CONCAT('City ',N%100),
    CONCAT('State ',N%20),
    CASE N%5
        WHEN 0 THEN 'USA'
        WHEN 1 THEN 'UK'
        WHEN 2 THEN 'Germany'
        WHEN 3 THEN 'UAE'
        ELSE 'Uzbekistan'
    END,
    N,
    CONCAT('+99890',RIGHT('0000000'+CAST(N AS VARCHAR(10)),7))
FROM Numbers;
GO

--Tekshiring:

--SELECT COUNT(*) FROM Branches;

--Natija: 10000

--3. Employees.BranchID ni to‘ldiramiz

--Endi FK mavjud bo‘lgani uchun:

UPDATE Employees
SET BranchID = EmployeeID;
GO

--Tekshirish:

--SELECT TOP 10 EmployeeID, BranchID
--FROM Employees;
--4. Accounts — 10000 row
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Accounts
(
    CustomerID,
    AccountType,
    Balance,
    Currency,
    Status,
    BranchID,
    CreatedDate
)
SELECT
    N,
    CASE N%4
        WHEN 0 THEN 'Savings'
        WHEN 1 THEN 'Checking'
        WHEN 2 THEN 'Business'
        ELSE 'Current'
    END,
    CAST(1000 + (RAND(CHECKSUM(NEWID()))*500000) AS DECIMAL(18,2)),
    CASE N%4
        WHEN 0 THEN 'USD'
        WHEN 1 THEN 'UZS'
        WHEN 2 THEN 'EUR'
        ELSE 'GBP'
    END,
    'Active',
    N,
    DATEADD(DAY,-(N%2000),GETDATE())
FROM Numbers;
GO

--Tekshirish:

--SELECT COUNT(*) FROM Accounts;

--Natija: 10000

--5. Transactions — 10000 row
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Transactions
(
    AccountID,
    TransactionType,
    Amount,
    Currency,
    [Date],
    Status,
    ReferenceNo,
    Country
)
SELECT
    N,
    CASE N%4
        WHEN 0 THEN 'Deposit'
        WHEN 1 THEN 'Withdrawal'
        WHEN 2 THEN 'Transfer'
        ELSE 'Payment'
    END,
    CAST(100 + (RAND(CHECKSUM(NEWID()))*50000) AS DECIMAL(18,2)),
    CASE N%4
        WHEN 0 THEN 'USD'
        WHEN 1 THEN 'UZS'
        WHEN 2 THEN 'EUR'
        ELSE 'GBP'
    END,
    DATEADD(MINUTE,-(N%10000),GETDATE()),
    'Completed',
    CONCAT('REF',FORMAT(N,'000000')),
    CASE N%5
        WHEN 0 THEN 'USA'
        WHEN 1 THEN 'UK'
        WHEN 2 THEN 'Germany'
        WHEN 3 THEN 'UAE'
        ELSE 'Uzbekistan'
    END
FROM Numbers;
GO

--Tekshirish:

--SELECT COUNT(*) FROM Transactions;






--6. CreditCards
CREATE TABLE CreditCards
(
    CardID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CardNumber VARCHAR(20) UNIQUE NOT NULL,
    CardType VARCHAR(20),
    CVV VARCHAR(4),
    ExpiryDate DATE,
    [Limit] DECIMAL(18,2),
    Status VARCHAR(20),

    CONSTRAINT FK_CreditCards_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--Insert
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO CreditCards
(
    CustomerID,
    CardNumber,
    CardType,
    CVV,
    ExpiryDate,
    [Limit],
    Status
)
SELECT
    N,
    CONCAT('8600',RIGHT('000000000000'+CAST(N AS VARCHAR(20)),12)),
    CASE N%3
        WHEN 0 THEN 'Visa'
        WHEN 1 THEN 'MasterCard'
        ELSE 'UzCard'
    END,
    RIGHT('000'+CAST((N%999)+1 AS VARCHAR(3)),3),
    DATEADD(YEAR,3,GETDATE()),
    5000 + (N*2),
    'Active'
FROM Numbers;
GO
--7. CreditCardTransactions
CREATE TABLE CreditCardTransactions
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    CardID INT NOT NULL,
    Merchant VARCHAR(100),
    Amount DECIMAL(18,2),
    Currency VARCHAR(10),
    [Date] DATETIME,
    Status VARCHAR(20),

    CONSTRAINT FK_CreditCardTransactions_CreditCards
        FOREIGN KEY (CardID)
        REFERENCES CreditCards(CardID)
);
GO
--Insert
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO CreditCardTransactions
(
    CardID,
    Merchant,
    Amount,
    Currency,
    [Date],
    Status
)
SELECT
    N,
    CONCAT('Merchant ',N%500),
    CAST(10 + (RAND(CHECKSUM(NEWID()))*5000) AS DECIMAL(18,2)),
    CASE N%4
        WHEN 0 THEN 'USD'
        WHEN 1 THEN 'UZS'
        WHEN 2 THEN 'EUR'
        ELSE 'GBP'
    END,
    DATEADD(MINUTE,-N,GETDATE()),
    'Completed'
FROM Numbers;
GO
--8. OnlineBankingUsers
CREATE TABLE OnlineBankingUsers
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Username VARCHAR(100) UNIQUE,
    PasswordHash VARCHAR(255),
    LastLogin DATETIME,

    CONSTRAINT FK_OnlineBankingUsers_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--Insert
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO OnlineBankingUsers
(
    CustomerID,
    Username,
    PasswordHash,
    LastLogin
)
SELECT
    N,
    CONCAT('user',N),
    CONCAT('HASH_',N),
    DATEADD(HOUR,-(N%500),GETDATE())
FROM Numbers;
GO
--9. BillPayments
CREATE TABLE BillPayments
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    BillerName VARCHAR(100),
    Amount DECIMAL(18,2),
    [Date] DATETIME,
    Status VARCHAR(20),

    CONSTRAINT FK_BillPayments_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--Insert
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO BillPayments
(
    CustomerID,
    BillerName,
    Amount,
    [Date],
    Status
)
SELECT
    N,
    CASE N%4
        WHEN 0 THEN 'Electricity'
        WHEN 1 THEN 'Water'
        WHEN 2 THEN 'Internet'
        ELSE 'Gas'
    END,
    CAST(50 + (RAND(CHECKSUM(NEWID()))*1000) AS DECIMAL(18,2)),
    DATEADD(DAY,-(N%365),GETDATE()),
    'Paid'
FROM Numbers;
GO
--Tekshirish
SELECT COUNT(*) FROM CreditCards;
SELECT COUNT(*) FROM CreditCardTransactions;
SELECT COUNT(*) FROM OnlineBankingUsers;
SELECT COUNT(*) FROM BillPayments;






--10. MobileBankingTransactions
CREATE TABLE MobileBankingTransactions
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    DeviceID VARCHAR(100),
    AppVersion VARCHAR(20),
    TransactionType VARCHAR(30),
    Amount DECIMAL(18,2),
    [Date] DATETIME,

    CONSTRAINT FK_MobileBankingTransactions_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--Insert
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO MobileBankingTransactions
(
    CustomerID,
    DeviceID,
    AppVersion,
    TransactionType,
    Amount,
    [Date]
)
SELECT
    N,
    CONCAT('DEVICE_',N),
    CONCAT('v',1+(N%5),'.',N%10),
    CASE N%4
        WHEN 0 THEN 'Transfer'
        WHEN 1 THEN 'Payment'
        WHEN 2 THEN 'Deposit'
        ELSE 'Withdrawal'
    END,
    CAST(100 + RAND(CHECKSUM(NEWID()))*10000 AS DECIMAL(18,2)),
    DATEADD(MINUTE,-N,GETDATE())
FROM Numbers;
GO
--11. Loans
CREATE TABLE Loans
(
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    LoanType VARCHAR(30),
    Amount DECIMAL(18,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20),

    CONSTRAINT FK_Loans_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--Insert (query natija qaytarishi uchun)

--Bu yerda har 1000 ta mijozdan bir qismiga 2 tadan ACTIVE loan beramiz.

;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Loans
(
    CustomerID,
    LoanType,
    Amount,
    InterestRate,
    StartDate,
    EndDate,
    Status
)
SELECT
    CASE
        WHEN N <= 2000 THEN ((N-1)%1000)+1
        ELSE N
    END,
    CASE N%4
        WHEN 0 THEN 'Mortgage'
        WHEN 1 THEN 'Personal'
        WHEN 2 THEN 'Auto'
        ELSE 'Business'
    END,
    5000 + (N*20),
    5 + (N%10),
    GETDATE(),
    DATEADD(YEAR,5,GETDATE()),
    CASE
        WHEN N <= 2000 THEN 'Active'
        ELSE CASE N%3
            WHEN 0 THEN 'Active'
            WHEN 1 THEN 'Closed'
            ELSE 'Pending'
        END
    END
FROM Numbers;
GO

--Bu insert natijasida:

--CustomerID 1–1000 oralig‘idagi mijozlarda bir nechta active loan bo‘ladi.
--Keyingi query bo‘sh chiqmaydi.
--12. LoanPayments
CREATE TABLE LoanPayments
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    LoanID INT NOT NULL,
    AmountPaid DECIMAL(18,2),
    PaymentDate DATE,
    RemainingBalance DECIMAL(18,2),

    CONSTRAINT FK_LoanPayments_Loans
        FOREIGN KEY (LoanID)
        REFERENCES Loans(LoanID)
);
GO
--Insert
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO LoanPayments
(
    LoanID,
    AmountPaid,
    PaymentDate,
    RemainingBalance
)
SELECT
    N,
    100 + (N%5000),
    DATEADD(DAY,-(N%365),GETDATE()),
    10000 - (N%5000)
FROM Numbers;
GO
--13. CreditScores
CREATE TABLE CreditScores
(
    CustomerID INT NOT NULL,
    CreditScore INT,
    UpdatedAt DATETIME,

    CONSTRAINT FK_CreditScores_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--Insert
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO CreditScores
(
    CustomerID,
    CreditScore,
    UpdatedAt
)
SELECT
    N,
    300 + (N%551),
    GETDATE()
FROM Numbers;
GO
--14. DebtCollection
CREATE TABLE DebtCollection
(
    DebtID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    AmountDue DECIMAL(18,2),
    DueDate DATE,
    CollectorAssigned VARCHAR(100),

    CONSTRAINT FK_DebtCollection_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--Insert
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO DebtCollection
(
    CustomerID,
    AmountDue,
    DueDate,
    CollectorAssigned
)
SELECT
    N,
    500 + (N*5),
    DATEADD(DAY,(N%180),GETDATE()),
    CONCAT('Collector ',N%100)
FROM Numbers;
GO
--Tekshirish
SELECT COUNT(*) FROM MobileBankingTransactions;
SELECT COUNT(*) FROM Loans;
SELECT COUNT(*) FROM LoanPayments;
SELECT COUNT(*) FROM CreditScores;
SELECT COUNT(*) FROM DebtCollection;





--15. KYC
CREATE TABLE KYC
(
    KYCID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    DocumentType VARCHAR(50),
    DocumentNumber VARCHAR(50),
    VerifiedBy VARCHAR(100),

    CONSTRAINT FK_KYC_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO KYC
(
    CustomerID,
    DocumentType,
    DocumentNumber,
    VerifiedBy
)
SELECT
    N,
    CASE N%3
        WHEN 0 THEN 'Passport'
        WHEN 1 THEN 'National ID'
        ELSE 'Driver License'
    END,
    CONCAT('DOC',FORMAT(N,'000000000')),
    CONCAT('Officer ',N%100)
FROM Numbers;
GO
--16. FraudDetection
CREATE TABLE FraudDetection
(
    FraudID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    TransactionID INT NOT NULL,
    RiskLevel VARCHAR(20),
    ReportedDate DATETIME,

    CONSTRAINT FK_Fraud_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    CONSTRAINT FK_Fraud_Transactions
        FOREIGN KEY (TransactionID)
        REFERENCES Transactions(TransactionID)
);
GO
--INSERT

--⚠️ Buni 10000 emas, 500 ta fraud case qilib kiritish yaxshiroq.

--Aks holda barcha transactionlar fraud bo‘lib qoladi.

;WITH Numbers AS
(
    SELECT TOP (500)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects
)
INSERT INTO FraudDetection
(
    CustomerID,
    TransactionID,
    RiskLevel,
    ReportedDate
)
SELECT
    N,
    N,
    CASE N%3
        WHEN 0 THEN 'Low'
        WHEN 1 THEN 'Medium'
        ELSE 'High'
    END,
    DATEADD(DAY,-(N%30),GETDATE())
FROM Numbers;
GO

--Bu bilan:

--SELECT *
--FROM FraudDetection

--→ 500 ta fraud transaction bo‘ladi.

--17. AMLCases
CREATE TABLE AMLCases
(
    CaseID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CaseType VARCHAR(50),
    Status VARCHAR(20),
    InvestigatorID INT,

    CONSTRAINT FK_AMLCases_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--INSERT
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO AMLCases
(
    CustomerID,
    CaseType,
    Status,
    InvestigatorID
)
SELECT
    N,
    CASE N%4
        WHEN 0 THEN 'Money Laundering'
        WHEN 1 THEN 'Terror Financing'
        WHEN 2 THEN 'Sanctions'
        ELSE 'Suspicious Transfer'
    END,
    CASE N%3
        WHEN 0 THEN 'Open'
        WHEN 1 THEN 'Closed'
        ELSE 'Investigating'
    END,
    ((N-1)%1000)+1
FROM Numbers;
GO
--18. RegulatoryReports
CREATE TABLE RegulatoryReports
(
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ReportType VARCHAR(100),
    SubmissionDate DATE
);
GO
--INSERT
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO RegulatoryReports
(
    ReportType,
    SubmissionDate
)
SELECT
    CASE N%4
        WHEN 0 THEN 'AML Report'
        WHEN 1 THEN 'Liquidity Report'
        WHEN 2 THEN 'Risk Report'
        ELSE 'Capital Adequacy Report'
    END,
    DATEADD(DAY,-(N%365),GETDATE())
FROM Numbers;
GO
--Tekshirish
SELECT COUNT(*) FROM KYC;
SELECT COUNT(*) FROM FraudDetection;
SELECT COUNT(*) FROM AMLCases;
SELECT COUNT(*) FROM RegulatoryReports;

--Natija:

--KYC                 10000
--FraudDetection        500
--AMLCases            10000
--RegulatoryReports   10000

--Bu holatda keyinchalik:

--● Firibgarlik (fraud) deb belgilangan tranzaksiyalar

SELECT COUNT(*) FROM FraudDetection;

--Agar haqiqatan 169 ta bo‘lsa va sizga 500 ta kerak bo‘lsa:

TRUNCATE TABLE FraudDetection;

--agar FK sababli truncate bo‘lmasa:

--DELETE FROM FraudDetection;

--Keyin qayta insert qiling:

;WITH Numbers AS
(
    SELECT TOP (500)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO FraudDetection
(
    CustomerID,
    TransactionID,
    RiskLevel,
    ReportedDate
)
SELECT
    N,
    N,
    CASE N%3
        WHEN 0 THEN 'Low'
        WHEN 1 THEN 'Medium'
        ELSE 'High'
    END,
    DATEADD(DAY,-(N%30),GETDATE())
FROM Numbers;

--So‘ng:

SELECT COUNT(*) FROM FraudDetection;

--natija 500 bo‘lishi kerak.












--19. Departments

--ManagerID ni Employees(EmployeeID) ga FK qilamiz.

CREATE TABLE Departments
(
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    ManagerID INT,

    CONSTRAINT FK_Departments_Employees
        FOREIGN KEY (ManagerID)
        REFERENCES Employees(EmployeeID)
);
GO
--INSERT
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Departments
(
    DepartmentName,
    ManagerID
)
SELECT
    CONCAT('Department ',N),
    ((N-1)%10000)+1
FROM Numbers;
GO
--20. Salaries
CREATE TABLE Salaries
(
    SalaryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    BaseSalary DECIMAL(18,2),
    Bonus DECIMAL(18,2),
    Deductions DECIMAL(18,2),
    PaymentDate DATE,

    CONSTRAINT FK_Salaries_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);
GO
--INSERT
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Salaries
(
    EmployeeID,
    BaseSalary,
    Bonus,
    Deductions,
    PaymentDate
)
SELECT
    N,
    3000 + (N*2),
    N%1000,
    N%300,
    DATEADD(DAY,-(N%365),GETDATE())
FROM Numbers;
GO
--21. EmployeeAttendance
CREATE TABLE EmployeeAttendance
(
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    CheckInTime DATETIME,
    CheckOutTime DATETIME,
    TotalHours DECIMAL(5,2),

    CONSTRAINT FK_EmployeeAttendance_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);
GO
--INSERT
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO EmployeeAttendance
(
    EmployeeID,
    CheckInTime,
    CheckOutTime,
    TotalHours
)
SELECT
    N,
    DATEADD(HOUR, 9, CAST(CAST(GETDATE() AS DATE) AS DATETIME)),
    DATEADD(HOUR, 17, CAST(CAST(GETDATE() AS DATE) AS DATETIME)),
    8.00
FROM Numbers;
GO
--Tekshirish
SELECT COUNT(*) AS DepartmentsCount
FROM Departments;

SELECT COUNT(*) AS SalariesCount
FROM Salaries;

SELECT COUNT(*) AS AttendanceCount
FROM EmployeeAttendance;

--Natija:

--Departments         10000
--Salaries            10000
--EmployeeAttendance  10000







--22. Investments
CREATE TABLE Investments
(
    InvestmentID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    InvestmentType VARCHAR(50),
    Amount DECIMAL(18,2),
    ROI DECIMAL(5,2),
    MaturityDate DATE,

    CONSTRAINT FK_Investments_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Investments
(
    CustomerID,
    InvestmentType,
    Amount,
    ROI,
    MaturityDate
)
SELECT
    N,
    CASE N % 4
        WHEN 0 THEN 'Stocks'
        WHEN 1 THEN 'Bonds'
        WHEN 2 THEN 'Mutual Fund'
        ELSE 'ETF'
    END,
    CAST(1000 + (N * 15) AS DECIMAL(18,2)),
    CAST(5 + (N % 15) AS DECIMAL(5,2)),
    DATEADD(YEAR, (N % 10) + 1, GETDATE())
FROM Numbers;
GO
--23. StockTradingAccounts
CREATE TABLE StockTradingAccounts
(
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    BrokerageFirm VARCHAR(100),
    TotalInvested DECIMAL(18,2),
    CurrentValue DECIMAL(18,2),

    CONSTRAINT FK_StockTradingAccounts_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO StockTradingAccounts
(
    CustomerID,
    BrokerageFirm,
    TotalInvested,
    CurrentValue
)
SELECT
    N,
    CASE N % 5
        WHEN 0 THEN 'Morgan Stanley'
        WHEN 1 THEN 'Goldman Sachs'
        WHEN 2 THEN 'Interactive Brokers'
        WHEN 3 THEN 'Charles Schwab'
        ELSE 'Fidelity'
    END,
    CAST(5000 + (N * 20) AS DECIMAL(18,2)),
    CAST(5500 + (N * 22) AS DECIMAL(18,2))
FROM Numbers;
GO
--24. ForeignExchange
CREATE TABLE ForeignExchange
(
    FXID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CurrencyPair VARCHAR(20),
    ExchangeRate DECIMAL(18,6),
    AmountExchanged DECIMAL(18,2),

    CONSTRAINT FK_ForeignExchange_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO ForeignExchange
(
    CustomerID,
    CurrencyPair,
    ExchangeRate,
    AmountExchanged
)
SELECT
    N,
    CASE N % 5
        WHEN 0 THEN 'USD/UZS'
        WHEN 1 THEN 'EUR/USD'
        WHEN 2 THEN 'GBP/USD'
        WHEN 3 THEN 'USD/AED'
        ELSE 'USD/JPY'
    END,
    CAST(1 + ((N % 1000) / 100.0) AS DECIMAL(18,6)),
    CAST(100 + (N * 5) AS DECIMAL(18,2))
FROM Numbers;
GO
--Tekshirish
SELECT COUNT(*) FROM Investments;
SELECT COUNT(*) FROM StockTradingAccounts;
SELECT COUNT(*) FROM ForeignExchange;

--Natija:

--10000
--10000
--10000







--25. InsurancePolicies
CREATE TABLE InsurancePolicies
(
    PolicyID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    InsuranceType VARCHAR(50),
    PremiumAmount DECIMAL(18,2),
    CoverageAmount DECIMAL(18,2),

    CONSTRAINT FK_InsurancePolicies_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO InsurancePolicies
(
    CustomerID,
    InsuranceType,
    PremiumAmount,
    CoverageAmount
)
SELECT
    N,
    CASE N % 4
        WHEN 0 THEN 'Health'
        WHEN 1 THEN 'Life'
        WHEN 2 THEN 'Auto'
        ELSE 'Property'
    END,
    CAST(100 + (N * 2) AS DECIMAL(18,2)),
    CAST(10000 + (N * 50) AS DECIMAL(18,2))
FROM Numbers;
GO
--26. Claims
CREATE TABLE Claims
(
    ClaimID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyID INT NOT NULL,
    ClaimAmount DECIMAL(18,2),
    Status VARCHAR(30),
    FiledDate DATE,

    CONSTRAINT FK_Claims_InsurancePolicies
        FOREIGN KEY (PolicyID)
        REFERENCES InsurancePolicies(PolicyID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Claims
(
    PolicyID,
    ClaimAmount,
    Status,
    FiledDate
)
SELECT
    N,
    CAST(500 + (N * 10) AS DECIMAL(18,2)),
    CASE N % 3
        WHEN 0 THEN 'Approved'
        WHEN 1 THEN 'Pending'
        ELSE 'Rejected'
    END,
    DATEADD(DAY,-(N%365),GETDATE())
FROM Numbers;
GO
--27. UserAccessLogs

--UserID → OnlineBankingUsers(UserID) FK

CREATE TABLE UserAccessLogs
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ActionType VARCHAR(50),
    [Timestamp] DATETIME,

    CONSTRAINT FK_UserAccessLogs_OnlineBankingUsers
        FOREIGN KEY (UserID)
        REFERENCES OnlineBankingUsers(UserID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO UserAccessLogs
(
    UserID,
    ActionType,
    [Timestamp]
)
SELECT
    N,
    CASE N % 5
        WHEN 0 THEN 'Login'
        WHEN 1 THEN 'Logout'
        WHEN 2 THEN 'Transfer'
        WHEN 3 THEN 'Bill Payment'
        ELSE 'Profile Update'
    END,
    DATEADD(MINUTE,-N,GETDATE())
FROM Numbers;
GO
--28. CyberSecurityIncidents
CREATE TABLE CyberSecurityIncidents
(
    IncidentID INT IDENTITY(1,1) PRIMARY KEY,
    AffectedSystem VARCHAR(100),
    ReportedDate DATETIME,
    ResolutionStatus VARCHAR(30)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO CyberSecurityIncidents
(
    AffectedSystem,
    ReportedDate,
    ResolutionStatus
)
SELECT
    CASE N % 4
        WHEN 0 THEN 'Core Banking'
        WHEN 1 THEN 'Mobile Banking'
        WHEN 2 THEN 'Internet Banking'
        ELSE 'Payment Gateway'
    END,
    DATEADD(DAY,-(N%365),GETDATE()),
    CASE N % 3
        WHEN 0 THEN 'Resolved'
        WHEN 1 THEN 'In Progress'
        ELSE 'Open'
    END
FROM Numbers;
GO
--Tekshirish
SELECT COUNT(*) FROM InsurancePolicies;
SELECT COUNT(*) FROM Claims;
SELECT COUNT(*) FROM UserAccessLogs;
SELECT COUNT(*) FROM CyberSecurityIncidents;




--29. Merchants
CREATE TABLE Merchants
(
    MerchantID INT IDENTITY(1,1) PRIMARY KEY,
    MerchantName VARCHAR(100) NOT NULL,
    Industry VARCHAR(100),
    Location VARCHAR(200),
    CustomerID INT NOT NULL,

    CONSTRAINT FK_Merchants_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO Merchants
(
    MerchantName,
    Industry,
    Location,
    CustomerID
)
SELECT
    CONCAT('Merchant ',N),
    CASE N % 5
        WHEN 0 THEN 'Retail'
        WHEN 1 THEN 'Restaurant'
        WHEN 2 THEN 'Technology'
        WHEN 3 THEN 'Healthcare'
        ELSE 'Education'
    END,
    CONCAT('Location ',N),
    N
FROM Numbers;
GO
--30. MerchantTransactions
CREATE TABLE MerchantTransactions
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    MerchantID INT NOT NULL,
    Amount DECIMAL(18,2),
    PaymentMethod VARCHAR(50),
    [Date] DATETIME,

    CONSTRAINT FK_MerchantTransactions_Merchants
        FOREIGN KEY (MerchantID)
        REFERENCES Merchants(MerchantID)
);
GO
--INSERT 10000
;WITH Numbers AS
(
    SELECT TOP (10000)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO MerchantTransactions
(
    MerchantID,
    Amount,
    PaymentMethod,
    [Date]
)
SELECT
    N,
    CAST(100 + (RAND(CHECKSUM(NEWID())) * 50000) AS DECIMAL(18,2)),
    CASE N % 4
        WHEN 0 THEN 'Credit Card'
        WHEN 1 THEN 'Debit Card'
        WHEN 2 THEN 'Mobile Banking'
        ELSE 'Bank Transfer'
    END,
    DATEADD(MINUTE,-N,GETDATE())
FROM Numbers;
GO
--Yakuniy tekshiruv

--Database'da 30 ta table yaratilganini tekshirish:

SELECT COUNT(*) AS TotalTables
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

--Yoki barcha tablelar bo‘yicha row sonlari:

SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Accounts', COUNT(*) FROM Accounts
UNION ALL
SELECT 'Transactions', COUNT(*) FROM Transactions
UNION ALL
SELECT 'Loans', COUNT(*) FROM Loans
UNION ALL
SELECT 'Merchants', COUNT(*) FROM Merchants
UNION ALL
SELECT 'MerchantTransactions', COUNT(*) FROM MerchantTransactions;






--TASKS

--1-●	Barcha hisoblari bo‘yicha eng yuqori umumiy balansga ega top 3 ta mijoz

select * from Customers;
select * from Accounts;

select top 3 c.CustomerID, c.FullName,
SUM(a.Balance) as total_balance
from Customers c
join Accounts a
on c.CustomerID=a.CustomerID
group by c.CustomerID, c.FullName
order by total_balance desc;

--2-●	Birdan ortiq faol kreditga ega bo‘lgan mijozlar

select * from Customers;
select * from Loans;

select c.CustomerID, c.FullName,
count(l.LoanID) as ActiveLoanCount
from Customers c
join Loans l
on c.CustomerID=l.CustomerID
where l.Status = 'Active'
group by c.CustomerID, c.FullName
having count(l.LoanID) > 1

--3-●	Firibgarlik (fraud) deb belgilangan tranzaksiyalar

select * from FraudDetection;
select * from Transactions;
select * from Customers;

select  t.TransactionID, 
        c.FullName, 
		f.RiskLevel, 
		f.ReportedDate,
        t.Amount,
		t.Currency
from FraudDetection f
join Transactions t
on f.TransactionID=t.TransactionID
join Customers c
on f.CustomerID=c.CustomerID 

--4-●	Har bir filial bo‘yicha berilgan jami kredit miqdori

select * from Loans;
select * from Branches;
select * from Accounts;
select * from Customers

select b.BranchName, 
sum(l.Amount) as TotalLoanAmount
from Branches b
join Accounts a
on b.BranchID=a.BranchID
join Customers c 
on a.CustomerID=c.CustomerID
join Loans l
on c.CustomerID=l.CustomerID
group by  b.BranchName


--5-●	Qisqa vaqt ichida (1 soatdan kam) bir nechta katta (10,000$ dan yuqori) tranzaksiyalar qilgan mijozlar

select * from Customers;
select * from Transactions;
select * from Accounts;

select distinct c.CustomerID, c.FullName
from Customers c
join Accounts a
on c.CustomerID=a.CustomerID
join Transactions t1
on a.AccountID=t1.AccountID
join Transactions t2
on a.AccountID=t2.AccountID
where t1.TransactionID < t2.TransactionID
and t1.Amount > 10000
and t2.Amount > 10000
and DATEDIFF(minute, t1.[Date], t2.[Date]) < 60;


--6-●	10 daqiqa ichida turli davlatlardan tranzaksiya qilgan mijozlar (firibgarlik uchun odatiy signal)


select * from Customers;
select * from Transactions;
select * from Accounts;

select distinct c.CustomerID, c.FullName
from Customers c
join Accounts a
on c.CustomerID=a.CustomerID
join Transactions t1
on a.AccountID=t1.AccountID
join Transactions t2
on a.AccountID=t2.AccountID
where t1.TransactionID < t2.TransactionID
and t1.Country<>t2.Country
and DATEDIFF(minute, t1.[Date], t2.[Date]) <= 10;
