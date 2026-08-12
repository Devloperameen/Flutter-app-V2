/**
 * ============================================
 * Analytics Routes
 * ============================================
 * 
 * Endpoints for dashboard analytics and statistics
 */

const express = require('express');
const router = express.Router();
const { authenticate, optional } = require('../middleware/auth');
const analyticsController = require('../controllers/analyticsController');

/**
 * GET /api/v1/analytics?period=today|week|month|all-time
 * Get multi-period analytics overview
 */
router.get('/', authenticate, analyticsController.getMultiPeriodAnalytics);

/**
 * GET /api/v1/analytics/habits?period=week
 * Get habit completion metrics
 */
router.get('/habits', authenticate, analyticsController.getHabitMetrics);

/**
 * GET /api/v1/analytics/focus?period=week
 * Get focus session analytics
 */
router.get('/focus', authenticate, analyticsController.getFocusAnalytics);

/**
 * GET /api/v1/analytics/xp-chart?days=30
 * Get XP progression chart data
 */
router.get('/xp-chart', authenticate, analyticsController.getXPChartData);

/**
 * GET /api/v1/analytics/heatmap?month=08&year=2026
 * Get activity heatmap (calendar view)
 */
router.get('/heatmap', authenticate, analyticsController.getHeatmapData);

/**
 * GET /api/v1/analytics/leaderboard?limit=10
 * Get global leaderboard (public)
 */
router.get('/leaderboard', optional, analyticsController.getLeaderboard);

/**
 * GET /api/v1/analytics/my-rank
 * Get user's leaderboard rank
 */
router.get('/my-rank', authenticate, analyticsController.getUserRank);

/**
 * GET /api/v1/analytics/insights
 * Get insights and suggestions for the user
 */
router.get('/insights', authenticate, analyticsController.getInsights);

module.exports = router;
