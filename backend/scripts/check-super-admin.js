/**
 * ============================================
 * Check Super Admin Account Status
 * ============================================
 * 
 * Diagnoses why super admin login is failing
 * Run: node scripts/check-super-admin.js
 */

require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../src/models/User');
const logger = require('../src/utils/logger');
const jwt = require('jsonwebtoken');

const checkSuperAdmin = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    logger.info('✅ Connected to MongoDB');

    // Find super admin
    const superAdmin = await User.findOne({ email: 'superadmin@fitflow.com' }).select('+password');
    
    if (!superAdmin) {
      logger.error('❌ Super admin user NOT FOUND in database');
      logger.info('Creating new super admin...');
      
      const newSuperAdmin = new User({
        email: 'superadmin@fitflow.com',
        password: 'SuperAdmin@2024!Fit',
        fullName: 'Super Administrator',
        role: 'super_admin',
        isEmailVerified: true,
        isActive: true,
      });
      
      await newSuperAdmin.save();
      logger.info('✅ New super admin created');
      
      await mongoose.connection.close();
      process.exit(0);
    }

    logger.info('');
    logger.info('╔════════════════════════════════════════════════╗');
    logger.info('║     SUPER ADMIN ACCOUNT DIAGNOSTIC REPORT      ║');
    logger.info('╠════════════════════════════════════════════════╣');
    logger.info(`║ Email:              ${superAdmin.email.padEnd(33)}║`);
    logger.info(`║ Role:               ${superAdmin.role.padEnd(33)}║`);
    logger.info(`║ Active:             ${(superAdmin.isActive ? 'YES' : 'NO').padEnd(33)}║`);
    logger.info(`║ Email Verified:     ${(superAdmin.isEmailVerified ? 'YES' : 'NO').padEnd(33)}║`);
    logger.info(`║ Password Hash:      ${(superAdmin.password ? 'SET ✓' : 'MISSING ✗').padEnd(33)}║`);
    logger.info(`║ Hash Length:        ${superAdmin.password?.length || 0} chars${' '.padEnd(26)}║`);
    logger.info('║                                                ║');
    
    // Test password comparison
    logger.info('║ Password Test:                                 ║');
    const testPasswords = [
      'SuperAdmin@2024!Fit',
      'superadmin@2024!fit',
      'SuperAdmin@2024!fit',
    ];
    
    for (const testPass of testPasswords) {
      const isValid = await superAdmin.comparePassword(testPass);
      const icon = isValid ? '✓' : '✗';
      logger.info(`║   ${icon} "${testPass}"${' '.padEnd(23 - testPass.length)}║`);
    }
    
    logger.info('║                                                ║');
    logger.info('║ TEST: Generate JWT Token                       ║');
    
    const token = jwt.sign(
      { userId: superAdmin._id },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );
    
    logger.info(`║ Token (first 40):  ${token.substring(0, 40)}...║`);
    logger.info('║                                                ║');
    logger.info('║ LOGIN TEST COMMAND:                            ║');
    logger.info('║                                                ║');
    logger.info('║ Email: superadmin@fitflow.com                  ║');
    logger.info('║ Password: SuperAdmin@2024!Fit                  ║');
    logger.info('║                                                ║');
    logger.info('║ Expected Response:                             ║');
    logger.info('║ {                                              ║');
    logger.info('║   "success": true,                             ║');
    logger.info('║   "message": "Login successful",               ║');
    logger.info('║   "data": {                                    ║');
    logger.info('║     "userId": "...",                           ║');
    logger.info('║     "accessToken": "...",                      ║');
    logger.info('║     "refreshToken": "..."                      ║');
    logger.info('║   }                                            ║');
    logger.info('║ }                                              ║');
    logger.info('╚════════════════════════════════════════════════╝');

    await mongoose.connection.close();
    logger.info('✅ Database connection closed');
    process.exit(0);
  } catch (error) {
    logger.error('❌ Diagnostic failed:', error);
    process.exit(1);
  }
};

checkSuperAdmin();
