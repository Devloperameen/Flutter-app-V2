/**
 * ============================================
 * FocusSession Model
 * ============================================
 * 
 * Represents a focus/deep work session
 * Tracks Pomodoro-style work sessions and XP earned
 */

const mongoose = require('mongoose');

/**
 * FocusSession Schema Definition
 * 
 * Fields:
 * - userId: Reference to the user
 * - sessionType: Duration template (25min/50min/custom)
 * - duration: Actual duration in minutes
 * - startedAt: Session start timestamp
 * - completedAt: Session completion timestamp
 * - xpEarned: XP points awarded
 * - status: Current session state
 */
const focusSessionSchema = new mongoose.Schema(
  {
    // ─── Relationship ────────────────────────────
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
    },

    // ─── Session Configuration ───────────────────
    sessionType: {
      type: String,
      enum: {
        values: ['25min', '50min', 'custom'],
        message: 'Invalid session type',
      },
      required: [true, 'Session type is required'],
    },

    // ─── Duration ─────────────────────────────────
    duration: {
      type: Number,
      required: [true, 'Duration is required'],
      min: [1, 'Duration must be at least 1 minute'],
      validate: {
        validator: function (v) {
          return v > 0;
        },
        message: 'Duration must be greater than 0',
      },
    },

    // ─── Timing ──────────────────────────────────
    startedAt: {
      type: Date,
      required: [true, 'Start time is required'],
    },
    completedAt: {
      type: Date,
      default: null,
    },

    // ─── XP Rewards ──────────────────────────────
    xpEarned: {
      type: Number,
      default: 0,
      min: [0, 'XP cannot be negative'],
    },

    // ─── Status ──────────────────────────────────
    status: {
      type: String,
      enum: {
        values: ['active', 'completed', 'abandoned'],
        message: 'Invalid status',
      },
      default: 'active',
    },

    // ─── Notes ────────────────────────────────────
    notes: {
      type: String,
      default: '',
      maxlength: [500, 'Notes must be less than 500 characters'],
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

// Get user's sessions sorted by date
focusSessionSchema.index({ userId: 1, completedAt: -1 });

// Get sessions by status
focusSessionSchema.index({ status: 1, completedAt: -1 });

// Get active sessions for a user
focusSessionSchema.index({ userId: 1, status: 1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save: Validate data before saving
 */
focusSessionSchema.pre('save', function (next) {
  // Validate duration is positive
  if (this.duration <= 0) {
    throw new Error('Duration must be greater than 0');
  }

  // Validate status transitions
  if (this.isModified('status')) {
    // Can transition from active to completed or abandoned
    if (this.status === 'completed' && !this.completedAt) {
      this.completedAt = new Date();
    }

    // If transitioning to completed, must have completedAt
    if (this.status === 'completed' && !this.completedAt) {
      throw new Error('Completed sessions must have a completedAt timestamp');
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
 * Calculate XP earned based on session duration
 * 
 * Formula:
 * - Base: 10 XP per minute
 * - Bonus: 50 XP if session completed (status = completed)
 * 
 * @returns {number} XP earned
 */
focusSessionSchema.methods.calculateXP = function () {
  let xp = this.duration * 10; // Base: 10 XP per minute

  // Bonus for completing session
  if (this.status === 'completed') {
    xp += 50;
  }

  return xp;
};

/**
 * Get session statistics
 * 
 * Returns:
 * - duration: Session length in minutes
 * - focusTime: Actual focused time (if tracked)
 * - xpPerMinute: Average XP earned per minute
 * - isCompleted: Whether session finished
 * - durationMinutes: How long until completion (if active)
 * 
 * @returns {object} Statistics object
 */
focusSessionSchema.methods.getSessionStats = function () {
  const stats = {
    duration: this.duration,
    xpEarned: this.xpEarned,
    xpPerMinute: this.duration > 0 ? (this.xpEarned / this.duration).toFixed(2) : 0,
    isCompleted: this.status === 'completed',
    isAbandoned: this.status === 'abandoned',
    isActive: this.status === 'active',
  };

  // Add elapsed time if active
  if (this.status === 'active') {
    const now = new Date();
    const elapsedMs = now.getTime() - this.startedAt.getTime();
    const elapsedMinutes = Math.floor(elapsedMs / (1000 * 60));
    stats.elapsedMinutes = elapsedMinutes;
    stats.remainingMinutes = Math.max(0, this.duration - elapsedMinutes);
  }

  // Add total duration if completed
  if (this.status === 'completed' && this.completedAt) {
    const durationMs = this.completedAt.getTime() - this.startedAt.getTime();
    const durationMinutes = Math.floor(durationMs / (1000 * 60));
    stats.actualDurationMinutes = durationMinutes;
  }

  return stats;
};

/**
 * Mark session as completed
 * 
 * Sets status to 'completed' and calculates XP
 */
focusSessionSchema.methods.markCompleted = function () {
  this.status = 'completed';
  this.completedAt = new Date();
  this.xpEarned = this.calculateXP();
  return this;
};

/**
 * Mark session as abandoned
 * 
 * Sets status to 'abandoned' (no XP earned)
 */
focusSessionSchema.methods.markAbandoned = function () {
  this.status = 'abandoned';
  this.xpEarned = 0;
  return this;
};

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get user's active session
 * 
 * Returns the current active session if any
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<FocusSession>} Active session or null
 */
focusSessionSchema.statics.getUserActiveSession = async function (userId) {
  return await this.findOne({
    userId,
    status: 'active',
  });
};

/**
 * Get user's completed sessions with stats
 * 
 * @param {string} userId - User's MongoDB ID
 * @param {number} limit - Max number of sessions (default 10)
 * @returns {Promise<Array>} Array of completed sessions
 */
focusSessionSchema.statics.getUserCompletedSessions = async function (
  userId,
  limit = 10
) {
  return await this.find({
    userId,
    status: 'completed',
  })
    .sort({ completedAt: -1 })
    .limit(limit);
};

/**
 * Get user's daily focus stats
 * 
 * Returns today's session metrics:
 * - totalSessions: Number of sessions today
 * - completedSessions: Completed count
 * - totalMinutes: Total focused minutes
 * - totalXP: Total XP earned today
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<object>} Daily stats
 */
focusSessionSchema.statics.getDailyStats = async function (userId) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);

  const sessions = await this.find({
    userId,
    createdAt: { $gte: today, $lt: tomorrow },
  });

  const completedSessions = sessions.filter((s) => s.status === 'completed');

  return {
    totalSessions: sessions.length,
    completedSessions: completedSessions.length,
    abandonedSessions: sessions.filter((s) => s.status === 'abandoned').length,
    activeSessions: sessions.filter((s) => s.status === 'active').length,
    totalMinutes: sessions.reduce((sum, s) => sum + s.duration, 0),
    totalXP: completedSessions.reduce((sum, s) => sum + s.xpEarned, 0),
  };
};

/**
 * Get user's weekly focus stats
 * 
 * @param {string} userId - User's MongoDB ID
 * @returns {Promise<object>} Weekly stats
 */
focusSessionSchema.statics.getWeeklyStats = async function (userId) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const sevenDaysAgo = new Date(today);
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

  const sessions = await this.find({
    userId,
    createdAt: { $gte: sevenDaysAgo, $lt: new Date() },
  });

  const completedSessions = sessions.filter((s) => s.status === 'completed');

  return {
    totalSessions: sessions.length,
    completedSessions: completedSessions.length,
    totalMinutes: sessions.reduce((sum, s) => sum + s.duration, 0),
    totalXP: completedSessions.reduce((sum, s) => sum + s.xpEarned, 0),
    averageSessionLength:
      sessions.length > 0
        ? Math.round(sessions.reduce((sum, s) => sum + s.duration, 0) / sessions.length)
        : 0,
  };
};

// Export the FocusSession model
module.exports = mongoose.model('FocusSession', focusSessionSchema);
