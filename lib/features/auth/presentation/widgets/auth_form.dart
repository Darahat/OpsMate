import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/core/widgets/custom_button.dart';
import 'package:opsmate/core/widgets/custom_text_fields.dart';
import 'package:opsmate/features/auth/presentation/widgets/google_signin_button.dart';

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 100,
              child: Image(image: AssetImage('assets/icon/icon.png')),
            ),
            const SizedBox(height: 24),
            Text(
              widget.isLogin ? 'Welcome back!' : 'Create Account',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Name Field is only shown in registration mode
            if (!widget.isLogin) ...[
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
            ],

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

            if (widget.isLogin) ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: const Text('Forget Password?'),
                ),
              ),
            ],

            const SizedBox(height: 24),

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final user = state.user;
                if (kDebugMode) {
                  print('Auth Status : ${state.status}');
                  print('User Present: ${user != null}');
                }
                if (user != null && state.status == AuthStatus.authenticated) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go('/tasks');
                  });
                  if (kDebugMode) {
                    print('Authenticated User: ${user.email}');
                  }
                } else if (user != null ||
                    state.status == AuthStatus.unauthenticated) {
                  if (kDebugMode) {
                    print('User ID: Not Found');
                  }
                }
                return Column(
                  children: [
                    CustomButton(
                      onPressed:
                          state.status == AuthStatus.loading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  if (widget.isLogin) {
                                    context.read<AuthBloc>().add(
                                      LoginEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  } else {
                                    context.read<AuthBloc>().add(
                                      RegisterEvent(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                }
                              },
                      child:
                          state.status == AuthStatus.loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(widget.isLogin ? 'Login' : 'Sign Up'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            /// Google Sign-in button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return state.status == AuthStatus.loading
                    ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeCap: StrokeCap.round,
                    )
                    : const GoogleSignInButton();
              },
            ),

            const SizedBox(height: 16),

            // Navigation button with GoRouter navigation
            TextButton(
              onPressed: () {
                if (widget.isLogin) {
                  // Navigate to register page using GoRouter
                  context.go('/register');
                } else {
                  // Navigate to login page using GoRouter
                  context.go('/login');
                }
              },
              child: Text(
                widget.isLogin
                    ? 'Create an account'
                    : 'Already have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
