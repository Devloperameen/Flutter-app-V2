/**
 * ============================================
 * Dashboard Controller
 * ============================================
 * 
 * Handles home/dashboard screen data
 */

const User = require('../models/User');
const Habit = require('../models/Habit');
const FocusSession = require('../models/FocusSession');
const logger = require('../utils/logger');

const getDashboard = async (req, res, next) => {
  try {
    logger.info(`📊 Fetching dashboard for user: ${req.user.id}`);

    // Fetch user data (real, not mock)
    const user = await User.findById(req.user.id).select('-password');
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    // Get today's habits
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const todayHabits = await Habit.find({
      userId: req.user.id,
      archived: false,
    }).sort({ createdAt: 1 });

    // Get today's focus sessions
    const todayFocusSessions = await FocusSession.find({
      userId: req.user.id,
      createdAt: {
        $gte: today,
        $lt: tomorrow,
      },
    });

    // Calculate streak
    let streakDays = 0;
    if (todayHabits.length > 0) {
      // Get max current streak from all habits
      streakDays = Math.max(...todayHabits.map(h => h.currentStreak || 0), 0);
    }

    // Get energy level based on focus sessions
    let energyLevel = 'Low';
    const focusMinutesToday = todayFocusSessions.reduce((sum, session) => {
      return sum + (session.duration || 0);
    }, 0);

    if (focusMinutesToday >= 120) energyLevel = 'Excellent';
    else if (focusMinutesToday >= 90) energyLevel = 'High';
    else if (focusMinutesToday >= 45) energyLevel = 'Medium';
    else if (focusMinutesToday > 0) energyLevel = 'Low';

    // Get today's mission (first incomplete habit)
    const todayMission = todayHabits.find(h => !h.completedToday) || todayHabits[0];

    const missionData = todayMission
      ? {
          id: todayMission._id.toString(),
          title: todayMission.title || 'Daily Habit',
          description: `Complete ${todayMission.targetMinutes || 30} minutes`,
          isCompleted: todayMission.completedToday || false,
          actionUrl: '/habits',
        }
      : {
          id: 'default',
          title: 'Create Your First Habit',
          description: 'Start building better habits today',
          isCompleted: false,
          actionUrl: '/habits',
        };

    // Daily quote (can be hardcoded or fetched)
    const quotes = [
      { text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs' },
      { text: 'Your time is limited, so don\'t waste it living someone else\'s life.', author: 'Steve Jobs' },
      { text: 'The future belongs to those who believe in the beauty of their dreams.', author: 'Eleanor Roosevelt' },
      { text: 'It is during our darkest moments that we must focus to see the light.', author: 'Aristotle' },
      { text: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt' },
    ];
    const dailyQuote = quotes[new Date().getDate() % quotes.length];

    const dashboardData = {
      userName: user.fullName || `${user.firstName || ''} ${user.lastName || ''}`.trim() || 'User',
      userAvatar: user.avatar || null,
      userEmail: user.email,
      todayMission: missionData,
      energyLevel,
      streakDays,
      dailyQuote,
      totalHabits: todayHabits.length,
      focusMinutesToday,
      level: user.level || 1,
      xp: user.xp || 0,
    };

    logger.info('✅ Dashboard data fetched successfully');

    res.status(200).json({
      success: true,
      data: dashboardData,
    });
  } catch (error) {
    logger.error('❌ Dashboard error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch dashboard data',
      error: error.message,
    });
  }
};

module.exports = {
  getDashboard,
};
