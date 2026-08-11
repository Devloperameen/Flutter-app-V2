# FitFlow Backend API

A production-ready Express.js + MongoDB backend for the FitFlow fitness application.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Environment Configuration](#environment-configuration)
- [Running the Server](#running-the-server)
- [API Documentation](#api-documentation)
- [Database Models](#database-models)

---

## ✨ Features

✅ **User Authentication** - Register, login, JWT tokens, token refresh  
✅ **Habit Management** - CRUD habits, streak tracking, completion logging  
✅ **Community Chat** - Direct messaging, group chat, message reactions  
✅ **User Profiles** - Profile management, preferences, statistics  
✅ **Input Validation** - Server-side validation for all inputs  
✅ **Error Handling** - Standardized error responses  
✅ **Logging** - Comprehensive logging for debugging  
✅ **Security** - Password hashing, JWT authentication, CORS  

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| **Runtime** | Node.js |
| **Framework** | Express.js |
| **Database** | MongoDB + Mongoose ODM |
| **Authentication** | JWT (JSON Web Tokens) |
| **Password Hashing** | bcryptjs |
| **Security** | Helmet, CORS |
| **Logging** | Morgan, Custom Logger |
| **Validation** | Custom validators, Mongoose schemas |

---

## 📁 Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js              # MongoDB connection setup
│   ├── controllers/
│   │   ├── authController.js        # Authentication logic
│   │   ├── habitController.js       # Habit CRUD & logic
│   │   ├── userController.js        # User profile management
│   │   └── communityController.js   # Chat & community features
│   ├── models/
│   │   ├── User.js                  # User schema & methods
│   │   ├── Habit.js                 # Habit schema & methods
│   │   └── ChatMessage.js           # Chat message schema & methods
│   ├── routes/
│   │   ├── authRoutes.js            # /api/v1/auth/*
│   │   ├── habitRoutes.js           # /api/v1/habits/*
│   │   ├── userRoutes.js            # /api/v1/users/*
│   │   └── communityRoutes.js       # /api/v1/community/*
│   ├── middleware/
│   │   ├── auth.js                  # JWT authentication middleware
│   │   └── errorHandler.js          # Global error handler
│   └── utils/
│       ├── logger.js                # Logging utility
│       ├── validators.js            # Input validators
│       └── response.js              # API response formatter
├── server.js                         # Express app entry point
├── package.json                      # Dependencies & scripts
├── .env.example                      # Environment template
└── .gitignore                        # Git ignore rules
```

---

## 🚀 Setup Instructions

### 1. Prerequisites

- **Node.js** (v16 or higher)
- **npm** or **yarn**
- **MongoDB** (local or MongoDB Atlas cloud)

### 2. Clone & Install Dependencies

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Or with yarn
yarn install
```

### 3. Setup Environment Variables

```bash
# Copy example to create .env file
cp .env.example .env

# Edit .env with your configuration
nano .env  # or use your favorite editor
```

### 4. Configure Database

**Option A: Local MongoDB**
```bash
# Install MongoDB locally
# macOS:
brew install mongodb-community

# Start MongoDB service
brew services start mongodb-community
```

**Option B: MongoDB Atlas (Cloud)**

1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free account
3. Create a cluster
4. Get connection string
5. Add to `.env`: `MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/fitflow`

---

## 🔧 Environment Configuration

### `.env` File

```bash
# ─── Server ───────────────────────
NODE_ENV=development
PORT=3000
API_VERSION=v1

# ─── Database ──────────────────────
MONGODB_URI=mongodb://localhost:27017/fitflow

# ─── JWT Secrets (CHANGE THESE!) ────
JWT_SECRET=your-super-secret-key-change-this
JWT_REFRESH_SECRET=your-refresh-secret-key
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d

# ─── CORS (Flutter app URL) ────────
CORS_ORIGIN=http://localhost:3001,http://localhost:8080

# ─── Logging ───────────────────────
LOG_LEVEL=info
```

### Important Security Notes

⚠️ **NEVER commit `.env` file to Git**  
✅ Only commit `.env.example`  
✅ Generate strong JWT secrets for production  
✅ Use environment-specific values per deployment  

---

## ▶️ Running the Server

### Development Mode (with auto-reload)

```bash
npm run dev

# Output:
# ╔════════════════════════════════════════╗
# ║   FitFlow Backend Server Started 🚀   ║
# ╚════════════════════════════════════════╝
# Environment: development
# Port: 3000
# API: http://localhost:3000/api/v1
```

### Production Mode

```bash
npm start
```

### Testing

```bash
npm test
```

---

## 📚 API Documentation

### Base URL
```
http://localhost:3000/api/v1
```

### Response Format

All responses follow this structure:

**Success (200)**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { /* response data */ },
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

**Error (4xx, 5xx)**
```json
{
  "success": false,
  "message": "Error description",
  "statusCode": 400,
  "errors": [ /* validation errors */ ],
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

### Authentication Endpoints

#### 1. Register
```
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123",
  "fullName": "John Doe"
}

Response:
{
  "success": true,
  "data": {
    "userId": "...",
    "email": "user@example.com",
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

#### 2. Login
```
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123"
}

Response: Same as register
```

#### 3. Refresh Token
```
POST /auth/refresh-token
Content-Type: application/json

{
  "refreshToken": "eyJhbGc..."
}

Response:
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc..."
  }
}
```

#### 4. Get Current User
```
GET /auth/me
Authorization: Bearer <accessToken>

Response:
{
  "success": true,
  "data": {
    "userId": "...",
    "email": "...",
    "fullName": "...",
    "avatar": "...",
    "createdAt": "..."
  }
}
```

### Habit Endpoints

#### 1. Get All Habits
```
GET /habits?archived=false&limit=50&page=1
Authorization: Bearer <accessToken>

Response:
{
  "success": true,
  "data": [ /* habits array */ ],
  "pagination": {
    "page": 1,
    "limit": 50,
    "total": 120,
    "pages": 3
  }
}
```

#### 2. Create Habit
```
POST /habits
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "title": "Morning Exercise",
  "emoji": "🏃",
  "color": "#FF6B6B",
  "category": "fitness",
  "description": "30 min morning run",
  "targetMinutes": 30,
  "reminderTime": "07:00"
}
```

#### 3. Mark Habit Complete
```
POST /habits/{habitId}/complete
Authorization: Bearer <accessToken>

Response: Updated habit with incremented streak
```

#### 4. Undo Completion
```
POST /habits/{habitId}/undo
Authorization: Bearer <accessToken>

Response: Updated habit with decremented streak
```

#### 5. Delete Habit
```
DELETE /habits/{habitId}
Authorization: Bearer <accessToken>
```

### User Endpoints

#### 1. Update Profile
```
PUT /users/me
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "fullName": "John Doe",
  "avatar": "https://...",
  "bio": "Fitness enthusiast"
}
```

#### 2. Change Password
```
POST /users/me/change-password
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "currentPassword": "OldPass123",
  "newPassword": "NewPass456"
}
```

### Community/Chat Endpoints

#### 1. Send Direct Message
```
POST /community/messages
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "receiverId": "userId",
  "message": "Hi there!",
  "attachments": []
}
```

#### 2. Get Conversation
```
GET /community/messages/{userId}?limit=50&page=1
Authorization: Bearer <accessToken>
```

#### 3. Add Emoji Reaction
```
POST /community/messages/{messageId}/reactions
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "emoji": "👍"
}
```

---

## 📊 Database Models

### User Schema

```javascript
{
  email: String (unique),
  password: String (hashed),
  fullName: String,
  avatar: String,
  bio: String,
  isEmailVerified: Boolean,
  isActive: Boolean,
  lastLogin: Date,
  preferences: {
    theme: 'light' | 'dark',
    notifications: {
      enabled: Boolean,
      email: Boolean,
      push: Boolean
    }
  },
  stats: {
    totalHabits: Number,
    totalCompletions: Number,
    currentStreak: Number,
    longestStreak: Number
  },
  createdAt: Date,
  updatedAt: Date
}
```

### Habit Schema

```javascript
{
  userId: ObjectId (reference to User),
  title: String,
  emoji: String,
  color: String (hex),
  category: 'health' | 'productivity' | 'learning' | 'fitness' | 'other',
  description: String,
  reminderEnabled: Boolean,
  reminderTime: String (HH:MM format),
  targetMinutes: Number,
  completedToday: Boolean,
  currentStreak: Number,
  longestStreak: Number,
  totalCompletions: Number,
  lastCompletedDate: Date,
  archived: Boolean,
  order: Number,
  createdAt: Date,
  updatedAt: Date
}
```

### ChatMessage Schema

```javascript
{
  senderId: ObjectId (reference to User),
  receiverId: ObjectId (reference to User) | null,
  roomId: String | null,
  message: String,
  attachments: [{
    url: String,
    type: 'image' | 'video' | 'audio' | 'document'
  }],
  isRead: Boolean,
  readAt: Date,
  isDeleted: Boolean,
  reactions: Map<emoji, [userId]>,
  createdAt: Date,
  updatedAt: Date
}
```

---

## 🐛 Common Issues & Solutions

### MongoDB Connection Error
**Issue:** `MongoNetworkError: connect ECONNREFUSED`

**Solution:**
```bash
# Make sure MongoDB is running
mongod

# Or check MongoDB Atlas connection string in .env
```

### JWT Secret Not Set
**Issue:** `Error: JWT_SECRET is not defined`

**Solution:** Add `JWT_SECRET` to `.env` file

### Port Already in Use
**Issue:** `Error: listen EADDRINUSE :::3000`

**Solution:**
```bash
# Change PORT in .env to different value (e.g., 3001)
PORT=3001
```

### CORS Error from Flutter
**Issue:** `Access to XMLHttpRequest has been blocked by CORS policy`

**Solution:** Add Flutter app URL to `CORS_ORIGIN` in `.env`:
```bash
CORS_ORIGIN=http://localhost:8080,http://your-device-ip:8080
```

---

## 📦 Deployment

### Deploy to Heroku

```bash
# Install Heroku CLI
npm install -g heroku

# Login to Heroku
heroku login

# Create app
heroku create your-app-name

# Add MongoDB Atlas database
heroku config:set MONGODB_URI=mongodb+srv://...

# Add JWT secrets
heroku config:set JWT_SECRET=your-production-secret
heroku config:set JWT_REFRESH_SECRET=your-production-refresh-secret

# Deploy
git push heroku main
```

### Deploy to DigitalOcean

```bash
# SSH into your droplet
ssh root@your-droplet-ip

# Install Node.js and MongoDB
# ... (follow DigitalOcean docs)

# Clone repository
git clone your-repo

# Install dependencies and run
npm install
npm start
```

---

## 📝 Development Notes

- Always validate input on both client and server
- Use transaction for operations affecting multiple records
- Log important operations for debugging
- Test all endpoints with Postman/Insomnia before deployment
- Never expose sensitive data in logs
- Keep database indexes up to date for performance

---

## 📞 Support

For issues, questions, or suggestions:
1. Check the [API Documentation](#api-documentation) above
2. Review error messages in logs
3. Check MongoDB Atlas status
4. Verify environment variables are set correctly

---

## 📄 License

MIT License - Feel free to use this project

---

**Happy coding! 🚀**
