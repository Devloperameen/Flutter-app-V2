/**
 * ============================================
 * User Routes
 * ============================================
 * 
 * Endpoints for user profile management
 * All routes require authentication
 */

const express = require('express');
const userController = require('../controllers/userController');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// ─── All routes are protected (require authentication) ───
router.use(authenticate);

/**
 * Get user profile by ID
 * GET /api/v1/users/:userId
 * 
 * Get any user's public profile
 * (Password excluded for security)
 */
router.get('/:userId', userController.getUserProfile);

/**
 * Update current user profile
 * PUT /api/v1/users/me
 * 
 * Body:
 * {
 *   "fullName": "John Doe",
 *   "avatar": "https://...",
 *   "bio": "Fitness enthusiast"
 * }
 */
router.put('/me', userController.updateProfile);

/**
 * Update user preferences
 * PATCH /api/v1/users/me/preferences
 * 
 * Body:
 * {
 *   "theme": "dark",
 *   "notifications": {
 *     "enabled": true,
 *     "email": false,
 *     "push": true
 *   }
 * }
 */
router.patch('/me/preferences', userController.updatePreferences);

/**
 * Change password
 * POST /api/v1/users/me/change-password
 * 
 * Body:
 * {
 *   "currentPassword": "OldPass123",
 *   "newPassword": "NewPass456"
 * }
 */
router.post('/me/change-password', userController.changePassword);

/**
 * Delete account
 * DELETE /api/v1/users/me
 * 
 * Body:
 * {
 *   "password": "UserPassword123"
 * }
 * 
 * Requires password confirmation for security
 * Soft deletes account (sets isActive = false)
 */
router.delete('/me', userController.deleteAccount);

module.exports = router;
