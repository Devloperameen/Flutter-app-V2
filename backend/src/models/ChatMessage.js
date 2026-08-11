/**
 * ============================================
 * Chat Message Model
 * ============================================
 * 
 * Represents messages in the community chat
 * Handles direct messages and group chat
 */

const mongoose = require('mongoose');

/**
 * Chat Message Schema Definition
 * 
 * Supports:
 * - Direct 1-on-1 messaging (sender to receiver)
 * - Group chat (via roomId)
 * - Message status tracking (read/unread)
 * - File attachments
 */
const chatMessageSchema = new mongoose.Schema(
  {
    // ─── Participants ────────────────────────────
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Sender is required'],
    },

    receiverId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null, // null for group messages
    },

    // ─── Group Chat Support ──────────────────────
    roomId: {
      type: String, // e.g., "community", "general", "team-1"
      default: null,
    },

    // ─── Message Content ─────────────────────────
    message: {
      type: String,
      required: [true, 'Message content is required'],
      maxlength: [5000, 'Message must be less than 5000 characters'],
      trim: true,
    },

    // ─── Attachments ─────────────────────────────
    attachments: [
      {
        url: String,
        type: {
          type: String,
          enum: ['image', 'video', 'audio', 'document'],
          default: 'image',
        },
        size: Number,
      },
    ],

    // ─── Message Status ──────────────────────────
    isRead: {
      type: Boolean,
      default: false,
    },
    readAt: {
      type: Date,
      default: null,
    },

    // ─── Editing ──────────────────────────────────
    isEdited: {
      type: Boolean,
      default: false,
    },
    editedAt: {
      type: Date,
      default: null,
    },

    // ─── Reactions ────────────────────────────────
    // Example: { "😂": [userId1, userId2], "❤️": [userId3] }
    reactions: {
      type: Map,
      of: [mongoose.Schema.Types.ObjectId],
      default: new Map(),
    },

    // ─── Deletion ──────────────────────────────────
    isDeleted: {
      type: Boolean,
      default: false,
    },
    deletedAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true, // createdAt, updatedAt
  }
);

/**
 * ─────────────────────────────────────────────────
 * INDEXES - Improve query performance
 * ─────────────────────────────────────────────────
 */

// Get messages for a user (received or sent)
chatMessageSchema.index({ receiverId: 1, createdAt: -1 });
chatMessageSchema.index({ senderId: 1, createdAt: -1 });

// Get room messages
chatMessageSchema.index({ roomId: 1, createdAt: -1 });

// Get unread messages for user
chatMessageSchema.index({ receiverId: 1, isRead: 1 });

// Get conversation between two users
chatMessageSchema.index({ senderId: 1, receiverId: 1, createdAt: -1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save: Validate message type
 * Either direct message (receiverId) or group message (roomId), not both
 */
chatMessageSchema.pre('save', function (next) {
  // Ensure message is either direct or group, not both
  if ((this.receiverId && this.roomId) || (!this.receiverId && !this.roomId)) {
    throw new Error('Message must have either receiverId or roomId, not both or neither');
  }

  next();
});

/**
 * ─────────────────────────────────────────────────
 * METHODS - Custom instance methods
 * ─────────────────────────────────────────────────
 */

/**
 * Mark message as read
 * 
 * @returns {Promise<void>}
 */
chatMessageSchema.methods.markAsRead = async function () {
  this.isRead = true;
  this.readAt = new Date();
  await this.save();
};

/**
 * Edit message content
 * 
 * @param {string} newMessage - Updated message text
 * @returns {Promise<void>}
 */
chatMessageSchema.methods.editMessage = async function (newMessage) {
  if (!newMessage || newMessage.trim().length === 0) {
    throw new Error('Message cannot be empty');
  }

  this.message = newMessage;
  this.isEdited = true;
  this.editedAt = new Date();
  await this.save();
};

/**
 * Add emoji reaction to message
 * 
 * @param {string} emoji - Emoji to add
 * @param {string} userId - User adding reaction
 * @returns {Promise<void>}
 */
chatMessageSchema.methods.addReaction = async function (emoji, userId) {
  if (!this.reactions.has(emoji)) {
    this.reactions.set(emoji, []);
  }

  const reacters = this.reactions.get(emoji);
  if (!reacters.includes(userId)) {
    reacters.push(userId);
  }

  await this.save();
};

/**
 * Remove emoji reaction from message
 * 
 * @param {string} emoji - Emoji to remove
 * @param {string} userId - User removing reaction
 * @returns {Promise<void>}
 */
chatMessageSchema.methods.removeReaction = async function (emoji, userId) {
  if (this.reactions.has(emoji)) {
    const reacters = this.reactions.get(emoji);
    const index = reacters.indexOf(userId);
    if (index > -1) {
      reacters.splice(index, 1);

      if (reacters.length === 0) {
        this.reactions.delete(emoji);
      }
    }
  }

  await this.save();
};

/**
 * Soft delete message (for privacy)
 * 
 * @returns {Promise<void>}
 */
chatMessageSchema.methods.delete = async function () {
  this.isDeleted = true;
  this.deletedAt = new Date();
  this.message = '[Message deleted]';
  await this.save();
};

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Get direct message conversation between two users
 * 
 * @param {string} userId1 - First user ID
 * @param {string} userId2 - Second user ID
 * @param {number} limit - Max messages to return
 * @returns {Promise<Array>} Messages between users
 */
chatMessageSchema.statics.getConversation = async function (userId1, userId2, limit = 50) {
  return await this.find({
    $or: [
      { senderId: userId1, receiverId: userId2 },
      { senderId: userId2, receiverId: userId1 },
    ],
    isDeleted: false,
  })
    .sort({ createdAt: -1 })
    .limit(limit)
    .populate('senderId', 'fullName avatar')
    .populate('receiverId', 'fullName avatar');
};

/**
 * Get room messages (group chat)
 * 
 * @param {string} roomId - Room identifier
 * @param {number} limit - Max messages to return
 * @returns {Promise<Array>} Messages in room
 */
chatMessageSchema.statics.getRoomMessages = async function (roomId, limit = 50) {
  return await this.find({
    roomId,
    isDeleted: false,
  })
    .sort({ createdAt: -1 })
    .limit(limit)
    .populate('senderId', 'fullName avatar');
};

/**
 * Get unread messages count for a user
 * 
 * @param {string} userId - User's ID
 * @returns {Promise<number>} Count of unread messages
 */
chatMessageSchema.statics.getUnreadCount = async function (userId) {
  return await this.countDocuments({
    receiverId: userId,
    isRead: false,
    isDeleted: false,
  });
};

/**
 * Get unread messages for a user
 * 
 * @param {string} userId - User's ID
 * @returns {Promise<Array>} Unread messages
 */
chatMessageSchema.statics.getUnreadMessages = async function (userId) {
  return await this.find({
    receiverId: userId,
    isRead: false,
    isDeleted: false,
  })
    .sort({ createdAt: -1 })
    .populate('senderId', 'fullName avatar');
};

/**
 * Mark all messages in conversation as read
 * 
 * @param {string} userId - Receiving user ID
 * @param {string} senderId - Sending user ID
 * @returns {Promise<object>} Update result
 */
chatMessageSchema.statics.markConversationAsRead = async function (userId, senderId) {
  return await this.updateMany(
    {
      receiverId: userId,
      senderId,
      isRead: false,
    },
    {
      $set: {
        isRead: true,
        readAt: new Date(),
      },
    }
  );
};

// Export the ChatMessage model
module.exports = mongoose.model('ChatMessage', chatMessageSchema);
