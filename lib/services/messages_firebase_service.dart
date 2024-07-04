import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MessagesFirebaseService {
  final _messageCollection = FirebaseFirestore.instance.collection("messages");

  Stream<QuerySnapshot> getMessages() async* {
    yield* _messageCollection.snapshots();
  }

  Future<void> sendMessage({
    required String date,
    required String receiverId,
    required String senderId,
    required String text,
  }) async {
    try {
      _messageCollection.add({
        'date': date,
        'receiverId': receiverId,
        'senderId': senderId,
        'text': text,
      });
    } on FirebaseException catch (e) {
      debugPrint("Firestore error: $e");
    } catch (e) {
      debugPrint("General error: $e");
    }
  }
}
