/**
 * ============================================
 * Habit Controller
 * ============================================
 * 
 * Handles all habit operations:
 * - CRUD operations
 * - Completion tracking
 * - Streak calculations
 * - Statistics
 */

const Habit = require('../models/Habit');
const User = require('../models/User');
const logger = require('../utils/logger');
const { success, error, validationError, paginated, sendResponse } = require('../utils/response');
const { validateHabit } = require('../utils/validators');

/**
 * Get all habits for current user
 * 
 * GET /api/v1/habits
 * Query params: ?archived=false&limit=50&page=1
 * 
 * Returns user's habits with optional filtering
 */
const getHabits = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { archived = false, limit = 50, page = 1 } = req.query;

    // ─── Parse and validate pagination ──────────
    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(100, parseInt(limit) || 50);
    const skip = (pageNum - 1) * limitNum;

    // ─── Build query filter ─────────────────────
    const filter = { userId };
    if (archived !== 'all') {
      filter.archived = archived === 'true';
    }

    // ─── Fetch habits ───────────────────────────
    const habits = await Habit.find(filter)
      .sort({ order: 1, createdAt: -1 })
      .skip(skip)
      .limit(limitNum);

    const total = await Habit.countDocuments(filter);

    logger.info(`✅ Fetched ${habits.length} habits for user ${userId}`);

    // ─── Return paginated response ──────────────
    const responseData = paginated(habits, pageNum, limitNum, total, 'Habits fetched successfully');

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get habits error:', error);
    next(error);
  }
};

/**
 * Get single habit by ID
 * 
 * GET /api/v1/habits/:habitId
 */
const getHabit = async (req, res, next) => {
  try {
    const { habitId } = req.params;
    const userId = req.user.id;

    // ─── Find habit ─────────────────────────────
    const habit = await Habit.findOne({
      _id: habitId,
      userId,
    });

    if (!habit) {
      const errorResponse = error('Habit not found', 404);
      return sendResponse(res, errorResponse);
    }

    logger.info(`✅ Fetched habit: ${habit.title}`);

    const responseData = success(habit, 'Habit retrieved successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get habit error:', error);
    next(error);
  }
};

/**
 * Create a new habit
 * 
 * POST /api/v1/habits
 * Body: { title, emoji, color, category, description, targetMinutes, reminderTime }
 */
const createHabit = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { title, emoji, color, category, description, targetMinutes, reminderTime } = req.body;

    // ─── Validate input ─────────────────────────
    const validation = validateHabit({ title, category, targetMinutes });
    if (!validation.valid) {
      const errorResponse = validationError(validation.errors, 'Habit validation failed');
      return sendResponse(res, errorResponse);
    }

    // ─── Get max order ──────────────────────────
    const lastHabit = await Habit.findOne({ userId }).sort({ order: -1 });
    const order = (lastHabit?.order || 0) + 1;

    // ─── Create habit ───────────────────────────
    const newHabit = new Habit({
      userId,
      title: title.trim(),
      emoji: emoji || '✨',
      color: color || '#FF6B6B',
      category: category || 'other',
      description: description ? description.trim() : '',
      targetMinutes: targetMinutes || 0,
      reminderTime,
      order,
    });

    await newHabit.save();

    logger.info(`✅ Habit created: ${newHabit.title}`);

    const responseData = success(newHabit, 'Habit created successfully', 201);
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Create habit error:', error);
    next(error);
  }
};

/**
 * Update a habit
 * 
 * PUT /api/v1/habits/:habitId
 * Body: { title, emoji, color, category, description, targetMinutes, reminderTime }
 */
const updateHabit = async (req, res, next) => {
  try {
    const { habitId } = req.params;
    const userId = req.user.id;

    // ─── Validate input ─────────────────────────
    const validation = validateHabit(req.body);
    if (!validation.valid) {
      const errorResponse = validationError(validation.errors, 'Habit validation failed');
      return sendResponse(res, errorResponse);
    }

    // ─── Update habit ───────────────────────────
    const updatedHabit = await Habit.findOneAndUpdate(
      { _id: habitId, userId },
      {
        ...req.body,
        updatedAt: new Date(),
      },
      { new: true, runValidators: true }
    );

    if (!updatedHabit) {
      const errorResponse = error('Habit not found', 404);
      return sendResponse(res, errorResponse);
    }

    logger.info(`✅ Habit updated: ${updatedHabit.title}`);

    const responseData = success(updatedHabit, 'Habit updated successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Update habit error:', error);
    next(error);
  }
};

/**
 * Mark habit as completed for today
 * 
 * POST /api/v1/habits/:habitId/complete
 * 
 * Handles:
 * - Streak calculation
 * - Completion tracking
 * - Statistics update
 */
const markHabitComplete = async (req, res, next) => {
  try {
    const { habitId } = req.params;
    const userId = req.user.id;

    // ─── Find habit ─────────────────────────────
    const habit = await Habit.findOne({
      _id: habitId,
      userId,
    });

    if (!habit) {
      const errorResponse = error('Habit not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Check if already completed today ───────
    if (habit.isCompletedToday()) {
      const responseData = success(habit, 'Habit already completed today');
      return sendResponse(res, responseData);
    }

    // ─── Mark complete ──────────────────────────
    habit.markComplete();
    await habit.save();

    // ─── Update user statistics ─────────────────
    const stats = await Habit.getUserStats(userId);
    await User.findByIdAndUpdate(userId, { 'stats': stats });

    logger.info(`✅ Habit marked complete: ${habit.title}, Streak: ${habit.currentStreak}`);

    const responseData = success(habit, 'Habit marked as completed', 200);
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Mark habit complete error:', error);
    next(error);
  }
};

/**
 * Undo habit completion for today
 * 
 * POST /api/v1/habits/:habitId/undo
 */
const undoHabitComplete = async (req, res, next) => {
  try {
    const { habitId } = req.params;
    const userId = req.user.id;

    // ─── Find habit ─────────────────────────────
    const habit = await Habit.findOne({
      _id: habitId,
      userId,
    });

    if (!habit) {
      const errorResponse = error('Habit not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Check if not completed today ───────────
    if (!habit.isCompletedToday()) {
      const responseData = success(habit, 'Habit was not completed today');
      return sendResponse(res, responseData);
    }

    // ─── Mark incomplete ────────────────────────
    habit.markIncomplete();
    await habit.save();

    // ─── Update user statistics ─────────────────
    const stats = await Habit.getUserStats(userId);
    await User.findByIdAndUpdate(userId, { 'stats': stats });

    logger.info(`✅ Habit completion undone: ${habit.title}, Streak: ${habit.currentStreak}`);

    const responseData = success(habit, 'Habit completion undone', 200);
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Undo habit complete error:', error);
    next(error);
  }
};

/**
 * Archive a habit
 * 
 * PATCH /api/v1/habits/:habitId/archive
 */
const archiveHabit = async (req, res, next) => {
  try {
    const { habitId } = req.params;
    const userId = req.user.id;

    const updatedHabit = await Habit.findOneAndUpdate(
      { _id: habitId, userId },
      { archived: true, updatedAt: new Date() },
      { new: true }
    );

    if (!updatedHabit) {
      const errorResponse = error('Habit not found', 404);
      return sendResponse(res, errorResponse);
    }

    logger.info(`📦 Habit archived: ${updatedHabit.title}`);

    const responseData = success(updatedHabit, 'Habit archived successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Archive habit error:', error);
    next(error);
  }
};

/**
 * Restore an archived habit
 * 
 * PATCH /api/v1/habits/:habitId/restore
 */
const restoreHabit = async (req, res, next) => {
  try {
    const { habitId } = req.params;
    const userId = req.user.id;

    const updatedHabit = await Habit.findOneAndUpdate(
      { _id: habitId, userId },
      { archived: false, updatedAt: new Date() },
      { new: true }
    );

    if (!updatedHabit) {
      const errorResponse = error('Habit not found', 404);
      return sendResponse(res, errorResponse);
    }

    logger.info(`♻️ Habit restored: ${updatedHabit.title}`);

    const responseData = success(updatedHabit, 'Habit restored successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Restore habit error:', error);
    next(error);
  }
};

/**
 * Delete a habit permanently
 * 
 * DELETE /api/v1/habits/:habitId
 */
const deleteHabit = async (req, res, next) => {
  try {
    const { habitId } = req.params;
    const userId = req.user.id;

    const deletedHabit = await Habit.findOneAndDelete({
      _id: habitId,
      userId,
    });

    if (!deletedHabit) {
      const errorResponse = error('Habit not found', 404);
      return sendResponse(res, errorResponse);
    }

    logger.info(`🗑️ Habit deleted: ${deletedHabit.title}`);

    const responseData = success({ message: 'Habit deleted successfully' });
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Delete habit error:', error);
    next(error);
  }
};

/**
 * Reorder habits
 * 
 * POST /api/v1/habits/reorder
 * Body: { habitIds: [id1, id2, id3, ...] }
 */
const reorderHabits = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { habitIds } = req.body;

    if (!Array.isArray(habitIds) || habitIds.length === 0) {
      const errorResponse = validationError(['habitIds must be a non-empty array']);
      return sendResponse(res, errorResponse);
    }

    // ─── Update order for each habit ────────────
    for (let i = 0; i < habitIds.length; i++) {
      await Habit.findOneAndUpdate(
        { _id: habitIds[i], userId },
        { order: i, updatedAt: new Date() }
      );
    }

    logger.info(`🔄 Reordered ${habitIds.length} habits`);

    const responseData = success({ message: 'Habits reordered successfully' });
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Reorder habits error:', error);
    next(error);
  }
};

/**
 * Get user's habit statistics
 * 
 * GET /api/v1/habits/stats
 */
const getHabitStats = async (req, res, next) => {
  try {
    const userId = req.user.id;

    const stats = await Habit.getUserStats(userId);

    logger.info(`📊 Fetched habit stats for user ${userId}`);

    const responseData = success(stats, 'Habit statistics retrieved successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get habit stats error:', error);
    next(error);
  }
};

module.exports = {
  getHabits,
  getHabit,
  createHabit,
  updateHabit,
  markHabitComplete,
  undoHabitComplete,
  archiveHabit,
  restoreHabit,
  deleteHabit,
  reorderHabits,
  getHabitStats,
};
