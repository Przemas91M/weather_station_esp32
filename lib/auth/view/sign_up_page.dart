import 'package:flutter/material.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  AuthRepository authRepo = AuthRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Display name'),
                controller: _displayNameController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                controller: _emailController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Password'),
                controller: _passwordController,
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authRepo.signUpWithEmailPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          displayName: _displayNameController.text);
                    },
                    child: const Text('Sign Up'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authRepo.signInWithEmailPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                    },
                    child: const Text('Sign In'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(authRepo.currentUser.toString());
                    },
                    child: const Text('Show User'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
