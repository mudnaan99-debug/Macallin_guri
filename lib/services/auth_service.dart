import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of auth state
  Stream<User?> get user => _auth.authStateChanges();

  // Sign up
  Future<UserCredential?> signUp(String email, String password, String username, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        // Create user doc in firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'role': role,
          'status': 'active',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Create user without logging out (for Admin/TeamIT)
  Future<UserCredential?> signUpUserWithoutLogout(String email, String password, String username, String role) async {
    try {
      FirebaseApp app;
      try {
        app = Firebase.app('Secondary');
      } catch (e) {
        app = await Firebase.initializeApp(
          name: 'Secondary',
          options: Firebase.app().options,
        );
      }

      UserCredential result = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'role': role,
          'status': 'active',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await app.delete();
      return result;
    } catch (e) {
      print('Secondary app user creation error: \$e');
      return null;
    }
  }

  // Login
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      // Auto-provision Team IT if it's the master email
      if (email.toLowerCase() == 'maxamedxsn24@gmail.com' && userCredential.user != null) {
        String uid = userCredential.user!.uid;
        DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
        if (!doc.exists) {
          await _firestore.collection('users').doc(uid).set({
            'username': 'Team IT Master',
            'role': 'teamIt',
            'status': 'active',
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Force update role just in case it was created as regular user previously
          if (doc.get('role') != 'teamIt') {
            await _firestore.collection('users').doc(uid).update({
              'role': 'teamIt',
              'status': 'active'
            });
          }
        }
      }

      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Change Password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        
        // Update password
        await user.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      print('Change password error: \$e');
      return false;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
