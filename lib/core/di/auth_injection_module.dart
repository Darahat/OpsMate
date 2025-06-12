import 'package:injectable/injectable.dart';
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

  /// Registers [AuthRemoteDataSourceImpl] as a singleton implementation
  /// of [AuthRemoteDataSource] using the provided Dio HTTP client.
  @singleton
  AuthRemoteDataSource get authRemoteDataSource =>
      AuthRemoteDataSourceImpl(dioClient: getIt());

  /// Registers [AuthRepositoryImpl] as a singleton implementation
  /// of [AuthRepository], which uses the [AuthRemoteDataSource].
  @singleton
  AuthRepository get authRepository => AuthRepositoryImpl(
    authRemoteDataSource: getIt(),
    authLocalDataSource: getIt(),
  );

  // ----------------------
  // Domain Layer (Use Cases)
  // ----------------------

  /// Registers [LoginUseCase] as a singleton, used to handle login logic.
  @singleton
  LoginUseCase get loginUseCase => LoginUseCase(getIt());

  /// Registers [LogoutUseCase] as a singleton, used to handle logout logic.
  @singleton
  LogoutUseCase get logoutUseCase => LogoutUseCase(getIt());

  /// Registers [RegisterUseCase] as a singleton, used to handle user registration logic.
  @singleton
  RegisterUseCase get registerUseCase => RegisterUseCase(getIt());

  /// Registers [CheckAuthStatusUsecase] as a singleton, used to verify authentication state.
  @singleton
  CheckAuthStatusUsecase get checkAuthStatusUsecase =>
      CheckAuthStatusUsecase(getIt());

  // ----------------------
  // Presentation Layer (BLoC)
  // ----------------------

  /// Registers [AuthBloc] as a singleton, which coordinates all authentication use cases
  /// and handles authentication-related events and state changes.
  @singleton
  AuthBloc get authBloc => AuthBloc(
    loginUseCase: getIt(),
    logoutUseCase: getIt(),
    registerUseCase: getIt(),
    checkAuthStatusUsecase: getIt(),
  );
}
