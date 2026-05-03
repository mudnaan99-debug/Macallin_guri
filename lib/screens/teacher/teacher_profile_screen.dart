import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/teacher_model.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  _TeacherProfileScreenState createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String phone = '';
  String location = '';
  String educationLevel = '';
  String experience = '';
  List<String> subjects = [];
  String cvLink = '';
  bool isLoading = false;

  final TextEditingController _subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final session = context.watch<SessionController>();
    final uid = session.currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                onChanged: (val) => fullName = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (val) => phone = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location (City/District)'),
                onChanged: (val) => location = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              const Text('Academic Background', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Education Level (e.g. Bachelor Degree)'),
                onChanged: (val) => educationLevel = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Years of Experience'),
                onChanged: (val) => experience = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'CV Link (Optional)'),
                onChanged: (val) => cvLink = val,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                   Expanded(
                     child: TextFormField(
                       controller: _subjectController,
                       decoration: const InputDecoration(labelText: 'Add Subject'),
                     ),
                   ),
                   IconButton(
                     icon: const Icon(Icons.add_circle, color: Colors.amber, size: 30),
                     onPressed: () {
                       if (_subjectController.text.isNotEmpty) {
                         setState(() {
                           subjects.add(_subjectController.text.trim());
                           _subjectController.clear();
                         });
                       }
                     },
                   )
                ],
              ),
              Wrap(
                spacing: 8,
                children: subjects.map((s) => Chip(
                  label: Text(s),
                  onDeleted: () => setState(() => subjects.remove(s)),
                  backgroundColor: Colors.amber.withOpacity(0.2),
                )).toList(),
              ),
              const SizedBox(height: 40),
              isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && subjects.isNotEmpty) {
                        setState(() => isLoading = true);
                        TeacherModel newTeacher = TeacherModel(
                          id: uid!,
                          userId: uid,
                          fullName: fullName,
                          phone: phone,
                          location: location,
                          subjects: subjects,
                          educationLevel: educationLevel,
                          experience: experience,
                          status: 'pending', // Wait for admin approval
                          cvLink: cvLink.isNotEmpty ? cvLink : null,
                          createdAt: DateTime.now(),
                        );
                        await firestoreService.createTeacherProfile(newTeacher);
                        // Dashboard will auto re-render due to FutureBuilder/Stream
                      } else if (subjects.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one subject')));
                      }
                    },
                    child: const Text('SUBMIT FOR APPROVAL'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
