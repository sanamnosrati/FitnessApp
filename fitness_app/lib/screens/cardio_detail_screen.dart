import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardioDetailScreen extends StatefulWidget {
  final String cardioName;

  const CardioDetailScreen({super.key, required this.cardioName});

  @override
  State<CardioDetailScreen> createState() => _CardioDetailScreenState();
}

class _CardioDetailScreenState extends State<CardioDetailScreen> {
  String selectedIntensity = 'Medium';

  final List<String> intensities = ['Low', 'Medium', 'High'];

  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();

  int getCaloriesPerMinute(String cardio, String intensity) {
    final Map<String, Map<String, int>> caloriesMap = {
      'Running': {'Low': 7, 'Medium': 10, 'High': 14},
      'Cycling': {'Low': 5, 'Medium': 8, 'High': 11},
      'Jump Rope': {'Low': 8, 'Medium': 12, 'High': 15},
      'HIIT': {'Low': 9, 'Medium': 13, 'High': 16},
      'Swimming': {'Low': 6, 'Medium': 9, 'High': 12},
      'Rowing': {'Low': 6, 'Medium': 9, 'High': 12},
      'Stair Climbing': {'Low': 7, 'Medium': 10, 'High': 13},
    };

    return caloriesMap[cardio]?[intensity] ?? 8;
  }

  int getTotalMinutes() {
    final int hours = int.tryParse(hoursController.text) ?? 0;
    int minutes = int.tryParse(minutesController.text) ?? 0;

    if (minutes > 59) {
      minutes = 59;
    }

    return (hours * 60) + minutes;
  }

  int calculateCalories() {
    final caloriesPerMinute = getCaloriesPerMinute(
      widget.cardioName,
      selectedIntensity,
    );
    final totalMinutes = getTotalMinutes();
    return caloriesPerMinute * totalMinutes;
  }

  Future<void> saveWorkout() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    final int hours = int.tryParse(hoursController.text) ?? 0;
    int minutes = int.tryParse(minutesController.text) ?? 0;

    if (minutes > 59) {
      minutes = 59;
    }

    final totalMinutes = (hours * 60) + minutes;

    if (totalMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid duration')),
      );
      return;
    }

    final calories = calculateCalories();

    try {
      await FirebaseFirestore.instance.collection('workouts').add({
        'userId': user.uid,
        'type': 'cardio',
        'exercise': widget.cardioName,
        'intensity': selectedIntensity,
        'hours': hours,
        'minutes': minutes,
        'totalMinutes': totalMinutes,
        'caloriesBurned': calories,
        'date': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout saved successfully')),
      );

      hoursController.clear();
      minutesController.clear();

      setState(() {
        selectedIntensity = 'Medium';
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving workout: $e')));
    }
  }

  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMinutes = getTotalMinutes();
    final totalCalories = calculateCalories();

    return Scaffold(
      appBar: AppBar(title: Text(widget.cardioName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Intensity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedIntensity,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items:
                    intensities.map((intensity) {
                      return DropdownMenuItem<String>(
                        value: intensity,
                        child: Text(intensity),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedIntensity = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Enter Duration',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Hours',
                        hintText: 'e.g. 1',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Minutes',
                        hintText: 'e.g. 30',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Duration: $totalMinutes min',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Estimated Calories Burned: $totalCalories kcal',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveWorkout,
                  child: const Text('Save', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '*Calories are estimated values and may vary depending on body weight and exercise intensity.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
