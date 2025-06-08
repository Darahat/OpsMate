import 'package:opsmate/core/usecases/usecase.dart';
import 'package:opsmate/features/auth/domain/repositories/auth_repository.dart';

///Encapsulates the business logic for user logout
///
/// This use case handles the logout operation by coordinating with
/// the [AuthRepository] to clear user authentication state.
class LogoutUseCase implements UseCase<void, NoParams> {
  /// Creates a [LogoutUseCase] instance
  ///
  /// Requires an [AuthRepository] implementation
  LogoutUseCase(this.repository);

  /// The Authentication repository instance
  final AuthRepository repository;

  /// Executes the logout operation
  ///
  /// Returns a [Future] that completes when logout is successful
  /// Throws [ServerFailure] if logout fails
  @override
  Future<void> call(NoParams params) async {
    return await repository.logout();
  }
}
