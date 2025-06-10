import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opsmate/features/auth/presentation/pages/login_page.dart';
import 'package:opsmate/features/tasks/presentation/pages/task_list_page.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';

/// Flutter app page routing system
final router = GoRouter(
  routes: [
    GoRoute(path: '/', redirect: (_, __) => '/login'),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/tasks', builder: (context, state) => const TaskListPage()),
  ],
);
