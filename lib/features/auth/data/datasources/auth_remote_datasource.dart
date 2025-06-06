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
}
