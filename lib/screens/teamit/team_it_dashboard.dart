import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/session_controller.dart';
import '../admin/approvals_screen.dart';
import '../admin/admin_applications_screen.dart';

class TeamItDashboard extends StatefulWidget {
  const TeamItDashboard({super.key});

  @override
  State<TeamItDashboard> createState() => _TeamItDashboardState();
}

class _TeamItDashboardState extends State<TeamItDashboard> {
  void _showAddUserDialog() {
    String newEmail = '';
    String newPassword = '';
    String newUsername = '';
    String newRole = 'admin'; // default role to create

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            bool isCreating = false;
            return AlertDialog(
              title: const Text('Create New User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: newRole,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                        DropdownMenuItem(value: 'user', child: Text('User')),
                      ],
                      onChanged: (val) => setStateDialog(() => newRole = val!),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      onChanged: (val) => newUsername = val,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (val) => newEmail = val,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onChanged: (val) => newPassword = val,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                isCreating 
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                  onPressed: () async {
                    if (newEmail.isEmpty || newPassword.length < 6 || newUsername.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields (Min password 6 chars)')),
                      );
                      return;
                    }
                    setStateDialog(() => isCreating = true);
                    final authService = Provider.of<AuthService>(context, listen: false);
                    var res = await authService.signUpUserWithoutLogout(
                      newEmail.trim(), 
                      newPassword, 
                      newUsername.trim(), 
                      newRole
                    );
                    if (res != null) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User created successfully.')),
                      );
                    } else {
                      setStateDialog(() => isCreating = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to create user.')),
                      );
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showEditUserDialog(String uid, String currentUsername, String currentRole) {
    String editUsername = currentUsername;
    String editRole = currentRole;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Edit User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: editRole,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                        DropdownMenuItem(value: 'user', child: Text('User')),
                      ],
                      onChanged: (val) => setStateDialog(() => editRole = val!),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: editUsername,
                      decoration: const InputDecoration(labelText: 'Username'),
                      onChanged: (val) => editUsername = val,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('users').doc(uid).update({
                      'username': editUsername.trim(),
                      'role': editRole,
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User updated successfully.')),
                    );
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _deleteUser(String uid) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user? They will not be able to log in.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(uid).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User deleted.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      )
    );
  }

  void _toggleUserStatus(String uid, String currentStatus) async {
    String newStatus = currentStatus == 'blocked' ? 'active' : 'blocked';
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'status': newStatus});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User marked as $newStatus')),
    );
  }

  void _toggleNotifications(String uid, bool currentVal) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'notificationsEnabled': !currentVal});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(!currentVal ? 'Notifications Enabled' : 'Notifications Disabled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team IT Dashboard'),
        actions: [
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
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text('Team IT Menu', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Job Applications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminApplicationsScreen()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: const Icon(Icons.person_add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No users found.'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final uid = docs[index].id;
              final username = data['username'] ?? 'No Username';
              final role = data['role'] ?? 'user';
              final status = data['status'] ?? 'active';
              final notifsEnabled = data['notificationsEnabled'] ?? true;
              final isTeamIt = role == 'teamIt';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(username),
                  subtitle: Text('Role: $role | Status: $status | Notifs: ${notifsEnabled ? "ON" : "OFF"}'),
                  trailing: isTeamIt 
                    ? const Icon(Icons.admin_panel_settings, color: Colors.blue)
                    : PopupMenuButton<String>(
                        onSelected: (val) {
                          if (val == 'edit') _showEditUserDialog(uid, username, role);
                          if (val == 'delete') _deleteUser(uid);
                          if (val == 'toggle_status') _toggleUserStatus(uid, status);
                          if (val == 'toggle_notifs') _toggleNotifications(uid, notifsEnabled);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit Info')),
                          PopupMenuItem(
                            value: 'toggle_status', 
                            child: Text(status == 'blocked' ? 'Unblock User' : 'Block User')
                          ),
                          PopupMenuItem(
                            value: 'toggle_notifs', 
                            child: Text(notifsEnabled ? 'Disable Notifications' : 'Enable Notifications')
                          ),
                          const PopupMenuItem(value: 'delete', child: Text('Delete User', style: TextStyle(color: Colors.red))),
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
