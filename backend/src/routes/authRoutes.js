/**
 * ============================================
 * Auth Routes
 * ============================================
 * 
 * Endpoints for authentication:
 * - User registration
 * - User login
 * - Token refresh
 * - Token verification
 * - Logout
 * - Get current user
 */

const express = require('express');
const authController = require('../controllers/authController');
const { authenticate } = require('../middleware/auth');
const { authLimiter } = require('../middleware/rateLimiter');
const { checkBlacklistMiddleware } = require('../middleware/tokenBlacklist');

const router = express.Router();

/**
 * PUBLIC ROUTES (No authentication required)
 */

/**
 * Register new user
 * POST /api/v1/auth/register
 * 
 * Rate limited to prevent abuse
 * 
 * Body:
 * {
 *   "email": "user@example.com",
 *   "password": "SecurePass123",
 *   "fullName": "John Doe"
 * }
 * 
 * Response:
 * {
 *   "success": true,
 *   "data": {
 *     "userId": "...",
 *     "email": "...",
 *     "accessToken": "...",
 *     "refreshToken": "..."
 *   }
 * }
 */
router.post('/register', authLimiter, authController.register);

/**
 * Login user
 * POST /api/v1/auth/login
 * 
 * Rate limited to prevent brute force attacks
 * Max 5 attempts per 15 minutes
 * 
 * Body:
 * {
 *   "email": "user@example.com",
 *   "password": "SecurePass123"
 * }
 * 
 * Response: Same as register
 */
router.post('/login', authLimiter, authController.login);

/**
 * Refresh access token
 * POST /api/v1/auth/refresh-token
 * 
 * Body:
 * {
 *   "refreshToken": "eyJhbGc..."
 * }
 * 
 * Use this when access token expires
 * Get a new access token using refresh token
 */
router.post('/refresh-token', authController.refreshToken);

/**
 * PROTECTED ROUTES (Requires authentication)
 * Middleware: authenticate, checkBlacklistMiddleware
 */

/**
 * Get current user profile
 * GET /api/v1/auth/me
 * Header: Authorization: Bearer <accessToken>
 */
router.get('/me', checkBlacklistMiddleware, authenticate, authController.getCurrentUser);

/**
 * Verify token validity
 * POST /api/v1/auth/verify
 * Header: Authorization: Bearer <accessToken>
 * 
 * Returns user data if token is valid
 */
router.post('/verify', checkBlacklistMiddleware, authenticate, authController.verifyToken);

/**
 * Logout user
 * POST /api/v1/auth/logout
 * Header: Authorization: Bearer <accessToken>
 * 
 * Invalidates the token by adding it to blacklist
 * Client should delete token from storage after this
 */
router.post('/logout', checkBlacklistMiddleware, authenticate, authController.logout);

module.exports = router;
