# FitFlow Gym - Flutter Fitness App

A comprehensive fitness tracking Flutter application with Firebase integration.

## Features

- **Dashboard**: Track your fitness stats, XP, level, and streaks
- **Habits**: Create and manage daily fitness habits
- **Focus Timer**: Pomodoro-style timer for workout sessions
- **Community**: Chat with other users and share posts
- **Missions**: Complete fitness challenges and earn XP

## Tech Stack

- **Flutter**: Cross-platform mobile framework
- **Firebase**: 
  - Authentication
  - Firestore Database
  - Firebase Storage
- **Riverpod**: State management
- **Clean Architecture**: Feature-based modular structure

## Project Structure

```
lib/
├── core/           # Core utilities, themes, and widgets
├── features/       # Feature modules (auth, dashboard, habits, community)
└── main.dart       # App entry point
```

## Setup

1. Clone the repository
2. Install Flutter dependencies: `flutter pub get`
3. Configure Firebase (see Firebase Setup below)
4. Run the app: `flutter run`

## Firebase Setup

This app requires a Firebase project with:
- Authentication enabled (Email/Password)
- Firestore database with collections: `users`, `habits`, `focusSessions`, `missions`, `community`, `dashboard_stats`, `quotes`, `community_chat`
- Security rules configured for authenticated users

**Note**: `google-services.json` is gitignored for security. You'll need to add your own Firebase configuration files.

## Building

- Debug build: `flutter build apk --debug`
- Release build: `flutter build apk --release`

## License

This project is for educational purposes.
