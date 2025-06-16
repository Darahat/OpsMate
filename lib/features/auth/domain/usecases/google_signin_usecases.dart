import 'package:opsmate/core/usecases/usecase.dart';
import 'package:opsmate/features/auth/domain/entities/user.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';

/// Encapsulates the business GoogleSignIn for user GoogleSignIn
///
/// This use case handles the GoogleSignIn operation by coordinating with
/// the [AuthRepository] to authenticate users.
class GoogleSignInUseCase implements UseCase<User, NoParams> {
  ///Creates a [GoogleSignInUseCase] instance
  ///
  ///Requires an [AuthRepository] implementation
  GoogleSignInUseCase(this.repository);

  ///initialising the Authrepository
  final AuthRepository repository;

  /// Executes the GoogleSignIn operation
  ///
  /// Uses the provided [params] to authenticate the user
  /// Returns a [Future] that completes with a [User] on success
  /// Throws [ServerFailure] if authentication fails
  @override
  Future<User> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
