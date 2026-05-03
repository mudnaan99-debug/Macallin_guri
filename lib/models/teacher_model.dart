import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String location;
  final List<String> subjects;
  final String educationLevel;
  final String experience;
  final String status; // "pending" | "approved" | "rejected"
  final String rejectionReason;
  final String? cvLink;
  final DateTime createdAt;

  TeacherModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.location,
    required this.subjects,
    required this.educationLevel,
    required this.experience,
    required this.status,
    this.rejectionReason = '',
    this.cvLink,
    required this.createdAt,
  });

  factory TeacherModel.fromMap(Map<String, dynamic> map, String id) {
    return TeacherModel(
      id: id,
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      subjects: List<String>.from(map['subjects'] ?? []),
      educationLevel: map['educationLevel'] ?? '',
      experience: map['experience'] ?? '',
      status: map['status'] ?? 'pending',
      rejectionReason: map['rejectionReason'] ?? '',
      cvLink: map['cvLink'],
      createdAt: map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'location': location,
      'subjects': subjects,
      'educationLevel': educationLevel,
      'experience': experience,
      'status': status,
      'rejectionReason': rejectionReason,
      if (cvLink != null) 'cvLink': cvLink,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
