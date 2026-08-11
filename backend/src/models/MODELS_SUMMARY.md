# Backend Models Summary

All missing backend models have been successfully created in `/backend/src/models/`. This document provides an overview of each model, its purpose, and key methods.

---

## 1. FocusSession.js

**Purpose:** Track focus/deep work sessions (Pomodoro-style)

### Schema Fields
- `userId` - Reference to user
- `sessionType` - Duration template ('25min', '50min', 'custom')
- `duration` - Actual duration in minutes (must be > 0)
- `startedAt` - Session start timestamp
- `completedAt` - Session completion timestamp
- `xpEarned` - XP points awarded
- `status` - Session state ('active', 'completed', 'abandoned')
- `notes` - Optional session notes

### Key Methods
- `calculateXP()` - Calculate XP based on duration (10 XP/min + 50 bonus if completed)
- `getSessionStats()` - Get session statistics including elapsed time, XP/minute ratio
- `markCompleted()` - Mark session as complete and calculate XP
- `markAbandoned()` - Mark session as abandoned (0 XP)

### Key Statics
- `getUserActiveSession(userId)` - Get user's current active session
- `getUserCompletedSessions(userId, limit)` - Get completed sessions
- `getDailyStats(userId)` - Today's session metrics
- `getWeeklyStats(userId)` - Weekly session metrics

### Indexes
- `userId + completedAt` - Get user's sessions sorted by date
- `status + completedAt` - Get sessions by status
- `userId + status` - Get active sessions quickly

---

## 2. UserActivity.js

**Purpose:** Track all user achievements for activity feed

### Schema Fields
- `userId` - Reference to user
- `type` - Activity type ('habit-completion', 'focus-completed', 'mission-done', 'activity-shared', 'streak-milestone', 'level-up')
- `habitId` - Reference to habit (optional)
- `xpEarned` - XP points for this activity
- `streakInfo` - Streak data (currentStreak, longestStreak, milestone)
- `metadata` - Contextual data (title, emoji, duration, etc.)

### Key Statics
- `getRecentActivity(userId, limit)` - Get user's activity feed
- `getTodayActivity(userId)` - Get all activities created today
- `getActivitiesByType(userId, type, limit)` - Filter by type
- `getActivitySummary(userId)` - Count activities by type
- `getTodayXP(userId)` - Total XP earned today
- `createHabitCompletion(data)` - Create habit completion activity
- `createFocusCompleted(data)` - Create focus session activity
- `createStreakMilestone(data)` - Create streak achievement
- `createLevelUp(data)` - Create level up notification

### Indexes
- `userId + createdAt` - Activity feed
- `type + createdAt` - Activities by type
- `habitId + createdAt` - Habit-related activities

---

## 3. UserXP.js

**Purpose:** Central XP and level tracking per user

### Schema Fields
- `userId` - Reference to user (unique)
- `totalXP` - Cumulative XP across all time
- `currentLevel` - Current level (1-100)
- `xpForNextLevel` - XP needed to reach next level
- `xpGainedToday` - XP earned in current day
- `lastXPUpdateDate` - Last time XP was updated
- `levelHistory` - Array of level progression records
- `achievements` - Badge tracking (firstCompletion, firstFocusSession, level5, level10, etc.)

### Key Methods
- `addXP(amount)` - Add XP and handle level progression
- `calculateLevel()` - Calculate level from total XP (exponential scaling: 1.3x per level)
- `getXPProgress()` - Get detailed progress to next level
- `getLeaderboardRank()` - Get user's ranking

### Key Statics
- `getOrCreate(userId)` - Get or create XP record
- `getLeaderboard(limit)` - Top users by level/XP
- `getTopUsersByXPGained(days, limit)` - Top users in timeframe
- `getUserRank(userId)` - Get user's leaderboard rank

### Level Scaling
- Level 1: 0 XP
- Level 2: 1,000 XP
- Level 3: 2,300 XP
- Each level requires 30% more XP than previous

### Indexes
- `userId` - Get user's XP
- `currentLevel + totalXP` - Leaderboard queries

---

## 4. Quote.js

**Purpose:** Motivational quotes for dashboard content management

### Schema Fields
- `text` - Quote text (10-500 characters)
- `author` - Quote author/attribution
- `isActive` - Whether quote is in rotation
- `createdBy` - Admin who added the quote (userId)
- `category` - Quote category (motivation, fitness, productivity, mindfulness, discipline, success, health, other)
- `displayCount` - Times shown to users
- `tags` - Search tags

### Key Methods
- `recordDisplay()` - Increment display count

### Key Statics
- `getRandomQuote(category)` - Get random active quote
- `getQuotesByCategory(category, limit)` - Get quotes by category
- `getMostDisplayed(limit)` - Most popular quotes
- `getRecentByAdmin(adminId, limit)` - Recent quotes by admin
- `getTodayQuote()` - Consistent quote for all users today
- `getStats()` - Quote statistics
- `search(searchTerm, limit)` - Search quotes

### Indexes
- `isActive + category` - Get active quotes
- `createdBy` - Admin's quotes
- `category` - Category filtering

---

## 5. Video.js

**Purpose:** YouTube videos for dashboard content management

### Schema Fields
- `title` - Video title (5-200 characters)
- `description` - Video description
- `youtubeUrl` - Full YouTube URL (validated)
- `videoId` - Extracted YouTube video ID (11 chars)
- `category` - Video category (motivation, fitness-training, productivity, nutrition, mindfulness, recovery, challenge, education, other)
- `createdBy` - Admin who added the video
- `isActive` - Whether video is in rotation
- `views` - Times shown to users
- `likes` - User likes count
- `duration` - Video length in seconds
- `thumbnail` - Generated thumbnail URL
- `tags` - Search tags

### Key Methods
- `extractVideoId()` - Extract ID from various YouTube URL formats
- `incrementViews()` - Track when video is displayed
- `incrementLikes()` - Track likes
- `getEmbedUrl()` - Get iframe embed URL
- `getStats()` - Video statistics

### Key Statics
- `getRandomVideo(category)` - Get random active video
- `getVideosByCategory(category, limit)` - Videos by category
- `getMostViewed(limit)` - Most viewed videos
- `getTrending(limit)` - Recent high-engagement videos
- `getRecentByAdmin(adminId, limit)` - Recent videos by admin
- `getMostEngaging(limit, minViews)` - Highest engagement rate
- `getStats()` - Video statistics
- `search(searchTerm, limit)` - Search videos

### Indexes
- `isActive + category` - Get active videos
- `createdBy` - Admin's videos
- `isActive + views` - Popular videos

---

## 6. Report.js

**Purpose:** Community content reports and moderation

### Schema Fields
- `reporterId` - User who filed report (userId)
- `targetId` - ID of reported content/user
- `targetType` - Type ('post', 'message', 'user', 'comment')
- `reason` - Report reason (inappropriate-content, harassment, spam, misinformation, self-harm-content, violent-content, sexual-content, hate-speech, copyright-violation, scam-fraud, other)
- `description` - Report description
- `status` - Status ('pending', 'under-review', 'resolved', 'dismissed', 'escalated')
- `priority` - Priority ('low', 'medium', 'high', 'critical')
- `moderatorNotes` - Notes from reviewer
- `resolvedBy` - Admin who resolved report
- `resolutionAction` - Action taken (content-removed, user-warned, user-suspended, user-banned, no-action)
- `evidence` - URLs to screenshots/evidence
- `isDuplicate` - Whether this duplicates another report
- `duplicateOf` - Reference to original report

### Key Methods
- `getTimeSince()` - Human-readable time since filing
- `assignToModerator(moderatorId)` - Assign to reviewer
- `resolve(action, moderatorId, notes)` - Resolve with action
- `dismiss(moderatorId, notes)` - Dismiss without action
- `escalate(reason)` - Escalate to higher priority
- `markAsDuplicate(duplicateReportId)` - Mark as duplicate

### Key Statics
- `getModerationQueue(limit)` - Pending reports for review
- `getReportsForTarget(targetId, targetType)` - Reports about content
- `getReportsAboutUser(userId)` - Reports about user
- `getStats()` - Report statistics
- `findDuplicates(targetId, targetType)` - Find duplicate reports
- `getReportsByReason(reason, status, limit)` - Filter by reason
- `getUnreviewed(limit)` - Unreviewed reports

### Indexes
- `status + createdAt` - Moderation queue
- `targetId + targetType` - Reports about content
- `reporterId` - User's reports
- `status + priority + createdAt` - Queue prioritization

---

## Integration Guide

### Database Connection
All models use Mongoose and require MongoDB connection:

```javascript
const mongoose = require('mongoose');

// Models must be registered after Mongoose connection
const FocusSession = require('./models/FocusSession');
const UserActivity = require('./models/UserActivity');
const UserXP = require('./models/UserXP');
const Quote = require('./models/Quote');
const Video = require('./models/Video');
const Report = require('./models/Report');
```

### Common Patterns

#### Adding XP
```javascript
// Get or create user XP record
const userXP = await UserXP.getOrCreate(userId);

// Add XP from habit completion
const result = userXP.addXP(25);
if (result.leveledUp) {
  // Create level up activity
  await UserActivity.createLevelUp({
    userId,
    newLevel: result.newLevel,
  });
}
await userXP.save();
```

#### Creating Activities
```javascript
// Create habit completion activity
await UserActivity.createHabitCompletion({
  userId,
  habitId,
  habitTitle: 'Morning Run',
  habitEmoji: '🏃',
  xpEarned: 25,
});
```

#### Getting Leaderboard
```javascript
const topUsers = await UserXP.getLeaderboard(10);
```

#### Managing Reports
```javascript
// Get moderation queue
const queue = await Report.getModerationQueue(20);

// Resolve a report
await report.resolve('content-removed', moderatorId, 'Violated policy');
```

---

## Validation & Constraints

All models include comprehensive validation:

- **Required fields:** Validated at schema level
- **String lengths:** Min/max constraints enforced
- **Enum values:** Only valid options allowed
- **Status transitions:** Pre-save hooks validate state changes
- **References:** Foreign keys validate related documents exist
- **Data types:** Automatic type coercion with validation

---

## Performance Considerations

### Indexes
All models include indexes for common queries:
- User-specific queries (userId + timestamp)
- Status filtering (status + timestamp)
- Leaderboard queries (level/XP descending)
- Admin content management (createdBy)

### Query Optimization
- Use `.select()` to limit returned fields
- Use `.lean()` for read-only queries
- Batch operations when possible
- Cache leaderboard data if high traffic

### Scaling Tips
1. Archive old reports after resolution (30 days)
2. Aggregate statistics periodically instead of real-time
3. Consider denormalizing frequently-accessed data
4. Use pagination for large result sets

---

## Testing

All models have been validated for:
- ✓ Syntax correctness
- ✓ Schema validation
- ✓ Pre-save hooks
- ✓ Method signatures
- ✓ Index definitions
- ✓ Enum constraints
