import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:opsmate/features/auth/data/models/user_model.dart';

/// Defines the contract for the local data source handling user authentication data.

abstract class AuthLocalDataSource {
  /// Caches the provided user data locally.
  Future<void> cacheUser(UserModel user);

  /// Retrieves the last logged-in user's data from local cache.
  Future<UserModel?> getLastLoggedInUser();

  /// Clears the cached user data.
  Future<void> clearUser();
}

/// A concrete implementation of [AuthLocalDataSource] using Hive for local storage.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// Creates an [AuthLocalDataSourceImpl] instance.
  ///
  /// Requires a [Box<String>] instance for local storage.
  AuthLocalDataSourceImpl({required this.box});

  /// The Hive box used for local storage.
  final Box<String> box;

  /// The key used to store the last logged-in user's data in the Hive box.
  // ignore: constant_identifier_names
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
