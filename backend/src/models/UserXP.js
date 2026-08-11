/**
 * ============================================
 * UserXP Model
 * ============================================
 * 
 * Tracks XP points and level progression for users
 * Central hub for all XP and gamification data
 */

const mongoose = require('mongoose');

/**
 * UserXP Schema Definition
 * 
 * Fields:
 * - userId: Reference to the user
 * - totalXP: Cumulative XP across all time
 * - currentLevel: Current level
 * - xpForNextLevel: XP needed to reach next level
 * - xpGainedToday: XP earned in current day
 * - lastXPUpdateDate: Last time XP was updated
 * - levelHistory: Array of level progression records
 */
const userXPSchema = new mongoose.Schema(
  {
    // ─── Relationship ────────────────────────────
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
      unique: true,
    },

    // ─── XP Tracking ─────────────────────────────
    totalXP: {
      type: Number,
      default: 0,
      min: [0, 'Total XP cannot be negative'],
    },

    currentLevel: {
      type: Number,
      default: 1,
      min: [1, 'Level must be at least 1'],
      max: [100, 'Level cannot exceed 100'],
    },

    // ─── Level Progression ───────────────────────
    xpForNextLevel: {
      type: Number,
      default: 1000, // 1000 XP to reach level 2
      min: [0, 'XP for next level cannot be negative'],
    },

    // ─── Daily Tracking ──────────────────────────
    xpGainedToday: {
      type: Number,
      default: 0,
      min: [0, 'Daily XP cannot be negative'],
    },

    lastXPUpdateDate: {
      type: Date,
      default: () => new Date(),
    },

    // ─── Level History ───────────────────────────
    // Track when user reached each level
    levelHistory: [
      {
        level: {
          type: Number,
          required: true,
        },
        xpAtLevel: {
          type: Number,
          required: true,
        },
        reachedAt: {
          type: Date,
          default: () => new Date(),
        },
      },
    ],

    // ─── Achievements ────────────────────────────
    achievements: {
      firstCompletion: {
        type: Boolean,
        default: false,
      },
      firstFocusSession: {
        type: Boolean,
        default: false,
      },
      level5: {
        type: Boolean,
        default: false,
      },
      level10: {
        type: Boolean,
        default: false,
      },
      weeklyStreak: {
        type: Boolean,
        default: false,
      },
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

// Get user's XP data
userXPSchema.index({ userId: 1 });

// Get top users by level and XP (leaderboard)
userXPSchema.index({ currentLevel: -1, totalXP: -1 });

// Get recently leveled up users
userXPSchema.index({ updatedAt: -1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save: Update daily XP tracking
 */
userXPSchema.pre('save', function (next) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const lastUpdate = new Date(this.lastXPUpdateDate);
  lastUpdate.setHours(0, 0, 0, 0);

  // Reset daily XP if it's a new day
  if (today.getTime() !== lastUpdate.getTime()) {
    this.xpGainedToday = 0;
  }

  next();
});

/**
 * ─────────────────────────────────────────────────
 * METHODS - Custom instance methods
 * ─────────────────────────────────────────────────
 */

/**
 * Add XP to the user's total
 * 
 * Handles:
 * - Adding XP to total
 * - Updating daily XP
 * - Level calculation
 * - Updating lastXPUpdateDate
 * 
 * @param {number} amount - XP amount to add
 * @returns {object} Result object with levelUp info
 */
userXPSchema.methods.addXP = function (amount) {
  const result = {
    xpAdded: amount,
    leveledUp: false,
    newLevel: null,
  };

  // Update today's date tracking
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const lastUpdate = new Date(this.lastXPUpdateDate);
  lastUpdate.setHours(0, 0, 0, 0);

  // Reset daily XP if it's a new day
  if (today.getTime() !== lastUpdate.getTime()) {
    this.xpGainedToday = 0;
  }

  // Add XP
  this.totalXP += amount;
  this.xpGainedToday += amount;
  this.lastXPUpdateDate = new Date();

  // Check for level up
  const levelUpResult = this.calculateLevel();
  if (levelUpResult.leveledUp) {
    result.leveledUp = true;
    result.newLevel = this.currentLevel;
  }

  return result;
};

/**
 * Calculate current level based on totalXP
 * 
 * Level progression (exponential):
 * - Level 1: 0 XP
 * - Level 2: 1,000 XP
 * - Level 3: 2,300 XP (1,000 + 1,300)
 * - Level 4: 4,060 XP (1,000 + 1,300 + 1,760)
 * - And so on...
 * 
 * Each level requires 30% more XP than previous
 * 
 * Returns object with:
 * - leveledUp: boolean if level increased
 * - previousLevel: what level was before
 * - newLevel: current level
 * 
 * @returns {object} Level calculation result
 */
userXPSchema.methods.calculateLevel = function () {
  const result = {
    leveledUp: false,
    previousLevel: this.currentLevel,
  };

  const previousLevel = this.currentLevel;

  // Calculate XP thresholds for each level
  // Level 1 = 0 XP, Level 2 = 1000 XP, Level 3 = 2300 XP, etc.
  const baseXP = 1000;
  const multiplier = 1.3; // 30% increase per level

  let currentThreshold = 0;
  let nextLevel = 1;

  // Find the correct level
  while (currentThreshold <= this.totalXP && nextLevel < 100) {
    nextLevel += 1;
    currentThreshold += Math.floor(baseXP * Math.pow(multiplier, nextLevel - 2));
  }

  this.currentLevel = nextLevel - 1;

  // Calculate XP needed for next level
  const nextThreshold = currentThreshold;
  const previousThreshold =
    nextThreshold - Math.floor(baseXP * Math.pow(multiplier, nextLevel - 2));

  this.xpForNextLevel = Math.max(0, nextThreshold - this.totalXP);

  // Check if leveled up
  if (this.currentLevel > previousLevel) {
    result.leveledUp = true;

    // Add to level history
    this.levelHistory.push({
      level: this.currentLevel,
      xpAtLevel: this.totalXP,
      reachedAt: new Date(),
    });
  }

  result.newLevel = this.currentLevel;
  return result;
};

/**
 * Get XP progress to next level
 * 
 * Returns:
 * - currentLevel: Current level
 * - nextLevel: Level after this one
 * - totalXP: Total cumulative XP
 * - xpInCurrentLevel: XP earned towards current level
 * - xpNeededForLevel: Total XP needed to reach current level
 * - xpForNextLevel: XP needed to reach next level
 * - progressPercent: Percentage through current level
 * 
 * @returns {object} Progress object
 */
userXPSchema.methods.getXPProgress = function () {
  const baseXP = 1000;
  const multiplier = 1.3;

  // Calculate total XP needed to reach current level
  let xpNeededForCurrentLevel = 0;
  for (let i = 2; i <= this.currentLevel; i++) {
    xpNeededForCurrentLevel += Math.floor(baseXP * Math.pow(multiplier, i - 2));
  }

  // XP earned within current level
  const xpInCurrentLevel = this.totalXP - xpNeededForCurrentLevel;

  // XP needed to reach next level
  const xpNeededForNextLevel = Math.floor(
    baseXP * Math.pow(multiplier, this.currentLevel - 1)
  );

  const progressPercent =
    xpNeededForNextLevel > 0
      ? Math.round((xpInCurrentLevel / xpNeededForNextLevel) * 100)
      : 0;

  return {
    currentLevel: this.currentLevel,
    nextLevel: this.currentLevel + 1,
    totalXP: this.totalXP,
    xpInCurrentLevel: xpInCurrentLevel,
    xpNeededForCurrentLevel: xpNeededForCurrentLevel,
    xpForNextLevel: this.xpForNextLevel,
    xpNeededForLevel: xpNeededForNextLevel,
    progressPercent: Math.min(100, progressPercent),
  };
};

/**
 * Get user's leaderboard ranking
 * 
 * Note: This is an instance method that queries for ranking
 * In production, might want to cache this
 * 
 * @returns {Promise<object>} Ranking info
 */
userXPSchema.methods.getLeaderboardRank = async function () {
  const Model = mongoose.model('UserXP');

  const rank = await Model.countDocuments({
    totalXP: { $gt: this.totalXP },
  });

  return {
    rank: rank + 1,
    totalXP: this.totalXP,
    currentLevel: this.currentLevel,
  };
};

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get or create XP record for a user
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<UserXP>} XP document
 */
userXPSchema.statics.getOrCreate = async function (userId) {
  let userXP = await this.findOne({ userId });

  if (!userXP) {
    userXP = await this.create({
      userId,
      totalXP: 0,
      currentLevel: 1,
      xpForNextLevel: 1000,
    });
  }

  return userXP;
};

/**
 * Get leaderboard (top users by level and XP)
 * 
 * @param {number} limit - Number of top users (default 10)
 * @returns {Promise<Array>} Top users
 */
userXPSchema.statics.getLeaderboard = async function (limit = 10) {
  return await this.find()
    .sort({ currentLevel: -1, totalXP: -1 })
    .limit(limit)
    .populate('userId', 'fullName avatar email');
};

/**
 * Get top users by XP in timeframe
 * 
 * @param {number} days - Number of days to look back
 * @param {number} limit - Number of users (default 10)
 * @returns {Promise<Array>} Top users
 */
userXPSchema.statics.getTopUsersByXPGained = async function (days = 7, limit = 10) {
  const dateThreshold = new Date();
  dateThreshold.setDate(dateThreshold.getDate() - days);

  return await this.find({
    updatedAt: { $gte: dateThreshold },
  })
    .sort({ totalXP: -1 })
    .limit(limit)
    .populate('userId', 'fullName avatar email');
};

/**
 * Get user's rank in leaderboard
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<object>} Ranking info
 */
userXPSchema.statics.getUserRank = async function (userId) {
  const userXP = await this.findOne({ userId });

  if (!userXP) {
    return {
      rank: null,
      totalUsers: 0,
      percentile: null,
    };
  }

  const rank = await this.countDocuments({
    totalXP: { $gt: userXP.totalXP },
  });

  const totalUsers = await this.countDocuments();

  return {
    rank: rank + 1,
    totalUsers,
    percentile: Math.round(((totalUsers - rank) / totalUsers) * 100),
  };
};

// Export the UserXP model
module.exports = mongoose.model('UserXP', userXPSchema);
