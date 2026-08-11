/**
 * ============================================
 * Habit Model
 * ============================================
 * 
 * Represents a user's habit in FitFlow
 * Tracks habit data, completion status, and streaks
 */

const mongoose = require('mongoose');

/**
 * Habit Schema Definition
 * 
 * Structure:
 * - userId: Reference to the user who owns this habit
 * - title: Display name of the habit
 * - emoji: Visual icon for the habit
 * - color: Hex color for UI display
 * - category: Type of habit (health, productivity, etc.)
 * - description: Details about the habit
 * - reminder: Notification settings
 * - targetMinutes: Goal time for the habit
 * - completion: Status and streak tracking
 * - archived: Soft delete flag
 * - order: Display order in UI
 */
const habitSchema = new mongoose.Schema(
  {
    // ─── Relationship ────────────────────────────
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
    },

    // ─── Basic Information ───────────────────────
    title: {
      type: String,
      required: [true, 'Habit title is required'],
      trim: true,
      maxlength: [100, 'Title must be less than 100 characters'],
    },

    // ─── Visual Properties ───────────────────────
    emoji: {
      type: String,
      default: '✨',
      maxlength: [2, 'Emoji must be a single character'],
    },
    color: {
      type: String,
      default: '#FF6B6B',
      match: [/^#[0-9A-F]{6}$/i, 'Invalid color hex format'],
    },

    // ─── Classification ──────────────────────────
    category: {
      type: String,
      enum: {
        values: ['health', 'productivity', 'learning', 'fitness', 'other'],
        message: 'Invalid category',
      },
      default: 'other',
    },

    // ─── Description ─────────────────────────────
    description: {
      type: String,
      default: '',
      maxlength: [500, 'Description must be less than 500 characters'],
    },

    // ─── Reminder Settings ───────────────────────
    reminderEnabled: {
      type: Boolean,
      default: false,
    },
    reminderTime: {
      type: String, // Format: "HH:MM" (e.g., "09:00")
      default: null,
    },

    // ─── Goal ────────────────────────────────────
    targetMinutes: {
      type: Number,
      default: 0,
      min: [0, 'Target minutes cannot be negative'],
    },

    // ─── Completion Status ───────────────────────
    completedToday: {
      type: Boolean,
      default: false,
    },
    lastCompletedDate: {
      type: Date,
      default: null,
    },

    // ─── Streak Tracking ─────────────────────────
    // Streak: consecutive days habit was completed
    currentStreak: {
      type: Number,
      default: 0,
      min: [0, 'Streak cannot be negative'],
    },
    longestStreak: {
      type: Number,
      default: 0,
      min: [0, 'Streak cannot be negative'],
    },

    // ─── Statistics ──────────────────────────────
    totalCompletions: {
      type: Number,
      default: 0,
      min: [0, 'Total completions cannot be negative'],
    },

    // ─── Organization ────────────────────────────
    archived: {
      type: Boolean,
      default: false,
    },
    order: {
      type: Number,
      default: 0,
    },
  },
  {
    // Automatically add createdAt and updatedAt
    timestamps: true,
  }
);

/**
 * ─────────────────────────────────────────────────
 * INDEXES - Improve query performance
 * ─────────────────────────────────────────────────
 */

// Most common query: Get user's habits sorted by date
habitSchema.index({ userId: 1, createdAt: -1 });

// Get non-archived habits for active display
habitSchema.index({ userId: 1, archived: 0 });

// Get today's completed habits
habitSchema.index({ userId: 1, completedToday: 1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save: Validate data before saving
 */
habitSchema.pre('save', function (next) {
  // Ensure reminder time format if reminder is enabled
  if (this.reminderEnabled && this.reminderTime) {
    const timeRegex = /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/;
    if (!timeRegex.test(this.reminderTime)) {
      throw new Error('Invalid reminder time format (use HH:MM)');
    }
  }

  next();
});

/**
 * ─────────────────────────────────────────────────
 * METHODS - Custom instance methods
 * ─────────────────────────────────────────────────
 */

/**
 * Check if habit was completed today
 * 
 * @returns {boolean} True if completed today
 */
habitSchema.methods.isCompletedToday = function () {
  if (!this.lastCompletedDate) return false;

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const lastDay = new Date(this.lastCompletedDate);
  lastDay.setHours(0, 0, 0, 0);

  return today.getTime() === lastDay.getTime();
};

/**
 * Mark habit as completed
 * 
 * Handles:
 * - Updating completedToday flag
 * - Calculating streak
 * - Updating statistics
 * 
 * Returns the updated habit
 */
habitSchema.methods.markComplete = function () {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  // Check if already completed today
  if (this.isCompletedToday()) {
    return this;
  }

  // Check if streak should continue (completed yesterday)
  const lastDay = new Date(this.lastCompletedDate || new Date(0));
  lastDay.setHours(0, 0, 0, 0);

  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);

  if (lastDay.getTime() === yesterday.getTime()) {
    // Yesterday was completed, increment streak
    this.currentStreak += 1;
  } else if (lastDay.getTime() !== today.getTime()) {
    // Streak is broken, start new streak
    this.currentStreak = 1;
  }

  // Update longest streak
  if (this.currentStreak > this.longestStreak) {
    this.longestStreak = this.currentStreak;
  }

  // Update statistics
  this.completedToday = true;
  this.totalCompletions += 1;
  this.lastCompletedDate = today;

  return this;
};

/**
 * Undo completion for today
 * 
 * Returns the updated habit
 */
habitSchema.methods.markIncomplete = function () {
  if (!this.isCompletedToday()) {
    return this;
  }

  // Decrement streak
  this.currentStreak = Math.max(0, this.currentStreak - 1);

  // Update statistics
  this.completedToday = false;
  this.totalCompletions = Math.max(0, this.totalCompletions - 1);

  // Reset lastCompletedDate if no more completions
  if (this.totalCompletions === 0) {
    this.lastCompletedDate = null;
  }

  return this;
};

/**
 * Get completion percentage
 * (Only meaningful if targetMinutes is set)
 * 
 * @returns {number} Percentage 0-100
 */
habitSchema.methods.getCompletionPercentage = function () {
  if (this.targetMinutes === 0) {
    return this.completedToday ? 100 : 0;
  }

  // In production, track actual minutes completed
  // For now, return simple yes/no
  return this.completedToday ? 100 : 0;
};

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get all active habits for a user
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<Array>} Array of habit documents
 */
habitSchema.statics.getActiveHabits = async function (userId) {
  return await this.find({
    userId,
    archived: false,
  }).sort({ order: 1, createdAt: -1 });
};

/**
 * Get completed habits for today
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<Array>} Array of today's completions
 */
habitSchema.statics.getTodayCompletions = async function (userId) {
  return await this.find({
    userId,
    completedToday: true,
  });
};

/**
 * Get user's stats for dashboard
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<object>} Stats object
 */
habitSchema.statics.getUserStats = async function (userId) {
  const habits = await this.find({ userId });

  return {
    totalHabits: habits.length,
    activeHabits: habits.filter((h) => !h.archived).length,
    completedToday: habits.filter((h) => h.completedToday).length,
    totalCompletions: habits.reduce((sum, h) => sum + h.totalCompletions, 0),
    currentStreak: Math.max(...habits.map((h) => h.currentStreak), 0),
  };
};

// Export the Habit model
module.exports = mongoose.model('Habit', habitSchema);
