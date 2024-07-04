import 'package:flutter/material.dart';

import '../services/firebase_auth_service.dart';

class AuthController with ChangeNotifier {
  final _firebaseAuthService = FirebaseAuthService();

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.register(email: email, password: password);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.login(email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }
}
