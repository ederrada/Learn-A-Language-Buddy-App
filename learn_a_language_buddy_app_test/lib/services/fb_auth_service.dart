import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //Method to register with email and password
  Future<User?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      User? newUser = auth.currentUser;
      //await db
      return userCredential.user;
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  //Method to login with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  //Once the existing user has been authenticated
  //Update user info
  Future<void> updateUserDisplayName(String displayName) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(displayName);
        await db.collection('users').doc(user.uid).set({
          'displayName': displayName,
          'email': user.email,
        });
      } catch (e) {
        print('Error updating user display name: $e');
        rethrow;
      }
    }
  }

  //Method to sign out the user
  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> deleteUser() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        await db.collection('users').doc(user.uid).delete();
        await user.delete();
      } catch (e) {
        print('Error deleting user: $e');
        rethrow;
      }
    }
  }
}
