import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _currentWeightController;
  late final TextEditingController _targetWeightController;
  late final TextEditingController _dailyCaloriesController;

  late String _selectedGoal;

  final List<String> _goals = const [
    'Lose Weight',
    'Build Muscle',
    'Maintain Weight',
    'Improve Fitness',
    'Stay Healthy',
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _ageController = TextEditingController(text: widget.profile.age.toString());
    _heightController = TextEditingController(
      text: widget.profile.height.toStringAsFixed(0),
    );
    _currentWeightController = TextEditingController(
      text: widget.profile.currentWeight.toStringAsFixed(1),
    );
    _targetWeightController = TextEditingController(
      text: widget.profile.targetWeight.toStringAsFixed(1),
    );
    _dailyCaloriesController = TextEditingController(
      text: widget.profile.dailyCalorieGoal.toString(),
    );

    _selectedGoal = widget.profile.goal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _dailyCaloriesController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = widget.profile.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? widget.profile.age,
      height:
          double.tryParse(_heightController.text.trim()) ??
          widget.profile.height,
      currentWeight:
          double.tryParse(_currentWeightController.text.trim()) ??
          widget.profile.currentWeight,
      targetWeight:
          double.tryParse(_targetWeightController.text.trim()) ??
          widget.profile.targetWeight,
      dailyCalorieGoal:
          int.tryParse(_dailyCaloriesController.text.trim()) ??
          widget.profile.dailyCalorieGoal,
      goal: _selectedGoal,
    );

    await _profileService.saveProfile(updatedProfile);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _sectionCard(
                title: 'Personal Info',
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_rounded,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _ageController,
                    label: 'Age',
                    icon: Icons.cake_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _heightController,
                    label: 'Height (cm)',
                    icon: Icons.height_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Fitness Goal',
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        _goals.map((goal) {
                          final selected = goal == _selectedGoal;
                          return ChoiceChip(
                            label: Text(goal),
                            selected: selected,
                            onSelected: (_) {
                              setState(() {
                                _selectedGoal = goal;
                              });
                            },
                            selectedColor: const Color(
                              0xFF6A5AE0,
                            ).withOpacity(0.18),
                            labelStyle: TextStyle(
                              color:
                                  selected
                                      ? const Color(0xFF4E3FD0)
                                      : Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                              side: BorderSide(
                                color:
                                    selected
                                        ? const Color(0xFF6A5AE0)
                                        : Colors.transparent,
                              ),
                            ),
                            backgroundColor: const Color(0xFFF2F3F7),
                          );
                        }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Body & Nutrition',
                children: [
                  _buildTextField(
                    controller: _currentWeightController,
                    label: 'Current Weight (kg)',
                    icon: Icons.monitor_weight_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _targetWeightController,
                    label: 'Target Weight (kg)',
                    icon: Icons.flag_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _dailyCaloriesController,
                    label: 'Daily Calorie Goal',
                    icon: Icons.local_fire_department_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF7F7FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF6A5AE0), width: 1.3),
        ),
      ),
    );
  }
}
