/**
 * ============================================
 * Quote Model
 * ============================================
 * 
 * Stores motivational quotes for dashboard
 * Admin content management for daily inspiration
 */

const mongoose = require('mongoose');

/**
 * Quote Schema Definition
 * 
 * Fields:
 * - text: The motivational quote text
 * - author: Person who said/wrote the quote
 * - isActive: Whether quote is in rotation
 * - createdBy: Admin user who added the quote
 * - category: Quote category (motivation, fitness, productivity, etc.)
 * - createdAt: When quote was added
 */
const quoteSchema = new mongoose.Schema(
  {
    // ─── Quote Content ───────────────────────────
    text: {
      type: String,
      required: [true, 'Quote text is required'],
      trim: true,
      minlength: [10, 'Quote must be at least 10 characters'],
      maxlength: [500, 'Quote must be less than 500 characters'],
    },

    // ─── Attribution ─────────────────────────────
    author: {
      type: String,
      required: [true, 'Quote author is required'],
      trim: true,
      maxlength: [100, 'Author name must be less than 100 characters'],
    },

    // ─── Status ──────────────────────────────────
    isActive: {
      type: Boolean,
      default: true,
    },

    // ─── Content Management ──────────────────────
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Creator (admin) is required'],
    },

    // ─── Classification ──────────────────────────
    category: {
      type: String,
      enum: {
        values: [
          'motivation',
          'fitness',
          'productivity',
          'mindfulness',
          'discipline',
          'success',
          'health',
          'other',
        ],
        message: 'Invalid quote category',
      },
      default: 'motivation',
    },

    // ─── Analytics ───────────────────────────────
    displayCount: {
      type: Number,
      default: 0,
      min: [0, 'Display count cannot be negative'],
    },

    // ─── Tags ────────────────────────────────────
    tags: [
      {
        type: String,
        maxlength: [20, 'Tag must be less than 20 characters'],
      },
    ],
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

// Get active quotes by category
quoteSchema.index({ isActive: 1, category: 1 });

// Get quotes created by admin
quoteSchema.index({ createdBy: 1 });

// Get quotes by category for filtering
quoteSchema.index({ category: 1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save: Validate and format data
 */
quoteSchema.pre('save', function (next) {
  // Trim extra whitespace from text
  this.text = this.text.trim();

  // Ensure author is properly formatted
  this.author = this.author.trim();

  next();
});

/**
 * ─────────────────────────────────────────────────
 * METHODS - Custom instance methods
 * ─────────────────────────────────────────────────
 */

/**
 * Increment display count when quote is shown
 * 
 * Tracks how often this quote appears to users
 * Useful for analytics and popular quotes
 * 
 * @returns {Promise<Quote>} Updated quote
 */
quoteSchema.methods.recordDisplay = async function () {
  this.displayCount += 1;
  return await this.save();
};

/**
 * Get quote with full info
 * 
 * @returns {object} Quote data with creator info
 */
quoteSchema.methods.toPublicJSON = function () {
  return {
    _id: this._id,
    text: this.text,
    author: this.author,
    category: this.category,
    displayCount: this.displayCount,
    createdAt: this.createdAt,
  };
};

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get a random active quote
 * 
 * Returns a random motivational quote from active quotes
 * Useful for dashboard display
 * 
 * @param {string} category - Optional category filter
 * @returns {Promise<Quote>} Random quote
 */
quoteSchema.statics.getRandomQuote = async function (category = null) {
  const query = { isActive: true };

  if (category) {
    query.category = category;
  }

  const count = await this.countDocuments(query);

  if (count === 0) {
    return null;
  }

  const random = Math.floor(Math.random() * count);
  return await this.findOne(query).skip(random);
};

/**
 * Get all active quotes by category
 * 
 * @param {string} category - Quote category
 * @param {number} limit - Max quotes to return (default 10)
 * @returns {Promise<Array>} Quotes in category
 */
quoteSchema.statics.getQuotesByCategory = async function (category, limit = 10) {
  return await this.find({
    isActive: true,
    category,
  })
    .limit(limit)
    .sort({ createdAt: -1 });
};

/**
 * Get most displayed quotes
 * 
 * Returns quotes shown most to users
 * Useful for identifying popular quotes
 * 
 * @param {number} limit - Number of quotes (default 10)
 * @returns {Promise<Array>} Most popular quotes
 */
quoteSchema.statics.getMostDisplayed = async function (limit = 10) {
  return await this.find({ isActive: true })
    .sort({ displayCount: -1 })
    .limit(limit);
};

/**
 * Get recent quotes added by admin
 * 
 * @param {string} adminId - Admin user ID
 * @param {number} limit - Number of quotes (default 10)
 * @returns {Promise<Array>} Recent quotes
 */
quoteSchema.statics.getRecentByAdmin = async function (adminId, limit = 10) {
  return await this.find({ createdBy: adminId })
    .sort({ createdAt: -1 })
    .limit(limit)
    .populate('createdBy', 'fullName email');
};

/**
 * Get today's quote
 * 
 * Returns same quote for all users on same day
 * Creates consistency in user experience
 * 
 * @returns {Promise<Quote>} Today's featured quote
 */
quoteSchema.statics.getTodayQuote = async function () {
  // Use day number to seed random selection
  // Same seed = same quote for everyone today
  const today = new Date();
  const dayOfYear = Math.floor(
    (today - new Date(today.getFullYear(), 0, 0)) / (24 * 60 * 60 * 1000)
  );

  const count = await this.countDocuments({ isActive: true });

  if (count === 0) {
    return null;
  }

  // Use day number modulo to get consistent index
  const index = dayOfYear % count;

  return await this.findOne({ isActive: true }).skip(index);
};

/**
 * Get quote statistics
 * 
 * @returns {Promise<object>} Quote statistics
 */
quoteSchema.statics.getStats = async function () {
  const totalQuotes = await this.countDocuments();
  const activeQuotes = await this.countDocuments({ isActive: true });
  const inactiveQuotes = totalQuotes - activeQuotes;

  // Get category breakdown
  const byCategory = await this.aggregate([
    { $match: { isActive: true } },
    { $group: { _id: '$category', count: { $sum: 1 } } },
  ]);

  // Get total displays
  const displayStats = await this.aggregate([
    { $group: { _id: null, totalDisplays: { $sum: '$displayCount' } } },
  ]);

  return {
    totalQuotes,
    activeQuotes,
    inactiveQuotes,
    byCategory: Object.fromEntries(byCategory.map((c) => [c._id, c.count])),
    totalDisplays: displayStats[0]?.totalDisplays || 0,
  };
};

/**
 * Search quotes by text or author
 * 
 * @param {string} searchTerm - Text to search for
 * @param {number} limit - Results limit
 * @returns {Promise<Array>} Matching quotes
 */
quoteSchema.statics.search = async function (searchTerm, limit = 10) {
  return await this.find({
    isActive: true,
    $or: [
      { text: { $regex: searchTerm, $options: 'i' } },
      { author: { $regex: searchTerm, $options: 'i' } },
    ],
  })
    .limit(limit);
};

// Export the Quote model
module.exports = mongoose.model('Quote', quoteSchema);
