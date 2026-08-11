# FitFlow Backend - Complete Setup Guide

## Step-by-Step Setup

This guide will walk you through setting up and running the FitFlow backend on your machine.

---

## ✅ Prerequisites

Before starting, make sure you have:

1. **Node.js** (v16+) - [Download](https://nodejs.org/)
   ```bash
   node --version  # Should be v16 or higher
   npm --version   # Should be 7 or higher
   ```

2. **MongoDB** - Choose one:
   - **Local MongoDB**: [Install](https://docs.mongodb.com/manual/installation/)
   - **MongoDB Atlas** (Cloud): [Free Account](https://www.mongodb.com/cloud/atlas)

3. **Code Editor** - VSCode, WebStorm, or any editor

4. **Git** - For version control

---

## 📥 Installation

### Step 1: Navigate to Backend Directory

```bash
cd fitflow_gym/backend
```

### Step 2: Install Dependencies

```bash
npm install
```

This installs all required packages:
- express - Web framework
- mongoose - MongoDB ODM
- bcryptjs - Password hashing
- jsonwebtoken - JWT authentication
- and others...

**Expected output:**
```
added 185 packages, and audited 187 packages in 2m
```

---

## 🔧 Configuration

### Step 3: Create Environment File

```bash
# Copy example to create .env file
cp .env.example .env

# Open and edit .env
nano .env  # or use your editor
```

### Step 4: Configure Environment Variables

#### For Local Development with Local MongoDB:

```bash
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/fitflow
JWT_SECRET=my-super-secret-key-change-this-in-production
JWT_REFRESH_SECRET=my-refresh-secret-key-change-this
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d
CORS_ORIGIN=http://localhost:3001,http://192.168.1.100:8080
LOG_LEVEL=info
```

#### For MongoDB Atlas (Cloud):

```bash
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/fitflow?retryWrites=true&w=majority
JWT_SECRET=my-super-secret-key-change-this-in-production
JWT_REFRESH_SECRET=my-refresh-secret-key-change-this
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d
CORS_ORIGIN=http://localhost:3001,http://192.168.1.100:8080
LOG_LEVEL=info
```

**To get MongoDB Atlas URI:**
1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create free account
3. Create a cluster (take ~5 min)
4. Click "Connect" → "Connect your application"
5. Copy connection string
6. Replace `<password>` with your password

---

## 🗄️ Database Setup

### Option A: Local MongoDB

#### macOS
```bash
# Install MongoDB
brew install mongodb-community

# Start MongoDB
brew services start mongodb-community

# Verify it's running
mongo --version

# (MongoDB runs in background)
```

#### Windows
```bash
# Download from: https://www.mongodb.com/try/download/community
# Run installer and follow prompts
# MongoDB starts as a service automatically
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y mongodb
sudo systemctl start mongodb
sudo systemctl enable mongodb
```

### Option B: MongoDB Atlas (Cloud - Recommended for first time)

1. Go to https://www.mongodb.com/cloud/atlas
2. Click "Start Free"
3. Create account with email
4. Create organization
5. Create cluster (select "Create" under "Shared Clusters" - it's free)
6. Wait for cluster to deploy (~10 min)
7. Click "Connect" button
8. Choose "Connect your application"
9. Copy connection string
10. Add to `.env` as `MONGODB_URI`

**Example connection string:**
```
mongodb+srv://username:password@cluster0.abc123.mongodb.net/fitflow?retryWrites=true&w=majority
```

---

## ▶️ Running the Server

### Development Mode (with auto-reload)

```bash
npm run dev

# Expected output:
# [timestamp] [INFO] ✅ Connected to MongoDB
# [timestamp] [INFO] ✅ All routes registered
# ╔════════════════════════════════════════╗
# ║   FitFlow Backend Server Started 🚀   ║
# ║────────────────────────────────────────║
# ║  Environment: development              ║
# ║  Port: 3000                            ║
# ║  URL: http://localhost:3000            ║
# ║  API: http://localhost:3000/api/v1     ║
# ╚════════════════════════════════════════╝
```

### Production Mode

```bash
npm start
```

### Check Server is Running

**Option 1: Browser**
```
http://localhost:3000/health
```

Should return:
```json
{
  "status": "OK",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 12.345,
  "environment": "development"
}
```

**Option 2: Terminal**
```bash
curl http://localhost:3000/health
```

---

## 🧪 Testing API Endpoints

### Using Postman

1. Download [Postman](https://www.postman.com/downloads/)
2. Create new request
3. Try endpoint:

```
POST http://localhost:3000/api/v1/auth/register
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "TestPass123",
  "fullName": "Test User"
}
```

Expected response:
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "userId": "...",
    "email": "test@example.com",
    "fullName": "Test User",
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

### Using cURL (Terminal)

```bash
# Register user
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123",
    "fullName": "Test User"
  }'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123"
  }'

# Get habits (replace TOKEN with access token from login)
curl -X GET http://localhost:3000/api/v1/habits \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 🔐 JWT Token Flow

### How Authentication Works:

1. **User registers/logs in**
   ```
   POST /api/v1/auth/register or /api/v1/auth/login
   ↓
   Returns: { accessToken, refreshToken }
   ```

2. **Use accessToken for API requests**
   ```
   GET /api/v1/habits
   Header: Authorization: Bearer <accessToken>
   ↓
   Returns: Habit data
   ```

3. **When accessToken expires (15 min)**
   ```
   POST /api/v1/auth/refresh-token
   Body: { refreshToken }
   ↓
   Returns: { new accessToken, new refreshToken }
   ```

### Test Token Refresh:

```bash
# 1. Login to get tokens
LOGIN_RESPONSE=$(curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123"
  }')

# 2. Extract refreshToken from response
# Copy the refreshToken value from LOGIN_RESPONSE

# 3. Use refreshToken to get new accessToken
curl -X POST http://localhost:3000/api/v1/auth/refresh-token \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "YOUR_REFRESH_TOKEN_HERE"
  }'
```

---

## 🐛 Troubleshooting

### Issue: "Cannot find module 'express'"

**Solution:**
```bash
# Make sure you're in backend directory
cd backend

# Install dependencies again
npm install
```

### Issue: "MongoDB connection error"

**Solution:**
```bash
# Check if MongoDB is running
# For local MongoDB:
mongod

# For MongoDB Atlas:
# Make sure connection string is correct in .env
# Check firewall allows connection
# Check IP whitelist in MongoDB Atlas
```

### Issue: "Port 3000 already in use"

**Solution:**
```bash
# Change port in .env
PORT=3001

# Or kill process using port 3000
# Linux/Mac:
kill -9 $(lsof -t -i:3000)

# Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### Issue: "JWT_SECRET is not defined"

**Solution:**
```bash
# Make sure .env file exists and has JWT_SECRET
ls -la .env

# Edit .env and add:
JWT_SECRET=your-secret-key
JWT_REFRESH_SECRET=your-refresh-secret
```

### Issue: CORS error from Flutter

**Solution:**
```bash
# Add Flutter app URL to CORS_ORIGIN in .env
CORS_ORIGIN=http://localhost:8080,http://your-device-ip:8080
```

---

## 📊 Testing All Endpoints

### Quick Test Script

Save as `test.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:3000/api/v1"

# 1. Register
echo "1️⃣  Registering user..."
REGISTER=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPass123",
    "fullName": "Test User"
  }')

echo "$REGISTER" | jq .

# Extract token
TOKEN=$(echo "$REGISTER" | jq -r '.data.accessToken')
echo "Token: $TOKEN"

# 2. Create habit
echo -e "\n2️⃣  Creating habit..."
curl -s -X POST "$BASE_URL/habits" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Morning Exercise",
    "emoji": "🏃",
    "color": "#FF6B6B",
    "category": "fitness",
    "targetMinutes": 30
  }' | jq .

# 3. Get habits
echo -e "\n3️⃣  Getting habits..."
curl -s -X GET "$BASE_URL/habits" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 4. Get user profile
echo -e "\n4️⃣  Getting user profile..."
curl -s -X GET "$BASE_URL/auth/me" \
  -H "Authorization: Bearer $TOKEN" | jq .
```

Run with:
```bash
chmod +x test.sh
./test.sh
```

---

## 🎯 Next Steps

1. **For Flutter Integration:**
   - Copy API endpoints from `src/routes/` to Flutter
   - Update Flutter's `api_endpoints.dart` with backend URL
   - Replace Firebase datasources with HTTP datasources

2. **For Deployment:**
   - Generate strong JWT secrets
   - Set `NODE_ENV=production`
   - Deploy to Heroku, DigitalOcean, AWS, etc.
   - Set environment variables on hosting platform

3. **For Features:**
   - Implement WebSockets for real-time chat
   - Add email verification
   - Add password reset
   - Add user blocking/muting
   - Add analytics tracking

---

## 📚 File Structure Explained

```
backend/
├── src/
│   ├── config/
│   │   └── database.js              # How to connect to MongoDB
│   ├── controllers/                 # Business logic for each feature
│   │   ├── authController.js        # Registration, login, tokens
│   │   ├── habitController.js       # Create, update, delete habits
│   │   ├── userController.js        # Profile management
│   │   └── communityController.js   # Chat messaging
│   ├── models/                      # MongoDB schemas
│   │   ├── User.js                  # User data structure
│   │   ├── Habit.js                 # Habit data structure
│   │   └── ChatMessage.js           # Message data structure
│   ├── routes/                      # API endpoints
│   │   ├── authRoutes.js            # /auth/* endpoints
│   │   ├── habitRoutes.js           # /habits/* endpoints
│   │   ├── userRoutes.js            # /users/* endpoints
│   │   └── communityRoutes.js       # /community/* endpoints
│   ├── middleware/
│   │   ├── auth.js                  # Check if user is logged in
│   │   └── errorHandler.js          # Handle errors
│   └── utils/                       # Helper functions
│       ├── logger.js                # Logging
│       ├── validators.js            # Check input is valid
│       └── response.js              # Format API responses
└── server.js                         # Start the server here
```

---

## ✨ You're Ready!

Your backend is now ready to use. Next, connect it to your Flutter app by:

1. Update Flutter's `api_endpoints.dart` with your backend URL
2. Replace Firebase datasources with HTTP datasources
3. Test communication between Flutter and backend

Good luck! 🚀

---

For more help, check:
- `README.md` - Full API documentation
- `src/controllers/` - How each feature works
- `src/routes/` - All available endpoints
