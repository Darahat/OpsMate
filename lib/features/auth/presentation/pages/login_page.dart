import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';

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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/tasks');
          } else if (state.status == AuthStatus.unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Login Failed')),
            );
          }
        },
      ),
    );
  }
}
