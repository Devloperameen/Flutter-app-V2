/**
 * ============================================
 * Upload Controller
 * ============================================
 * 
 * Handles file uploads:
 * - Profile avatars/images
 * - Post images & videos
 * - Message attachments
 * 
 * Uses local file storage (disk)
 * For production: Use AWS S3, Google Cloud Storage, etc
 */

const fs = require('fs');
const path = require('path');
const logger = require('../utils/logger');
const { success, error, validationError, sendResponse } = require('../utils/response');

// Create uploads directory if it doesn't exist
const uploadsDir = path.join(__dirname, '../../uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
  logger.info('✅ Created uploads directory');
}

// ─── Configuration ──────────────────────────────

/**
 * Allowed file types and maximum sizes
 */
const FILE_CONFIG = {
  avatar: {
    maxSize: 5 * 1024 * 1024, // 5MB
    mimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
    directory: 'avatars',
  },
  postImage: {
    maxSize: 10 * 1024 * 1024, // 10MB
    mimeTypes: ['image/jpeg', 'image/png', 'image/webp', 'image/gif'],
    directory: 'posts/images',
  },
  postVideo: {
    maxSize: 100 * 1024 * 1024, // 100MB
    mimeTypes: ['video/mp4', 'video/webm', 'video/quicktime'],
    directory: 'posts/videos',
  },
  messageAttachment: {
    maxSize: 20 * 1024 * 1024, // 20MB
    mimeTypes: [
      'image/jpeg', 'image/png', 'image/webp',
      'video/mp4', 'video/webm',
      'application/pdf', 'application/msword'
    ],
    directory: 'messages',
  },
};

// ─── Upload Handlers ────────────────────────────

/**
 * Upload user avatar/profile image
 * 
 * POST /api/v1/uploads/avatar
 * Body: FormData with 'file' field
 * 
 * Returns: { url: "/uploads/avatars/..." }
 */
const uploadAvatar = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // ─── Validate file exists ───────────────────
    if (!req.file) {
      const errorResponse = validationError(['No file provided']);
      return sendResponse(res, errorResponse);
    }

    // ─── Validate file type & size ──────────────
    const validation = _validateFile(req.file, FILE_CONFIG.avatar);
    if (!validation.valid) {
      const errorResponse = validationError(validation.errors);
      return sendResponse(res, errorResponse);
    }

    // ─── Save file ──────────────────────────────
    const filename = _generateFilename(req.file, userId);
    const uploadPath = path.join(uploadsDir, FILE_CONFIG.avatar.directory);
    
    // Create directory if needed
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }

    const filepath = path.join(uploadPath, filename);
    
    // Save file
    fs.writeFileSync(filepath, req.file.buffer);

    // ─── Generate URL ───────────────────────────
    const fileUrl = `/uploads/${FILE_CONFIG.avatar.directory}/${filename}`;

    logger.info(`✅ Avatar uploaded for user ${userId}: ${fileUrl}`);

    const responseData = success(
      { url: fileUrl, filename },
      'Avatar uploaded successfully',
      201
    );
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Upload avatar error:', error);
    next(error);
  }
};

/**
 * Upload post image
 * 
 * POST /api/v1/uploads/post-image
 * Body: FormData with 'file' field
 */
const uploadPostImage = async (req, res, next) => {
  try {
    const userId = req.user.id;

    if (!req.file) {
      const errorResponse = validationError(['No file provided']);
      return sendResponse(res, errorResponse);
    }

    const validation = _validateFile(req.file, FILE_CONFIG.postImage);
    if (!validation.valid) {
      const errorResponse = validationError(validation.errors);
      return sendResponse(res, errorResponse);
    }

    const filename = _generateFilename(req.file, userId);
    const uploadPath = path.join(uploadsDir, FILE_CONFIG.postImage.directory);
    
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }

    const filepath = path.join(uploadPath, filename);
    fs.writeFileSync(filepath, req.file.buffer);

    const fileUrl = `/uploads/${FILE_CONFIG.postImage.directory}/${filename}`;

    logger.info(`✅ Post image uploaded: ${fileUrl}`);

    const responseData = success(
      { url: fileUrl, filename },
      'Image uploaded successfully',
      201
    );
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Upload post image error:', error);
    next(error);
  }
};

/**
 * Upload post video
 * 
 * POST /api/v1/uploads/post-video
 * Body: FormData with 'file' field
 */
const uploadPostVideo = async (req, res, next) => {
  try {
    const userId = req.user.id;

    if (!req.file) {
      const errorResponse = validationError(['No file provided']);
      return sendResponse(res, errorResponse);
    }

    const validation = _validateFile(req.file, FILE_CONFIG.postVideo);
    if (!validation.valid) {
      const errorResponse = validationError(validation.errors);
      return sendResponse(res, errorResponse);
    }

    const filename = _generateFilename(req.file, userId);
    const uploadPath = path.join(uploadsDir, FILE_CONFIG.postVideo.directory);
    
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }

    const filepath = path.join(uploadPath, filename);
    fs.writeFileSync(filepath, req.file.buffer);

    const fileUrl = `/uploads/${FILE_CONFIG.postVideo.directory}/${filename}`;

    logger.info(`✅ Video uploaded: ${fileUrl}`);

    const responseData = success(
      { url: fileUrl, filename },
      'Video uploaded successfully',
      201
    );
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Upload video error:', error);
    next(error);
  }
};

/**
 * Upload message attachment
 * 
 * POST /api/v1/uploads/attachment
 * Body: FormData with 'file' field
 */
const uploadAttachment = async (req, res, next) => {
  try {
    const userId = req.user.id;

    if (!req.file) {
      const errorResponse = validationError(['No file provided']);
      return sendResponse(res, errorResponse);
    }

    const validation = _validateFile(req.file, FILE_CONFIG.messageAttachment);
    if (!validation.valid) {
      const errorResponse = validationError(validation.errors);
      return sendResponse(res, errorResponse);
    }

    const filename = _generateFilename(req.file, userId);
    const uploadPath = path.join(uploadsDir, FILE_CONFIG.messageAttachment.directory);
    
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }

    const filepath = path.join(uploadPath, filename);
    fs.writeFileSync(filepath, req.file.buffer);

    const fileUrl = `/uploads/${FILE_CONFIG.messageAttachment.directory}/${filename}`;

    logger.info(`✅ Attachment uploaded: ${fileUrl}`);

    const responseData = success(
      { url: fileUrl, filename },
      'File uploaded successfully',
      201
    );
    sendResponse(res, responseData);
  } catch (error) {
    logger.error('Upload attachment error:', error);
    next(error);
  }
};

// ─── Helper Functions ───────────────────────────

/**
 * Validate file against config rules
 * 
 * @param {object} file - Express file object
 * @param {object} config - File configuration
 * @returns {object} { valid: boolean, errors: array }
 */
function _validateFile(file, config) {
  const errors = [];

  // Check file exists
  if (!file) {
    errors.push('No file provided');
    return { valid: false, errors };
  }

  // Check file size
  if (file.size > config.maxSize) {
    const maxMB = config.maxSize / (1024 * 1024);
    errors.push(`File too large. Max size: ${maxMB}MB`);
  }

  // Check MIME type
  if (!config.mimeTypes.includes(file.mimetype)) {
    errors.push(`Invalid file type. Allowed: ${config.mimeTypes.join(', ')}`);
  }

  return {
    valid: errors.length === 0,
    errors,
  };
}

/**
 * Generate unique filename
 * 
 * Format: userId_timestamp_originalname.ext
 * Example: user123_1234567890_profile.jpg
 */
function _generateFilename(file, userId) {
  const timestamp = Date.now();
  const ext = path.extname(file.originalname);
  const name = path.basename(file.originalname, ext);
  
  // Clean filename (remove special chars)
  const cleanName = name.replace(/[^a-zA-Z0-9]/g, '_');
  
  return `${userId}_${timestamp}_${cleanName}${ext}`;
}

/**
 * Get file URL from path
 * 
 * Convert local path to public URL
 */
function _getFileUrl(filepath) {
  return `/uploads/${path.relative(uploadsDir, filepath)}`;
}

module.exports = {
  uploadAvatar,
  uploadPostImage,
  uploadPostVideo,
  uploadAttachment,
};
