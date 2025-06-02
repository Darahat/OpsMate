import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/tasks/presentation/pages/task_list_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/tasks', builder: (context, state) => const TaskListPage()),
  ],
);
