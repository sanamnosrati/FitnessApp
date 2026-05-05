import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      log("Attempting email login: $email");

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      log("Login successful");
      return result.user;
    } on FirebaseAuthException catch (e) {
      log("Login failed: ${e.code}, ${e.message}");
      return null;
    } catch (e) {
      log("General error during login: $e");
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      log("Attempting email registration: $email");

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      log("Registration successful");
      return result.user;
    } on FirebaseAuthException catch (e) {
      log("Registration failed: ${e.code}, ${e.message}");
      return null;
    } catch (e) {
      log("General error during registration: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      log("Attempting Google login");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        log("Google login canceled");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      log("Google login successful");
      return result.user;
    } on FirebaseAuthException catch (e) {
      log("Google login failed: ${e.code}, ${e.message}");
      return null;
    } catch (e) {
      log("General error during Google login: $e");
      return null;
    }
  }

  Future<User?> signInWithApple() async {
    try {
      log("Attempting Apple login");

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider(
        "apple.com",
      ).credential(idToken: appleCredential.identityToken);

      UserCredential result = await _auth.signInWithCredential(oauthCredential);

      log("Apple login successful");
      return result.user;
    } on FirebaseAuthException catch (e) {
      log("Apple login failed: ${e.code}, ${e.message}");
      return null;
    } catch (e) {
      log("General error during Apple login: $e");
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log("Password reset email sent to $email");
    } on FirebaseAuthException catch (e) {
      log("Password reset failed: ${e.code}, ${e.message}");
    } catch (e) {
      log("General error during password reset: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    await _auth.signOut();
    log("Logout successful");
  }
}
