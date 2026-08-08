# 📋 FitFlow App - Complete Requirements Specification

**Status**: Awaiting User Approval  
**Date**: August 7, 2026  
**Version**: 1.0

---

## 🎯 Executive Summary

This document specifies the complete overhaul needed for FitFlow's social & communication features. The current implementation has:

- ✅ **Chat**: Production-ready code but needs Firebase setup
- ⚠️ **Posts**: Fallback to mock data (unreliable)
- ⚠️ **Profile**: UI only, no data persistence
- ❌ **Stories**: Not implemented
- ⚠️ **Analytics**: Half-implemented

**Goal**: Clean, modern, fully-functional social platform similar to Instagram/TikTok/Telegram.

---

## 🔥 FIREBASE COLLECTIONS SETUP

### Phase 1: Delete Old/Unused Collections
These collections should be cleaned up (if they exist):
```
❌ community_posts (OLD - replace with 'community')
❌ posts (OLD - replace with 'community')
❌ test_* (test data - delete all)
```

### Phase 2: Create Required Collections

#### Collection 1: `users`
```
users/
├── {userId}/
│   ├── email: string
│   ├── firstName: string
│   ├── lastName: string
│   ├── avatarUrl: string (HTTPS only)
│   ├── bio: string
│   ├── followerCount: number
│   ├── followingCount: number
│   ├── createdAt: timestamp
│   ├── updatedAt: timestamp
│   └── settings: map
│       ├── theme: "light" | "dark" | "auto"
│       ├── notificationsEnabled: boolean
│       └── privacyLevel: "public" | "friends" | "private"
```

**Firestore Rules**:
```javascript
match /users/{userId} {
  // Only users can read/update their own profile
  allow read: if request.auth.uid == userId || 
    (exists(/databases/$(database)/documents/users/$(request.auth.uid)) && 
     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.privacyLevel == "public");
  allow update: if request.auth.uid == userId;
  allow create: if request.auth.uid == userId;
  allow delete: if false; // Prevent deletion of user docs
}
```

---

#### Collection 2: `community` (Posts)
```
community/
├── {postId}/
│   ├── userId: string (required)
│   ├── userName: string (required)
│   ├── userAvatar: string (HTTPS URL, optional)
│   ├── content: string (1-5000 chars, required)
│   ├── imageUrl: string (HTTPS only, optional)
│   ├── videoUrl: string (HTTPS only, optional)
│   ├── likeCount: number (default: 0)
│   ├── commentCount: number (default: 0)
│   ├── createdAt: timestamp (server-set)
│   ├── updatedAt: timestamp (server-set)
│   ├── isDeleted: boolean (soft-delete flag)
│   └── comments/ (subcollection)
│       └── {commentId}/
│           ├── userId: string
│           ├── userName: string
│           ├── userAvatar: string
│           ├── text: string (1-1000 chars)
│           ├── createdAt: timestamp
│           └── likes: number
```

**Firestore Rules**:
```javascript
match /community/{postId} {
  // Authenticated users can read posts
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
```

---

#### Collection 3: `community_chat` (Real-Time Chat)
```
community_chat/
├── main/ (document)
│   └── messages/ (subcollection)
│       └── {messageId}/
│           ├── userId: string (required)
│           ├── userName: string (required)
│           ├── userAvatar: string (HTTPS URL, optional)
│           ├── message: string (1-5000 chars)
│           ├── createdAt: timestamp (server-set)
│           └── isDeleted: boolean (soft-delete)
```

**Firestore Rules**:
```javascript
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
```

---

#### Collection 4: `stories` (User Stories - 24hr Expiry)
```
stories/
├── {storyId}/
│   ├── userId: string (required)
│   ├── userName: string (required)
│   ├── userAvatar: string (HTTPS URL)
│   ├── imageUrl: string (HTTPS only)
│   ├── videoUrl: string (HTTPS only, optional)
│   ├── caption: string (optional)
│   ├── createdAt: timestamp (server-set)
│   ├── expiresAt: timestamp (createdAt + 24 hours)
│   ├── viewCount: number (default: 0)
│   └── viewers/ (subcollection - lightweight)
│       └── {viewerId}/
│           └── viewedAt: timestamp
```

**Firestore Rules**:
```javascript
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
```

---

#### Collection 5: `posts_likes` (Denormalized - for performance)
```
posts_likes/
├── {postId}_{userId}/
│   ├── postId: string
│   ├── userId: string
│   ├── createdAt: timestamp
```

**Why**: For fast "did user like this" queries instead of scanning comments.

**Firestore Rules**:
```javascript
match /posts_likes/{docId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null && 
    request.resource.data.userId == request.auth.uid;
  allow delete: if request.auth != null && 
    request.resource.data.userId == request.auth.uid;
  allow update: if false;
}
```

---

#### Collection 6: `notifications` (Optional but recommended)
```
notifications/
├── {userId}/
│   └── {notificationId}/
│       ├── type: "like" | "comment" | "follow" | "message"
│       ├── fromUserId: string
│       ├── fromUserName: string
│       ├── postId: string (optional)
│       ├── message: string
│       ├── isRead: boolean
│       ├── createdAt: timestamp
```

---

## 📱 FEATURE REQUIREMENTS

### Feature 1: Community Posts (Instagram/TikTok Style)

#### 1.1 Posts Feed
| Requirement | Details | Priority |
|---|---|---|
| **Display** | Vertical feed of posts, newest first | P0 |
| **Components** | Avatar, name, role/badge, timestamp, content, image/video | P0 |
| **Media** | Show image OR video (image prioritized if both) | P0 |
| **Interaction** | Like button (heart, red when liked), comment count, share button | P0 |
| **Loading** | Skeleton loaders, pull-to-refresh | P1 |
| **Pagination** | Load more when scrolling to bottom | P1 |
| **Offline** | Show cached posts, disable send button | P2 |

#### 1.2 Create Post
| Requirement | Details | Priority |
|---|---|---|
| **Text** | 1-5000 characters, text editor with mentions | P0 |
| **Media** | Pick image OR video from gallery/camera | P0 |
| **Validation** | Text required, media optional, max file size 50MB | P0 |
| **Upload** | Show progress, cancel option | P1 |
| **Publishing** | "Post" button disabled until content ready | P0 |

#### 1.3 Comments
| Requirement | Details | Priority |
|---|---|---|
| **View** | Bottom sheet modal with comments list | P0 |
| **Display** | Avatar, name, text, timestamp, like count | P0 |
| **Add** | Input field + send button, character limit 1000 | P0 |
| **Like** | Like individual comments | P1 |
| **Replies** | Nested replies (1 level) | P2 |

#### 1.4 Engagement
| Requirement | Details | Priority |
|---|---|---|
| **Like** | Toggle like, update count real-time | P0 |
| **Unlike** | Remove like, sync to server | P0 |
| **Delete Post** | Swipe or menu → confirm delete | P0 |
| **Delete Comment** | Long-press or menu → delete | P1 |
| **Report** | Report inappropriate content (UI stub) | P2 |

#### 1.5 Search/Filter
| Requirement | Details | Priority |
|---|---|---|
| **Search** | Search posts by text/hashtags | P2 |
| **Filter** | By user, by type (text/image/video), by time | P2 |

---

### Feature 2: Community Chat (Telegram/WhatsApp Style)

#### 2.1 Chat Screen
| Requirement | Details | Priority |
|---|---|---|
| **Display** | Scrollable message list, oldest at bottom | P0 |
| **Messages** | Bubble design with avatar, name, timestamp | P0 |
| **Own Messages** | Different color/alignment (right side) | P0 |
| **Others' Messages** | Different color/alignment (left side) | P0 |
| **Loading** | "Connecting to chat..." status | P0 |
| **Empty State** | "Start the conversation!" with icon | P0 |

#### 2.2 Message Sending
| Requirement | Details | Priority |
|---|---|---|
| **Input** | Text field with send button | P0 |
| **Validation** | Cannot send empty messages | P0 |
| **Emoji** | Emoji picker button (optional) | P1 |
| **Rich Text** | Bold, italic, links (optional) | P2 |
| **Attachments** | Images/videos (stretch goal) | P3 |

#### 2.3 Message Management
| Requirement | Details | Priority |
|---|---|---|
| **Delete** | Long-press own message → delete | P0 |
| **Edit** | NOT supported (immutable messages) | N/A |
| **Read Receipts** | Show who viewed messages (optional) | P2 |
| **Typing Indicator** | Show "User is typing..." (optional) | P2 |

#### 2.4 Real-Time Sync
| Requirement | Details | Priority |
|---|---|---|
| **Subscribe** | Firestore listener on page load | P0 |
| **Receive** | New messages appear instantly | P0 |
| **Network Loss** | Show "Reconnecting..." until online | P1 |
| **Timestamps** | Show server timestamps, not local | P0 |

---

### Feature 3: User Profile (Instagram Style)

#### 3.1 Profile View
| Requirement | Details | Priority |
|---|---|---|
| **Avatar** | Large circular image with upload option | P0 |
| **Name** | Display full name (editable) | P0 |
| **Bio** | Optional bio/description (editable) | P0 |
| **Stats** | Followers, Following, Posts count | P1 |
| **Posts** | Grid of user's posts | P1 |
| **Stories** | Story previews (when implemented) | P2 |

#### 3.2 Edit Profile
| Requirement | Details | Priority |
|---|---|---|
| **Personal Info** | Edit first name, last name, bio | P0 |
| **Avatar** | Upload new avatar to Firebase Storage | P0 |
| **Save** | Persist changes to Firestore immediately | P0 |
| **Validation** | Required fields, length limits | P0 |

#### 3.3 Settings
| Requirement | Details | Priority |
|---|---|---|
| **Theme** | Light, dark, auto (save to Firestore) | P1 |
| **Notifications** | Enable/disable (save to Firestore) | P1 |
| **Privacy** | Public/friends/private (save to Firestore) | P1 |

#### 3.4 Other User Profile
| Requirement | Details | Priority |
|---|---|---|
| **View** | Tap user avatar → see their profile | P1 |
| **Follow** | Follow/unfollow button (UI stub) | P2 |
| **Message** | DM button (future feature) | P2 |

---

### Feature 4: Stories (Snapchat/Instagram Style)

#### 4.1 Story Creation
| Requirement | Details | Priority |
|---|---|---|
| **Capture** | Camera or gallery photo/video | P1 |
| **Duration** | Auto-expire after 24 hours | P1 |
| **Upload** | Show progress, upload to Firebase Storage | P1 |
| **Preview** | Confirm before publishing | P1 |

#### 4.2 Story Viewing
| Requirement | Details | Priority |
|---|---|---|
| **Feed** | Row of user avatars with stories (circular progress) | P1 |
| **Fullscreen** | Tap avatar → open fullscreen story viewer | P1 |
| **Navigation** | Swipe left/right to next/previous story | P1 |
| **Duration** | Auto-advance after 5 seconds | P1 |
| **Pause** | Tap to pause/resume | P1 |

#### 4.3 Story Interactions
| Requirement | Details | Priority |
|---|---|---|
| **View Counter** | Show "5 views" on own stories | P1 |
| **Seen By** | List of users who viewed (own stories only) | P1 |
| **Reply** | DM the user (optional) | P2 |

---

## 🎨 UI/UX REQUIREMENTS

### Design Language
- **Style**: Modern, clean, Material 3
- **Colors**: Use app color scheme (primary, secondary, tertiary seeds)
- **Animations**: Smooth transitions, fade-in on load
- **Responsiveness**: Work on phones (portrait), tablets (landscape)

### Key UI Elements

#### Posts Feed
```
┌─────────────────┐
│ 👤 Alex Chen    │ ← Avatar, name, badge (if Mentor)
│ Fitness Coach   │ ← Role
│ 2h ago          │ ← Timestamp
├─────────────────┤
│ "Just crushed   │ ← Content (max 3 lines preview)
│ my workout..."  │
│ [IMAGE ______]  │ ← Optional image/video (height: 280px)
├─────────────────┤
│ ❤️ 245  💬 12   │ ← Like count, comment count (TikTok style)
│ 🔄 Share       │ ← Share (optional)
└─────────────────┘
```

#### Comments Modal (Bottom Sheet)
```
╔════════════════════╗
║    ▔▔▔ Drag Bar   ║ ← Can drag to close
║  Comments (12)  ✕ ║ ← Header with close button
╠════════════════════╣
║ 👤 User 1         ║
║ "Great post!"     ║ ← Comment in bubble
║ 2h ago  ❤️        ║
║                   ║
║ 👤 User 2         ║
║ "Amazing!"        ║
║ 1h ago  ❤️        ║
╠════════════════════╣
║ [Add comment..] ⬆ ║ ← Input + send button
╚════════════════════╝
```

#### Chat Screen
```
┌─────────────────────┐
│ Connecting... 🔄   │ ← Status
├─────────────────────┤
│                    │
│  ┌──────────┐      │ ← Other user (left align)
│  │ Hi there │      │   
│  └──────────┘ 2h  │
│                    │
│           ┌─────┐  │ ← Own message (right align)
│           │ Hey!│  │   (different color)
│           └─────┘   │
│                    │
├─────────────────────┤
│ [Type message...] ➤ │ ← Input + send
└─────────────────────┘
```

#### Profile Screen
```
┌──────────────────────┐
│   [AVATAR IMAGE]     │ ← Tap to change
│    Alex Chen         │
│  Fitness Coach       │
│  "Living my best"    │ ← Bio
├──────────────────────┤
│  127    134    45    │ ← Followers, Following, Posts
│  Posts Following Followers
├──────────────────────┤
│ Edit  Share  🔔      │ ← Action buttons (only if own profile)
├──────────────────────┤
│ [Grid of 9 posts]    │ ← User's posts
└──────────────────────┘
```

---

## 🔐 SECURITY REQUIREMENTS

### Authentication
- **Require**: Firebase Auth (email/phone)
- **Session**: Auto logout after 30 mins of inactivity (optional)
- **Passwords**: Min 8 chars, mix of letters/numbers/symbols

### Data Protection
- **PII**: Never log user emails or phone numbers
- **Images**: Upload to Firebase Storage, not embedded in Firestore
- **URLs**: Validate HTTPS only, reject file:// or blob://
- **Rate Limits**: Max 5 posts/hour per user (server-side)

### Firestore Security Rules
- ✅ Users can only modify their own data
- ✅ Messages are immutable (no edits)
- ✅ Non-authenticated users cannot read posts/chat
- ✅ Ownership verified before delete operations
- ✅ Field validation (no empty messages, max lengths)

### Firebase Storage Security
```javascript
service firebase.storage {
  match /b/{bucket}/o {
    // User avatars
    match /avatars/{userId}/{filename} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId && 
        request.resource.size < 5MB &&
        request.resource.contentType.matches('image/.*');
    }
    
    // Post media (images)
    match /posts/{userId}/{filename} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId &&
        request.resource.size < 50MB &&
        request.resource.contentType.matches('image/.*|video/.*');
    }
    
    // Story media
    match /stories/{userId}/{filename} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId &&
        request.resource.size < 50MB;
      allow delete: if request.auth.uid == userId;
    }
  }
}
```

---

## 📊 DATABASE INDEXES

For optimal performance, create these Firestore indexes:

```
1. Collection: community
   Fields: createdAt (Descending), __name__ (Ascending)
   Purpose: Fast "newest posts first" queries

2. Collection: community_chat/main/messages
   Fields: createdAt (Ascending), __name__ (Ascending)
   Purpose: Fast "oldest messages first" queries

3. Collection: users
   Fields: createdAt (Descending)
   Purpose: Fast user discovery/leaderboards

4. Collection: stories
   Fields: expiresAt (Ascending), userId (Ascending)
   Purpose: Efficient story expiration + user queries

5. Collection: posts_likes
   Composite index: postId + userId
   Purpose: Fast "did user like this post" queries
```

---

## 🧹 CLEANUP ITEMS

### Delete/Remove
1. ❌ `community_mock_datasource.dart` - Use real Firestore only
2. ❌ All mock avatar colors (use real avatars from Firebase Storage)
3. ❌ "Comments (3)" hardcoded dummy comments in `community_screen.dart`
4. ❌ "Stories coming soon!" toast on profile
5. ❌ `dashboard_mock_datasource.dart` (unused)
6. ❌ `mock_habit_datasource.dart` (unused)
7. ❌ `auth_mock_datasource.dart` (unused)

### Update
1. ✏️ Replace post card avatar with real Firebase Storage URL
2. ✏️ Fix media URL sanitization (handle Firebase Storage paths)
3. ✏️ Implement comment count from actual Firestore data
4. ✏️ Implement like count from actual Firestore data

---

## 📋 DATA MODELS

### Post Model
```dart
@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String userId,
    required String userName,
    required String userAvatar, // HTTPS URL
    required String content,
    String? imageUrl, // HTTPS only
    String? videoUrl, // HTTPS only
    required int likeCount,
    required int commentCount,
    required DateTime createdAt,
    required bool isLikedByMe,
  }) = _Post;
}
```

### ChatMessage Model
```dart
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String userId,
    required String userName,
    required String userAvatar, // HTTPS URL
    required String message,
    required DateTime createdAt,
    @Default(false) bool isCurrentUser,
  }) = _ChatMessage;
}
```

### Story Model (NEW)
```dart
@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String userId,
    required String userName,
    required String userAvatar,
    required String imageUrl,
    String? videoUrl,
    String? caption,
    required DateTime createdAt,
    required DateTime expiresAt,
    required int viewCount,
  }) = _Story;
}
```

### User Profile Model (Update)
```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? avatarUrl, // HTTPS URL
    String? bio,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @Default(0) int postCount,
    required DateTime createdAt,
    required UserSettings settings,
  }) = _UserProfile;
}

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    @Default('auto') String theme,
    @Default(true) bool notificationsEnabled,
    @Default('public') String privacyLevel, // 'public', 'friends', 'private'
  }) = _UserSettings;
}
```

---

## 🚀 IMPLEMENTATION PHASES

### Phase 1: Stabilize Community Chat (Week 1)
- [ ] Set up Firebase Firestore collections
- [ ] Apply Firestore security rules
- [ ] Test real-time messaging
- [ ] Fix any connection issues
- **Deliverable**: Working 1:1 community chat

### Phase 2: Fix Community Posts (Week 2)
- [ ] Remove mock datasource fallback
- [ ] Implement proper error UI
- [ ] Fix media URL handling
- [ ] Test image/video uploads
- **Deliverable**: Posts feed with real media

### Phase 3: Implement Profile Backend (Week 3)
- [ ] Create profile Firestore datasource
- [ ] Add profile repository
- [ ] Create profile providers
- [ ] Wire UI to state
- [ ] Test profile persistence
- **Deliverable**: Fully functional profile editing

### Phase 4: Build Stories Feature (Week 4)
- [ ] Create story directory structure
- [ ] Design Story models
- [ ] Implement Firestore datasource
- [ ] Build UI screens
- [ ] Test 24hr expiration
- **Deliverable**: Instagram-style stories

### Phase 5: Polish & Testing (Week 5)
- [ ] End-to-end testing
- [ ] Performance optimization
- [ ] Security audit
- [ ] Bug fixes
- **Deliverable**: Production-ready app

---

## ✅ ACCEPTANCE CRITERIA

### Community Chat
- [ ] Send messages and receive real-time updates
- [ ] Delete own messages only
- [ ] Show read/unread status
- [ ] Handle offline gracefully
- [ ] No permission errors with Firestore rules

### Community Posts
- [ ] Create post with text + image/video
- [ ] Like/unlike posts in feed
- [ ] Add comments to posts
- [ ] Delete own posts only
- [ ] See real post counts (not hardcoded)

### Profile
- [ ] View own profile with all info
- [ ] Edit profile and save to Firestore
- [ ] Upload and update avatar
- [ ] Change settings (theme, notifications)
- [ ] View other users' profiles

### Stories
- [ ] Create story with image/video
- [ ] Stories auto-expire after 24 hours
- [ ] View stories from other users
- [ ] See who viewed own stories
- [ ] Delete stories before expiry

---

## 📞 CLARIFICATION QUESTIONS FOR USER

1. **Comments real-time**: Should comments update in real-time like chat, or page-based?
2. **Follower system**: Should we implement follow/unfollow functionality?
3. **Direct Messages**: Should profile have "Message" button for DMs?
4. **Notifications**: Should we send notifications for likes/comments?
5. **Search**: How important is search functionality (hashtags, users, posts)?
6. **Video requirements**: Max duration for videos? (e.g., 30s, 60s, unlimited)
7. **Moderation**: Should we flag/report inappropriate content?
8. **Comments nesting**: Just 1 level or deep threading?

---

## 📝 NOTES

- **Firestore** will handle all data persistence
- **Firebase Storage** for all media (avatars, post images/videos)
- **Riverpod** for all state management
- **Clean Architecture** maintained throughout
- **Real-time sync** via Firestore listeners (`.snapshots()`)
- **Offline support** via Firestore offline persistence
- **Security** via Firestore rules (server-side validation)

---

## 🎯 SUCCESS METRICS

- ✅ Chat messages send instantly (< 1 sec latency)
- ✅ Posts load within 2 seconds
- ✅ Likes update immediately (optimistic UI)
- ✅ No crashes on poor connectivity
- ✅ Zero unauthorized data access
- ✅ Stories expire automatically after 24 hours
- ✅ All features work on both iOS and Android

---

**NEXT STEP**: Review this specification and approve (or request changes) before implementation begins.

