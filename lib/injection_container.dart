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

/// Creates a singleton instance of GetIt. This 'getIt' instance is your central service locator; you'll use it to register your dependencies and then retrieve them when needed throughout your application.
final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Dio
  getIt.registerSingleton<Dio>(
    Dio()..options.baseUrl = 'https://api.example.com',
  );

  // Data sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(dioClient: getIt<Dio>()),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(authRemoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // Usecases
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt()));
  getIt.registerSingleton<LogoutUseCase>(LogoutUseCase(getIt()));
  getIt.registerSingleton<RegisterUseCase>(RegisterUseCase(getIt()));
  getIt.registerSingleton<CheckAuthStatusUsecase>(
    CheckAuthStatusUsecase(getIt()),
  );

  // BLoC
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      registerUseCase: getIt(),
      checkAuthStatusUsecase: getIt(),
    ),
  );
}
