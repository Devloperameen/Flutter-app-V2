# ✅ Using Deployed Backend (Production)

**Status:** Changed to production backend  
**URL:** https://flutter-app-v2.onrender.com/api/v1

---

## Why This Change

Your local backend wasn't running, causing "Connection refused" errors. The app now connects to the deployed production backend instead.

---

## Change Applied

**File:** `lib/core/network/api_endpoints.dart`

```dart
// Changed FROM:
static const String baseUrl = 'http://localhost:5000/api/v1';

// Changed TO:
static const String baseUrl = 'https://flutter-app-v2.onrender.com/api/v1';
```

---

## What to Do Now

### 1. Hot Restart Flutter App

In your Flutter terminal, press:
```
R
```

(Capital R - full restart with new backend URL)

### 2. Login

Use your existing credentials or the admin account:

```
Email:    superadmin@fitflow.com  (if exists on deployed server)
Password: SuperAdmin@2024!Fit
```

Or use an account you registered earlier:
```
Email:    eman@gmail.com  (or your registered email)
Password: (your password)
```

---

## Expected Result

✅ App connects to deployed backend  
✅ Authentication works  
✅ Habits load  
✅ Focus timer works  
✅ Analytics loads  
✅ All features functional  

---

## Logs Should Show

```
🐛 → POST https://flutter-app-v2.onrender.com/api/v1/auth/login
🐛 ← 200 https://flutter-app-v2.onrender.com/api/v1/auth/login
```

---

## If Login Still Fails

Check if:
1. The deployed backend is up (visit https://flutter-app-v2.onrender.com)
2. Your credentials are correct
3. Try registering a new account on the deployed version
4. Check Render dashboard if backend is sleeping

---

## To Switch Back to Local Backend Later

Change baseUrl back to:
```dart
static const String baseUrl = 'http://localhost:5000/api/v1';
```

And make sure your local backend is running:
```bash
npm run dev
```

---

**Status:** Ready to test with deployed backend ✅
