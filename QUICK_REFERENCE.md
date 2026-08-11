# 🚀 FitFlow Gym - Quick Reference Guide

**Status:** ✅ Production Ready  
**Last Updated:** 2026-08-11

---

## 🔗 Important URLs

| Resource | URL |
|----------|-----|
| **Backend API** | https://flutter-app-v2.onrender.com/api/v1 |
| **Health Check** | https://flutter-app-v2.onrender.com/health |
| **GitHub Repo** | https://github.com/Devloperameen/Flutter-app-V2 |
| **Render Dashboard** | https://dashboard.render.com |
| **MongoDB Atlas** | https://cloud.mongodb.com |

---

## 📝 API Endpoints

### Authentication
```
POST   /auth/register              Register new user
POST   /auth/login                 Login user
GET    /auth/me                    Get current user profile
POST   /auth/verify                Verify token
POST   /auth/logout                Logout user
POST   /auth/refresh-token         Refresh access token
```

### Full Endpoint Path
```
https://flutter-app-v2.onrender.com/api/v1/auth/register
```

---

## 📱 Test Credentials

Use these to test on your device:

```
Email:    testuser@example.com
Password: TestPass123
```

Or create a new test account:
- Email: any email not yet registered
- Password: Must have uppercase, lowercase, number, 8+ chars
- Name: Your test name

---

## 🧪 Quick Test

### Via cURL
```bash
# Register
curl -X POST https://flutter-app-v2.onrender.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123","fullName":"Test"}'

# Login
curl -X POST https://flutter-app-v2.onrender.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123"}'

# Get user (with token)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://flutter-app-v2.onrender.com/api/v1/auth/me
```

### On Your Phone
1. Open FitFlow app
2. Go to Register tab
3. Enter email, password, name
4. Click Register → Auto-logged in
5. Check app logs for success message

---

## 🔐 Password Requirements

✅ **Valid Password:**
- Minimum 8 characters
- Contains uppercase (A-Z)
- Contains lowercase (a-z)
- Contains number (0-9)

Example: `MyPassword123` ✅

---

## 📊 Test Results Summary

```
Total Tests:      7/7 PASSING
Register:         ✅ Working (201)
Login:            ✅ Working (200)
Get User:         ✅ Working (200)
Verify Token:     ✅ Working (200)
Logout:           ✅ Working (200)
Error Cases:      ✅ Working (401, 409)
```

---

## 🛠️ Common Tasks

### Check Backend Status
```bash
curl https://flutter-app-v2.onrender.com/health
```

### View Backend Logs
1. Go to https://dashboard.render.com
2. Select "flutter-app-v2"
3. Click "Logs" tab

### Deploy Latest Code
1. Make changes locally
2. `git push` to GitHub
3. Render auto-deploys (1-2 minutes)
4. Check logs in Render dashboard

### Reset Rate Limit
- Rate limit: 5 attempts per 15 minutes
- Wait 15 minutes or contact support
- Check email verification requirements

---

## 📱 App Integration

### Token Management
- **Access Token:** 15 minutes validity
- **Refresh Token:** 7 days validity
- **Auto-Refresh:** Happens automatically
- **Secure Storage:** Encrypted on device

### Error Messages
All errors are user-friendly:
- "Invalid email or password"
- "User with this email already exists"
- "Password must be at least 8 characters"
- etc.

### Debug Logs
Open Flutter console to see:
- `→ POST /api/v1/auth/register` (outgoing request)
- `← 201 /api/v1/auth/register` (response)
- `✅ Registration successful` (success message)
- `❌ Error message` (error details)

---

## 🚨 Troubleshooting

### Problem: "Connection refused"
**Solution:** Backend might be starting up. Wait 1-2 minutes and try again.

### Problem: "401 Unauthorized"
**Solution:** 
- Token might be expired (auto-refresh should handle)
- Clear app cache and reinstall
- Check network connection

### Problem: "409 User already exists"
**Solution:** Use a different email address for testing

### Problem: "422 Password too weak"
**Solution:** Use password with uppercase, lowercase, number, 8+ chars

### Problem: Rate limit (429)
**Solution:** Wait 15 minutes and try again

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| DEPLOYMENT_STATUS.md | System architecture |
| AUTH_TROUBLESHOOTING.md | Error solutions |
| API_TEST_REPORT.md | Detailed test results |
| FINAL_STATUS.md | Project summary |
| RENDER_DEPLOYMENT_CONFIRMED.md | Deployment verification |
| BACKEND_VERIFICATION.md | Live API verification |
| QUICK_REFERENCE.md | This file |

---

## 🎯 Next Steps

1. **Test on Device**
   ```
   1. Open FitFlow app
   2. Try registering
   3. Try logging in
   4. Check for errors
   ```

2. **Monitor Logs**
   ```
   1. Open Render dashboard
   2. Watch for errors
   3. Check response times
   ```

3. **Scale When Ready**
   ```
   1. Upgrade Render plan
   2. Increase MongoDB limits
   3. Add caching layer
   ```

---

## 🔒 Security Notes

✅ **What's Protected:**
- Passwords (bcrypt hashed)
- Tokens (expire automatically)
- Database (MongoDB security)
- Communications (HTTPS)
- Storage (encrypted on device)

⚠️ **What You Should Do:**
- Never share passwords
- Don't store tokens in plain text
- Use strong passwords
- Clear cache on shared devices

---

## 📞 Getting Help

1. **Check Documentation**
   - Read *.md files in project
   - Look in AUTH_TROUBLESHOOTING.md

2. **Check Logs**
   - Flutter: `flutter logs`
   - Backend: Render dashboard

3. **Verify Backend**
   - https://flutter-app-v2.onrender.com/health
   - Should return `{"status":"OK"}`

4. **Test API**
   - Use cURL commands above
   - Check response codes

---

## 🎊 You're All Set!

Your FitFlow Gym is:
- ✅ Deployed and running
- ✅ Tested and verified
- ✅ Documented and ready
- ✅ Production-grade secure

**Happy coding!** 🚀

---

*Generated: 2026-08-11*  
*Status: Production Ready*  
*Tests: 7/7 Passing*
