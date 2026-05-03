import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/session_controller.dart';
import 'admin/admin_dashboard.dart';
import 'teacher/teacher_dashboard.dart';
import 'user/user_dashboard.dart';
import 'teamit/team_it_dashboard.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>();
    final UserModel? user = session.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user.email?.toLowerCase() == 'maxamedxsn24@gmail.com') {
      return const TeamItDashboard();
    }

    if (user.status == 'blocked') {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Your account has been blocked.', style: TextStyle(fontSize: 20)),
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

    switch (user.role) {
      case 'teamIt':
        return const TeamItDashboard();
      case 'admin':
        return const AdminDashboard();
      case 'teacher':
      case 'tutor':
        return const TeacherDashboard();
      default:
        return const UserDashboard();
    }
  }
}
