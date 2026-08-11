# 🚀 Quick Setup: MongoDB + Render.com Deployment

---

## Step 1: Set Up MongoDB Atlas (5 minutes)

### 1.1 Create Account
1. Go to https://www.mongodb.com/cloud/atlas
2. Click "Sign Up"
3. Create account with email/password
4. Verify email

### 1.2 Create Cluster
1. Click "Create a Cluster"
2. Select **M0** (Free tier)
3. Choose region closest to you
4. Click "Create Cluster"
5. Wait 2-3 minutes for cluster to deploy

### 1.3 Create Database User
1. In left sidebar, go to **Database Access**
2. Click **"Add New User"**
3. Username: `fitflow_admin`
4. Password: Use auto-generated password
5. Set authentication: **Password**
6. Set access level: **Read and write to any database**
7. Click **"Add User"**
8. **Copy the password** and save it somewhere safe

### 1.4 Get Connection String
1. Go to **Database** in left sidebar
2. Click the **"Connect"** button on your cluster
3. Select **"Connect your application"**
4. Copy the connection string
5. Replace `<username>` and `<password>` with your credentials
6. Replace `fitflow` with `fitflow_gym`

**Example:**
```
mongodb+srv://fitflow_admin:YOUR_PASSWORD_HERE@cluster0.mongodb.net/fitflow_gym?retryWrites=true&w=majority
```

### 1.5 Whitelist IP Address
1. Go to **Network Access** in left sidebar
2. Click **"Add IP Address"**
3. Click **"Allow Access from Anywhere"** (0.0.0.0/0)
4. Click **"Confirm"**

✅ **MongoDB is now ready!**

---

## Step 2: Prepare Backend for Deployment

### 2.1 Create .env file in backend folder

Create file: `backend/.env`

```env
# Server
NODE_ENV=production
PORT=10000

# Database
MONGODB_URI=mongodb+srv://fitflow_admin:YOUR_PASSWORD@cluster0.mongodb.net/fitflow_gym?retryWrites=true&w=majority

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_EXPIRE=7d

# CORS
CORS_ORIGIN=*

# Upload
UPLOAD_DIR=/tmp/uploads
MAX_FILE_SIZE=5mb
```

**Important:** Replace `YOUR_PASSWORD` with your MongoDB password

### 2.2 Update server.js

Make sure your `server.js` has:

```javascript
require('dotenv').config();
const mongoose = require('mongoose');
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('✅ MongoDB connected'))
.catch(err => console.log('❌ MongoDB error:', err));

// CORS
app.use(cors({ origin: process.env.CORS_ORIGIN }));
app.use(express.json());

// Routes
app.use('/api/v1/auth', require('./routes/auth'));
app.use('/api/v1/habits', require('./routes/habits'));
app.use('/api/v1/community', require('./routes/community'));
app.use('/api/v1/focus', require('./routes/focus'));
app.use('/api/v1/uploads', require('./routes/uploads'));

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
```

### 2.3 Update package.json

Make sure your `package.json` has:

```json
{
  "name": "fitflow-backend",
  "version": "1.0.0",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.0",
    "mongoose": "^7.0.0",
    "dotenv": "^16.0.3",
    "cors": "^2.8.5",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.20"
  }
}
```

### 2.4 Test Locally

```bash
cd backend
npm install
npm start

# Should see: ✅ MongoDB connected
# Should see: 🚀 Server running on port 5000
```

✅ **Backend ready!**

---

## Step 3: Deploy to Render.com

### 3.1 Create GitHub Repository (if not already)

```bash
cd backend
git init
git add .
git commit -m "Initial commit - ready for deployment"
git remote add origin https://github.com/yourusername/fitflow-backend.git
git push -u origin main
```

### 3.2 Create Render.com Account

1. Go to https://render.com
2. Click **"Sign Up"**
3. Connect with GitHub
4. Authorize Render to access your repositories

### 3.3 Create New Web Service

1. Click **"New +"**
2. Select **"Web Service"**
3. Select your **fitflow-backend** repository
4. Click **"Connect"**

### 3.4 Configure Service

**Name:** `fitflow-backend`

**Environment:** `Node`

**Build Command:**
```
npm install
```

**Start Command:**
```
npm start
```

### 3.5 Add Environment Variables

Click **"Environment"** and add:

```
MONGODB_URI=mongodb+srv://fitflow_admin:YOUR_PASSWORD@cluster0.mongodb.net/fitflow_gym?retryWrites=true&w=majority
JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_EXPIRE=7d
CORS_ORIGIN=*
NODE_ENV=production
```

### 3.6 Deploy

1. Click **"Create Web Service"**
2. Wait for deployment (2-5 minutes)
3. You'll get a URL like: `https://fitflow-backend-xxxx.onrender.com`
4. Check logs to confirm: `✅ MongoDB connected`

✅ **Backend deployed!**

---

## Step 4: Update Flutter App

### 4.1 Update API Endpoint

Edit: `lib/core/network/api_endpoints.dart`

**Change:**
```dart
// From:
static const String baseUrl = 'http://localhost:5000/api/v1';

// To:
static const String baseUrl = 'https://fitflow-backend-xxxx.onrender.com/api/v1';
```

Replace `fitflow-backend-xxxx` with your actual Render.com URL (without `/api/v1`)

### 4.2 Rebuild App

```bash
flutter clean
flutter pub get
flutter run
```

### 4.3 Test Production

1. Open app on device
2. Test login
3. Try creating a habit
4. Try creating a community post
5. Check analytics tab
6. Test profile photo upload

✅ **App updated!**

---

## ✅ Verification Checklist

### MongoDB
- [ ] Cluster created
- [ ] Database user created
- [ ] IP whitelisted (0.0.0.0/0)
- [ ] Connection string saved

### Backend
- [ ] `.env` file created with MongoDB URI
- [ ] `server.js` updated
- [ ] `package.json` has start script
- [ ] Tested locally: `npm start` works
- [ ] Pushed to GitHub

### Render.com
- [ ] Connected GitHub
- [ ] Web service created
- [ ] Environment variables set
- [ ] Deployment successful
- [ ] URL received

### Flutter App
- [ ] `api_endpoints.dart` updated
- [ ] App rebuilt: `flutter run`
- [ ] All features tested
- [ ] API calls working with production backend

---

## 🔗 Important URLs

| Service | URL |
|---------|-----|
| MongoDB Atlas | https://cloud.mongodb.com |
| Render.com | https://render.com |
| Your Backend | https://fitflow-backend-xxxx.onrender.com |
| Your API | https://fitflow-backend-xxxx.onrender.com/api/v1 |

---

## 🆘 Troubleshooting

### Backend won't connect to MongoDB

**Error:** `MongoDB connection failed`

**Fix:**
1. Check MongoDB URI in `.env` file
2. Verify username/password (including special characters)
3. Check IP whitelist (should be 0.0.0.0/0)
4. Verify database name is `fitflow_gym`

### Render.com shows error

**Error:** `Build failed` or `Deployment failed`

**Fix:**
1. Check Build Command: should be `npm install`
2. Check Start Command: should be `npm start`
3. Check environment variables are set
4. View logs on Render.com console

### Flutter app can't connect

**Error:** `Connection refused` or `Failed to connect`

**Fix:**
1. Update `api_endpoints.dart` with correct Render.com URL
2. Make sure URL is `https://` (not http://)
3. Run `flutter clean && flutter pub get`
4. Rebuild: `flutter run`

---

## 📊 Expected Results

After deployment, you should see:

```
✅ Backend running on Render.com
✅ MongoDB connected
✅ App connects to backend
✅ Login works
✅ Habits sync
✅ Posts upload
✅ Analytics load
✅ Profile updates
```

---

**Status: Ready to Deploy! 🚀**

Follow these steps and your app will be live in production!
