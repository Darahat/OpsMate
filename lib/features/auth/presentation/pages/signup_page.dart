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
                current.status == AuthStatus.authenticated,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            // Navigate to tasks page using GoRouter
            context.go('/tasks');
          }
        },
        child: const Center(child: AuthForm(isLogin: false)),
      ),
    );
  }
}
