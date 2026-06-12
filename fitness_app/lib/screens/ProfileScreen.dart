import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/theme/app_theme.dart';

import '../services/profile_service.dart';
import 'EditProfileScreen.dart';
import 'SettingsScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  String name = 'Sanam';
  String goal = 'Lose Weight';
  String weight = '60 kg';
  String progress = '70%';

  bool isLoading = true;

  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color accentBlue = Color(0xFF00B8FF);
  static const Color softBorder = Color(0xFF2A2D35);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _profileService.getProfile();

    if (data != null) {
      name = data['name'] ?? name;
      goal = data['goal'] ?? goal;
      weight = data['weight'] ?? weight;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => EditProfileScreen(
              currentName: name,
              currentGoal: goal,
              currentWeight: weight,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        name = result['name'];
        goal = result['goal'];
        weight = result['weight'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator(color: accentPurple)),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No email';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            color: AppTheme.textPrimaryColor,
            onPressed: _openEditProfile,
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            color: AppTheme.textPrimaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D1F24), Color(0xFF15161A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: softBorder),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentPurple.withOpacity(0.65),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: AppTheme.backgroundColor,
                      child: Icon(
                        Icons.person_rounded,
                        size: 54,
                        color: accentPurple,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    email,
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 18),

                  GestureDetector(
                    onTap: _openEditProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: accentPurple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: accentPurple.withOpacity(0.35),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: accentPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    Icons.local_fire_department_rounded,
                    'Goal',
                    goal,
                    accentPurple,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _infoCard(
                    Icons.monitor_weight_rounded,
                    'Weight',
                    weight,
                    accentBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            _wideCard(
              Icons.show_chart_rounded,
              'Progress',
              'Keep going 💪',
              progress,
              accentPurple,
            ),

            const SizedBox(height: 14),

            _wideCard(
              Icons.favorite_rounded,
              'Wellness',
              'Balanced week',
              'Good',
              accentBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wideCard(
    IconData icon,
    String title,
    String sub,
    String trailing,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: softBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  sub,
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
