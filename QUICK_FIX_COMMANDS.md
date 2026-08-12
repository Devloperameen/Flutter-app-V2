# Quick Command Reference

## Copy & Paste These Commands

### Fix 1: Super Admin Account

```bash
cd /home/sadiq/FlutterProjects/fitflow_gym/backend && node scripts/fix-super-admin.js
```

**Expected**: ✅ Super Admin account created/updated

---

### Fix 2: Deploy App

```bash
cd /home/sadiq/FlutterProjects/fitflow_gym && flutter run -d R58X904CBJH
```

**Expected**: ✅ App deployed on device

---

## Test Commands

### Login as Super Admin
- Email: `superadmin@fitflow.com`
- Password: `SuperAdmin@2024!Fit`

### Login as Admin
- Email: `admin@fitflow.com`
- Password: `Admin@2024!Gym`

---

## Verify Fixes Work

1. **Posts appear after creation**: Create post → appears immediately ✅
2. **Images display**: Add image → shows in post ✅
3. **Videos display**: Add video → shows in post ✅
4. **Super admin login**: Both accounts can login ✅

---

## If Something Goes Wrong

```bash
# Check Flutter compilation
flutter analyze

# Rebuild app
flutter clean && flutter pub get && flutter build apk --debug

# Run verbose logs
flutter run -d R58X904CBJH --verbose

# Check backend
cd backend && node scripts/fix-super-admin.js
```

---

## Files Modified

| File | Change |
|------|--------|
| `lib/features/community/presentation/providers/community_provider.dart` | Posts fix |
| `backend/scripts/fix-super-admin.js` | Super admin fix (NEW) |

---

## Done! ✅

After running those two commands and testing, everything should work:
- ✅ Posts appear immediately
- ✅ Images/videos display
- ✅ Super admin can login
- ✅ Admin account works

