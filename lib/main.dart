import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:opsmate/app/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:opsmate/injection_container.dart';
import 'package:opsmate/app/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive
  await Hive.initFlutter();

  // Configure dependencies using the injection container
  await configureDependencies();
  
  // Check auth status immediately
  getIt<AuthBloc>().add(const CheckAuthStatusEvent());

  runApp(const MyApp());
}

/// The root widget of the OpsMate application.
class MyApp extends StatelessWidget {
  /// Creates an instance of [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: MaterialApp.router(
        title: 'OpsMate',
        theme: lightTheme,
        darkTheme: darkTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
