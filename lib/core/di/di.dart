import 'package:dio/dio.dart';
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

@module
abstract class AuthInjectionModule {
  // Data Layer
  @singleton
  AuthRemoteDataSource get authRemoteDataSource =>
      AuthRemoteDataSourceImpl(dioClient: getIt());

  @singleton
  AuthRepository get authRepository =>
      AuthRepositoryImpl(authRemoteDataSource: getIt());

  // Domain Layer
  @singleton
  LoginUseCase get loginUseCase => LoginUseCase(getIt());

  @singleton
  LogoutUseCase get logoutUseCase => LogoutUseCase(getIt());

  @singleton
  RegisterUseCase get registerUseCase => RegisterUseCase(getIt());

  @singleton
  CheckAuthStatusUsecase get checkAuthStatusUsecase =>
      CheckAuthStatusUsecase(getIt());

  // Presentation Layer
  @singleton
  AuthBloc get authBloc => AuthBloc(
    loginUseCase: getIt(),
    logoutUseCase: getIt(),
    registerUseCase: getIt(),
    checkAuthStatusUsecase: getIt(),
  );
}
