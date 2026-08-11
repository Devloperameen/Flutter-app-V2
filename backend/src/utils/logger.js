/**
 * ============================================
 * Logger Utility
 * ============================================
 * 
 * Simple logging utility for consistent
 * logging across the application.
 * 
 * Levels: error, warn, info, debug
 */

const getTimestamp = () => {
  return new Date().toISOString();
};

/**
 * Format log message with timestamp and level
 */
const formatLog = (level, message, data = '') => {
  const timestamp = getTimestamp();
  return `[${timestamp}] [${level.toUpperCase()}] ${message} ${data ? JSON.stringify(data) : ''}`;
};

const logger = {
  /**
   * Error level logging
   * Use for errors, exceptions
   */
  error: (message, error = null) => {
    if (error) {
      console.error(formatLog('error', message, error.message || error));
    } else {
      console.error(formatLog('error', message));
    }
  },

  /**
   * Warning level logging
   * Use for potential issues
   */
  warn: (message, data = null) => {
    console.warn(formatLog('warn', message, data));
  },

  /**
   * Info level logging
   * Use for general information
   */
  info: (message, data = null) => {
    console.log(formatLog('info', message, data));
  },

  /**
   * Debug level logging
   * Use for debugging (only shown in development)
   */
  debug: (message, data = null) => {
    if (process.env.NODE_ENV === 'development') {
      console.log(formatLog('debug', message, data));
    }
  },
};

module.exports = logger;
