import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterService {
  RegisterService._();

  static final RegisterService instance =
      RegisterService._();

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> registerEmployee({
    required String employeeId,
    required String name,
    required String email,
    required String password,
  }) async {

    final id =
        employeeId.trim().toUpperCase();

    /// Only EMP IDs allowed
    if (!id.startsWith('EMP')) {
      throw Exception(
        'Employee ID must start with EMP.',
      );
    }

    /// Check duplicate Employee ID
    final existingEmployee =
        await _firestore
            .collection('employees')
            .doc(id)
            .get();

    if (existingEmployee.exists) {
      throw Exception(
        'Employee ID already exists.',
      );
    }

    /// Check duplicate email in Firebase Auth
    try {
      final methods =
          await _auth.fetchSignInMethodsForEmail(
        email.trim(),
      );

      if (methods.isNotEmpty) {
        throw Exception(
          'Email already registered.',
        );
      }
    } catch (_) {}

    /// Create Firebase Authentication User
    final credential =
        await _auth
            .createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid =
        credential.user!.uid;

    /// Create Firestore Employee Record
    await _firestore
        .collection('employees')
        .doc(id)
        .set({

      'uid': uid,

      'employeeId': id,

      'name': name.trim(),

      'email': email.trim(),

      'role': 'employee',

      'approvalStatus': 'pending',

      'active': false,

      'notificationsEnabled': true,

      'darkMode': false,

      'soundEnabled': true,

      'criticalAlertsOnly': false,

      'selectedTracks': [],
    });

    /// Logout immediately
    await _auth.signOut();
  }
}