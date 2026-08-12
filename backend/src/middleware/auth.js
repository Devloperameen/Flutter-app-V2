/**
 * ============================================
 * JWT Authentication Middleware
 * ============================================
 * 
 * Validates JWT tokens and protects routes
 * All protected routes must use this middleware
 */

const jwt = require('jsonwebtoken');
const logger = require('../utils/logger');
const User = require('../models/User');

/**
 * Authenticate user with JWT token
 * 
 * Expected header: Authorization: Bearer <token>
 * Adds user data to req.user for use in controllers
 * 
 * Usage in routes:
 * router.get('/protected', authenticate, controllerFunction);
 */
const authenticate = async (req, res, next) => {
  try {
    // 1. Extract token from header
    const authHeader = req.headers.authorization;
    
    logger.debug(`🔐 Auth request to: ${req.method} ${req.path}`);
    logger.debug(`Auth header present: ${!!authHeader}`);
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      logger.warn(`❌ No Bearer token in ${req.path}`);
      return res.status(401).json({
        success: false,
        message: 'No authorization token provided. Use "Bearer TOKEN" format.',
        statusCode: 401,
      });
    }

    // 2. Extract token value (remove 'Bearer ' prefix)
    const token = authHeader.substring(7);
    logger.debug(`Token received (first 20 chars): ${token.substring(0, 20)}...`);

    // 3. Verify token signature and expiry
    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_SECRET);
      logger.debug(`✅ Token verified successfully`);
    } catch (jwtError) {
      logger.error(`❌ JWT verification failed:`, jwtError.message);
      if (jwtError.name === 'TokenExpiredError') {
        return res.status(401).json({
          success: false,
          message: 'Token has expired',
          statusCode: 401,
        });
      }
      if (jwtError.name === 'JsonWebTokenError') {
        return res.status(401).json({
          success: false,
          message: 'Invalid token',
          statusCode: 401,
        });
      }
      throw jwtError;
    }
    
    // 4. Check if token is valid (not blacklisted, etc.)
    if (!decoded.userId) {
      logger.warn(`❌ Token missing userId field`);
      return res.status(401).json({
        success: false,
        message: 'Invalid token structure',
        statusCode: 401,
      });
    }

    // 5. Fetch user from database
    const user = await User.findById(decoded.userId).select('-password');
    
    if (!user) {
      logger.warn(`❌ User not found with ID: ${decoded.userId}`);
      return res.status(401).json({
        success: false,
        message: 'User not found',
        statusCode: 401,
      });
    }

    // 6. Check if user is active
    if (!user.isActive) {
      logger.warn(`❌ User account disabled: ${user.email}`);
      return res.status(403).json({
        success: false,
        message: 'User account is disabled',
        statusCode: 403,
      });
    }

    // 7. Attach user to request object for use in controllers
    req.user = {
      id: user._id,
      email: user.email,
      fullName: user.fullName,
    };

    logger.debug(`✅ User authenticated: ${req.user.email} → ${req.method} ${req.path}`);

    // 8. Continue to next middleware/controller
    next();
  } catch (error) {
    logger.error('❌ Authentication middleware error:', error.message);
    
    res.status(500).json({
      success: false,
      message: 'Authentication failed',
      error: error.message,
      statusCode: 500,
    });
  }
};

/**
 * Check if user is authorized (admin role check)
 * Verifies user has 'admin' or 'super_admin' role
 * 
 * Usage: router.delete('/admin/users/:id', authenticate, authorize, deleteUser);
 */
const authorize = async (req, res, next) => {
  try {
    // Fetch full user data with role
    const user = await User.findById(req.user.id);

    // Allow both 'admin' and 'super_admin' roles
    if (!user || (user.role !== 'admin' && user.role !== 'super_admin')) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to access this resource',
        statusCode: 403,
      });
    }

    next();
  } catch (error) {
    logger.error('Authorization error:', error);
    res.status(500).json({
      success: false,
      message: 'Authorization failed',
      statusCode: 500,
    });
  }
};

/**
 * Optional authentication - allows both authenticated and anonymous access
 * If token is provided and valid, attaches user to req.user
 * If token is not provided or invalid, continues without user
 * 
 * Usage: router.get('/public-but-enhanced', optional, controllerFunction);
 */
const optional = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    // No token provided - continue as anonymous
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      req.user = null;
      return next();
    }

    const token = authHeader.substring(7);

    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      
      if (decoded.userId) {
        const user = await User.findById(decoded.userId).select('-password');
        
        if (user && user.isActive) {
          req.user = {
            id: user._id,
            email: user.email,
            fullName: user.fullName,
          };
        } else {
          req.user = null;
        }
      } else {
        req.user = null;
      }
    } catch (jwtError) {
      // Invalid token - continue as anonymous
      req.user = null;
    }

    next();
  } catch (error) {
    logger.error('Optional auth error:', error);
    // Even if error, continue as anonymous
    req.user = null;
    next();
  }
};

module.exports = {
  authenticate,
  authorize,
  optional,
};
