import 'package:dio/dio.dart';
import 'package:opsmate/core/errors/exceptions.dart';
import 'package:opsmate/core/network/dio_client.dart';
import 'package:opsmate/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
}
