import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/features/auth/presentation/widgets/auth_form.dart';

/// A StatefulWidget that displays the user registration interface.
class SignupPage extends StatelessWidget {
  /// Creates a [SignupPage] instance
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen:
            (previous, current) =>
                previous.status != current.status &&
                    current.status == AuthStatus.authenticated ||
                previous.message != current.message,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated && state.user != null) {
            // Navigate to tasks page using GoRouter
            context.go('/tasks');
          } else if (state.status == AuthStatus.unauthenticated &&
              state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Registration Failed'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: const Center(child: AuthForm(isLogin: false)),
      ),
    );
  }
}
