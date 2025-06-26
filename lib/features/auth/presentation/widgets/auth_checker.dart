import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart';

/// A widget that checks authentication status and redirects accordingly.
class AuthChecker extends StatelessWidget {
  /// Creates an [AuthChecker] widget.
  const AuthChecker({super.key, required this.child});

  /// The widget to display when the user is authenticated.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    /// Dispatch check auth status event when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const CheckAuthStatusEvent());
    });

    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) =>
              previous.status != current.status &&
              current.status == AuthStatus.unauthenticated,
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          // Redirect to login page if user is not authenticated
          context.go('/login');
        } else {
          if (kDebugMode) {
            print('User is authenticated');
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Show loading indicator while checking auth status
          if (state.status == AuthStatus.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Show child widget if authenticated, otherwise show loading
          // (redirection will happen via BlocListener)
          return state.status == AuthStatus.authenticated
              ? child
              : const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
        },
      ),
    );
  }
}
