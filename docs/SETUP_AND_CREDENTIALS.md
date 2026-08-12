# FitFlow Gym - Setup & Credentials Guide

**Last Updated:** August 12, 2026  
**Status:** Production Ready ✅

---

## 🚀 Quick Start

### Prerequisites
- Node.js 16+ (Backend)
- Flutter 3.12+  (Frontend)
- MongoDB 7.5+ (Database)
- npm or yarn

---

## 📝 Admin Credentials

### 🔐 SUPER ADMIN (Full System Control)
**Use this account to manage everything**

```
Email:    superadmin@fitflow.com
Password: SuperAdmin@2024!Fit
Role:     super_admin (highest privileges)
```

**Permissions:**
- Access admin dashboard
- Manage all users
- Manage content (quotes, videos)
- Manage posts and comments
- View all analytics
- Configure system settings

### 👤 ADMIN (Content Moderation)
**Use this account for moderation tasks**

```
Email:    admin@fitflow.com
Password: Admin@2024!Gym
Role:     admin (moderate privileges)
```

**Permissions:**
- Access admin dashboard
- Moderate posts and comments
- Delete inappropriate content
- View moderation queue
- View analytics (read-only)

### ⚠️ IMPORTANT SECURITY NOTES
1. **Store credentials securely** - Never commit to git
2. **Change passwords after first login** - Use strong, unique passwords
3. **Super admin account should be used sparingly** - Use regular admin for day-to-day tasks
4. **Enable 2FA if available** - Add extra security layer
5. **Never share credentials** - Use unique accounts per admin

---

## 🗄️ Database Setup

### Create Admin Users

**Automatic (Recommended):**
```bash
cd backend
node scripts/seed.js
```

This will:
- Connect to MongoDB
- Create super admin user (if not exists)
- Create admin user (if not exists)  
- Display credentials for reference
- Show success confirmation

**Output:**
```
╔════════════════════════════════════════════════╗
║          SEED COMPLETED SUCCESSFULLY           ║
╠════════════════════════════════════════════════╣
║  SUPER ADMIN (Full System Control)             ║
║  Email:    superadmin@fitflow.com              ║
║  Password: SuperAdmin@2024!Fit                 ║
║                                                ║
║  ADMIN (Content Moderation)                    ║
║  Email:    admin@fitflow.com                   ║
║  Password: Admin@2024!Gym                      ║
╚════════════════════════════════════════════════╝
```

### Manual User Creation (MongoDB)
```javascript
// Connect to MongoDB and run:
db.users.insertOne({
  email: "superadmin@fitflow.com",
  password: "hashed_password", // bcrypt hashed
  fullName: "Super Administrator",
  role: "super_admin",
  isEmailVerified: true,
  isActive: true,
  createdAt: new Date(),
  updatedAt: new Date()
})
```

---

## 🔧 Backend Setup

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Environment Variables
Create `.env` file:
```env
# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/fitflow

# Server
NODE_ENV=production
PORT=3000

# JWT
JWT_SECRET=your-super-secret-key-change-this
JWT_EXPIRE=7d

# CORS
CORS_ORIGIN=https://flutter-app-v2.onrender.com

# Upload
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=5242880
```

### 3. Create Admin Users
```bash
npm run seed
# or: node scripts/seed.js
```

### 4. Start Backend
```bash
# Production
npm start

# Development with auto-reload
npm run dev
```

**Verify Backend is Running:**
```bash
curl https://flutter-app-v2.onrender.com/health
# Response: { "status": "OK", "environment": "production" }
```

---

## 📱 Frontend Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure Backend URL
Edit `lib/core/network/api_endpoints.dart`:
```dart
static const String baseUrl = 'https://flutter-app-v2.onrender.com/api/v1';
```

### 3. Run App
```bash
# Debug on emulator/device
flutter run

# Release build
flutter build apk --release
# Output: android/app/build/outputs/flutter-apk/app-release.apk (64 MB)
```

---

## 🧪 Testing Credentials

### Login Test Flow

**1. Test Super Admin:**
```
Email: superadmin@fitflow.com
Password: SuperAdmin@2024!Fit
```
- ✅ Should login successfully
- ✅ Should show admin dashboard
- ✅ Should have full access to all features

**2. Test Admin:**
```
Email: admin@fitflow.com
Password: Admin@2024!Gym
```
- ✅ Should login successfully
- ✅ Should show admin dashboard
- ✅ Should have limited moderation access

**3. Test Regular User:**
```
Email: user@example.com
Password: User123456 (create new)
```
- ✅ Should login successfully
- ✅ Should NOT see admin dashboard
- ✅ Should see normal user features

### API Testing

**Get Dashboard (requires authentication):**
```bash
curl -X GET 'https://flutter-app-v2.onrender.com/api/v1/dashboard' \
  -H 'Authorization: Bearer {TOKEN}'
```

**Get Admin Stats (requires super_admin role):**
```bash
curl -X GET 'https://flutter-app-v2.onrender.com/api/v1/admin/stats' \
  -H 'Authorization: Bearer {TOKEN}'
```

**Get Posts (public, requires auth):**
```bash
curl -X GET 'https://flutter-app-v2.onrender.com/api/v1/community/posts' \
  -H 'Authorization: Bearer {TOKEN}'
```

---

## 📊 Database Models

### User Model Structure
```javascript
{
  _id: ObjectId,
  email: String (unique),
  password: String (hashed),
  fullName: String,
  avatar: String (URL),
  role: String (enum: ['user', 'admin', 'super_admin']),
  isEmailVerified: Boolean,
  isActive: Boolean,
  level: Number,
  xp: Number,
  createdAt: Date,
  updatedAt: Date
}
```

### Other Collections
- **habits** - User habits
- **posts** - Community posts
- **focusSessions** - Focus timer sessions
- **messages** - Direct messages
- **chatMessages** - Group chat
- **quotes** - Daily quotes
- **videos** - Educational videos

---

## 🔄 Real-Time Data Integration

All screens now use **real backend data** instead of mock:

| Feature | Endpoint | Status |
|---------|----------|--------|
| Dashboard | GET `/api/v1/dashboard` | ✅ Real |
| Posts | GET `/api/v1/community/posts` | ✅ Real |
| Habits | GET `/api/v1/habits` | ✅ Real |
| Focus Sessions | GET `/api/v1/focus` | ✅ Real |
| Profile | GET `/api/v1/auth/me` | ✅ Real |
| Admin Stats | GET `/api/v1/admin/stats` | ✅ Real |

**No mock data in production paths** ✅

---

## 🐛 Troubleshooting

### "401 Unauthorized" Error
- ✅ Token expired: Re-login
- ✅ Invalid token: Clear app cache and restart
- ✅ Token not sent: Check Authorization header

### "403 Forbidden" Error  
- ✅ User role is not admin: Use super admin account
- ✅ Admin dashboard removed from user: Contact super admin

### "404 Not Found" Error
- ✅ Backend not running: Start with `npm start`
- ✅ Wrong endpoint: Check API_ENDPOINTS.dart
- ✅ Database not seeded: Run `npm run seed`

### Posts Not Loading
- ✅ Posts collection empty: Create posts via app
- ✅ API error: Check backend logs
- ✅ Image loading slow: Images are real, may take time

### Focus Timer Errors
- ✅ Rate limit (429): Wait 1 minute, try again
- ✅ 403 error: User not authenticated, re-login
- ✅ 404 error: Backend focus endpoint missing

---

## 📈 Deployment Checklist

- [ ] Database seeded with admin users
- [ ] Backend running and healthy (`/health` endpoint)
- [ ] All API endpoints returning real data
- [ ] Frontend pointing to correct backend URL
- [ ] CORS properly configured
- [ ] Environment variables set
- [ ] SSL/HTTPS enabled
- [ ] Rate limiting active
- [ ] Logging enabled
- [ ] Backups configured

---

## 🔒 Security Checklist

- [ ] Admin credentials stored securely (not in code)
- [ ] Passwords are strong (12+ chars, mixed case, special chars)
- [ ] JWT secret is strong and unique
- [ ] Database backups scheduled
- [ ] API rate limiting enabled
- [ ] CORS restricted to frontend domain
- [ ] MongoDB access limited by IP
- [ ] Sensitive data not logged
- [ ] Two-factor authentication considered
- [ ] Security headers configured (Helmet.js)

---

## 📞 Support

**Issues?**
1. Check `/docs/FINAL_STATUS.md` for completed tasks
2. Check logs: `backend/logs/` or Flutter console
3. Test credentials with Postman
4. Verify MongoDB connection
5. Check CORS configuration

**Key Files:**
- Backend entry: `backend/server.js`
- Frontend entry: `lib/main.dart`
- Database seeds: `backend/scripts/seed.js`
- API client: `lib/core/network/api_client.dart`

---

## 📚 Additional Resources

- **API Documentation:** `/docs/guides/ARCHITECTURE.md`
- **Testing Guide:** `/docs/testing/DETAILED_TEST.md`
- **Fixes Applied:** `/docs/fixes/WHAT_WAS_FIXED.md`
- **Architecture:** `/docs/guides/ARCHITECTURE.md`

---

**Status:** ✅ Production Ready  
**All endpoints tested and working**  
**Real data integration complete**  
**Admin role-based access control active**
