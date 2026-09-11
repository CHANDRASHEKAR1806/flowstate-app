import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/bottom_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const SettingsScreen({super.key, required this.onNavigate});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final initials = user?.initials ?? 'U';
    final fullName = user?.fullName ?? 'Alex Morgan';
    final email = user?.email ?? 'alex.morgan@company.com';
    final role = user?.role ?? 'Product Designer';
    final department = user?.department ?? 'Product Engineering';

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        currentScreen: 'settings',
        onNavigate: widget.onNavigate,
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Settings & Preferences', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Profile Card
          _ProfileCard(
            initials: initials,
            fullName: fullName,
            email: email,
            role: role,
            department: department,
            onEditProfile: () => _showEditProfileDialog(context, auth, fullName, role, department),
          ),

          const SizedBox(height: 20),

          // Section 1: Appearance
          _SectionHeader(title: 'Appearance'),
          Card(
            elevation: 0,
            color: isDark ? AppColors.surfaceContainerLowDark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryContainer, size: 20),
                  ),
                  title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Switch between light and dark visual mode', style: TextStyle(fontSize: 12)),
                  value: theme.isDarkTheme,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => theme.toggleDarkTheme(val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section 2: Notifications & Reminders
          _SectionHeader(title: 'Notifications & Reminders'),
          Card(
            elevation: 0,
            color: isDark ? AppColors.surfaceContainerLowDark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.notifications_outlined, color: AppColors.secondary, size: 20),
                  ),
                  title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Real-time alerts for scheduled tasks', style: TextStyle(fontSize: 12)),
                  value: theme.pushNotifications,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => theme.togglePushNotifications(val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.wb_sunny_outlined, color: AppColors.tertiary, size: 20),
                  ),
                  title: const Text('Daily Morning Digest', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Receive an 8:00 AM summary of pending goals', style: TextStyle(fontSize: 12)),
                  value: theme.dailyDigest,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => theme.toggleDailyDigest(val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section 3: Preferences & Security
          _SectionHeader(title: 'Preferences & Security'),
          Card(
            elevation: 0,
            color: isDark ? AppColors.surfaceContainerLowDark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.volume_up_outlined, color: Colors.blue, size: 20),
                  ),
                  title: const Text('Sound & Haptic Feedback', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Subtle chime on task completion', style: TextStyle(fontSize: 12)),
                  value: theme.soundHaptics,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => theme.toggleSoundHaptics(val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.fingerprint, color: Colors.purple, size: 20),
                  ),
                  title: const Text('Biometric App Lock', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Require authentication to open Clarity', style: TextStyle(fontSize: 12)),
                  value: theme.biometricLock,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => theme.toggleBiometricLock(val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section 4: Task Data Management
          _SectionHeader(title: 'Data & Workspace'),
          Card(
            elevation: 0,
            color: isDark ? AppColors.surfaceContainerLowDark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.done_all, color: AppColors.secondary, size: 20),
                  ),
                  title: const Text('Mark All Tasks Completed', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Complete all active items in one click', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () => _showConfirmAction(
                    context: context,
                    title: 'Complete All Tasks?',
                    message: 'Are you sure you want to mark all active tasks as completed? This will maximize your daily streak!',
                    confirmLabel: 'Mark All',
                    onConfirm: () async {
                      await taskProvider.markAllCompleted();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All tasks marked completed! 🎉')),
                        );
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_sweep_outlined, color: Colors.orange, size: 20),
                  ),
                  title: const Text('Clear Completed Tasks', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Remove finished items to declutter', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () => _showConfirmAction(
                    context: context,
                    title: 'Clear Completed Tasks?',
                    message: 'This will permanently remove all tasks that are marked as completed from your list.',
                    confirmLabel: 'Clear Tasks',
                    isDestructive: true,
                    onConfirm: () async {
                      await taskProvider.clearCompletedTasks();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Completed tasks cleared.')),
                        );
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.restart_alt, color: AppColors.primary, size: 20),
                  ),
                  title: const Text('Reset Sample Tasks', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  subtitle: const Text('Restore default tasks and momentum data', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () => _showConfirmAction(
                    context: context,
                    title: 'Reset to Sample Data?',
                    message: 'This will restore the 8 starter demo tasks and refresh your workspace.',
                    confirmLabel: 'Reset Data',
                    onConfirm: () async {
                      await taskProvider.resetToSeedTasks();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sample tasks restored successfully.')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section 5: App Info & Session
          _SectionHeader(title: 'App & Session'),
          Card(
            elevation: 0,
            color: isDark ? AppColors.surfaceContainerLowDark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline, size: 20),
                  title: Text('Version', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  trailing: Text('v2.4.0 (Flutter Edition)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.code, size: 20),
                  title: Text('Platform & Framework', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  trailing: Text('Flutter & Dart (Cross-Platform)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.logout, color: AppColors.error, size: 20),
                  ),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.error),
                  ),
                  subtitle: const Text('Log out of your Clarity account', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.error, size: 18),
                  onTap: () => _showSignOutDialog(context, auth),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentScreen: 'settings',
        onNavigate: widget.onNavigate,
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    AuthProvider auth,
    String currentFullName,
    String currentRole,
    String currentDepartment,
  ) {
    final nameCtrl = TextEditingController(text: currentFullName);
    final roleCtrl = TextEditingController(text: currentRole);
    final deptCtrl = TextEditingController(text: currentDepartment);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceContainerLowestDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Edit Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: roleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Job Title / Role',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deptCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    prefixIcon: Icon(Icons.business_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      final newName = nameCtrl.text.trim();
                      if (newName.isNotEmpty) {
                        await auth.updateProfile(
                          fullName: newName,
                          role: roleCtrl.text.trim().isEmpty ? 'Member' : roleCtrl.text.trim(),
                          department: deptCtrl.text.trim().isEmpty ? 'General' : deptCtrl.text.trim(),
                        );
                        if (ctx.mounted) {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated successfully!')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmAction({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive ? AppColors.error : AppColors.primaryContainer,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out of Clarity?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'You will be returned to the sign in screen. Your tasks and settings will remain safely saved on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await auth.logout();
              widget.onNavigate('login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String initials;
  final String fullName;
  final String email;
  final String role;
  final String department;
  final VoidCallback onEditProfile;

  const _ProfileCard({
    required this.initials,
    required this.fullName,
    required this.email,
    required this.role,
    required this.department,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.surfaceContainerLowDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Initials Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryContainer, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$role • $department',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Edit profile button
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: 'Edit Profile',
              onPressed: onEditProfile,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
