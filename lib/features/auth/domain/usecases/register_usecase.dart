import 'package:opsmate/core/usecases/usecase.dart';
import 'package:opsmate/features/auth/domain/entities/user.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';

/// Encapsulates the business logic for user registration
///
/// This use case handles the registration operation by coordinating with
/// the [AuthRepository] to create new user accounts.
class RegisterUseCase implements UseCase<User, RegisterParams> {
  /// Creates a [RegisterUseCase] instance
  ///
  /// Requires an [AuthRepository] implementation
  RegisterUseCase(this.repository);

  /// The authentication repository instance
  final AuthRepository repository;

  /// Executes the registration operation
  ///
  /// Uses the provided [params] to register a new user
  /// Returns a [Future] that completes with a [User] on success
  /// Throws [ServerFailure] if registration fails
  @override
  Future<User> call(RegisterParams params) async {
    return await repository.register(
      params.name,
      params.email,
      params.password,
    );
  }
}

/// Parameters required for the registration operation
class RegisterParams {
  /// Creates a [RegisterParams] instance
  ///
  /// Require [name], [email], and [password] for registration
  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// User's password
  final String password;
}
