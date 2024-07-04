import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_day_50/services/users_firebase_service.dart';

class UsersController with ChangeNotifier {
  final _usersFirebaseService = UsersFirebaseService();

  Stream<QuerySnapshot> get users async* {
    yield* _usersFirebaseService.getUsers();
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String userId,
  }) async {
    _usersFirebaseService.addUser(name: name, email: email,userId: userId);
  }
}
