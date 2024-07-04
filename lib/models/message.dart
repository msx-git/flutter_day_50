import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final String date;
  final String senderId;
  final String receiverId;

  const Message({
    required this.id,
    required this.text,
    required this.date,
    required this.senderId,
    required this.receiverId,
  });

  @override
  String toString() {
    return 'Message{id: $id, text: $text, date: $date, senderId: $senderId, receiverId: $receiverId}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  factory Message.fromQuery(QueryDocumentSnapshot query) {
    return Message(
      id: query.id,
      text: query['text'] as String,
      date: query['date'] as String,
      senderId: query['senderId'] as String,
      receiverId: query['receiverId'] as String,
    );
  }
}
