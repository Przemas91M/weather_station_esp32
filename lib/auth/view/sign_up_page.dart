import 'package:flutter/material.dart';
import 'package:weather_station_esp32/auth/widgets/auth_button.dart';
import 'package:weather_station_esp32/auth/widgets/elevated_text_input.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                  inputText: "Name",
                  icon: const Icon(Icons.abc),
                  onChanged: (input) {}),
              const SizedBox(height: 20.0),
              ElevatedTextInput(
                onChanged: (input) {},
                inputText: 'Email',
                icon: const Icon(Icons.person),
              ),
              const SizedBox(height: 20.0),
              ElevatedTextInput(
                onChanged: (input) {},
                inputText: 'Password',
                obscureText: true,
                icon: const Icon(Icons.lock),
              ),
              const SizedBox(height: 20),
              ElevatedTextInput(
                  inputText: 'Repeat password',
                  obscureText: true,
                  icon: const Icon(Icons.lock),
                  onChanged: (input) {}),
              const SizedBox(height: 20.0),
              AuthButton(textInput: 'Register', onTap: () {}),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Already a member? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Sign in here.',
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
