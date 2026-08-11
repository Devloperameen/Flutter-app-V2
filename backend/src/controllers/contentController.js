/**
 * ============================================
 * Content Controller
 * ============================================
 * 
 * Manages motivational content and moderation
 * - Quote management (create, read, update, delete)
 * - Video management (create, read, update, delete)
 * - Report system (file reports, moderation queue)
 * - Content approval workflow
 */

const logger = require('../utils/logger');
const { success, error, validationError, sendResponse, paginated } = require('../utils/response');
const Quote = require('../models/Quote');
const Video = require('../models/Video');
const Report = require('../models/Report');
const User = require('../models/User');

// ─────────────────────────────────────────────
// QUOTE ENDPOINTS
// ─────────────────────────────────────────────

/**
 * Get random motivational quote
 * 
 * GET /api/v1/content/quote?category=motivation|fitness|productivity
 */
const getRandomQuote = async (req, res, next) => {
  try {
    const { category } = req.query;

    // ─── Build query ───────────────────────────
    const query = { isActive: true };
    if (category) {
      query.category = category;
    }

    // ─── Get random quote ──────────────────────
    const count = await Quote.countDocuments(query);
    if (count === 0) {
      return sendResponse(res, error('No quotes available', 404));
    }

    const randomIndex = Math.floor(Math.random() * count);
    const quote = await Quote.findOne(query).skip(randomIndex).lean();

    // ─── Increment display count ───────────────
    if (quote) {
      await Quote.updateOne(
        { _id: quote._id },
        { $inc: { displayCount: 1 } }
      );
    }

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: quote._id,
        text: quote.text,
        author: quote.author,
        category: quote.category,
      },
      'Random quote retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching random quote:', err);
    return sendResponse(res, error('Failed to retrieve quote', 500));
  }
};

/**
 * Get today's featured quote
 * Same for all users
 * 
 * GET /api/v1/content/quote/today
 */
const getTodayQuote = async (req, res, next) => {
  try {
    // ─── Use date-based index to get same quote ─
    const today = new Date();
    const dayOfYear = Math.floor(
      (today - new Date(today.getFullYear(), 0, 0)) / 1000 / 60 / 60 / 24
    );

    // ─── Get active quotes ─────────────────────
    const quotes = await Quote.find({ isActive: true }).lean();

    if (quotes.length === 0) {
      return sendResponse(res, error('No quotes available', 404));
    }

    // ─── Select quote based on day of year ─────
    const quoteIndex = dayOfYear % quotes.length;
    const quote = quotes[quoteIndex];

    // ─── Increment display count ───────────────
    await Quote.updateOne(
      { _id: quote._id },
      { $inc: { displayCount: 1 } }
    );

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: quote._id,
        text: quote.text,
        author: quote.author,
        category: quote.category,
      },
      'Today\'s quote retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching today\'s quote:', err);
    return sendResponse(res, error('Failed to retrieve today\'s quote', 500));
  }
};

/**
 * Get quotes by category (paginated)
 * 
 * GET /api/v1/content/quotes?category=fitness&page=1&limit=10
 */
const getQuotesByCategory = async (req, res, next) => {
  try {
    const { category } = req.query;
    const page = parseInt(req.query.page) || 1;
    const limit = Math.min(parseInt(req.query.limit) || 10, 100);
    const skip = (page - 1) * limit;

    // ─── Build query ───────────────────────────
    const query = { isActive: true };
    if (category) {
      query.category = category;
    }

    // ─── Fetch quotes ──────────────────────────
    const quotes = await Quote.find(query)
      .sort({ displayCount: -1 })
      .skip(skip)
      .limit(limit)
      .lean();

    const total = await Quote.countDocuments(query);

    // ─── Return response ────────────────────────
    const responseData = paginated(
      quotes,
      page,
      limit,
      total,
      `Quotes for category '${category || 'all'}' retrieved`
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching quotes by category:', err);
    return sendResponse(res, error('Failed to retrieve quotes', 500));
  }
};

/**
 * Create quote (ADMIN only)
 * 
 * POST /api/v1/content/quote
 * Body: { text, author, category, tags }
 */
const createQuote = async (req, res, next) => {
  try {
    const { text, author, category, tags } = req.body;

    // ─── Check if user is admin ────────────────
    const user = await User.findById(req.user.id);
    if (!user || user.role !== 'admin') {
      return sendResponse(res, error('Only admins can create quotes', 403));
    }

    // ─── Validate input ────────────────────────
    if (!text || !author || !category) {
      return sendResponse(res, validationError(
        ['text, author, and category are required'],
        'Quote validation failed'
      ));
    }

    // ─── Create quote ──────────────────────────
    const newQuote = new Quote({
      text,
      author,
      category,
      tags: tags || [],
      isActive: true,
    });

    await newQuote.save();
    logger.info(`✅ Quote created by ${req.user.id}: ${newQuote._id}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: newQuote._id,
        text: newQuote.text,
        author: newQuote.author,
        category: newQuote.category,
      },
      'Quote created successfully',
      201
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error creating quote:', err);
    return sendResponse(res, error('Failed to create quote', 500));
  }
};

/**
 * Update quote (ADMIN + creator only)
 * 
 * PUT /api/v1/content/quote/:quoteId
 * Body: { text, author, category }
 */
const updateQuote = async (req, res, next) => {
  try {
    const { quoteId } = req.params;
    const { text, author, category } = req.body;

    // ─── Get quote and check ownership ─────────
    const quote = await Quote.findById(quoteId);
    if (!quote) {
      return sendResponse(res, error('Quote not found', 404));
    }

    const user = await User.findById(req.user.id);
    if (
      !user ||
      (user.role !== 'admin' && quote.createdBy.toString() !== req.user.id)
    ) {
      return sendResponse(res, error('Unauthorized', 403));
    }

    // ─── Update quote ──────────────────────────
    if (text) quote.text = text;
    if (author) quote.author = author;
    if (category) quote.category = category;

    await quote.save();
    logger.info(`✅ Quote updated: ${quoteId}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      quote,
      'Quote updated successfully',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error updating quote:', err);
    return sendResponse(res, error('Failed to update quote', 500));
  }
};

/**
 * Delete quote (ADMIN + creator only)
 * 
 * DELETE /api/v1/content/quote/:quoteId
 */
const deleteQuote = async (req, res, next) => {
  try {
    const { quoteId } = req.params;

    // ─── Get quote and check ownership ─────────
    const quote = await Quote.findById(quoteId);
    if (!quote) {
      return sendResponse(res, error('Quote not found', 404));
    }

    const user = await User.findById(req.user.id);
    if (
      !user ||
      (user.role !== 'admin' && quote.createdBy.toString() !== req.user.id)
    ) {
      return sendResponse(res, error('Unauthorized', 403));
    }

    // ─── Delete quote ──────────────────────────
    await Quote.deleteOne({ _id: quoteId });
    logger.info(`✅ Quote deleted: ${quoteId}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      { deletedId: quoteId },
      'Quote deleted successfully',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error deleting quote:', err);
    return sendResponse(res, error('Failed to delete quote', 500));
  }
};

/**
 * Toggle quote active status (ADMIN only)
 * 
 * PATCH /api/v1/content/quote/:quoteId/toggle
 * Body: { isActive }
 */
const toggleQuoteActive = async (req, res, next) => {
  try {
    const { quoteId } = req.params;
    const { isActive } = req.body;

    // ─── Check if user is admin ────────────────
    const user = await User.findById(req.user.id);
    if (!user || user.role !== 'admin') {
      return sendResponse(res, error('Only admins can toggle quotes', 403));
    }

    // ─── Update quote ──────────────────────────
    const quote = await Quote.findByIdAndUpdate(
      quoteId,
      { isActive: isActive || false },
      { new: true }
    );

    if (!quote) {
      return sendResponse(res, error('Quote not found', 404));
    }

    logger.info(
      `✅ Quote toggled: ${quoteId}, isActive: ${quote.isActive}`
    );

    // ─── Return response ────────────────────────
    const responseData = success(
      { _id: quote._id, isActive: quote.isActive },
      `Quote ${quote.isActive ? 'activated' : 'deactivated'} successfully`,
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error toggling quote:', err);
    return sendResponse(res, error('Failed to toggle quote', 500));
  }
};

// ─────────────────────────────────────────────
// VIDEO ENDPOINTS
// ─────────────────────────────────────────────

/**
 * Get random YouTube video
 * 
 * GET /api/v1/content/video?category=motivation|fitness-training
 */
const getRandomVideo = async (req, res, next) => {
  try {
    const { category } = req.query;

    // ─── Build query ───────────────────────────
    const query = { isActive: true };
    if (category) {
      query.category = category;
    }

    // ─── Get random video ──────────────────────
    const count = await Video.countDocuments(query);
    if (count === 0) {
      return sendResponse(res, error('No videos available', 404));
    }

    const randomIndex = Math.floor(Math.random() * count);
    const video = await Video.findOne(query).skip(randomIndex).lean();

    // ─── Increment view count ──────────────────
    if (video) {
      await Video.updateOne(
        { _id: video._id },
        { $inc: { views: 1 } }
      );
    }

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: video._id,
        title: video.title,
        description: video.description,
        videoId: video.videoId,
        embedUrl: video.embedUrl,
        category: video.category,
      },
      'Random video retrieved',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching random video:', err);
    return sendResponse(res, error('Failed to retrieve video', 500));
  }
};

/**
 * Get videos by category (paginated)
 * 
 * GET /api/v1/content/videos?category=motivation&page=1&limit=5
 */
const getVideosByCategory = async (req, res, next) => {
  try {
    const { category } = req.query;
    const page = parseInt(req.query.page) || 1;
    const limit = Math.min(parseInt(req.query.limit) || 5, 50);
    const skip = (page - 1) * limit;

    // ─── Build query ───────────────────────────
    const query = { isActive: true };
    if (category) {
      query.category = category;
    }

    // ─── Fetch videos ──────────────────────────
    const videos = await Video.find(query)
      .sort({ views: -1 })
      .skip(skip)
      .limit(limit)
      .lean();

    const total = await Video.countDocuments(query);

    // ─── Return response ────────────────────────
    const responseData = paginated(
      videos,
      page,
      limit,
      total,
      `Videos for category '${category || 'all'}' retrieved`
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching videos by category:', err);
    return sendResponse(res, error('Failed to retrieve videos', 500));
  }
};

/**
 * Create video (ADMIN only)
 * 
 * POST /api/v1/content/video
 * Body: { title, description, youtubeUrl, category, tags }
 */
const createVideo = async (req, res, next) => {
  try {
    const { title, description, youtubeUrl, category, tags } = req.body;

    // ─── Check if user is admin ────────────────
    const user = await User.findById(req.user.id);
    if (!user || user.role !== 'admin') {
      return sendResponse(res, error('Only admins can create videos', 403));
    }

    // ─── Validate input ────────────────────────
    if (!title || !youtubeUrl || !category) {
      return sendResponse(res, validationError(
        ['title', 'youtubeUrl', 'category are required'],
        'Video validation failed'
      ));
    }

    // ─── Extract video ID from URL ─────────────
    const videoIdMatch = youtubeUrl.match(
      /(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})/
    );
    if (!videoIdMatch) {
      return sendResponse(res, validationError(
        ['Invalid YouTube URL format'],
        'Video URL validation failed'
      ));
    }

    const videoId = videoIdMatch[1];
    const embedUrl = `https://www.youtube.com/embed/${videoId}`;

    // ─── Create video ──────────────────────────
    const newVideo = new Video({
      title,
      description,
      videoId,
      embedUrl,
      category,
      tags: tags || [],
      isActive: true,
    });

    await newVideo.save();
    logger.info(`✅ Video created by ${req.user.id}: ${newVideo._id}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: newVideo._id,
        title: newVideo.title,
        videoId: newVideo.videoId,
        embedUrl: newVideo.embedUrl,
        category: newVideo.category,
      },
      'Video created successfully',
      201
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error creating video:', err);
    return sendResponse(res, error('Failed to create video', 500));
  }
};

/**
 * Update video (ADMIN + creator only)
 * 
 * PUT /api/v1/content/video/:videoId
 * Body: { title, description, category }
 */
const updateVideo = async (req, res, next) => {
  try {
    const { videoId } = req.params;
    const { title, description, category } = req.body;

    // ─── Get video and check ownership ─────────
    const video = await Video.findById(videoId);
    if (!video) {
      return sendResponse(res, error('Video not found', 404));
    }

    const user = await User.findById(req.user.id);
    if (
      !user ||
      (user.role !== 'admin' && video.createdBy.toString() !== req.user.id)
    ) {
      return sendResponse(res, error('Unauthorized', 403));
    }

    // ─── Update video ──────────────────────────
    if (title) video.title = title;
    if (description) video.description = description;
    if (category) video.category = category;

    await video.save();
    logger.info(`✅ Video updated: ${videoId}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      video,
      'Video updated successfully',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error updating video:', err);
    return sendResponse(res, error('Failed to update video', 500));
  }
};

/**
 * Delete video (ADMIN + creator only)
 * 
 * DELETE /api/v1/content/video/:videoId
 */
const deleteVideo = async (req, res, next) => {
  try {
    const { videoId } = req.params;

    // ─── Get video and check ownership ─────────
    const video = await Video.findById(videoId);
    if (!video) {
      return sendResponse(res, error('Video not found', 404));
    }

    const user = await User.findById(req.user.id);
    if (
      !user ||
      (user.role !== 'admin' && video.createdBy.toString() !== req.user.id)
    ) {
      return sendResponse(res, error('Unauthorized', 403));
    }

    // ─── Delete video ──────────────────────────
    await Video.deleteOne({ _id: videoId });
    logger.info(`✅ Video deleted: ${videoId}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      { deletedId: videoId },
      'Video deleted successfully',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error deleting video:', err);
    return sendResponse(res, error('Failed to delete video', 500));
  }
};

/**
 * Toggle video active status (ADMIN only)
 * 
 * PATCH /api/v1/content/video/:videoId/toggle
 * Body: { isActive }
 */
const toggleVideoActive = async (req, res, next) => {
  try {
    const { videoId } = req.params;
    const { isActive } = req.body;

    // ─── Check if user is admin ────────────────
    const user = await User.findById(req.user.id);
    if (!user || user.role !== 'admin') {
      return sendResponse(res, error('Only admins can toggle videos', 403));
    }

    // ─── Update video ──────────────────────────
    const video = await Video.findByIdAndUpdate(
      videoId,
      { isActive: isActive || false },
      { new: true }
    );

    if (!video) {
      return sendResponse(res, error('Video not found', 404));
    }

    logger.info(
      `✅ Video toggled: ${videoId}, isActive: ${video.isActive}`
    );

    // ─── Return response ────────────────────────
    const responseData = success(
      { _id: video._id, isActive: video.isActive },
      `Video ${video.isActive ? 'activated' : 'deactivated'} successfully`,
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error toggling video:', err);
    return sendResponse(res, error('Failed to toggle video', 500));
  }
};

// ─────────────────────────────────────────────
// REPORT/MODERATION ENDPOINTS
// ─────────────────────────────────────────────

/**
 * Report inappropriate content
 * 
 * POST /api/v1/content/report
 * Body: { targetId, targetType, reason, description }
 */
const reportContent = async (req, res, next) => {
  try {
    const { targetId, targetType, reason, description } = req.body;
    const userId = req.user.id;

    // ─── Validate input ────────────────────────
    const validTypes = ['post', 'message', 'user', 'comment'];
    const validReasons = ['harassment', 'spam', 'inappropriate-content'];

    if (!validTypes.includes(targetType) || !validReasons.includes(reason)) {
      return sendResponse(res, validationError(
        ['Invalid targetType or reason'],
        'Report validation failed'
      ));
    }

    // ─── Create report ─────────────────────────
    const newReport = new Report({
      reportedBy: userId,
      targetId,
      targetType,
      reason,
      description,
      status: 'pending',
    });

    await newReport.save();
    logger.info(`📋 Report filed: ${newReport._id}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      {
        _id: newReport._id,
        status: newReport.status,
        createdAt: newReport.createdAt,
      },
      'Report submitted successfully',
      201
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error creating report:', err);
    return sendResponse(res, error('Failed to create report', 500));
  }
};

/**
 * Get moderation queue (ADMIN only)
 * 
 * GET /api/v1/content/reports/queue?status=pending&limit=20
 */
const getModerationQueue = async (req, res, next) => {
  try {
    // ─── Check if user is admin ────────────────
    const user = await User.findById(req.user.id);
    if (!user || user.role !== 'admin') {
      return sendResponse(res, error('Only admins can access reports', 403));
    }

    const status = req.query.status || 'pending';
    const limit = Math.min(parseInt(req.query.limit) || 20, 100);

    // ─── Fetch reports ─────────────────────────
    const reports = await Report.find({ status })
      .sort({ createdAt: 1 })
      .limit(limit)
      .populate('reportedBy', 'fullName email')
      .lean();

    // ─── Return response ────────────────────────
    const responseData = success(
      reports,
      `Reports with status '${status}' retrieved`,
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error fetching moderation queue:', err);
    return sendResponse(res, error('Failed to retrieve reports', 500));
  }
};

/**
 * Resolve report (ADMIN only)
 * 
 * POST /api/v1/content/report/:reportId/resolve
 * Body: { action, notes }
 */
const resolveReport = async (req, res, next) => {
  try {
    const { reportId } = req.params;
    const { action, notes } = req.body;

    // ─── Check if user is admin ────────────────
    const user = await User.findById(req.user.id);
    if (!user || user.role !== 'admin') {
      return sendResponse(res, error('Only admins can resolve reports', 403));
    }

    // ─── Validate action ───────────────────────
    const validActions = ['content-removed', 'user-warned', 'dismissed'];
    if (!validActions.includes(action)) {
      return sendResponse(res, error('Invalid action', 400));
    }

    // ─── Update report ─────────────────────────
    const report = await Report.findByIdAndUpdate(
      reportId,
      {
        status: 'resolved',
        action,
        notes: notes || '',
        resolvedAt: new Date(),
        resolvedBy: req.user.id,
      },
      { new: true }
    );

    if (!report) {
      return sendResponse(res, error('Report not found', 404));
    }

    logger.info(`✅ Report resolved: ${reportId}, action: ${action}`);

    // ─── Return response ────────────────────────
    const responseData = success(
      report,
      'Report resolved successfully',
      200
    );
    return sendResponse(res, responseData);
  } catch (err) {
    logger.error('Error resolving report:', err);
    return sendResponse(res, error('Failed to resolve report', 500));
  }
};

module.exports = {
  // Quotes
  getRandomQuote,
  getTodayQuote,
  getQuotesByCategory,
  createQuote,
  updateQuote,
  deleteQuote,
  toggleQuoteActive,
  // Videos
  getRandomVideo,
  getVideosByCategory,
  createVideo,
  updateVideo,
  deleteVideo,
  toggleVideoActive,
  // Reports
  reportContent,
  getModerationQueue,
  resolveReport,
};
