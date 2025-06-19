import 'package:flutter_test/flutter_test.dart';
import 'package:opsmate/injection_container.dart';
import 'package:opsmate/core/utils/test_service.dart';
import 'package:opsmate/core/utils/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';
import 'package:hive/hive.dart'; // Not hive_flutter
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';

// Mock dependencies that might cause issues in tests
class MockFirebaseApp extends Mock {}

class MockFirebaseAuth extends Mock {}

class MockGoogleSignIn extends Mock {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    /// Required for Firebase Auth
    await Firebase.initializeApp(); // ✅ Required for FirebaseAuth.instance

    ///  Initialize Hive for testing

    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(path.join(tempDir.path, 'hive_testing'));

    // Initialize mocks for Firebase and other external dependencies
    // that might be causing issues in the test environment
    getIt.registerSingleton<MockFirebaseApp>(MockFirebaseApp());
    getIt.registerSingleton<MockFirebaseAuth>(MockFirebaseAuth());
    getIt.registerSingleton<MockGoogleSignIn>(MockGoogleSignIn());

    /// 🛠️ Important: Initialize before use
    AppLogger.init();

    // Use test mode for dependency injection
    await configureDependencies();
  });

  test('TestService should be registered', () {
    AppLogger.info('Test is running');
    final testService = getIt<TestService>();
    AppLogger.info('Retrieved service: $testService');

    final message = testService.getTestMessage();
    AppLogger.info('Service returned: $message');
    expect(testService, isA<TestServiceImpl>());
  });

  test('TestService should return correct message', () {
    final testService = getIt<TestService>();
    expect(testService.getTestMessage(), 'Dependency injection is working!');
  });
}
