# 🔥 FitFlow Firebase Setup - Complete Step by Step (From Zero)

**Status**: Community Chat ✅ | Everything Else: ❌ (to be created)

**Your Firebase Project**: `safe-5723a`
**Your Firebase UID**: `safe-5723a`

---

## ⚠️ IMPORTANT: No Mock Data

- **All features use REAL Firestore only**
- **No fallback mock datasources**
- **Real user names, real data, real timestamps**

---

## 📋 Collections to Create (5 Total)

### 1️⃣ `community` - Posts Collection (Top Level)

**Purpose**: User posts with images/videos

**Location**: Top-level collection
```
community/
├─ {postId1}/
├─ {postId2}/
└─ {postId3}/
```

**Create a test post with these fields**:

| Field | Type | Value |
|-------|------|-------|
| `userId` | String | `safe-5723a` |
| `userName` | String | Your name (e.g., "Sadiq Khan") |
| `userAvatar` | String | "" (empty for now) |
| `content` | String | "Hello FitFlow! This is my first post" |
| `imageUrl` | String | "" (empty - will add via app) |
| `videoUrl` | String | "" (empty - will add via app) |
| `likeCount` | Number | 0 |
| `commentCount` | Number | 0 |
| `createdAt` | Timestamp | Current time |
| `updatedAt` | Timestamp | Current time |
| `isDeleted` | Boolean | false |

**Subcollection under community/{postId}**: `comments`

| Field | Type | Value |
|-------|------|-------|
| `userId` | String | `safe-5723a` |
| `userName` | String | "Sadiq Khan" |
| `text` | String | "Great post!" |
| `createdAt` | Timestamp | Current time |

---

### 2️⃣ `users` - User Profiles (Top Level)

**Purpose**: User profile data

**Create document with ID = your Firebase UID**:
```
users/safe-5723a/
```

**Fields**:

| Field | Type | Value |
|-------|------|-------|
| `email` | String | Your email |
| `firstName` | String | "Sadiq" |
| `lastName` | String | "Khan" |
| `avatarUrl` | String | "" |
| `bio` | String | "Flutter Developer 💪" |
| `followerCount` | Number | 0 |
| `followingCount` | Number | 0 |
| `postCount` | Number | 1 |
| `createdAt` | Timestamp | Current time |
| `updatedAt` | Timestamp | Current time |
| `isOnline` | Boolean | true |
| `lastActiveDate` | Timestamp | Current time |

**Subcollections under users/{userId}**:

#### 2a. `focusSessions` (Dashboard - Focus Time Tracking)

```
users/safe-5723a/focusSessions/{sessionId}
```

| Field | Type | Value |
|-------|------|-------|
| `startedAt` | Timestamp | Yesterday at 9:00 AM |
| `endedAt` | Timestamp | Yesterday at 10:00 AM |
| `durationSeconds` | Number | 3600 |
| `status` | String | "completed" |
| `focusType` | String | "work" |
| `notes` | String | "Morning focus session" |
| `createdAt` | Timestamp | Current time |

#### 2b. `tasks` (Tasks/Habits - User Tasks)

```
users/safe-5723a/tasks/{taskId}
```

| Field | Type | Value |
|-------|------|-------|
| `title` | String | "Complete Flutter project" |
| `description` | String | "Finish FitFlow setup" |
| `priority` | String | "high" |
| `status` | String | "in_progress" |
| `completed` | Boolean | false |
| `completedAt` | Timestamp | null |
| `dueDate` | Timestamp | Next Friday |
| `category` | String | "work" |
| `createdAt` | Timestamp | Current time |
| `updatedAt` | Timestamp | Current time |

#### 2c. `missions` (Dashboard - Daily Missions)

```
users/safe-5723a/missions/{missionId}
```

| Field | Type | Value |
|-------|------|-------|
| `title` | String | "Complete 3 focus sessions" |
| `description` | String | "Stay focused and productive" |
| `type` | String | "daily" |
| `targetValue` | Number | 3 |
| `currentValue` | Number | 1 |
| `completed` | Boolean | false |
| `reward` | Number | 100 |
| `createdDate` | Timestamp | Today |
| `completedDate` | Timestamp | null |
| `expiryDate` | Timestamp | Tomorrow |

---

### 3️⃣ `stories` - 24-Hour Stories (Top Level)

**Purpose**: Stories that expire after 24 hours

**Create a test story**:

```
stories/{storyId}
```

| Field | Type | Value |
|-------|------|-------|
| `userId` | String | `safe-5723a` |
| `userName` | String | "Sadiq Khan" |
| `userAvatar` | String | "" |
| `imageUrl` | String | "" (will add via app) |
| `videoUrl` | String | "" |
| `caption` | String | "My gym session today! 💪" |
| `createdAt` | Timestamp | Current time |
| `expiresAt` | Timestamp | Tomorrow |
| `viewCount` | Number | 0 |

**Subcollection**: `viewers`

```
stories/{storyId}/viewers/{userId}
```

| Field | Type | Value |
|-------|------|-------|
| `viewedAt` | Timestamp | Current time |

---

### 4️⃣ `habits` - Habit Tracking (Top Level)

**Purpose**: User's daily habits (sleep, water, exercise, etc.)

**Create a test habit**:

```
habits/{habitId}
```

| Field | Type | Value |
|-------|------|-------|
| `userId` | String | `safe-5723a` |
| `name` | String | "Morning Workout" |
| `description` | String | "30 min exercise" |
| `frequency` | String | "daily" |
| `color` | Number | 4294198070 |
| `icon` | String | "fitness_center" |
| `streak` | Number | 5 |
| `maxStreak` | Number | 5 |
| `totalCount` | Number | 15 |
| `lastCompletedDate` | Timestamp | Today |
| `isActive` | Boolean | true |
| `createdAt` | Timestamp | Current time |
| `updatedAt` | Timestamp | Current time |

---

### 5️⃣ `habitLogs` - Habit Completion Logs (Top Level)

**Purpose**: Track when habits are completed

**Create a test log**:

```
habitLogs/{logId}
```

| Field | Type | Value |
|-------|------|-------|
| `habitId` | String | ID from habits collection |
| `userId` | String | `safe-5723a` |
| `completedDate` | Timestamp | Today |
| `notes` | String | "Great workout today!" |
| `mood` | String | "energized" |
| `duration` | Number | 30 |
| `createdAt` | Timestamp | Current time |

---

## 🔐 Firestore Security Rules

**Replace ALL your security rules with this**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ============ HELPER FUNCTIONS ============
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // ============ COMMUNITY POSTS ============
    match /community/{postId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && 
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.content.size() > 0 &&
        request.resource.data.content.size() <= 5000;
      allow update: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      allow delete: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      
      // ============ POST COMMENTS ============
      match /comments/{commentId} {
        allow read: if isSignedIn();
        allow create: if isSignedIn() &&
          request.resource.data.userId == request.auth.uid &&
          request.resource.data.text.size() > 0 &&
          request.resource.data.text.size() <= 1000;
        allow update: if isSignedIn() && 
          resource.data.userId == request.auth.uid;
        allow delete: if isSignedIn() && 
          resource.data.userId == request.auth.uid;
      }
    }
    
    // ============ COMMUNITY CHAT (ALREADY WORKING) ============
    match /community_chat/main/messages/{messageId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() &&
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.message.size() > 0 &&
        request.resource.data.message.size() <= 5000;
      allow delete: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      allow update: if false;
    }
    
    // ============ STORIES (24-HOUR) ============
    match /stories/{storyId} {
      allow read: if isSignedIn() && 
        resource.data.expiresAt > request.time;
      allow create: if isSignedIn() && 
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.imageUrl != null;
      allow update: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      allow delete: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      
      // Story viewers tracking
      match /viewers/{viewerId} {
        allow read: if isSignedIn() && 
          resource.data.userId == request.auth.uid;
        allow create: if isSignedIn();
        allow delete: if false;
      }
    }
    
    // ============ USER PROFILES ============
    match /users/{userId} {
      allow read: if isSignedIn();
      allow update: if isOwner(userId);
      allow create: if false;
      allow delete: if false;
      
      // ============ FOCUS SESSIONS ============
      match /focusSessions/{sessionId} {
        allow read: if isOwner(userId);
        allow create: if isOwner(userId);
        allow update: if isOwner(userId);
        allow delete: if isOwner(userId);
      }
      
      // ============ TASKS ============
      match /tasks/{taskId} {
        allow read: if isOwner(userId);
        allow create: if isOwner(userId);
        allow update: if isOwner(userId);
        allow delete: if isOwner(userId);
      }
      
      // ============ MISSIONS ============
      match /missions/{missionId} {
        allow read: if isOwner(userId);
        allow create: if isOwner(userId);
        allow update: if isOwner(userId);
        allow delete: if isOwner(userId);
      }
    }
    
    // ============ HABITS ============
    match /habits/{habitId} {
      allow read: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      allow create: if isSignedIn() && 
        request.resource.data.userId == request.auth.uid;
      allow update: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      allow delete: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
    }
    
    // ============ HABIT LOGS ============
    match /habitLogs/{logId} {
      allow read: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      allow create: if isSignedIn() && 
        request.resource.data.userId == request.auth.uid;
      allow update: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
      allow delete: if isSignedIn() && 
        resource.data.userId == request.auth.uid;
    }
    
    // ============ LIKES INDEX (PERFORMANCE) ============
    match /posts_likes/{docId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && 
        request.resource.data.userId == request.auth.uid;
      allow delete: if isSignedIn() && 
        request.resource.data.userId == request.auth.uid;
      allow update: if false;
    }
  }
}
```

---

## 🚀 Step-by-Step Setup Instructions

### STEP 1: Open Firebase Console

1. Go to: https://console.firebase.google.com/project/safe-5723a
2. Select **Firestore Database** from left menu
3. Click **Data** tab

### STEP 2: Create `community` Collection

1. Click **+ Create Collection**
2. Collection ID: `community`
3. Click **Next**
4. Click **Auto ID** to create first document
5. Add fields:
   - `userId` = String = `safe-5723a`
   - `userName` = String = (your name)
   - `userAvatar` = String = ``
   - `content` = String = `Hello FitFlow!`
   - `imageUrl` = String = ``
   - `videoUrl` = String = ``
   - `likeCount` = Number = `0`
   - `commentCount` = Number = `0`
   - `createdAt` = Timestamp = (current time)
   - `updatedAt` = Timestamp = (current time)
   - `isDeleted` = Boolean = `false`
6. Click **Save**

**Add a comment subcollection**:
1. In the document you just created, scroll down
2. Click **+ Add subcollection**
3. Name: `comments`
4. Click **Auto ID**
5. Add one comment:
   - `userId` = String = `safe-5723a`
   - `userName` = String = (your name)
   - `text` = String = `Great start!`
   - `createdAt` = Timestamp = (current time)
6. Click **Save**

### STEP 3: Create `users` Collection

1. Click **+ Create Collection**
2. Collection ID: `users`
3. Click **Next**
4. Document ID: `safe-5723a` (your Firebase UID)
5. Add fields:
   - `email` = String = (your email)
   - `firstName` = String = `Sadiq`
   - `lastName` = String = `Khan`
   - `avatarUrl` = String = ``
   - `bio` = String = `Flutter Developer`
   - `followerCount` = Number = `0`
   - `followingCount` = Number = `0`
   - `postCount` = Number = `1`
   - `createdAt` = Timestamp = (current time)
   - `updatedAt` = Timestamp = (current time)
   - `isOnline` = Boolean = `true`
   - `lastActiveDate` = Timestamp = (current time)
6. Click **Save**

**Add focusSessions subcollection**:
1. Click **+ Add subcollection**
2. Name: `focusSessions`
3. Click **Auto ID**
4. Add fields:
   - `startedAt` = Timestamp = (any past time)
   - `endedAt` = Timestamp = (1 hour later)
   - `durationSeconds` = Number = `3600`
   - `status` = String = `completed`
   - `focusType` = String = `work`
   - `notes` = String = ``
   - `createdAt` = Timestamp = (current time)
5. Click **Save**

**Add tasks subcollection**:
1. Back at users/safe-5723a, click **+ Add subcollection**
2. Name: `tasks`
3. Click **Auto ID**
4. Add fields:
   - `title` = String = `Complete FitFlow`
   - `description` = String = ``
   - `priority` = String = `high`
   - `status` = String = `in_progress`
   - `completed` = Boolean = `false`
   - `completedAt` = Timestamp = (null - leave empty)
   - `dueDate` = Timestamp = (next week)
   - `category` = String = `work`
   - `createdAt` = Timestamp = (current time)
   - `updatedAt` = Timestamp = (current time)
5. Click **Save**

**Add missions subcollection**:
1. Back at users/safe-5723a, click **+ Add subcollection**
2. Name: `missions`
3. Click **Auto ID**
4. Add fields:
   - `title` = String = `Daily Challenge`
   - `description` = String = `Complete 3 focus sessions`
   - `type` = String = `daily`
   - `targetValue` = Number = `3`
   - `currentValue` = Number = `1`
   - `completed` = Boolean = `false`
   - `reward` = Number = `100`
   - `createdDate` = Timestamp = (today)
   - `completedDate` = Timestamp = (null)
   - `expiryDate` = Timestamp = (tomorrow)
5. Click **Save**

### STEP 4: Create `stories` Collection

1. Click **+ Create Collection**
2. Collection ID: `stories`
3. Click **Next**
4. Click **Auto ID**
5. Add fields:
   - `userId` = String = `safe-5723a`
   - `userName` = String = (your name)
   - `userAvatar` = String = ``
   - `imageUrl` = String = ``
   - `videoUrl` = String = ``
   - `caption` = String = `My story`
   - `createdAt` = Timestamp = (current time)
   - `expiresAt` = Timestamp = (tomorrow)
   - `viewCount` = Number = `0`
6. Click **Save**

**Add viewers subcollection**:
1. Click **+ Add subcollection**
2. Name: `viewers`
3. Click **Auto ID**
4. Add one field:
   - `viewedAt` = Timestamp = (current time)
5. Click **Save**

### STEP 5: Create `habits` Collection (Top Level)

1. Click **+ Create Collection**
2. Collection ID: `habits`
3. Click **Next**
4. Click **Auto ID**
5. Add fields:
   - `userId` = String = `safe-5723a`
   - `name` = String = `Morning Workout`
   - `description` = String = `30 min exercise`
   - `frequency` = String = `daily`
   - `color` = Number = `4294198070`
   - `icon` = String = `fitness_center`
   - `streak` = Number = `5`
   - `maxStreak` = Number = `5`
   - `totalCount` = Number = `15`
   - `lastCompletedDate` = Timestamp = (today)
   - `isActive` = Boolean = `true`
   - `createdAt` = Timestamp = (current time)
   - `updatedAt` = Timestamp = (current time)
6. Click **Save**

### STEP 6: Create `habitLogs` Collection (Top Level)

1. Click **+ Create Collection**
2. Collection ID: `habitLogs`
3. Click **Next**
4. Click **Auto ID**
5. Add fields:
   - `habitId` = String = (copy ID from habits collection)
   - `userId` = String = `safe-5723a`
   - `completedDate` = Timestamp = (today)
   - `notes` = String = `Great session!`
   - `mood` = String = `energized`
   - `duration` = Number = `30`
   - `createdAt` = Timestamp = (current time)
6. Click **Save**

### STEP 7: Create `posts_likes` Collection (Performance Index)

1. Click **+ Create Collection**
2. Collection ID: `posts_likes`
3. Click **Next**
4. Click **Auto ID**
5. Add fields:
   - `userId` = String = `safe-5723a`
   - `postId` = String = (ID from community collection)
   - `createdAt` = Timestamp = (current time)
6. Click **Save**

### STEP 8: Update Firestore Security Rules

1. Go to **Firestore Database** → **Rules** tab
2. Delete ALL existing rules
3. Paste the complete rules from section above
4. Click **Publish**

### STEP 9: Verify in Flutter

1. In terminal:
```bash
cd ~/FlutterProjects/fitflow_gym
flutter clean
flutter pub get
flutter run
```

2. Check:
   - ✅ Community chat works (already confirmed)
   - ✅ Posts tab shows your post
   - ✅ Can add comments
   - ✅ Dashboard shows focus sessions, tasks, missions
   - ✅ Habits tab shows your habit
   - ✅ Profile shows your user data
   - ✅ Stories tab shows your story

---

## ✅ All Collections Created

```
✅ community (Posts)
✅ community_chat/main/messages (Chat - Already Working)
✅ stories (Stories)
✅ users (Profiles + focusSessions + tasks + missions)
✅ habits (Habits)
✅ habitLogs (Habit Logs)
✅ posts_likes (Like Index)
```

**Total: 8 Collections**

---

## 🎯 Next: Code Updates

After creating all collections, I'll update:
1. **Remove ALL mock datasources** ✅ (already done)
2. **Verify field mapping** (posts use `content`, not `message`)
3. **Ensure real names** (from Firestore, not hardcoded)
4. **Real timestamps** (from Firestore)
5. **Real avatar URLs** (from Firestore)

---

## ⚠️ Testing Notes

- **Real data only**: No dummy "User 1, 2, 3"
- **Real user ID**: `safe-5723a` (your Firebase UID)
- **Real names**: From the `users` collection
- **Real timestamps**: From Firestore timestamps
- **No mock fallback**: All features fail gracefully if Firestore isn't ready

**Status**: Ready for manual Firebase setup! 🚀

