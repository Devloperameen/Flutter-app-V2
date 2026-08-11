# 🔐 Authentication Troubleshooting Guide

## Common Errors and Solutions

### 1. **409 Conflict - User Already Exists**

**Error Message:**
```
Registration failed
User with this email already exists
```

**Cause:** You're trying to register with an email that's already in the database.

**Solution:**
- ✅ Use a different email address
- ✅ Try with a new email: `test+timestamp@example.com`
- ✅ Or request password reset for the existing account

---

### 2. **422 Validation Error - Password Requirements**

**Error Message:**
```
Password must be at least 8 characters
```

**Cause:** Backend password policy requires:
- ✅ Minimum 8 characters
- ✅ Contains uppercase letter (A-Z)
- ✅ Contains lowercase letter (a-z)  
- ✅ Contains number (0-9)

**Example Valid Passwords:**
- `MyPassword123`
- `SecurePass99`
- `Test@Pass1`

**Invalid Passwords:**
- `password123` ❌ (no uppercase)
- `PASSWORD123` ❌ (no lowercase)
- `Pass123` ❌ (only 7 chars)
- `Test123` ❌ (only 7 chars)

---

### 3. **401 Unauthorized - Invalid Email or Password**

**Error Message:**
```
Invalid email or password
Login failed
```

**Cause:** Email doesn't exist OR password is incorrect.

**Solution:**
- ✅ Check email spelling
- ✅ Verify password is correct
- ✅ Use "Forgot Password" if you don't remember
- ℹ️ We don't tell you which one is wrong for security reasons

---

### 4. **403 Forbidden - Account Disabled**

**Error Message:**
```
Your account has been disabled
```

**Cause:** Your account has been suspended by admin.

**Solution:**
- 📧 Contact support to re-enable account
- ℹ️ Reason for suspension can be requested from admin

---

### 5. **500 Internal Server Error - Backend Issue**

**Error Message:**
```
Registration failed
500 Internal Server Error
```

**Cause:** Backend server is experiencing issues.

**Solution:**
- ✅ Check if backend is online: `curl https://flutter-app-v2.onrender.com/health`
- ✅ If 502/503, backend might be restarting (wait 2-3 minutes)
- 📧 If problem persists, check server logs on Render dashboard

---

### 6. **Network Error - Can't Reach Backend**

**Error Message:**
```
Failed to connect to flutter-app-v2.onrender.com
Connection refused
```

**Cause:** 
- Backend server is down
- No internet connection on device
- Firewall blocking requests

**Solution:**

**Check 1: Is backend online?**
```bash
curl https://flutter-app-v2.onrender.com/health
# Should return: {"status":"OK",...}
```

**Check 2: Is device online?**
- Try: Settings → About → Internet Connection
- Try switching WiFi → Mobile data → WiFi

**Check 3: Clear app cache**
- Settings → Apps → SAFE (your app) → Storage → Clear Cache

**Check 4: Wait for Render deployment**
- If you recently pushed code, Render might be redeploying (2-5 minutes)

---

### 7. **CORS Error - Blocked by Browser/App**

**Error Message:**
```
Access to XMLHttpRequest blocked by CORS policy
```

**Cause:** This shouldn't happen now that CORS is fixed, but if it does:

**Solution:**
- ✅ Update app: `flutter pub get && flutter run`
- ✅ Clear cache: Settings → Apps → SAFE → Storage → Clear Cache
- ✅ Restart device
- 🔄 Backend redeploy might be in progress

---

### 8. **Null Pointer Exception - Invalid Response**

**Error Message:**
```
type 'Null' is not a subtype of type 'Map<String, dynamic>'
```

**Cause:** Backend returned unexpected response format or error response.

**Solution:**
- ✅ Check backend logs for actual error
- ✅ Try again (might be temporary)
- 🔄 If persists, backend might need restart

---

## API Response Formats

### Success Response (201 Created)
```json
{
  "success": true,
  "data": {
    "userId": "507f1f77bcf86cd799439011",
    "email": "user@example.com",
    "fullName": "John Doe",
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  },
  "message": "User registered successfully",
  "statusCode": 201
}
```

### Error Response (4xx/5xx)
```json
{
  "success": false,
  "message": "User with this email already exists",
  "statusCode": 409,
  "errors": ["Email already in use"]
}
```

---

## Token Management

### Access Token
- **Duration:** 15 minutes
- **Usage:** Include in all API requests
- **Format:** `Authorization: Bearer <accessToken>`
- **When expires:** System auto-refreshes using refreshToken

### Refresh Token
- **Duration:** 7 days
- **Usage:** Only to get new access token when it expires
- **Secure Storage:** Stored in Flutter Secure Storage (encrypted)
- **When expires:** User must login again

### Token Refresh Flow
```
1. Access token expires (after 15 min)
2. App automatically calls: POST /api/v1/auth/refresh-token
3. Backend validates refresh token
4. Returns new access token
5. App continues with new token
(User doesn't notice anything)
```

---

## Testing Checklist

### ✅ Test Registration
1. Open app → Register tab
2. Enter valid email (not registered before)
3. Enter password with uppercase, lowercase, number, 8+ chars
4. Enter full name
5. Click Register
6. Should see: "✅ Registration successful" in logs
7. Should be logged in automatically

### ✅ Test Login
1. Register with test account (if not already done)
2. Logout
3. Go to Login tab
4. Enter registered email
5. Enter password
6. Click Login
7. Should see: "✅ Login successful" in logs
8. Should navigate to home screen

### ✅ Test Error Cases
1. **Wrong Password**: Login with wrong password → See "Invalid email or password"
2. **Duplicate Email**: Register with existing email → See "User already exists"
3. **Weak Password**: Try password like "test123" → See password requirements
4. **Missing Fields**: Try submitting without email → See validation error

---

## Debug Logs to Look For

### Success Logs
```
✅ Registration successful: user@example.com
✅ User registered: user@example.com
✅ Login successful: user@example.com
✅ User logged in: user@example.com
```

### Error Logs
```
❌ Dio error registering: User with this email already exists
❌ Registration error: Instance of 'ServerFailure'
❌ Error registering: Exception message
```

### Network Logs
```
→ POST https://flutter-app-v2.onrender.com/api/v1/auth/register
← 201 https://flutter-app-v2.onrender.com/api/v1/auth/register
← 409 https://flutter-app-v2.onrender.com/api/v1/auth/register
```

---

## Backend Connection Status

**Check if backend is running:**
```bash
curl -s https://flutter-app-v2.onrender.com/health | jq .
```

**Expected response:**
```json
{
  "status": "OK",
  "timestamp": "2026-08-11T07:55:50.138Z",
  "uptime": 3600.5,
  "environment": "development"
}
```

---

## How to View Full Logs

### Option 1: Android Logcat
```bash
# In terminal, while app is running:
flutter logs
```

### Option 2: In-App Logging
- App already logs all requests/responses
- Look in Flutter's debug console in IDE

### Option 3: Check Backend Logs
- Go to Render Dashboard
- Select "flutter-app-v2" service
- View "Logs" tab
- Filter by timestamp or "ERROR"

---

## Security Notes

🔒 **What We Do Right:**
- ✅ Never store passwords (only hashed in DB)
- ✅ Tokens expire automatically
- ✅ Refresh tokens are separate from access tokens
- ✅ Tokens sent over HTTPS only
- ✅ Secure Storage encrypts tokens on device

🔐 **What You Should Do:**
- ✅ Never share your password
- ✅ Don't store tokens in plain text
- ✅ Clear app cache if shared device
- ✅ Use strong, unique passwords
- ✅ Enable app lock on your device

---

## Still Having Issues?

1. **Check Backend Status**
   ```bash
   curl https://flutter-app-v2.onrender.com/health
   ```

2. **View Full Logs**
   ```bash
   flutter logs
   ```

3. **Check Render Deployment**
   - https://dashboard.render.com
   - Select "flutter-app-v2"
   - Check "Events" tab

4. **Clear Everything & Retry**
   - Uninstall app
   - `flutter clean`
   - `flutter pub get`
   - `flutter run`

5. **Check MongoDB Connection**
   - Render logs should show: "✅ Connected to MongoDB"
   - If not, check `.env` file has correct MONGODB_URI

---

*Last Updated: 2026-08-11* ✅
