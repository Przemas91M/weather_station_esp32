import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';
import 'package:weather_station_esp32/auth/widgets/auth_button.dart';
import 'package:weather_station_esp32/auth/widgets/elevated_text_input.dart';
import 'package:weather_station_esp32/style/styling.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/auth_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository: context.read<AuthRepository>()),
      child: _SignInForm(),
    );
  }
}

class _SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var locale = AppLocalizations.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.errorMessage ?? 'Validation error!')));
        } else if (state.status == AuthStatus.authenticated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Login successful!')));
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
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
                          errorText: state.errorMessage,
                          helperText: locale!.emailInput,
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
                        errorText: state.errorMessage,
                        helperText: locale!.passwordInput,
                        inputText: locale.password,
                        obscureText: true,
                        icon: const Icon(Icons.lock),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    if (state.status == AuthStatus.loading) {
                      return const CircularProgressIndicator();
                    } else {
                      return AuthButton(
                          textInput: locale!.signIn,
                          onTap: () =>
                              context.read<AuthBloc>().add(SignInRequested()));
                    }
                  }),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${locale!.notMember} ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/signUp'),
                        child: Text(
                          locale.createAccount,
                          style: theme.textTheme.bodyMedium!
                              .apply(decoration: TextDecoration.underline),
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
    );
  }
}
