import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/features/auth/presentation/widgets/auth_form.dart';

/// A StatefulWidget that displays the user login interface.
///
/// This page allows users to input their credentials and log into the app.
/// It is typically the entry point after the splash screen or onboarding.
class LoginPage extends StatelessWidget {
  /// Creates a [LoginPage] instance
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen:
            (previous, current) =>
                previous.status != current.status ||
                previous.message != current.message,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated && state.user != null) {
            context.go('/tasks');
          } else if (state.status == AuthStatus.unauthenticated &&
              state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Login Failed')),
            );
          }
        },
        builder: (context, state) {
          return const Center(child: AuthForm(isLogin: true));
        },
      ),
    );
  }
}
