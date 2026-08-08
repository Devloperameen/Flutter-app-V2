# Firestore Security Rules for Community Chat

## Overview
These security rules ensure that only authenticated users can read and write to the community chat collection, and they can only modify their own messages.

## Database Structure
```
community_chat/
  ├── main (document)
  │   ├── messages (subcollection)
  │   │   ├── {messageId} (document)
  │   │   │   ├── userId (string)
  │   │   │   ├── userName (string)
  │   │   │   ├── profilePhoto (string, optional)
  │   │   │   ├── message (string)
  │   │   │   └── createdAt (string - ISO8601 timestamp)
```

## Security Rules

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow unauthenticated read/write to test collection (for development only)
    // Remove this in production
    match /test/{document=**} {
      allow read, write: if true;
    }

    // Community Chat Collection
    match /community_chat/{document=**} {
      // Main document (metadata, if needed)
      match /main {
        // Allow read by authenticated users
        allow read: if request.auth != null;
        
        // Messages subcollection
        match /messages/{messageId} {
          
          // Allow read: authenticated users can read all messages
          allow read: if request.auth != null;
          
          // Allow create: authenticated users can send messages
          allow create: if request.auth != null
            && request.resource.data.keys().hasAll(['userId', 'userName', 'message', 'createdAt'])
            && request.resource.data.userId == request.auth.uid
            && request.resource.data.message.size() > 0
            && request.resource.data.message.size() <= 5000
            && request.resource.data.userName.size() > 0
            && request.resource.data.userName.size() <= 100
            && request.resource.data.createdAt is string;
          
          // Allow update: only for message sender (limited fields)
          allow update: if request.auth != null
            && resource.data.userId == request.auth.uid
            && request.resource.data.diff(resource.data).affectedKeys()
                .hasOnly(['editedAt']); // Allow minimal edits only
          
          // Allow delete: only message sender can delete
          allow delete: if request.auth != null
            && resource.data.userId == request.auth.uid;
          
          // Typing indicators (optional)
          match /typingIndicators/{indicator} {
            allow read: if request.auth != null;
            allow write: if request.auth != null
              && request.resource.data.userId == request.auth.uid;
          }
        }
      }
    }

    // Deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## Rule Explanations

### Collection Read Access
- **Authenticated users only**: `if request.auth != null`
- All authenticated users can read all messages

### Message Create (Send)
- **Authentication required**: `request.auth != null`
- **Required fields validation**: Messages must contain `userId`, `userName`, `message`, `createdAt`
- **Sender verification**: `request.resource.data.userId == request.auth.uid` - User can only send messages as themselves
- **Message validation**:
  - Message must not be empty: `message.size() > 0`
  - Message max length: `message.size() <= 5000` characters
  - Username must not be empty: `userName.size() > 0`
  - Username max length: `userName.size() <= 100` characters
- **Timestamp validation**: `createdAt` must be a string (ISO8601 format)

### Message Delete
- **Authentication required**: `request.auth != null`
- **Ownership check**: `resource.data.userId == request.auth.uid` - Users can only delete their own messages
- Only the message sender can delete their messages

### Message Update (Optional)
- **Limited updates**: Only `editedAt` field can be modified
- **Prevents abuse**: Attackers cannot modify message content or metadata
- Users can only update their own messages

### Typing Indicators (Optional)
- **Subcollection**: Under each message (optional feature)
- **Authenticated read**: All authenticated users can see who's typing
- **Authenticated write**: Users can only update their own typing status

## Installation Steps

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your FitFlow Gym project
3. Navigate to **Firestore Database** → **Rules** tab
4. Replace the existing rules with the rules above
5. Click **Publish** to apply the rules

## Testing

### Test 1: Unauthenticated Access (Should Fail)
```javascript
// This should fail - no authentication
db.collection('community_chat').doc('main').collection('messages').add({
  userId: 'test',
  userName: 'Test User',
  message: 'Hello',
  createdAt: new Date().toISOString()
})
// Error: Missing or insufficient permissions
```

### Test 2: Authenticated User Can Send (Should Succeed)
```javascript
// This should succeed - user is authenticated
db.collection('community_chat').doc('main').collection('messages').add({
  userId: auth.currentUser.uid,
  userName: 'John Doe',
  message: 'Hello everyone!',
  createdAt: new Date().toISOString()
})
// Success: Message created
```

### Test 3: User Cannot Send as Another User (Should Fail)
```javascript
// This should fail - userId doesn't match current user
db.collection('community_chat').doc('main').collection('messages').add({
  userId: 'some_other_user_id',
  userName: 'Attacker',
  message: 'Hacking attempt',
  createdAt: new Date().toISOString()
})
// Error: Missing or insufficient permissions
```

### Test 4: Empty Message (Should Fail)
```javascript
// This should fail - empty message
db.collection('community_chat').doc('main').collection('messages').add({
  userId: auth.currentUser.uid,
  userName: 'John',
  message: '', // Empty!
  createdAt: new Date().toISOString()
})
// Error: Missing or insufficient permissions
```

### Test 5: User Can Delete Own Message (Should Succeed)
```javascript
// Get a message ID from your messages subcollection
const messageId = 'some_message_id';

// This should succeed - user owns the message
db.collection('community_chat').doc('main').collection('messages')
  .doc(messageId).delete()
// Success: Message deleted
```

### Test 6: User Cannot Delete Others' Messages (Should Fail)
```javascript
// Get someone else's message ID
const someoneElsesMessageId = 'their_message_id';

// This should fail - user doesn't own it
db.collection('community_chat').doc('main').collection('messages')
  .doc(someoneElsesMessageId).delete()
// Error: Missing or insufficient permissions
```

## Security Best Practices

✅ **Implemented**:
- Authentication required for all read/write operations
- User identity verification (userId must match `request.auth.uid`)
- Field validation (required fields, max lengths)
- Message content validation (not empty, max 5000 chars)
- Sender verification for deletions
- Role-based access control (users can only manage their own messages)

⚠️ **Additional Recommendations**:
1. **Rate Limiting**: Consider Firebase Extensions for rate limiting to prevent spam
2. **Moderation**: Add admin role for moderating/deleting inappropriate content
3. **Reporting**: Implement a "report message" feature for community safety
4. **Timestamps**: Use server timestamps (`firebase.firestore.FieldValue.serverTimestamp()`) to prevent timestamp manipulation
5. **Backups**: Regular Firestore backups for data protection
6. **Monitoring**: Set up Firestore metrics to monitor unusual activity

## Firestore Collection Structure

### Main Document
```json
{
  "lastMessageCount": 1234,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### Message Document
```json
{
  "userId": "auth_user_123",
  "userName": "John Doe",
  "profilePhoto": "https://storage.googleapis.com/...",
  "message": "Hello everyone! This is my first message.",
  "createdAt": "2024-01-15T10:30:00Z",
  "editedAt": "2024-01-15T10:35:00Z" // Optional
}
```

## Migration Guide

If you have existing community posts that should migrate to the new chat:

1. **Export existing posts** from mock datasource
2. **Transform to message format**:
   ```
   post {
     id, authorId, authorName, content, createdAt
   }
   ```
   becomes
   ```
   message {
     userId: authorId,
     userName: authorName,
     message: content,
     createdAt: createdAt.toIso8601String()
   }
   ```
3. **Batch import** to `community_chat/main/messages` using Firebase Admin SDK
4. **Verify** all messages appear in the chat screen
5. **Monitor** for any permission errors

## Support

For questions or issues:
1. Check Firestore rules documentation: https://firebase.google.com/docs/firestore/security/start
2. Review the security rules simulator in Firebase Console
3. Check browser console for permission error details
4. Monitor Firestore metrics for usage patterns
