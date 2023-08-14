import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/auth/view/sign_up_page.dart';
import 'package:weather_station_esp32/auth/widgets/auth_button.dart';
import 'package:weather_station_esp32/auth/widgets/elevated_text_input.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud,
                    color: ColorPalette.darkBlue, size: 60.0),
                const SizedBox(height: 20.0),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) =>
                      previous.email != current.email,
                  builder: (context, state) {
                    return ElevatedTextInput(
                        onChanged: (input) => context
                            .read<AuthBloc>()
                            .add(EmailChanged(email: input)),
                        inputText: 'Email',
                        icon: const Icon(Icons.person));
                  },
                ),
                const SizedBox(height: 20.0),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) =>
                      previous.password != current.password,
                  builder: (context, state) {
                    return ElevatedTextInput(
                      onChanged: (input) => context
                          .read<AuthBloc>()
                          .add(PasswordChanged(password: input)),
                      inputText: 'Password',
                      obscureText: true,
                      icon: const Icon(Icons.keyboard),
                    );
                  },
                ),
                const SizedBox(height: 20),
                AuthButton(
                    textInput: 'Login',
                    onTap: () =>
                        context.read<AuthBloc>().add(SignInRequested())),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Not a member? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).push<void>(SignUpPage.route()),
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
      ),
    );
  }
}
