import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:opsmate/core/utils/network_info.dart';
import 'package:opsmate/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:opsmate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:opsmate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:opsmate/features/auth/domain/usecases/login_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/logout_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/register_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/injection_container.dart';

/// Dependency injection module for the authentication feature.
///
/// This module registers all required classes and dependencies
/// for the authentication layer, including data sources, repositories,
/// use cases, and presentation logic (BLoC). The `@module` annotation
/// tells Injectable to use this class to provide dependencies.
@module
abstract class AuthInjectionModule {
  // ----------------------
  // Data Layer
  // ----------------------

  /// Registers [FirebaseAuthRemoteDataSource] as a singleton implementation
  /// of [AuthRemoteDataSource] using Firebase Authentication.
  @singleton
  AuthRemoteDataSource get authRemoteDataSource =>
      FirebaseAuthRemoteDataSource(firebaseAuth: getIt<FirebaseAuth>());

  /// Registers [AuthLocalDataSourceImpl] as a singleton implementation
  /// of [AuthLocalDataSource] using Hive for local storage.
  @singleton
  AuthLocalDataSource get authLocalDataSource =>
      AuthLocalDataSourceImpl(box: getIt());

  /// Registers [AuthRepositoryImpl] as a singleton implementation
  /// of [AuthRepository], which uses the [AuthRemoteDataSource].
  @singleton
  AuthRepository get authRepository => AuthRepositoryImpl(
    authRemoteDataSource: getIt<AuthRemoteDataSource>(),
    authLocalDataSource: getIt<AuthLocalDataSource>(),
  );

  // ----------------------
  // Domain Layer (Use Cases)
  // ----------------------

  /// Registers [LoginUseCase] as a singleton, used to handle login logic.
  @singleton
  LoginUseCase get loginUseCase => LoginUseCase(getIt<AuthRepository>());

  /// Registers [LogoutUseCase] as a singleton, used to handle logout logic.
  @singleton
  LogoutUseCase get logoutUseCase => LogoutUseCase(getIt<AuthRepository>());

  /// Registers [RegisterUseCase] as a singleton, used to handle user registration logic.
  @singleton
  RegisterUseCase get registerUseCase =>
      RegisterUseCase(getIt<AuthRepository>());

  /// Registers [CheckAuthStatusUsecase] as a singleton, used to verify authentication state.
  @singleton
  CheckAuthStatusUsecase get checkAuthStatusUsecase =>
      CheckAuthStatusUsecase(getIt<AuthRepository>());

  // ----------------------
  // Presentation Layer (BLoC)
  // ----------------------

  /// Registers [AuthBloc] as a singleton, which coordinates all authentication use cases
  /// and handles authentication-related events and state changes.
  @singleton
  AuthBloc get authBloc => AuthBloc(
    loginUseCase: getIt<LoginUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
    registerUseCase: getIt<RegisterUseCase>(),
    checkAuthStatusUsecase: getIt<CheckAuthStatusUsecase>(),
    // networkInfo: getIt<NetworkInfo>(),
  );
}
