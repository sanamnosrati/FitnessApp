import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_app_bar.dart';
import '../theme/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;

  bool allReminders = true;
  bool waterReminder = true;
  bool breakfastReminder = true;
  bool lunchReminder = true;
  bool dinnerReminder = true;
  bool workoutReminder = true;
  bool mentalReminder = true;
  bool sleepReminder = false;
  bool weightReminder = false;
  bool weeklySummary = true;

  @override
  void initState() {
    super.initState();
    _loadReminderSettings();
  }

  Future<void> _loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      allReminders = prefs.getBool('allReminders') ?? true;
      waterReminder = prefs.getBool('waterReminder') ?? true;
      breakfastReminder = prefs.getBool('breakfastReminder') ?? true;
      lunchReminder = prefs.getBool('lunchReminder') ?? true;
      dinnerReminder = prefs.getBool('dinnerReminder') ?? true;
      workoutReminder = prefs.getBool('workoutReminder') ?? true;
      mentalReminder = prefs.getBool('mentalReminder') ?? true;
      sleepReminder = prefs.getBool('sleepReminder') ?? false;
      weightReminder = prefs.getBool('weightReminder') ?? false;
      weeklySummary = prefs.getBool('weeklySummary') ?? true;
      isLoading = false;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _toggleAllReminders(bool value) async {
    setState(() {
      allReminders = value;
    });

    await _saveBool('allReminders', value);
  }

  Future<void> _toggleReminder({
    required String key,
    required bool value,
    required void Function(bool) updateState,
  }) async {
    setState(() {
      updateState(value);
    });

    await _saveBool(key, value);
  }

  int get enabledReminderCount {
    if (!allReminders) return 0;

    final reminders = [
      waterReminder,
      breakfastReminder,
      lunchReminder,
      dinnerReminder,
      workoutReminder,
      mentalReminder,
      sleepReminder,
      weightReminder,
      weeklySummary,
    ];

    return reminders.where((item) => item).length;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Notifications', showBackButton: true),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          _headerCard(),

          const SizedBox(height: 24),

          _sectionTitle('Daily Health Reminders'),

          _reminderCard(
            icon: Icons.water_drop_rounded,
            title: 'Water Intake',
            subtitle: 'Stay hydrated throughout the day.',
            value: waterReminder,
            onChanged: (value) {
              _toggleReminder(
                key: 'waterReminder',
                value: value,
                updateState: (newValue) => waterReminder = newValue,
              );
            },
          ),

          _reminderCard(
            icon: Icons.breakfast_dining_rounded,
            title: 'Breakfast Reminder',
            subtitle: 'Start your day with a balanced meal.',
            value: breakfastReminder,
            onChanged: (value) {
              _toggleReminder(
                key: 'breakfastReminder',
                value: value,
                updateState: (newValue) => breakfastReminder = newValue,
              );
            },
          ),

          _reminderCard(
            icon: Icons.lunch_dining_rounded,
            title: 'Lunch Reminder',
            subtitle: 'Track your lunch and keep your energy steady.',
            value: lunchReminder,
            onChanged: (value) {
              _toggleReminder(
                key: 'lunchReminder',
                value: value,
                updateState: (newValue) => lunchReminder = newValue,
              );
            },
          ),

          _reminderCard(
            icon: Icons.dinner_dining_rounded,
            title: 'Dinner Reminder',
            subtitle: 'Log your dinner and complete your daily nutrition.',
            value: dinnerReminder,
            onChanged: (value) {
              _toggleReminder(
                key: 'dinnerReminder',
                value: value,
                updateState: (newValue) => dinnerReminder = newValue,
              );
            },
          ),

          _reminderCard(
            icon: Icons.fitness_center_rounded,
            title: 'Workout Reminder',
            subtitle: 'Stay active and complete your workout routine.',
            value: workoutReminder,
            onChanged: (value) {
              _toggleReminder(
                key: 'workoutReminder',
                value: value,
                updateState: (newValue) => workoutReminder = newValue,
              );
            },
          ),

          _reminderCard(
            icon: Icons.favorite_rounded,
            title: 'Mental Health Check-In',
            subtitle: 'Log your mood, feelings or journal entry.',
            value: mentalReminder,
            onChanged: (value) {
              _toggleReminder(
                key: 'mentalReminder',
                value: value,
                updateState: (newValue) => mentalReminder = newValue,
              );
            },
          ),

          const SizedBox(height: 20),

          _sectionTitle('Optional Reminders'),

          _reminderCard(
            icon: Icons.bedtime_rounded,
            title: 'Sleep Reminder',
            subtitle: 'Prepare for a healthy sleep routine.',
            value: sleepReminder,
            onChanged: (value) {
              _toggleReminder(
                key: 'sleepReminder',
                value: value,
                updateState: (newValue) => sleepReminder = newValue,
              );
            },
          ),

          _reminderCard(
            icon: Icons.monitor_weight_rounded,
            title: 'Weight Check',
            subtitle: 'Track your progress regularly.',
            value: weightReminder,
            onChanged: (value) {
              _toggleReminder(
                key: 'weightReminder',
                value: value,
                updateState: (newValue) => weightReminder = newValue,
              );
            },
          ),

          _reminderCard(
            icon: Icons.insights_rounded,
            title: 'Weekly Progress Summary',
            subtitle: 'Receive a weekly recap of your fitness progress.',
            value: weeklySummary,
            onChanged: (value) {
              _toggleReminder(
                key: 'weeklySummary',
                value: value,
                updateState: (newValue) => weeklySummary = newValue,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active_rounded,
                color: AppTheme.primaryColor,
                size: 38,
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Daily Reminders',
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                value: allReminders,
                activeColor: AppTheme.primaryColor,
                onChanged: _toggleAllReminders,
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Receive helpful notifications for water intake, meals, workouts, mental wellness and healthy habits.',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 15,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              allReminders
                  ? '$enabledReminderCount reminder categories enabled'
                  : 'All reminders are disabled',
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _reminderCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDisabled = !allReminders;

    return Opacity(
      opacity: isDisabled ? 0.45 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 29),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            Switch(
              value: value,
              activeColor: AppTheme.primaryColor,
              onChanged: isDisabled ? null : onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
