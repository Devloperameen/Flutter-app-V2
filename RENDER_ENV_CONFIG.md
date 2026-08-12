# ✅ Render Environment Variables - Complete Configuration Guide

**Status**: Your current Render config is MOSTLY correct, but needs small fixes

---

## 📊 Current Render Variables (From Your Screenshot)

| Variable | Current Value | Status | Action |
|----------|---------------|--------|--------|
| `API_VERSION` | v1 | ✅ Correct | No change |
| `CORS_ORIGIN` | http://localhost:3001,... | ⚠️ Wrong | **NEEDS FIX** |
| `JWT_ACCESS_EXPIRY` | 15m | ✅ Correct | No change |
| `JWT_REFRESH_EXPIRY` | 7d | ✅ Correct | No change |
| `JWT_REFRESH_SECRET` | dev-refresh-secret-... | ✅ Correct | No change |
| `JWT_SECRET` | dev-jwt-secret-... | ✅ Correct | No change |
| `LOG_LEVEL` | info | ✅ Correct | No change |
| `MONGODB_URI` | [your connection string] | ✅ Correct | No change |
| `NODE_ENV` | development | ⚠️ Should be production | **NEEDS FIX** |

---

## 🔴 Issues Found

### Issue 1: CORS_ORIGIN Wrong
**Current**: `http://localhost:3001,http://localhost:8080,http://localhost:*`
**Should be**: `*` (for production) OR specific domain

**Why it matters**: 
- Flutter app is trying to call backend
- CORS header mismatch causes 404 errors
- Localhost entries don't work on production

### Issue 2: NODE_ENV Wrong
**Current**: `development`
**Should be**: `production`

**Why it matters**:
- Development mode has different logging
- Production mode enables strict CORS
- Affects error handling and security headers

### Issue 3: Missing Socket.IO Configuration
**Current**: Not configured
**Should add**: `SOCKET_IO_CORS` (if needed)

---

## ✅ Correct Render Configuration

Go to https://dashboard.render.com and update these variables:

### Step 1: Fix CORS_ORIGIN
```
KEY:   CORS_ORIGIN
VALUE: *
```

**OR** (if you want to restrict):
```
VALUE: https://flutter-app-v2.onrender.com
```

### Step 2: Fix NODE_ENV
```
KEY:   NODE_ENV
VALUE: production
```

### Step 3: Verify Other Variables
```
API_VERSION = v1
JWT_SECRET = dev-jwt-secret-key-for-testing-only-change-in-production
JWT_REFRESH_SECRET = dev-refresh-secret-key-for-testing-only-change-in-production
JWT_ACCESS_EXPIRY = 15m
JWT_REFRESH_EXPIRY = 7d
LOG_LEVEL = info
MONGODB_URI = mongodb+srv://habittracking:G1HDEewgMJXCo5qn@habittrucking.rjzolku.mongodb.net/fitflow?retryWrites=true&w=majority
```

### Step 4: Optional - Add Socket.IO Logging (for debugging)
```
KEY:   SOCKET_IO_LOG_LEVEL
VALUE: debug
```

---

## 🔧 How to Update Variables on Render

1. Go to https://dashboard.render.com
2. Select **"flutter-app-v2"** service
3. Scroll down to **"Environment"** section
4. Click **"Edit"** next to the variable
5. Change the value
6. Click **"Save"**
7. Render will automatically redeploy

**Wait**: ~30 seconds for each variable change to apply

---

## 📋 Complete Render Environment Setup

Here's the COMPLETE list of variables your Render service should have:

```
API_VERSION = v1
CORS_ORIGIN = *
JWT_ACCESS_EXPIRY = 15m
JWT_REFRESH_EXPIRY = 7d
JWT_REFRESH_SECRET = dev-refresh-secret-key-for-testing-only-change-in-production
JWT_SECRET = dev-jwt-secret-key-for-testing-only-change-in-production
LOG_LEVEL = info
MONGODB_URI = mongodb+srv://habittracking:G1HDEewgMJXCo5qn@habittrucking.rjzolku.mongodb.net/fitflow?retryWrites=true&w=majority
NODE_ENV = production
PORT = [Leave BLANK - Render auto-assigns]
```

---

## 🎯 Socket.IO Configuration

Socket.IO is configured in **`backend/server.js`** and **`backend/src/core/providers/socket_provider.dart`**

### Backend Socket.IO Setup (Already Correct)
```javascript
// In server.js, Socket.IO is configured with:
io.OptionBuilder()
    .setTransports(['websocket', 'polling']) // ✅ Both enabled
    .setPath('/socket.io/') // ✅ Correct path
    .setExtraHeaders({...}) // ✅ Auth headers
```

### Frontend Socket.IO Setup (Already Correct)
```dart
// In socket_provider.dart:
const String socketUrl = 'https://flutter-app-v2.onrender.com';
io.OptionBuilder()
    .setTransports(['websocket', 'polling'])
    .setPath('/socket.io/')
    .setReconnectionAttempts(5)
```

**Status**: ✅ Socket.IO is correctly configured - NO CHANGES NEEDED

---

## ⚠️ Why You're Getting 404 Errors

Even with correct env vars, you were still getting 404s because:

1. **OLD CODE** was deployed on Render
2. **NEW CODE** fixes weren't deployed yet
3. Env vars are correct, just the deployed code was old

**Solution**: Push code to Git and redeploy (as in previous instructions)

---

## 🔍 Verification Checklist

After updating Render env vars:

- [ ] CORS_ORIGIN changed to `*`
- [ ] NODE_ENV changed to `production`
- [ ] Render is redeploying (check Events tab)
- [ ] Deployment shows green checkmark
- [ ] Test: `curl https://flutter-app-v2.onrender.com/health`
  - Should return `{"status":"OK",...}`
- [ ] Test: Login in Flutter app
  - Should succeed with super admin credentials

---

## 🚀 Quick Fix Checklist

```bash
BEFORE pushing code:

☐ Go to https://dashboard.render.com
☐ Select "flutter-app-v2"
☐ Go to Environment section
☐ Change CORS_ORIGIN = *
☐ Change NODE_ENV = production
☐ Save changes (auto-redeploy)
☐ Wait 1-2 minutes
☐ Then proceed with git push and manual deploy
```

---

## 📊 Environment Variables Explained

### JWT Variables
- `JWT_SECRET` - Used to sign/verify access tokens
- `JWT_REFRESH_SECRET` - Used to sign/verify refresh tokens
- `JWT_ACCESS_EXPIRY` - How long access token lasts (15m = 15 minutes)
- `JWT_REFRESH_EXPIRY` - How long refresh token lasts (7d = 7 days)

### Database
- `MONGODB_URI` - Connection string to MongoDB Atlas
- Format: `mongodb+srv://username:password@cluster.mongodb.net/dbname?params`

### CORS
- `CORS_ORIGIN` - Which domains can access this backend
- `*` = Allow ALL origins (good for development/testing)
- Specific domain = Only that domain (good for production)

### Node.js
- `NODE_ENV` - Environment mode (development vs production)
- `development` = More logging, less strict CORS
- `production` = Strict CORS, strict error handling

### Logging
- `LOG_LEVEL` - How much logging to show
- `debug` = Very detailed
- `info` = Normal (recommended)
- `error` = Only errors

### API
- `API_VERSION` - API prefix (v1, v2, etc.)

---

## ✅ Final Configuration for Render

Copy this exact configuration:

```
API_VERSION=v1
CORS_ORIGIN=*
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d
JWT_REFRESH_SECRET=dev-refresh-secret-key-for-testing-only-change-in-production
JWT_SECRET=dev-jwt-secret-key-for-testing-only-change-in-production
LOG_LEVEL=info
MONGODB_URI=mongodb+srv://habittracking:G1HDEewgMJXCo5qn@habittrucking.rjzolku.mongodb.net/fitflow?retryWrites=true&w=majority
NODE_ENV=production
```

---

## 🎯 Next Steps

1. **Update Render env vars** (5 minutes)
   - CORS_ORIGIN = `*`
   - NODE_ENV = `production`

2. **Push code to Git** (1 minute)
   ```bash
   git add -A && git commit -m "Fix backend" && git push origin main
   ```

3. **Redeploy on Render** (5 minutes)
   - Manual Deploy → Deploy latest commit

4. **Test in app** (2 minutes)
   - Login with super admin
   - Check Community posts

---

## 🔧 Socket.IO Specific

**Question**: Do I need to add Socket.IO env vars?

**Answer**: ✅ **NO** - Socket.IO is configured in code, not env vars

Socket.IO settings:
- Transport: WebSocket + Polling ✅
- Path: `/socket.io/` ✅
- CORS: Inherits from app CORS settings ✅
- Auto-reconnect: Enabled ✅

No additional configuration needed!

---

## ❓ Still Getting 404?

If after updating env vars and redeploying you still see 404:

1. **Clear browser cache** (or reinstall app)
   ```bash
   flutter clean && flutter build apk --debug
   ```

2. **Check Render logs**
   - Go to Render dashboard
   - Click "Logs" tab
   - Look for errors

3. **Verify MongoDB connection**
   - Check if MONGODB_URI is correct
   - Test locally: `node scripts/check-super-admin.js`

4. **Check deployment status**
   - Go to "Events" tab
   - Should show green checkmark on latest deploy

---

**Status**: ✅ Environment configuration guide complete  
**Action**: Update CORS_ORIGIN and NODE_ENV on Render  
**Expected Result**: 404 errors will be gone after deployment
