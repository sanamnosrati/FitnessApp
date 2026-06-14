import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_theme.dart';
import 'ProfileScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Settings', showBackButton: false),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 28),

          _buildSettingsItem(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: selectedLanguage,
            onTap: _showLanguageBottomSheet,
          ),
          _buildSettingsItem(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Manage your reminders',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.info_outline_rounded,
            title: 'About Us',
            subtitle: 'Learn more about Fitness App',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            subtitle: 'Get help and support',
            onTap: () {},
          ),

          const SizedBox(height: 28),

          CustomButton(
            text: 'Log Out',
            icon: Icons.logout_rounded,
            isOutlined: true,
            onPressed: () {},
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

  void _showLanguageBottomSheet() {
    final languages = [
      'English',
      'Deutsch',
      'Persian',
      'Turkish',
      'Arabic',
      'French',
      'Spanish',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose Language',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...languages.map(
                (language) => ListTile(
                  title: Text(language),
                  trailing:
                      selectedLanguage == language
                          ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.primaryColor,
                          )
                          : null,
                  onTap: () {
                    setState(() {
                      selectedLanguage = language;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
