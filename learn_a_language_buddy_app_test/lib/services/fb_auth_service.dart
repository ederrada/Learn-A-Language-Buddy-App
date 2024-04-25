import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreService db = FirestoreService();

  //Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      //Get the newly created user
      User? newUser = userCredential.user;

      //Create user document in Firestore
      if (newUser != null) {
        await db.createUser(
          newUser.uid,
          name,
          newUser.email,
        );
      }

      return newUser;
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  // Method to login with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  // Method to update user display name
  Future<void> updateUserDisplayName(String displayName) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(displayName);
        await db.updateUser(
          user.uid,
          displayName,
          user.email!,
        );
      } catch (e) {
        print('Error updating user display name: $e');
        rethrow;
      }
    }
  }

  // Method to sign out the user
  Future<void> signOut() async {
    await auth.signOut();
  }

  // Get the current authenticated user
  User? getCurrentUser() {
    return auth.currentUser;
  }

  // Method to delete user account
  Future<void> deleteUser() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        await db.deleteUser(user.uid); // Delete user document
        await user.delete(); // Delete user in Firebase Authentication
      } catch (e) {
        print('Error deleting user: $e');
        rethrow;
      }
    }
  }
}
