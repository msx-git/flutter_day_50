import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UsersFirebaseService {
  final _usersCollection = FirebaseFirestore.instance.collection("users");

  Stream<QuerySnapshot> getUsers() async* {
    yield* _usersCollection.snapshots();
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String userId,
  }) async {
    try {
      await _usersCollection.add({
        'name': name,
        'email': email,
        'userId':userId,
      });
    } on FirebaseException catch (e) {
      debugPrint("Firestore error: $e");
    } catch (e) {
      debugPrint("General error: $e");
    }
  }
}
