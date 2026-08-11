/**
 * ============================================
 * User Controller
 * ============================================
 * 
 * Handles user profile operations:
 * - Get profile
 * - Update profile
 * - Update preferences
 * - Delete account
 */

const User = require('../models/User');
const logger = require('../utils/logger');
const { success, error, validationError, sendResponse } = require('../utils/response');

/**
 * Get user profile by ID
 * 
 * GET /api/v1/users/:userId
 */
const getUserProfile = async (req, res, next) => {
  try {
    const { userId } = req.params;

    const user = await User.findById(userId).select('-password');

    if (!user) {
      const errorResponse = error('User not found', 404);
      return sendResponse(res, errorResponse);
    }

    logger.info(`✅ User profile fetched: ${user.email}`);

    const responseData = success(user, 'User profile retrieved successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get user profile error:', error);
    next(error);
  }
};

/**
 * Update current user's profile
 * 
 * PUT /api/v1/users/me
 * Header: Authorization: Bearer <token>
 * Body: { fullName, avatar, bio }
 */
const updateProfile = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { fullName, avatar, bio } = req.body;

    // ─── Validate input ─────────────────────────
    const errors = [];

    if (fullName && (typeof fullName !== 'string' || fullName.trim().length === 0)) {
      errors.push('Full name must be a non-empty string');
    }

    if (fullName && fullName.length > 100) {
      errors.push('Full name must be less than 100 characters');
    }

    if (bio && bio.length > 500) {
      errors.push('Bio must be less than 500 characters');
    }

    if (errors.length > 0) {
      const errorResponse = validationError(errors, 'Profile update validation failed');
      return sendResponse(res, errorResponse);
    }

    // ─── Build update object ────────────────────
    const updateData = {};
    if (fullName) updateData.fullName = fullName.trim();
    if (avatar) updateData.avatar = avatar;
    if (bio !== undefined) updateData.bio = bio;

    // ─── Update user ────────────────────────────
    const updatedUser = await User.findByIdAndUpdate(userId, updateData, {
      new: true,
      runValidators: true,
    }).select('-password');

    logger.info(`✅ User profile updated: ${updatedUser.email}`);

    const responseData = success(updatedUser, 'Profile updated successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Update profile error:', error);
    next(error);
  }
};

/**
 * Update user preferences
 * 
 * PATCH /api/v1/users/me/preferences
 * Body: { theme, notifications }
 */
const updatePreferences = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { theme, notifications } = req.body;

    // ─── Validate input ─────────────────────────
    const errors = [];

    if (theme && !['light', 'dark'].includes(theme)) {
      errors.push('Theme must be "light" or "dark"');
    }

    if (errors.length > 0) {
      const errorResponse = validationError(errors, 'Preference validation failed');
      return sendResponse(res, errorResponse);
    }

    // ─── Build update object ────────────────────
    const updateData = {};

    if (theme) {
      updateData['preferences.theme'] = theme;
    }

    if (notifications) {
      if (typeof notifications.enabled === 'boolean') {
        updateData['preferences.notifications.enabled'] = notifications.enabled;
      }
      if (typeof notifications.email === 'boolean') {
        updateData['preferences.notifications.email'] = notifications.email;
      }
      if (typeof notifications.push === 'boolean') {
        updateData['preferences.notifications.push'] = notifications.push;
      }
    }

    // ─── Update user ────────────────────────────
    const updatedUser = await User.findByIdAndUpdate(userId, updateData, {
      new: true,
    }).select('-password');

    logger.info(`✅ User preferences updated: ${updatedUser.email}`);

    const responseData = success(updatedUser.preferences, 'Preferences updated successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Update preferences error:', error);
    next(error);
  }
};

/**
 * Change user password
 * 
 * POST /api/v1/users/me/change-password
 * Body: { currentPassword, newPassword }
 */
const changePassword = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { currentPassword, newPassword } = req.body;

    // ─── Validate input ─────────────────────────
    const errors = [];

    if (!currentPassword) {
      errors.push('Current password is required');
    }

    if (!newPassword || newPassword.length < 8) {
      errors.push('New password must be at least 8 characters');
    }

    if (currentPassword === newPassword) {
      errors.push('New password must be different from current password');
    }

    if (errors.length > 0) {
      const errorResponse = validationError(errors, 'Password change validation failed');
      return sendResponse(res, errorResponse);
    }

    // ─── Get user with password field ───────────
    const user = await User.findById(userId).select('+password');

    if (!user) {
      const errorResponse = error('User not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Verify current password ─────────────────
    const isValidPassword = await user.comparePassword(currentPassword);

    if (!isValidPassword) {
      const errorResponse = error('Current password is incorrect', 401);
      return sendResponse(res, errorResponse);
    }

    // ─── Update password ────────────────────────
    user.password = newPassword;
    await user.save();

    logger.info(`✅ Password changed for user: ${user.email}`);

    const responseData = success({ message: 'Password changed successfully' });
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Change password error:', error);
    next(error);
  }
};

/**
 * Delete user account
 * 
 * DELETE /api/v1/users/me
 * 
 * Handles:
 * - Soft delete (disable account)
 * - User confirmation via password
 */
const deleteAccount = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { password } = req.body;

    // ─── Validate input ─────────────────────────
    if (!password) {
      const errorResponse = validationError(['Password is required to delete account']);
      return sendResponse(res, errorResponse);
    }

    // ─── Get user with password field ───────────
    const user = await User.findById(userId).select('+password');

    if (!user) {
      const errorResponse = error('User not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Verify password ────────────────────────
    const isValidPassword = await user.comparePassword(password);

    if (!isValidPassword) {
      const errorResponse = error('Password is incorrect', 401);
      return sendResponse(res, errorResponse);
    }

    // ─── Soft delete (disable account) ──────────
    user.isActive = false;
    await user.save();

    logger.warn(`⚠️ User account deleted: ${user.email}`);

    const responseData = success({ message: 'Account deleted successfully' });
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Delete account error:', error);
    next(error);
  }
};

module.exports = {
  getUserProfile,
  updateProfile,
  updatePreferences,
  changePassword,
  deleteAccount,
};
