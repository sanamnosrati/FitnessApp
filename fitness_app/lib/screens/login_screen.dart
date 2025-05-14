import 'package:flutter/material.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isLogin = true; // Toggle between Login and Register

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await _authService.getLoginStatus();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Future<void> _handleEmailAuth() async {
    setState(() => isLoading = true);
    try {
      User? user;
      if (isLogin) {
        user = await _authService.signInWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        user = await _authService.signUpWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      }

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        _showError("Authentication failed");
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Unknown error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    if (emailController.text.trim().isEmpty) {
      _showError("Please enter your email first.");
      return;
    }
    await _authService.resetPassword(emailController.text.trim());
    _showMessage("Password reset email sent.");
  }

  Future<void> _signInWithGoogle() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      _showError("Google Sign-In failed");
    }
  }

  Future<void> _signInWithApple() async {
    User? user = await _authService.signInWithApple();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      _showError("Apple Sign-In failed");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.fitness_center,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),

              // Email Field
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),

              // Forgot Password
              TextButton(
                onPressed: _forgotPassword,
                child: const Text("Forgot Password?"),
              ),
              const SizedBox(height: 10),

              // Login or Register Button
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _handleEmailAuth,
                    child: Text(isLogin ? "Sign In" : "Sign Up"),
                  ),
              const SizedBox(height: 10),

              // Switch between Login / Register
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Sign In",
                ),
              ),
              const SizedBox(height: 20),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Google Login
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.g_mobiledata),
                label: const Text("Sign in with Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Apple Login
              ElevatedButton.icon(
                onPressed: _signInWithApple,
                icon: const Icon(Icons.apple),
                label: const Text("Sign in with Apple"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
