# 🔥 Complete Firestore Collections Setup

**Goal**: Set up ALL collections needed for FitFlow (Community, Dashboard, Habits, Tasks, Missions)

---

## ✅ Collections Already Created

```
✅ community (Posts)
✅ community_chat/main/messages (Chat)
✅ stories (Stories)
✅ users (Profiles)
✅ posts_likes (Index)
```

---

## 📋 NEW Collections to Create

### Collection 1: `focusSessions` (Dashboard)

**Under**: `users/{userId}/focusSessions`

Create one example:
```
Collection: users
Document: safe-5723a (your UID)
Subcollection: focusSessions
Document: Auto ID

Fields:
┌─ startedAt ............... timestamp (current time)
├─ endedAt ................. timestamp (1 hour later)
├─ durationSeconds ......... number (3600)
├─ status .................. string ("completed")
├─ focusType ............... string ("work")
├─ notes ................... string ("")
└─ createdAt ............... timestamp (current time)
```

---

### Collection 2: `tasks` (Dashboard/Habits)

**Under**: `users/{userId}/tasks`

Create one example:
```
Collection: users
Document: safe-5723a
Subcollection: tasks
Document: Auto ID

Fields:
┌─ title ................... string ("Complete project")
├─ description ............. string ("")
├─ priority ................ string ("high")
├─ status .................. string ("pending")
├─ completed ............... boolean (false)
├─ completedAt ............. timestamp (null or set to today)
├─ dueDate ................. timestamp (tomorrow)
├─ category ................ string ("work")
├─ createdAt ............... timestamp (current time)
└─ updatedAt ............... timestamp (current time)
```

---

### Collection 3: `missions` (Dashboard)

**Under**: `users/{userId}/missions`

Create one example:
```
Collection: users
Document: safe-5723a
Subcollection: missions
Document: Auto ID

Fields:
┌─ title ................... string ("Daily Challenge")
├─ description ............. string ("Complete 3 focus sessions")
├─ type .................... string ("daily")
├─ targetValue ............. number (3)
├─ currentValue ............. number (1)
├─ completed ............... boolean (false)
├─ reward .................. number (100)
├─ createdDate ............. timestamp (current time)
├─ completedDate ........... timestamp (null)
└─ expiryDate .............. timestamp (tomorrow)
```

---

### Collection 4: `habits` (Habits feature)

**Top-level collection**

Create one example:
```
Collection: habits
Document: Auto ID

Fields:
┌─ userId .................. string (safe-5723a)
├─ name .................... string ("Morning Workout")
├─ description ............. string ("30 min exercise")
├─ frequency ............... string ("daily")
├─ color ................... number (4294198070)
├─ icon .................... string ("fitness_center")
├─ streak .................. number (5)
├─ maxStreak ............... number (5)
├─ totalCount .............. number (15)
├─ lastCompletedDate ....... timestamp (today)
├─ isActive ................ boolean (true)
├─ createdAt ............... timestamp (current time)
└─ updatedAt ............... timestamp (current time)
```

---

### Collection 5: `habitLogs` (Habit tracking)

**Top-level collection**

Create one example:
```
Collection: habitLogs
Document: Auto ID

Fields:
┌─ habitId ................. string (from habits collection)
├─ userId .................. string (safe-5723a)
├─ completedDate ........... timestamp (today)
├─ notes ................... string ("")
├─ mood .................... string ("good")
├─ duration ................ number (30)
└─ createdAt ............... timestamp (current time)
```

---

## 🔐 Update Security Rules

Add these rules to your existing rules. Replace the entire rules file with this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ============ COMMUNITY POSTS ============
    match /community/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.content.size() > 0 &&
        request.resource.data.content.size() <= 5000;
      allow update: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      
      match /comments/{commentId} {
        allow read: if request.auth != null;
        allow create: if request.auth != null &&
          request.resource.data.userId == request.auth.uid &&
          request.resource.data.text.size() > 0 &&
          request.resource.data.text.size() <= 1000;
        allow update: if request.auth != null && 
          resource.data.userId == request.auth.uid;
        allow delete: if request.auth != null && 
          resource.data.userId == request.auth.uid;
      }
    }
    
    // ============ COMMUNITY CHAT ============
    match /community_chat/main/messages/{messageId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null &&
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.message.size() > 0 &&
        request.resource.data.message.size() <= 5000;
      allow delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow update: if false;
    }
    
    // ============ STORIES ============
    match /stories/{storyId} {
      allow read: if request.auth != null && 
        resource.data.expiresAt > request.time;
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.imageUrl != null;
      allow update: if request.auth != null && 
        resource.data.userId == request.auth.uid &&
        request.resource.data.viewCount >= resource.data.viewCount;
      allow delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      
      match /viewers/{viewerId} {
        allow read: if request.auth.uid == get(/databases/$(database)/documents/stories/$(storyId)).data.userId;
        allow create: if request.auth.uid == viewerId;
        allow delete: if false;
      }
    }
    
    // ============ USER PROFILES ============
    match /users/{userId} {
      allow read: if request.auth != null;
      allow update: if request.auth != null && 
        request.auth.uid == userId;
      allow create: if false;
      allow delete: if false;
      
      // ============ FOCUS SESSIONS (DASHBOARD) ============
      match /focusSessions/{sessionId} {
        allow read: if request.auth != null && 
          request.auth.uid == userId;
        allow create: if request.auth != null && 
          request.auth.uid == userId;
        allow update: if request.auth != null && 
          request.auth.uid == userId;
        allow delete: if request.auth != null && 
          request.auth.uid == userId;
      }
      
      // ============ TASKS ============
      match /tasks/{taskId} {
        allow read: if request.auth != null && 
          request.auth.uid == userId;
        allow create: if request.auth != null && 
          request.auth.uid == userId;
        allow update: if request.auth != null && 
          request.auth.uid == userId;
        allow delete: if request.auth != null && 
          request.auth.uid == userId;
      }
      
      // ============ MISSIONS ============
      match /missions/{missionId} {
        allow read: if request.auth != null && 
          request.auth.uid == userId;
        allow create: if request.auth != null && 
          request.auth.uid == userId;
        allow update: if request.auth != null && 
          request.auth.uid == userId;
        allow delete: if request.auth != null && 
          request.auth.uid == userId;
      }
    }
    
    // ============ HABITS ============
    match /habits/{habitId} {
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // ============ HABIT LOGS ============
    match /habitLogs/{logId} {
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // ============ LIKES INDEX ============
    match /posts_likes/{docId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
      allow update: if false;
    }
  }
}
```

---

## 📝 Step-by-Step

1. **Open Firebase Console**: https://console.firebase.google.com/project/safe-5723a

2. **Add Subcollections** (under users/safe-5723a):
   - focusSessions (create 1 document)
   - tasks (create 1 document)
   - missions (create 1 document)

3. **Add Top-Level Collections**:
   - habits (create 1 document)
   - habitLogs (create 1 document)

4. **Update Security Rules**:
   - Go to Rules tab
   - Paste the complete rules above
   - Click Publish

5. **Rebuild Flutter**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

## ✅ After Setup

- ✅ Dashboard loads with real data
- ✅ Habits feature works
- ✅ Tasks feature works
- ✅ Missions feature works
- ✅ Community works
- ✅ Chat works
- ✅ Stories works
- ✅ Profile works

---

**No mock data - everything real! 🚀**

