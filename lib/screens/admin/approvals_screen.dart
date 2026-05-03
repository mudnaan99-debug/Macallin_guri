import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';
import '../../models/teacher_model.dart';

class ApprovalsScreen extends StatelessWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pending Teacher Approvals')),
      body: StreamBuilder<List<TeacherModel>>(
        stream: firestoreService.getPendingTeachers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending teacher approvals.'));
          }

          final teachers = snapshot.data!;
          return ListView.builder(
            itemCount: teachers.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(teacher.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(teacher.educationLevel),
                        trailing: Text(teacher.location),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Subjects: \${teacher.subjects.join(", ")}'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _showRejectDialog(context, teacher),
                            child: const Text('REJECT', style: TextStyle(color: Colors.red)),
                          ),
                          ElevatedButton(
                            onPressed: () => firestoreService.updateTeacherStatus(teacher.id, 'approved'),
                            child: const Text('APPROVE'),
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

  void _showRejectDialog(BuildContext context, TeacherModel teacher) {
    String reason = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Teacher'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Reason for rejection'),
          onChanged: (val) => reason = val,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              Provider.of<FirestoreService>(context, listen: false).updateTeacherStatus(teacher.id, 'rejected', reason: reason);
              Navigator.pop(context);
            },
            child: const Text('CONFIRM REJECTION'),
          ),
        ],
      ),
    );
  }
}
