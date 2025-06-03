import 'package:flutter_test/flutter_test.dart';
import 'package:opsmate/injection_container.dart';
import 'package:opsmate/core/utils/test_service.dart';
import 'package:opsmate/core/utils/logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    configureDependencies();
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
