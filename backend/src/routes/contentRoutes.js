/**
 * ============================================
 * Content Routes
 * ============================================
 * 
 * Endpoints for content management (quotes, videos, reports)
 * and community moderation
 */

const express = require('express');
const router = express.Router();
const { authenticate, optional } = require('../middleware/authMiddleware');
const { apiLimiter } = require('../middleware/rateLimiter');
const contentController = require('../controllers/contentController');

// ─────────────────────────────────────────────
// QUOTE ROUTES
// ─────────────────────────────────────────────

/**
 * GET /api/v1/content/quote?category=motivation|fitness
 * Get random motivational quote
 */
router.get('/quote', optional, contentController.getRandomQuote);

/**
 * GET /api/v1/content/quote/today
 * Get today's featured quote (same for all users)
 */
router.get('/quote/today', optional, contentController.getTodayQuote);

/**
 * GET /api/v1/content/quotes?category=fitness&page=1&limit=10
 * Get quotes by category (paginated)
 */
router.get('/quotes', optional, contentController.getQuotesByCategory);

/**
 * POST /api/v1/content/quote
 * Create quote (ADMIN only)
 */
router.post('/quote', authenticate, apiLimiter, contentController.createQuote);

/**
 * PUT /api/v1/content/quote/:quoteId
 * Update quote (ADMIN + creator only)
 */
router.put('/quote/:quoteId', authenticate, contentController.updateQuote);

/**
 * DELETE /api/v1/content/quote/:quoteId
 * Delete quote (ADMIN + creator only)
 */
router.delete('/quote/:quoteId', authenticate, contentController.deleteQuote);

/**
 * PATCH /api/v1/content/quote/:quoteId/toggle
 * Toggle quote active status (ADMIN only)
 */
router.patch('/quote/:quoteId/toggle', authenticate, contentController.toggleQuoteActive);

// ─────────────────────────────────────────────
// VIDEO ROUTES
// ─────────────────────────────────────────────

/**
 * GET /api/v1/content/video?category=motivation
 * Get random YouTube video
 */
router.get('/video', optional, contentController.getRandomVideo);

/**
 * GET /api/v1/content/videos?category=motivation&page=1&limit=5
 * Get videos by category (paginated)
 */
router.get('/videos', optional, contentController.getVideosByCategory);

/**
 * POST /api/v1/content/video
 * Create video (ADMIN only)
 */
router.post('/video', authenticate, apiLimiter, contentController.createVideo);

/**
 * PUT /api/v1/content/video/:videoId
 * Update video (ADMIN + creator only)
 */
router.put('/video/:videoId', authenticate, contentController.updateVideo);

/**
 * DELETE /api/v1/content/video/:videoId
 * Delete video (ADMIN + creator only)
 */
router.delete('/video/:videoId', authenticate, contentController.deleteVideo);

/**
 * PATCH /api/v1/content/video/:videoId/toggle
 * Toggle video active status (ADMIN only)
 */
router.patch('/video/:videoId/toggle', authenticate, contentController.toggleVideoActive);

// ─────────────────────────────────────────────
// REPORT/MODERATION ROUTES
// ─────────────────────────────────────────────

/**
 * POST /api/v1/content/report
 * Report inappropriate content
 */
router.post('/report', authenticate, contentController.reportContent);

/**
 * GET /api/v1/content/reports/queue?status=pending&limit=20
 * Get moderation queue (ADMIN only)
 */
router.get('/reports/queue', authenticate, contentController.getModerationQueue);

/**
 * POST /api/v1/content/report/:reportId/resolve
 * Resolve report (ADMIN only)
 */
router.post('/report/:reportId/resolve', authenticate, contentController.resolveReport);

module.exports = router;
