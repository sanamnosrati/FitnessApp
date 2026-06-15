import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsService {
  UserSettingsService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get uid => _auth.currentUser?.uid;

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    final localLanguage = prefs.getString('selectedLanguage') ?? 'English';

    final currentUid = uid;
    if (currentUid == null) return localLanguage;

    try {
      final doc =
          await _firestore
              .collection('users')
              .doc(currentUid)
              .collection('settings')
              .doc('preferences')
              .get();

      final firebaseLanguage = doc.data()?['language'];

      if (firebaseLanguage is String && firebaseLanguage.isNotEmpty) {
        await prefs.setString('selectedLanguage', firebaseLanguage);
        return firebaseLanguage;
      }

      return localLanguage;
    } catch (_) {
      return localLanguage;
    }
  }

  static Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);

    final currentUid = uid;
    if (currentUid == null) return;

    await _firestore
        .collection('users')
        .doc(currentUid)
        .collection('settings')
        .doc('preferences')
        .set({
          'language': language,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }
}
