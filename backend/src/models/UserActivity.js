/**
 * ============================================
 * UserActivity Model
 * ============================================
 * 
 * Tracks all user achievements and milestones
 * Powers the activity feed and achievement system
 */

const mongoose = require('mongoose');

/**
 * UserActivity Schema Definition
 * 
 * Fields:
 * - userId: Reference to the user
 * - type: Activity type (habit-completion, focus-completed, mission-done, activity-shared)
 * - habitId: Reference to habit (if applicable)
 * - xpEarned: XP points awarded for this activity
 * - streakInfo: Streak data if activity is streak-related
 * - metadata: Additional contextual data
 * - createdAt: When the activity occurred
 */
const userActivitySchema = new mongoose.Schema(
  {
    // ─── Relationship ────────────────────────────
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
    },

    // ─── Activity Type ───────────────────────────
    type: {
      type: String,
      enum: {
        values: [
          'habit-completion',
          'focus-completed',
          'mission-done',
          'activity-shared',
          'streak-milestone',
          'level-up',
        ],
        message: 'Invalid activity type',
      },
      required: [true, 'Activity type is required'],
    },

    // ─── Related Entity ──────────────────────────
    habitId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Habit',
      default: null,
    },

    // ─── Rewards ──────────────────────────────────
    xpEarned: {
      type: Number,
      default: 0,
      min: [0, 'XP cannot be negative'],
    },

    // ─── Streak Information ──────────────────────
    streakInfo: {
      currentStreak: {
        type: Number,
        default: 0,
      },
      longestStreak: {
        type: Number,
        default: 0,
      },
      streakMilestone: {
        type: Number,
        default: null,
      }, // e.g., 7, 14, 30 days
    },

    // ─── Additional Context ──────────────────────
    metadata: {
      // For habit-completion: habit title, emoji
      habitTitle: String,
      habitEmoji: String,

      // For focus-completed: session duration, session type
      sessionDuration: Number,
      sessionType: String,

      // For mission-done: mission name
      missionName: String,

      // For activity-shared: what was shared
      sharedContent: String,

      // For level-up: new level
      newLevel: Number,

      // For streak-milestone: which milestone
      milestoneType: String, // e.g., "7-day", "30-day", "100-day"

      // Any other contextual data
      description: String,
    },
  },
  {
    timestamps: true,
  }
);

/**
 * ─────────────────────────────────────────────────
 * INDEXES - Improve query performance
 * ─────────────────────────────────────────────────
 */

// Get user's activity feed sorted by date
userActivitySchema.index({ userId: 1, createdAt: -1 });

// Get activities by type
userActivitySchema.index({ type: 1, createdAt: -1 });

// Get recent activities for a user
userActivitySchema.index({ userId: 1, type: 1, createdAt: -1 });

// Get habit-related activities
userActivitySchema.index({ habitId: 1, createdAt: -1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save: Validate data before saving
 */
userActivitySchema.pre('save', function (next) {
  // Validate type-specific requirements
  if (this.type === 'habit-completion' && !this.habitId) {
    throw new Error('Habit completion activities must have a habitId');
  }

  next();
});

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get recent activities for a user
 * 
 * Returns the most recent activities for the feed
 * 
 * Usage:
 * const activities = await UserActivity.getRecentActivity(userId, 20);
 * 
 * @param {string} userId - User's MongoDB ID
 * @param {number} limit - Number of activities to return (default 10)
 * @returns {Promise<Array>} Array of recent activities
 */
userActivitySchema.statics.getRecentActivity = async function (
  userId,
  limit = 10
) {
  return await this.find({ userId })
    .sort({ createdAt: -1 })
    .limit(limit)
    .populate('habitId', 'title emoji color');
};

/**
 * Get today's activities for a user
 * 
 * Returns all activities created today
 * 
 * Usage:
 * const todayActivities = await UserActivity.getTodayActivity(userId);
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<Array>} Array of today's activities
 */
userActivitySchema.statics.getTodayActivity = async function (userId) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);

  return await this.find({
    userId,
    createdAt: { $gte: today, $lt: tomorrow },
  }).sort({ createdAt: -1 });
};

/**
 * Get activities by type for a user
 * 
 * @param {string} userId - User's MongoDB ID
 * @param {string} type - Activity type
 * @param {number} limit - Number of activities (default 10)
 * @returns {Promise<Array>} Filtered activities
 */
userActivitySchema.statics.getActivitiesByType = async function (
  userId,
  type,
  limit = 10
) {
  return await this.find({ userId, type })
    .sort({ createdAt: -1 })
    .limit(limit);
};

/**
 * Get activity summary for dashboard
 * 
 * Returns count of each activity type
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<object>} Activity counts by type
 */
userActivitySchema.statics.getActivitySummary = async function (userId) {
  const activities = await this.find({ userId });

  const summary = {
    totalActivities: activities.length,
    byType: {},
    totalXP: 0,
  };

  for (const activity of activities) {
    if (!summary.byType[activity.type]) {
      summary.byType[activity.type] = 0;
    }
    summary.byType[activity.type] += 1;
    summary.totalXP += activity.xpEarned;
  }

  return summary;
};

/**
 * Get today's XP earned
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<number>} Total XP earned today
 */
userActivitySchema.statics.getTodayXP = async function (userId) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);

  const activities = await this.find({
    userId,
    createdAt: { $gte: today, $lt: tomorrow },
  });

  return activities.reduce((sum, activity) => sum + activity.xpEarned, 0);
};

/**
 * Create a habit completion activity
 * 
 * @param {object} data - Activity data
 * @returns {Promise<UserActivity>} Created activity
 */
userActivitySchema.statics.createHabitCompletion = async function (data) {
  return await this.create({
    userId: data.userId,
    type: 'habit-completion',
    habitId: data.habitId,
    xpEarned: data.xpEarned || 25,
    metadata: {
      habitTitle: data.habitTitle,
      habitEmoji: data.habitEmoji,
    },
  });
};

/**
 * Create a focus session completion activity
 * 
 * @param {object} data - Activity data
 * @returns {Promise<UserActivity>} Created activity
 */
userActivitySchema.statics.createFocusCompleted = async function (data) {
  return await this.create({
    userId: data.userId,
    type: 'focus-completed',
    xpEarned: data.xpEarned || 50,
    metadata: {
      sessionDuration: data.sessionDuration,
      sessionType: data.sessionType,
    },
  });
};

/**
 * Create a streak milestone activity
 * 
 * @param {object} data - Activity data
 * @returns {Promise<UserActivity>} Created activity
 */
userActivitySchema.statics.createStreakMilestone = async function (data) {
  return await this.create({
    userId: data.userId,
    type: 'streak-milestone',
    habitId: data.habitId,
    xpEarned: data.xpEarned || 100,
    streakInfo: {
      currentStreak: data.currentStreak,
      longestStreak: data.longestStreak,
      streakMilestone: data.streakMilestone,
    },
    metadata: {
      habitTitle: data.habitTitle,
      milestoneType: data.milestoneType,
    },
  });
};

/**
 * Create a level up activity
 * 
 * @param {object} data - Activity data
 * @returns {Promise<UserActivity>} Created activity
 */
userActivitySchema.statics.createLevelUp = async function (data) {
  return await this.create({
    userId: data.userId,
    type: 'level-up',
    xpEarned: 0,
    metadata: {
      newLevel: data.newLevel,
      totalXP: data.totalXP,
    },
  });
};

// Export the UserActivity model
module.exports = mongoose.model('UserActivity', userActivitySchema);
