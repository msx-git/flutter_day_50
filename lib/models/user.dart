import 'package:cloud_firestore/cloud_firestore.dart';

class Foydalanuvchi {
  final String id;
  final String name;
  final String email;
  final String userId;
  final String? pushToken;

  const Foydalanuvchi({
    required this.id,
    required this.name,
    required this.email,
    required this.userId,
    required this.pushToken,
  });

  @override
  String toString() {
    return 'Foydalanuvchi{id: $id, name: $name, email: $email, userId: $userId, pushToken: $pushToken}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userId': userId,
      'pushToken': pushToken,
    };
  }

  factory Foydalanuvchi.fromJson(Map<String, dynamic> json) {
    return Foydalanuvchi(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      userId: json['userId'] as String,
      pushToken: json['pushToken'] ?? "",
    );
  }

  factory Foydalanuvchi.fromQuery(QueryDocumentSnapshot query) {
    return Foydalanuvchi(
      id: query.id,
      name: query['name'] as String,
      email: query['email'] as String,
      userId: query['userId'] as String,
      pushToken: query['pushToken'] ?? "",
    );
  }
}
