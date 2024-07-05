import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_day_50/services/messages_firebase_service.dart';

class MessagesController with ChangeNotifier {
  final _messagesFirebaseService = MessagesFirebaseService();

  Stream<QuerySnapshot> get messages async* {
    yield* _messagesFirebaseService.getMessages();
  }

  Future<void> sendMessage({
    required String date,
    required String receiverId,
    required String senderId,
    required String text,
  }) async {
    await _messagesFirebaseService.sendMessage(
      date: date,
      receiverId: receiverId,
      senderId: senderId,
      text: text,
    );
  }
}