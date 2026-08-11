/**
 * ============================================
 * Rate Limiting Middleware
 * ============================================
 * 
 * Protects APIs from abuse:
 * - Brute force attacks on auth endpoints
 * - DoS attacks on expensive endpoints
 * - Excessive API usage
 * 
 * Uses in-memory store (suitable for single server)
 * For multi-server deployment, use Redis
 */

const rateLimit = require('express-rate-limit');
const logger = require('../utils/logger');

/**
 * Generic rate limiter
 * Use for general API endpoints
 */
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true, // Return rate limit info in `RateLimit-*` headers
  legacyHeaders: false, // Disable `X-RateLimit-*` headers
  skip: (req) => {
    // Don't rate limit health checks
    return req.path === '/health';
  },
  handler: (req, res) => {
    logger.warn(
      `⚠️ Rate limit exceeded for IP: ${req.ip} on ${req.path}`
    );
    res.status(429).json({
      success: false,
      statusCode: 429,
      message: 'Too many requests. Please try again later.',
      retryAfter: req.rateLimit.resetTime,
    });
  },
});

/**
 * Strict rate limiter for authentication
 * Use on login, register, password reset endpoints
 * 
 * Prevents brute force attacks
 * 5 attempts per 15 minutes
 */
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // Limit each IP to 5 requests per windowMs
  skipSuccessfulRequests: true, // Don't count successful requests
  message:
    'Too many login attempts from this IP, please try again after 15 minutes.',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    logger.warn(
      `🚨 Auth rate limit exceeded for IP: ${req.ip} - ${req.body.email || 'unknown'}`
    );
    res.status(429).json({
      success: false,
      statusCode: 429,
      message:
        'Too many authentication attempts. Please try again later.',
      retryAfter: req.rateLimit.resetTime,
    });
  },
});

/**
 * Moderate rate limiter for API endpoints
 * Use on resource creation, updates, file uploads
 * 
 * Prevents spam and excessive usage
 * 30 requests per 15 minutes
 */
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 30, // 30 requests per 15 minutes
  message: 'Too many requests, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    logger.warn(
      `⚠️ API rate limit exceeded for IP: ${req.ip} on ${req.method} ${req.path}`
    );
    res.status(429).json({
      success: false,
      statusCode: 429,
      message: 'API rate limit exceeded. Please try again later.',
      retryAfter: req.rateLimit.resetTime,
    });
  },
});

/**
 * Strict rate limiter for file uploads
 * Use on upload endpoints
 * 
 * Prevents storage abuse and bandwidth waste
 * 10 uploads per hour
 */
const uploadLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 10, // 10 uploads per hour
  message: 'Too many file uploads, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    logger.warn(
      `🚨 Upload rate limit exceeded for IP: ${req.ip} (${req.user?.id || 'unauthenticated'})`
    );
    res.status(429).json({
      success: false,
      statusCode: 429,
      message: 'Upload limit exceeded. Maximum 10 uploads per hour.',
      retryAfter: req.rateLimit.resetTime,
    });
  },
});

/**
 * User-based rate limiter
 * Limits per authenticated user instead of IP
 * 
 * Use when user is authenticated
 * Prevents a user from flooding the API
 */
const userBasedLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 20, // 20 requests per minute per user
  keyGenerator: (req) => {
    // Rate limit by user ID if authenticated, otherwise by IP
    return req.user?.id || req.ip;
  },
  skip: (req) => {
    // Don't rate limit unauthenticated requests on this limiter
    return !req.user;
  },
  message: 'Too many requests from this account, please slow down.',
  handler: (req, res) => {
    logger.warn(
      `⚠️ User rate limit exceeded: ${req.user?.id || 'unknown'}`
    );
    res.status(429).json({
      success: false,
      statusCode: 429,
      message: 'Too many requests. Please slow down.',
      retryAfter: req.rateLimit.resetTime,
    });
  },
});

module.exports = {
  generalLimiter,
  authLimiter,
  apiLimiter,
  uploadLimiter,
  userBasedLimiter,
};
