import 'package:flutter/material.dart';
import 'package:weather_station_esp32/auth/widgets/auth_button.dart';
import 'package:weather_station_esp32/auth/widgets/elevated_text_input.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud, color: ColorPalette.darkBlue, size: 60.0),
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
              const SizedBox(height: 20),
              AuthButton(textInput: 'Login', onTap: () {}),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Not a member? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {}, //TODO dolozyc funkcje do przelaczania ekranu
                    child: const Text(
                      'Create account here!',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: ColorPalette.midBlue),
                    ),
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
