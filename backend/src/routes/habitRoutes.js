/**
 * ============================================
 * Habit Routes
 * ============================================
 * 
 * All routes require authentication
 * Middleware: authenticate
 * 
 * Endpoints for habit management
 */

const express = require('express');
const habitController = require('../controllers/habitController');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// ─── All routes are protected (require authentication) ───
router.use(authenticate);

/**
 * Get all habits
 * GET /api/v1/habits
 * Query params:
 *   - archived: 'true' | 'false' | 'all' (default: 'false')
 *   - limit: 1-100 (default: 50)
 *   - page: 1+ (default: 1)
 * 
 * Response:
 * {
 *   "success": true,
 *   "data": [{ habit1 }, { habit2 }, ...],
 *   "pagination": {
 *     "page": 1,
 *     "limit": 50,
 *     "total": 120,
 *     "pages": 3
 *   }
 * }
 */
router.get('/', habitController.getHabits);

/**
 * Get habit statistics
 * GET /api/v1/habits/stats
 * 
 * Returns user's overall habit statistics
 * {
 *   "totalHabits": 10,
 *   "activeHabits": 8,
 *   "completedToday": 5,
 *   "totalCompletions": 234,
 *   "currentStreak": 12
 * }
 */
router.get('/stats', habitController.getHabitStats);

/**
 * Create new habit
 * POST /api/v1/habits
 * 
 * Body:
 * {
 *   "title": "Morning Exercise",
 *   "emoji": "🏃",
 *   "color": "#FF6B6B",
 *   "category": "fitness",
 *   "description": "30 min morning run",
 *   "targetMinutes": 30,
 *   "reminderTime": "07:00"
 * }
 */
router.post('/', habitController.createHabit);

/**
 * Reorder habits
 * POST /api/v1/habits/reorder
 * 
 * Body:
 * {
 *   "habitIds": ["habitId1", "habitId2", "habitId3"]
 * }
 * 
 * Sets the order of habits in this sequence
 */
router.post('/reorder', habitController.reorderHabits);

/**
 * Get single habit
 * GET /api/v1/habits/:habitId
 */
router.get('/:habitId', habitController.getHabit);

/**
 * Update habit
 * PUT /api/v1/habits/:habitId
 * 
 * Body: Any fields to update
 * {
 *   "title": "Updated Title",
 *   "emoji": "🏋️",
 *   "targetMinutes": 45
 * }
 */
router.put('/:habitId', habitController.updateHabit);

/**
 * Mark habit as completed
 * POST /api/v1/habits/:habitId/complete
 * 
 * Increments:
 * - currentStreak (if not already completed today)
 * - longestStreak
 * - totalCompletions
 * Sets completedToday = true
 */
router.post('/:habitId/complete', habitController.markHabitComplete);

/**
 * Undo habit completion
 * POST /api/v1/habits/:habitId/undo
 * 
 * Reverts today's completion:
 * - Decrements currentStreak
 * - Decrements totalCompletions
 * - Sets completedToday = false
 */
router.post('/:habitId/undo', habitController.undoHabitComplete);

/**
 * Archive habit (soft delete)
 * PATCH /api/v1/habits/:habitId/archive
 * 
 * Hides habit from normal view but doesn't delete
 * Can be restored later
 */
router.patch('/:habitId/archive', habitController.archiveHabit);

/**
 * Restore archived habit
 * PATCH /api/v1/habits/:habitId/restore
 * 
 * Makes archived habit visible again
 */
router.patch('/:habitId/restore', habitController.restoreHabit);

/**
 * Delete habit permanently
 * DELETE /api/v1/habits/:habitId
 * 
 * Permanently removes the habit from database
 * Cannot be recovered
 */
router.delete('/:habitId', habitController.deleteHabit);

module.exports = router;
