import 'package:opsmate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:opsmate/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:opsmate/features/auth/domain/entities/user.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:opsmate/core/errors/exceptions.dart';
import 'package:opsmate/core/errors/failures.dart';

// Ensure ServerException is defined in exceptions.dart or import the correct file where ServerException is defined.

/// A concrete implementation of [AuthRepository] that uses a remote data source.
///
/// This class handles the actual authentication operations by delegating to
/// the [AuthRemoteDataSource] for network communication.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates a new [AuthRepositoryImpl] instance.
  ///
  /// Requires an [authRemoteDataSource] to perform network operations.
  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  /// The remote data source used for authentication operations.
  final AuthRemoteDataSource authRemoteDataSource;

  /// The Local data source use for caching user data
  final AuthLocalDataSource authLocalDataSource;

  /// Authenticates a user with the provided credentials
  ///
  /// Delegates to [authRemoteDataSource.login] for network communication.
  /// Returns a [User] on successful authentication.
  /// Throws [ServerFailure] if authentication fails.
  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await authRemoteDataSource.login(email, password);
      await authLocalDataSource.cacheUser(userModel);
      return userModel;
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  /// Registers a new user with the provided information
  ///
  /// Delegates to [authRemoteDataSource.register] for network communication.
  /// Returns a [User] on successful registration.
  /// Throws [ServerFailure] if registration fails.
  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final userModel = await authRemoteDataSource.register(
        name,
        email,
        password,
      );
      await authLocalDataSource.cacheUser(userModel);
      return userModel;
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  /// Logs out the current user
  ///
  /// Delegates to [authRemoteDataSource.logout] for network communication.
  /// Returns [void] on successful logout.
  /// Throws [ServerFailure] if logout fails.
  @override
  Future<void> logout() async {
    try {
      await authRemoteDataSource.logout();
      await authLocalDataSource.clearUser();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    }
  }

  /// Checks if there's an authenticated user
  ///
  /// Delegates to [authRemoteDataSource.checkAuthStatus] for network communication.
  /// Returns a [User] if authenticated, null otherwise.
  /// Throws [ServerFailure] if there's an error checking status.
  @override
  Future<User?> checkAuthStatus() async {
    try {
      ///first try to get from remote
      final remoteUser = await authRemoteDataSource.checkAuthStatus();
      if (remoteUser != null) {
        await authLocalDataSource.cacheUser(remoteUser);
        return remoteUser;
      }
    } on ServerException {
      return await authLocalDataSource.getLastLoggedInUser();
    }
  }
}
