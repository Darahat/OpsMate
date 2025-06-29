import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth/domain/user_model.dart';
import '../../features/tasks/domain/task_model.dart';

/// Hive service functionality isolated from main
class HiveService {
  /// AuthBox name defined
  static const String authBoxName = 'authbox';
  static Box<UserModel>? _authBox;

  /// TaskBox hive name defined
  static const String taskBoxName = 'taskbox';
  static Box<TaskModel>? _taskBox;

  /// main hive service initialization function
  static Future<void> init() async {
    await Hive.initFlutter();

    /// User Authentication registration and check box is open or not
    Hive.registerAdapter(UserModelAdapter());

    if (!Hive.isBoxOpen(authBoxName)) {
      _authBox = await Hive.openBox<UserModel>(authBoxName);
    } else {
      _authBox = Hive.box<UserModel>(authBoxName);
    }

    /// Task registration and check box is open or not

    Hive.registerAdapter(TaskModelAdapter());

    if (!Hive.isBoxOpen(taskBoxName)) {
      _taskBox = await Hive.openBox<TaskModel>(taskBoxName);
    } else {
      _taskBox = Hive.box<TaskModel>(taskBoxName);
    }
  }

  /// return a check is authBox is open or not

  static Box<UserModel> get authBox {
    if (_authBox == null) {
      throw Exception('HiveService not initialized. Call init() first');
    }
    return _authBox!;
  }

  /// return a check is taskbox is open or not
  static Box<TaskModel> get taskBox {
    if (_taskBox == null) {
      throw Exception('HiveService not initialized. Call init() first');
    }
    return _taskBox!;
  }

  /// close function for close all hive boxes
  static Future<void> close() async {
    await _authBox?.close();
    await _taskBox?.close();
  }
}
