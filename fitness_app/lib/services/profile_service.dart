import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveProfile({
    required String name,
    required String goal,
    required String weight,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).set({
      'name': name,
      'goal': goal,
      'weight': weight,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return doc.data();
  }
}
