# 🧪 Testing Checklist - FitFlow App

## Quick Test Instructions

Run the app and test each feature. Check the boxes as you test:

```bash
flutter run
```

---

## ✅ Test 1: App Launch
- [ ] App launches without crashes
- [ ] Dashboard screen loads
- [ ] No red error screens
- [ ] User name displays correctly

---

## ✅ Test 2: Community Chat (Should Work)
**Location**: Bottom nav → Community icon → Chat tab

- [ ] Open community chat
- [ ] Messages load from Firestore
- [ ] Can send a new message
- [ ] Message appears in real-time
- [ ] Timestamp displays correctly

**Expected**: ✅ SHOULD WORK (collection exists)

---

## ✅ Test 3: Habits Tracker (Should Work)
**Location**: Bottom nav → Habits icon

- [ ] Habits screen opens
- [ ] Can create a new habit
- [ ] Habit appears in list
- [ ] Can mark habit complete
- [ ] Streak counter updates
- [ ] Completion animation plays

**Expected**: ✅ SHOULD WORK (collection exists)

---

## ✅ Test 4: Focus Timer (Should Work)
**Location**: Dashboard → Focus Session cards OR Bottom nav → Focus icon

- [ ] Timer screen opens
- [ ] Can start 25-min Deep Work session
- [ ] Can start 50-min Start Mission session
- [ ] Timer counts down
- [ ] Can pause/resume
- [ ] Session completes and saves to Firestore

**Expected**: ✅ SHOULD WORK

---

## ✅ Test 5: Dashboard (Partial - Quote May Fail)
**Location**: Bottom nav → Home icon

- [ ] Dashboard loads
- [ ] User welcome message shows
- [ ] Habit mission card displays (if habits exist)
- [ ] Quick stats show (Energy, Streak)
- [ ] Focus timer cards display
- [ ] **Today's Quote** - May show default text if `quotes` collection missing

**Expected**: ✅ MOSTLY WORKS (quote needs Firebase setup)

---

## ⏳ Test 6: Community Posts (Will Fail - Needs Firebase)
**Location**: Bottom nav → Community icon → Posts tab

- [ ] Posts screen opens
- [ ] Posts load (or empty state)
- [ ] Can create new post
- [ ] Can like posts
- [ ] Can comment on posts

**Expected**: ❌ WILL FAIL - Needs `community_posts` collection in Firebase

---

## ⏳ Test 7: Profile (May Fail - Needs Firebase)
**Location**: Bottom nav → Profile icon

- [ ] Profile screen opens
- [ ] User data displays
- [ ] Stats show correctly
- [ ] Can edit profile
- [ ] Can sign out

**Expected**: ⚠️ MAY PARTIALLY WORK - Depends on `users` collection structure

---

## 📊 Report Your Results

After testing, tell me:

### ✅ What Works:
Example: "Chat works perfectly, habits work, focus timer works"

### ❌ What Doesn't Work:
Example: "Community posts show error, profile crashes"

### ⚠️ Errors/Warnings:
Copy any error messages you see in:
- App UI (red error screens)
- Console output
- Snackbar messages

---

## 🔥 Common Issues & Fixes

### Issue: "Quote not loading on dashboard"
**Fix**: Create `quotes` collection in Firestore:
1. Open Firebase Console
2. Firestore Database → Start Collection
3. Collection ID: `quotes`
4. Add document with fields:
   - `text` (string): "Your inspirational quote"
   - `createdAt` (timestamp): Now

### Issue: "Posts screen crashes"
**Fix**: Create `community_posts` collection (see `QUICK_START_REFERENCE.md`)

### Issue: "Profile shows wrong data"
**Fix**: Check `users/{userId}` document structure matches expected fields

---

## 🚀 Quick Commands

```bash
# Run app
flutter run

# Check for errors
flutter analyze

# Clear cache if needed
flutter clean && flutter pub get

# See logs
flutter run --verbose
```

---

## 📝 Notes for Next Session

When reporting results, include:
1. Which tests passed ✅
2. Which tests failed ❌
3. Any error messages (copy full text)
4. Screenshots of errors (if possible)

This helps me fix remaining issues quickly!
