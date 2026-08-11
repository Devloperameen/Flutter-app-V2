/**
 * ============================================
 * Focus Session Routes
 * ============================================
 * 
 * Endpoints for managing focus/deep work sessions
 */

const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/authMiddleware');
const { apiLimiter } = require('../middleware/rateLimiter');
const focusSessionController = require('../controllers/focusSessionController');

/**
 * POST /api/v1/focus
 * Create a new focus session
 * Body: { sessionType: '25min'|'50min'|'custom', duration?: number }
 */
router.post('/', authenticate, apiLimiter, focusSessionController.createSession);

/**
 * GET /api/v1/focus/active
 * Get user's active session (if any)
 */
router.get('/active', authenticate, focusSessionController.getActiveSession);

/**
 * GET /api/v1/focus/history?page=1&limit=10
 * Get user's completed sessions with pagination
 */
router.get('/history', authenticate, focusSessionController.getSessionHistory);

/**
 * POST /api/v1/focus/:sessionId/complete
 * Mark session as completed and award XP
 */
router.post('/:sessionId/complete', authenticate, focusSessionController.completeSession);

/**
 * POST /api/v1/focus/:sessionId/abandon
 * Abandon active session without XP
 */
router.post('/:sessionId/abandon', authenticate, focusSessionController.abandonSession);

/**
 * GET /api/v1/focus/stats/today
 * Get today's focus statistics
 */
router.get('/stats/today', authenticate, focusSessionController.getDailyStats);

/**
 * GET /api/v1/focus/stats/weekly
 * Get this week's focus statistics
 */
router.get('/stats/weekly', authenticate, focusSessionController.getWeeklyStats);

module.exports = router;
