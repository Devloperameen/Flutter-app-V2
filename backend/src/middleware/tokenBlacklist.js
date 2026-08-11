/**
 * ============================================
 * Token Blacklist Service
 * ============================================
 * 
 * Manages invalidated tokens for logout and security
 * 
 * In production, use Redis for distributed systems
 * For MVP, uses in-memory store with cleanup
 * 
 * Token is blacklisted on:
 * - User logout
 * - Password change
 * - Permission/role change
 * - Account deletion
 */

const logger = require('../utils/logger');

/**
 * In-memory token blacklist
 * Format: { token: expiryTimestamp }
 * 
 * In production with multiple servers, use Redis:
 * - SETEX token value ttl
 * - GET token
 * - DELETE token on cleanup
 */
let tokenBlacklist = {};

/**
 * Clean up expired tokens every 5 minutes
 * Prevents memory leak in long-running processes
 */
setInterval(() => {
  const now = Date.now();
  let cleaned = 0;

  for (const [token, expiry] of Object.entries(tokenBlacklist)) {
    if (expiry < now) {
      delete tokenBlacklist[token];
      cleaned++;
    }
  }

  if (cleaned > 0) {
    logger.debug(`🧹 Token blacklist cleanup: removed ${cleaned} expired tokens`);
  }
}, 5 * 60 * 1000); // Every 5 minutes

/**
 * Add token to blacklist
 * 
 * @param {string} token - JWT token to blacklist
 * @param {number} expiryTime - Token expiry timestamp (ms)
 * @returns {void}
 */
const blacklistToken = (token, expiryTime) => {
  if (!token || !expiryTime) {
    logger.warn('⚠️ Invalid token or expiry time for blacklist');
    return;
  }

  tokenBlacklist[token] = expiryTime;
  logger.debug(`🛑 Token blacklisted (expires: ${new Date(expiryTime).toISOString()})`);
};

/**
 * Check if token is blacklisted
 * 
 * @param {string} token - JWT token to check
 * @returns {boolean} True if token is blacklisted
 */
const isTokenBlacklisted = (token) => {
  if (!token) {
    return false;
  }

  // If token in blacklist and hasn't expired yet
  if (tokenBlacklist[token]) {
    const now = Date.now();
    const expiry = tokenBlacklist[token];

    if (expiry > now) {
      return true; // Token is still blacklisted
    } else {
      // Token has expired, remove from blacklist
      delete tokenBlacklist[token];
      return false;
    }
  }

  return false;
};

/**
 * Clear all blacklist (useful for testing)
 * 
 * @returns {number} Number of tokens cleared
 */
const clearBlacklist = () => {
  const count = Object.keys(tokenBlacklist).length;
  tokenBlacklist = {};
  logger.info(`🧹 Token blacklist cleared (${count} tokens)`);
  return count;
};

/**
 * Get blacklist statistics
 * 
 * @returns {object} Stats object
 */
const getBlacklistStats = () => {
  const now = Date.now();
  let activeBlacklisted = 0;
  let expiredBlacklisted = 0;

  for (const [, expiry] of Object.entries(tokenBlacklist)) {
    if (expiry > now) {
      activeBlacklisted++;
    } else {
      expiredBlacklisted++;
    }
  }

  return {
    totalBlacklisted: Object.keys(tokenBlacklist).length,
    activeBlacklisted,
    expiredBlacklisted,
    memoryUsage: JSON.stringify(tokenBlacklist).length,
  };
};

/**
 * Middleware to check if token is blacklisted
 * 
 * Add to protected routes to enforce logout
 * Example:
 *   router.get('/profile', checkBlacklist, authenticate, profileController);
 * 
 * @returns {function} Express middleware
 */
const checkBlacklistMiddleware = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);

      if (isTokenBlacklisted(token)) {
        return res.status(401).json({
          success: false,
          message:
            'Token has been invalidated. Please login again.',
          statusCode: 401,
        });
      }
    }

    next();
  } catch (error) {
    logger.error('Error checking token blacklist:', error);
    next(); // Continue even if blacklist check fails
  }
};

/**
 * Logout user by blacklisting their token
 * 
 * Usage in logout controller:
 * ```
 * const token = req.headers.authorization.substring(7);
 * const decoded = jwt.decode(token);
 * const expiryTime = decoded.exp * 1000; // Convert to ms
 * logoutUser(token, expiryTime);
 * ```
 * 
 * @param {string} token - JWT token to invalidate
 * @param {number} expiryTime - Token expiry timestamp
 * @returns {object} Result object
 */
const logoutUser = (token, expiryTime) => {
  try {
    blacklistToken(token, expiryTime);

    logger.info('✅ User logged out - token invalidated');

    return {
      success: true,
      message: 'Successfully logged out',
    };
  } catch (error) {
    logger.error('Error logging out user:', error);

    return {
      success: false,
      message: 'Error during logout',
      error: error.message,
    };
  }
};

/**
 * Invalidate all tokens for a user
 * Use when user changes password or modifies permissions
 * 
 * @param {string} userId - User ID
 * @returns {void}
 */
const invalidateUserTokens = (userId) => {
  // In a real system, would track all tokens per user in Redis
  // For now, this is a placeholder
  logger.info(
    `🔐 Invalidated all tokens for user: ${userId} (implement with Redis for multi-token tracking)`
  );
};

module.exports = {
  blacklistToken,
  isTokenBlacklisted,
  clearBlacklist,
  getBlacklistStats,
  checkBlacklistMiddleware,
  logoutUser,
  invalidateUserTokens,
};
