/**
 * ============================================
 * Dashboard Routes
 * ============================================
 * 
 * Endpoints for dashboard/home screen
 * All routes require authentication
 */

const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const dashboardController = require('../controllers/dashboardController');

/**
 * GET /api/v1/dashboard
 * Get dashboard data for home screen
 * 
 * Returns:
 * {
 *   "userName": "John Doe",
 *   "userAvatar": "https://...",
 *   "todayMission": { ... },
 *   "energyLevel": "High",
 *   "streakDays": 5,
 *   "dailyQuote": { "text": "...", "author": "..." }
 * }
 */
router.get('/', authenticate, dashboardController.getDashboard);

module.exports = router;
