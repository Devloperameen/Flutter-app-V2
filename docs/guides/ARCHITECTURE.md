# Architecture Overview

## Technology Stack

- **Frontend:** Flutter (Dart)
- **State Management:** Riverpod (async)
- **HTTP Client:** Dio
- **Real-time:** Socket.IO
- **Local Storage:** Secure Storage
- **Architecture:** Repository Pattern

## Project Structure

```
lib/
├── core/
│   ├── design/              # UI design system
│   ├── network/             # HTTP, API endpoints
│   ├── providers/           # Global Riverpod providers
│   ├── router/              # Navigation
│   ├── storage/             # Local storage
│   └── utils/               # Helpers, logger
│
├── features/
│   ├── auth/                # Login, registration
│   ├── profile/             # User profile
│   ├── focus_timer/         # Focus sessions
│   ├── community/           # Chat, posts
│   ├── habits/              # Habit tracking
│   └── [other features]/
│
├── app.dart                 # Main app widget
└── bootstrap.dart           # App initialization

android/                      # Android native code
ios/                         # iOS native code
web/                         # Web support
backend/                     # Backend API (Express.js)
```

## Data Flow

```
UI (Widget)
   ↓
Provider/Riverpod (State management)
   ↓
Repository (Business logic)
   ↓
Datasource (HTTP/Socket.IO)
   ↓
Backend API
```

## Key Providers

### Authentication
- `authNotifierProvider` - Current user state
- `authRepositoryProvider` - Login, register, logout

### Community
- `chatMessagesStreamProvider` - Real-time chat messages
- `communityPostsStreamProvider` - Real-time posts
- `chatNotifierProvider` - Send/delete messages

### Focus Timer
- `activeFocusSessionProvider` - Current session
- `focusDailyStatsProvider` - Today's stats
- `createFocusSessionProvider` - Create new session

### Profile
- `userProfileProvider` - User info stream

## State Management Pattern

### AsyncValue Pattern
```dart
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  FutureOr<MyData> build() async {
    return await repository.fetchData();
  }

  Future<void> updateData(MyData data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.update(data));
  }
}
```

### Stream Pattern
```dart
@riverpod
Stream<List<Item>> itemsStream(ItemsStreamRef ref) {
  final repository = ref.watch(repositoryProvider);
  return repository.watchItems();
}
```

## Error Handling

All operations have try-catch with:
- User-friendly error messages (SnackBar)
- Logging for debugging (app_logger)
- Proper state rollback
- Network error detection

Example:
```dart
try {
  await repository.delete(id);
  if (mounted) showSnackBar('Deleted successfully');
} catch (e) {
  log.e('Failed to delete: $e');
  if (mounted) showSnackBar('Error: $e');
}
```

## Backend Integration

### Base URL
```
Production: https://flutter-app-v2.onrender.com
API: /api/v1/[endpoint]
```

### Socket.IO
- Real-time chat/posts updates
- WebSocket transport with polling fallback
- Automatic reconnection
- JWT authentication

### HTTP Endpoints
- Auth: `/auth/login`, `/auth/register`, `/auth/profile`
- Posts: `/community/posts`, `/community/comments`
- Chat: `/community/chat`
- Focus: `/focus-sessions`

---

**All components are production-ready and tested.**

