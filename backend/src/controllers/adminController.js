/**
 * ============================================
 * Admin Controller
 * ============================================
 * 
 * Handles admin dashboard endpoints
 * All methods assume user is authenticated and authorized
 */

const User = require('../models/User');
const Habit = require('../models/Habit');
const Post = require('../models/Post');
const logger = require('../utils/logger');

/**
 * GET /admin/stats
 * Get system statistics for admin dashboard
 */
const getStats = async (req, res) => {
  try {
    logger.info('📊 Fetching admin stats');

    // Get count of users
    const totalUsers = await User.countDocuments();
    const activeUsers = await User.countDocuments({ isActive: true });
    const todayNewUsers = await User.countDocuments({
      createdAt: {
        $gte: new Date(new Date().setHours(0, 0, 0, 0)),
        $lt: new Date(new Date().setHours(23, 59, 59, 999)),
      },
    });

    // Get count of posts and comments
    const totalPosts = await Post.countDocuments({ archived: false });
    const todayPosts = await Post.countDocuments({
      archived: false,
      createdAt: {
        $gte: new Date(new Date().setHours(0, 0, 0, 0)),
        $lt: new Date(new Date().setHours(23, 59, 59, 999)),
      },
    });

    // Get comments count (from posts' comments array)
    const postsWithComments = await Post.aggregate([
      {
        $group: {
          _id: null,
          totalComments: {
            $sum: { $size: { $ifNull: ['$comments', []] } },
          },
        },
      },
    ]);

    const totalComments = postsWithComments[0]?.totalComments || 0;

    // Get today's comments
    const todayStart = new Date(new Date().setHours(0, 0, 0, 0));
    const todayEnd = new Date(new Date().setHours(23, 59, 59, 999));

    const todayCommentsAgg = await Post.aggregate([
      {
        $unwind: {
          path: '$comments',
          preserveNullAndEmptyArrays: true,
        },
      },
      {
        $match: {
          'comments.createdAt': {
            $gte: todayStart,
            $lte: todayEnd,
          },
        },
      },
      {
        $count: 'totalComments',
      },
    ]);

    const todayComments = todayCommentsAgg[0]?.totalComments || 0;

    // Get today's focus sessions (from analytics or activity)
    const todaySessions = 0; // TODO: Query from focus sessions collection

    const stats = {
      totalUsers,
      activeUsers,
      totalPosts,
      totalComments,
      todayNewUsers,
      todayPosts,
      todayComments,
      todaySessions,
    };

    logger.info('✅ Admin stats retrieved:', stats);

    res.status(200).json({
      success: true,
      data: stats,
    });
  } catch (error) {
    logger.error('❌ Error fetching admin stats:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch admin stats',
      error: error.message,
    });
  }
};

/**
 * GET /admin/users
 * Get all users with pagination
 */
const getUsers = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const skip = (page - 1) * limit;
    const role = req.query.role; // Filter by role if provided
    const isActive = req.query.isActive; // Filter by status if provided

    logger.info(`📋 Fetching users - page: ${page}, limit: ${limit}`);

    // Build filter
    const filter = {};
    if (role) filter.role = role;
    if (isActive !== undefined) filter.isActive = isActive === 'true';

    // Get users count
    const total = await User.countDocuments(filter);

    // Get users with pagination
    const users = await User.find(filter)
      .select('-password')
      .skip(skip)
      .limit(limit)
      .sort({ createdAt: -1 })
      .lean();

    logger.info(`✅ Retrieved ${users.length} users`);

    res.status(200).json({
      success: true,
      data: users,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    logger.error('❌ Error fetching users:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch users',
      error: error.message,
    });
  }
};

/**
 * GET /admin/users/:userId
 * Get user details
 */
const getUserDetails = async (req, res) => {
  try {
    const { userId } = req.params;

    logger.info(`🔍 Fetching user details: ${userId}`);

    const user = await User.findById(userId).select('-password');

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (error) {
    logger.error('❌ Error fetching user details:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch user details',
      error: error.message,
    });
  }
};

/**
 * PATCH /admin/users/:userId/role
 * Update user role
 */
const updateUserRole = async (req, res) => {
  try {
    const { userId } = req.params;
    const { role } = req.body;

    // Validate role
    if (!['user', 'admin', 'super_admin'].includes(role)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid role. Must be "user", "admin", or "super_admin"',
      });
    }

    logger.info(`✏️ Updating user role: ${userId} -> ${role}`);

    const user = await User.findByIdAndUpdate(
      userId,
      { role },
      { new: true, runValidators: true }
    ).select('-password');

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    logger.info(`✅ User role updated: ${user.email} -> ${role}`);

    res.status(200).json({
      success: true,
      message: `User role updated to ${role}`,
      data: user,
    });
  } catch (error) {
    logger.error('❌ Error updating user role:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update user role',
      error: error.message,
    });
  }
};

/**
 * PATCH /admin/users/:userId/status
 * Update user status (active/inactive)
 */
const updateUserStatus = async (req, res) => {
  try {
    const { userId } = req.params;
    const { isActive } = req.body;

    if (typeof isActive !== 'boolean') {
      return res.status(400).json({
        success: false,
        message: 'isActive must be a boolean',
      });
    }

    logger.info(`✏️ Updating user status: ${userId} -> isActive: ${isActive}`);

    const user = await User.findByIdAndUpdate(
      userId,
      { isActive },
      { new: true, runValidators: true }
    ).select('-password');

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    logger.info(`✅ User status updated: ${user.email} -> isActive: ${isActive}`);

    res.status(200).json({
      success: true,
      message: `User account ${isActive ? 'activated' : 'deactivated'}`,
      data: user,
    });
  } catch (error) {
    logger.error('❌ Error updating user status:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update user status',
      error: error.message,
    });
  }
};

/**
 * DELETE /admin/users/:userId
 * Soft delete user (set isActive = false)
 */
const deleteUser = async (req, res) => {
  try {
    const { userId } = req.params;

    logger.info(`🗑️ Deleting user: ${userId}`);

    const user = await User.findByIdAndUpdate(
      userId,
      { isActive: false },
      { new: true }
    ).select('-password');

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    logger.info(`✅ User deleted (soft): ${user.email}`);

    res.status(200).json({
      success: true,
      message: 'User account deleted',
      data: user,
    });
  } catch (error) {
    logger.error('❌ Error deleting user:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete user',
      error: error.message,
    });
  }
};

/**
 * GET /admin/posts
 * Get all posts for moderation
 */
const getPosts = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const skip = (page - 1) * limit;

    logger.info(`📋 Fetching posts - page: ${page}, limit: ${limit}`);

    const total = await Post.countDocuments({ archived: false });

    const posts = await Post.find({ archived: false })
      .skip(skip)
      .limit(limit)
      .sort({ createdAt: -1 })
      .populate('authorId', 'fullName email')
      .lean();

    logger.info(`✅ Retrieved ${posts.length} posts`);

    res.status(200).json({
      success: true,
      data: posts,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    logger.error('❌ Error fetching posts:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch posts',
      error: error.message,
    });
  }
};

/**
 * DELETE /admin/posts/:postId
 * Delete post (hard delete)
 */
const deletePost = async (req, res) => {
  try {
    const { postId } = req.params;

    logger.info(`🗑️ Deleting post: ${postId}`);

    const post = await Post.findByIdAndDelete(postId);

    if (!post) {
      return res.status(404).json({
        success: false,
        message: 'Post not found',
      });
    }

    logger.info(`✅ Post deleted: ${postId}`);

    res.status(200).json({
      success: true,
      message: 'Post deleted',
      data: post,
    });
  } catch (error) {
    logger.error('❌ Error deleting post:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete post',
      error: error.message,
    });
  }
};

/**
 * GET /admin/logs
 * Get admin action logs (audit trail)
 */
const getAdminLogs = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;

    logger.info(`📋 Fetching admin logs - page: ${page}, limit: ${limit}`);

    // TODO: Implement admin logs collection
    // For now, return empty array
    res.status(200).json({
      success: true,
      data: [],
      message: 'Admin logs feature coming soon',
      pagination: {
        page,
        limit,
        total: 0,
        pages: 0,
      },
    });
  } catch (error) {
    logger.error('❌ Error fetching admin logs:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch admin logs',
      error: error.message,
    });
  }
};

module.exports = {
  getStats,
  getUsers,
  getUserDetails,
  updateUserRole,
  updateUserStatus,
  deleteUser,
  getPosts,
  deletePost,
  getAdminLogs,
};
