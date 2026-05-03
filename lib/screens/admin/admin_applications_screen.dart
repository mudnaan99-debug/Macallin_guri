import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';
import '../../models/application_model.dart';
import '../../models/teacher_model.dart';
import '../../models/job_model.dart';

class AdminApplicationsScreen extends StatelessWidget {
  const AdminApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We need a stream to get ALL applications
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Job Applications')),
      body: StreamBuilder<List<ApplicationModel>>(
        // Assuming we add a method to get all applications
        stream: firestoreService.getAllApplications(), 
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No job applications found.'));
          }

          final apps = snapshot.data!;
          return ListView.builder(
            itemCount: apps.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final app = apps[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status: \${app.status.toUpperCase()}', 
                            style: TextStyle(
                              color: app.status == 'accepted' ? Colors.green : (app.status == 'rejected' ? Colors.red : Colors.orange),
                              fontWeight: FontWeight.bold
                            )
                          ),
                          Text(app.createdAt.toString().split(' ')[0]),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<JobModel?>(
                        future: firestoreService.getJobById(app.jobId),
                        builder: (context, jobSnapshot) {
                          if (!jobSnapshot.hasData) return const Text('Loading job info...');
                          final job = jobSnapshot.data;
                          if (job == null) return const Text('Job deleted');
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Job: \${job.title} (\${job.subject})', style: const TextStyle(fontWeight: FontWeight.bold)),
                          );
                        }
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<TeacherModel?>(
                        future: firestoreService.getTeacherByUserId(app.teacherId),
                        builder: (context, teacherSnapshot) {
                          if (!teacherSnapshot.hasData) return const Text('Loading applicant info...');
                          final teacher = teacherSnapshot.data;
                          if (teacher == null) return const Text('Applicant deleted');
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Applicant: \${teacher.fullName} (\${teacher.phone})'),
                          );
                        }
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
                            ElevatedButton(
                              onPressed: () => firestoreService.updateApplicationStatus(app.id, 'accepted'),
                              child: const Text('ACCEPT'),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
