import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  static User? get currentUser => _auth.currentUser;

  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.sendEmailVerification();
    return credential;
  }

  static Future<void> resendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  static Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> reauthenticateWithPassword(String password) async {
    final user = _auth.currentUser;
    final email = user?.email;

    if (user == null || email == null) {
      throw Exception('No user found');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

  static Future<void> deleteAccount() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user found');
    }

    final uid = user.uid;

    await _db.collection('users').doc(uid).delete();
    await user.delete();
  }
}
