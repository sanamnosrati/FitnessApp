import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MentalHealthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveMentalEntry({
    required List<String> moods,
    required int score,
    required String reflection,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('mental_entries')
        .add({
          'moods': moods,
          'score': score,
          'reflection': reflection.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Future<List<Map<String, dynamic>>> getRecentMentalEntries({
    int limit = 7,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is logged in');
    }

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('mental_entries')
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();

    return snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllMentalEntries() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is logged in');
    }

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('mental_entries')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }
}
