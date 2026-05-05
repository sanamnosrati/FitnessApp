import 'package:flutter/material.dart';
import '../components/custom_bottom_nav.dart';
import 'WorkoutCategoriesScreen.dart';
import 'CategorySelectionScreen.dart';
import 'package:fitness_app/screens/ProgressScreen.dart' as progress;
import 'package:fitness_app/screens/AchievementsScreen.dart' as achievements;
import 'package:fitness_app/screens/SettingsScreen.dart' as settings;
import '../theme/app_theme.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const WorkoutCategoriesScreen(),
    const CategorySelectionScreen(),
    const progress.ProgressScreen(),
    const achievements.AchievementsScreen(),
    const settings.SettingsScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
