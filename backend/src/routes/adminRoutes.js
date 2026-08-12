/**
 * ============================================
 * Admin Routes
 * ============================================
 * 
 * Admin dashboard endpoints with role-based access control
 * All routes require:
 * 1. Authentication (JWT token)
 * 2. Authorization (user.role === 'admin' or 'super_admin')
 * 
 * Security:
 * - Every endpoint checks user role
 * - Audit logs can be added for compliance
 * - Rate limited to prevent abuse
 */

const express = require('express');
const router = express.Router();
const { authenticate, authorize } = require('../middleware/auth');
const adminController = require('../controllers/adminController');

/**
 * ─────────────────────────────────────────────────
 * STATISTICS & ANALYTICS
 * ─────────────────────────────────────────────────
 */

/**
 * GET /api/v1/admin/stats
 * Get system statistics for dashboard
 * 
 * Requires: Admin role
 * 
 * Returns:
 * {
 *   "totalUsers": 156,
 *   "activeUsers": 23,
 *   "totalPosts": 342,
 *   "totalComments": 891,
 *   "todayNewUsers": 5,
 *   "todayPosts": 12,
 *   "todayComments": 34,
 *   "todaySessions": 78
 * }
 */
router.get('/stats', authenticate, authorize, adminController.getStats);

/**
 * ─────────────────────────────────────────────────
 * USER MANAGEMENT
 * ─────────────────────────────────────────────────
 */

/**
 * GET /api/v1/admin/users?page=1&limit=20
 * Get all users with pagination
 * 
 * Requires: Admin role
 * 
 * Query:
 * - page: Page number (default: 1)
 * - limit: Items per page (default: 20)
 * - role: Filter by role ('user', 'admin')
 * - isActive: Filter by status (true/false)
 */
router.get('/users', authenticate, authorize, adminController.getUsers);

/**
 * GET /api/v1/admin/users/:userId
 * Get user details for management
 * 
 * Requires: Admin role
 */
router.get('/users/:userId', authenticate, authorize, adminController.getUserDetails);

/**
 * PATCH /api/v1/admin/users/:userId/role
 * Change user role
 * 
 * Requires: Admin role
 * Body: { "role": "admin" | "user" }
 */
router.patch('/users/:userId/role', authenticate, authorize, adminController.updateUserRole);

/**
 * PATCH /api/v1/admin/users/:userId/status
 * Activate/deactivate user account
 * 
 * Requires: Admin role
 * Body: { "isActive": true | false }
 */
router.patch('/users/:userId/status', authenticate, authorize, adminController.updateUserStatus);

/**
 * DELETE /api/v1/admin/users/:userId
 * Soft delete user account
 * 
 * Requires: Admin role
 * Sets isActive = false
 */
router.delete('/users/:userId', authenticate, authorize, adminController.deleteUser);

/**
 * ─────────────────────────────────────────────────
 * CONTENT MODERATION
 * ─────────────────────────────────────────────────
 */

/**
 * GET /api/v1/admin/posts?page=1&limit=20
 * Get all posts for moderation
 * 
 * Requires: Admin role
 */
router.get('/posts', authenticate, authorize, adminController.getPosts);

/**
 * DELETE /api/v1/admin/posts/:postId
 * Delete post (hard delete)
 * 
 * Requires: Admin role
 */
router.delete('/posts/:postId', authenticate, authorize, adminController.deletePost);

/**
 * ─────────────────────────────────────────────────
 * AUDIT & LOGS
 * ─────────────────────────────────────────────────
 */

/**
 * GET /api/v1/admin/logs?page=1&limit=50
 * Get admin action logs
 * 
 * Requires: Admin role
 * Useful for compliance and audit trail
 */
router.get('/logs', authenticate, authorize, adminController.getAdminLogs);

module.exports = router;
