# FitFlow Backend - Quick Start (5 minutes)

## 🚀 Start Here if You're in a Hurry

### 1. Install & Setup (2 min)

```bash
# Navigate to backend
cd fitflow_gym/backend

# Copy environment template
cp .env.example .env

# Install dependencies
npm install
```

### 2. Start MongoDB

**Option A: Using local MongoDB**
```bash
mongod
# Keep this running in another terminal
```

**Option B: Using MongoDB Atlas (Cloud)**
1. Go to https://www.mongodb.com/cloud/atlas
2. Create free account
3. Create cluster (wait ~5 min)
4. Get connection string
5. Add to `.env`: `MONGODB_URI=your_connection_string`

### 3. Start Backend (1 min)

```bash
npm run dev
```

You should see:
```
╔════════════════════════════════════════╗
║   FitFlow Backend Server Started 🚀   ║
║────────────────────────────────────────║
║  Environment: development              ║
║  Port: 3000                            ║
║  API: http://localhost:3000/api/v1     ║
╚════════════════════════════════════════╝
```

### 4. Test (1 min)

**In Postman or Terminal:**

```bash
# Test register
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123",
    "fullName": "Test User"
  }'

# You should get a response with accessToken
```

### 5. Create Habit (1 min)

Use the accessToken from above:

```bash
curl -X POST http://localhost:3000/api/v1/habits \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Morning Exercise",
    "emoji": "🏃",
    "color": "#FF6B6B",
    "category": "fitness",
    "targetMinutes": 30
  }'
```

✅ **You're Done!** Backend is running.

---

## 📚 What to Read Next

1. **README.md** - Complete API documentation
2. **SETUP_GUIDE.md** - Detailed setup & troubleshooting
3. **FOLDER_STRUCTURE.md** - Code organization

---

## 🔑 Key Environment Variables

In `.env`:

```bash
# Database
MONGODB_URI=mongodb://localhost:27017/fitflow

# JWT (Change these!)
JWT_SECRET=your-secret-key
JWT_REFRESH_SECRET=your-refresh-secret

# Server
PORT=3000
NODE_ENV=development

# Flutter App URL
CORS_ORIGIN=http://localhost:8080
```

---

## 📞 Common Issues

| Issue | Solution |
|-------|----------|
| `MongoDB connection error` | Make sure `mongod` is running or update `MONGODB_URI` |
| `Port 3000 already in use` | Change `PORT=3001` in `.env` |
| `JWT_SECRET not defined` | Add `JWT_SECRET=your-key` to `.env` |
| `Module not found` | Run `npm install` again |

---

## 🧪 API Endpoints

### Auth
```
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh-token
```

### Habits (need token)
```
GET /api/v1/habits
POST /api/v1/habits
POST /api/v1/habits/{id}/complete
POST /api/v1/habits/{id}/undo
```

### User (need token)
```
GET /api/v1/auth/me
PUT /api/v1/users/me
```

### Chat (need token)
```
POST /api/v1/community/messages
GET /api/v1/community/messages/{userId}
```

---

## 🎯 Next: Connect Flutter

1. Update Flutter's `lib/core/network/api_endpoints.dart`:
   ```dart
   static const String baseUrl = 'http://localhost:3000/api/v1';
   ```

2. Replace Firebase datasources with HTTP datasources

3. Test Flutter app with backend

---

## 💡 Pro Tips

- Use Postman to test all endpoints
- Check logs in terminal for errors
- Read error messages carefully
- Keep .env file secure (never commit)
- Change JWT secrets in production

---

🚀 **That's it! Your backend is ready.**

For more details, see **README.md** and **SETUP_GUIDE.md**
