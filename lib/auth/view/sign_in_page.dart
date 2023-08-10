import 'package:flutter/material.dart';
import 'package:weather_station_esp32/auth/widgets/elevated_text_input.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(187, 215, 246, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud, color: Colors.white, size: 60.0),
              const SizedBox(height: 20.0),
              ElevatedTextInput(
                controller: _emailController,
                inputText: 'Email',
                icon: const Icon(Icons.person),
              ),
              const SizedBox(height: 20.0),
              ElevatedTextInput(
                controller: _passwordController,
                inputText: 'Password',
                icon: const Icon(Icons.keyboard),
              ),
              ElevatedButton(onPressed: () {}, child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
