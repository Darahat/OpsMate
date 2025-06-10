import 'package:dio/dio.dart';
import 'package:opsmate/core/errors/exceptions.dart';
// import 'package:dio/dio.dart';
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

/// A concrete implementation of [AuthRemoteDataSource] that uses Dio for HTTP requests.
///
/// This class handles the actual network communication for authentication-related
/// operations like login and registration
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates a new [AuthRemoteDataSourceImpl] instance.
  ///
  /// Requires a[dioClient] to be used for network requests.
  AuthRemoteDataSourceImpl({required this.dioClient});

  /// The Dio client used to make HTTP requests.
  final Dio dioClient;
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await dioClient.post(
        '/auth/register',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.post('/auth/logout');
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<UserModel?> checkAuthStatus() async {
    try {
      final response = await dioClient.get('/auth/status');
      if (response.data['authenticated']) {
        return UserModel.fromJson(response.data['user']);
      }
      return null;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    }
  }
}
