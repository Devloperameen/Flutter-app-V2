/**
 * ============================================
 * Activity Controller
 * ============================================
 * 
 * Manages user activity feed and achievements
 * - Track user activities and milestones
 * - Display activity history
 * - Manage achievements/badge system
 * - Filter and sort activities
 */

const logger = require('../utils/logger');
const { success, error, validationError, sendResponse, paginated } = require('../utils/response');
const UserActivity = require('../models/UserActivity');
const UserXP = require('../models/UserXP');
const User = require('../models/User');

/**
 * Get user's activity feed (paginated)
 * 
 * GET /api/v1/activity/feed?page=1&limit=20&type=all
 */
const getActivityFeed = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const page = parseInt(req.query.page) || 1;
    const limit = Math.min(parseInt(req.query.limit) || 20, 100);
    const skip = (page - 1) * limit;
    const typeFilter = req.query.type || 'all';

    // ─── Build query ───────────────────────────
    const query = { userId };
    if (typeFilter !== 'all') {
      query.type = typeFilter;
    }

    // ─── Fetch activities ──────────────────────
    const activities = await UserActivity.find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .lean();

    const total = await UserActivity.countDocuments(query);

    // ─── Return response ────────────────────────
    const responseData = paginated(
      activities,
      page,
      limit,
      total,
      'Activity feed retrieved'
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching activity feed:', err);
    return sendResponse(res, error('Failed to retrieve activity feed', 500));
  }
};

/**
 * Get today's activities
 * 
 * GET /api/v1/activity/today
 */
const getTodayActivities = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // ─── Get today's date range ────────────────
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    // ─── Fetch today's activities ──────────────
    const activities = await UserActivity.find({
      userId,
      createdAt: { $gte: today, $lt: tomorrow },
    })
      .sort({ createdAt: -1 })
      .lean();

    // ─── Return response ────────────────────────
    const responseData = success(
      activities,
      'Today\'s activities retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching today\'s activities:', err);
    return sendResponse(res, error('Failed to retrieve today\'s activities', 500));
  }
};

/**
 * Get activities by type
 * 
 * GET /api/v1/activity/by-type/:type?limit=10
 */
const getActivitiesByType = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { type } = req.params;
    const limit = Math.min(parseInt(req.query.limit) || 10, 100);

    // ─── Validate type ─────────────────────────
    const validTypes = [
      'habit-completion',
      'focus-completed',
      'streak-milestone',
      'level-up',
      'focus-abandoned',
      'achievement-unlocked',
    ];

    if (!validTypes.includes(type)) {
      return sendResponse(res, error(`Invalid activity type: ${type}`, 400));
    }

    // ─── Fetch activities ──────────────────────
    const activities = await UserActivity.find({
      userId,
      type,
    })
      .sort({ createdAt: -1 })
      .limit(limit)
      .lean();

    // ─── Return response ────────────────────────
    const responseData = success(
      activities,
      `Activities of type '${type}' retrieved`,
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error(`Error fetching activities by type:`, err);
    return sendResponse(res, error('Failed to retrieve activities by type', 500));
  }
};

/**
 * Get activity summary (counts by type)
 * 
 * GET /api/v1/activity/summary
 */
const getActivitySummary = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // ─── Get all activities ────────────────────
    const activities = await UserActivity.find({ userId }).lean();

    // ─── Count by type ─────────────────────────
    const byType = {
      'habit-completion': 0,
      'focus-completed': 0,
      'streak-milestone': 0,
      'level-up': 0,
      'focus-abandoned': 0,
      'achievement-unlocked': 0,
    };

    let totalXP = 0;

    activities.forEach((activity) => {
      if (byType[activity.type] !== undefined) {
        byType[activity.type]++;
      }
      totalXP += activity.xpEarned || 0;
    });

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        totalActivities: activities.length,
        byType,
        totalXP,
      },
      'Activity summary retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching activity summary:', err);
    return sendResponse(res, error('Failed to retrieve activity summary', 500));
  }
};

/**
 * Get user's achievements/milestones
 * 
 * GET /api/v1/activity/achievements
 */
const getAchievements = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // ─── Define all possible achievements ──────
    const allAchievements = [
      {
        id: 'first-habit-completion',
        name: 'First Step',
        description: 'Complete your first habit',
        icon: '🎯',
      },
      {
        id: 'week-streak-3',
        name: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: '🔥',
      },
      {
        id: 'level-5',
        name: 'Rising Star',
        description: 'Reach level 5',
        icon: '⭐',
      },
      {
        id: 'level-10',
        name: 'Legend',
        description: 'Reach level 10',
        icon: '👑',
      },
      {
        id: 'perfect-week',
        name: 'Perfect Week',
        description: 'Complete all habits for 7 days straight',
        icon: '💯',
      },
      {
        id: 'focus-100',
        name: 'Focus Master',
        description: 'Complete 100 focus sessions',
        icon: '🎯',
      },
      {
        id: 'habits-10',
        name: 'Habit Collector',
        description: 'Create 10 habits',
        icon: '📚',
      },
      {
        id: 'xp-10000',
        name: 'XP Hoarder',
        description: 'Earn 10,000 XP',
        icon: '💰',
      },
    ];

    // ─── Check which achievements are unlocked ─
    const userXP = await UserXP.findOne({ userId });
    const activities = await UserActivity.find({ userId }).lean();

    // ─── Calculate achievement progress ───────
    const achievements = allAchievements.map((achievement) => {
      let unlocked = false;
      let unlockedAt = null;
      let progress = 0;

      switch (achievement.id) {
        case 'first-habit-completion':
          const firstHabit = activities.find(a => a.type === 'habit-completion');
          unlocked = !!firstHabit;
          unlockedAt = firstHabit?.createdAt || null;
          break;

        case 'week-streak-3':
          unlocked = (userXP?.streakDays || 0) >= 7;
          break;

        case 'level-5':
          unlocked = (userXP?.level || 0) >= 5;
          break;

        case 'level-10':
          unlocked = (userXP?.level || 0) >= 10;
          break;

        case 'perfect-week':
          unlocked = (userXP?.perfectWeeks || 0) > 0;
          break;

        case 'focus-100':
          progress = activities.filter(a => a.type === 'focus-completed').length;
          unlocked = progress >= 100;
          break;

        case 'habits-10':
          progress = activities.filter(a => a.type === 'habit-creation').length;
          unlocked = progress >= 10;
          break;

        case 'xp-10000':
          progress = userXP?.totalXP || 0;
          unlocked = progress >= 10000;
          break;
      }

      return {
        id: achievement.id,
        name: achievement.name,
        description: achievement.description,
        icon: achievement.icon,
        unlocked,
        unlockedAt,
        progress: !unlocked ? progress : 100,
      };
    });

    // ─── Return response ────────────────────────
    const responseData = success(
      achievements,
      'Achievements retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching achievements:', err);
    return sendResponse(res, error('Failed to retrieve achievements', 500));
  }
};

/**
 * Create activity (Internal use)
 * Called by other controllers to create activity entries
 * 
 * POST /api/v1/activity/create (Internal only)
 * Body: { userId, type, metadata, xpEarned }
 */
const createActivity = async (userId, type, metadata, xpEarned = 0) => {
  try {
    const activity = new UserActivity({
      userId,
      type,
      metadata,
      xpEarned,
    });

    await activity.save();
    logger.info(`✅ Activity created: ${type} for user ${userId}`);

    return activity;
  } catch (err) {
    logger.error('Error creating activity:', err);
    throw err;
  }
};

/**
 * Share activity to community (future feature)
 * 
 * POST /api/v1/activity/:activityId/share
 */
const shareActivity = async (req, res, next) => {
  try {
    const { activityId } = req.params;
    const userId = req.user.id;

    // ─── Validate activity exists ──────────────
    const activity = await UserActivity.findById(activityId);

    if (!activity) {
      return sendResponse(res, error('Activity not found', 404));
    }

    if (activity.userId.toString() !== userId) {
      return sendResponse(res, error('Unauthorized', 403));
    }

    // ─── Mark as shared ────────────────────────
    activity.shared = true;
    activity.sharedAt = new Date();
    await activity.save();

    logger.info(`✅ Activity shared: ${activityId}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: activity._id,
        shared: true,
        sharedAt: activity.sharedAt,
        message: 'Activity shared to community!',
      },
      'Activity shared successfully',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error sharing activity:', err);
    return sendResponse(res, error('Failed to share activity', 500));
  }
};

/**
 * Check and unlock achievements
 * Called internally when user completes actions
 * 
 * @param {string} userId - User ID
 * @param {string} achievementId - Achievement ID
 */
const checkAchievementUnlock = async (userId, achievementId) => {
  try {
    const achievement = await UserActivity.findOne({
      userId,
      type: 'achievement-unlocked',
      'metadata.achievementId': achievementId,
    });

    // Already unlocked
    if (achievement) return false;

    // Unlock achievement
    const newActivity = new UserActivity({
      userId,
      type: 'achievement-unlocked',
      xpEarned: 100, // Bonus XP for achievement unlock
      metadata: {
        achievementId,
      },
    });

    await newActivity.save();

    // Update user XP
    const userXP = await UserXP.findOne({ userId });
    if (userXP) {
      await userXP.addXP(100);
    }

    logger.info(
      `🏆 Achievement unlocked: ${achievementId} for user ${userId}`
    );

    return true;
  } catch (err) {
    logger.error('Error checking achievement unlock:', err);
    return false;
  }
};

module.exports = {
  getActivityFeed,
  getTodayActivities,
  getActivitiesByType,
  getActivitySummary,
  getAchievements,
  createActivity,
  shareActivity,
  checkAchievementUnlock,
};
