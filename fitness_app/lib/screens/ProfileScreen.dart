import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final targetWeightController = TextEditingController();
  final caloriesController = TextEditingController();

  String selectedGoal = 'Fat Loss';
  bool isLoading = true;
  bool isSaving = false;

  final List<String> goals = const [
    'Fat Loss',
    'Muscle Gain',
    'Maintain Weight',
    'Improve Fitness',
    'Healthy Lifestyle',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    targetWeightController.dispose();
    caloriesController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    final profileDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('profile')
            .doc('data')
            .get();

    final userData = userDoc.data() ?? {};
    final profileData = profileDoc.data() ?? {};

    nameController.text =
        (userData['name'] ?? user.displayName ?? 'User').toString();

    phoneController.text = (userData['phone'] ?? '').toString();
    emailController.text = (userData['email'] ?? user.email ?? '').toString();

    ageController.text = (profileData['age'] ?? '').toString();
    heightController.text = _formatNumber(profileData['heightCm']);
    weightController.text = _formatNumber(profileData['currentWeightKg']);
    targetWeightController.text = _formatNumber(profileData['targetWeightKg']);
    caloriesController.text = (profileData['dailyCalories'] ?? '').toString();

    final goal = profileData['goal'];
    if (goal is String && goals.contains(goal)) {
      selectedGoal = goal;
    }

    if (!mounted) return;

    setState(() => isLoading = false);
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '';

    final number = double.tryParse(value.toString());
    if (number == null) return '';

    if (number % 1 == 0) {
      return number.toInt().toString();
    }

    return number.toStringAsFixed(1);
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage('No user found.');
      return;
    }

    final age = int.tryParse(ageController.text.trim());
    final height = double.tryParse(heightController.text.trim());
    final weight = double.tryParse(weightController.text.trim());
    final targetWeight = double.tryParse(targetWeightController.text.trim());
    final calories = int.tryParse(caloriesController.text.trim());

    if (age == null || age < 13 || age > 100) {
      _showMessage('Please enter a realistic age.');
      return;
    }

    if (height == null || height < 120 || height > 230) {
      _showMessage('Please enter a realistic height in cm.');
      return;
    }

    if (weight == null || weight < 30 || weight > 300) {
      _showMessage('Please enter a realistic current weight in kg.');
      return;
    }

    if (targetWeight == null || targetWeight < 30 || targetWeight > 300) {
      _showMessage('Please enter a realistic target weight in kg.');
      return;
    }

    if (calories == null || calories < 800 || calories > 6000) {
      _showMessage('Please enter a realistic daily calorie goal.');
      return;
    }

    try {
      setState(() => isSaving = true);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('data')
          .set({
            'age': age,
            'heightCm': height,
            'currentWeightKg': weight,
            'targetWeightKg': targetWeight,
            'dailyCalories': calories,
            'goal': selectedGoal,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (!mounted) return;

      _showMessage('Profile saved successfully.');
    } catch (e) {
      _showMessage('Could not save profile.');
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
    bool readOnly = false,
  }) {
    return InputDecoration(
      labelText: label,
      suffixText: suffix,
      prefixIcon: Icon(icon, color: AppTheme.primaryColor),
      filled: true,
      fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
      labelStyle: const TextStyle(color: AppTheme.textSecondaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        decoration: _inputDecoration(
          label: label,
          icon: icon,
          suffix: suffix,
          readOnly: readOnly,
        ),
      ),
    );
  }

  Widget _buildGoalDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: selectedGoal,
        decoration: InputDecoration(
          labelText: 'Goal',
          prefixIcon: const Icon(
            Icons.track_changes_rounded,
            color: AppTheme.primaryColor,
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: AppTheme.textSecondaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
        items:
            goals.map((goal) {
              return DropdownMenuItem<String>(value: goal, child: Text(goal));
            }).toList(),
        onChanged: (value) {
          if (value == null) return;
          setState(() => selectedGoal = value);
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final numberOnly = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Profile', showBackButton: true),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
              : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  Center(
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
                        Text(
                          nameController.text.isEmpty
                              ? 'User Profile'
                              : nameController.text,
                          style: const TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          emailController.text,
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle('Account Information'),

                  _buildInput(
                    label: 'Full Name',
                    controller: nameController,
                    icon: Icons.person_outline_rounded,
                  ),
                  _buildInput(
                    label: 'Phone Number',
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildInput(
                    label: 'Email Address',
                    controller: emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                  ),

                  const SizedBox(height: 12),

                  _sectionTitle('Body & Goals'),

                  _buildInput(
                    label: 'Age',
                    controller: ageController,
                    icon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: numberOnly,
                  ),
                  _buildInput(
                    label: 'Height',
                    controller: heightController,
                    icon: Icons.height_rounded,
                    keyboardType: TextInputType.number,
                    suffix: 'cm',
                    inputFormatters: numberOnly,
                  ),
                  _buildInput(
                    label: 'Current Weight',
                    controller: weightController,
                    icon: Icons.monitor_weight_outlined,
                    keyboardType: TextInputType.number,
                    suffix: 'kg',
                    inputFormatters: numberOnly,
                  ),
                  _buildInput(
                    label: 'Target Weight',
                    controller: targetWeightController,
                    icon: Icons.track_changes_rounded,
                    keyboardType: TextInputType.number,
                    suffix: 'kg',
                    inputFormatters: numberOnly,
                  ),
                  _buildInput(
                    label: 'Daily Calorie Goal',
                    controller: caloriesController,
                    icon: Icons.local_fire_department_outlined,
                    keyboardType: TextInputType.number,
                    suffix: 'kcal',
                    inputFormatters: numberOnly,
                  ),

                  _buildGoalDropdown(),

                  const SizedBox(height: 24),

                  CustomButton(
                    text: isSaving ? 'Saving...' : 'Save Profile',
                    icon: Icons.save_rounded,
                    onPressed: isSaving ? () {} : _saveProfile,
                  ),
                ],
              ),
    );
  }
}
