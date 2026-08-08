# 🔥 Firebase Setup - Complete Step-by-Step Guide

**Goal**: Set up Firebase Firestore for FitFlow community features (chat, posts, stories, profile)

**Time Required**: ~30-45 minutes

**Prerequisites**: Google Account

---

## 📋 STEP 1: Go to Firebase Console

1. Open browser: `https://console.firebase.google.com`
2. Sign in with your Google account
3. You should see your existing FitFlow project

---

## 🎯 STEP 2: Select Your Project

1. Click on **FitFlow Gym** (or your project name)
2. You're now in Firebase Console for your project

---

## ⚡ STEP 3: Create Firestore Database

### 3.1 Navigate to Firestore
1. Left sidebar → **Build** section
2. Click **Firestore Database**
3. You'll see: "Cloud Firestore"

### 3.2 Create Database
1. Click blue button: **Create Database**
2. A dialog appears:

```
Choose starting mode for your database:
```

3. **Select**: Production mode
   - (Not testing mode - we'll set security rules)

4. **Select region**: Choose closest to your users
   - Recommended: `us-central1` or `europe-west1`
   - If in Asia: `asia-southeast1`

5. Click: **Create**

### 3.3 Wait for Database Creation
- Green checkmark appears
- Takes ~1-2 minutes
- You'll see empty database

---

## 📁 STEP 4: Create Collections

### Collection 1: `community` (Posts)

1. Click: **Start collection**
2. Enter Collection ID: `community`
3. Click: **Next**

4. **Create first document**:
   - Document ID: Click **Auto ID** (or enter: `post_1`)
   - Add fields:

```
Field Name        | Type      | Value
-----------------+-----------+----------------------------------
userId            | string    | user123
userName          | string    | Alex Chen
userAvatar        | string    | https://example.com/avatar.jpg
content           | string    | My first post
imageUrl          | string    | (leave empty)
videoUrl          | string    | (leave empty)
likeCount         | number    | 0
commentCount      | number    | 0
createdAt         | timestamp | Set to: August 7, 2026 (today)
isDeleted         | boolean   | false
```

5. Click: **Save**

6. Back to `community` collection, create more test documents following same format

---

### Collection 2: `community_chat` (Chat Messages)

1. Click: **Start collection**
2. Collection ID: `community_chat`
3. Click: **Next**

4. **Create first document**:
   - Document ID: `main`
   - NO fields needed (just save empty)
   - Click: **Save**

5. This creates `main` document

6. **Now create subcollection inside `main`**:
   - Inside `main` document, click: **Add subcollection**
   - Subcollection ID: `messages`
   - Click: **Next**

7. **Create first message**:
   - Document ID: **Auto ID**
   - Fields:

```
Field Name        | Type      | Value
-----------------+-----------+----------------------------------
userId            | string    | user123
userName          | string    | Alex Chen
userAvatar        | string    | https://example.com/avatar.jpg
message           | string    | Hello everyone!
createdAt         | timestamp | Set to: August 7, 2026
isDeleted         | boolean   | false
```

8. Click: **Save**

---

### Collection 3: `stories` (User Stories)

1. Click: **Start collection**
2. Collection ID: `stories`
3. Click: **Next**

4. **Create first document**:
   - Document ID: **Auto ID**
   - Fields:

```
Field Name        | Type      | Value
-----------------+-----------+----------------------------------
userId            | string    | user123
userName          | string    | Alex Chen
userAvatar        | string    | https://example.com/avatar.jpg
imageUrl          | string    | https://example.com/story.jpg
videoUrl          | string    | (leave empty)
caption           | string    | My story
createdAt         | timestamp | August 7, 2026
expiresAt         | timestamp | August 8, 2026 (24 hours later)
viewCount         | number    | 0
```

5. Click: **Save**

---

### Collection 4: `users` (Profile Data)

1. Click: **Start collection**
2. Collection ID: `users`
3. Click: **Next**

4. **Create first document**:
   - Document ID: `user123` (must match userId in other collections)
   - Fields:

```
Field Name           | Type      | Value
---------------------+-----------+----------------------------------
email                | string    | user@example.com
firstName            | string    | Alex
lastName             | string    | Chen
avatarUrl            | string    | https://example.com/avatar.jpg
bio                  | string    | Fitness enthusiast
followerCount        | number    | 0
followingCount       | number    | 0
postCount            | number    | 0
createdAt            | timestamp | August 7, 2026
updatedAt            | timestamp | August 7, 2026
settings             | map       | (see next step)
```

5. For `settings` field (click the `map` type):
   - Add field: `theme` = `"auto"` (string)
   - Add field: `notificationsEnabled` = `true` (boolean)
   - Add field: `privacyLevel` = `"public"` (string)

6. Click: **Save**

---

### Collection 5: `posts_likes` (Performance Index)

1. Click: **Start collection**
2. Collection ID: `posts_likes`
3. Click: **Next**

4. **Create first document**:
   - Document ID: `post_1_user123`
   - Fields:

```
Field Name        | Type      | Value
-----------------+-----------+----------------------------------
postId            | string    | post_1
userId            | string    | user123
createdAt         | timestamp | August 7, 2026
```

5. Click: **Save**

---

## 🔐 STEP 5: Set Up Security Rules

### 5.1 Go to Firestore Rules
1. Top menu: **Rules** tab
2. You'll see default rules

### 5.2 Replace ALL Rules

**DELETE** all existing rules and **PASTE** this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ============ COMMUNITY POSTS ============
    match /community/{postId} {
      // Only authenticated users can read posts
      allow read: if request.auth != null;
      
      // Users can create their own posts
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.content.size() > 0 &&
        request.resource.data.content.size() <= 5000;
      
      // Users can update their own posts
      allow update: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      
      // Users can delete their own posts
      allow delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      
      // Comments subcollection
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
      // Only authenticated users can read messages
      allow read: if request.auth != null;
      
      // Users can send messages as themselves
      allow create: if request.auth != null &&
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.message.size() > 0 &&
        request.resource.data.message.size() <= 5000;
      
      // Users can delete only their own messages
      allow delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      
      // No updates allowed (immutable messages)
      allow update: if false;
    }
    
    // ============ STORIES ============
    match /stories/{storyId} {
      // Only non-expired stories can be read
      allow read: if request.auth != null && 
        resource.data.expiresAt > request.time;
      
      // Users can create their own stories
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid &&
        request.resource.data.imageUrl != null;
      
      // Users can update their own stories (view count only)
      allow update: if request.auth != null && 
        resource.data.userId == request.auth.uid &&
        request.resource.data.viewCount >= resource.data.viewCount;
      
      // Users can delete their own stories
      allow delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      
      // Viewers subcollection
      match /viewers/{viewerId} {
        allow read: if request.auth.uid == get(/databases/$(database)/documents/stories/$(storyId)).data.userId;
        allow create: if request.auth.uid == viewerId;
        allow delete: if false;
      }
    }
    
    // ============ USER PROFILES ============
    match /users/{userId} {
      // Users can read all public profiles
      allow read: if request.auth != null;
      
      // Users can only update their own profile
      allow update: if request.auth != null && 
        request.auth.uid == userId;
      
      // Only allow profile creation at signup (via backend)
      allow create: if false;
      
      // Prevent deletion
      allow delete: if false;
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

### 5.3 Publish Rules
1. Click blue button: **Publish**
2. Confirmation: "Rules have been published"

---

## 🔍 STEP 6: Create Firestore Indexes (Optional but Recommended)

### 6.1 Go to Indexes Tab
1. Top menu: **Indexes** tab
2. Click: **Create Index**

### 6.2 Create Indexes

**Index 1: Posts by date**
- Collection: `community`
- Fields to index:
  - `createdAt` (Descending)
  - `__name__` (Ascending)
- Click: **Create**

**Index 2: Messages by timestamp**
- Collection: `community_chat/main/messages`
- Fields to index:
  - `createdAt` (Ascending)
  - `__name__` (Ascending)
- Click: **Create**

**Index 3: Stories by expiration**
- Collection: `stories`
- Fields to index:
  - `expiresAt` (Ascending)
  - `userId` (Ascending)
- Click: **Create**

**Index 4: Users**
- Collection: `users`
- Fields to index:
  - `createdAt` (Descending)
- Click: **Create**

---

## ✅ STEP 7: Verify Firebase Auth is Enabled

1. Left sidebar → **Build** → **Authentication**
2. Click: **Get Started**
3. Enable **Email/Password** provider
   - Click: **Enable**
   - Click: **Save**

---

## 🧪 STEP 8: Test Connection

### 8.1 Check google-services.json

In your project, verify file exists:
```
/android/app/google-services.json
```

It should contain:
- `project_id`
- `api_key`
- `client_id`

### 8.2 Run App and Test

```bash
cd /home/sadiq/FlutterProjects/fitflow_gym
flutter clean
flutter pub get
flutter run
```

### 8.3 Verify Connection
- Open app → Community → Posts tab
- Should load without "Permission denied" errors
- May show empty posts (that's OK, we just created test data)

---

## 📊 STEP 9: Monitor Firestore Usage

1. **Dashboard** tab (left sidebar)
2. See:
   - Document reads
   - Document writes
   - Delete operations
   - Storage used

This helps you understand costs and usage patterns.

---

## 🔥 STEP 10: Test Each Feature

### Test Chat
1. Open app
2. Community → Chat tab
3. Type message → Send
4. Check Firestore `community_chat/main/messages`
5. Your message should appear

### Test Posts
1. Community → Posts tab
2. Click plus icon → Create Post
3. Add text and image
4. Click Post
5. Check Firestore `community` collection
6. Your post should appear

### Test Comments
1. Click on any post → Comments button
2. Type comment → Send
3. Check Firestore `community/{postId}/comments`
4. Your comment should appear

### Test Profile
1. Profile tab
2. Edit profile → Save
3. Check Firestore `users/{userId}`
4. Your changes should be saved

---

## ⚠️ Common Issues & Solutions

### Issue 1: "Permission Denied" Error

**Problem**: Can't read/write to Firestore

**Solution**:
1. Check rules are published (Step 5)
2. Check you're logged in (Firebase Auth)
3. Wait 1-2 minutes for rules to propagate

---

### Issue 2: "Collection Not Found"

**Problem**: Collections don't appear

**Solution**:
1. Refresh page: F5
2. Collections appear only after first document is created
3. Try creating a test document in each collection

---

### Issue 3: "Messages Not Real-Time"

**Problem**: New messages don't appear instantly

**Solution**:
1. Check internet connection
2. Restart app
3. Check Firestore connection in logs

---

## 🎉 Success Checklist

```
✅ Firestore Database Created
✅ Collections Created:
   ✅ community (Posts)
   ✅ community_chat (Chat)
   ✅ stories (Stories)
   ✅ users (Profiles)
   ✅ posts_likes (Index)
✅ Security Rules Published
✅ Firestore Indexes Created
✅ Firebase Auth Enabled
✅ App Connects to Firestore
✅ Test Data Created
✅ Chat Messages Send
✅ Posts Save to Database
✅ Comments Functional
✅ Profile Saves Changes
```

---

## 💡 Quick Reference

### Firestore Console URLs
- **Firebase Console**: https://console.firebase.google.com
- **Your Project**: https://console.firebase.google.com/project/fitflow-gym (or your project ID)

### Collections Quick View
```
community_chat/
└── main/
    └── messages/
        └── (auto-generated message docs)

community/
└── (post_1, post_2, etc)
    └── comments/ (subcollection)

stories/
└── (story_1, story_2, etc)
   └── viewers/ (subcollection)

users/
└── (user_1, user_2, etc)

posts_likes/
└── (post_1_user_1, etc)
```

---

## 🚀 Next Steps

After Firebase is set up:

1. **Test each feature** (Chat, Posts, Comments, Profile, Stories)
2. **Monitor Firestore usage** in Dashboard
3. **Fix any errors** that appear
4. **Deploy to production** when ready

---

## 📞 Need Help?

If something doesn't work:

1. Check Firestore Rules (Step 5)
2. Check Collections Exist (Step 4)
3. Check Auth is Enabled (Step 7)
4. Check Internet Connection
5. Restart App

---

**Firebase Setup Complete! Your app is now connected to real-time database. 🎉**

