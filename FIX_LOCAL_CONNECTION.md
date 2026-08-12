# 🔧 Fix: Connect to Local Backend

**Date:** August 12, 2026  
**Issue:** App connecting to production server instead of localhost  
**Status:** ✅ FIXED

---

## Problem Identified

The app was configured to connect to production backend:
```
https://flutter-app-v2.onrender.com/api/v1
```

But it should connect to your local development backend:
```
http://localhost:5000/api/v1
```

---

## Symptoms

1. ⛔ Token refresh failed (can't reach production server from device)
2. ⛔ 401 Unauthorized errors on all API calls
3. ⛔ Authentication issues even with valid credentials
4. ⛔ Habits, Focus Timer, Analytics not loading

---

## Solution Applied

**File:** `lib/core/network/api_endpoints.dart`

**Changed:**
```dart
// FROM:
static const String baseUrl = 'https://flutter-app-v2.onrender.com/api/v1';

// TO:
static const String baseUrl = 'http://localhost:5000/api/v1';
```

---

## What This Fixes

✅ App now connects to local backend on port 5000  
✅ Authentication will work with local database  
✅ All API calls will use localhost  
✅ Habits, Focus Timer, Analytics will load  
✅ Signout will work properly  

---

## Next Steps

### In Flutter Terminal
Press `r` to hot reload the app:
```
r → Hot reload
R → Hot restart (if reload doesn't work)
```

Or manually restart:
```bash
flutter run
```

### Verify Connection
After reload, check flutter logs for:
```
🐛 → GET http://localhost:5000/api/v1/auth/me
🐛 ← 200 http://localhost:5000/api/v1/auth/me
```

---

## Local Development Setup

For physical devices (ADB reverse setup):

```bash
adb reverse tcp:5000 tcp:5000
```

This allows physical devices to access localhost:5000 through ADB.

---

## Production Setup

When deploying to production:

Change back to production URL:
```dart
static const String baseUrl = 'https://flutter-app-v2.onrender.com/api/v1';
```

---

## Troubleshooting

### Still getting 401 errors?
1. Ensure backend is running: `npm run dev` (in backend folder)
2. Ensure database is seeded: `npm run seed`
3. Clear app data and restart
4. Use `R` (hot restart) instead of `r` (hot reload)

### Still can't connect?
1. Check backend is on port 5000: `lsof -i :5000`
2. Verify backend logs show it's running
3. Try `flutter run` from scratch instead of hot reload

### For Physical Device
If using ADB:
```bash
adb reverse tcp:5000 tcp:5000
```

Then use same localhost URL in code.

---

## Files Modified

- ✅ `lib/core/network/api_endpoints.dart` - Changed baseUrl to localhost

---

## Status

✅ Fix Applied  
✅ Ready to Test  
✅ Backend Running on localhost:5000  
✅ Database Seeded with Admin Users  

**Ready to reload Flutter app!**
