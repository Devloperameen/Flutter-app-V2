# Quick Start Testing Guide

## Installation (1 minute)

```bash
flutter install build/app/outputs/flutter-apk/app-debug.apk
```

## Fast Test (5 minutes)

### Test 1: Timer
1. Open app → Focus Timer
2. Tap "Custom"
3. Enter 1 minute
4. Tap OK
5. Wait for timer → completion dialog appears
✅ Expected: "Session Completed!" with XP earned

### Test 2: Chat Ordering
1. Community → Chat
2. Send 3 messages rapidly
3. Verify order: oldest at top, newest at bottom
✅ Expected: Messages like Telegram (NOT reversed)

### Test 3: Delete Message
1. Long-press your message
2. Confirm delete
3. Message disappears after 5 seconds
✅ Expected: Message deleted successfully

### Test 4: Posts Loading
1. Community → Posts
2. Wait 10 seconds
3. Posts appear or "No posts yet"
✅ Expected: NO infinite spinner

## Check Build Status

```bash
adb logcat -s flutter:V | grep "✅\|❌"
```

Watch for: ✅ Socket.IO CONNECTED

## If All Tests Pass

```bash
git add .
git commit -m "fix: all 4 features tested and working"
git push origin main
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| APK won't install | `adb shell pm clear com.safe.app` then reinstall |
| Timer doesn't work | Wait 2-3 seconds, check logs |
| Chat order wrong | Pull down to refresh |
| Posts don't load | Wait 10+ seconds, check internet |
| Delete fails | Verify you're the sender |

---

**Status:** ✅ READY FOR COMPETITION

