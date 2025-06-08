/// Abstract class defining the authentication repository contract.
/// This interface should be implemented by concrete
/// that handle authentication operations
library;

import 'package:opsmate/features/auth/domain/entities/user.dart';

/// Authenticates a user with the provided credentials
abstract class AuthRepository {
  /// Authenticates a user with the provided credentials
  /// Throws [ServerFailure] if authentication fails
  /// Returns [User] on successful authentication
  Future<User> login(String email, String password);

  /// Registers a new user with the provided information
  ///
  /// Throws [ServerFailure] if registration fails
  /// Returns [User] on successful registration
  Future<User> register(String name, String email, String password);

  /// Logout user
  ///
  /// Throws [ServerFailure] if registration fails
  /// Returns [User] on successful registration
  Future<void> logout();

  /// Checks if there's an authenticated user
  Future<User?> checkAuthStatus();
}
