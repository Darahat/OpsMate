import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

enum LogLevel { info, warning, error }

class AppLogger {
  static late Logger _logger;

  ///initialize the logger with appropriate configuration
  static void init() {
    _logger = Logger(
      printer:
          kDebugMode
              ? PrettyPrinter(
                methodCount: 2,
                errorMethodCount: 8,
                lineLength: 120,
                colors: true,
                printEmojis: true,
                dateTimeFormat: DateTimeFormat.dateAndTime,
              )
              : SimplePrinter(), // Productionl: simple, less verbose
      level: kDebugMode ? Level.debug : Level.info,
    );
  }

  /// Log debug message(only in debug mode)
  static void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
      developer.log(message, name: 'OpsMate');
    }
  }

  /// Log info messages
  static void info(String message) {
    _logger.i(message);
    developer.log(message, name: 'OpsMate', level: 800);
  }

  /// Log warning messages
  static void warning(String message) {
    _logger.w(message);
    developer.log(message, name: 'OpsMate', level: 900);
  }

  /// lOG ERROR messages with option error object and stack trace
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    developer.log(
      message,
      name: 'OpsMate',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

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
