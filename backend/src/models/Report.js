/**
 * ============================================
 * Report Model
 * ============================================
 * 
 * Handles community content reports and moderation
 * Tracks user reports for posts, messages, and users
 */

const mongoose = require('mongoose');

/**
 * Report Schema Definition
 * 
 * Fields:
 * - reporterId: User who filed the report
 * - targetId: ID of reported content/user
 * - targetType: Type of reported item (post/message/user)
 * - reason: Reason for report
 * - status: Report resolution status
 * - description: Detailed report description
 * - moderatorNotes: Mod's review notes
 * - resolvedBy: Admin who resolved report
 * - createdAt: When report was filed
 */
const reportSchema = new mongoose.Schema(
  {
    // ─── Reporter Information ────────────────────
    reporterId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Reporter ID is required'],
    },

    // ─── Reported Content ────────────────────────
    targetId: {
      type: mongoose.Schema.Types.ObjectId,
      required: [true, 'Target ID is required'],
      // Note: This can reference different models based on targetType
      // MongoDB allows flexible references
    },

    targetType: {
      type: String,
      enum: {
        values: ['post', 'message', 'user', 'comment'],
        message: 'Invalid target type',
      },
      required: [true, 'Target type is required'],
    },

    // ─── Report Details ──────────────────────────
    reason: {
      type: String,
      enum: {
        values: [
          'inappropriate-content',
          'harassment',
          'spam',
          'misinformation',
          'self-harm-content',
          'violent-content',
          'sexual-content',
          'hate-speech',
          'copyright-violation',
          'scam-fraud',
          'other',
        ],
        message: 'Invalid report reason',
      },
      required: [true, 'Report reason is required'],
    },

    description: {
      type: String,
      default: '',
      maxlength: [1000, 'Description must be less than 1000 characters'],
    },

    // ─── Status ──────────────────────────────────
    status: {
      type: String,
      enum: {
        values: ['pending', 'under-review', 'resolved', 'dismissed', 'escalated'],
        message: 'Invalid status',
      },
      default: 'pending',
    },

    // ─── Moderation ──────────────────────────────
    moderatorNotes: {
      type: String,
      default: '',
      maxlength: [1000, 'Moderator notes must be less than 1000 characters'],
    },

    resolvedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null,
    },

    resolutionAction: {
      type: String,
      enum: {
        values: [
          'content-removed',
          'user-warned',
          'user-suspended',
          'user-banned',
          'no-action',
          null,
        ],
        message: 'Invalid resolution action',
      },
      default: null,
    },

    // ─── Evidence/Attachments ────────────────────
    evidence: [
      {
        type: String, // URL to screenshot or evidence
        maxlength: [500, 'Evidence URL too long'],
      },
    ],

    // ─── Review Timeline ─────────────────────────
    reviewedAt: {
      type: Date,
      default: null,
    },

    resolvedAt: {
      type: Date,
      default: null,
    },

    // ─── Priority ────────────────────────────────
    priority: {
      type: String,
      enum: {
        values: ['low', 'medium', 'high', 'critical'],
        message: 'Invalid priority',
      },
      default: 'medium',
    },

    // ─── Duplicate Handling ──────────────────────
    isDuplicate: {
      type: Boolean,
      default: false,
    },

    duplicateOf: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Report',
      default: null,
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

// Get reports by status for moderation queue
reportSchema.index({ status: 1, createdAt: -1 });

// Get reports for specific content
reportSchema.index({ targetId: 1, targetType: 1 });

// Get reports by reporter
reportSchema.index({ reporterId: 1 });

// Get pending reports by priority
reportSchema.index({ status: 1, priority: -1, createdAt: -1 });

// Get reports resolved by admin
reportSchema.index({ resolvedBy: 1, resolvedAt: -1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save: Validate and process report
 */
reportSchema.pre('save', function (next) {
  // Auto-set review timestamp if changing status to under-review
  if (this.isModified('status') && this.status === 'under-review') {
    this.reviewedAt = new Date();
  }

  // Auto-set resolved timestamp if changing to resolved or dismissed
  if (
    this.isModified('status') &&
    (this.status === 'resolved' || this.status === 'dismissed')
  ) {
    this.resolvedAt = new Date();
  }

  // Validate: Can't resolve without resolution action
  if (this.status === 'resolved' && !this.resolutionAction) {
    throw new Error('Resolution action required when resolving report');
  }

  next();
});

/**
 * ─────────────────────────────────────────────────
 * METHODS - Custom instance methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get time since report was filed
 * 
 * @returns {string} Human-readable time (e.g., "2 hours ago")
 */
reportSchema.methods.getTimeSince = function () {
  const now = new Date();
  const diff = now.getTime() - this.createdAt.getTime();

  const minutes = Math.floor(diff / (1000 * 60));
  const hours = Math.floor(diff / (1000 * 60 * 60));
  const days = Math.floor(diff / (1000 * 60 * 60 * 24));

  if (minutes < 60) {
    return `${minutes} minute${minutes !== 1 ? 's' : ''} ago`;
  } else if (hours < 24) {
    return `${hours} hour${hours !== 1 ? 's' : ''} ago`;
  } else {
    return `${days} day${days !== 1 ? 's' : ''} ago`;
  }
};

/**
 * Assign report to moderator (change status to under-review)
 * 
 * @param {string} moderatorId - Moderator's user ID
 * @returns {Promise<Report>} Updated report
 */
reportSchema.methods.assignToModerator = async function (moderatorId) {
  this.status = 'under-review';
  this.resolvedBy = moderatorId;
  this.reviewedAt = new Date();
  return await this.save();
};

/**
 * Resolve report with action
 * 
 * @param {string} action - Resolution action taken
 * @param {string} moderatorId - Moderator's user ID
 * @param {string} notes - Optional moderator notes
 * @returns {Promise<Report>} Updated report
 */
reportSchema.methods.resolve = async function (action, moderatorId, notes = '') {
  if (
    ![
      'content-removed',
      'user-warned',
      'user-suspended',
      'user-banned',
      'no-action',
    ].includes(action)
  ) {
    throw new Error('Invalid resolution action');
  }

  this.status = 'resolved';
  this.resolutionAction = action;
  this.resolvedBy = moderatorId;
  this.resolvedAt = new Date();
  if (notes) {
    this.moderatorNotes = notes;
  }

  return await this.save();
};

/**
 * Dismiss report (no action needed)
 * 
 * @param {string} moderatorId - Moderator's user ID
 * @param {string} notes - Optional moderator notes
 * @returns {Promise<Report>} Updated report
 */
reportSchema.methods.dismiss = async function (moderatorId, notes = '') {
  this.status = 'dismissed';
  this.resolvedBy = moderatorId;
  this.resolvedAt = new Date();
  this.resolutionAction = 'no-action';
  if (notes) {
    this.moderatorNotes = notes;
  }

  return await this.save();
};

/**
 * Escalate report to higher priority
 * 
 * @param {string} reason - Reason for escalation
 * @returns {Promise<Report>} Updated report
 */
reportSchema.methods.escalate = async function (reason) {
  const priorityLevels = ['low', 'medium', 'high', 'critical'];
  const currentIndex = priorityLevels.indexOf(this.priority);

  // Move to next priority level, max is critical
  if (currentIndex < priorityLevels.length - 1) {
    this.priority = priorityLevels[currentIndex + 1];
  } else {
    this.priority = 'critical';
  }

  this.status = 'escalated';
  this.moderatorNotes = `ESCALATED: ${reason}\n${this.moderatorNotes}`;

  return await this.save();
};

/**
 * Mark as duplicate of another report
 * 
 * @param {string} duplicateReportId - ID of original report
 * @returns {Promise<Report>} Updated report
 */
reportSchema.methods.markAsDuplicate = async function (duplicateReportId) {
  this.isDuplicate = true;
  this.duplicateOf = duplicateReportId;
  return await this.save();
};

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get moderation queue (pending reports)
 * 
 * Returns all pending reports sorted by priority and date
 * 
 * @param {number} limit - Number of reports (default 20)
 * @returns {Promise<Array>} Pending reports
 */
reportSchema.statics.getModerationQueue = async function (limit = 20) {
  return await this.find({
    status: { $in: ['pending', 'under-review'] },
  })
    .sort({ priority: -1, createdAt: 1 })
    .limit(limit)
    .populate('reporterId', 'fullName email')
    .populate('resolvedBy', 'fullName email');
};

/**
 * Get reports for a specific content item
 * 
 * @param {string} targetId - Content ID
 * @param {string} targetType - Type of content
 * @returns {Promise<Array>} Reports about that content
 */
reportSchema.statics.getReportsForTarget = async function (targetId, targetType) {
  return await this.find({
    targetId,
    targetType,
  })
    .sort({ createdAt: -1 })
    .populate('reporterId', 'fullName email');
};

/**
 * Get reports about a specific user
 * 
 * @param {string} userId - User ID to check
 * @returns {Promise<Array>} Reports about user
 */
reportSchema.statics.getReportsAboutUser = async function (userId) {
  return await this.find({
    targetId: userId,
    targetType: 'user',
  })
    .sort({ createdAt: -1 })
    .populate('reporterId', 'fullName email');
};

/**
 * Get report statistics for dashboard
 * 
 * @returns {Promise<object>} Report statistics
 */
reportSchema.statics.getStats = async function () {
  const total = await this.countDocuments();
  const pending = await this.countDocuments({ status: 'pending' });
  const underReview = await this.countDocuments({ status: 'under-review' });
  const resolved = await this.countDocuments({ status: 'resolved' });
  const dismissed = await this.countDocuments({ status: 'dismissed' });
  const escalated = await this.countDocuments({ status: 'escalated' });

  // Get reason breakdown
  const byReason = await this.aggregate([
    { $group: { _id: '$reason', count: { $sum: 1 } } },
  ]);

  // Get average resolution time
  const avgResolutionTime = await this.aggregate([
    {
      $match: { resolvedAt: { $exists: true } },
    },
    {
      $group: {
        _id: null,
        avgTime: {
          $avg: {
            $subtract: ['$resolvedAt', '$createdAt'],
          },
        },
      },
    },
  ]);

  return {
    total,
    byStatus: {
      pending,
      underReview,
      resolved,
      dismissed,
      escalated,
    },
    byReason: Object.fromEntries(byReason.map((r) => [r._id, r.count])),
    avgResolutionTimeMs: avgResolutionTime[0]?.avgTime || 0,
  };
};

/**
 * Find duplicate reports for same content
 * 
 * @param {string} targetId - Content ID
 * @param {string} targetType - Content type
 * @returns {Promise<Array>} Duplicate reports
 */
reportSchema.statics.findDuplicates = async function (targetId, targetType) {
  return await this.find({
    targetId,
    targetType,
    isDuplicate: false,
  }).sort({ createdAt: 1 });
};

/**
 * Get reports by reason
 * 
 * @param {string} reason - Report reason
 * @param {string} status - Optional status filter
 * @param {number} limit - Results limit
 * @returns {Promise<Array>} Reports with reason
 */
reportSchema.statics.getReportsByReason = async function (
  reason,
  status = null,
  limit = 20
) {
  const query = { reason };

  if (status) {
    query.status = status;
  }

  return await this.find(query)
    .sort({ createdAt: -1 })
    .limit(limit)
    .populate('reporterId', 'fullName email')
    .populate('resolvedBy', 'fullName email');
};

/**
 * Get unreviewed reports
 * 
 * @param {number} limit - Results limit
 * @returns {Promise<Array>} Unreviewed reports
 */
reportSchema.statics.getUnreviewed = async function (limit = 50) {
  return await this.find({
    status: 'pending',
  })
    .sort({ priority: -1, createdAt: 1 })
    .limit(limit)
    .populate('reporterId', 'fullName email');
};

// Export the Report model
module.exports = mongoose.model('Report', reportSchema);
