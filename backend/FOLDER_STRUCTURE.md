# FitFlow Backend - Complete Folder & File Structure

## Visual Directory Tree

```
fitflow_gym/backend/
│
├── 📄 server.js                          ⭐ MAIN ENTRY POINT
│                                         - Start the Express server here
│                                         - Setup middleware
│                                         - Register all routes
│                                         - Connect to database
│
├── 📄 package.json                       📦 PROJECT CONFIGURATION
│                                         - All dependencies listed
│                                         - npm scripts (start, dev)
│
├── 📄 .env.example                       🔑 EXAMPLE ENVIRONMENT
│                                         - Copy to .env to use
│                                         - Contains all config variables
│
├── 📄 .gitignore                         🚫 GIT IGNORE
│                                         - Files to exclude from git
│                                         - .env, node_modules, etc
│
├── 📄 README.md                          📖 MAIN DOCUMENTATION
│                                         - Features overview
│                                         - API documentation
│                                         - Tech stack info
│
├── 📄 SETUP_GUIDE.md                     🚀 SETUP INSTRUCTIONS
│                                         - Step-by-step setup
│                                         - Troubleshooting
│                                         - Testing guide
│
├── 📄 FOLDER_STRUCTURE.md                📁 THIS FILE
│                                         - What each file does
│
└── 📁 src/                               🔧 SOURCE CODE
    │
    ├── 📁 config/
    │   └── 📄 database.js                🗄️  DATABASE CONFIGURATION
    │                                     - MongoDB connection
    │                                     - Connection pooling
    │                                     - Error handling
    │                                     Functions:
    │                                     - connectDB()
    │                                     - closeDB()
    │
    ├── 📁 models/                        📊 DATABASE SCHEMAS
    │   ├── 📄 User.js                    👤 USER SCHEMA
    │   │                                 - User profile data
    │   │                                 - Authentication fields
    │   │                                 - Methods:
    │   │                                   * comparePassword()
    │   │                                   * toPublicJSON()
    │   │                                   * findByEmail()
    │   │
    │   ├── 📄 Habit.js                   🎯 HABIT SCHEMA
    │   │                                 - Habit data structure
    │   │                                 - Streak tracking
    │   │                                 - Completion status
    │   │                                 - Methods:
    │   │                                   * markComplete()
    │   │                                   * markIncomplete()
    │   │                                   * getCompletionPercentage()
    │   │                                 - Statics:
    │   │                                   * getActiveHabits()
    │   │                                   * getTodayCompletions()
    │   │                                   * getUserStats()
    │   │
    │   └── 📄 ChatMessage.js             💬 CHAT MESSAGE SCHEMA
    │                                     - Message data
    │                                     - Direct & group chat
    │                                     - Reactions support
    │                                     - Methods:
    │                                       * markAsRead()
    │                                       * editMessage()
    │                                       * addReaction()
    │                                       * delete()
    │                                     - Statics:
    │                                       * getConversation()
    │                                       * getRoomMessages()
    │                                       * getUnreadMessages()
    │
    ├── 📁 controllers/                   🎮 BUSINESS LOGIC
    │   ├── 📄 authController.js          🔐 AUTHENTICATION
    │   │                                 - Register user
    │   │                                 - Login user
    │   │                                 - Token refresh
    │   │                                 - Token verification
    │   │                                 - Logout
    │   │                                 - Get current user
    │   │                                 Functions:
    │   │                                 - register()
    │   │                                 - login()
    │   │                                 - refreshToken()
    │   │                                 - verifyToken()
    │   │                                 - logout()
    │   │                                 - getCurrentUser()
    │   │
    │   ├── 📄 habitController.js         📋 HABIT OPERATIONS
    │   │                                 - CRUD habits
    │   │                                 - Mark complete/incomplete
    │   │                                 - Archive/restore
    │   │                                 - Reorder habits
    │   │                                 - Get statistics
    │   │                                 Functions:
    │   │                                 - getHabits()
    │   │                                 - getHabit()
    │   │                                 - createHabit()
    │   │                                 - updateHabit()
    │   │                                 - markHabitComplete()
    │   │                                 - undoHabitComplete()
    │   │                                 - deleteHabit()
    │   │                                 - reorderHabits()
    │   │                                 - getHabitStats()
    │   │
    │   ├── 📄 userController.js          👨 USER PROFILE
    │   │                                 - Get profile
    │   │                                 - Update profile
    │   │                                 - Change preferences
    │   │                                 - Change password
    │   │                                 - Delete account
    │   │                                 Functions:
    │   │                                 - getUserProfile()
    │   │                                 - updateProfile()
    │   │                                 - updatePreferences()
    │   │                                 - changePassword()
    │   │                                 - deleteAccount()
    │   │
    │   └── 📄 communityController.js     🌐 COMMUNITY FEATURES
    │                                     - Send/receive messages
    │                                     - Group chat
    │                                     - Unread tracking
    │                                     - Reactions
    │                                     Functions:
    │                                     - sendDirectMessage()
    │                                     - getConversation()
    │                                     - sendRoomMessage()
    │                                     - getRoomMessages()
    │                                     - getUnreadCount()
    │                                     - addReaction()
    │                                     - removeReaction()
    │                                     - deleteMessage()
    │
    ├── 📁 routes/                        🛣️  API ROUTES
    │   ├── 📄 authRoutes.js              /api/v1/auth/*
    │   │                                 - POST /register
    │   │                                 - POST /login
    │   │                                 - POST /refresh-token
    │   │                                 - GET /me
    │   │                                 - POST /verify
    │   │                                 - POST /logout
    │   │
    │   ├── 📄 habitRoutes.js             /api/v1/habits/*
    │   │                                 - GET / (list all)
    │   │                                 - GET /:id
    │   │                                 - POST / (create)
    │   │                                 - PUT /:id (update)
    │   │                                 - POST /:id/complete
    │   │                                 - POST /:id/undo
    │   │                                 - PATCH /:id/archive
    │   │                                 - PATCH /:id/restore
    │   │                                 - DELETE /:id
    │   │
    │   ├── 📄 userRoutes.js              /api/v1/users/*
    │   │                                 - GET /:userId
    │   │                                 - PUT /me
    │   │                                 - PATCH /me/preferences
    │   │                                 - POST /me/change-password
    │   │                                 - DELETE /me
    │   │
    │   └── 📄 communityRoutes.js         /api/v1/community/*
    │                                     - POST /messages (send)
    │                                     - GET /messages/:userId
    │                                     - POST /rooms/:id/messages
    │                                     - GET /rooms/:id/messages
    │                                     - GET /messages/unread/count
    │                                     - GET /messages/unread
    │                                     - POST /messages/:id/reactions
    │                                     - DELETE /messages/:id
    │
    ├── 📁 middleware/                    ⚙️  MIDDLEWARE
    │   ├── 📄 auth.js                    🔑 AUTHENTICATION MIDDLEWARE
    │   │                                 - authenticate()
    │   │                                   * Verify JWT token
    │   │                                   * Check user exists
    │   │                                   * Attach user to request
    │   │                                 - authorize()
    │   │                                   * Check user role/permissions
    │   │
    │   └── 📄 errorHandler.js            ⚠️  ERROR HANDLER MIDDLEWARE
    │                                     - Global error catching
    │                                     - Standardized error responses
    │                                     - Error type detection
    │                                     - Logging
    │
    └── 📁 utils/                         🛠️  UTILITY FUNCTIONS
        ├── 📄 logger.js                  📝 LOGGING UTILITY
        │                                 - Consistent logging across app
        │                                 - Levels: error, warn, info, debug
        │                                 - Functions:
        │                                   * error()
        │                                   * warn()
        │                                   * info()
        │                                   * debug()
        │
        ├── 📄 validators.js              ✔️  INPUT VALIDATORS
        │                                 - Email validation
        │                                 - Password strength check
        │                                 - Habit data validation
        │                                 - User data validation
        │                                 - Input sanitization
        │                                 - Functions:
        │                                   * isValidEmail()
        │                                   * validatePassword()
        │                                   * validateHabit()
        │                                   * validateUserData()
        │                                   * sanitizeInput()
        │
        └── 📄 response.js                📤 RESPONSE FORMATTER
                                          - Standardized API responses
                                          - Success/error formatting
                                          - Pagination support
                                          - Functions:
                                            * success()
                                            * error()
                                            * validationError()
                                            * paginated()
                                            * sendResponse()
```

---

## File Purposes & Relationships

### Entry Point Flow

```
server.js (START HERE)
├── config/database.js (connects to MongoDB)
├── Load middleware (cors, helmet, morgan)
├── Register routes:
│   ├── authRoutes.js → authController.js → User model
│   ├── habitRoutes.js → habitController.js → Habit model
│   ├── userRoutes.js → userController.js → User model
│   └── communityRoutes.js → communityController.js → ChatMessage model
├── errorHandler.js (catches all errors)
└── Start listening on PORT
```

### Request Flow (Example: Create Habit)

```
Client (Flutter)
↓
POST /api/v1/habits
{"title": "Exercise", ...}
↓
habitRoutes.js (route definition)
↓
authenticate middleware (checks JWT token)
↓
habitController.createHabit() (business logic)
├── validators.validateHabit() (check input)
├── Habit model (save to MongoDB)
└── response.js (format response)
↓
Response sent to client
```

### Authentication Flow

```
1. POST /auth/register or /auth/login
   ↓
   authController.register/login()
   ├── validators.validateUserData()
   ├── User.create() or User.findByEmail()
   ├── bcryptjs.hash() (hash password)
   └── authController.generateTokens()
   ↓
   Returns: { accessToken (15m), refreshToken (7d) }

2. Client stores tokens

3. Client makes request with token:
   GET /api/v1/habits
   Header: Authorization: Bearer <accessToken>
   ↓
   middleware/auth.js authenticate()
   ├── Extract token
   ├── jwt.verify(token)
   ├── User.findById()
   ├── Attach user to req.user
   └── Continue to controller
   ↓
   Request succeeds

4. When accessToken expires:
   POST /auth/refresh-token
   { refreshToken }
   ↓
   authController.refreshToken()
   ├── jwt.verify(refreshToken)
   ├── Generate new tokens
   └── Return new accessToken + refreshToken
   ↓
   Client updates stored tokens
```

---

## Database Relationships

```
User (1 user)
├── Multiple Habits (has many)
│   ├── Habit 1
│   ├── Habit 2
│   └── Habit 3
│
└── Multiple ChatMessages (sends/receives)
    ├── Message to User A
    ├── Message to User B
    └── Message in Room "general"

ChatMessage (references)
├── senderId → User
├── receiverId → User (for direct messages, null for groups)
└── roomId → Group identifier
```

---

## Important File Functions Quick Reference

### Models

| File | Key Functions | Purpose |
|------|---------------|---------|
| User.js | comparePassword(), toPublicJSON(), findByEmail() | User authentication & profile |
| Habit.js | markComplete(), markIncomplete(), getUserStats() | Habit tracking & statistics |
| ChatMessage.js | addReaction(), markAsRead(), delete() | Message management |

### Controllers

| File | Key Functions | Purpose |
|------|---------------|---------|
| authController.js | register, login, refreshToken | User authentication |
| habitController.js | createHabit, markComplete, deleteHabit | Habit CRUD operations |
| userController.js | updateProfile, changePassword | User management |
| communityController.js | sendDirectMessage, addReaction | Chat & messaging |

### Utilities

| File | Key Functions | Purpose |
|------|---------------|---------|
| logger.js | error(), warn(), info(), debug() | Application logging |
| validators.js | validatePassword(), validateHabit() | Input validation |
| response.js | success(), error(), paginated() | API response formatting |

---

## Development Workflow

### When Adding a New Feature

1. **Create Model** (src/models/)
   - Define schema and validation
   - Add methods for business logic
   - Create indexes for performance

2. **Create Controller** (src/controllers/)
   - Write business logic functions
   - Use validators
   - Format responses

3. **Create Routes** (src/routes/)
   - Define endpoints
   - Add middleware as needed
   - Comment with examples

4. **Update Server** (server.js)
   - Import new routes
   - Register routes with express

5. **Test**
   - Use Postman/cURL
   - Verify response format
   - Check error handling

---

## Code Comments Convention

Every file has:

```javascript
/**
 * ============================================
 * Feature Name
 * ============================================
 * 
 * Description of what this file does
 * Key exports or functions
 */
```

Every function has:

```javascript
/**
 * What this function does
 * 
 * @param {type} paramName - Description
 * @returns {type} Description
 * 
 * Usage:
 * functionName(param1, param2)
 */
```

---

## Testing Files Location

To test each component:

| Component | File | How to Test |
|-----------|------|-----------|
| Auth | authController.js | POST /auth/register → POST /auth/login |
| Habits | habitController.js | POST /habits → PUT /habits/:id |
| Users | userController.js | PUT /users/me → POST /users/me/change-password |
| Chat | communityController.js | POST /community/messages |

---

## Debugging Tips

1. **Check Logs** - Look at console output for errors
2. **Check DB** - Use MongoDB Compass to inspect data
3. **Use Postman** - Test endpoints individually
4. **Read Error Messages** - They often contain the solution
5. **Check .env** - Make sure all variables are set

---

That's it! You now understand the complete backend structure. 🎉

Start with `server.js` and trace through to understand how requests flow through the system!
