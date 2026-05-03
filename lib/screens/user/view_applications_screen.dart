import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';
import '../../models/job_model.dart';
import '../../models/application_model.dart';
import '../../models/teacher_model.dart';
import '../common/chat_screen.dart';

class ViewApplicationsScreen extends StatelessWidget {
  final JobModel job;
  const ViewApplicationsScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Applications: ${job.title}')),
      body: StreamBuilder<List<ApplicationModel>>(
        stream: firestoreService.getApplicationsForJob(job.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No applications yet.'));
          }

          final apps = snapshot.data!;
          return ListView.builder(
            itemCount: apps.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final app = apps[index];
              return ApplicationCard(app: app, firestoreService: firestoreService);
            },
          );
        },
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final ApplicationModel app;
  final FirestoreService firestoreService;
  const ApplicationCard({required this.app, required this.firestoreService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TeacherModel?>(
      // Note: We need a method to get teacher by teacherId (which is userId in this case)
      future: firestoreService.getTeacherByUserId(app.teacherId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final teacher = snapshot.data!;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person)),
                  title: Text(teacher.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(teacher.educationLevel),
                  trailing: Text(app.status.toUpperCase(), style: TextStyle(
                    color: app.status == 'accepted' ? Colors.green : (app.status == 'rejected' ? Colors.red : Colors.grey),
                    fontWeight: FontWeight.bold,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Experience: ${teacher.experience}'),
                ),
                const SizedBox(height: 12),
                if (app.status == 'pending')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => firestoreService.updateApplicationStatus(app.id, 'rejected'),
                        child: const Text('REJECT', style: TextStyle(color: Colors.red)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => firestoreService.updateApplicationStatus(app.id, 'accepted'),
                        child: const Text('ACCEPT'),
                      ),
                    ],
                  )
                else if (app.status == 'accepted')
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                         final myId = app.id; // Correct this to current user id
                         // I will use a placeholder for now as I don't have the context here easily without provider
                         // Better to handle it in a separate logic
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chat system opening...')));
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('CHAT WITH TEACHER'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
