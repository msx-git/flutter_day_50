import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    final pushToken = await FirebaseMessaging.instance.getToken();
    try {
      await _usersCollection.add({
        'name': name,
        'email': email,
        'userId': userId,
        'pushToken': pushToken,
      });
    } on FirebaseException catch (e) {
      debugPrint("Firestore error: $e");
    } catch (e) {
      debugPrint("General error: $e");
    }
  }
}
