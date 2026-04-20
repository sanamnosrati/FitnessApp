import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentGoal;
  final String currentWeight;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentGoal,
    required this.currentWeight,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileService _profileService = ProfileService();

  late TextEditingController nameController;
  late TextEditingController goalController;
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    goalController = TextEditingController(text: widget.currentGoal);
    weightController = TextEditingController(text: widget.currentWeight);
  }

  void _save() async {
    final name = nameController.text.trim();
    final goal = goalController.text.trim();
    final weight = weightController.text.trim();

    await _profileService.saveProfile(name: name, goal: goal, weight: weight);

    Navigator.pop(context, {'name': name, 'goal': goal, 'weight': weight});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: goalController,
              decoration: const InputDecoration(labelText: 'Goal'),
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
