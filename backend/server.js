/**
 * ============================================
 * FitFlow Backend - Express Server Entry Point
 * ============================================
 * 
 * This is the main entry point for the Express.js application.
 * It initializes the server, connects to MongoDB, and starts listening.
 * 
 * Features:
 * - Environment configuration loading
 * - Database connection
 * - Middleware setup (CORS, logging, security)
 * - Route registration
 * - Error handling
 * - Graceful shutdown
 * - Production ready with all security measures
 */

// ─── Load environment variables first ───────────────
require('dotenv').config();

// ─── Core Dependencies ──────────────────────────────
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
require('express-async-errors');

// ─── Project Dependencies ───────────────────────────
const { connectDB } = require('./src/config/database');
const errorHandler = require('./src/middleware/errorHandler');
const logger = require('./src/utils/logger');
const { generalLimiter, authLimiter } = require('./src/middleware/rateLimiter');

// ─── Routes ─────────────────────────────────────────
const authRoutes = require('./src/routes/authRoutes');
const habitRoutes = require('./src/routes/habitRoutes');
const userRoutes = require('./src/routes/userRoutes');
const communityRoutes = require('./src/routes/communityRoutes');
const uploadRoutes = require('./src/routes/uploadRoutes');
const focusRoutes = require('./src/routes/focusRoutes');
const analyticsRoutes = require('./src/routes/analyticsRoutes');
const activityRoutes = require('./src/routes/activityRoutes');
const contentRoutes = require('./src/routes/contentRoutes');

// ─── Initialize Express App ─────────────────────────
const app = express();
const PORT = process.env.PORT || 3000;
const ENV = process.env.NODE_ENV || 'development';

/**
 * ─────────────────────────────────────────────────
 * MIDDLEWARE CONFIGURATION
 * ─────────────────────────────────────────────────
 */

// 1. Security Headers (Helmet)
app.use(helmet());
logger.info('✅ Helmet security headers enabled');

// 2. CORS Configuration
const corsOptions = {
  // In development, allow all origins (especially for mobile apps)
  // In production, use the CORS_ORIGIN env variable
  origin: (origin, callback) => {
    if (process.env.NODE_ENV === 'production') {
      const allowedOrigins = (process.env.CORS_ORIGIN || 'http://localhost:3000').split(',').map(o => o.trim());
      if (!origin || allowedOrigins.includes(origin) || allowedOrigins.includes('*')) {
        callback(null, true);
      } else {
        callback(new Error('Not allowed by CORS'));
      }
    } else {
      // Development: allow all origins
      callback(null, true);
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
};

app.use(cors(corsOptions));
logger.info('✅ CORS configured');

// 3. Rate Limiting Middleware
app.use(generalLimiter);
logger.info('✅ Rate limiting enabled');

// 4. Body Parser Middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));
logger.info('✅ Body parser middleware enabled');

// 5. Request Logging (Morgan)
const morganFormat = ENV === 'production' ? 'combined' : 'dev';
app.use(morgan(morganFormat));

// 6. Serve static files (uploaded files)
app.use('/uploads', express.static('uploads'));
logger.info('✅ Static file serving enabled at /uploads');

// 5. Health Check Endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: ENV,
  });
});

/**
 * ─────────────────────────────────────────────────
 * API ROUTES
 * ─────────────────────────────────────────────────
 * All routes are prefixed with /api/v1
 */

const apiV1 = '/api/v1';

app.use(`${apiV1}/auth`, authRoutes);
app.use(`${apiV1}/habits`, habitRoutes);
app.use(`${apiV1}/users`, userRoutes);
app.use(`${apiV1}/community`, communityRoutes);
app.use(`${apiV1}/uploads`, uploadRoutes);
app.use(`${apiV1}/focus`, focusRoutes);
app.use(`${apiV1}/analytics`, analyticsRoutes);
app.use(`${apiV1}/activity`, activityRoutes);
app.use(`${apiV1}/content`, contentRoutes);

logger.info('✅ All routes registered');

/**
 * ─────────────────────────────────────────────────
 * 404 - NOT FOUND HANDLER
 * ─────────────────────────────────────────────────
 */
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: `Route not found: ${req.method} ${req.originalUrl}`,
  });
});

/**
 * ─────────────────────────────────────────────────
 * ERROR HANDLING MIDDLEWARE
 * ─────────────────────────────────────────────────
 * This must be the last middleware defined
 */
app.use(errorHandler);

/**
 * ─────────────────────────────────────────────────
 * DATABASE CONNECTION & SERVER START
 * ─────────────────────────────────────────────────
 */

const startServer = async () => {
  try {
    // 1. Connect to MongoDB
    await connectDB();
    logger.info('✅ Connected to MongoDB');

    // 2. Start Express Server
    app.listen(PORT, () => {
      logger.info(`
╔════════════════════════════════════════╗
║   FitFlow Backend Server Started 🚀   ║
║────────────────────────────────────────║
║  Environment: ${ENV.padEnd(26)}║
║  Port: ${PORT.toString().padEnd(33)}║
║  URL: http://localhost:${PORT.toString().padEnd(28)}║
║  API: http://localhost:${PORT}/api/v1${' '.padEnd(19)}║
╚════════════════════════════════════════╝
      `);
    });
  } catch (error) {
    logger.error('❌ Failed to start server:', error);
    process.exit(1);
  }
};

/**
 * ─────────────────────────────────────────────────
 * GRACEFUL SHUTDOWN
 * ─────────────────────────────────────────────────
 * Properly close database connections on shutdown
 */

process.on('SIGINT', () => {
  logger.info('📍 SIGINT received, shutting down gracefully...');
  process.exit(0);
});

process.on('SIGTERM', () => {
  logger.info('📍 SIGTERM received, shutting down gracefully...');
  process.exit(0);
});

process.on('unhandledRejection', (reason, promise) => {
  logger.error('Unhandled Rejection at:', promise, 'reason:', reason);
  process.exit(1);
});

// ─── Start the Server ───────────────────────────────
startServer();

module.exports = app;
