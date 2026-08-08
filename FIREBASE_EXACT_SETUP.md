# 🔥 FIREBASE EXACT SETUP GUIDE

**Your Firebase Project**: `safe-5723a`  
**Your User ID**: `OIxCpD2grJNO3jblAkV524HpMTs1`

---

## ✅ WORKING FEATURES
- **Community Chat**: ✅ Working perfectly
- **Habits**: ✅ Working perfectly

## ❌ BROKEN FEATURES
- **Dashboard**: Missing Firestore index
- **Community Posts**: Field type error in document
- **Profile**: Status unknown

---

## 🚨 IMMEDIATE FIXES NEEDED

### 1. CREATE FIRESTORE INDEX (Dashboard Fix)
**Click this URL to create the missing index (takes 1-2 minutes):**

```
https://console.firebase.google.com/v1/r/project/safe-5723a/firestore/indexes?create_composite=ClBwcm9qZWN0cy9zYWZlLTU3MjNhL2RhdGFiYXNlcy8oZGVmYXVsdCkvY29sbGVjdGlvbkdyb3Vwcy9mb2N1c1Nlc3Npb25zL2luZGV4ZXMvXxABGgoKBnN0YXR1cxABGg0KCXN0YXR1ZBABEIMKBF9fbmFtZV9fEAE
```

**What it does**: Creates a composite index for `focusSessions` collection to query by `status` and sort by `createdAt`

---

### 2. FIX POST DOCUMENT TYPE ERROR

**Problem**: Document `Z9U5wUGUc3X0x8lTOlI6` in `community` collection has wrong field types.

**Error**: `type 'bool' is not a subtype of type 'String'`

**How to fix**:
1. Go to Firebase Console → Firestore Database
2. Open collection: `community`
3. Find document: `Z9U5wUGUc3X0x8lTOlI6`
4. Check these fields - if any are **boolean** instead of **string/timestamp**, delete and recreate:
   - `imageUrl` → Should be **string** (or null)
   - `videoUrl` → Should be **string** (or null)  
   - `createdAt` → Should be **timestamp** (not string, not boolean)
   - `content` → Should be **string**

**Quick fix**: Delete the document and create a new test post.

---

## 📋 REQUIRED FIREBASE COLLECTIONS

### ✅ Already Created (by you):
1. `community_chat/main/messages` - Chat messages
2. `community` - Community posts (has field errors)
3. `users` - User profiles
4. `quotes` - Daily quotes
5. `dashboard_stats` - Dashboard statistics
6. `habits` - User habits

### 🆕 Still Needed:
7. `focusSessions` - Focus timer sessions (for dashboard)
8. `missions` - Daily missions

---

## 📊 COLLECTION STRUCTURES WITH SAMPLE DATA

### 1. **users** Collection
**Path**: `users/{userId}`

**Sample Document** (`OIxCpD2grJNO3jblAkV524HpMTs1`):
```json
{
  "userId": "OIxCpD2grJNO3jblAkV524HpMTs1",
  "email": "sadiqferej397@gmail.com",
  "displayName": "Sadiq",
  "photoUrl": null,
  "level": 1,
  "xp": 0,
  "streak": 0,
  "totalWorkouts": 0,
  "createdAt": "2026-08-07T10:00:00Z",
  "updatedAt": "2026-08-07T10:00:00Z"
}
```

**Field Types**:
- All numbers: **int64** (not double)
- Dates: **timestamp** or **string** (ISO 8601)
- URLs: **string** or **null**

---

### 2. **dashboard_stats** Collection
**Path**: `dashboard_stats/{userId}`

**Sample Document** (`OIxCpD2grJNO3jblAkV524HpMTs1`):
```json
{
  "userId": "OIxCpD2grJNO3jblAkV524HpMTs1",
  "level": 5,
  "xp": 450,
  "xpToNextLevel": 550,
  "streak": 7,
  "totalWorkouts": 24,
  "weeklyMinutes": 320,
  "lastUpdated": "2026-08-07T10:00:00Z"
}
```

---

### 3. **focusSessions** Collection
**Path**: `focusSessions/{sessionId}`

**Sample Document** (create with auto-ID):
```json
{
  "userId": "OIxCpD2grJNO3jblAkV524HpMTs1",
  "duration": 1500,
  "completedSeconds": 1500,
  "status": "completed",
  "createdAt": "2026-08-07T09:00:00Z",
  "endedAt": "2026-08-07T09:25:00Z"
}
```

**Important**: Create at least 2-3 documents with different dates for the dashboard chart.

---

### 4. **missions** Collection
**Path**: `missions/{missionId}`

**Sample Document** (create with auto-ID):
```json
{
  "userId": "OIxCpD2grJNO3jblAkV524HpMTs1",
  "title": "Complete 3 workouts",
  "description": "Stay consistent with your training",
  "xpReward": 50,
  "status": "active",
  "progress": 2,
  "target": 3,
  "date": "2026-08-07",
  "createdAt": "2026-08-07T00:00:00Z"
}
```

---

### 5. **community** Collection (Posts)
**Path**: `community/{postId}`

**Sample Document** (create with auto-ID):
```json
{
  "userId": "OIxCpD2grJNO3jblAkV524HpMTs1",
  "authorId": "OIxCpD2grJNO3jblAkV524HpMTs1",
  "userName": "Sadiq",
  "authorName": "Sadiq",
  "authorRole": "Member",
  "content": "Just finished an amazing workout! 💪",
  "likeCount": 5,
  "commentCount": 2,
  "createdAt": "2026-08-07T10:00:00Z",
  "isLikedByMe": false,
  "imageUrl": null,
  "videoUrl": null
}
```

**CRITICAL**: All fields must use correct types:
- `content`, `userName`, `authorName`, `authorRole`: **string**
- `likeCount`, `commentCount`: **int64** (NOT double, NOT boolean)
- `createdAt`: **timestamp** or **string** (ISO 8601)
- `isLikedByMe`: **boolean**
- `imageUrl`, `videoUrl`: **string** or **null**

---

### 6. **quotes** Collection
**Path**: `quotes/{quoteId}`

**Sample Document** (create with auto-ID):
```json
{
  "text": "The only bad workout is the one that didn't happen.",
  "author": "Unknown",
  "category": "motivation",
  "date": "2026-08-07"
}
```

---

## 🔐 FIREBASE SECURITY RULES

**Current rules** (temporary - allows all authenticated users):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**For Storage** (if you add images):
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

---

## 📝 STEP-BY-STEP SETUP

### Step 1: Create Missing Index
1. Click the index creation URL above
2. Wait 1-2 minutes for index to build
3. Refresh Firebase Console to confirm

### Step 2: Fix Community Posts
1. Go to Firestore → `community` collection
2. Find document `Z9U5wUGUc3X0x8lTOlI6`
3. Delete it (it has wrong field types)
4. Create new test post using sample data above
5. **Use int64 for numbers, not double or boolean**

### Step 3: Create focusSessions
1. Go to Firestore → Create collection: `focusSessions`
2. Add 3 sample documents using sample data above
3. Change dates to different days (yesterday, 2 days ago, 3 days ago)
4. Set all to `status: "completed"`

### Step 4: Create missions
1. Go to Firestore → Create collection: `missions`
2. Add 1 mission using sample data above
3. Set `date` to today: `2026-08-07`

### Step 5: Verify User Profile
1. Go to Firestore → `users` collection
2. Check if document `OIxCpD2grJNO3jblAkV524HpMTs1` exists
3. If not, create it using sample data above

---

## 🧪 TESTING CHECKLIST

After completing setup:

1. ✅ **Login** - Does authentication work?
2. ✅ **Chat** - Can you send/receive messages?
3. ✅ **Habits** - Can you create/complete habits?
4. ⏳ **Dashboard** - Do stats load? (After index creation)
5. ⏳ **Posts** - Can you see community posts? (After field fix)
6. ⏳ **Profile** - Does your profile show?
7. ⏳ **Focus Timer** - Can you start a timer session?

---

## 🐛 COMMON ISSUES

### Issue 1: "The query requires an index"
**Solution**: Click the index creation URL provided above.

### Issue 2: "type 'bool' is not a subtype of type 'String'"
**Solution**: Delete and recreate the post document with correct field types.

### Issue 3: "User not authenticated"
**Solution**: Logout and login again. Check if `authState` is properly initialized.

### Issue 4: Storage 404 error
**Solution**: Enable Firebase Storage in console, or set `imageUrl`/`videoUrl` to `null` in posts.

---

## 📞 VERIFICATION COMMANDS

After setup, check these in Firebase Console:

```
✅ Authentication → Users → sadiqferej397@gmail.com exists
✅ Firestore → users → OIxCpD2grJNO3jblAkV524HpMTs1 exists
✅ Firestore → dashboard_stats → OIxCpD2grJNO3jblAkV524HpMTs1 exists
✅ Firestore → focusSessions → (3+ documents with userId)
✅ Firestore → missions → (1+ document with today's date)
✅ Firestore → community → (1+ valid post)
✅ Firestore → quotes → (1+ quote)
✅ Firestore → habits → (your habits)
✅ Indexes → focusSessions composite index created
```

---

## 🎯 SUMMARY

**What works**: Chat ✅, Habits ✅  
**What needs fixing**: Dashboard (index), Posts (field types), Profile (verify)  
**Action items**:
1. Click index URL
2. Fix/recreate post document
3. Create `focusSessions` and `missions` collections
4. Test all features

**Your credentials**:
- Email: `sadiqferej397@gmail.com`
- Firebase UID: `OIxCpD2grJNO3jblAkV524HpMTs1`
- Project: `safe-5723a`
