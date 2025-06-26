import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/pages/auth_page.dart';
import 'package:opsmate/splashscreen.dart';
// import 'package:opsmate/features/auth/presentation/pages/signup_page.dart';
// import 'package:opsmate/features/auth/presentation/widgets/auth_checker.dart';
// import 'package:opsmate/features/tasks/presentation/pages/task_list_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreenWidget()),
    GoRoute(path: '/login', builder: (context, state) => const AuthScreen()),
    // GoRoute(path: '/register', builder: (context, state) => const SignupPage()),
    // GoRoute(
    //   path: '/tasks',
    //   builder: (context, state) => const AuthChecker(child: TaskListPage()),
    // ),
  ],
);
