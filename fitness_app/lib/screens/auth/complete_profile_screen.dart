import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth_service.dart';
import '../../services/user_repository.dart';
import '../../theme/app_theme.dart';
import '../main_navigation.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  DateTime? birthday;

  String heightUnit = 'cm';
  String weightUnit = 'kg';

  final heightCmController = TextEditingController();
  final heightFeetController = TextEditingController();
  final heightInchController = TextEditingController();

  final currentWeightController = TextEditingController();
  final targetWeightController = TextEditingController();

  String selectedGoal = 'Fat Loss';
  String selectedActivity = 'Moderately Active';

  bool isSaving = false;

  final goals = const [
    {'title': 'Fat Loss', 'icon': Icons.local_fire_department_rounded},
    {'title': 'Muscle Gain', 'icon': Icons.fitness_center_rounded},
    {'title': 'Maintain Weight', 'icon': Icons.balance_rounded},
    {'title': 'Improve Fitness', 'icon': Icons.directions_run_rounded},
    {'title': 'Healthy Lifestyle', 'icon': Icons.favorite_rounded},
  ];

  final activityLevels = const [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Athlete',
  ];

  @override
  void dispose() {
    heightCmController.dispose();
    heightFeetController.dispose();
    heightInchController.dispose();
    currentWeightController.dispose();
    targetWeightController.dispose();
    super.dispose();
  }

  int? get age {
    if (birthday == null) return null;

    final today = DateTime.now();
    int calculatedAge = today.year - birthday!.year;

    if (today.month < birthday!.month ||
        (today.month == birthday!.month && today.day < birthday!.day)) {
      calculatedAge--;
    }

    return calculatedAge;
  }

  double? get heightCm {
    if (heightUnit == 'cm') {
      return double.tryParse(heightCmController.text.trim());
    }

    final feet = double.tryParse(heightFeetController.text.trim());
    final inch = double.tryParse(heightInchController.text.trim());

    if (feet == null || inch == null) return null;

    return (feet * 30.48) + (inch * 2.54);
  }

  double? _weightToKg(String value) {
    final weight = double.tryParse(value.trim());
    if (weight == null) return null;

    if (weightUnit == 'kg') return weight;

    return weight * 0.453592;
  }

  int _calculateCalories({
    required int age,
    required double heightCm,
    required double weightKg,
    required String goal,
    required String activity,
  }) {
    double bmr = 10 * weightKg + 6.25 * heightCm - 5 * age - 161;

    double activityFactor = switch (activity) {
      'Sedentary' => 1.2,
      'Lightly Active' => 1.375,
      'Moderately Active' => 1.55,
      'Very Active' => 1.725,
      'Athlete' => 1.9,
      _ => 1.55,
    };

    double calories = bmr * activityFactor;

    if (goal == 'Fat Loss') calories -= 350;
    if (goal == 'Muscle Gain') calories += 250;

    return calories.round();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 24, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 13),
    );

    if (picked == null) return;

    setState(() {
      birthday = picked;
    });
  }

  Future<void> _saveProfile() async {
    final user = AuthService.currentUser;

    if (user == null) {
      _showError('No user found. Please sign in again.');
      return;
    }

    final calculatedAge = age;
    final calculatedHeightCm = heightCm;
    final currentWeightKg = _weightToKg(currentWeightController.text);
    final targetWeightKg = _weightToKg(targetWeightController.text);

    if (birthday == null || calculatedAge == null) {
      _showError('Please choose your birthday.');
      return;
    }

    if (calculatedAge < 13 || calculatedAge > 100) {
      _showError('Please enter a realistic age.');
      return;
    }

    if (calculatedHeightCm == null ||
        calculatedHeightCm < 120 ||
        calculatedHeightCm > 230) {
      _showError('Please enter a realistic height.');
      return;
    }

    if (currentWeightKg == null ||
        currentWeightKg < 30 ||
        currentWeightKg > 300) {
      _showError('Please enter a realistic current weight.');
      return;
    }

    if (targetWeightKg == null || targetWeightKg < 30 || targetWeightKg > 300) {
      _showError('Please enter a realistic target weight.');
      return;
    }

    final calories = _calculateCalories(
      age: calculatedAge,
      heightCm: calculatedHeightCm,
      weightKg: currentWeightKg,
      goal: selectedGoal,
      activity: selectedActivity,
    );

    try {
      setState(() => isSaving = true);

      await UserRepository.saveProfile(
        uid: user.uid,
        birthday: birthday!,
        age: calculatedAge,
        heightCm: calculatedHeightCm,
        currentWeightKg: currentWeightKg,
        targetWeightKg: targetWeightKg,
        goal: selectedGoal,
        activityLevel: selectedActivity,
        dailyCalories: calories,
        heightUnit: heightUnit,
        weightUnit: weightUnit,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } catch (e) {
      _showError('Could not save profile. Please try again.');
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void _showError(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text), backgroundColor: Colors.red));
  }

  String _birthdayText() {
    if (birthday == null) return 'Choose birthday';

    return '${birthday!.day.toString().padLeft(2, '0')}.${birthday!.month.toString().padLeft(2, '0')}.${birthday!.year}';
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      suffixText: suffix,
      prefixIcon: Icon(icon, color: AppTheme.primaryColor),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: AppTheme.textSecondaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _unitButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _goalCard(String title, IconData icon) {
    final selected = selectedGoal == title;

    return GestureDetector(
      onTap: () {
        setState(() => selectedGoal = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.white : AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _activityCard(String title) {
    final selected = selectedActivity == title;

    return GestureDetector(
      onTap: () {
        setState(() => selectedActivity = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              selected ? AppTheme.primaryColor.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color:
                  selected
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  List<TextInputFormatter> get numberInput => [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
  ];

  @override
  Widget build(BuildContext context) {
    final calculatedCalories = () {
      final calculatedAge = age;
      final calculatedHeightCm = heightCm;
      final currentWeightKg = _weightToKg(currentWeightController.text);

      if (calculatedAge == null ||
          calculatedHeightCm == null ||
          currentWeightKg == null) {
        return null;
      }

      return _calculateCalories(
        age: calculatedAge,
        heightCm: calculatedHeightCm,
        weightKg: currentWeightKg,
        goal: selectedGoal,
        activity: selectedActivity,
      );
    }();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppTheme.primaryColor,
                    size: 42,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Complete your profile',
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'We use this information to personalize your workouts, calories and progress tracking.',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            _sectionTitle('Birthday'),

            GestureDetector(
              onTap: _pickBirthday,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cake_outlined,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        birthday == null
                            ? 'Choose your birthday'
                            : '${_birthdayText()}  •  ${age ?? '-'} years old',
                        style: const TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ],
                ),
              ),
            ),

            _sectionTitle('Height'),

            Row(
              children: [
                _unitButton(
                  text: 'CM',
                  selected: heightUnit == 'cm',
                  onTap: () => setState(() => heightUnit = 'cm'),
                ),
                const SizedBox(width: 10),
                _unitButton(
                  text: 'FT / IN',
                  selected: heightUnit == 'ft',
                  onTap: () => setState(() => heightUnit = 'ft'),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (heightUnit == 'cm')
              TextField(
                controller: heightCmController,
                keyboardType: TextInputType.number,
                inputFormatters: numberInput,
                decoration: _inputDecoration(
                  label: 'Height',
                  icon: Icons.height_rounded,
                  suffix: 'cm',
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: heightFeetController,
                      keyboardType: TextInputType.number,
                      inputFormatters: numberInput,
                      decoration: _inputDecoration(
                        label: 'Feet',
                        icon: Icons.height_rounded,
                        suffix: 'ft',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: heightInchController,
                      keyboardType: TextInputType.number,
                      inputFormatters: numberInput,
                      decoration: _inputDecoration(
                        label: 'Inches',
                        icon: Icons.straighten_rounded,
                        suffix: 'in',
                      ),
                    ),
                  ),
                ],
              ),

            _sectionTitle('Weight'),

            Row(
              children: [
                _unitButton(
                  text: 'KG',
                  selected: weightUnit == 'kg',
                  onTap: () => setState(() => weightUnit = 'kg'),
                ),
                const SizedBox(width: 10),
                _unitButton(
                  text: 'LBS',
                  selected: weightUnit == 'lbs',
                  onTap: () => setState(() => weightUnit = 'lbs'),
                ),
              ],
            ),

            const SizedBox(height: 14),

            TextField(
              controller: currentWeightController,
              keyboardType: TextInputType.number,
              inputFormatters: numberInput,
              onChanged: (_) => setState(() {}),
              decoration: _inputDecoration(
                label: 'Current Weight',
                icon: Icons.monitor_weight_outlined,
                suffix: weightUnit,
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: targetWeightController,
              keyboardType: TextInputType.number,
              inputFormatters: numberInput,
              decoration: _inputDecoration(
                label: 'Target Weight',
                icon: Icons.track_changes_rounded,
                suffix: weightUnit,
              ),
            ),

            _sectionTitle('Goal'),

            ...goals.map(
              (goal) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _goalCard(
                  goal['title'] as String,
                  goal['icon'] as IconData,
                ),
              ),
            ),

            _sectionTitle('Activity Level'),

            ...activityLevels.map(_activityCard),

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppTheme.primaryColor,
                    size: 34,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      calculatedCalories == null
                          ? 'Your daily calorie goal will be calculated automatically.'
                          : 'Estimated daily goal: $calculatedCalories kcal',
                      style: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 58,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child:
                    isSaving
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Continue',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
