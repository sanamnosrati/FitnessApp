import 'package:flutter/material.dart';
import 'package:fitness_app/services/auth_service.dart'; // Importiere AuthService
import 'package:fitness_app/screens/home_screen.dart'; // HomeScreen importieren

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Ladeindikator

  final AuthService _authService = AuthService(); // Instanziiere AuthService

  @override
  void initState() {
    super.initState();
    // Prüfen, ob der Benutzer bereits eingeloggt ist
    _checkLoginStatus();
  }

  // Überprüfen, ob der Benutzer eingeloggt ist
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await _authService.getLoginStatus();
    if (isLoggedIn) {
      // Wenn der Benutzer eingeloggt ist, zum HomeScreen weiterleiten
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // ------------------ Login ------------------
  Future<void> _signIn() async {
    setState(() => isLoading = true);
    try {
      final user = await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showError("Login fehlgeschlagen");
      }
    } catch (e) {
      _showError("Fehler beim Login");
    }
    setState(() => isLoading = false);
  }

  // ------------------ Registrierung ------------------
  Future<void> _signUp() async {
    setState(() => isLoading = true);
    try {
      final user = await _authService.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showError("Registrierung fehlgeschlagen");
      }
    } catch (e) {
      _showError("Fehler bei der Registrierung");
    }
    setState(() => isLoading = false);
  }

  // ------------------ Fehler anzeigen ------------------
  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 100, color: Colors.black),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "E-Mail"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Passwort"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Login"),
                      ),
                      TextButton(
                        onPressed: _signUp,
                        child: const Text("Registrieren"),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
