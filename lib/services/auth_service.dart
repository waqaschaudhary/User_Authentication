import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up method
  Future<User?> signUp(String email, String password, String username) async {
    try {
      // Create the user with FirebaseAuth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user from the credentials
      User? user = userCredential.user;

      if (user != null) {
        // Store the username and email in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });

        return user;
      } else {
        print("Error: User not created.");
        return null;
      }
    } catch (e) {
      print("Error during sign up: $e");
      return null;
    }
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      // If username exists in Firestore, return false
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print("Error checking username: $e");
      return false;
    }
  }
}
