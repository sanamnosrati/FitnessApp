import 'package:flutter/material.dart';
import '../components/abstract_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animiertes Logo
                const AbstractLogo(
                  size: 200,
                  primaryColor: Color(0xFFFFD700), // Gold
                  secondaryColor: Color(0xFF1E90FF), // Dodger Blue
                ),
                const SizedBox(height: 30),
                // App Name
                const Text(
                  'BFit',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                // Slogan
                Text(
                  'BFit – weil du es dir wert bist.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[300],
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 