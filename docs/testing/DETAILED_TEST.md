# Detailed Testing Procedures

## Timer Testing

### Minutes Input
```
1. Tap "Custom"
2. Keep "Minutes" selected
3. Enter: 1 → OK → ✅ Timer starts
4. Enter: 300 → OK → ✅ Max accepted
5. Enter: 301 → OK → ✅ Shows error "Minutes must be 1-300"
```

### Seconds Input
```
1. Tap "Custom"
2. Switch to "Seconds"
3. Enter: 5 → OK → ✅ Shows 0:05, counts down
4. Enter: 18000 → OK → ✅ Max accepted
5. Enter: 18001 → OK → ✅ Shows error "Seconds must be 1-18000"
```

### Completion Dialog
```
1. Create 1 minute session
2. Wait for timer to reach 0:00
3. Dialog appears with:
   ✓ Icon: Check mark
   ✓ Title: "Session Completed!"
   ✓ XP: "XP Earned: +XX"
   ✓ Button: "Continue" (required tap)
4. Tap "Continue"
✅ Dialog closes, returns to timer screen
```

## Chat Testing

### Message Ordering
```
1. Send: "Message 1" (12:30)
2. Send: "Message 2" (12:31)
3. Send: "Message 3" (12:32)
4. Verify screen shows (top to bottom):
   - Message 1 (oldest)
   - Message 2
   - Message 3 (newest)
✅ Order is oldest→newest (like Telegram)
```

### Message Styling
```
1. Send a message
✅ Your message: right side, blue
✅ Other messages: left side, colored by user
✅ Rounded corners: 18° top, 6/18° bottom
✅ Username shows above others' messages
✅ Timestamp in HH:MM format
```

### Emoji Support
```
1. Tap emoji icon 😊
2. Select emoji (e.g., 👍)
3. Send message
✅ Emoji appears in message
```

### Delete Functionality
```
1. Send: "Delete test"
2. Long-press message
3. Dialog: "Delete Message?"
4. Tap "Delete"
5. SnackBar: "Message deleted"
6. After 5 sec: message vanishes
✅ Only your messages show delete option
```

## Posts Testing

### Initial Load
```
1. Community → Posts
2. Wait 5-10 seconds
✅ Posts appear OR "No posts yet" message
✅ NO infinite spinner
```

### Pull-to-Refresh
```
1. On Posts screen
2. Swipe down
3. Loading spinner appears
4. After 2-3 sec: refreshes
✅ Posts update or "No posts yet"
```

### Create Post
```
1. Profile → "New Post"
2. Enter text, optionally add image
3. Tap "Post"
✅ SnackBar: "Posted!"
✅ Post appears in Posts tab
```

## Profile Testing

### Avatar Upload
```
1. Profile → Tap avatar
2. Select image from gallery
3. Upload completes
✅ Avatar displays in circle
✅ SnackBar: "Profile photo updated!"
```

### Edit Profile
```
1. Profile → "Personal Information"
2. Edit first/last name
3. Tap "Save Changes"
✅ SnackBar: "Profile updated!"
✅ Header updates
```

## Socket.IO Verification

```bash
adb logcat -s flutter:V | grep "Socket.IO"
```

Watch for:
- ✅ "Socket.IO initializing: https://flutter-app-v2.onrender.com/socket.io/"
- ✅ "✅✅✅ Socket.IO CONNECTED ✅✅✅"

NOT:
- ❌ "Socket.IO error"
- ❌ ":0" in URL (port issue)

---

**All tests passing = ✅ READY FOR COMPETITION**

