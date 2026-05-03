import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String role; // Django: student|tutor|parent|publisher|admin — legacy: teacher|user|teamIt
  final DateTime createdAt;
  final String status; // "active" | "blocked"
  final String? email;

  UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
    this.status = 'active',
    this.email,
  });

  factory UserModel.fromApiJson(Map<String, dynamic> json) {
    DateTime created = DateTime.now();
    final raw = json['created_at'];
    if (raw is String) {
      created = DateTime.tryParse(raw) ?? created;
    }
    return UserModel(
      id: json['id'].toString(),
      username: (json['name'] ?? json['username'] ?? '') as String,
      role: (json['role'] ?? 'student') as String,
      createdAt: created,
      status: (json['status'] ?? 'active') as String,
      email: json['email'] as String?,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      username: map['username'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      status: map['status'] ?? 'active',
      email: map['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      if (email != null) 'email': email,
    };
  }
}
