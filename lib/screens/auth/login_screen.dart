import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/session_controller.dart';
import 'landing_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Hero(
                  tag: 'logo',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'MACALIN QURI',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const Text(
                  'Welcome back!',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Enter an email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (val) => val == null || val.length < 6 ? 'Password too short' : null,
                ),
                const SizedBox(height: 16),
                Text(
                  'Sample: student@sample.macalin ama demo@sample.macalin — Password: Demo123!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          FocusScope.of(context).unfocus();
                          setState(() => isLoading = true);
                          final messenger = ScaffoldMessenger.of(context);
                          final session =
                              Provider.of<SessionController>(context, listen: false);
                          final ok = await session.login(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (!mounted) return;
                          if (!ok) {
                            final msg = session.lastLoginError ??
                                'Login failed. Check email and password.';
                            messenger.showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          }
                          setState(() => isLoading = false);
                        },
                        child: const Text('LOGIN'),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LandingScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Looking for Tutors or Jobs? ",
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                      children: const [
                        TextSpan(
                          text: 'Go to Home',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
