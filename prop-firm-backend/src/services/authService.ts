import poolPromise from '../config/dbConfig';
import sql from 'mssql';
import bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';
import Joi from 'joi';

// NEW: Joi schema for registration
const registerSchema = Joi.object({
    username: Joi.string().min(3).required(),
    password: Joi.string().min(6).required(),
    email: Joi.string().email().required(),
});

export class AuthService {
    async register(username: string, password: string, email: string) {
        // CHANGED: Replaced manual validation with Joi
        const { error } = registerSchema.validate({ username, password, email });
        if (error) throw new Error(error.details[0].message);

        const hashedPassword = await bcrypt.hash(password, 10);
        const userId = uuidv4();

        const pool = await poolPromise;
        const result = await pool.request()
            .input('id', sql.UniqueIdentifier, userId)
            .input('username', sql.VarChar, username)
            .input('password', sql.VarChar, hashedPassword)
            .input('email', sql.VarChar, email)
            .execute('sp_RegisterUser');
        return { id: result.recordset[0].id, username, email, role: 'user' }; // CHANGED: Hardcoded 'user' role
    }

    async login(email: string, password: string) {
        // Joi schema for login
        const loginSchema = Joi.object({
            email: Joi.string().required(),
            password: Joi.string().required(),
        });
        const { error } = loginSchema.validate({ email, password });
        if (error) throw new Error(error.details[0].message);
    
        const pool = await poolPromise;
        const result = await pool.request()
            .input('email', sql.VarChar, email)
            .execute('sp_LoginUser');
        const user = result.recordset[0];
    
        // Check if user exists and password matches
        if (!user || !(await bcrypt.compare(password, user.password))) {
            throw new Error('Invalid credentials');
        }
    
        // Check if the account is inactive
        if (!user.isActive) {
            throw new Error('Your account is deactivated. Please contact support.');
        }
    
        // Return user data if active
        return { id: user.id, username: user.username, email: user.email, role: user.role };
    }

    async resetPassword(email: string, password: string): Promise<void> {
        const pool = await poolPromise;
        const hashedPassword = await bcrypt.hash(password, 10);

        const result = await pool.request()
            .input('email', sql.VarChar, email)
            .input('password', sql.VarChar, hashedPassword)
            .execute('sp_ResetPassword');

        if (result.rowsAffected[0] === 0) {
            throw new Error('User not found');
        }
    }
}