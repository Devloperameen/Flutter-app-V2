# 🖥️ Terminal Setup Guide

**Status:** Port 5000 freed, ready to proceed

---

## ✅ Current Situation

Port 5000 was in use from previous `npm start` command. It has been freed.
You are now ready to start fresh.

---

## 🔧 Proper Setup (3 Terminals)

### Terminal 1: Backend Server (KEEP RUNNING)

```bash
cd ~/FlutterProjects/fitflow_gym/backend
npm run dev
```

**Expected Output:**
```
[nodemon] 3.1.14
[nodemon] to restart at any time, enter `rs`
[nodemon] watching path(s): *.*
[nodemon] starting `node server.js`
✅ Socket.IO configured with WebSocket support
✅ Database connected
✅ Connected to MongoDB
```

**Status:** ✅ READY (backend running, can be reloaded with `rs`)

---

### Terminal 2: Flutter App (NEW TERMINAL)

Once Terminal 1 is running, open a **NEW** terminal and run:

```bash
cd ~/FlutterProjects/fitflow_gym
flutter run
```

**Expected Output:**
```
Launching lib/main.dart on SM A155F in debug mode...
Running Gradle task 'assembleDebug'...
✅ App running on device
```

**Status:** ✅ READY (when Terminal 1 is running)

---

### Terminal 3: Optional Commands

Available for manual testing, debugging, seed scripts, etc.

```bash
# Run seed script
npm run seed

# Check logs
flutter logs

# Other debugging commands
```

---

## ⚠️ Important Notes

### DO NOT
- ❌ Run Flutter and Backend in the same terminal
- ❌ Stop the backend server while testing
- ❌ Run `flutter run` before backend is started

### DO
- ✅ Keep Terminal 1 (backend) running throughout testing
- ✅ Use separate terminals for backend and frontend
- ✅ Start backend FIRST, then Flutter
- ✅ Let hot reload work (press `r` in Flutter terminal)

---

## 🚀 Quick Start (3 Commands in 3 Terminals)

### Terminal 1
```bash
cd ~/FlutterProjects/fitflow_gym/backend && npm run dev
```

### Terminal 2 (Wait for Terminal 1 to fully start first)
```bash
cd ~/FlutterProjects/fitflow_gym && flutter run
```

### Terminal 3
```bash
# Available for other commands
```

---

## 📱 Login Credentials

When app launches and shows login screen:

```
Email:    superadmin@fitflow.com
Password: SuperAdmin@2024!Fit
```

---

## ✅ Verification Checklist

### Backend Terminal Shows
- [ ] `✅ Socket.IO configured`
- [ ] `✅ Database connected`
- [ ] `✅ Connected to MongoDB`
- [ ] `✅ Listening on port 5000` (if npm start)

### Flutter Terminal Shows
- [ ] `✅ app running on device`
- [ ] Login screen displays
- [ ] Can enter credentials

### In App
- [ ] Login successful
- [ ] Dashboard loads with real data
- [ ] Can navigate to other screens
- [ ] Admin button visible (for superadmin)

---

## 🔧 Troubleshooting

### Port 5000 Still in Use
```bash
lsof -i :5000 | grep -v COMMAND | awk '{print $2}' | xargs kill -9
npm run dev
```

### Flutter Won't Compile
```bash
flutter clean
flutter pub get
flutter run
```

### Backend Crashes
Check error message, usually one of:
- Missing MongoDB connection
- Socket.io not installed
- Invalid environment variables

### Hot Reload Not Working
Press `r` in Flutter terminal to manually reload

---

## 📊 Development Workflow

1. **Start Backend**
   - Terminal 1: `npm run dev`
   - Keep running throughout development

2. **Launch Frontend**
   - Terminal 2: `flutter run` (after backend fully starts)
   - App shows on device

3. **Make Changes**
   - Edit code in IDE
   - Hot reload automatically (or press `r`)
   - Backend auto-restarts with nodemon on file changes

4. **Test**
   - Use app on device
   - Check Terminal 1 for backend logs
   - Check Terminal 2 for Flutter logs

5. **Deploy**
   - When ready: `flutter build apk --release`
   - Backend: `npm start` (production mode)

---

## ✅ Everything Ready

- Backend code: ✅ Ready
- Database: ✅ Connected & Seeded
- Frontend code: ✅ Ready (0 errors)
- Credentials: ✅ Ready
- Dependencies: ✅ Installed

**Ready to proceed with Terminal setup!**
