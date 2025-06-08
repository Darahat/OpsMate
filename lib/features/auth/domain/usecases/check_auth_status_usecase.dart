import 'package:opsmate/core/usecases/usecase.dart';
import 'package:opsmate/features/auth/domain/entities/user.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';

/// Encapsulates the business logic for checking authentication status
///
/// This use case checks if there's an authenticated user by coordinating with
/// the [AuthRepository]
class CheckAuthStatusUsecase implements UseCase<User?, NoParams> {
  /// Creates a [CheckAuthStatusUseCase] instance
  ///
  /// Requires an [AuthRepository] implementation
  CheckAuthStatusUsecase(this.repository);

  /// The Authentication repository instance
  final AuthRepository repository;

  /// Executes the authentication status check
  ///
  /// Returns a [Future] that completes with:
  /// -[User] if authenticated
  /// - 'null' if no authenticated user
  /// Throws [cacheFailure if there's an error checking status]
  @override
  Future<User?> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}
