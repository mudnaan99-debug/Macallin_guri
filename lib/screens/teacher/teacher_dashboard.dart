import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/teacher_model.dart';
import 'teacher_profile_screen.dart';
import 'job_list_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final session = context.watch<SessionController>();
    final uid = session.currentUser?.id;

    return StreamBuilder<TeacherModel?>(
      stream: uid == null
          ? Stream<TeacherModel?>.value(null)
          : firestoreService.streamTeacherByUserId(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final teacher = snapshot.data;

        if (teacher == null) {
          return const TeacherProfileScreen(); // Redirect to create profile
        }

        if (teacher.status == 'rejected') {
          return Scaffold(
            appBar: AppBar(title: const Text('Account Rejected')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.error_outline, size: 80, color: Colors.red),
                   const SizedBox(height: 10),
                   const Text('Profile Rejected', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   Text('Reason: \${teacher.rejectionReason}'),
                   const SizedBox(height: 20),
                   ElevatedButton(
                      onPressed: () => session.signOut(),
                      child: const Text('LOGOUT'),
                    ),
                ],
              ),
            ),
          );
        }

        if (teacher.status == 'pending') {
          return Scaffold(
            appBar: AppBar(title: const Text('Pending Approval')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.access_time, size: 80, color: Colors.amber),
                   const SizedBox(height: 10),
                   const Text('Profile Pending Approval', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   const Padding(
                     padding: EdgeInsets.all(16.0),
                     child: Text(
                       'Your application is currently under review by the admin. Please wait for approval to see available jobs.',
                       textAlign: TextAlign.center,
                     ),
                   ),
                   const SizedBox(height: 20),
                   ElevatedButton(
                      onPressed: () => session.signOut(),
                      child: const Text('LOGOUT'),
                    ),
                ],
              ),
            ),
          );
        }

        return JobListScreen(teacher: teacher);
      },
    );
  }
}
