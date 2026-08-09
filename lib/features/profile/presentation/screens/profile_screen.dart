import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:safe/core/design/design.dart';
import 'package:safe/core/providers/theme_provider.dart';
import 'package:safe/core/router/route_names.dart';
import 'package:safe/features/auth/domain/models/user.dart';
import 'package:safe/features/auth/presentation/providers/auth_provider.dart';
import 'package:safe/features/community/presentation/screens/create_post_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingAvatar = false;

  Future<void> _pickAndUploadAvatar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    setState(() => _isUploadingAvatar = true);
    try {
      final file = File(picked.path);
      final storageRef = FirebaseStorage.instance
          .ref().child('avatars').child('${const Uuid().v4()}.jpg');
      await storageRef.putFile(file);
      final url = await storageRef.getDownloadURL();
      await ref.read(authNotifierProvider.notifier).updateProfile(avatarUrl: url);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAvatar = false);
    }
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).logout();
              if (mounted) context.goNamed(RouteNames.login);
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showEditPersonalInfo() {
    final user = ref.read(authNotifierProvider).valueOrNull;
    final firstNameCtrl = TextEditingController(text: user?.firstName ?? '');
    final lastNameCtrl = TextEditingController(text: user?.lastName ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Information', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: firstNameCtrl, decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: lastNameCtrl, decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            Text('Email: ${user?.email ?? 'N/A'}', style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: Theme.of(ctx).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await ref.read(authNotifierProvider.notifier).updateProfile(
                    firstName: firstNameCtrl.text.trim(),
                    lastName: lastNameCtrl.text.trim(),
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!')));
                  }
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _NotificationSettings(),
    );
  }

  void _showSecurityPrivacy() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _SecurityPrivacySheet(
        onChangePassword: () async {
          Navigator.pop(ctx);
          final user = ref.read(authNotifierProvider).valueOrNull;
          if (user != null) {
            try {
              await ref.read(authNotifierProvider.notifier).sendPasswordReset(user.email);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset email sent!')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
          }
        },
      ),
    );
  }

  void _showHelpSupport() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Help & Support', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(leading: const Icon(Icons.email_outlined), title: const Text('Contact Us'), subtitle: const Text('support@safe-app.com'), onTap: () {}),
              ListTile(leading: const Icon(Icons.bug_report_outlined), title: const Text('Report a Bug'), onTap: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bug report feature coming soon'))); }),
              ListTile(leading: const Icon(Icons.info_outline), title: const Text('About'), subtitle: const Text('SAFE v0.1.0'), onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.settings_rounded), onPressed: () {}),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            // ─── Profile Header ───
            _buildProfileHeader(theme, userAsync.valueOrNull).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
            const SizedBox(height: AppSpacing.xl),

            // ─── Action Buttons Row ───
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionChip(theme, Icons.add_circle_outline, 'Add Story', () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.hourglass_empty_rounded, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Coming Soon'),
                        ],
                      ),
                      content: const Text('Stories feature is under development and will be available soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(width: 12),
                _buildActionChip(theme, Icons.post_add, 'New Post', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePostScreen()));
                }),
              ],
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),
            const SizedBox(height: AppSpacing.xxxl),

            // ─── Stats ───
            _buildStatsGrid(theme).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1),
            const SizedBox(height: AppSpacing.xxxl),

            // ─── Theme Toggle ───
            Align(alignment: Alignment.centerLeft, child: Text('Appearance', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: AppSpacing.md),
            _buildThemeToggles(theme).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
            const SizedBox(height: AppSpacing.xxxl),

            // ─── Settings List ───
            Align(alignment: Alignment.centerLeft, child: Text('Account', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))).animate(delay: 400.ms).fadeIn(),
            const SizedBox(height: AppSpacing.md),
            _buildSettingsList(theme).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(ThemeData theme, IconData icon, String label, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: theme.colorScheme.primary),
      label: Text(label, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
      onPressed: onTap,
      side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, User? user) {
    final firstName = user?.firstName ?? 'User';
    final lastName = user?.lastName ?? '';
    final email = user?.email ?? 'user@example.com';
    final avatarUrl = user?.avatarUrl;
    final initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U';

    return Column(
      children: [
        GestureDetector(
          onTap: _pickAndUploadAvatar,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.surface,
                  child: _isUploadingAvatar
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : avatarUrl != null
                          ? CircleAvatar(radius: 44, backgroundImage: NetworkImage(avatarUrl))
                          : CircleAvatar(
                              radius: 44,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Text(initial, style: theme.textTheme.displayMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                            ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle, border: Border.all(color: theme.colorScheme.surface, width: 3)),
                child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('$firstName $lastName', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.xs),
        Text(email, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(color: AppColors.secondarySeed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.chipRadius)),
          child: Text('Architect Level 5', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.secondarySeed, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildStatItem(theme, title: 'Rank', value: '#12', icon: Icons.emoji_events_rounded)),
        Container(width: 1, height: 40, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        Expanded(child: _buildStatItem(theme, title: 'Deep Work', value: '142h', icon: Icons.timer_rounded)),
        Container(width: 1, height: 40, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        Expanded(child: _buildStatItem(theme, title: 'Days', value: '45', icon: Icons.local_fire_department_rounded)),
      ],
    );
  }

  Widget _buildStatItem(ThemeData theme, {required String title, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(title, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildThemeToggles(ThemeData theme) {
    final themeState = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDark = themeState.themeMode == ThemeMode.system
        ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
        : themeState.themeMode == ThemeMode.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          SwitchListTile.adaptive(title: const Text('Dark Mode'), subtitle: const Text('Toggle app dark theme'), secondary: const Icon(Icons.dark_mode_rounded), value: isDark, onChanged: themeNotifier.toggleDarkMode),
          Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
          SwitchListTile.adaptive(
            title: const Text('Theme Color'),
            subtitle: Text(themeState.useBlueTheme ? 'Light Blue Mode' : 'Brown Mode'),
            secondary: Icon(Icons.palette_rounded, color: themeState.useBlueTheme ? AppColors.primarySeed : AppColors.secondarySeed),
            activeTrackColor: AppColors.primarySeed.withValues(alpha: 0.5),
            activeThumbColor: AppColors.primarySeed,
            inactiveThumbColor: AppColors.secondarySeed,
            inactiveTrackColor: AppColors.secondarySeed.withValues(alpha: 0.3),
            value: themeState.useBlueTheme,
            onChanged: themeNotifier.setUseBlueTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildSettingsTile(theme, Icons.person_outline_rounded, 'Personal Information', _showEditPersonalInfo),
          _buildDivider(theme),
          _buildSettingsTile(theme, Icons.notifications_none_rounded, 'Notifications', _showNotificationSettings),
          _buildDivider(theme),
          _buildSettingsTile(theme, Icons.security_rounded, 'Security & Privacy', _showSecurityPrivacy),
          _buildDivider(theme),
          _buildSettingsTile(theme, Icons.help_outline_rounded, 'Help & Support', _showHelpSupport),
          _buildDivider(theme),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            title: Text('Sign Out', style: TextStyle(color: theme.colorScheme.error)),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(ThemeData theme, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(title),
      trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
      onTap: onTap,
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2));
  }
}

// ─── Notification Settings Sheet ───
class _NotificationSettings extends StatefulWidget {
  @override
  State<_NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<_NotificationSettings> {
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _communityEnabled = true;
  bool _habitReminders = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SwitchListTile(title: const Text('Push Notifications'), value: _pushEnabled, onChanged: (v) => setState(() => _pushEnabled = v)),
            SwitchListTile(title: const Text('Email Notifications'), value: _emailEnabled, onChanged: (v) => setState(() => _emailEnabled = v)),
            SwitchListTile(title: const Text('Community Updates'), value: _communityEnabled, onChanged: (v) => setState(() => _communityEnabled = v)),
            SwitchListTile(title: const Text('Habit Reminders'), value: _habitReminders, onChanged: (v) => setState(() => _habitReminders = v)),
          ],
        ),
      ),
    );
  }
}

// ─── Security & Privacy Sheet ───
class _SecurityPrivacySheet extends StatelessWidget {
  const _SecurityPrivacySheet({required this.onChangePassword});

  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Security & Privacy', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Change Password'), subtitle: const Text('Send password reset email'), onTap: onChangePassword),
            ListTile(leading: const Icon(Icons.visibility_off_outlined), title: const Text('Private Profile'), subtitle: const Text('Coming soon'), onTap: () {}),
            ListTile(leading: const Icon(Icons.delete_outline, color: Colors.red), title: const Text('Delete Account', style: TextStyle(color: Colors.red)), subtitle: const Text('This action cannot be undone'), onTap: () {}),
          ],
        ),
      ),
    );
  }
}
