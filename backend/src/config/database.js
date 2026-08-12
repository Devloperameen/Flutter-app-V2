/**
 * ============================================
 * MongoDB Database Configuration
 * ============================================
 * 
 * This module handles all database-related setup:
 * - Connection to MongoDB
 * - Connection pooling
 * - Error handling
 * - Index creation
 */

const mongoose = require('mongoose');
const logger = require('../utils/logger');

/**
 * Connect to MongoDB
 * 
 * Handles:
 * - Connection string from environment
 * - Retry logic
 * - Event listeners for connection lifecycle
 */
const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/fitflow';

    // Apply global plugin to transform _id to id and remove __v
    mongoose.plugin((schema) => {
      schema.set('toJSON', {
        virtuals: true,
        versionKey: false,
        transform: (doc, ret) => {
          ret.id = ret._id;
          delete ret._id;
        }
      });
    });

    const connection = await mongoose.connect(mongoURI, {
      // Modern MongoDB driver options
      useNewUrlParser: true,
      useUnifiedTopology: true,
      
      // Connection pooling
      maxPoolSize: 10,
      minPoolSize: 5,
      
      // Timeout settings
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    });

    logger.info(`✅ Database connected: ${connection.connection.host}`);
    
    // Log connection events
    mongoose.connection.on('disconnected', () => {
      logger.warn('⚠️ MongoDB disconnected');
    });

    mongoose.connection.on('error', (error) => {
      logger.error('❌ MongoDB connection error:', error);
    });

    return connection;
  } catch (error) {
    logger.error('❌ Failed to connect to MongoDB:', error);
    throw error;
  }
};

/**
 * Close database connection
 * Useful for graceful shutdown
 */
const closeDB = async () => {
  try {
    await mongoose.connection.close();
    logger.info('✅ Database connection closed');
  } catch (error) {
    logger.error('❌ Error closing database:', error);
    throw error;
  }
};

/**
 * Get mongoose connection instance
 */
const getConnection = () => mongoose.connection;

module.exports = {
  connectDB,
  closeDB,
  getConnection,
  mongoose,
};
