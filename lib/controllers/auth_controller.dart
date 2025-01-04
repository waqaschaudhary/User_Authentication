import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserLocally(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    await prefs.setString('email', user.email);
    await prefs.setString('username', user.username);
  }

  Future<UserModel?> getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    final email = prefs.getString('email');
    final username = prefs.getString('username');

    if (uid != null && email != null && username != null) {
      return UserModel(uid: uid, email: email, username: username);
    }
    return null;
  }
}
