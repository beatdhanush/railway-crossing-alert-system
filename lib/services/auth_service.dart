import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'role_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance =
      AuthService._();

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// Universal Login
  Future<Map<String, dynamic>> login({
    required String userId,
    required String password,
  }) async {

    final id = userId.trim().toUpperCase();

    final role =
        RoleService.detectRole(id);

    if (role == null) {
      throw Exception(
        'Invalid User ID.',
      );
    }

    String collectionName;

    switch (role) {
      case 'employee':
        collectionName = 'employees';
        break;

      case 'operator':
        collectionName = 'operators';
        break;

      case 'admin':
        collectionName = 'admins';
        break;

      default:
        throw Exception(
          'Invalid role.',
        );
    }

    final userDoc =
        await _firestore
            .collection(collectionName)
            .doc(id)
            .get();

    if (!userDoc.exists) {
      throw Exception(
        'User account not found.',
      );
    }

    final data =
        userDoc.data()!;

    final email =
        data['email'];

    if (email == null ||
        email.toString().isEmpty) {
      throw Exception(
        'Email not configured.',
      );
    }

    /// Employee-specific approval
    if (role == 'employee') {

      final approvalStatus =
          data['approvalStatus'];

      if (approvalStatus !=
          'approved') {

        throw Exception(
          'Your account is pending approval.',
        );
      }
    }

    /// Active account check
    final active =
        data['active'] ?? true;

    if (active != true) {
      throw Exception(
        'Account is inactive.',
      );
    }

    await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return {
      'userId': id,
      'role': role,
      'data': data,
    };
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Current Firebase User
  User? get currentUser =>
      _auth.currentUser;

  /// Is Logged In
  bool get isLoggedIn =>
      _auth.currentUser != null;
}