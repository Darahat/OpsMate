import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth/domain/user_model.dart';

class HiveService {
  static const String authBoxName = 'authbox';
  static Box<UserModel>? _authBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());

    if (!Hive.isBoxOpen(authBoxName)) {
      _authBox = await Hive.openBox<UserModel>(authBoxName);
    } else {
      _authBox = Hive.box<UserModel>(authBoxName);
    }
  }

  static Box<UserModel> get authBox {
    if (_authBox == null) {
      throw Exception('HiveService not initialized. Call init() first');
    }
    return _authBox!;
  }

  static Future<void> close() async {
    await _authBox?.close();
  }
}
