import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String id;
  final String jobId;
  final String teacherId;
  final String status; // "pending" | "accepted" | "rejected"
  final DateTime createdAt;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.teacherId,
    required this.status,
    required this.createdAt,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map, String id) {
    return ApplicationModel(
      id: id,
      jobId: map['jobId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'teacherId': teacherId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
