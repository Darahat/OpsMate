part of 'auth_bloc.dart';

/// Base class for all authentication-related events
///
/// Extend this class to define specific events such as login, logout,
/// registration, and authentication status chcks.
abstract class AuthEvent extends Equatable {
  /// Constructs an [AuthEvent].
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when a user attempts to log in.
///
/// contains the user's [email] and [password] credentials.
class LoginEvent extends AuthEvent {
  /// Constructs a [LoginEvent] with the given [email] and [password].
  const LoginEvent({required this.email, required this.password});

  ///The user's email address.
  final String email;

  /// The user's password
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Event triggered when a user attempts to register a new account.
///
/// Contains the user's [name], [email], and [password].
class RegisterEvent extends AuthEvent {
  /// Constructs a [RegisterEvent] with the given [name], [email], and [password].
  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  /// The user's full name
  final String name;

  /// The user's email address
  final String email;

  /// The user's desired password
  final String password;

  @override
  List<Object> get props => [name, email, password];
}

/// Event triggered when the user logs out of the application.
///
/// used to clear user session and authentication tokens.
class LogoutEvent extends AuthEvent {
  /// Construct a [LogoutEvent].
  const LogoutEvent();
}

/// Event triggered to verify the current authentication status
///
/// Typically used during app initialization to determine
/// if the user is allready logged in or needs to authenticate.
class CheckAuthStatusEvent extends AuthEvent {
  /// Constructs a [CheckAuthStatusEvent]
  const CheckAuthStatusEvent();
}
