/**
 * ============================================
 * Community Routes
 * ============================================
 * 
 * Endpoints for community features:
 * - Direct messaging
 * - Group chat
 * - Message reactions
 * 
 * All routes require authentication
 */

const express = require('express');
const communityController = require('../controllers/communityController');
const postController = require('../controllers/postController');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// ─── All routes are protected (require authentication) ───
router.use(authenticate);

// ─── Posts ─────────────────────────────────────────
router.get('/posts', postController.getPosts);
router.post('/posts', postController.createPost);
router.post('/posts/:id/like', postController.toggleLike);

/**
 * ─────────────────────────────────────────────────
 * DIRECT MESSAGING ROUTES
 * ─────────────────────────────────────────────────
 */

/**
 * Get direct message conversation
 * GET /api/v1/community/messages/:userId
 * 
 * Get all messages between current user and another user
 * Query params:
 *   - limit: 1-100 (default: 50)
 *   - page: 1+ (default: 1)
 */
router.get('/messages/:userId', communityController.getConversation);

/**
 * Send direct message
 * POST /api/v1/community/messages
 * 
 * Body:
 * {
 *   "receiverId": "userId",
 *   "message": "Hi there!",
 *   "attachments": [
 *     {
 *       "url": "https://...",
 *       "type": "image"
 *     }
 *   ]
 * }
 */
router.post('/messages', communityController.sendDirectMessage);

/**
 * ─────────────────────────────────────────────────
 * GROUP CHAT ROUTES
 * ─────────────────────────────────────────────────
 */

/**
 * Get group chat messages
 * GET /api/v1/community/rooms/:roomId/messages
 * 
 * Get all messages in a group chat room
 * Query params:
 *   - limit: 1-100 (default: 50)
 *   - page: 1+ (default: 1)
 */
router.get('/rooms/:roomId/messages', communityController.getRoomMessages);

/**
 * Send group chat message
 * POST /api/v1/community/rooms/:roomId/messages
 * 
 * Body:
 * {
 *   "message": "Hello everyone!",
 *   "attachments": []
 * }
 */
router.post('/rooms/:roomId/messages', communityController.sendRoomMessage);

/**
 * ─────────────────────────────────────────────────
 * UNREAD MESSAGE TRACKING
 * ─────────────────────────────────────────────────
 */

/**
 * Get unread message count
 * GET /api/v1/community/messages/unread/count
 * 
 * Returns number of unread messages for current user
 * Response: { "unreadCount": 5 }
 */
router.get('/messages/unread/count', communityController.getUnreadCount);

/**
 * Get unread messages
 * GET /api/v1/community/messages/unread
 * 
 * Returns list of all unread messages
 */
router.get('/messages/unread', communityController.getUnreadMessages);

/**
 * ─────────────────────────────────────────────────
 * MESSAGE REACTIONS
 * ─────────────────────────────────────────────────
 */

/**
 * Add emoji reaction to message
 * POST /api/v1/community/messages/:messageId/reactions
 * 
 * Body:
 * {
 *   "emoji": "👍"
 * }
 */
router.post('/messages/:messageId/reactions', communityController.addReaction);

/**
 * Remove emoji reaction from message
 * DELETE /api/v1/community/messages/:messageId/reactions/:emoji
 * 
 * URL Params:
 *   - messageId: Message ID
 *   - emoji: Emoji to remove (URL encoded)
 * 
 * Example: DELETE /api/v1/community/messages/123/reactions/%F0%9F%91%8D
 */
router.delete('/messages/:messageId/reactions/:emoji', communityController.removeReaction);

/**
 * ─────────────────────────────────────────────────
 * MESSAGE MANAGEMENT
 * ─────────────────────────────────────────────────
 */

/**
 * Delete message
 * DELETE /api/v1/community/messages/:messageId
 * 
 * Only message sender can delete
 * Soft delete (message marked as deleted but not removed)
 */
router.delete('/messages/:messageId', communityController.deleteMessage);

module.exports = router;
