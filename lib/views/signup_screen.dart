import 'package:flutter/material.dart';
import 'package:login/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Email field
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              // Username field
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 10),
              // Password field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        await handleSignUp(context);
                      },
                      child: Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleSignUp(BuildContext context) async {
    setState(() => isLoading = true);

    String email = emailController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      setState(() => isLoading = false);
      return;
    }

    // Check if the username is unique
    bool isUsernameAvailable = await _authService.isUsernameAvailable(username);

    if (!isUsernameAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username is already taken")),
      );
      setState(() => isLoading = false);
      return;
    }

    // Proceed with signup if username is unique
    final user = await _authService.signUp(email, password, username);

    setState(() => isLoading = false);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up failed")),
      );
    }
  }
}
