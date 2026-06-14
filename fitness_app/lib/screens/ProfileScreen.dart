import 'package:flutter/material.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firstNameController = TextEditingController(text: 'Sanam');
  final lastNameController = TextEditingController(text: 'Hadadnosrati');
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  String selectedGoal = 'Lose Weight';

  final List<String> goals = const [
    'Lose Weight',
    'Build Muscle',
    'Maintain Weight',
    'Improve Fitness',
    'Healthy Lifestyle',
  ];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: 'Profile', showBackButton: true),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          Center(
            child: Container(
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
          ),

          const SizedBox(height: 28),

          _buildInput(
            label: 'First Name',
            controller: firstNameController,
            icon: Icons.person_outline_rounded,
          ),
          _buildInput(
            label: 'Last Name',
            controller: lastNameController,
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
          ),
          _buildInput(
            label: 'Height',
            controller: heightController,
            icon: Icons.height_rounded,
            keyboardType: TextInputType.number,
            suffix: 'cm',
          ),
          _buildInput(
            label: 'Weight',
            controller: weightController,
            icon: Icons.monitor_weight_outlined,
            keyboardType: TextInputType.number,
            suffix: 'kg',
          ),
          _buildInput(
            label: 'Age',
            controller: ageController,
            icon: Icons.cake_outlined,
            keyboardType: TextInputType.number,
          ),

          _buildGoalDropdown(),

          const SizedBox(height: 28),

          CustomButton(
            text: 'Save Profile',
            icon: Icons.save_rounded,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
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
          setState(() {
            selectedGoal = value;
          });
        },
      ),
    );
  }
}
