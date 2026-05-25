import 'package:flutter/material.dart';

import 'WorkoutCategoriesScreen.dart';
import 'package:fitness_app/screens/nutrition_screen.dart';
import 'package:fitness_app/screens/daily_dashboard_screen.dart';
import 'package:fitness_app/screens/MentalHealthScreen.dart' as mental_health;
import 'package:fitness_app/screens/ProfileScreen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    const WorkoutCategoriesScreen(),
    const NutritionScreen(),
    const DailyDashboardScreen(),
    const mental_health.MentalHealthScreen(),
    const ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTap,
        height: 74,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_rounded),
            label: 'Nutrition',
          ),
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.favorite_rounded),
            label: 'Mind',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
