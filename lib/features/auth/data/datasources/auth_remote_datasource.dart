import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:opsmate/core/errors/exceptions.dart';
import 'package:opsmate/features/auth/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  /// Sign in with Google
  ///
  /// Throws a [ServerException] if the sign in fails.
  /// Returns a [UserModel] if sign in is successful.
  Future<UserModel> signInWithGoogle();
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRemoteDataSource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // for emulators, disable automatic recaptcha verification
      if (kDebugMode) {
        await _firebaseAuth.setSettings(
          appVerificationDisabledForTesting: true,
        );
      }
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException(message: 'Login failed: User is null');
      }

      /// Registration Successfull
      print('User logged in: ${userCredential.user?.email}');

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
      // For emulators, disable automatic recaptcha verification
      if (kDebugMode) {
        await _firebaseAuth.setSettings(
          appVerificationDisabledForTesting: true,
        );
      }
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException(message: 'Registration failed: User is null');
      }
      print('User registered: ${userCredential.user?.uid}');

      // Update the user's display name
      await userCredential.user!.updateDisplayName(name);

      // Reload user to get updated profile
      await userCredential.user!.reload();
      final updatedUser = _firebaseAuth.currentUser;

      return _mapFirebaseUserToUserModel(updatedUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print(
        'Firebase Auth Exception during registration: ${e.code} - ${e.message}',
      );
      // Special handling for reCAPTCHA issues
      if (e.code == 'captcha-check-failed' ||
          e.message?.contains('reCAPTCHA') == true) {
        print(
          'reCAPTCHA verification failed. Checking Firebase project configuration...',
        );
        // Log detailed information to help diagnose the issue
        print('Device info: ${await _getDeviceInfo()}');
        throw ServerException(
          message:
              'Authentication security check failed. Please ensure you have Google Play Services updated on your device.',
        );
      }

      throw ServerException(message: _getErrorMessage(e));
    } catch (e) {
      print('General Exception during registration: ${e.toString()}');
      throw ServerException(message: 'Registration failed: ${e.toString()}');
    }
  }

  // Helper method to get device information for debugging
  Future<String> _getDeviceInfo() async {
    // In a real implementation, you would use a package like device_info_plus
    // to get detailed device information
    return 'Platform: ${kIsWeb ? 'Web' : defaultTargetPlatform.toString()}';
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();

      /// Also sign out from Google if the user signed in with Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      print('Logout error: ${e.toString()}');
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

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw ServerException(message: 'Google sign-in failed: User is null');
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw ServerException(message: 'Google sign-in failed: User is null');
      }

      return _mapFirebaseUserToUserModel(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw ServerException(message: _getErrorMessage(e));
    } catch (e) {
      throw ServerException(message: 'Google sign-in failed: ${e.toString()}');
    }
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
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'captcha-check-failed':
        return 'reCAPTCHA verification failed. Please try again.';
      case 'internal-error':
        if (e.message?.contains('CONFIGURATION_NOT_FOUND') ?? false) {
          return 'Firebase configuration error. Please contact support.';
        }
        return 'An internal error occurred. Please try again later.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
