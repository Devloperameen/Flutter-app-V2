/**
 * ============================================
 * Activity Routes
 * ============================================
 * 
 * Endpoints for activity feed and achievements
 */

const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/authMiddleware');
const activityController = require('../controllers/activityController');

/**
 * GET /api/v1/activity/feed?page=1&limit=20&type=all
 * Get user's activity feed (paginated)
 */
router.get('/feed', authenticate, activityController.getActivityFeed);

/**
 * GET /api/v1/activity/today
 * Get today's activities
 */
router.get('/today', authenticate, activityController.getTodayActivities);

/**
 * GET /api/v1/activity/by-type/:type?limit=10
 * Get activities filtered by type
 */
router.get('/by-type/:type', authenticate, activityController.getActivitiesByType);

/**
 * GET /api/v1/activity/summary
 * Get activity summary (counts by type)
 */
router.get('/summary', authenticate, activityController.getActivitySummary);

/**
 * GET /api/v1/activity/achievements
 * Get user's achievements/milestones
 */
router.get('/achievements', authenticate, activityController.getAchievements);

/**
 * POST /api/v1/activity/:activityId/share
 * Share activity to community
 */
router.post('/:activityId/share', authenticate, activityController.shareActivity);

module.exports = router;
