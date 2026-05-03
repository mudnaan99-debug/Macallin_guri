import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/job_model.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String subject = '';
  String location = '';
  double salary = 0;
  String schedule = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final uid = context.watch<SessionController>().currentUser?.id;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Job Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Job Title (e.g. Math Tutor)'),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Subject'),
                onChanged: (val) => subject = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (val) => location = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Salary range/amount'),
                keyboardType: TextInputType.number,
                onChanged: (val) => salary = double.tryParse(val) ?? 0,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Schedule (e.g. Mon-Fri, 4 PM)'),
                onChanged: (val) => schedule = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                onChanged: (val) => description = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 40),
              isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      if (uid == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not signed in.')),
                        );
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        JobModel job = JobModel(
                          id: '',
                          userId: uid,
                          title: title,
                          description: description,
                          subject: subject,
                          location: location,
                          salary: salary,
                          schedule: schedule,
                          createdAt: DateTime.now(),
                        );
                        await firestoreService.postJob(job);
                        setState(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job Posted Successfully!')));
                        _formKey.currentState!.reset();
                      }
                    },
                    child: const Text('POST JOB'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
