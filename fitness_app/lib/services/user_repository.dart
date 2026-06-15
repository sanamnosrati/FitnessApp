import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  UserRepository._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
      'emailVerified': false,
      'profileCompleted': false,
    }, SetOptions(merge: true));
  }

  static Future<void> markEmailVerified(String uid) async {
    await _db.collection('users').doc(uid).set({
      'emailVerified': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<bool> isProfileCompleted(String uid) async {
    final userDoc = await _db.collection('users').doc(uid).get();

    final userCompleted = userDoc.data()?['profileCompleted'] == true;

    final profileDoc =
        await _db
            .collection('users')
            .doc(uid)
            .collection('profile')
            .doc('data')
            .get();

    return userCompleted || profileDoc.exists;
  }

  static Future<void> saveProfile({
    required String uid,
    required DateTime birthday,
    required int age,
    required double heightCm,
    required double currentWeightKg,
    required double targetWeightKg,
    required String goal,
    required String activityLevel,
    required int dailyCalories,
    required String heightUnit,
    required String weightUnit,
  }) async {
    final batch = _db.batch();

    final userRef = _db.collection('users').doc(uid);
    final profileRef = _db
        .collection('users')
        .doc(uid)
        .collection('profile')
        .doc('data');

    batch.set(userRef, {
      'profileCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    batch.set(profileRef, {
      'birthday': Timestamp.fromDate(birthday),
      'age': age,
      'heightCm': heightCm,
      'currentWeightKg': currentWeightKg,
      'targetWeightKg': targetWeightKg,
      'goal': goal,
      'activityLevel': activityLevel,
      'dailyCalories': dailyCalories,
      'heightUnit': heightUnit,
      'weightUnit': weightUnit,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }
}
