import 'package:opsmate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opsmate/features/auth/domain/usecases/login_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/logout_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/register_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:opsmate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:opsmate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

/// Creates a singleton instance of GetIt
final getIt = GetIt.instance;

/// Configures all dependencies for the application.
/// This function registers all dependencies synchronously to ensure
/// they are available immediately when needed.
Future<void> configureDependencies() async {
  // Reset if any of our dependencies are already registered (hot restart scenario)
  if (getIt.isRegistered<Dio>() ||
      getIt.isRegistered<AuthRemoteDataSource>() ||
      getIt.isRegistered<AuthRepository>() ||
      getIt.isRegistered<AuthBloc>()) {
    await getIt.reset();
  }

  // Register Dio
  getIt.registerSingleton<Dio>(
    Dio()..options.baseUrl = 'https://api.example.com',
  );

  // Register data sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(dioClient: getIt<Dio>()),
  );

  // Register repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(authRemoteDataSource: getIt<AuthRemoteDataSource>()),
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

  // Register BLoC
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      checkAuthStatusUsecase: getIt<CheckAuthStatusUsecase>(),
    ),
  );
}
