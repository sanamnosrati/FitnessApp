import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MentalHealthService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No logged in user');
    }
    return user.uid;
  }

  String dateId(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DocumentReference<Map<String, dynamic>> _dayRef(DateTime date) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('mental_logs')
        .doc(dateId(date));
  }

  Future<Map<String, dynamic>?> getDayLog(DateTime date) async {
    final doc = await _dayRef(date).get();

    if (!doc.exists) return null;

    return {'id': doc.id, ...?doc.data()};
  }

  Future<void> saveMood({
    required DateTime date,
    required List<String> moods,
    required int score,
  }) async {
    await _dayRef(date).set({
      'date': dateId(date),
      'moods': moods,
      'score': score,
      'moodSavedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveNote({required DateTime date, required String note}) async {
    await _dayRef(date).set({
      'date': dateId(date),
      'reflection': note,
      'noteSavedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getLast30Days() async {
    final now = DateTime.now();
    final from = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 30));

    final snapshot =
        await _db
            .collection('users')
            .doc(_uid)
            .collection('mental_logs')
            .where('date', isGreaterThanOrEqualTo: dateId(from))
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }
}
