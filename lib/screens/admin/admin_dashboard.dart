import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/session_controller.dart';
import '../../models/teacher_model.dart';
import 'manage_users_screen.dart';
import 'approvals_screen.dart';
import 'admin_applications_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _showChangePasswordDialog(BuildContext context) {
    String currentPassword = '';
    String newPassword = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
              onChanged: (val) => currentPassword = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
              onChanged: (val) => newPassword = val,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () async {
              if (currentPassword.isEmpty || newPassword.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid passwords (min 6 chars)')),
                );
                return;
              }
              final success = await Provider.of<AuthService>(context, listen: false)
                  .changePassword(currentPassword, newPassword);
              Navigator.pop(context);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully.')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to change password. Check current password.')),
                );
              }
            },
            child: const Text('CHANGE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Provider.of<SessionController>(context, listen: false).signOut(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text('Admin Menu', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageUsersScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Job Applications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminApplicationsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                _showChangePasswordDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => Provider.of<SessionController>(context, listen: false).signOut(),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings, size: 100, color: Colors.blueGrey),
            const SizedBox(height: 20),
            const Text('Welcome to Admin Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Use the side menu to Manage Users \nand view Job Applications.', textAlign: TextAlign.center),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.assignment),
              label: const Text('VIEW JOB APPLICATIONS'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminApplicationsScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
