import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/core/widgets/custom_button.dart';
import 'package:opsmate/core/widgets/custom_text_fields.dart';

/// A reusable authentication form widget supporting both login and registration.
///
/// This widget dynamically shows/hides the name input field based on the [isLogin] flag.
/// It also validates from input and triggers [LoginEvent] or [RegisterEvent] through [AuthBloc].
class AuthForm extends StatefulWidget {
  /// Creates an [AuthForm] instance.
  const AuthForm({super.key, required this.isLogin});

  /// Indicates wheter the form is in login mode ('true') or register mode ('false').
  final bool isLogin;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  /// Key used to validate the form state.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the email input field.
  final _emailController = TextEditingController();

  /// Controller for the password input field.
  final _passwordController = TextEditingController();

  /// Controller for the name input field (used in registration mode).
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name Field is only shown in registration mode
          if (!widget.isLogin)
            CustomTextField(
              controller: _nameController,
              label: 'name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          const SizedBox(height: 16),

          //Email input field
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Password input field
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                onPressed:
                    state.status == AuthStatus.loading
                        ? null
                        : () {
                          if (_formKey.currentState!.validate()) {}
                        },
                child:
                    state.status == AuthStatus.loading
                        ? const CircularProgressIndicator()
                        : Text(widget.isLogin ? 'Login' : 'Sign Up'),
              );
            },
          ),
        ],
      ),
    );
  }
}
