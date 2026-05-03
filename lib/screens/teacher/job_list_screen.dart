import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/job_model.dart';
import '../../models/application_model.dart';
import '../../models/teacher_model.dart';
import '../common/chat_list_screen.dart';
import 'my_applications_screen.dart';

class JobListScreen extends StatelessWidget {
  final TeacherModel teacher;
  const JobListScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatListScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<SessionController>().signOut(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Text('Teacher Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Available Jobs'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('My Applications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MyApplicationsScreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<JobModel>>(
              stream: firestoreService.getJobs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No jobs available at the moment.'));
                }

                final jobs = snapshot.data!;

                return ListView.builder(
                  itemCount: jobs.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return JobCard(job: job, teacher: teacher);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final JobModel job;
  final TeacherModel teacher;
  const JobCard({required this.job, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(job.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('\$${job.salary}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.book, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(job.subject, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(job.location, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            Text(job.description, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showApplyDialog(context, job),
              child: const Text('APPLY NOW'),
            ),
          ],
        ),
      ),
    );
  }

  void _showApplyDialog(BuildContext context, JobModel job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Job'),
        content: Text('Are you sure you want to apply for "${job.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () async {
              final session = context.read<SessionController>();
              final firestoreService = Provider.of<FirestoreService>(context, listen: false);

              ApplicationModel app = ApplicationModel(
                id: '',
                jobId: job.id,
                teacherId: session.currentUser!.id,
                status: 'pending',
                createdAt: DateTime.now(),
              );
              await firestoreService.applyForJob(app);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application Sent!')));
            },
            child: const Text('CONFIRM'),
          ),
        ],
      ),
    );
  }
}
