CREATE TABLE Users (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(10) NOT NULL DEFAULT 'user', -- Default remains 'user'
    isActive BIT NOT NULL DEFAULT 1,
    createdAt DATETIME DEFAULT GETDATE()
);


SELECT * FROM Users;


UPDATE Users
SET role = 'admin'
WHERE id = 'ebb8320b-82c9-467b-841c-3b3d02124d24' AND email = 'admin@example.com';