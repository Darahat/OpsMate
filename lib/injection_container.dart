import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:opsmate/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:opsmate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:opsmate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:opsmate/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/login_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/logout_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/register_usecase.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/features/auth/domain/usecases/google_signin_usecases.dart';

/// Creates a singleton instance of GetIt
final getIt = GetIt.instance;

/// Configures all dependencies for the application.
/// This function registers all dependencies synchronously to ensure
/// they are available immediately when needed.
Future<void> configureDependencies() async {
  // Reset if any of our dependencies are already registered (hot restart scenario)
  if (getIt.isRegistered<AuthRemoteDataSource>() ||
      getIt.isRegistered<AuthRepository>() ||
      getIt.isRegistered<AuthBloc>()) {
    await getIt.reset();
  }

  // Open Hive box for auth data
  final authBox = await Hive.openBox<String>('auth_box');

  // Register Hive box
  getIt.registerSingleton<Box<String>>(authBox);

  // Register Firebase Auth
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  // Register data sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    FirebaseAuthRemoteDataSource(firebaseAuth: getIt<FirebaseAuth>()),
  );

  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(box: getIt<Box<String>>()),
  );

  // Register repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Register use cases
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<CheckAuthStatusUsecase>(
    CheckAuthStatusUsecase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GoogleSignInUseCase>(
    GoogleSignInUseCase(getIt<AuthRepository>()),
  );

  // Register BLoC
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      checkAuthStatusUsecase: getIt<CheckAuthStatusUsecase>(),
      googleSignInUseCase: getIt<GoogleSignInUseCase>(),
    ),
  );
}
