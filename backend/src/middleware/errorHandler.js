/**
 * ============================================
 * Global Error Handler Middleware
 * ============================================
 * 
 * Catches all errors in the application
 * and returns consistent error responses
 * 
 * This middleware MUST be defined last in app.js
 */

const logger = require('../utils/logger');
const { error: formatError } = require('../utils/response');

/**
 * Main error handling middleware
 * 
 * Error types handled:
 * 1. Validation errors (422)
 * 2. Not found errors (404)
 * 3. Authentication errors (401)
 * 4. Authorization errors (403)
 * 5. Mongoose errors
 * 6. Generic server errors (500)
 */
const errorHandler = (err, req, res, next) => {
  // ─── Log the error ────────────────────────────────
  logger.error(`Error: ${err.message}`, err);

  // ─── Extract error details ────────────────────────
  let statusCode = err.statusCode || 500;
  let message = err.message || 'Internal Server Error';
  let errorDetails = null;

  // ─── Handle Different Error Types ────────────────

  // 1. Mongoose Validation Error
  if (err.name === 'ValidationError') {
    statusCode = 422;
    message = 'Validation error';
    errorDetails = Object.values(err.errors).map((e) => e.message);
  }

  // 2. Mongoose Cast Error (Invalid ID format)
  if (err.name === 'CastError') {
    statusCode = 400;
    message = 'Invalid ID format';
    errorDetails = err.message;
  }

  // 3. Duplicate Key Error
  if (err.code === 11000) {
    statusCode = 409;
    const field = Object.keys(err.keyValue)[0];
    message = `${field} already exists`;
    errorDetails = err.keyValue;
  }

  // 4. JWT Errors
  if (err.name === 'JsonWebTokenError') {
    statusCode = 401;
    message = 'Invalid token';
  }

  if (err.name === 'TokenExpiredError') {
    statusCode = 401;
    message = 'Token expired';
  }

  // ─── Log error for debugging ─────────────────────
  if (statusCode === 500) {
    logger.error(`[500] ${message}`, err);
  }

  // ─── Send error response ─────────────────────────
  const errorResponse = formatError(message, statusCode, errorDetails);
  
  res.status(statusCode).json(errorResponse);
};

module.exports = errorHandler;
