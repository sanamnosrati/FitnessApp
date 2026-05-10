import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final int age;
  final double height;
  final double currentWeight;
  final double targetWeight;
  final int dailyCalorieGoal;
  final String goal;
  final String email;

  const UserProfile({
    required this.name,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.targetWeight,
    required this.dailyCalorieGoal,
    required this.goal,
    required this.email,
  });

  factory UserProfile.empty() {
    return const UserProfile(
      name: 'Sanam',
      age: 20,
      height: 165,
      currentWeight: 65,
      targetWeight: 58,
      dailyCalorieGoal: 1800,
      goal: 'Lose Weight',
      email: 'sanam@example.com',
    );
  }

  UserProfile copyWith({
    String? name,
    int? age,
    double? height,
    double? currentWeight,
    double? targetWeight,
    int? dailyCalorieGoal,
    String? goal,
    String? email,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      goal: goal ?? this.goal,
      email: email ?? this.email,
    );
  }
}

class ProfileService {
  static const String _nameKey = 'profile_name';
  static const String _ageKey = 'profile_age';
  static const String _heightKey = 'profile_height';
  static const String _currentWeightKey = 'profile_current_weight';
  static const String _targetWeightKey = 'profile_target_weight';
  static const String _dailyCalorieGoalKey = 'profile_daily_calorie_goal';
  static const String _goalKey = 'profile_goal';
  static const String _emailKey = 'profile_email';

  Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    return UserProfile(
      name: prefs.getString(_nameKey) ?? 'Sanam',
      age: prefs.getInt(_ageKey) ?? 20,
      height: prefs.getDouble(_heightKey) ?? 165,
      currentWeight: prefs.getDouble(_currentWeightKey) ?? 65,
      targetWeight: prefs.getDouble(_targetWeightKey) ?? 58,
      dailyCalorieGoal: prefs.getInt(_dailyCalorieGoalKey) ?? 1800,
      goal: prefs.getString(_goalKey) ?? 'Lose Weight',
      email: prefs.getString(_emailKey) ?? 'sanam@example.com',
    );
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_nameKey, profile.name);
    await prefs.setInt(_ageKey, profile.age);
    await prefs.setDouble(_heightKey, profile.height);
    await prefs.setDouble(_currentWeightKey, profile.currentWeight);
    await prefs.setDouble(_targetWeightKey, profile.targetWeight);
    await prefs.setInt(_dailyCalorieGoalKey, profile.dailyCalorieGoal);
    await prefs.setString(_goalKey, profile.goal);
    await prefs.setString(_emailKey, profile.email);
  }
}
