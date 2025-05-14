import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:developer';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ------------------ Speichern des Login-Status ------------------
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // ------------------ Abrufen des Login-Status ------------------
  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ??
        false; // Default value is false if not set
  }

  // ------------------ EMAIL LOGIN ------------------
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      log("📨 Attempting email login: $email");
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("✅ Login successful!");
      await saveLoginStatus(true); // Save login status
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        log("❌ Login failed: ${e.code}, ${e.message}");
      } else {
        log("❌ General error during login: $e");
      }
      return null;
    }
  }

  // ------------------ EMAIL REGISTRATION ------------------
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      log("📝 Attempting email registration: $email");
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("✅ Registration successful!");
      await saveLoginStatus(true); // Save login status
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        log("❌ Registration failed: ${e.code}, ${e.message}");
      } else {
        log("❌ General error during registration: $e");
      }
      return null;
    }
  }

  // ------------------ GOOGLE LOGIN ------------------
  Future<User?> signInWithGoogle() async {
    try {
      log("🔗 Attempting Google login");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        log("❌ Google login canceled");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      log("✅ Google login successful!");
      await saveLoginStatus(true); // Save login status
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        log("❌ Google login failed: ${e.code}, ${e.message}");
      } else {
        log("❌ General error during Google login: $e");
      }
      return null;
    }
  }

  // ------------------ APPLE LOGIN ------------------
  Future<User?> signInWithApple() async {
    try {
      log("🍎 Attempting Apple login");
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider(
        "apple.com",
      ).credential(idToken: credential.identityToken);

      UserCredential result = await _auth.signInWithCredential(oauthCredential);
      log("✅ Apple login successful!");
      await saveLoginStatus(true); // Save login status
      return result.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        log("❌ Apple login failed: ${e.code}, ${e.message}");
      } else {
        log("❌ General error during Apple login: $e");
      }
      return null;
    }
  }

  // ------------------ RESET PASSWORD ------------------
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log("✅ Password reset email sent to $email");
    } catch (e) {
      if (e is FirebaseAuthException) {
        log("❌ Password reset failed: ${e.code}, ${e.message}");
      } else {
        log("❌ General error during password reset: $e");
      }
    }
  }

  // ------------------ LOGOUT ------------------
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      log("🚪 Logout successful");
      await saveLoginStatus(false); // Set login status to false
    } catch (e) {
      if (e is FirebaseAuthException) {
        log("❌ Logout failed: ${e.code}, ${e.message}");
      } else {
        log("❌ General error during logout: $e");
      }
    }
  }
}
