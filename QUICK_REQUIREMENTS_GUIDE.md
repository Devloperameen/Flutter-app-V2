# ⚡ FitFlow - Quick Requirements Guide

**TL;DR**: Fix community chat, posts, profile, and add stories. Delete mock data.

---

## 🎯 What's Broken Right Now?

| Feature | Status | Issue | Fix |
|---------|--------|-------|-----|
| **Chat** | 95% done | Firebase not set up | Create Firestore collection + rules |
| **Posts** | Using mock data | Falls back to hardcoded data | Use Firestore only, remove mock |
| **Profile** | UI only | Can't save changes | Add Firestore persistence |
| **Stories** | Doesn't exist | "Coming soon" | Build from scratch |
| **Comments** | Hardcoded | Shows dummy data | Load from Firestore |

---

## 🔥 Firebase Collections Needed

### Create in Firebase Console:

1. **community** (Posts)
   - postId, userId, userName, content, imageUrl, videoUrl, likeCount, commentCount
   - Subcollection: comments

2. **community_chat** (Real-time Chat)
   - main/messages: userId, userName, message, createdAt

3. **stories** (24hr Stories)
   - userId, userName, imageUrl, createdAt, expiresAt

4. **users** (Profile Data)
   - email, firstName, lastName, avatarUrl, bio, settings

5. **posts_likes** (Performance)
   - postId, userId, createdAt

---

## 📱 Features Summary

### Community Chat ✅ Almost Done
```
What works: Code, real-time streaming, delete messages
What's needed: Firebase setup (15 mins)
```

### Community Posts ⚠️ Needs Cleanup
```
Current: Falls back to mock data (WRONG!)
Needed: Firestore only, no mock fallback
Fix: Delete community_mock_datasource.dart
```

### Profile 🔴 Not Persistent
```
Current: Edit UI works but doesn't save
Needed: Save changes to Firestore
Fix: Add profile repository + providers
```

### Stories 🔴 Not Implemented
```
Current: Doesn't exist
Needed: Complete feature (upload → display → 24hr expiry)
Fix: Create /features/story directory
```

---

## 🗑️ Delete These Files (No More Mock)

```
❌ lib/features/community/data/datasources/community_mock_datasource.dart
❌ lib/features/dashboard/data/datasources/dashboard_mock_datasource.dart
❌ lib/features/habits/data/datasources/mock_habit_datasource.dart
❌ lib/features/auth/data/datasources/auth_mock_datasource.dart
```

---

## 🚀 Implementation Order (Recommended)

### Week 1: Chat (Critical)
1. Set up Firebase Firestore database
2. Create `community_chat` collection
3. Apply security rules
4. Test real-time messaging

**Result**: Working chat with 2+ users

### Week 2: Posts (High Priority)
1. Remove mock datasource
2. Fix media URL handling
3. Load real posts from Firestore
4. Test like/comment functionality

**Result**: Working posts feed (no more fake data)

### Week 3: Profile (High Priority)
1. Create profile Firestore datasource
2. Add profile repository
3. Create profile providers
4. Wire UI to state

**Result**: Can save profile changes

### Week 4: Stories (Medium Priority)
1. Create story feature directory
2. Build story models
3. Implement upload/display
4. Test 24hr expiration

**Result**: Instagram-style stories

### Week 5: Polish
1. End-to-end testing
2. Bug fixes
3. Performance optimization

**Result**: Production-ready app

---

## 🔒 Security Rules (Copy-Paste Ready)

### For community_chat messages:
```javascript
match /community_chat/main/messages/{messageId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null && 
    request.resource.data.userId == request.auth.uid &&
    request.resource.data.message.size() > 0;
  allow delete: if request.auth != null && 
    resource.data.userId == request.auth.uid;
  allow update: if false;
}
```

### For community posts:
```javascript
match /community/{postId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null && 
    request.resource.data.userId == request.auth.uid &&
    request.resource.data.content.size() > 0;
  allow delete: if request.auth != null && 
    resource.data.userId == request.auth.uid;
}
```

---

## ❓ Questions Before We Start?

1. Should comments be real-time like chat?
2. Do you want follow/unfollow system?
3. Video length limits?
4. Should we show notifications for likes/comments?
5. Need search functionality?

---

## ✅ Simple Checklist

```
Firebase Setup:
☐ Create community_chat collection
☐ Create community collection  
☐ Create stories collection
☐ Create users collection
☐ Apply Firestore security rules

Code Cleanup:
☐ Delete all mock datasources
☐ Remove mock fallback logic
☐ Update imports

Implementation:
☐ Test chat (Week 1)
☐ Fix posts (Week 2)
☐ Add profile persistence (Week 3)
☐ Build stories (Week 4)
☐ Polish & test (Week 5)
```

---

## 💡 Key Points

✅ **Chat code is ready** - just needs Firebase  
❌ **Posts use fake data** - need to remove mock  
❌ **Profile doesn't save** - need Firestore  
❌ **Stories don't exist** - need to build  
✅ **Security rules provided** - copy-paste to Firebase

---

**APPROVAL**: Review and approve these requirements before implementation starts.

