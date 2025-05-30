import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error }

class AppLogger {
  static void log(String message, {LogLevel level = LogLevel.info}) {
    if (kDebugMode) {
      final emoji =
          {
            LogLevel.info: 'ℹ️',
            LogLevel.warning: '⚠️',
            LogLevel.error: '❌',
          }[level];
      print('$emoji $message');
    }
  }
}
