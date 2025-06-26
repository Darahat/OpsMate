import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';

/// A custom button for Google Sign-in functionality.
class GoogleSignInButton extends StatelessWidget {
  /// Creates a [GoogleSignInButton] instance.
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.network(
        'https://w7.pngwing.com/pngs/882/225/png-transparent-google-logo-google-logo-google-search-icon-google-text-logo-business-thumbnail.png',
        height: 24.0,
        width: 24.0,
      ),
      label: const Text('Sign in with Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        context.read<AuthBloc>().add(const GoogleSignInEvent());
      },
    );
  }
}
