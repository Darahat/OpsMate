import 'package:flutter/material.dart';
import 'package:opsmate/app/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:opsmate/injection_container.dart';
import 'package:opsmate/app/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/features/auth/domain/usecases/login_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/logout_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/register_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:opsmate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:opsmate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dio/dio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies(); // this handles all service setup
  runApp(const MyApp());
}

/// The root widget of the OpsMate application.
///
/// This widget sets up the application's theme and entry point.
/// It uses [MaterialApp] to initialize the app with both light and dark themes.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OpsMate',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      builder: (context, child) {
        return BlocProvider.value(
          value: getIt<AuthBloc>()..add(const CheckAuthStatusEvent()),
          child: child!,
        );
      },
    );
  }
}
