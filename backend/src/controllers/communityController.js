/**
 * ============================================
 * Community Controller
 * ============================================
 * 
 * Handles community features:
 * - Direct messaging
 * - Group chat
 * - Message reactions
 * - Unread message tracking
 */

const ChatMessage = require('../models/ChatMessage');
const User = require('../models/User');
const logger = require('../utils/logger');
const { success, error, validationError, paginated, sendResponse } = require('../utils/response');

/**
 * Get direct message conversation with another user
 * 
 * GET /api/v1/community/messages/:userId
 * Query params: ?limit=50&page=1
 */
const getConversation = async (req, res, next) => {
  try {
    const currentUserId = req.user.id;
    const { userId: otherUserId } = req.params;
    const { limit = 50, page = 1 } = req.query;

    // ─── Validate input ─────────────────────────
    if (!otherUserId) {
      const errorResponse = validationError(['User ID is required']);
      return sendResponse(res, errorResponse);
    }

    if (currentUserId === otherUserId) {
      const errorResponse = error('Cannot message yourself', 400);
      return sendResponse(res, errorResponse);
    }

    // ─── Verify other user exists ───────────────
    const otherUser = await User.findById(otherUserId);
    if (!otherUser) {
      const errorResponse = error('User not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Parse pagination ───────────────────────
    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(100, parseInt(limit) || 50);
    const skip = (pageNum - 1) * limitNum;

    // ─── Fetch conversation ─────────────────────
    const messages = await ChatMessage.getConversation(currentUserId, otherUserId, limitNum);

    // ─── Mark messages as read ──────────────────
    await ChatMessage.markConversationAsRead(currentUserId, otherUserId);

    logger.info(`✅ Fetched conversation between ${currentUserId} and ${otherUserId}`);

    const responseData = success(
      {
        messages,
        other_user: {
          id: otherUser._id,
          fullName: otherUser.fullName,
          avatar: otherUser.avatar,
        },
      },
      'Conversation retrieved successfully'
    );

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get conversation error:', error);
    next(error);
  }
};

/**
 * Send a direct message
 * 
 * POST /api/v1/community/messages
 * Body: { receiverId, message, attachments }
 */
const sendDirectMessage = async (req, res, next) => {
  try {
    const senderId = req.user.id;
    const { receiverId, message, attachments } = req.body;

    // ─── Validate input ─────────────────────────
    const errors = [];

    if (!receiverId) {
      errors.push('Receiver ID is required');
    }

    if (!message || message.trim().length === 0) {
      errors.push('Message cannot be empty');
    }

    if (message && message.length > 5000) {
      errors.push('Message must be less than 5000 characters');
    }

    if (senderId === receiverId) {
      errors.push('Cannot message yourself');
    }

    if (errors.length > 0) {
      const errorResponse = validationError(errors, 'Message validation failed');
      return sendResponse(res, errorResponse);
    }

    // ─── Verify receiver exists ─────────────────
    const receiver = await User.findById(receiverId);
    if (!receiver) {
      const errorResponse = error('Receiver not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Create message ─────────────────────────
    const newMessage = new ChatMessage({
      senderId,
      receiverId,
      message: message.trim(),
      attachments: attachments || [],
    });

    await newMessage.save();
    await newMessage.populate('senderId', 'fullName avatar');

    logger.info(`✅ Direct message sent from ${senderId} to ${receiverId}`);

    const responseData = success(newMessage, 'Message sent successfully', 201);
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Send direct message error:', error);
    next(error);
  }
};

/**
 * Get group chat messages (room-based)
 * 
 * GET /api/v1/community/rooms/:roomId/messages
 * Query params: ?limit=50&page=1
 */
const getRoomMessages = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { roomId } = req.params;
    const { limit = 50, page = 1 } = req.query;

    // ─── Parse pagination ───────────────────────
    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(100, parseInt(limit) || 50);

    // ─── Fetch room messages ────────────────────
    const messages = await ChatMessage.getRoomMessages(roomId, limitNum);

    const total = await ChatMessage.countDocuments({ roomId, isDeleted: false });

    logger.info(`✅ Fetched messages from room: ${roomId}`);

    const responseData = paginated(messages, pageNum, limitNum, total, 'Room messages retrieved');

    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get room messages error:', error);
    next(error);
  }
};

/**
 * Send group chat message
 * 
 * POST /api/v1/community/rooms/:roomId/messages
 * Body: { message, attachments }
 */
const sendRoomMessage = async (req, res, next) => {
  try {
    const senderId = req.user.id;
    const { roomId } = req.params;
    const { message, attachments } = req.body;

    // ─── Validate input ─────────────────────────
    const errors = [];

    if (!roomId) {
      errors.push('Room ID is required');
    }

    if (!message || message.trim().length === 0) {
      errors.push('Message cannot be empty');
    }

    if (message && message.length > 5000) {
      errors.push('Message must be less than 5000 characters');
    }

    if (errors.length > 0) {
      const errorResponse = validationError(errors, 'Message validation failed');
      return sendResponse(res, errorResponse);
    }

    // ─── Create message ─────────────────────────
    const newMessage = new ChatMessage({
      senderId,
      roomId,
      message: message.trim(),
      attachments: attachments || [],
    });

    await newMessage.save();
    await newMessage.populate('senderId', 'fullName avatar');

    logger.info(`✅ Room message sent to ${roomId}`);

    const responseData = success(newMessage, 'Message sent to room successfully', 201);
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Send room message error:', error);
    next(error);
  }
};

/**
 * Get unread messages count
 * 
 * GET /api/v1/community/messages/unread/count
 */
const getUnreadCount = async (req, res, next) => {
  try {
    const userId = req.user.id;

    const unreadCount = await ChatMessage.getUnreadCount(userId);

    logger.info(`✅ Fetched unread count for user: ${userId}`);

    const responseData = success({ unreadCount }, 'Unread count retrieved');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get unread count error:', error);
    next(error);
  }
};

/**
 * Get unread messages
 * 
 * GET /api/v1/community/messages/unread
 */
const getUnreadMessages = async (req, res, next) => {
  try {
    const userId = req.user.id;

    const messages = await ChatMessage.getUnreadMessages(userId);

    logger.info(`✅ Fetched ${messages.length} unread messages for user: ${userId}`);

    const responseData = success(messages, 'Unread messages retrieved');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Get unread messages error:', error);
    next(error);
  }
};

/**
 * Add emoji reaction to message
 * 
 * POST /api/v1/community/messages/:messageId/reactions
 * Body: { emoji }
 */
const addReaction = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { messageId } = req.params;
    const { emoji } = req.body;

    // ─── Validate input ─────────────────────────
    if (!emoji) {
      const errorResponse = validationError(['Emoji is required']);
      return sendResponse(res, errorResponse);
    }

    // ─── Find message ───────────────────────────
    const message = await ChatMessage.findById(messageId);

    if (!message) {
      const errorResponse = error('Message not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Add reaction ───────────────────────────
    await message.addReaction(emoji, userId);

    logger.info(`✅ Reaction added to message: ${messageId}`);

    const responseData = success(message, 'Reaction added successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Add reaction error:', error);
    next(error);
  }
};

/**
 * Remove emoji reaction from message
 * 
 * DELETE /api/v1/community/messages/:messageId/reactions/:emoji
 */
const removeReaction = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { messageId, emoji } = req.params;

    // ─── Find message ───────────────────────────
    const message = await ChatMessage.findById(messageId);

    if (!message) {
      const errorResponse = error('Message not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Remove reaction ────────────────────────
    await message.removeReaction(emoji, userId);

    logger.info(`✅ Reaction removed from message: ${messageId}`);

    const responseData = success(message, 'Reaction removed successfully');
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Remove reaction error:', error);
    next(error);
  }
};

/**
 * Delete a message
 * 
 * DELETE /api/v1/community/messages/:messageId
 */
const deleteMessage = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { messageId } = req.params;

    // ─── Find message ───────────────────────────
    const message = await ChatMessage.findById(messageId);

    if (!message) {
      const errorResponse = error('Message not found', 404);
      return sendResponse(res, errorResponse);
    }

    // ─── Check ownership ────────────────────────
    if (message.senderId.toString() !== userId) {
      const errorResponse = error('You can only delete your own messages', 403);
      return sendResponse(res, errorResponse);
    }

    // ─── Delete message ─────────────────────────
    await message.delete();

    logger.info(`🗑️ Message deleted: ${messageId}`);

    const responseData = success({ message: 'Message deleted successfully' });
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Delete message error:', error);
    next(error);
  }
};

module.exports = {
  getConversation,
  sendDirectMessage,
  getRoomMessages,
  sendRoomMessage,
  getUnreadCount,
  getUnreadMessages,
  addReaction,
  removeReaction,
  deleteMessage,
};
