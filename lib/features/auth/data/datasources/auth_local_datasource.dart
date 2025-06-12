import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:opsmate/core/config/database_config.dart';
import 'package:opsmate/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getLastLoggedInUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<String> box;

  AuthLocalDataSourceImpl({required this.box});

  static const String USER_CACHED_KEY = 'CACHED_USER';

  @override
  Future<void> cacheUser(UserModel user) async {
    await box.put(USER_CACHED_KEY, json.encode(user.toJson()));
  }

  @override
  Future<UserModel?> getLastLoggedInUser() async {
    final jsonString = box.get(USER_CACHED_KEY);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await box.delete(USER_CACHED_KEY);
  }
}
