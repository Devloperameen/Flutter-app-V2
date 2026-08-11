/**
 * ============================================
 * Video Model
 * ============================================
 * 
 * Stores YouTube videos for dashboard content
 * Admin management for motivation and education
 */

const mongoose = require('mongoose');

/**
 * Video Schema Definition
 * 
 * Fields:
 * - title: Video title
 * - description: Video description
 * - youtubeUrl: Full YouTube URL
 * - videoId: Extracted YouTube video ID
 * - category: Video category
 * - createdBy: Admin who added the video
 * - isActive: Whether video is in rotation
 * - views: Number of times shown
 * - createdAt: When added
 */
const videoSchema = new mongoose.Schema(
  {
    // ─── Video Information ───────────────────────
    title: {
      type: String,
      required: [true, 'Video title is required'],
      trim: true,
      minlength: [5, 'Title must be at least 5 characters'],
      maxlength: [200, 'Title must be less than 200 characters'],
    },

    description: {
      type: String,
      default: '',
      maxlength: [1000, 'Description must be less than 1000 characters'],
    },

    // ─── YouTube Information ─────────────────────
    youtubeUrl: {
      type: String,
      required: [true, 'YouTube URL is required'],
      match: [
        /^(https?:\/\/)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)\//,
        'Invalid YouTube URL',
      ],
    },

    videoId: {
      type: String,
      required: [true, 'Video ID is required'],
      minlength: [11, 'Video ID must be 11 characters'],
      maxlength: [11, 'Video ID must be 11 characters'],
    },

    // ─── Classification ──────────────────────────
    category: {
      type: String,
      enum: {
        values: [
          'motivation',
          'fitness-training',
          'productivity',
          'nutrition',
          'mindfulness',
          'recovery',
          'challenge',
          'education',
          'other',
        ],
        message: 'Invalid video category',
      },
      default: 'motivation',
    },

    // ─── Content Management ──────────────────────
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Creator (admin) is required'],
    },

    isActive: {
      type: Boolean,
      default: true,
    },

    // ─── Analytics ───────────────────────────────
    views: {
      type: Number,
      default: 0,
      min: [0, 'Views cannot be negative'],
    },

    likes: {
      type: Number,
      default: 0,
      min: [0, 'Likes cannot be negative'],
    },

    // ─── Metadata ────────────────────────────────
    duration: {
      type: Number,
      default: null, // In seconds - can be populated from YouTube API
    },

    thumbnail: {
      type: String,
      default: null,
    },

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

// Get active videos by category
videoSchema.index({ isActive: 1, category: 1 });

// Get videos created by admin
videoSchema.index({ createdBy: 1 });

// Get videos by category
videoSchema.index({ category: 1 });

// Get most viewed videos
videoSchema.index({ isActive: 1, views: -1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save: Extract and validate video information
 */
videoSchema.pre('save', function (next) {
  // Extract video ID if not provided
  if (!this.videoId && this.youtubeUrl) {
    this.videoId = this.extractVideoId();
  }

  // Generate thumbnail URL
  if (this.videoId && !this.thumbnail) {
    this.thumbnail = `https://img.youtube.com/vi/${this.videoId}/maxresdefault.jpg`;
  }

  next();
});

/**
 * ─────────────────────────────────────────────────
 * METHODS - Custom instance methods
 * ─────────────────────────────────────────────────
 */

/**
 * Extract YouTube video ID from URL
 * 
 * Handles formats:
 * - https://www.youtube.com/watch?v=VIDEO_ID
 * - https://youtu.be/VIDEO_ID
 * - https://www.youtube.com/embed/VIDEO_ID
 * 
 * @returns {string} Video ID or empty string if invalid
 */
videoSchema.methods.extractVideoId = function () {
  if (!this.youtubeUrl) return '';

  let videoId = '';

  // Standard YouTube URL
  if (this.youtubeUrl.includes('youtube.com/watch')) {
    const url = new URL(this.youtubeUrl);
    videoId = url.searchParams.get('v');
  }
  // Shortened URL
  else if (this.youtubeUrl.includes('youtu.be')) {
    const url = new URL(this.youtubeUrl);
    videoId = url.pathname.substring(1);
  }
  // Embed URL
  else if (this.youtubeUrl.includes('embed')) {
    const parts = this.youtubeUrl.split('/');
    videoId = parts[parts.length - 1];
  }

  return videoId || '';
};

/**
 * Increment view count when video is shown
 * 
 * Tracks how often this video appears to users
 * Useful for analytics and popular videos
 * 
 * @returns {Promise<Video>} Updated video
 */
videoSchema.methods.incrementViews = async function () {
  this.views += 1;
  return await this.save();
};

/**
 * Increment like count
 * 
 * @returns {Promise<Video>} Updated video
 */
videoSchema.methods.incrementLikes = async function () {
  this.likes += 1;
  return await this.save();
};

/**
 * Get embedded video URL
 * 
 * @returns {string} URL for iframe embed
 */
videoSchema.methods.getEmbedUrl = function () {
  return `https://www.youtube.com/embed/${this.videoId}`;
};

/**
 * Get video statistics
 * 
 * @returns {object} Stats object
 */
videoSchema.methods.getStats = function () {
  return {
    views: this.views,
    likes: this.likes,
    engagementRate:
      this.views > 0
        ? ((this.likes / this.views) * 100).toFixed(2)
        : 0,
    category: this.category,
    isActive: this.isActive,
  };
};

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get a random active video
 * 
 * Returns a random video from active videos
 * Useful for dashboard display
 * 
 * @param {string} category - Optional category filter
 * @returns {Promise<Video>} Random video
 */
videoSchema.statics.getRandomVideo = async function (category = null) {
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
 * Get all active videos by category
 * 
 * @param {string} category - Video category
 * @param {number} limit - Max videos to return (default 10)
 * @returns {Promise<Array>} Videos in category
 */
videoSchema.statics.getVideosByCategory = async function (category, limit = 10) {
  return await this.find({
    isActive: true,
    category,
  })
    .sort({ views: -1 })
    .limit(limit);
};

/**
 * Get most viewed videos
 * 
 * Returns videos shown most to users
 * Useful for identifying popular content
 * 
 * @param {number} limit - Number of videos (default 10)
 * @returns {Promise<Array>} Most popular videos
 */
videoSchema.statics.getMostViewed = async function (limit = 10) {
  return await this.find({ isActive: true })
    .sort({ views: -1 })
    .limit(limit);
};

/**
 * Get trending videos
 * 
 * Returns videos with highest engagement recently
 * 
 * @param {number} limit - Number of videos (default 10)
 * @returns {Promise<Array>} Trending videos
 */
videoSchema.statics.getTrending = async function (limit = 10) {
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

  return await this.find({
    isActive: true,
    updatedAt: { $gte: sevenDaysAgo },
  })
    .sort({ views: -1, likes: -1 })
    .limit(limit);
};

/**
 * Get recent videos added by admin
 * 
 * @param {string} adminId - Admin user ID
 * @param {number} limit - Number of videos (default 10)
 * @returns {Promise<Array>} Recent videos
 */
videoSchema.statics.getRecentByAdmin = async function (adminId, limit = 10) {
  return await this.find({ createdBy: adminId })
    .sort({ createdAt: -1 })
    .limit(limit)
    .populate('createdBy', 'fullName email');
};

/**
 * Get videos with highest engagement rate
 * 
 * Filters by minimum views to avoid noise
 * 
 * @param {number} limit - Number of videos
 * @param {number} minViews - Minimum views for consideration
 * @returns {Promise<Array>} Most engaging videos
 */
videoSchema.statics.getMostEngaging = async function (limit = 10, minViews = 10) {
  return await this.find({
    isActive: true,
    views: { $gte: minViews },
  })
    .sort({
      $expr: {
        $divide: ['$likes', '$views'],
      },
    })
    .limit(limit);
};

/**
 * Get video statistics
 * 
 * @returns {Promise<object>} Video statistics
 */
videoSchema.statics.getStats = async function () {
  const totalVideos = await this.countDocuments();
  const activeVideos = await this.countDocuments({ isActive: true });
  const inactiveVideos = totalVideos - activeVideos;

  // Get category breakdown
  const byCategory = await this.aggregate([
    { $match: { isActive: true } },
    { $group: { _id: '$category', count: { $sum: 1 } } },
  ]);

  // Get view statistics
  const viewStats = await this.aggregate([
    {
      $group: {
        _id: null,
        totalViews: { $sum: '$views' },
        totalLikes: { $sum: '$likes' },
        avgViews: { $avg: '$views' },
      },
    },
  ]);

  return {
    totalVideos,
    activeVideos,
    inactiveVideos,
    byCategory: Object.fromEntries(byCategory.map((c) => [c._id, c.count])),
    stats: viewStats[0] || {
      totalViews: 0,
      totalLikes: 0,
      avgViews: 0,
    },
  };
};

/**
 * Search videos by title, description, or tags
 * 
 * @param {string} searchTerm - Text to search for
 * @param {number} limit - Results limit
 * @returns {Promise<Array>} Matching videos
 */
videoSchema.statics.search = async function (searchTerm, limit = 10) {
  return await this.find({
    isActive: true,
    $or: [
      { title: { $regex: searchTerm, $options: 'i' } },
      { description: { $regex: searchTerm, $options: 'i' } },
      { tags: { $regex: searchTerm, $options: 'i' } },
    ],
  })
    .limit(limit);
};

// Export the Video model
module.exports = mongoose.model('Video', videoSchema);
