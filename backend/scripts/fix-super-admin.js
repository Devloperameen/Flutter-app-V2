/**
 * ============================================
 * Fix Super Admin Credentials Script
 * ============================================
 * 
 * Resets or creates super admin account
 * Run: node scripts/fix-super-admin.js
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

const fixSuperAdmin = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    logger.info('✅ Connected to MongoDB');

    // 1. Try to find existing super admin
    let superAdmin = await User.findOne({ email: SUPER_ADMIN_CREDENTIALS.email });

    if (superAdmin) {
      logger.info('⚠️ Super Admin exists, updating password...');
      // Update password
      superAdmin.password = SUPER_ADMIN_CREDENTIALS.password;
      superAdmin.isActive = true;
      superAdmin.isEmailVerified = true;
      await superAdmin.save();
      logger.info('✅ Super Admin password updated');
    } else {
      logger.info('Creating new Super Admin user...');
      // Create new super admin
      superAdmin = await User.create({
        email: SUPER_ADMIN_CREDENTIALS.email,
        password: SUPER_ADMIN_CREDENTIALS.password,
        firstName: 'Super',
        lastName: 'Admin',
        fullName: SUPER_ADMIN_CREDENTIALS.fullName,
        role: 'super_admin',
        isEmailVerified: true,
        isActive: true,
      });
      logger.info('✅ Created new Super Admin user');
    }

    logger.info('');
    logger.info('╔════════════════════════════════════════════════╗');
    logger.info('║       SUPER ADMIN CREDENTIALS (FIXED)          ║');
    logger.info('╠════════════════════════════════════════════════╣');
    logger.info(`║  Email:    ${SUPER_ADMIN_CREDENTIALS.email.padEnd(37)}║`);
    logger.info(`║  Password: ${SUPER_ADMIN_CREDENTIALS.password.padEnd(37)}║`);
    logger.info('║  Role:     super_admin                         ║');
    logger.info('║  Status:   Active                              ║');
    logger.info('╚════════════════════════════════════════════════╝');
    logger.info('');

    await mongoose.connection.close();
    logger.info('✅ Database connection closed');
    process.exit(0);
  } catch (error) {
    logger.error('❌ Fix failed:', error);
    process.exit(1);
  }
};

fixSuperAdmin();
