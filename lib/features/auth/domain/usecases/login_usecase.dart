import 'package:opsmate/core/usecases/usecase.dart';
import 'package:opsmate/features/auth/domain/entities/user.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';

/// Encapsulates the business login for user login
///
/// This use case handles the login operation by coordinating with
/// the [AuthRepository] to authenticate users.
class LoginUseCase implements UseCase<User, LoginParams> {
  ///Creates a [LoginUseCase] instance
  ///
  ///Requires an [AuthRepository] implementation
  LoginUseCase(this.repository);

  ///initialising the Authrepository
  final AuthRepository repository;

  /// Executes the login operation
  ///
  /// Uses the provided [params] to authenticate the user
  /// Returns a [Future] that completes with a [User] on success
  /// Throws [ServerFailure] if authentication fails
  @override
  Future<User> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

/// Parameters required for the login operation
class LoginParams {
  /// creates a [LoginParams] instance
  ///
  /// Requires both [email] and [password] for authentication
  LoginParams({required this.email, required this.password});

  /// User's email address
  final String email;

  /// User's Password
  final String password;
}
