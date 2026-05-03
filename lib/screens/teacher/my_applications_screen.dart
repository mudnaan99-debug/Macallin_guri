import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/application_model.dart';
import '../../models/job_model.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final uid = context.watch<SessionController>().currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: StreamBuilder<List<ApplicationModel>>(
        stream: uid == null
            ? Stream.value(<ApplicationModel>[])
            : firestoreService.getApplicationsForTeacher(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have not applied for any jobs yet.'));
          }

          final apps = snapshot.data!;
          return ListView.builder(
            itemCount: apps.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final app = apps[index];
              return ApplicationStatusCard(app: app, firestoreService: firestoreService);
            },
          );
        },
      ),
    );
  }
}

class ApplicationStatusCard extends StatelessWidget {
  final ApplicationModel app;
  final FirestoreService firestoreService;
  
  const ApplicationStatusCard({required this.app, required this.firestoreService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JobModel?>(
      future: firestoreService.getJobById(app.jobId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final job = snapshot.data!;

        return Card(
          child: ListTile(
            title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Subject: \${job.subject} | Location: \${job.location}'),
            trailing: Chip(
              label: Text(app.status.toUpperCase(), style: const TextStyle(color: Colors.white)),
              backgroundColor: app.status == 'accepted' ? Colors.green : (app.status == 'rejected' ? Colors.red : Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
