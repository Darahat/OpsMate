import 'package:opsmate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:opsmate/features/auth/domain/entities/user.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';
import '';

/// A concrete implementation of [AuthRepository] that uses a remote data source.
///
/// This class handles the actual authentication operations by delegating to
/// the [AuthRemoteDataSource] for network communication.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates a new [AuthRepositoryImpl] instance.
  ///
  /// Requires an [authRemoteDataSource] to perform network operations.
  AuthRepositoryImpl({required this.authRemoteDataSource});

  /// The remote data source used for authentication operations.
  final AuthRemoteDataSource authRemoteDataSource;

  /// Authenticates a user with the provided credentials
  ///
  /// Delegates to [authRemoteDataSource.login] for network communication.
  /// Returns a [User] on successful authentication.
  /// Throws [ServerFailure] if authentication fails.
  @override
  Future<User> login(String email, String password) async {
    return await authRemoteDataSource.login(email, password);
  }

  /// Registers a new user with the provided information
  ///
  /// Delegates to [authRemoteDataSource.register] for network communication.
  /// Returns a [User] on successful registration.
  /// Throws [ServerFailure] if registration fails.
  @override
  Future<User> register(String name, String email, String password) async {
    return await authRemoteDataSource.register(name, email, password);
  }

  /// Logs out the current user
  ///
  /// Delegates to [authRemoteDataSource.logout] for network communication.
  /// Returns [void] on successful logout.
  /// Throws [ServerFailure] if logout fails.
  @override
  Future<void> logout() async {
    return await authRemoteDataSource.logout();
  }

  /// Checks if there's an authenticated user
  ///
  /// Delegates to [authRemoteDataSource.checkAuthStatus] for network communication.
  /// Returns a [User] if authenticated, null otherwise.
  /// Throws [ServerFailure] if there's an error checking status.
  @override
  Future<User?> checkAuthStatus() async {
    return await authRemoteDataSource.checkAuthStatus();
  }
}
