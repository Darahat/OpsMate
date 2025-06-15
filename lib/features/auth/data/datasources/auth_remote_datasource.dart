import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:opsmate/core/errors/exceptions.dart';
import 'package:opsmate/features/auth/data/models/user_model.dart';

/// An abstract class defining the contract for authentication remote data sources.
///
/// this interface specifies the methods that any concrete implementation
/// of and authentication remote data source must provide.
abstract class AuthRemoteDataSource {
  /// Authenticates a user with the provided credentials
  /// Throws a [ServerException] if the authentication fails.
  /// Returns a [UserModel] if authentication is successful.
  Future<UserModel> login(String email, String password);

  /// Registers a  user with the provided information
  ///
  /// Throws a [ServerException] if the registration fails.
  /// Returns a [UserModel] representing the newly created user.
  Future<UserModel> register(String name, String email, String password);

  /// Logs out the current user
  ///
  /// Throws a [ServerException] if the logout fails.
  Future<void> logout();

  /// Checks if there's an authenticated user
  ///
  /// Throws a [ServerException] if there's an error checking status.
  /// Returns a [UserModel] if authenticated, null otherwise.
  Future<UserModel?> checkAuthStatus();
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthRemoteDataSource({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException(message: 'Login failed: User is null');
      }

      return _mapFirebaseUserToUserModel(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(message: _getErrorMessage(e));
    } catch (e) {
      throw ServerException(message: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException(message: 'Registration failed: User is null');
      }

      // Update the user's display name
      await userCredential.user!.updateDisplayName(name);

      // Reload user to get updated profile
      await userCredential.user!.reload();
      final updatedUser = _firebaseAuth.currentUser;

      return _mapFirebaseUserToUserModel(updatedUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(message: _getErrorMessage(e));
    } catch (e) {
      throw ServerException(message: 'Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(message: 'Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> checkAuthStatus() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        return _mapFirebaseUserToUserModel(firebaseUser);
      }
      return null;
    } catch (e) {
      throw ServerException(
        message: 'Failed to check auth status: ${e.toString()}',
      );
    }
  }

  // Helper method to map Firebase User to your UserModel
  UserModel _mapFirebaseUserToUserModel(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      // Add any other fields you need
    );
  }

  // Helper method to get readable error messages
  String _getErrorMessage(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-email':
        return 'The email address is invalid.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
