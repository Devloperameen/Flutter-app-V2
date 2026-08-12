/**
 * ============================================
 * Create Test Post Script
 * ============================================
 * 
 * Creates test posts in the database
 * Run: node scripts/create-test-post.js
 */

require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../src/models/User');
const Post = require('../src/models/Post');
const logger = require('../src/utils/logger');

const createTestPosts = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    logger.info('✅ Connected to MongoDB');

    // Find admin user
    const admin = await User.findOne({ email: 'admin@fitflow.com' });
    
    if (!admin) {
      logger.error('❌ Admin user not found. Run seed.js first');
      await mongoose.connection.close();
      process.exit(1);
    }

    logger.info(`✅ Found admin user: ${admin.email}`);

    // Create test posts
    const testPosts = [
      {
        authorId: admin._id,
        authorName: admin.fullName || `${admin.firstName} ${admin.lastName}`,
        authorRole: 'Admin',
        content: 'Welcome to FitFlow Community! This is the first test post.',
        imageUrl: null,
        videoUrl: null,
      },
      {
        authorId: admin._id,
        authorName: admin.fullName || `${admin.firstName} ${admin.lastName}`,
        authorRole: 'Admin',
        content: 'Great workout today! Completed 500 push-ups 💪',
        imageUrl: 'https://via.placeholder.com/400x300?text=Workout',
        videoUrl: null,
      },
      {
        authorId: admin._id,
        authorName: admin.fullName || `${admin.firstName} ${admin.lastName}`,
        authorRole: 'Admin',
        content: 'Sharing my fitness journey. Day 30 of the challenge!',
        imageUrl: null,
        videoUrl: 'https://via.placeholder.com/400x300?text=Video',
      },
    ];

    const created = await Post.insertMany(testPosts);
    logger.info(`✅ Created ${created.length} test posts`);

    // Fetch and display all posts
    const allPosts = await Post.find();
    logger.info(`📊 Total posts in database: ${allPosts.length}`);
    logger.info('Posts:', allPosts.map(p => ({
      id: p._id,
      content: p.content,
      author: p.authorName,
      likes: p.likeCount,
    })));

    await mongoose.connection.close();
    logger.info('✅ Database connection closed');
    process.exit(0);
  } catch (error) {
    logger.error('❌ Failed to create posts:', error);
    process.exit(1);
  }
};

createTestPosts();
