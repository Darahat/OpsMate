part of 'auth_bloc.dart';

/// Represents the diffrent states of authentication operations
enum AuthStatus {
  /// Initial state before any authentication attempt
  initial,

  /// When Authentication is in progress
  loading,

  /// When authentication succeeds
  authenticated,

  /// When authentication fails
  unauthenticated,
}

/// The state of authentication in the application
class AuthState extends Equatable {
  /// Creates an instance of [AuthState]
  ///
  /// [status] defaults to [AuthStatus.initial]
  ///[user] represents the currently authenticated user, if any
  ///[message] provides feedback or error information
  const AuthState({this.status = AuthStatus.initial, this.user, this.message});

  ///Current status of authentication
  final AuthStatus status;

  /// Authenticated user details, null if unauthenticated
  final User? user;

  /// Optional message for success or error feedback
  final String? message;

  /// Creates a copy of the state with updated values
  AuthState copyWith({AuthStatus? status, User? user, String? message}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  /// Helper getter to check if user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Helper getter to check if authentication is in progress
  bool get isLoading => status == AuthStatus.loading;

  @override
  List<Object?> get props => [status, user, message];
}
