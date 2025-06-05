/// A domain entity representing a user in the system.
class User {
  /// Creates a [User] instance.
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.token,
  });

  /// The unique identifier of the user.
  final String id;

  /// The email address of the user.
  final String email;

  /// The full name of the user.
  final String name;

  /// An optional authentication token associated with the user.
  final String? token;
}
