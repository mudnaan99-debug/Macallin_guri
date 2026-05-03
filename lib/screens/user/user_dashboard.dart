import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/job_model.dart';
import '../../models/teacher_model.dart';
import 'post_job_screen.dart';
import 'view_applications_screen.dart';
import '../common/chat_list_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final uid = session.currentUser?.id;
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatListScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => session.signOut(),
          ),
        ],
      ),
      body: _buildBody(uid, firestoreService),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find Tutors'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Post Job'),
        ],
      ),
    );
  }

  Widget _buildMyJobs(String? uid, FirestoreService firestoreService) {
    if (uid == null) {
      return const Center(child: Text('Not signed in.'));
    }
    return StreamBuilder<List<JobModel>>(
      stream: firestoreService.getMyJobs(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('You haven\'t posted any jobs yet.'));
        }

        final jobs = snapshot.data!;
        return ListView.builder(
          itemCount: jobs.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Card(
              child: ListTile(
                title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${job.subject} - ${job.location}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewApplicationsScreen(job: job)),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(String? uid, FirestoreService firestoreService) {
    if (_selectedIndex == 0) return _buildApprovedTeachers(firestoreService);
    if (_selectedIndex == 1) return _buildMyJobs(uid, firestoreService);
    return const PostJobScreen();
  }

  Widget _buildApprovedTeachers(FirestoreService firestoreService) {
    return StreamBuilder<List<TeacherModel>>(
      stream: firestoreService.getApprovedTeachers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No approved teachers available yet.'));
        }

        final teachers = snapshot.data!;
        return ListView.builder(
          itemCount: teachers.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Text(teacher.fullName[0].toUpperCase()),
                ),
                title: Text(teacher.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${teacher.subjects.join(", ")}\n${teacher.location}'),
                isThreeLine: true,
                trailing: ElevatedButton(
                  onPressed: () {
                    // Logic to request this teacher.
                    // Depending on the app, this could send a notification or open a chat.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostJobScreen()), // Redirect to post job for now, or direct message
                    );
                  },
                  child: const Text('Request'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
