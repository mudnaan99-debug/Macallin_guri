import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String subject;
  final String location;
  final double salary;
  final String schedule;
  final DateTime createdAt;

  JobModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.subject,
    required this.location,
    required this.salary,
    required this.schedule,
    required this.createdAt,
  });

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      subject: map['subject'] ?? '',
      location: map['location'] ?? '',
      salary: (map['salary'] ?? 0).toDouble(),
      schedule: map['schedule'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'subject': subject,
      'location': location,
      'salary': salary,
      'schedule': schedule,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
