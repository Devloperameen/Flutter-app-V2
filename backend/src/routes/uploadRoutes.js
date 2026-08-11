/**
 * ============================================
 * Upload Routes
 * ============================================
 * 
 * Endpoints for file uploads
 * All routes require authentication
 */

const express = require('express');
const multer = require('multer');
const uploadController = require('../controllers/uploadController');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// ─── Multer Configuration ───────────────────────
// Configure multer to store files in memory
// Then save to disk in controller
const storage = multer.memoryStorage();

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 100 * 1024 * 1024, // 100MB max
  },
});

// ─── All routes are protected (require authentication) ───
router.use(authenticate);

/**
 * Upload user avatar/profile image
 * POST /api/v1/uploads/avatar
 * 
 * FormData:
 * - file: image file (JPEG, PNG, WebP)
 * - max size: 5MB
 * 
 * Returns: { url: "/uploads/avatars/...", filename: "..." }
 */
router.post('/avatar', upload.single('file'), uploadController.uploadAvatar);

/**
 * Upload post image
 * POST /api/v1/uploads/post-image
 * 
 * FormData:
 * - file: image file (JPEG, PNG, WebP, GIF)
 * - max size: 10MB
 */
router.post('/post-image', upload.single('file'), uploadController.uploadPostImage);

/**
 * Upload post video
 * POST /api/v1/uploads/post-video
 * 
 * FormData:
 * - file: video file (MP4, WebM, MOV)
 * - max size: 100MB
 */
router.post('/post-video', upload.single('file'), uploadController.uploadPostVideo);

/**
 * Upload message attachment
 * POST /api/v1/uploads/attachment
 * 
 * FormData:
 * - file: any supported file
 * - max size: 20MB
 * 
 * Supports: images, videos, PDFs, documents
 */
router.post('/attachment', upload.single('file'), uploadController.uploadAttachment);

module.exports = router;
