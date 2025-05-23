-- Transactions table (no change)
CREATE TABLE Transactions (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    accountId UNIQUEIDENTIFIER NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    description VARCHAR(255),
    transactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (accountId) REFERENCES Accounts(id)
);

SELECT * FROM Transactions;


CREATE TABLE PropTransactions (
    transactionId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    userId UNIQUEIDENTIFIER NOT NULL,
    accountId UNIQUEIDENTIFIER NOT NULL,
    propAccountId UNIQUEIDENTIFIER NOT NULL,
    depositAmount DECIMAL(15, 2) NOT NULL,
    tradingBalance DECIMAL(15, 2) NOT NULL,
    title VARCHAR(50) NOT NULL,
    purchaseDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(id),
    FOREIGN KEY (accountId) REFERENCES Accounts(id),
    FOREIGN KEY (propAccountId) REFERENCES PropAccounts(id)
);

CREATE TABLE PropTransactions (
    transactionId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    userId UNIQUEIDENTIFIER NOT NULL,
    accountId UNIQUEIDENTIFIER NOT NULL,
    propAccountId UNIQUEIDENTIFIER NOT NULL,
    depositAmount DECIMAL(15, 2) NOT NULL,
    tradingBalance DECIMAL(15, 2) NOT NULL, -- Initial balance from PropAccounts
    currentBalance DECIMAL(15, 2) NOT NULL DEFAULT 0.00, -- Tracks current balance after trades
    title VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Phase I', -- 'Phase I', 'Phase II', 'Completed', 'Failed'
    tradingDays INT NOT NULL DEFAULT 0, -- Tracks days traded
    purchaseDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userId) REFERENCES Users(id),
    FOREIGN KEY (accountId) REFERENCES Accounts(id),
    FOREIGN KEY (propAccountId) REFERENCES PropAccounts(id)
);

SELECT * FROM PropTransactions;

DELETE FROM PropTransactions
