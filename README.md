# Talk with Sadiq 💬

> **Transform Your Mindset, Build Better Habits, Achieve Your Dreams**

A modern productivity & mindset transformation app built with Flutter. "Talk with Sadiq" helps young people develop strong habits, practice deep work, and achieve their goals through guided productivity techniques.

---

## 📱 App Overview

**Talk with Sadiq** is a mobile application designed to:
- 🎯 Transform mindsets and build lasting habits
- ⏱️ Practice Pomodoro deep work techniques
- 🎥 Access motivational content and learning resources
- 👥 Connect with a supportive community
- 📊 Track progress and celebrate wins

**Target**: Young people (13-25 years old) seeking mindset transformation and habit development

---

## ✨ Key Features

### 🏠 Modern Dashboard
- **Time-based Greeting**: Dynamic greeting based on time of day
- **Daily Progress Overview**: Track focus time, habits, and streaks
- **Auto-Rotating Video Carousel**: 5-second auto-rotate with manual swipe
- **Pomodoro Timer**: 25/50-minute focus sessions with Pause/Resume/End controls
- **Today's Habits**: Horizontal scrollable habit tracking
- **Daily Mission**: Task cards with progress indicators
- **Community Preview**: Recent community messages and discussions
- **Learning Resources**: Educational video library with real YouTube content
- **Weekly Statistics**: Focus time, habit completion, streaks, and XP
- **Quick Actions**: One-tap access to all main features
- **Motivational Quotes**: Auto-rotating inspirational quotes

### ⏱️ Deep Work Timer
- Customizable Pomodoro sessions (25/50 minutes)
- Pause, Resume, and End controls
- Real-time countdown display
- Completion notifications

### 👥 Community Features
- Real-time community chat powered by Socket.IO
- User-specific color coding for better distinction
- Post images and videos with MongoDB storage
- Like, share, and comment on posts
- Real-time updates across all connected clients

### 📊 Analytics & Progress
- Weekly focus time tracking
- Habit completion statistics
- Streak counting system
- XP/Points reward system

### 🔐 Authentication
- Express.js JWT token-based authentication
- Secure user sessions with token validation
- User profile management via REST API
- Role-based access control (Admin, User)

---

## 🏗️ Project Structure

```
fitflow_gym/
├── lib/
│   ├── core/                          # Core utilities and configuration
│   │   ├── design/                    # UI design system, colors, themes
│   │   ├── router/                    # Navigation and routing
│   │   ├── services/                  # External services and API integration
│   │   ├── security/                  # Input validation and security
│   │   ├── network/                   # API endpoints and networking
│   │   ├── errors/                    # Error handling
│   │   └── utils/                     # Logging and utilities
│   │
│   ├── features/                      # Feature modules
│   │   ├── auth/                      # Authentication feature
│   │   │   ├── domain/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   └── repositories/
│   │   │   └── presentation/
│   │   │       ├── providers/         # Riverpod state management
│   │   │       └── screens/
│   │   │
│   │   ├── dashboard/                 # Dashboard & home screen
│   │   │   ├── domain/
│   │   │   │   └── models/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   └── repositories/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       └── screens/
│   │   │           └── dashboard_screen_simple.dart (MAIN)
│   │   │
│   │   ├── community/                 # Community chat & posts
│   │   │   ├── domain/
│   │   │   │   └── models/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   └── repositories/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── habits/                    # Habit tracking feature
│   │   ├── profile/                   # User profile management
│   │   ├── analytics/                 # Progress analytics
│   │   └── focus_timer/               # Focus timer feature
│   │
│   ├── main.dart                      # App entry point
│   └── app.dart                       # App configuration
│
├── pubspec.yaml                       # Dependencies
├── analysis_options.yaml              # Lint rules
├── android/                           # Android native code
├── ios/                               # iOS native code
└── README.md                          # This file
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.13.0 or higher
- Dart 3.1.0 or higher
- Android SDK / Xcode for mobile builds

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Devloperameen/Flutter-app.git
   cd fitflow_gym
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # For Android
   flutter run -d R58X904CBJH --debug
   
   # Or on any connected device
   flutter run
   ```

### Build Production APK
```bash
flutter build apk --target-platform android-arm64 --release
```

---

## 🏛️ Architecture

This project follows **Clean Architecture** principles with **Riverpod** for state management:

- **Domain Layer**: Business logic and entities (models, repositories interfaces)
- **Data Layer**: Data sources (Express REST API) and repository implementations
- **Presentation Layer**: UI components, screens, and providers (Riverpod)

### State Management
- **Riverpod**: For reactive state management and dependency injection
- **ConsumerStatefulWidget**: For widget-level state
- **AsyncValue**: For handling async operations (loading, error, data)

### Data Source
- **Express.js**: RESTful API backend
- **MongoDB**: NoSQL database for user data, habits, posts, and missions
- **Socket.IO**: Real-time communication for community chat and notifications

---

## 📚 Key Technologies

| Technology | Purpose |
|-----------|---------|
| **Flutter 3.13+** | Cross-platform UI framework |
| **Dart 3.1+** | Programming language |
| **Riverpod 2.x** | State management & DI |
| **Express.js** | RESTful API backend |
| **MongoDB** | NoSQL database |
| **Socket.IO** | Real-time communication |
| **url_launcher** | Open URLs and apps |
| **share_plus** | Share functionality |
| **emoji_picker_flutter** | Emoji selector |
| **intl** | Internationalization |

---

## 🎨 UI/UX Design

### Color Scheme
- **Primary Blue**: #2196F3
- **Dark Blue**: #1976D2
- **Light Blue**: #64B5F6
- **Follows Material Design 3** with light/dark theme support

### Typography
- Modern, clean sans-serif fonts
- Proper hierarchy and spacing
- Accessible text sizes

### Animations
- Smooth 500-800ms transitions
- Gradient backgrounds
- Shadow effects for depth

---

## 📋 Features in Detail

### Dashboard (Main Screen)
✅ Header with time-based greeting  
✅ Daily progress overview with stats  
✅ Auto-rotating video carousel (5-second interval)  
✅ Pomodoro deep work timer (25/50 minutes)  
✅ Today's habits tracking  
✅ Daily mission card  
✅ Community chat preview  
✅ Learning resources (YouTube videos)  
✅ Weekly statistics  
✅ Quick action buttons  
✅ Motivational quote section  

### Community Chat
✅ Real-time Socket.IO integration  
✅ Color-coded user messages  
✅ Post images and videos  
✅ Message timestamps  
✅ Like, share, and comment features  

### Timer
✅ 25/50-minute Pomodoro  
✅ Pause/Resume/End controls  
✅ Real-time countdown  
✅ Completion notifications  

---

## 🔧 Configuration

### Backend Setup
1. Backend is already deployed on **Render**: https://flutter-app-v2.onrender.com/api/v1
2. Uses **MongoDB** for data persistence
3. **Socket.IO** for real-time features (community chat, notifications)

### For Local Development (Optional)
1. Clone backend repository
2. Setup MongoDB locally
3. Configure `.env` file with database credentials
4. Run: `npm start`

**Default Backend**: The app is pre-configured to use the production backend on Render. No local setup required for testing.

---

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📈 Future Enhancements

- [ ] Offline mode with local caching
- [ ] Advanced analytics dashboard
- [ ] Social features (followers, mentions)
- [ ] Notification system
- [ ] Video call integration
- [ ] Export progress reports
- [ ] Gamification system (badges, leaderboards)

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 Code Standards

- Follow Dart's style guide
- Use meaningful variable names
- Add comments for complex logic
- Run `flutter analyze` before committing
- Format code with `flutter format`

---

## 🐛 Known Issues

- None currently. Please report bugs via GitHub Issues.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👨‍💻 Developer

**Sadiq Ferej**  
Mindset Coach & App Developer  
Transforming young minds through technology

---

## 🙏 Acknowledgments

- Flutter and Dart communities
- Express.js and MongoDB communities
- Material Design for UI guidelines
- Socket.IO for real-time communication
- All open-source contributors

---

## 📞 Contact & Support

For questions, support, or feedback:
- GitHub: [@Devloperameen](https://github.com/Devloperameen)
- Repository: [Flutter-app](https://github.com/Devloperameen/Flutter-app)

---

**Last Updated**: August 9, 2026  
**Current Version**: 1.0.0  
**Status**: ✅ Production Ready
