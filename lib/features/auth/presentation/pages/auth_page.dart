import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/auth_providers.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Auth Screen")),
      body: Center(
        child:
            user == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          () => controller.signIn("demo@email.com", "123456"),
                      child: const Text("Sign In"),
                    ),
                    ElevatedButton(
                      onPressed:
                          () => controller.signUp("demo@email.com", "123456"),
                      child: const Text("Sign Up"),
                    ),
                    ElevatedButton(
                      onPressed: () => controller.signInWithGoogle(),
                      child: const Text("Google Sign In"),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome ${user.email}"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.signOut(),
                      child: const Text("Sign Out"),
                    ),
                  ],
                ),
      ),
    );
  }
}
