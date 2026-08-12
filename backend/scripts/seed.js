/**
 * ============================================
 * Database Seeding Script
 * ============================================
 * 
 * Creates initial admin users and test data
 * Run: node scripts/seed.js
 */

require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../src/models/User');
const logger = require('../src/utils/logger');

const SUPER_ADMIN_CREDENTIALS = {
  email: 'superadmin@fitflow.com',
  password: 'SuperAdmin@2024!Fit',
  fullName: 'Super Administrator',
};

const ADMIN_CREDENTIALS = {
  email: 'admin@fitflow.com',
  password: 'Admin@2024!Gym',
  fullName: 'Administrator',
};

const seedDatabase = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    logger.info('✅ Connected to MongoDB');

    // 1. Check and create Super Admin
    let superAdmin = await User.findOne({ email: SUPER_ADMIN_CREDENTIALS.email });
    
    if (!superAdmin) {
      superAdmin = await User.create({
        email: SUPER_ADMIN_CREDENTIALS.email,
        password: SUPER_ADMIN_CREDENTIALS.password,
        fullName: SUPER_ADMIN_CREDENTIALS.fullName,
        role: 'super_admin',
        isEmailVerified: true,
        isActive: true,
      });
      logger.info('✅ Created Super Admin user');
      logger.info(`📧 Email: ${SUPER_ADMIN_CREDENTIALS.email}`);
      logger.info(`🔑 Password: ${SUPER_ADMIN_CREDENTIALS.password}`);
    } else {
      logger.info('⚠️ Super Admin already exists');
    }

    // 2. Check and create Admin
    let admin = await User.findOne({ email: ADMIN_CREDENTIALS.email });
    
    if (!admin) {
      admin = await User.create({
        email: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
        fullName: ADMIN_CREDENTIALS.fullName,
        role: 'admin',
        isEmailVerified: true,
        isActive: true,
      });
      logger.info('✅ Created Admin user');
      logger.info(`📧 Email: ${ADMIN_CREDENTIALS.email}`);
      logger.info(`🔑 Password: ${ADMIN_CREDENTIALS.password}`);
    } else {
      logger.info('⚠️ Admin already exists');
    }

    logger.info('');
    logger.info('╔════════════════════════════════════════════════╗');
    logger.info('║          SEED COMPLETED SUCCESSFULLY           ║');
    logger.info('╠════════════════════════════════════════════════╣');
    logger.info('║  SUPER ADMIN (Full System Control)             ║');
    logger.info(`║  Email:    ${SUPER_ADMIN_CREDENTIALS.email.padEnd(37)}║`);
    logger.info(`║  Password: ${SUPER_ADMIN_CREDENTIALS.password.padEnd(37)}║`);
    logger.info('║                                                ║');
    logger.info('║  ADMIN (Content Moderation)                    ║');
    logger.info(`║  Email:    ${ADMIN_CREDENTIALS.email.padEnd(41)}║`);
    logger.info(`║  Password: ${ADMIN_CREDENTIALS.password.padEnd(41)}║`);
    logger.info('╚════════════════════════════════════════════════╝');
    logger.info('');
    logger.info('ℹ️  Store these credentials securely.');
    logger.info('ℹ️  Use super admin account for full app management.');

    await mongoose.connection.close();
    logger.info('✅ Database connection closed');
    process.exit(0);
  } catch (error) {
    logger.error('❌ Seed failed:', error);
    process.exit(1);
  }
};

seedDatabase();
