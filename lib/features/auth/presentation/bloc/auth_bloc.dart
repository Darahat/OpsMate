import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:opsmate/core/usecases/usecase.dart';

import 'package:opsmate/features/auth/domain/entities/user.dart';
import 'package:opsmate/features/auth/domain/usecases/login_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/logout_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/register_usecase.dart';
import 'package:opsmate/features/auth/domain/usecases/check_auth_status_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Business Logic Component for authentication features
///
/// Handles:
/// - User Login
/// - User Registration
/// - Logout
/// - Authentication status checks

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Creates an [AuthBloc] instance with required use cases
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUsecase,
    required this.registerUseCase,
  }) : super(const AuthState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  ///Handles login event
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await loginUseCase.call(
        LoginParams(email: event.email, password: event.password),
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          message: 'Login successful',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.authenticated, message: e.toString()),
      );
    }
  }

  ///Handles registration event
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await registerUseCase.call(
        RegisterParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          message: 'Registration successful',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.authenticated, message: e.toString()),
      );
    }
  }

  /// Handles logout event
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await logoutUseCase.call(const NoParams());
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          message: 'Logged out successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          message: 'Logout Failed: ${e.toString()}',
        ),
      );
    }
  }

  /// Checks current authentication status
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await checkAuthStatusUsecase.call(const NoParams());
      emit(
        state.copyWith(
          status:
              user != null
                  ? AuthStatus.authenticated
                  : AuthStatus.unauthenticated,
          user: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          message: 'Failed to check auth status',
        ),
      );
    }
  }

  /// Use case responsible for handling user login
  final LoginUseCase loginUseCase;

  /// Use case responsile for handling user logout
  final LogoutUseCase logoutUseCase;

  /// Use case responsile for handling user registration

  final RegisterUseCase registerUseCase;

  /// Use case responsile for handling user Authentication check
  final CheckAuthStatusUsecase checkAuthStatusUsecase;
}
