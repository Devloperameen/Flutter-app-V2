# Environment Setup Guide

## Backend Environment Variables

### Setup Instructions

1. **Copy the example file:**
   ```bash
   cd backend
   cp .env.example .env
   ```

2. **Fill in your values in `.env`:**
   ```
   NODE_ENV=development
   PORT=5000
   API_VERSION=v1
   MONGODB_URI=mongodb+srv://[YOUR_USERNAME]:[YOUR_PASSWORD]@[YOUR_CLUSTER].mongodb.net/fitflow
   JWT_SECRET=your-secret-key-here
   JWT_REFRESH_SECRET=your-refresh-secret-here
   ```

3. **Important:** `.env` is in `.gitignore` - it will NOT be committed to GitHub

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| NODE_ENV | Yes | development/production |
| PORT | Yes | Server port (default: 5000) |
| API_VERSION | Yes | API version (v1) |
| MONGODB_URI | Yes | MongoDB connection string |
| JWT_SECRET | Yes | JWT signing secret |
| JWT_REFRESH_SECRET | Yes | Refresh token secret |
| JWT_ACCESS_EXPIRY | No | Token expiry (default: 15m) |
| JWT_REFRESH_EXPIRY | No | Refresh expiry (default: 7d) |
| LOG_LEVEL | No | Logging level (default: info) |
| CORS_ORIGIN | No | CORS origin (default: *) |

### Security Notes

⚠️ **IMPORTANT:**
- Never commit `.env` to git (already in `.gitignore`)
- Never share `.env` files in messages or code reviews
- Change secrets in production
- Use strong, unique JWT secrets
- Keep MongoDB credentials secure

### Getting Started

1. Create `.env` from `.env.example`
2. Add your MongoDB connection string
3. Add your JWT secrets
4. Start the backend: `npm start`

---

**For more info:** See backend/README.md

