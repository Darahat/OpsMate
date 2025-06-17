import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
import 'package:opsmate/core/utils/test_service.dart';

/// Creates a singleton instance of GetIt
final getIt = GetIt.instance;

/// Configures all dependencies for the application.
/// This function registers all dependencies synchronously to ensure
/// they are available immediately when needed.
///
/// The [testing] parameter allows for different configuration in test environments.
Future<void> configureDependencies({bool testing = false}) async {
  // Reset if any of our dependencies are already registered (hot restart scenario)
  if (getIt.isRegistered<AuthRemoteDataSource>() ||
      getIt.isRegistered<AuthRepository>() ||
      getIt.isRegistered<AuthBloc>()) {
    await getIt.reset();
  }

  // Open Hive box for auth data - use in-memory box for testing
  final Box<String> authBox;
  if (testing) {
    authBox = await Hive.openBox<String>(
      'test_auth_box',
      path: './', // Use current directory for tests
    );
  } else {
    authBox = await Hive.openBox<String>('auth_box');
  }

  // Register Hive box
  getIt.registerSingleton<Box<String>>(authBox);

  // Register Firebase Auth - handle differently in tests
  if (!testing || !getIt.isRegistered<FirebaseAuth>()) {
    getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  }

  // Register GoogleSignIn - handle differently in tests
  if (!testing || !getIt.isRegistered<GoogleSignIn>()) {
    getIt.registerSingleton<GoogleSignIn>(GoogleSignIn());
  }

  // Register data sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    FirebaseAuthRemoteDataSource(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<GoogleSignIn>(),
    ),
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

  // Register TestService for tests
  if (testing) {
    getIt.registerSingleton<TestService>(TestServiceImpl());
  }
}
