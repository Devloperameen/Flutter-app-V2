# 🚀 Quick Start Guide

Get the app running in 5 minutes!

---

## 📦 Prerequisites

- **Flutter**: 3.13.0 or higher
- **Dart**: 3.1.0 or higher
- **Android SDK** or **Xcode** (for mobile builds)
- **Git**: For cloning the repository

---

## ⚡ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/Devloperameen/Flutter-app-V2.git
cd fitflow_gym
```

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Generate Code (Riverpod + Freezed)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the App
```bash
# On Android device/emulator
flutter run

# Or specify a device
flutter run -d <device-id>
```

---

## 🏃 Running on Your Device

### Android Device
```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -d R58X904CBJH

# Or just run on the first available device
flutter run
```

### Hot Reload (During Development)
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

---

## 🔨 Building APK

### Debug APK (for testing)
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk` (222 MB)

### Release APK (for production)
```bash
flutter build apk --release
```

---

## 🔧 Configure Firebase (If Needed)

1. Create a project at [Firebase Console](https://console.firebase.google.com)
2. Add Android app and download `google-services.json`
3. Place in: `android/app/google-services.json`
4. Enable Firestore and Authentication

---

## 📱 Backend API

The app connects to:
- **API URL**: `https://flutter-app-v2.onrender.com/api/v1`
- **Socket.IO**: Same endpoint (for real-time features)
- **Environment**: Production (Render deployment)

---

## 🧪 Run Tests
```bash
flutter test
```

---

## 🛠️ Development Commands

| Command | Purpose |
|---------|---------|
| `flutter analyze` | Check code for issues |
| `flutter format lib/` | Format code |
| `flutter clean` | Clean build cache |
| `flutter pub upgrade` | Update dependencies |
| `flutter pub get` | Get dependencies |

---

## 📋 Troubleshooting

**App crashes on launch?**
- Run `flutter clean && flutter pub get`
- Rebuild code: `flutter pub run build_runner build --delete-conflicting-outputs`

**Hot reload not working?**
- Press `R` (hot restart) or rebuild

**Device not found?**
- Run `flutter devices` to list connected devices
- Ensure USB debugging is enabled on Android

**Build fails?**
- Check Android SDK version compatibility
- Run `flutter doctor -v` to verify setup

---

## 📚 More Resources

- Full documentation: See `README.md`
- Flutter docs: [flutter.dev](https://flutter.dev)
- Riverpod docs: [riverpod.dev](https://riverpod.dev)

---

**Ready?** Run `flutter run` and enjoy! 🎉
