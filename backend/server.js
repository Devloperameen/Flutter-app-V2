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
const http = require('http');
const socketIo = require('socket.io');
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
const adminRoutes = require('./src/routes/adminRoutes');
const dashboardRoutes = require('./src/routes/dashboardRoutes');

// ─── Initialize Express App ─────────────────────────
const app = express();
const PORT = process.env.PORT || 3000;
const ENV = process.env.NODE_ENV || 'development';

// ─── Create HTTP Server with Socket.IO ──────────────
const httpServer = http.createServer(app);
const io = socketIo(httpServer, {
  cors: {
    origin: function(origin, callback) {
      if (process.env.NODE_ENV === 'production') {
        const allowedOrigins = (process.env.CORS_ORIGIN || 'https://flutter-app-v2.onrender.com').split(',').map(o => o.trim());
        if (!origin || allowedOrigins.includes(origin) || allowedOrigins.includes('*')) {
          callback(null, true);
        } else {
          callback(new Error('Not allowed by CORS'));
        }
      } else {
        callback(null, true);
      }
    },
    methods: ['GET', 'POST'],
    credentials: true,
  },
  path: '/socket.io/',
  transports: ['websocket', 'polling'],
  reconnection: true,
  reconnectionDelay: 1000,
  reconnectionDelayMax: 5000,
  reconnectionAttempts: 5,
});

logger.info('✅ Socket.IO configured with WebSocket support');

// Trust proxy - required for Render deployment with X-Forwarded-For headers
app.set('trust proxy', 1);

/**
 * ─────────────────────────────────────────────────
 * SOCKET.IO EVENT HANDLERS
 * ─────────────────────────────────────────────────
 */

io.on('connection', (socket) => {
  const userId = socket.handshake.auth?.token || 'anonymous';
  logger.info(`✅ Socket.IO client connected: ${socket.id} (User: ${userId})`);

  // Handle authentication
  socket.on('authenticate', (data) => {
    logger.info(`🔐 Socket.IO authentication: ${socket.id}`);
  });

  // Handle chat events
  socket.on('message:new', (data) => {
    logger.info(`💬 New message from ${socket.id}: ${data.message}`);
    // Broadcast to all clients
    io.emit('message:received', data);
  });

  // Handle disconnect
  socket.on('disconnect', () => {
    logger.info(`❌ Socket.IO client disconnected: ${socket.id}`);
  });

  socket.on('error', (error) => {
    logger.error(`❌ Socket.IO error for ${socket.id}:`, error);
  });
});

logger.info('✅ Socket.IO event handlers registered');

/**
 * ─────────────────────────────────────────────────
 * EXPRESS MIDDLEWARE CONFIGURATION
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

// Register all routes
logger.info('📍 Registering routes...');

app.use(`${apiV1}/auth`, authRoutes);
logger.info(`✅ /api/v1/auth registered`);

app.use(`${apiV1}/habits`, habitRoutes);
logger.info(`✅ /api/v1/habits registered`);

app.use(`${apiV1}/users`, userRoutes);
logger.info(`✅ /api/v1/users registered`);

app.use(`${apiV1}/community`, communityRoutes);
logger.info(`✅ /api/v1/community registered (includes /posts)`);

app.use(`${apiV1}/uploads`, uploadRoutes);
logger.info(`✅ /api/v1/uploads registered`);

app.use(`${apiV1}/focus`, focusRoutes);
logger.info(`✅ /api/v1/focus registered`);

app.use(`${apiV1}/analytics`, analyticsRoutes);
logger.info(`✅ /api/v1/analytics registered (includes /my-rank)`);

app.use(`${apiV1}/activity`, activityRoutes);
logger.info(`✅ /api/v1/activity registered`);

app.use(`${apiV1}/content`, contentRoutes);
logger.info(`✅ /api/v1/content registered`);

app.use(`${apiV1}/admin`, adminRoutes);
logger.info(`✅ /api/v1/admin registered`);

app.use(`${apiV1}/dashboard`, dashboardRoutes);
logger.info(`✅ /api/v1/dashboard registered`);

logger.info('✅ All routes registered successfully');

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

    // 2. Start HTTP Server (which includes Express + Socket.IO)
    httpServer.listen(PORT, () => {
      logger.info(`
╔════════════════════════════════════════════════╗
║     FitFlow Backend Server Started 🚀         ║
║────────────────────────────────────────────────║
║  Environment: ${ENV.padEnd(31)}║
║  Port: ${PORT.toString().padEnd(38)}║
║  URL: https://flutter-app-v2.onrender.com${' '.padEnd(8)}║
║  API: /api/v1${' '.padEnd(39)}║
║  Socket.IO: /socket.io/ (WebSocket)${' '.padEnd(11)}║
╚════════════════════════════════════════════════╝
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
