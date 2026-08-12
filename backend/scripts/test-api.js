/**
 * ============================================
 * API Test Script
 * ============================================
 * 
 * Tests the posts endpoint with proper authentication
 * Run: node scripts/test-api.js
 */

require('dotenv').config();
const jwt = require('jsonwebtoken');
const User = require('../src/models/User');
const mongoose = require('mongoose');
const logger = require('../src/utils/logger');

const testApi = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    logger.info('✅ Connected to MongoDB');

    // Find admin user
    const admin = await User.findOne({ email: 'admin@fitflow.com' });
    
    if (!admin) {
      logger.error('❌ Admin user not found');
      await mongoose.connection.close();
      process.exit(1);
    }

    // Generate JWT token
    const token = jwt.sign(
      { userId: admin._id },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    logger.info('✅ Generated JWT token for testing');
    logger.info('');
    logger.info('╔════════════════════════════════════════════════╗');
    logger.info('║          API TEST INFORMATION                  ║');
    logger.info('╠════════════════════════════════════════════════╣');
    logger.info(`║ Backend URL: https://flutter-app-v2.onrender.com/api/v1`);
    logger.info(`║ Endpoint: GET /community/posts`);
    logger.info(`║ Auth: Bearer ${token.substring(0, 20)}...`);
    logger.info('║                                                ║');
    logger.info('║ To test:                                       ║');
    logger.info('║ 1. Use Postman or curl                         ║');
    logger.info('║ 2. Add header: Authorization: Bearer <token>   ║');
    logger.info('║ 3. Make GET request to /api/v1/community/posts║');
    logger.info('║                                                ║');
    logger.info('║ Or use curl:                                   ║');
    logger.info(`║ curl -H "Authorization: Bearer ${token.substring(0, 20)}..." \\`);
    logger.info(`║      https://flutter-app-v2.onrender.com/api/v1/community/posts`);
    logger.info('╚════════════════════════════════════════════════╝');
    logger.info('');

    // Show token (for testing)
    logger.info('Full Token for Testing:');
    logger.info(token);
    logger.info('');

    await mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    logger.error('❌ Test failed:', error);
    process.exit(1);
  }
};

testApi();
