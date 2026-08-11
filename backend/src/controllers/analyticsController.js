/**
 * ============================================
 * Analytics Controller
 * ============================================
 * 
 * Provides analytics data for dashboards
 * - Multi-period analytics (today, week, month, all-time)
 * - Habit completion metrics
 * - Focus session analytics
 * - XP progression charts
 * - Activity heatmap (calendar view)
 * - Leaderboard rankings
 * - User insights and suggestions
 */

const logger = require('../utils/logger');
const { success, error, paginated, sendResponse } = require('../utils/response');
const FocusSession = require('../models/FocusSession');
const UserXP = require('../models/UserXP');
const UserActivity = require('../models/UserActivity');
const Habit = require('../models/Habit');
const User = require('../models/User');

/**
 * Helper: Calculate date range for period
 * @param {string} period - 'today' | 'week' | 'month' | 'all-time'
 * @returns {object} { startDate, endDate }
 */
const getDateRange = (period) => {
  const now = new Date();
  let startDate = new Date();

  switch (period) {
    case 'today':
      startDate.setHours(0, 0, 0, 0);
      break;
    case 'week':
      const dayOfWeek = now.getDay();
      startDate.setDate(now.getDate() - dayOfWeek);
      startDate.setHours(0, 0, 0, 0);
      break;
    case 'month':
      startDate.setDate(1);
      startDate.setHours(0, 0, 0, 0);
      break;
    case 'all-time':
      startDate = new Date(0);
      break;
    default:
      startDate.setHours(0, 0, 0, 0);
  }

  return {
    startDate,
    endDate: new Date(now.getTime() + 86400000), // Next day end
  };
};

/**
 * Get multi-period analytics overview
 * 
 * GET /api/v1/analytics?period=today|week|month|all-time
 */
const getMultiPeriodAnalytics = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const period = req.query.period || 'week';

    // ─── Validate period ───────────────────────
    if (!['today', 'week', 'month', 'all-time'].includes(period)) {
      return sendResponse(res, error('Invalid period', 400));
    }

    const { startDate, endDate } = getDateRange(period);

    // ─── Get focus sessions ────────────────────
    const focusSessions = await FocusSession.find({
      userId,
      status: 'completed',
      completedAt: { $gte: startDate, $lt: endDate },
    }).lean();

    const totalFocusMinutes = focusSessions.reduce((sum, s) => sum + s.duration, 0);
    const totalFocusXP = focusSessions.reduce((sum, s) => sum + s.xpEarned, 0);

    // ─── Get habits ────────────────────────────
    const habits = await Habit.find({ userId }).lean();
    const habitCompletions = await UserActivity.find({
      userId,
      type: 'habit-completion',
      createdAt: { $gte: startDate, $lt: endDate },
    }).lean();

    const totalHabits = habits.length;
    const completedHabits = habitCompletions.length;

    // ─── Get XP ────────────────────────────────
    const activities = await UserActivity.find({
      userId,
      createdAt: { $gte: startDate, $lt: endDate },
    }).lean();

    const totalXP = activities.reduce((sum, a) => sum + a.xpEarned, 0);

    // ─── Get streaks ───────────────────────────
    let currentStreak = 0;
    let longestStreak = 0;
    const habitStreaks = [];

    for (const habit of habits) {
      const streak = await Habit.findById(habit._id).select('currentStreak longestStreak');
      if (streak) {
        habitStreaks.push({
          habitId: habit._id,
          name: habit.title,
          currentStreak: streak.currentStreak || 0,
        });
        currentStreak = Math.max(currentStreak, streak.currentStreak || 0);
        longestStreak = Math.max(longestStreak, streak.longestStreak || 0);
      }
    }

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        period,
        startDate: startDate.toISOString().split('T')[0],
        endDate: endDate.toISOString().split('T')[0],
        habits: {
          completed: completedHabits,
          total: totalHabits,
          percentage: totalHabits > 0 ? Math.round((completedHabits / totalHabits) * 100) : 0,
        },
        focus: {
          totalMinutes: totalFocusMinutes,
          sessions: focusSessions.length,
          averageDuration: focusSessions.length > 0 ? Math.round(totalFocusMinutes / focusSessions.length) : 0,
        },
        xpGained: totalXP,
        streaks: {
          current: currentStreak,
          longest: longestStreak,
          habits: habitStreaks,
        },
        activities: {
          count: activities.length,
          topTypes: activities
            .reduce((acc, a) => {
              const existing = acc.find(x => x.type === a.type);
              if (existing) existing.count++;
              else acc.push({ type: a.type, count: 1 });
              return acc;
            }, [])
            .sort((a, b) => b.count - a.count)
            .slice(0, 5),
        },
      },
      `Analytics for ${period} retrieved`,
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching analytics:', err);
    return sendResponse(res, error('Failed to retrieve analytics', 500));
  }
};

/**
 * Get habit completion metrics
 * 
 * GET /api/v1/analytics/habits?period=week
 */
const getHabitMetrics = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const period = req.query.period || 'week';

    const { startDate, endDate } = getDateRange(period);

    // ─── Get all habits ────────────────────────
    const habits = await Habit.find({ userId }).lean();

    // ─── Calculate metrics for each habit ──────
    const metrics = await Promise.all(
      habits.map(async (habit) => {
        const completions = await UserActivity.countDocuments({
          userId,
          type: 'habit-completion',
          'metadata.habitId': habit._id.toString(),
          createdAt: { $gte: startDate, $lt: endDate },
        });

        const xpEarned = await UserActivity.aggregate([
          {
            $match: {
              userId: new (require('mongoose')).Types.ObjectId(userId),
              type: 'habit-completion',
              'metadata.habitId': habit._id.toString(),
              createdAt: { $gte: startDate, $lt: endDate },
            },
          },
          {
            $group: { _id: null, total: { $sum: '$xpEarned' } },
          },
        ]);

        const lastCompletion = await UserActivity.findOne({
          userId,
          type: 'habit-completion',
          'metadata.habitId': habit._id.toString(),
        })
          .sort({ createdAt: -1 })
          .lean();

        return {
          habitId: habit._id,
          title: habit.title,
          emoji: habit.emoji,
          completionRate: completions,
          streak: habit.currentStreak || 0,
          xpEarned: xpEarned[0]?.total || 0,
          lastCompleted: lastCompletion?.createdAt || null,
        };
      })
    );

    // ─── Return response ────────────────────────
    const responseData = success(
      metrics.sort((a, b) => b.completionRate - a.completionRate),
      'Habit metrics retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching habit metrics:', err);
    return sendResponse(res, error('Failed to retrieve habit metrics', 500));
  }
};

/**
 * Get focus session analytics
 * 
 * GET /api/v1/analytics/focus?period=week
 */
const getFocusAnalytics = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const period = req.query.period || 'week';

    const { startDate, endDate } = getDateRange(period);

    // ─── Get all focus sessions ────────────────
    const sessions = await FocusSession.find({
      userId,
      status: 'completed',
      completedAt: { $gte: startDate, $lt: endDate },
    }).lean();

    // ─── Calculate metrics ─────────────────────
    const totalSessions = sessions.length;
    const totalMinutes = sessions.reduce((sum, s) => sum + s.duration, 0);
    const totalXP = sessions.reduce((sum, s) => sum + s.xpEarned, 0);
    const averageSessionLength = totalSessions > 0 ? Math.round(totalMinutes / totalSessions) : 0;

    // ─── Group by session type ─────────────────
    const sessionsByType = {
      '25min': sessions.filter(s => s.sessionType === '25min').length,
      '50min': sessions.filter(s => s.sessionType === '50min').length,
      custom: sessions.filter(s => s.sessionType === 'custom').length,
    };

    // ─── Group by day ──────────────────────────
    const dailyBreakdown = {};
    sessions.forEach((session) => {
      const date = new Date(session.completedAt);
      const dateStr = date.toISOString().split('T')[0];
      if (!dailyBreakdown[dateStr]) {
        dailyBreakdown[dateStr] = {
          date: dateStr,
          sessions: 0,
          minutes: 0,
          xp: 0,
        };
      }
      dailyBreakdown[dateStr].sessions++;
      dailyBreakdown[dateStr].minutes += session.duration;
      dailyBreakdown[dateStr].xp += session.xpEarned;
    });

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        period,
        totalSessions,
        completedSessions: totalSessions,
        abandonedSessions: 0,
        totalMinutes,
        averageSessionLength,
        sessionsByType,
        totalXP,
        dailyBreakdown: Object.values(dailyBreakdown),
      },
      'Focus analytics retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching focus analytics:', err);
    return sendResponse(res, error('Failed to retrieve focus analytics', 500));
  }
};

/**
 * Get XP progression chart data
 * 
 * GET /api/v1/analytics/xp-chart?days=30
 */
const getXPChartData = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const days = Math.min(parseInt(req.query.days) || 30, 365);

    // ─── Calculate date range ──────────────────
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const startDate = new Date(today);
    startDate.setDate(today.getDate() - days);

    // ─── Get user XP ───────────────────────────
    const userXP = await UserXP.findOne({ userId });

    // ─── Get activities ────────────────────────
    const activities = await UserActivity.find({
      userId,
      createdAt: { $gte: startDate, $lt: new Date(today.getTime() + 86400000) },
    })
      .sort({ createdAt: 1 })
      .lean();

    // ─── Build daily breakdown ─────────────────
    const dailyXP = {};
    for (let i = 0; i <= days; i++) {
      const date = new Date(today);
      date.setDate(date.getDate() - i);
      const dateStr = date.toISOString().split('T')[0];
      dailyXP[dateStr] = 0;
    }

    activities.forEach((activity) => {
      const dateStr = activity.createdAt.toISOString().split('T')[0];
      if (dailyXP[dateStr] !== undefined) {
        dailyXP[dateStr] += activity.xpEarned;
      }
    });

    const labels = Object.keys(dailyXP).reverse();
    const data = labels.map(label => dailyXP[label]);

    // ─── Calculate progress to next level ──────
    const xpForCurrentLevel = userXP?.getXPRequiredForLevel(userXP.level) || 0;
    const xpForNextLevel = userXP?.getXPRequiredForLevel((userXP?.level || 1) + 1) || 0;
    const xpInCurrentLevel = userXP?.totalXP - xpForCurrentLevel || 0;
    const xpToNextLevel = Math.max(0, xpForNextLevel - (userXP?.totalXP || 0));

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        labels,
        data,
        totalXP: userXP?.totalXP || 0,
        currentLevel: userXP?.level || 1,
        xpInCurrentLevel: xpInCurrentLevel,
        xpToNextLevel,
        xpForNextLevel: xpForNextLevel - xpForCurrentLevel,
      },
      'XP chart data retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching XP chart data:', err);
    return sendResponse(res, error('Failed to retrieve XP chart data', 500));
  }
};

/**
 * Get activity heatmap (calendar view)
 * 
 * GET /api/v1/analytics/heatmap?month=08&year=2026
 */
const getHeatmapData = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const year = parseInt(req.query.year) || new Date().getFullYear();
    const month = parseInt(req.query.month) || new Date().getMonth() + 1;

    // ─── Validate month/year ───────────────────
    if (month < 1 || month > 12) {
      return sendResponse(res, error('Invalid month', 400));
    }

    // ─── Get date range for month ──────────────
    const startDate = new Date(year, month - 1, 1);
    const endDate = new Date(year, month, 1);

    // ─── Get all activities for month ──────────
    const activities = await UserActivity.find({
      userId,
      createdAt: { $gte: startDate, $lt: endDate },
    }).lean();

    // ─── Build heatmap data ────────────────────
    const heatmapData = {};
    const daysInMonth = endDate.getDate();

    for (let day = 1; day < daysInMonth; day++) {
      const date = new Date(year, month - 1, day);
      const dateStr = date.toISOString().split('T')[0];
      heatmapData[dateStr] = {
        date: dateStr,
        activityCount: 0,
        intensity: 'none',
      };
    }

    activities.forEach((activity) => {
      const dateStr = activity.createdAt.toISOString().split('T')[0];
      if (heatmapData[dateStr]) {
        heatmapData[dateStr].activityCount++;
      }
    });

    // ─── Calculate intensity levels ────────────
    const counts = Object.values(heatmapData).map(d => d.activityCount);
    const maxCount = Math.max(...counts, 1);
    const midPoint = maxCount / 2;

    Object.keys(heatmapData).forEach((date) => {
      const count = heatmapData[date].activityCount;
      if (count === 0) heatmapData[date].intensity = 'none';
      else if (count < midPoint) heatmapData[date].intensity = 'low';
      else if (count < maxCount) heatmapData[date].intensity = 'medium';
      else heatmapData[date].intensity = 'high';
    });

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        month,
        year,
        data: Object.values(heatmapData),
      },
      'Heatmap data retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching heatmap data:', err);
    return sendResponse(res, error('Failed to retrieve heatmap data', 500));
  }
};

/**
 * Get leaderboard
 * 
 * GET /api/v1/analytics/leaderboard?limit=10
 */
const getLeaderboard = async (req, res, next) => {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 10, 100);

    // ─── Get top users by XP ───────────────────
    const topUsers = await UserXP.find()
      .sort({ totalXP: -1 })
      .limit(limit)
      .populate('userId', 'fullName avatar email')
      .lean();

    // ─── Format response ───────────────────────
    const leaderboard = topUsers.map((userXP, index) => ({
      rank: index + 1,
      userId: userXP.userId._id,
      fullName: userXP.userId.fullName,
      level: userXP.level,
      totalXP: userXP.totalXP,
      avatar: userXP.userId.avatar || null,
    }));

    // ─── Return response ────────────────────────
    const responseData = success(
      leaderboard,
      'Leaderboard retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching leaderboard:', err);
    return sendResponse(res, error('Failed to retrieve leaderboard', 500));
  }
};

/**
 * Get user's leaderboard rank
 * 
 * GET /api/v1/analytics/my-rank
 */
const getUserRank = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // ─── Get user's XP ─────────────────────────
    const userXP = await UserXP.findOne({ userId });

    if (!userXP) {
      return sendResponse(res, error('User XP data not found', 404));
    }

    // ─── Get rank (count of users with higher XP) ───
    const rank = await UserXP.countDocuments({
      totalXP: { $gt: userXP.totalXP },
    });

    // ─── Get total users ───────────────────────
    const totalUsers = await UserXP.countDocuments();

    // ─── Calculate percentile ──────────────────
    const percentile = Math.round(((totalUsers - rank) / totalUsers) * 100);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        rank: rank + 1,
        totalUsers,
        percentile,
        level: userXP.level,
        totalXP: userXP.totalXP,
      },
      'User rank retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching user rank:', err);
    return sendResponse(res, error('Failed to retrieve user rank', 500));
  }
};

/**
 * Get insights and suggestions
 * 
 * GET /api/v1/analytics/insights
 */
const getInsights = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const insights = [];

    // ─── Get user data ─────────────────────────
    const userXP = await UserXP.findOne({ userId });
    const habits = await Habit.find({ userId }).lean();
    const userRank = await UserXP.countDocuments({ totalXP: { $gt: userXP?.totalXP || 0 } });

    // ─── Streak milestone insight ──────────────
    if (userXP?.level && userXP.level % 5 === 0) {
      insights.push({
        type: 'level-milestone',
        message: `🎉 You've reached level ${userXP.level}! Keep up the momentum!`,
        priority: 'high',
      });
    }

    // ─── Habit consistency insight ─────────────
    const completedHabits = habits.filter(h => (h.completedToday || false));
    if (completedHabits.length === habits.length && habits.length > 0) {
      insights.push({
        type: 'perfect-day',
        message: '💪 Perfect day! You completed all your habits!',
        priority: 'high',
      });
    }

    // ─── Leaderboard insight ───────────────────
    if (userRank < 10) {
      insights.push({
        type: 'top-ranking',
        message: `🏆 You're in the top 10! Keep grinding!`,
        priority: 'medium',
      });
    }

    // ─── Streak warning ────────────────────────
    const activeHabits = habits.filter(h => h.status === 'active');
    const lowStreakHabits = activeHabits.filter(h => (h.currentStreak || 0) < 3);
    if (lowStreakHabits.length > 0) {
      insights.push({
        type: 'streak-warning',
        message: `⚠️ Your ${lowStreakHabits[0].title} streak is below 3 days. Don't lose it!`,
        priority: 'low',
      });
    }

    // ─── Return response ────────────────────────
    const responseData = success(
      insights,
      'Insights retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching insights:', err);
    return sendResponse(res, error('Failed to retrieve insights', 500));
  }
};

module.exports = {
  getMultiPeriodAnalytics,
  getHabitMetrics,
  getFocusAnalytics,
  getXPChartData,
  getHeatmapData,
  getLeaderboard,
  getUserRank,
  getInsights,
};
