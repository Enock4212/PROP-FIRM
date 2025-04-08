CREATE PROCEDURE sp_LoginUser
    @email VARCHAR(50)
AS
BEGIN
    SELECT id, username, email, password, role, isActive 
    FROM Users 
    WHERE email = @email;
END;