import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_theme.dart';
import '../services/user_settings_service.dart';
import '../services/auth_service.dart';

import 'ProfileScreen.dart';
import 'about_us_screen.dart';
import 'help_center_screen.dart';
import 'NotificationScreen.dart';
import 'LanguageScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';
  bool isLoading = true;
  bool isLoggingOut = false;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final language = await UserSettingsService.getLanguage();

    if (!mounted) return;

    setState(() {
      selectedLanguage = language;
      isLoading = false;
    });
  }

  Future<void> _openLanguageScreen() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LanguageScreen(currentLanguage: selectedLanguage),
      ),
    );

    if (result == null) return;

    setState(() {
      selectedLanguage = result;
    });
  }

  Future<void> _logout() async {
    setState(() => isLoggingOut = true);

    await AuthService.signOut();

    if (!mounted) return;

    setState(() => isLoggingOut = false);
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _logout();
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final passwordController = TextEditingController();

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This will permanently delete your account. Please enter your password to confirm.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      passwordController.dispose();
      return;
    }

    final password = passwordController.text.trim();
    passwordController.dispose();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() => isDeleting = true);

      await AuthService.reauthenticateWithPassword(password);
      await AuthService.deleteAccount();

      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;

      setState(() => isDeleting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not delete account. Password may be wrong.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (shouldDelete != true) return;

    try {
      setState(() => isDeleting = true);

      await AuthService.deleteAccount();

      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;

      setState(() => isDeleting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not delete account. Please log out, sign in again and try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionLoading = isLoggingOut || isDeleting;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Settings', showBackButton: false),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
              : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 28),

                  _buildSettingsItem(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: selectedLanguage,
                    onTap: _openLanguageScreen,
                  ),

                  _buildSettingsItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Manage your daily reminders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),

                  _buildSettingsItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About Us',
                    subtitle: 'Learn more about Fitness App',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutUsScreen(),
                        ),
                      );
                    },
                  ),

                  _buildSettingsItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpCenterScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  CustomButton(
                    text: isLoggingOut ? 'Logging out...' : 'Log Out',
                    icon: Icons.logout_rounded,
                    isOutlined: true,
                    onPressed:
                        actionLoading
                            ? () {}
                            : () async {
                              await _confirmLogout();
                            },
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed:
                          actionLoading
                              ? () {}
                              : () async {
                                await _confirmDeleteAccount();
                              },
                      icon: const Icon(Icons.delete_forever_rounded),
                      label: Text(
                        isDeleting
                            ? 'Deleting account...'
                            : 'Delete My Account',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildProfileHeader() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      },
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 62,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Sanam Hadadnosrati',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap to edit profile',
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Icon(icon, color: AppTheme.primaryColor, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 13,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
