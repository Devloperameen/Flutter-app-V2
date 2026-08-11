/**
 * ============================================
 * User Model
 * ============================================
 * 
 * Represents a user in the FitFlow application
 * Stores authentication data, profile info, and settings
 */

const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

/**
 * User Schema Definition
 * 
 * Fields:
 * - email: Unique email address (login credential)
 * - password: Hashed password (never stored plain)
 * - fullName: User's display name
 * - avatar: URL to profile picture
 * - bio: Short user biography
 * - createdAt: Account creation timestamp
 * - updatedAt: Last update timestamp
 * - lastLogin: Timestamp of last login
 * - isEmailVerified: Whether email is verified
 * - isActive: Whether account is active (can be disabled)
 */
const userSchema = new mongoose.Schema(
  {
    // ─── Authentication ──────────────────────────
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      lowercase: true,
      trim: true,
      match: [/.+@.+\..+/, 'Invalid email format'],
    },
    password: {
      type: String,
      required: [true, 'Password is required'],
      minlength: [8, 'Password must be at least 8 characters'],
      select: false, // Don't return password by default
    },

    // ─── Profile Information ─────────────────────
    fullName: {
      type: String,
      required: [true, 'Full name is required'],
      trim: true,
      maxlength: [100, 'Name must be less than 100 characters'],
    },
    avatar: {
      type: String,
      default: null,
    },
    bio: {
      type: String,
      default: '',
      maxlength: [500, 'Bio must be less than 500 characters'],
    },

    // ─── Role & Permissions ──────────────────────
    role: {
      type: String,
      enum: ['user', 'admin'],
      default: 'user',
    },

    // ─── Account Status ──────────────────────────
    isEmailVerified: {
      type: Boolean,
      default: false,
    },
    isActive: {
      type: Boolean,
      default: true,
    },

    // ─── Activity Tracking ───────────────────────
    lastLogin: {
      type: Date,
      default: null,
    },

    // ─── Preferences ─────────────────────────────
    preferences: {
      theme: {
        type: String,
        enum: ['light', 'dark'],
        default: 'light',
      },
      notifications: {
        enabled: { type: Boolean, default: true },
        email: { type: Boolean, default: true },
        push: { type: Boolean, default: true },
      },
    },

    // ─── Statistics ──────────────────────────────
    stats: {
      totalHabits: { type: Number, default: 0 },
      totalCompletions: { type: Number, default: 0 },
      currentStreak: { type: Number, default: 0 },
      longestStreak: { type: Number, default: 0 },
    },

    // ─── Gamification ────────────────────────────
    level: {
      type: Number,
      default: 1,
      min: [1, 'Level must be at least 1'],
    },
    xp: {
      type: Number,
      default: 0,
      min: [0, 'XP cannot be negative'],
    },
  },
  {
    // Automatically add createdAt and updatedAt fields
    timestamps: true,
    
    // Exclude certain fields when converting to JSON
    toJSON: { select: '-password' },
  }
);

/**
 * ─────────────────────────────────────────────────
 * INDEXES - Improve query performance
 * ─────────────────────────────────────────────────
 */

// Speed up email lookups (used during login)
userSchema.index({ email: 1 });

// Speed up queries for active users
userSchema.index({ isActive: 1 });

// Speed up queries for verified users
userSchema.index({ isEmailVerified: 1 });

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE - Pre/Post hooks
 * ─────────────────────────────────────────────────
 */

/**
 * Pre-save hook: Hash password before saving
 * 
 * Why:
 * - Never store plain passwords
 * - User's password is private and sensitive
 * - Password is hashed using bcrypt (one-way encryption)
 * 
 * This runs only if password is modified
 */
userSchema.pre('save', async function (next) {
  // Skip if password hasn't been modified
  if (!this.isModified('password')) {
    return next();
  }

  try {
    // Generate salt and hash password
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

/**
 * ─────────────────────────────────────────────────
 * METHODS - Custom instance methods
 * ─────────────────────────────────────────────────
 */

/**
 * Compare provided password with hashed password
 * 
 * Usage in login:
 * const user = await User.findOne({ email });
 * const isValid = await user.comparePassword(providedPassword);
 * 
 * @param {string} providedPassword - Password provided by user
 * @returns {Promise<boolean>} True if passwords match
 */
userSchema.methods.comparePassword = async function (providedPassword) {
  return await bcrypt.compare(providedPassword, this.password);
};

/**
 * Get public user data (safe to send to client)
 * 
 * Usage: return user.toPublicJSON();
 * 
 * @returns {object} User data without sensitive info
 */
userSchema.methods.toPublicJSON = function () {
  const user = this.toObject();
  delete user.password;
  return user;
};

/**
 * ─────────────────────────────────────────────────
 * STATICS - Collection-level methods
 * ─────────────────────────────────────────────────
 */

/**
 * Find user by email
 * 
 * Usage: const user = await User.findByEmail('user@example.com');
 * 
 * @param {string} email - User email
 * @returns {Promise<User>} User document
 */
userSchema.statics.findByEmail = async function (email) {
  return await this.findOne({ email: email.toLowerCase() });
};

/**
 * Find active user by email
 * 
 * @param {string} email - User email
 * @returns {Promise<User>} User document if active
 */
userSchema.statics.findActiveByEmail = async function (email) {
  return await this.findOne({
    email: email.toLowerCase(),
    isActive: true,
  });
};

// Export the User model
module.exports = mongoose.model('User', userSchema);
