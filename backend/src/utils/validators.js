/**
 * ============================================
 * Input Validators
 * ============================================
 * 
 * Utility functions for validating user input
 * Prevents bad data from entering the database
 */

const validator = require('validator');

/**
 * Validate email format
 * @param {string} email - Email to validate
 * @returns {boolean} True if valid
 */
const isValidEmail = (email) => {
  return validator.isEmail(email);
};

/**
 * Validate password strength
 * Requirements:
 * - Minimum 8 characters
 * - At least one uppercase letter
 * - At least one lowercase letter
 * - At least one number
 * 
 * @param {string} password - Password to validate
 * @returns {object} { valid: boolean, errors: array }
 */
const validatePassword = (password) => {
  const errors = [];

  if (!password || password.length < 8) {
    errors.push('Password must be at least 8 characters');
  }
  if (!/[A-Z]/.test(password)) {
    errors.push('Password must contain at least one uppercase letter');
  }
  if (!/[a-z]/.test(password)) {
    errors.push('Password must contain at least one lowercase letter');
  }
  if (!/\d/.test(password)) {
    errors.push('Password must contain at least one number');
  }

  return {
    valid: errors.length === 0,
    errors,
  };
};

/**
 * Validate habit data
 * @param {object} habitData - Habit object to validate
 * @returns {object} { valid: boolean, errors: array }
 */
const validateHabit = (habitData) => {
  const errors = [];
  const { title, category, targetMinutes } = habitData;

  if (!title || typeof title !== 'string' || title.trim().length === 0) {
    errors.push('Habit title is required and must be a non-empty string');
  }

  if (title && title.length > 100) {
    errors.push('Habit title must be less than 100 characters');
  }

  const validCategories = ['mindfulness', 'fitness', 'learning', 'health', 'productivity', 'creativity', 'social', 'entertainment', 'other'];
  if (category && !validCategories.includes(category)) {
    errors.push(`Category must be one of: ${validCategories.join(', ')}`);
  }

  if (targetMinutes && (typeof targetMinutes !== 'number' || targetMinutes < 0)) {
    errors.push('Target minutes must be a non-negative number');
  }

  return {
    valid: errors.length === 0,
    errors,
  };
};

/**
 * Validate user data
 * @param {object} userData - User object to validate
 * @returns {object} { valid: boolean, errors: array }
 */
const validateUserData = (userData) => {
  const errors = [];
  const { email, password, fullName } = userData;

  if (!isValidEmail(email)) {
    errors.push('Invalid email format');
  }

  const passwordValidation = validatePassword(password);
  if (!passwordValidation.valid) {
    errors.push(...passwordValidation.errors);
  }

  if (!fullName || fullName.trim().length === 0) {
    errors.push('Full name is required');
  }

  if (fullName && fullName.length > 100) {
    errors.push('Full name must be less than 100 characters');
  }

  return {
    valid: errors.length === 0,
    errors,
  };
};

/**
 * Sanitize user input
 * Removes potentially dangerous characters
 * @param {string} input - String to sanitize
 * @returns {string} Sanitized string
 */
const sanitizeInput = (input) => {
  if (typeof input !== 'string') return input;
  
  // Remove HTML/script tags
  return input
    .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
    .replace(/<[^>]*>/g, '')
    .trim();
};

module.exports = {
  isValidEmail,
  validatePassword,
  validateHabit,
  validateUserData,
  sanitizeInput,
};
