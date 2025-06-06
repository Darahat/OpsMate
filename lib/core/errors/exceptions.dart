library;

/// Base class for all custom exceptions in the application
///
/// All app-specific exceptions should extend this class

abstract class AppException implements Exception {
  /// Creates an [AppException]
  ///
  /// Requires [message] to describe the error
  /// [innerException] is option
  const AppException(this.message, [this.innerException]);
  @override
  String toString() =>
      innerException != null
          ? '$message (Inner exception: $innerException)'
          : message;

  /// A message describing the error
  final String message;

  /// The underlying exception that caused this error
  final Exception? innerException;
}

/// Thrown when there's an error communication with the server
class ServerException extends AppException {
  /// Creates a [Serexception]
  ///
  /// [message] describes the server error
  /// [statusCode] is the HTTP status code (if available)
  /// [innerException] is the original exception (if available)
  const ServerException({
    required String message,
    this.statusCode,
    Exception? innerException,
  }) : super(message, innerException);

  /// HTTP status code from the server (if avilable)
  final int? statusCode;
  @override
  String toString() =>
      statusCode != null
          ? 'ServerException: $message(Status code: $statusCode)'
          : 'ServerException: $message';
}

/// thrown when there's an error with local data storage
class CacheException extends AppException {
  /// Creates a [CacheException]
  ///
  /// [message] describes the cache error
  /// [innerException] is the original Exception (if available)
  const CacheException(super.message, [super.innerException]);
}

/// Thrown when there's a network connectivity issue
class NetworkException extends AppException {
  /// Creates a [NetworkException]
  ///
  /// [message] describes the network error
  /// [innerException] is the original exception (if available)
  const NetworkException(super.message, [super.innerException]);
}

/// Thrown when there's an error in input validation
class ValidationException extends AppException {
  /// Creates a [ValidException]
  ///
  /// [message] describes the network error
  /// [innerException] is the original exception(if available
  const ValidationException(super.message, [super.innerException]);
}

/// Thrown when a requested resource is not found

class NotFoundException extends AppException {
  /// Creates a [NotFoundException ]
  ///
  /// [message] describes the network error
  /// [innerException] is the original exception(if available
  const NotFoundException(this.resourceType, this.identifier)
    : super('$resourceType with identifier $identifier not found');

  /// The type of resource that wasnt found
  final String resourceType;

  /// The identifier that wasnt found
  final String identifier;
}

/// Thrown when authentication fails

class AuthenticationException extends AppException {
  /// Creates a [AuthenticationException ]
  ///
  /// [message] describes the network error
  const AuthenticationException(super.message);
}

/// Thrown when a user doesnt have permission to perform an action
class PermissionException extends AppException {
  /// The permission that was denied
  const PermissionException(this.permission, String message) : super(message);

  /// The permission that was denied

  final String permission;
  @override
  String toString() => 'PermissionException for $permission: $message';
}
