/**
 * ============================================
 * Focus Session Controller
 * ============================================
 * 
 * Manages focus sessions (Pomodoro-style deep work)
 * - Create, track, and complete focus sessions
 * - Award XP for completed sessions
 * - Track daily and weekly statistics
 * - Update user achievements
 * 
 * XP Calculation:
 * - Base XP: 10 XP per minute
 * - Completion Bonus: 50 XP
 * - Total: (duration * 10) + 50
 */

const logger = require('../utils/logger');
const { success, error, validationError, sendResponse, paginated } = require('../utils/response');
const FocusSession = require('../models/FocusSession');
const UserXP = require('../models/UserXP');
const UserActivity = require('../models/UserActivity');
const User = require('../models/User');

/**
 * Create a new focus session
 * 
 * POST /api/v1/focus
 * Body: { sessionType, duration? }
 * 
 * sessionType: '25min' | '50min' | 'custom'
 * duration: minutes (optional, only for custom)
 */
const createSession = async (req, res, next) => {
  try {
    const { sessionType, duration } = req.body;
    const userId = req.user.id;

    // ─── Validate Input ─────────────────────────
    if (!sessionType || !['25min', '50min', 'custom'].includes(sessionType)) {
      const errorResponse = validationError(
        ['Invalid session type'],
        'Session type must be 25min, 50min, or custom'
      );
      return sendResponse(res, errorResponse);
    }

    // ─── Determine Duration ─────────────────────
    let finalDuration = duration;
    if (sessionType === '25min') finalDuration = 25;
    if (sessionType === '50min') finalDuration = 50;
    
    if (!finalDuration || finalDuration < 1 || finalDuration > 300) {
      const errorResponse = validationError(
        ['Invalid duration'],
        'Duration must be between 1 and 300 minutes'
      );
      return sendResponse(res, errorResponse);
    }

    // ─── Check for active session ───────────────
    const activeSession = await FocusSession.findOne({
      userId,
      status: 'active',
    });

    if (activeSession) {
      const errorResponse = error(
        'You already have an active focus session',
        409
      );
      return sendResponse(res, errorResponse);
    }

    // ─── Create new session ─────────────────────
    const newSession = new FocusSession({
      userId,
      sessionType,
      duration: finalDuration,
      startedAt: new Date(),
      status: 'active',
    });

    await newSession.save();
    logger.info(`✅ Focus session created: ${newSession._id} for user ${userId}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: newSession._id,
        userId: newSession.userId,
        sessionType: newSession.sessionType,
        duration: newSession.duration,
        startedAt: newSession.startedAt,
        status: newSession.status,
      },
      'Focus session started successfully',
      201
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error creating focus session:', err);
    const errorResponse = error('Failed to create focus session', 500);
    return sendResponse(res, errorResponse);
  }
};

/**
 * Get user's active session (if any)
 * 
 * GET /api/v1/focus/active
 */
const getActiveSession = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // ─── Find active session ────────────────────
    const activeSession = await FocusSession.findOne(
      { userId, status: 'active' },
      'duration startedAt sessionType status'
    ).lean();

    // ─── Return response ────────────────────────
    const responseData = success(
      activeSession || null,
      'Active session retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error getting active session:', err);
    const errorResponse = error('Failed to retrieve active session', 500);
    return sendResponse(res, errorResponse);
  }
};

/**
 * Get user's completed sessions (paginated)
 * 
 * GET /api/v1/focus/history?page=1&limit=10
 */
const getSessionHistory = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const page = parseInt(req.query.page) || 1;
    const limit = Math.min(parseInt(req.query.limit) || 10, 100);
    const skip = (page - 1) * limit;

    // ─── Fetch sessions ─────────────────────────
    const sessions = await FocusSession.find(
      { userId, status: { $in: ['completed', 'abandoned'] } },
      'sessionType duration xpEarned status completedAt'
    )
      .sort({ completedAt: -1 })
      .skip(skip)
      .limit(limit)
      .lean();

    const total = await FocusSession.countDocuments({
      userId,
      status: { $in: ['completed', 'abandoned'] },
    });

    // ─── Return response ────────────────────────
    const responseData = paginated(
      sessions,
      page,
      limit,
      total,
      'Session history retrieved'
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching session history:', err);
    const errorResponse = error('Failed to retrieve session history', 500);
    return sendResponse(res, errorResponse);
  }
};

/**
 * Mark session as completed and award XP
 * 
 * POST /api/v1/focus/:sessionId/complete
 */
const completeSession = async (req, res, next) => {
  try {
    const { sessionId } = req.params;
    const userId = req.user.id;

    // ─── Validate session exists ────────────────
    const session = await FocusSession.findById(sessionId);

    if (!session) {
      const errorResponse = error('Focus session not found', 404);
      return sendResponse(res, errorResponse);
    }

    if (session.userId.toString() !== userId) {
      const errorResponse = error('Unauthorized', 403);
      return sendResponse(res, errorResponse);
    }

    if (session.status !== 'active') {
      const errorResponse = error(
        `Cannot complete a ${session.status} session`,
        400
      );
      return sendResponse(res, errorResponse);
    }

    // ─── Calculate XP ──────────────────────────
    // XP: 10 per minute + 50 bonus
    const xpEarned = session.duration * 10 + 50;

    // ─── Update session ────────────────────────
    session.status = 'completed';
    session.completedAt = new Date();
    session.xpEarned = xpEarned;
    await session.save();

    logger.info(
      `✅ Focus session completed: ${sessionId}, XP earned: ${xpEarned}`
    );

    // ─── Update user XP ────────────────────────
    let userXP = await UserXP.findOne({ userId });
    if (!userXP) {
      userXP = new UserXP({ userId, totalXP: 0, level: 1 });
    }

    await userXP.addXP(xpEarned);
    logger.info(
      `✅ User XP updated: ${userId}, New total: ${userXP.totalXP}`
    );

    // ─── Create activity entry ─────────────────
    const activity = new UserActivity({
      userId,
      type: 'focus-completed',
      xpEarned,
      metadata: {
        sessionId: session._id,
        duration: session.duration,
        sessionType: session.sessionType,
      },
    });
    await activity.save();

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: session._id,
        status: session.status,
        xpEarned,
        message: `🎉 Great focus session! ${xpEarned} XP earned!`,
        newLevel: userXP.level,
      },
      'Focus session completed successfully',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error completing focus session:', err);
    const errorResponse = error('Failed to complete focus session', 500);
    return sendResponse(res, errorResponse);
  }
};

/**
 * Abandon active session (no XP earned)
 * 
 * POST /api/v1/focus/:sessionId/abandon
 */
const abandonSession = async (req, res, next) => {
  try {
    const { sessionId } = req.params;
    const userId = req.user.id;

    // ─── Validate session exists ────────────────
    const session = await FocusSession.findById(sessionId);

    if (!session) {
      const errorResponse = error('Focus session not found', 404);
      return sendResponse(res, errorResponse);
    }

    if (session.userId.toString() !== userId) {
      const errorResponse = error('Unauthorized', 403);
      return sendResponse(res, errorResponse);
    }

    if (session.status !== 'active') {
      const errorResponse = error(
        `Cannot abandon a ${session.status} session`,
        400
      );
      return sendResponse(res, errorResponse);
    }

    // ─── Update session ────────────────────────
    session.status = 'abandoned';
    session.completedAt = new Date();
    session.xpEarned = 0;
    await session.save();

    logger.info(`⚠️ Focus session abandoned: ${sessionId}`);

    // ─── Create activity entry ─────────────────
    const activity = new UserActivity({
      userId,
      type: 'focus-abandoned',
      xpEarned: 0,
      metadata: {
        sessionId: session._id,
        duration: session.duration,
        sessionType: session.sessionType,
      },
    });
    await activity.save();

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: session._id,
        status: session.status,
        xpEarned: 0,
        message: 'Session abandoned. No XP earned.',
      },
      'Focus session abandoned',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error abandoning focus session:', err);
    const errorResponse = error('Failed to abandon focus session', 500);
    return sendResponse(res, errorResponse);
  }
};

/**
 * Get today's focus statistics
 * 
 * GET /api/v1/focus/stats/today
 */
const getDailyStats = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // ─── Get today's date range ────────────────
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    // ─── Query sessions from today ──────────────
    const todaySessions = await FocusSession.find({
      userId,
      status: { $in: ['completed', 'abandoned'] },
      completedAt: { $gte: today, $lt: tomorrow },
    }).lean();

    // ─── Calculate stats ───────────────────────
    const completedSessions = todaySessions.filter(s => s.status === 'completed');
    const totalSessions = todaySessions.length;
    const totalMinutes = todaySessions.reduce((sum, s) => sum + s.duration, 0);
    const totalXP = completedSessions.reduce((sum, s) => sum + s.xpEarned, 0);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        date: today.toISOString().split('T')[0],
        totalSessions,
        completedSessions: completedSessions.length,
        abandonedSessions: totalSessions - completedSessions.length,
        totalMinutes,
        totalXP,
        averageSessionLength:
          completedSessions.length > 0
            ? Math.round(totalMinutes / completedSessions.length)
            : 0,
      },
      'Today\'s focus stats retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching daily stats:', err);
    const errorResponse = error('Failed to retrieve daily stats', 500);
    return sendResponse(res, errorResponse);
  }
};

/**
 * Get weekly focus statistics
 * 
 * GET /api/v1/focus/stats/weekly
 */
const getWeeklyStats = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // ─── Get this week's date range ────────────
    const today = new Date();
    const dayOfWeek = today.getDay();
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - dayOfWeek);
    startOfWeek.setHours(0, 0, 0, 0);

    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 7);

    // ─── Query sessions from this week ─────────
    const weeklySessions = await FocusSession.find({
      userId,
      status: { $in: ['completed', 'abandoned'] },
      completedAt: { $gte: startOfWeek, $lt: endOfWeek },
    }).lean();

    // ─── Calculate stats ───────────────────────
    const completedSessions = weeklySessions.filter(s => s.status === 'completed');
    const totalSessions = weeklySessions.length;
    const totalMinutes = weeklySessions.reduce((sum, s) => sum + s.duration, 0);
    const totalXP = completedSessions.reduce((sum, s) => sum + s.xpEarned, 0);

    // ─── Group by session type ─────────────────
    const byType = {
      '25min': weeklySessions.filter(s => s.sessionType === '25min').length,
      '50min': weeklySessions.filter(s => s.sessionType === '50min').length,
      custom: weeklySessions.filter(s => s.sessionType === 'custom').length,
    };

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        weekStart: startOfWeek.toISOString().split('T')[0],
        weekEnd: endOfWeek.toISOString().split('T')[0],
        totalSessions,
        completedSessions: completedSessions.length,
        abandonedSessions: totalSessions - completedSessions.length,
        totalMinutes,
        totalXP,
        averageSessionLength:
          completedSessions.length > 0
            ? Math.round(totalMinutes / completedSessions.length)
            : 0,
        bySessionType: byType,
      },
      'Weekly focus stats retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching weekly stats:', err);
    const errorResponse = error('Failed to retrieve weekly stats', 500);
    return sendResponse(res, errorResponse);
  }
};

module.exports = {
  createSession,
  getActiveSession,
  getSessionHistory,
  completeSession,
  abandonSession,
  getDailyStats,
  getWeeklyStats,
};
