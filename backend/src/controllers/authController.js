/**
 * ============================================
 * Auth Controller
 * ============================================
 * 
 * Handles authentication operations:
 * - User registration
 * - User login
 * - Token refresh
 * - Token validation
 * 
 * JWT Flow:
 * 1. User registers/login → Get accessToken (15 min) + refreshToken (7 days)
 * 2. Use accessToken for API requests
 * 3. When accessToken expires → Use refreshToken to get new accessToken
 * 4. Never store password in client, only tokens
 */

const jwt = require('jsonwebtoken');
const User = require('../models/User');
const logger = require('../utils/logger');
const { success, error, validationError, sendResponse } = require('../utils/response');
const { validateUserData } = require('../utils/validators');

/**
 * Generate JWT tokens
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {object} { accessToken, refreshToken }
 */
const generateTokens = (userId) => {
  // Access token: Short-lived (15 minutes)
  // Used for API requests
  const accessToken = jwt.sign(
    { userId },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_ACCESS_EXPIRY || '15m' }
  );

  // Refresh token: Long-lived (7 days)
  // Used to get new access tokens
  const refreshToken = jwt.sign(
    { userId },
    process.env.JWT_REFRESH_SECRET,
    { expiresIn: process.env.JWT_REFRESH_EXPIRY || '7d' }
  );

  return { accessToken, refreshToken };
};

/**
 * Register a new user
 * 
 * POST /api/v1/auth/register
 * Body: { email, password, fullName }
 * 
 * Handles:
 * - Input validation
 * - Duplicate email check
 * - Password hashing
 * - Token generation
 */
const register = async (req, res, next) => {
  try {
    const { email, password, fullName } = req.body;

    // ─── Validate Input ─────────────────────────
    const validation = validateUserData({ email, password, fullName });
    if (!validation.valid) {
      const errorResponse = validationError(validation.errors, 'Registration validation failed');
      return sendResponse(res, errorResponse);
    }

    // ─── Check if user already exists ───────────
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      const errorResponse = error('User with this email already exists', 409);
      return sendResponse(res, errorResponse);
    }

    // ─── Create new user ────────────────────────
    // Password is automatically hashed by User.pre('save') middleware
    const newUser = new User({
      email: email.toLowerCase(),
      password, // Plain text, will be hashed
      fullName: fullName.trim(),
    });

    await newUser.save();
    logger.info(`✅ User registered: ${newUser.email}`);

    // ─── Generate tokens ────────────────────────
    const { accessToken, refreshToken } = generateTokens(newUser._id);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        userId: newUser._id,
        email: newUser.email,
        fullName: newUser.fullName,
        accessToken,
        refreshToken,
      },
      'User registered successfully',
      201
    );

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Registration error:', error);
    next(error);
  }
};

/**
 * Login user
 * 
 * POST /api/v1/auth/login
 * Body: { email, password }
 * 
 * Handles:
 * - Email validation
 * - Password verification
 * - Token generation
 * - Last login update
 */
const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // ─── Validate Input ─────────────────────────
    if (!email || !password) {
      const errorResponse = validationError(
        ['Email and password are required'],
        'Login validation failed'
      );
      return sendResponse(res, errorResponse);
    }

    // ─── Find user by email ─────────────────────
    // Include password field (normally excluded)
    const user = await User.findByEmail(email).select('+password');
    if (!user) {
      // Don't reveal if email exists (security)
      const errorResponse = error('Invalid email or password', 401);
      return sendResponse(res, errorResponse);
    }

    // ─── Check if account is active ──────────────
    if (!user.isActive) {
      const errorResponse = error('Your account has been disabled', 403);
      return sendResponse(res, errorResponse);
    }

    // ─── Verify password ────────────────────────
    // comparePassword uses bcrypt.compare()
    const isValidPassword = await user.comparePassword(password);
    if (!isValidPassword) {
      const errorResponse = error('Invalid email or password', 401);
      return sendResponse(res, errorResponse);
    }

    // ─── Update last login ──────────────────────
    user.lastLogin = new Date();
    await user.save();

    logger.info(`✅ User logged in: ${user.email}`);

    // ─── Generate tokens ────────────────────────
    const { accessToken, refreshToken } = generateTokens(user._id);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        userId: user._id,
        email: user.email,
        fullName: user.fullName,
        avatar: user.avatar,
        accessToken,
        refreshToken,
      },
      'Login successful',
      200
    );

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Login error:', error);
    next(error);
  }
};

/**
 * Refresh access token using refresh token
 * 
 * POST /api/v1/auth/refresh-token
 * Body: { refreshToken }
 * 
 * When access token expires:
 * 1. Use this endpoint with refresh token
 * 2. Get new access token
 * 3. Continue using API
 */
const refreshToken = async (req, res, next) => {
  try {
    const { refreshToken: token } = req.body;

    // ─── Validate input ─────────────────────────
    if (!token) {
      const errorResponse = validationError(['Refresh token is required']);
      return sendResponse(res, errorResponse);
    }

    // ─── Verify refresh token ───────────────────
    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_REFRESH_SECRET);
    } catch (err) {
      const errorResponse = error('Invalid or expired refresh token', 401);
      return sendResponse(res, errorResponse);
    }

    // ─── Verify user still exists ───────────────
    const user = await User.findById(decoded.userId);
    if (!user || !user.isActive) {
      const errorResponse = error('User not found or account disabled', 401);
      return sendResponse(res, errorResponse);
    }

    // ─── Generate new tokens ────────────────────
    const { accessToken: newAccessToken, refreshToken: newRefreshToken } = generateTokens(
      user._id
    );

    logger.info(`✅ Token refreshed for user: ${user.email}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      },
      'Token refreshed successfully'
    );

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Token refresh error:', error);
    next(error);
  }
};

/**
 * Verify token validity
 * 
 * POST /api/v1/auth/verify
 * Header: Authorization: Bearer <token>
 * 
 * Used by Flutter to check if token is still valid
 * before making API requests
 */
const verifyToken = async (req, res, next) => {
  try {
    // req.user is set by authenticate middleware
    const responseData = success(
      {
        userId: req.user.id,
        email: req.user.email,
        valid: true,
      },
      'Token is valid'
    );

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Token verification error:', error);
    next(error);
  }
};

/**
 * Logout user
 * 
 * POST /api/v1/auth/logout
 * Header: Authorization: Bearer <token>
 * 
 * Adds token to blacklist so it can't be used again
 * Client should delete token from storage after receiving response
 */
const logout = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const token = req.headers.authorization?.substring(7); // Extract token from "Bearer <token>"

    // Add token to blacklist to invalidate it
    if (token) {
      const decoded = jwt.decode(token);
      if (decoded && decoded.exp) {
        // Convert exp (seconds) to milliseconds
        const expiryTime = decoded.exp * 1000;
        
        // Import and use token blacklist
        const { logoutUser } = require('../middleware/tokenBlacklist');
        logoutUser(token, expiryTime);
      }
    }

    logger.info(`✅ User logged out: ${req.user.email}`);

    const responseData = success(
      { message: 'Logged out successfully' },
      'Logout successful'
    );

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Logout error:', error);
    next(error);
  }
};

/**
 * Get current user profile
 * 
 * GET /api/v1/auth/me
 * Header: Authorization: Bearer <token>
 * 
 * Returns current authenticated user's profile
 */
const getCurrentUser = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      const errorResponse = error('User not found', 404);
      return sendResponse(res, errorResponse);
    }

    const responseData = success(
      {
        userId: user._id,
        email: user.email,
        fullName: user.fullName,
        avatar: user.avatar,
        bio: user.bio,
        createdAt: user.createdAt,
        lastLogin: user.lastLogin,
      },
      'User profile retrieved'
    );

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get current user error:', error);
    next(error);
  }
};

module.exports = {
  register,
  login,
  refreshToken,
  verifyToken,
  logout,
  getCurrentUser,
  generateTokens,
};
