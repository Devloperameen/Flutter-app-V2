# Community Chat - Architecture Diagram

## 📊 Complete System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         FLUTTER APP                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │              PRESENTATION LAYER (UI)                       │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │                                                              │  │
│  │  ┌──────────────────┐          ┌──────────────────┐        │  │
│  │  │ community_screen │          │ community_chat_  │        │  │
│  │  │                  │ ────────► │ screen           │        │  │
│  │  │ [Posts] [Chat]   │          │ (Real-time UI)   │        │  │
│  │  └──────────────────┘          └──────────────────┘        │  │
│  │                                                              │  │
│  │                        ▲                                     │  │
│  │                        │                                     │  │
│  └────────────────────────┼─────────────────────────────────────┘  │
│                           │                                         │
│  ┌────────────────────────▼─────────────────────────────────────┐  │
│  │              STATE MANAGEMENT (Riverpod)                    │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │                                                              │  │
│  │  ┌────────────────────┐      ┌────────────────────┐        │  │
│  │  │ community_provider │      │ chat_provider      │        │  │
│  │  │ (Posts state)      │      │ (Chat state)       │        │  │
│  │  │                    │      │                    │        │  │
│  │  │ - Posts stream     │      │ - Messages stream  │        │  │
│  │  │ - Toggle like      │      │ - Send message     │        │  │
│  │  │ - Refresh          │      │ - Delete message   │        │  │
│  │  │                    │      │ - User info        │        │  │
│  │  └────────────────────┘      └────────────────────┘        │  │
│  │                                                              │  │
│  │                        ▲                                     │  │
│  │                        │                                     │  │
│  └────────────────────────┼─────────────────────────────────────┘  │
│                           │                                         │
│  ┌────────────────────────▼─────────────────────────────────────┐  │
│  │            BUSINESS LOGIC (Repositories)                    │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │                                                              │  │
│  │  ┌──────────────────┐      ┌──────────────────────┐        │  │
│  │  │ community_       │      │ community_chat_      │        │  │
│  │  │ repository       │      │ repository           │        │  │
│  │  │ (Posts logic)    │      │ (Chat logic)         │        │  │
│  │  │                  │      │                      │        │  │
│  │  │ - Get posts      │      │ - Send message       │        │  │
│  │  │ - Like post      │      │ - Get messages       │        │  │
│  │  │ - Create post    │      │ - Delete message     │        │  │
│  │  │ - Stream posts   │      │ - Messages stream    │        │  │
│  │  └──────────────────┘      └──────────────────────┘        │  │
│  │                                                              │  │
│  │                        ▲                                     │  │
│  │                        │                                     │  │
│  └────────────────────────┼─────────────────────────────────────┘  │
│                           │                                         │
│  ┌────────────────────────▼─────────────────────────────────────┐  │
│  │        DATA ACCESS (Firestore Datasources)                  │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │                                                              │  │
│  │  ┌──────────────────┐      ┌──────────────────────┐        │  │
│  │  │ community_       │      │ community_chat_      │        │  │
│  │  │ firestore_       │      │ firestore_           │        │  │
│  │  │ datasource       │      │ datasource           │        │  │
│  │  │ (Posts DB)       │      │ (Chat DB)            │        │  │
│  │  │                  │      │                      │        │  │
│  │  │ - Query posts    │      │ - Send message       │        │  │
│  │  │ - Update likes   │      │ - Stream messages    │        │  │
│  │  │ - Add post       │      │ - Delete message     │        │  │
│  │  │ - Stream posts   │      │ - Paginate messages  │        │  │
│  │  └──────────────────┘      └──────────────────────┘        │  │
│  │                                                              │  │
│  │                        ▲                                     │  │
│  └────────────────────────┼─────────────────────────────────────┘  │
│                           │                                         │
└───────────────────────────┼─────────────────────────────────────────┘
                            │
                    ┌───────▼────────┐
                    │   FIREBASE     │
                    │   FIRESTORE    │
                    └────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
    ┌───▼────┐          ┌───▼────┐         ┌───▼────┐
    │ Posts  │          │ Chat   │         │ Auth   │
    │ Posts  │          │ Main/  │         │ Users  │
    │ Likes  │          │ Messages          │ Tokens │
    │        │          │        │         │        │
    └────────┘          └────────┘         └────────┘
```

## 🔄 Real-Time Message Flow

```
┌──────────────┐
│   User A     │
│   Types: Hi  │  ─────►  ┌──────────────────┐
└──────────────┘          │  TextField       │
                          │  Input captured  │
                          └────────┬─────────┘
                                   │
                                   ▼
                          ┌──────────────────┐
                          │  Validate Input  │
                          │  (not empty)     │
                          └────────┬─────────┘
                                   │
                                   ▼
                          ┌──────────────────┐
                          │ Get Current User │
                          │ from Firebase    │
                          │ Auth             │
                          └────────┬─────────┘
                                   │
                                   ▼
                          ┌──────────────────┐
                          │ sendMessage()    │
                          │ in Repository    │
                          └────────┬─────────┘
                                   │
                                   ▼
        ┌──────────────────────────────────────────────────────┐
        │  CommunityChatFirestoreDataSource                    │
        │  - Create document with userId, userName, message   │
        │  - Set timestamp                                     │
        │  - Validate fields                                   │
        └────────────────────────┬─────────────────────────────┘
                                 │
                                 ▼
        ┌────────────────────────────────────────────────────┐
        │  FIRESTORE (Real-time Database)                    │
        │  community_chat/main/messages/{msgId}             │
        │  {                                                 │
        │    userId: "user_a",                              │
        │    userName: "User A",                            │
        │    message: "Hi",                                 │
        │    createdAt: "2024-01-15T14:30:00Z"             │
        │  }                                                 │
        └────────────────┬─────────────────────────────────┘
                         │
                         ▼ (Listener triggered)
                    
                    ┌─────────────────────────┐
                    │ Firestore Listener      │
                    │ (All connected clients) │
                    │ orderBy('createdAt')    │
                    └────────────┬────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
        ▼                        ▼                        ▼
   ┌─────────┐             ┌─────────┐             ┌─────────┐
   │ User A  │             │ User B  │             │ User C  │
   │App 1    │             │App 1    │             │App 1    │
   └────┬────┘             └────┬────┘             └────┬────┘
        │                       │                       │
        ▼                       ▼                       ▼
   ┌─────────┐             ┌─────────┐             ┌─────────┐
   │ Stream  │             │ Stream  │             │ Stream  │
   │ Provider│             │ Provider│             │ Provider│
   └────┬────┘             └────┬────┘             └────┬────┘
        │                       │                       │
        ▼                       ▼                       ▼
   ┌─────────┐             ┌─────────┐             ┌─────────┐
   │Stream-  │             │Stream-  │             │Stream-  │
   │Builder  │             │Builder  │             │Builder  │
   └────┬────┘             └────┬────┘             └────┬────┘
        │                       │                       │
        ▼                       ▼                       ▼
   ┌──────────┐            ┌──────────┐            ┌──────────┐
   │UI Update │            │UI Update │            │UI Update │
   │ Message  │            │ Message  │            │ Message  │
   │ appears  │            │ appears  │            │ appears  │
   └──────────┘            └──────────┘            └──────────┘

   ALL IN REAL-TIME! ⚡
   No refresh needed
   Instant updates
```

## 🏗️ Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                         │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         UI Screens & Widgets                         │   │
│  │  - community_screen.dart                             │   │
│  │  - community_chat_screen.dart                        │   │
│  │  - Message bubbles, input, etc.                      │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         Riverpod Providers & Notifiers              │   │
│  │  - Chat providers                                    │   │
│  │  - State management                                  │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       │ (Depends on)
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         Business Logic Models                        │   │
│  │  - ChatMessage (Freezed model)                       │   │
│  │  - Post (existing)                                   │   │
│  │  - Pure data, no dependencies                        │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         Repository Interfaces                        │   │
│  │  - Contracts/Abstractions                            │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       │ (Implements)
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                     DATA LAYER                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │      Repository Implementation                       │   │
│  │  - CommunityRepository                               │   │
│  │  - CommunityChatRepository                           │   │
│  │  - Error handling, validation                        │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         Datasources (Firestore Access)               │   │
│  │  - CommunityFirestoreDatasource                      │   │
│  │  - CommunityChatFirestoreDatasource                  │   │
│  │  - Queries, streams, mutations                       │   │
│  └──────────────────────────────────────────────────────┘   │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       │ (Calls)
                       ▼
        ┌──────────────────────────────────┐
        │    FIREBASE FIRESTORE            │
        │                                  │
        │  community_chat/main/messages/  │
        │                                  │
        │  Real-time database              │
        └──────────────────────────────────┘
```

## 🔐 Security Flow

```
User Action (Send Message)
        │
        ▼
┌──────────────────────────────┐
│ Client-Side Validation       │
│ - Message not empty?         │
│ - User authenticated?        │
│ - Max length check?          │
└───────────┬──────────────────┘
            │
            ▼
┌──────────────────────────────┐
│ Send to Firestore            │
│ with:                        │
│ - userId (from auth)         │
│ - userName                   │
│ - message                    │
│ - timestamp                  │
└───────────┬──────────────────┘
            │
            ▼
┌──────────────────────────────────────────┐
│ FIRESTORE SERVER-SIDE VALIDATION         │
│                                          │
│ Rules check:                             │
│ 1. User authenticated? ✓                 │
│ 2. userId == request.auth.uid? ✓         │
│ 3. Has required fields? ✓                │
│ 4. Message not empty? ✓                  │
│ 5. Message < 5000 chars? ✓               │
│ 6. Timestamp valid? ✓                    │
│                                          │
│ All checks pass ✓ → Save to DB           │
│ Any check fails ✗ → Reject               │
└──────────────────────────────────────────┘
            │
            ▼
┌──────────────────────────────┐
│ Document Saved to Firestore  │
└───────────┬──────────────────┘
            │
            ▼
┌──────────────────────────────┐
│ Stream Listener Updated       │
│ (all connected clients)       │
└───────────┬──────────────────┘
            │
            ▼
┌──────────────────────────────┐
│ UI Updated Instantly         │
│ Message appears for all      │
└──────────────────────────────┘
```

## 📱 Screen Navigation Flow

```
┌────────────────────────────────┐
│   Main App                     │
└────────────┬───────────────────┘
             │
             ▼
┌────────────────────────────────┐
│   Community Screen             │
│  (TabBarView with 2 tabs)      │
├────────────────────────────────┤
│ ┌────────────┬───────────────┐ │
│ │ [Posts]    │ [Chat] ← HERE │ │
│ └─────┬──────┴───────┬───────┘ │
│       │              │         │
│       ▼              ▼         │
│  ┌─────────┐  ┌────────────┐  │
│  │ Posts   │  │ Chat       │  │
│  │ Screen  │  │ Screen     │  │
│  │         │  │ (New)      │  │
│  │ - Feed  │  │ - Messages │  │
│  │ - Like  │  │ - Input    │  │
│  │ - Video │  │ - Delete   │  │
│  │ - FAB   │  │ - Real-time│  │
│  └─────────┘  └────────────┘  │
│                                │
└────────────────────────────────┘
```

## 🔄 Data Flow Diagram

```
┌──────────┐
│   User   │
│   Input  │
└────┬─────┘
     │ "Hello!"
     ▼
┌─────────────────────────┐
│ ChatNotifier            │
│ sendMessage()           │
└────┬────────────────────┘
     │
     ▼
┌──────────────────────────────────┐
│ Repository                       │
│ sendMessage(...)                 │
└────┬─────────────────────────────┘
     │
     ▼
┌──────────────────────────────────┐
│ Firestore Datasource             │
│ - Create document                │
│ - Set fields                     │
│ - Timestamp                      │
└────┬─────────────────────────────┘
     │
     ▼
┌──────────────────────────────────┐
│ Firestore Database               │
│ Saves: {userId, userName,        │
│        message, createdAt}       │
└────┬─────────────────────────────┘
     │
     ▼
┌──────────────────────────────────┐
│ Listener Triggered               │
│ (all clients watching)           │
└────┬─────────────────────────────┘
     │
     ├─────────┬────────────┬─────────┐
     ▼         ▼            ▼         ▼
  ┌────┐   ┌────┐      ┌────┐    ┌────┐
  │ U1 │   │ U2 │      │ U3 │    │ U4 │
  │UI  │   │UI  │      │UI  │    │UI  │
  │Upd │   │Upd │      │Upd │    │Upd │
  │ates│   │ates│      │ates│    │ates│
  └────┘   └────┘      └────┘    └────┘
   Show     Show       Show      Show
   New      New        New       New
   Message  Message    Message   Message
   (instant) (instant) (instant) (instant)
```

---

All diagrams show the complete flow of real-time community chat from user input to all clients receiving updates instantly! ⚡
