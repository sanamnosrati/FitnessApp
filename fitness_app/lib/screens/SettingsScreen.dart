import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSection(
            title: 'Account',
            children: [
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  // TODO: Navigate to profile
                },
              ),
              _buildSettingsTile(
                icon: Icons.notifications_none,
                title: 'Notifications',
                onTap: () {
                  // TODO: Navigate to notifications
                },
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy',
                onTap: () {
                  // TODO: Navigate to privacy settings
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Preferences',
            children: [
              _buildSettingsTile(
                icon: Icons.fitness_center,
                title: 'Workout Preferences',
                onTap: () {
                  // TODO: Navigate to workout preferences
                },
              ),
              _buildSettingsTile(
                icon: Icons.track_changes,
                title: 'Goals',
                onTap: () {
                  // TODO: Navigate to goals
                },
              ),
              _buildSettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () {
                  // TODO: Navigate to language settings
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Support',
            children: [
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {
                  // TODO: Navigate to help center
                },
              ),
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  // TODO: Navigate to about page
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Sign Out',
            onPressed: () {
              // TODO: Handle sign out
            },
            isOutlined: true,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }
}
