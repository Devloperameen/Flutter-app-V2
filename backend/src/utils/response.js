/**
 * ============================================
 * API Response Formatter
 * ============================================
 * 
 * Standardized response format for all API endpoints
 * Ensures consistent JSON structure across the application
 */

/**
 * Format successful response
 * 
 * @param {*} data - Response data
 * @param {string} message - Success message
 * @param {number} statusCode - HTTP status code (default: 200)
 * @returns {object} Formatted response
 * 
 * Example:
 * success(habit, 'Habit created successfully', 201)
 * Returns: { success: true, message: '...', data: {...}, statusCode: 201 }
 */
const success = (data, message = 'Success', statusCode = 200) => {
  return {
    success: true,
    message,
    data,
    statusCode,
    timestamp: new Date().toISOString(),
  };
};

/**
 * Format error response
 * 
 * @param {string} message - Error message
 * @param {number} statusCode - HTTP status code (default: 400)
 * @param {*} error - Additional error details
 * @returns {object} Formatted error response
 * 
 * Example:
 * error('User not found', 404, { userId: 123 })
 * Returns: { success: false, message: '...', statusCode: 404, ... }
 */
const error = (message = 'An error occurred', statusCode = 400, errorDetails = null) => {
  return {
    success: false,
    message,
    statusCode,
    error: errorDetails,
    timestamp: new Date().toISOString(),
  };
};

/**
 * Format validation error response
 * Used when request validation fails
 * 
 * @param {array} errors - Array of validation error messages
 * @param {string} message - Main error message
 * @returns {object} Formatted validation error response
 * 
 * Example:
 * validationError(['Invalid email', 'Password too weak'], 'Validation failed')
 */
const validationError = (errors = [], message = 'Validation failed') => {
  return {
    success: false,
    message,
    statusCode: 422,
    errors,
    timestamp: new Date().toISOString(),
  };
};

/**
 * Format paginated response
 * 
 * @param {array} data - Array of items
 * @param {number} page - Current page number
 * @param {number} limit - Items per page
 * @param {number} total - Total items count
 * @param {string} message - Success message
 * @returns {object} Formatted paginated response
 * 
 * Example:
 * paginated(habits, 1, 10, 42, 'Habits fetched')
 * Returns: { success: true, data: [...], pagination: { page: 1, limit: 10, total: 42, pages: 5 } }
 */
const paginated = (data, page = 1, limit = 10, total = 0, message = 'Success') => {
  const pages = Math.ceil(total / limit);
  
  return {
    success: true,
    message,
    data,
    pagination: {
      page,
      limit,
      total,
      pages,
    },
    timestamp: new Date().toISOString(),
  };
};

/**
 * Send response with appropriate HTTP status
 * 
 * @param {object} res - Express response object
 * @param {object} responseData - Response data from above formatters
 * @returns {void}
 * 
 * Example:
 * const responseData = success(habit, 'Habit created', 201);
 * sendResponse(res, responseData);
 */
const sendResponse = (res, responseData) => {
  const statusCode = responseData.statusCode || 200;
  res.status(statusCode).json(responseData);
};

module.exports = {
  success,
  error,
  validationError,
  paginated,
  sendResponse,
};
