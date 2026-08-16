const Post = require('../models/Post');
const User = require('../models/User');
const { success, error, paginated, sendResponse } = require('../utils/response');

const getPosts = async (req, res, next) => {
  try {
    const { limit = 20, page = 1 } = req.query;
    const pageNum = parseInt(page);
    const limitNum = parseInt(limit);
    const skip = (pageNum - 1) * limitNum;

    const posts = await Post.find()
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limitNum);

    const total = await Post.countDocuments();

    // Map to flutter structure
    const mappedPosts = posts.map(post => {
      const p = post.toJSON();
      // Ensure likeCount is properly included (in case toJSON doesn't include virtuals)
      p.likeCount = post.likeCount || post.likes?.length || 0;
      p.isLikedByMe = post.checkIsLikedBy(req.user.id);
      p.commentCount = post.commentCount || 0;
      return p;
    });

    sendResponse(res, success(mappedPosts, 'Posts fetched'));
  } catch (err) {
    next(err);
  }
};

const createPost = async (req, res, next) => {
  try {
    const { content, imageUrl, videoUrl } = req.body;
    const user = await User.findById(req.user.id);

    const newPost = await Post.create({
      authorId: user._id,
      authorName: user.fullName || `${user.firstName} ${user.lastName}`,
      authorRole: 'Member', // Can be customized later
      content,
      imageUrl,
      videoUrl,
    });

    const mapped = newPost.toJSON();
    mapped.likeCount = 0;
    mapped.isLikedByMe = false;

    sendResponse(res, success(mapped, 'Post created', 201));
  } catch (err) {
    next(err);
  }
};

const toggleLike = async (req, res, next) => {
  try {
    const { id } = req.params;
    const post = await Post.findById(id);

    if (!post) {
      return sendResponse(res, error('Post not found', 404));
    }

    const userId = req.user.id;
    const isLiked = post.checkIsLikedBy(userId);

    if (isLiked) {
      post.likes = post.likes.filter(uid => uid.toString() !== userId);
    } else {
      post.likes.push(userId);
    }

    await post.save();

    sendResponse(res, success({ isLiked: !isLiked }, 'Like toggled'));
  } catch (err) {
    next(err);
  }
};

const addComment = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { content } = req.body;
    
    if (!content) {
      return sendResponse(res, error('Comment content is required', 400));
    }

    const post = await Post.findById(id);

    if (!post) {
      return sendResponse(res, error('Post not found', 404));
    }

    // For now, we just increment the commentCount since full comment tracking
    // requires a separate Comment model or a comments array.
    post.commentCount = (post.commentCount || 0) + 1;
    await post.save();

    sendResponse(res, success({ commentCount: post.commentCount }, 'Comment added', 201));
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getPosts,
  createPost,
  toggleLike,
  addComment
};
