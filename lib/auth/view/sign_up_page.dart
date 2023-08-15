import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';
import 'package:weather_station_esp32/auth/widgets/auth_button.dart';
import 'package:weather_station_esp32/auth/widgets/elevated_text_input.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

import '../bloc/auth_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: context.read<AuthRepository>()),
      child: _SignUpForm(),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.errorMessage ?? 'User creation error!')));
        } else if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud,
                        color: ColorPalette.darkBlue, size: 60.0),
                    const SizedBox(height: 20.0),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ElevatedTextInput(
                            helperText: 'Displayed name.',
                            inputText: "Name",
                            icon: const Icon(Icons.abc),
                            onChanged: (input) => context
                                .read<AuthBloc>()
                                .add(DisplayNameChanged(displayName: input)));
                      },
                    ),
                    const SizedBox(height: 20.0),
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) =>
                          previous.email != current.email,
                      builder: (context, state) {
                        return ElevatedTextInput(
                          onChanged: (input) => context
                              .read<AuthBloc>()
                              .add(EmailChanged(email: input)),
                          errorText: state.errorMessage,
                          helperText: 'Enter your email address.',
                          inputText: 'Email',
                          icon: const Icon(Icons.person),
                        );
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
                          errorText: state.errorMessage,
                          helperText: 'Minimum 8 characters.',
                          inputText: 'Password',
                          obscureText: true,
                          icon: const Icon(Icons.lock),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) =>
                          previous.confirmedPassword !=
                          current.confirmedPassword,
                      builder: (context, state) {
                        return ElevatedTextInput(
                            errorText: state.errorMessage,
                            helperText: 'Passwords must match.',
                            inputText: 'Repeat password',
                            obscureText: true,
                            icon: const Icon(Icons.lock),
                            onChanged: (input) => context.read<AuthBloc>().add(
                                ConfirmPasswordChanged(
                                    confirmPassword: input)));
                      },
                    ),
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
          ),
        ),
      ),
    );
  }
}
