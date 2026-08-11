/**
 * ============================================
 * Database Seed Script
 * ============================================
 * 
 * Seeds MongoDB with test data for development and testing
 * 
 * Usage: node scripts/seed.js
 */

require('dotenv').config();
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

// Import models
const User = require('../src/models/User');
const Quote = require('../src/models/Quote');
const Video = require('../src/models/Video');
const FocusSession = require('../src/models/FocusSession');
const Activity = require('../src/models/UserActivity');

// Test data
const QUOTES = [
  // Fitness quotes
  { text: 'The only bad workout is the one that didn\'t happen.', author: 'Unknown', category: 'fitness', tags: ['motivation', 'workout'] },
  { text: 'Your body can stand almost anything. It\'s your mind you have to convince.', author: 'Unknown', category: 'fitness', tags: ['mindset', 'strength'] },
  { text: 'Take care of your body. It\'s the only place you have to live.', author: 'Jim Rohn', category: 'fitness', tags: ['health', 'wellness'] },
  { text: 'Fitness is not about being better than someone else. It\'s about being better than you used to be.', author: 'Khloe Kardashian', category: 'fitness', tags: ['progress', 'self-improvement'] },
  { text: 'The difference between try and triumph is a little umph.', author: 'Marvin Phillips', category: 'fitness', tags: ['effort', 'success'] },
  { text: 'Strength doesn\'t come from what you can do. It comes from overcoming what you thought you couldn\'t.', author: 'Rikki Rogers', category: 'fitness', tags: ['strength', 'overcome'] },
  { text: 'Don\'t count the days, make the days count.', author: 'Muhammad Ali', category: 'fitness', tags: ['motivation', 'action'] },
  
  // Mindset quotes
  { text: 'Whether you think you can or think you can\'t, you\'re right.', author: 'Henry Ford', category: 'mindset', tags: ['belief', 'attitude'] },
  { text: 'The mind is everything. What you think you become.', author: 'Buddha', category: 'mindset', tags: ['thoughts', 'manifestation'] },
  { text: 'Change your thoughts and you change your world.', author: 'Norman Vincent Peale', category: 'mindset', tags: ['perspective', 'transformation'] },
  { text: 'Success is not final, failure is not fatal: it is the courage to continue that counts.', author: 'Winston Churchill', category: 'mindset', tags: ['perseverance', 'courage'] },
  { text: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt', category: 'mindset', tags: ['belief', 'confidence'] },
  { text: 'The only limit to our realization of tomorrow will be our doubts of today.', author: 'Franklin D. Roosevelt', category: 'mindset', tags: ['potential', 'doubt'] },
  { text: 'Your limitation—it\'s only your imagination.', author: 'Unknown', category: 'mindset', tags: ['limits', 'imagination'] },
  
  // Inspiration quotes
  { text: 'The future belongs to those who believe in the beauty of their dreams.', author: 'Eleanor Roosevelt', category: 'inspiration', tags: ['dreams', 'future'] },
  { text: 'It does not matter how slowly you go as long as you do not stop.', author: 'Confucius', category: 'inspiration', tags: ['persistence', 'progress'] },
  { text: 'Everything you\'ve ever wanted is on the other side of fear.', author: 'George Addair', category: 'inspiration', tags: ['fear', 'courage'] },
  { text: 'Dream big and dare to fail.', author: 'Norman Vaughan', category: 'inspiration', tags: ['dreams', 'courage'] },
  { text: 'The best time to plant a tree was 20 years ago. The second best time is now.', author: 'Chinese Proverb', category: 'inspiration', tags: ['action', 'timing'] },
  { text: 'You are never too old to set another goal or to dream a new dream.', author: 'C.S. Lewis', category: 'inspiration', tags: ['goals', 'dreams'] },
  { text: 'Success is not how high you have climbed, but how you make a positive difference to the world.', author: 'Roy T. Bennett', category: 'inspiration', tags: ['success', 'impact'] },
];

const VIDEOS = [
  // Workout videos
  { 
    title: '10 Minute Full Body Workout', 
    videoId: 'ml6cT4AZdqI',
    youtubeUrl: 'https://youtube.com/watch?v=ml6cT4AZdqI', 
    category: 'fitness-training', 
    duration: 600, 
    viewCount: 1500000, 
    thumbnailUrl: 'https://img.youtube.com/vi/ml6cT4AZdqI/maxresdefault.jpg', 
    description: 'Complete full body workout in just 10 minutes' 
  },
  { 
    title: '30 Min HIIT Cardio Workout', 
    videoId: 'gC_L9qAHVJ8',
    youtubeUrl: 'https://youtube.com/watch?v=gC_L9qAHVJ8', 
    category: 'fitness-training', 
    duration: 1800, 
    viewCount: 2000000, 
    thumbnailUrl: 'https://img.youtube.com/vi/gC_L9qAHVJ8/maxresdefault.jpg', 
    description: 'High intensity interval training for maximum calorie burn' 
  },
  { 
    title: 'Beginner Strength Training', 
    videoId: 'UBMk30rjy0o',
    youtubeUrl: 'https://youtube.com/watch?v=UBMk30rjy0o', 
    category: 'fitness-training', 
    duration: 1200, 
    viewCount: 800000, 
    thumbnailUrl: 'https://img.youtube.com/vi/UBMk30rjy0o/maxresdefault.jpg', 
    description: 'Build strength with this beginner-friendly routine' 
  },
  { 
    title: 'Core and Abs Workout', 
    videoId: 'DHD1-2P94DI',
    youtubeUrl: 'https://youtube.com/watch?v=DHD1-2P94DI', 
    category: 'fitness-training', 
    duration: 900, 
    viewCount: 1200000, 
    thumbnailUrl: 'https://img.youtube.com/vi/DHD1-2P94DI/maxresdefault.jpg', 
    description: 'Strengthen your core with targeted exercises' 
  },
  
  // Yoga/Mindfulness videos
  { 
    title: 'Morning Yoga Flow', 
    videoId: 'VaoV1PrYft4',
    youtubeUrl: 'https://youtube.com/watch?v=VaoV1PrYft4', 
    category: 'mindfulness', 
    duration: 1200, 
    viewCount: 900000, 
    thumbnailUrl: 'https://img.youtube.com/vi/VaoV1PrYft4/maxresdefault.jpg', 
    description: 'Start your day with energizing yoga flow' 
  },
  { 
    title: 'Yoga for Flexibility', 
    videoId: 'Yzm3fA2HhkQ',
    youtubeUrl: 'https://youtube.com/watch?v=Yzm3fA2HhkQ', 
    category: 'mindfulness', 
    duration: 1500, 
    viewCount: 750000, 
    thumbnailUrl: 'https://img.youtube.com/vi/Yzm3fA2HhkQ/maxresdefault.jpg', 
    description: 'Improve flexibility with gentle stretches' 
  },
  { 
    title: 'Bedtime Yoga Routine', 
    videoId: 'BiWDsfZ3zbo',
    youtubeUrl: 'https://youtube.com/watch?v=BiWDsfZ3zbo', 
    category: 'recovery', 
    duration: 1000, 
    viewCount: 600000, 
    thumbnailUrl: 'https://img.youtube.com/vi/BiWDsfZ3zbo/maxresdefault.jpg', 
    description: 'Relax and unwind before sleep' 
  },
  
  // Motivation videos
  { 
    title: '20 Min Cardio Dance Workout', 
    videoId: 'l5g8KWGh_CQ',
    youtubeUrl: 'https://youtube.com/watch?v=l5g8KWGh_CQ', 
    category: 'fitness-training', 
    duration: 1200, 
    viewCount: 1800000, 
    thumbnailUrl: 'https://img.youtube.com/vi/l5g8KWGh_CQ/maxresdefault.jpg', 
    description: 'Fun dance cardio to burn calories' 
  },
  { 
    title: 'Jump Rope Cardio Challenge', 
    videoId: 'FHaRS8Y1Gh0',
    youtubeUrl: 'https://youtube.com/watch?v=FHaRS8Y1Gh0', 
    category: 'challenge', 
    duration: 900, 
    viewCount: 500000, 
    thumbnailUrl: 'https://img.youtube.com/vi/FHaRS8Y1Gh0/maxresdefault.jpg', 
    description: 'Intense jump rope workout for cardiovascular health' 
  },
  { 
    title: 'Low Impact Cardio', 
    videoId: '3sEeVJEXTfY',
    youtubeUrl: 'https://youtube.com/watch?v=3sEeVJEXTfY', 
    category: 'fitness-training', 
    duration: 1500, 
    viewCount: 650000, 
    thumbnailUrl: 'https://img.youtube.com/vi/3sEeVJEXTfY/maxresdefault.jpg', 
    description: 'Joint-friendly cardio exercises' 
  },
];

const USERS = [
  {
    email: 'admin@fitflow.com',
    password: 'Admin123!',
    fullName: 'Admin User',
    role: 'admin',
    level: 25,
    xp: 15000,
    stats: {
      currentStreak: 45,
      longestStreak: 60,
      totalHabits: 0,
      totalCompletions: 0,
    },
  },
  {
    email: 'test@fitflow.com',
    password: 'Test123!',
    fullName: 'Test User',
    role: 'user',
    level: 8,
    xp: 2500,
    stats: {
      currentStreak: 7,
      longestStreak: 15,
      totalHabits: 0,
      totalCompletions: 0,
    },
  },
  {
    email: 'john@example.com',
    password: 'John123!',
    fullName: 'John Doe',
    role: 'user',
    level: 12,
    xp: 4800,
    stats: {
      currentStreak: 12,
      longestStreak: 20,
      totalHabits: 0,
      totalCompletions: 0,
    },
  },
];

// Achievements
const ACHIEVEMENTS = [
  { id: 'first_habit', title: 'First Habit', description: 'Complete your first habit', icon: '🔥', xpReward: 50 },
  { id: 'week_streak', title: 'Week Streak', description: 'Maintain a 7-day habit streak', icon: '⚡', xpReward: 100 },
  { id: 'habit_master', title: 'Habit Master', description: 'Complete 100 habits', icon: '🎯', xpReward: 500 },
  { id: 'focused', title: 'Focused', description: 'Complete your first focus session', icon: '⏱️', xpReward: 50 },
  { id: 'deep_work', title: 'Deep Work', description: 'Complete 10 focus sessions', icon: '🧠', xpReward: 200 },
  { id: 'consistent', title: 'Consistent', description: 'Active for 30 consecutive days', icon: '💪', xpReward: 300 },
  { id: 'level_10', title: 'Level 10', description: 'Reach level 10', icon: '⭐', xpReward: 100 },
  { id: 'achiever', title: 'Achiever', description: 'Earn 10 achievements', icon: '🏆', xpReward: 250 },
];

/**
 * Connect to MongoDB
 */
async function connectDB() {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('✅ Connected to MongoDB');
  } catch (error) {
    console.error('❌ MongoDB connection failed:', error.message);
    process.exit(1);
  }
}

/**
 * Clear existing data
 */
async function clearDatabase() {
  try {
    await User.deleteMany({});
    await Quote.deleteMany({});
    await Video.deleteMany({});
    await FocusSession.deleteMany({});
    await Activity.deleteMany({});
    console.log('✅ Database cleared');
  } catch (error) {
    console.error('❌ Failed to clear database:', error.message);
  }
}

/**
 * Seed users
 */
async function seedUsers() {
  try {
    const hashedUsers = await Promise.all(
      USERS.map(async (user) => ({
        ...user,
        password: await bcrypt.hash(user.password, 10),
        isActive: true,
        emailVerified: true,
      }))
    );

    const createdUsers = await User.insertMany(hashedUsers);
    console.log(`✅ Seeded ${createdUsers.length} users`);
    return createdUsers;
  } catch (error) {
    console.error('❌ Failed to seed users:', error.message);
    return [];
  }
}

/**
 * Seed quotes
 */
async function seedQuotes(adminUser) {
  if (!adminUser) {
    console.log('⚠️  No admin user found, skipping quotes');
    return [];
  }

  try {
    const quotes = QUOTES.map(q => ({
      text: q.text,
      author: q.author,
      category: q.category === 'fitness' ? 'fitness' : q.category === 'mindset' ? 'mindfulness' : 'motivation',
      isActive: true,
      createdBy: adminUser._id,
      displayCount: Math.floor(Math.random() * 100),
    }));

    const createdQuotes = await Quote.insertMany(quotes);
    console.log(`✅ Seeded ${createdQuotes.length} quotes`);
    return createdQuotes;
  } catch (error) {
    console.error('❌ Failed to seed quotes:', error.message);
    return [];
  }
}

/**
 * Seed videos
 */
async function seedVideos(adminUser) {
  if (!adminUser) {
    console.log('⚠️  No admin user found, skipping videos');
    return [];
  }

  try {
    const videos = VIDEOS.map(v => ({
      ...v,
      isActive: true,
      createdBy: adminUser._id,
    }));

    const createdVideos = await Video.insertMany(videos);
    console.log(`✅ Seeded ${createdVideos.length} videos`);
    return createdVideos;
  } catch (error) {
    console.error('❌ Failed to seed videos:', error.message);
    return [];
  }
}

/**
 * Seed focus sessions for a user
 */
async function seedFocusSessions(users) {
  if (!users || users.length === 0) return [];

  try {
    const testUser = users[1]; // Use test user
    const sessions = [];

    // Create sessions for the past 7 days
    for (let i = 0; i < 7; i++) {
      const date = new Date();
      date.setDate(date.getDate() - i);

      // 2-3 sessions per day
      const sessionsPerDay = Math.floor(Math.random() * 2) + 2;

      for (let j = 0; j < sessionsPerDay; j++) {
        const duration = [25, 50][Math.floor(Math.random() * 2)]; // 25 or 50 minutes
        const sessionType = duration === 25 ? '25min' : '50min';
        const startedAt = new Date(date);
        startedAt.setHours(9 + j * 3); // Spread throughout day

        const endedAt = new Date(startedAt);
        endedAt.setMinutes(endedAt.getMinutes() + duration);

        sessions.push({
          userId: testUser._id,
          sessionType,
          duration,
          startedAt,
          endedAt,
          status: 'completed',
          xpEarned: (duration * 10) + 50,
        });
      }
    }

    const createdSessions = await FocusSession.insertMany(sessions);
    console.log(`✅ Seeded ${createdSessions.length} focus sessions`);
    return createdSessions;
  } catch (error) {
    console.error('❌ Failed to seed focus sessions:', error.message);
    return [];
  }
}

/**
 * Seed activities for a user
 */
async function seedActivities(users, sessions) {
  if (!users || users.length === 0) return [];

  try {
    const testUser = users[1]; // Use test user
    const activities = [];

    // Activity for focus sessions
    sessions.forEach((session, index) => {
      activities.push({
        userId: testUser._id,
        type: 'focus-completed',
        xpEarned: session.xpEarned,
        metadata: {
          sessionId: session._id.toString(),
          duration: session.duration,
          sessionType: session.sessionType,
        },
        createdAt: session.endedAt,
      });
    });

    // Add milestone activities
    if (sessions.length >= 5) {
      activities.push({
        userId: testUser._id,
        type: 'streak-milestone',
        xpEarned: 100,
        metadata: {
          type: 'focus_streak',
          count: 5,
          description: 'Completed 5 focus sessions',
        },
        createdAt: new Date(),
      });
    }

    if (sessions.length >= 10) {
      activities.push({
        userId: testUser._id,
        type: 'level-up',
        xpEarned: 200,
        metadata: {
          newLevel: 8,
          previousLevel: 7,
        },
        createdAt: sessions[9].endedAt,
      });
    }

    const createdActivities = await Activity.insertMany(activities);
    console.log(`✅ Seeded ${createdActivities.length} activities`);
    return createdActivities;
  } catch (error) {
    console.error('❌ Failed to seed activities:', error.message);
    return [];
  }
}

/**
 * Main seed function
 */
async function seed() {
  console.log('\n🌱 Starting database seeding...\n');

  await connectDB();
  await clearDatabase();

  const users = await seedUsers();
  const adminUser = users.find(u => u.role === 'admin');
  const quotes = await seedQuotes(adminUser);
  const videos = await seedVideos(adminUser);
  const sessions = await seedFocusSessions(users);
  const activities = await seedActivities(users, sessions);

  console.log('\n📊 Seed Summary:');
  console.log(`   Users: ${users.length}`);
  console.log(`   Quotes: ${quotes.length}`);
  console.log(`   Videos: ${videos.length}`);
  console.log(`   Focus Sessions: ${sessions.length}`);
  console.log(`   Activities: ${activities.length}`);
  console.log('\n🎉 Database seeding complete!\n');

  console.log('📝 Test Credentials:');
  console.log('   Admin: admin@fitflow.com / Admin123!');
  console.log('   User:  test@fitflow.com / Test123!');
  console.log('   User:  john@example.com / John123!\n');

  await mongoose.connection.close();
  console.log('✅ Database connection closed');
  process.exit(0);
}

// Run seed
seed().catch((error) => {
  console.error('❌ Seed failed:', error);
  process.exit(1);
});
