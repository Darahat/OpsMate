import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';

/// A StatefulWidget that displays a list of tasks for the user.
class TaskListPage extends StatefulWidget {
  /// Creates a new instance of [TaskListPage].
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Listen for authentication state changes
        if (state.status == AuthStatus.unauthenticated) {
          // Navigate to login page when user is logged out
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tasks'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutEvent());
              },
              tooltip: 'Logout',
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Get the user name from the state
            final userName = state.user?.name ?? 'User';

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 80,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Authentication Successfulll!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome, $userName!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'This is a placeholder for the task list page.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const LogoutEvent());
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // This will be implemented later to add new tasks
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add task functionality coming soon!'),
              ),
            );
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
