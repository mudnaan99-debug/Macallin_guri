import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';
import '../models/teacher_model.dart';
import '../models/application_model.dart';
import '../models/chat_model.dart';
import '../models/notification_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Teachers ---
  Future<void> createTeacherProfile(TeacherModel teacher) async {
    await _db.collection('teachers').doc(teacher.id).set(teacher.toMap());
  }

  Stream<List<TeacherModel>> getPendingTeachers() {
    return _db
        .collection('teachers')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TeacherModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<TeacherModel>> getApprovedTeachers() {
    return _db
        .collection('teachers')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TeacherModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateTeacherStatus(String id, String status, {String reason = ''}) async {
    await _db.collection('teachers').doc(id).update({
      'status': status,
      'rejectionReason': reason,
    });
  }

  Future<TeacherModel?> getTeacherByUserId(String userId) async {
    var snapshot = await _db.collection('teachers').where('userId', isEqualTo: userId).get();
    if (snapshot.docs.isNotEmpty) {
      return TeacherModel.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
    }
    return null;
  }

  Stream<TeacherModel?> streamTeacherByUserId(String userId) {
    return _db.collection('teachers').where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return TeacherModel.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
      }
      return null;
    });
  }

  // --- Jobs ---
  Future<void> postJob(JobModel job) async {
    await _db.collection('jobs').add(job.toMap());
  }

  Stream<List<JobModel>> getJobs() {
    return _db.collection('jobs').orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => JobModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<JobModel?> getJobById(String jobId) async {
    var doc = await _db.collection('jobs').doc(jobId).get();
    if (doc.exists) {
      return JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Stream<List<JobModel>> getMyJobs(String userId) {
    return _db.collection('jobs').where('userId', isEqualTo: userId).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => JobModel.fromMap(doc.data(), doc.id)).toList());
  }

  // --- Applications ---
  Future<void> applyForJob(ApplicationModel app) async {
    await _db.collection('applications').add(app.toMap());
  }

  Stream<List<ApplicationModel>> getApplicationsForJob(String jobId) {
    return _db.collection('applications').where('jobId', isEqualTo: jobId).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => ApplicationModel.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<ApplicationModel>> getApplicationsForTeacher(String teacherId) {
    return _db.collection('applications').where('teacherId', isEqualTo: teacherId).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => ApplicationModel.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<ApplicationModel>> getAllApplications() {
    return _db.collection('applications').orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => ApplicationModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateApplicationStatus(String id, String status) async {
    await _db.collection('applications').doc(id).update({'status': status});
  }

  // --- Notifications ---
  Future<void> sendNotification(NotificationModel note) async {
    await _db.collection('notifications').add(note.toMap());
  }

  Stream<List<NotificationModel>> getNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // --- Messaging ---
  Stream<List<ChatModel>> getMyChats(String userId) {
    return _db
        .collection('messages')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatModel.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _db
        .collection('messages')
        .doc(chatId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> sendMessage(String chatId, MessageModel msg) async {
    await _db.collection('messages').doc(chatId).collection('chats').add(msg.toMap());
    await _db.collection('messages').doc(chatId).update({
      'lastMessage': msg.message,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> startChat(String myId, String otherId) async {
    // Check if chat exists
    var existing = await _db
        .collection('messages')
        .where('participants', arrayContains: myId)
        .get();
    
    for (var doc in existing.docs) {
      List p = doc['participants'];
      if (p.contains(otherId)) return doc.id;
    }

    // Create new
    var ref = await _db.collection('messages').add({
      'participants': [myId, otherId],
      'lastMessage': '',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }
}
